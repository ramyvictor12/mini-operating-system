
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
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
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 00 3b 80 00       	push   $0x803b00
  800095:	6a 14                	push   $0x14
  800097:	68 1c 3b 80 00       	push   $0x803b1c
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 0e 1c 00 00       	call   801cb9 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 fd 23 00 00       	call   8024b5 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 4f 20 00 00       	call   80211d <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 22 20 00 00       	call   80211d <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 ba 20 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 a2 1b 00 00       	call   801cb9 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 30 3b 80 00       	push   $0x803b30
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 1c 3b 80 00       	push   $0x803b1c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 80 20 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 98 3b 80 00       	push   $0x803b98
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 1c 3b 80 00       	push   $0x803b1c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 b3 1f 00 00       	call   80211d <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 4b 20 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 33 1b 00 00       	call   801cb9 <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 30 3b 80 00       	push   $0x803b30
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 1c 3b 80 00       	push   $0x803b1c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 05 20 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 98 3b 80 00       	push   $0x803b98
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 1c 3b 80 00       	push   $0x803b1c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 38 1f 00 00       	call   80211d <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 d0 1f 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 bb 1a 00 00       	call   801cb9 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 30 3b 80 00       	push   $0x803b30
  800220:	6a 3d                	push   $0x3d
  800222:	68 1c 3b 80 00       	push   $0x803b1c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 8c 1f 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 98 3b 80 00       	push   $0x803b98
  80023e:	6a 3e                	push   $0x3e
  800240:	68 1c 3b 80 00       	push   $0x803b1c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 c2 1e 00 00       	call   80211d <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 5a 1f 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 45 1a 00 00       	call   801cb9 <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 30 3b 80 00       	push   $0x803b30
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 1c 3b 80 00       	push   $0x803b1c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 0c 1f 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 98 3b 80 00       	push   $0x803b98
  8002be:	6a 46                	push   $0x46
  8002c0:	68 1c 3b 80 00       	push   $0x803b1c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 42 1e 00 00       	call   80211d <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 da 1e 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 bd 19 00 00       	call   801cb9 <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 30 3b 80 00       	push   $0x803b30
  800328:	6a 4d                	push   $0x4d
  80032a:	68 1c 3b 80 00       	push   $0x803b1c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 84 1e 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 98 3b 80 00       	push   $0x803b98
  800346:	6a 4e                	push   $0x4e
  800348:	68 1c 3b 80 00       	push   $0x803b1c
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 b2 1d 00 00       	call   80211d <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 4a 1e 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 2e 19 00 00       	call   801cb9 <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 30 3b 80 00       	push   $0x803b30
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 1c 3b 80 00       	push   $0x803b1c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 f5 1d 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 98 3b 80 00       	push   $0x803b98
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 1c 3b 80 00       	push   $0x803b1c
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 24 1d 00 00       	call   80211d <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 bc 1d 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 a4 18 00 00       	call   801cb9 <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 30 3b 80 00       	push   $0x803b30
  800448:	6a 5d                	push   $0x5d
  80044a:	68 1c 3b 80 00       	push   $0x803b1c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 64 1d 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 98 3b 80 00       	push   $0x803b98
  800466:	6a 5e                	push   $0x5e
  800468:	68 1c 3b 80 00       	push   $0x803b1c
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 97 1c 00 00       	call   80211d <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 2f 1d 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 a7 18 00 00       	call   801d44 <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 18 1d 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 c8 3b 80 00       	push   $0x803bc8
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 1c 3b 80 00       	push   $0x803b1c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 cd 1f 00 00       	call   80249c <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 04 3c 80 00       	push   $0x803c04
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 1c 3b 80 00       	push   $0x803b1c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 9b 1f 00 00       	call   80249c <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 04 3c 80 00       	push   $0x803c04
  80051a:	6a 71                	push   $0x71
  80051c:	68 1c 3b 80 00       	push   $0x803b1c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 f2 1b 00 00       	call   80211d <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 8a 1c 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 02 18 00 00       	call   801d44 <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 73 1c 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 c8 3b 80 00       	push   $0x803bc8
  800557:	6a 76                	push   $0x76
  800559:	68 1c 3b 80 00       	push   $0x803b1c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 28 1f 00 00       	call   80249c <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 04 3c 80 00       	push   $0x803c04
  800585:	6a 7a                	push   $0x7a
  800587:	68 1c 3b 80 00       	push   $0x803b1c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 f6 1e 00 00       	call   80249c <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 04 3c 80 00       	push   $0x803c04
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 1c 3b 80 00       	push   $0x803b1c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 4d 1b 00 00       	call   80211d <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 e5 1b 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 5d 17 00 00       	call   801d44 <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 ce 1b 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 c8 3b 80 00       	push   $0x803bc8
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 1c 3b 80 00       	push   $0x803b1c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 80 1e 00 00       	call   80249c <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 04 3c 80 00       	push   $0x803c04
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 1c 3b 80 00       	push   $0x803b1c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 4b 1e 00 00       	call   80249c <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 04 3c 80 00       	push   $0x803c04
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 1c 3b 80 00       	push   $0x803b1c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 9f 1a 00 00       	call   80211d <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 37 1b 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 af 16 00 00       	call   801d44 <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 20 1b 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 c8 3b 80 00       	push   $0x803bc8
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 1c 3b 80 00       	push   $0x803b1c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 d2 1d 00 00       	call   80249c <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 04 3c 80 00       	push   $0x803c04
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 1c 3b 80 00       	push   $0x803b1c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 9d 1d 00 00       	call   80249c <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 04 3c 80 00       	push   $0x803c04
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 1c 3b 80 00       	push   $0x803b1c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 f1 19 00 00       	call   80211d <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 89 1a 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 01 16 00 00       	call   801d44 <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 72 1a 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 c8 3b 80 00       	push   $0x803bc8
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 1c 3b 80 00       	push   $0x803b1c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 24 1d 00 00       	call   80249c <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 04 3c 80 00       	push   $0x803c04
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 1c 3b 80 00       	push   $0x803b1c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 ef 1c 00 00       	call   80249c <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 04 3c 80 00       	push   $0x803c04
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 1c 3b 80 00       	push   $0x803b1c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 43 19 00 00       	call   80211d <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 db 19 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 53 15 00 00       	call   801d44 <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 c4 19 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 c8 3b 80 00       	push   $0x803bc8
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 1c 3b 80 00       	push   $0x803b1c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 76 1c 00 00       	call   80249c <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 04 3c 80 00       	push   $0x803c04
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 1c 3b 80 00       	push   $0x803b1c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 41 1c 00 00       	call   80249c <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 04 3c 80 00       	push   $0x803c04
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 1c 3b 80 00       	push   $0x803b1c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 95 18 00 00       	call   80211d <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 2d 19 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 a5 14 00 00       	call   801d44 <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 16 19 00 00       	call   8021bd <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 c8 3b 80 00       	push   $0x803bc8
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 1c 3b 80 00       	push   $0x803b1c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 c8 1b 00 00       	call   80249c <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 04 3c 80 00       	push   $0x803c04
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 1c 3b 80 00       	push   $0x803b1c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 93 1b 00 00       	call   80249c <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 04 3c 80 00       	push   $0x803c04
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 1c 3b 80 00       	push   $0x803b1c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 e7 17 00 00       	call   80211d <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 48 3c 80 00       	push   $0x803c48
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 1c 3b 80 00       	push   $0x803b1c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 55 1b 00 00       	call   8024b5 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 7c 3c 80 00       	push   $0x803c7c
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 79 1a 00 00       	call   8023fd <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 1b 18 00 00       	call   80220a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 d0 3c 80 00       	push   $0x803cd0
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 f8 3c 80 00       	push   $0x803cf8
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 20 3d 80 00       	push   $0x803d20
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 78 3d 80 00       	push   $0x803d78
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 d0 3c 80 00       	push   $0x803cd0
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 9b 17 00 00       	call   802224 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 28 19 00 00       	call   8023c9 <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 7d 19 00 00       	call   80242f <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 8c 3d 80 00       	push   $0x803d8c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 91 3d 80 00       	push   $0x803d91
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 ad 3d 80 00       	push   $0x803dad
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 b0 3d 80 00       	push   $0x803db0
  800b44:	6a 26                	push   $0x26
  800b46:	68 fc 3d 80 00       	push   $0x803dfc
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 08 3e 80 00       	push   $0x803e08
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 fc 3d 80 00       	push   $0x803dfc
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 5c 3e 80 00       	push   $0x803e5c
  800c86:	6a 44                	push   $0x44
  800c88:	68 fc 3d 80 00       	push   $0x803dfc
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 7c 13 00 00       	call   80205c <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 05 13 00 00       	call   80205c <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 69 14 00 00       	call   80220a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 63 14 00 00       	call   802224 <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 81 2a 00 00       	call   80388c <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 41 2b 00 00       	call   80399c <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 d4 40 80 00       	add    $0x8040d4,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 e5 40 80 00       	push   $0x8040e5
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 ee 40 80 00       	push   $0x8040ee
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 50 42 80 00       	push   $0x804250
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801b2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b31:	00 00 00 
  801b34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b3b:	00 00 00 
  801b3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b45:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801b48:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b4f:	00 00 00 
  801b52:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b59:	00 00 00 
  801b5c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b63:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801b66:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b6d:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801b70:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801b77:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b86:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b8b:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801b90:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b9f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	6a 06                	push   $0x6
  801ba9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bac:	50                   	push   %eax
  801bad:	e8 ee 05 00 00       	call   8021a0 <sys_allocate_chunk>
  801bb2:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bb5:	a1 20 51 80 00       	mov    0x805120,%eax
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	50                   	push   %eax
  801bbe:	e8 63 0c 00 00       	call   802826 <initialize_MemBlocksList>
  801bc3:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801bc6:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801bcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be9:	89 c2                	mov    %eax,%edx
  801beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bee:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801bfb:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c05:	8b 50 08             	mov    0x8(%eax),%edx
  801c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0b:	01 d0                	add    %edx,%eax
  801c0d:	48                   	dec    %eax
  801c0e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c14:	ba 00 00 00 00       	mov    $0x0,%edx
  801c19:	f7 75 e0             	divl   -0x20(%ebp)
  801c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c1f:	29 d0                	sub    %edx,%eax
  801c21:	89 c2                	mov    %eax,%edx
  801c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c26:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801c29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c2d:	75 14                	jne    801c43 <initialize_dyn_block_system+0x11f>
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	68 75 42 80 00       	push   $0x804275
  801c37:	6a 34                	push   $0x34
  801c39:	68 93 42 80 00       	push   $0x804293
  801c3e:	e8 72 ee ff ff       	call   800ab5 <_panic>
  801c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	74 10                	je     801c5c <initialize_dyn_block_system+0x138>
  801c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c54:	8b 52 04             	mov    0x4(%edx),%edx
  801c57:	89 50 04             	mov    %edx,0x4(%eax)
  801c5a:	eb 0b                	jmp    801c67 <initialize_dyn_block_system+0x143>
  801c5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c5f:	8b 40 04             	mov    0x4(%eax),%eax
  801c62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c6a:	8b 40 04             	mov    0x4(%eax),%eax
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	74 0f                	je     801c80 <initialize_dyn_block_system+0x15c>
  801c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c74:	8b 40 04             	mov    0x4(%eax),%eax
  801c77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c7a:	8b 12                	mov    (%edx),%edx
  801c7c:	89 10                	mov    %edx,(%eax)
  801c7e:	eb 0a                	jmp    801c8a <initialize_dyn_block_system+0x166>
  801c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	a3 48 51 80 00       	mov    %eax,0x805148
  801c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c9d:	a1 54 51 80 00       	mov    0x805154,%eax
  801ca2:	48                   	dec    %eax
  801ca3:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	ff 75 e8             	pushl  -0x18(%ebp)
  801cae:	e8 c4 13 00 00       	call   803077 <insert_sorted_with_merge_freeList>
  801cb3:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cbf:	e8 2f fe ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cc8:	75 07                	jne    801cd1 <malloc+0x18>
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	eb 71                	jmp    801d42 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801cd1:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801cd8:	76 07                	jbe    801ce1 <malloc+0x28>
	return NULL;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	eb 61                	jmp    801d42 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ce1:	e8 88 08 00 00       	call   80256e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 53                	je     801d3d <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801cea:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf7:	01 d0                	add    %edx,%eax
  801cf9:	48                   	dec    %eax
  801cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d00:	ba 00 00 00 00       	mov    $0x0,%edx
  801d05:	f7 75 f4             	divl   -0xc(%ebp)
  801d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0b:	29 d0                	sub    %edx,%eax
  801d0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	ff 75 ec             	pushl  -0x14(%ebp)
  801d16:	e8 d2 0d 00 00       	call   802aed <alloc_block_FF>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801d21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d25:	74 16                	je     801d3d <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	ff 75 e8             	pushl  -0x18(%ebp)
  801d2d:	e8 0c 0c 00 00       	call   80293e <insert_sorted_allocList>
  801d32:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d38:	8b 40 08             	mov    0x8(%eax),%eax
  801d3b:	eb 05                	jmp    801d42 <malloc+0x89>
    }

			}


	return NULL;
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801d5b:	83 ec 08             	sub    $0x8,%esp
  801d5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d61:	68 40 50 80 00       	push   $0x805040
  801d66:	e8 a0 0b 00 00       	call   80290b <find_block>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d74:	8b 50 0c             	mov    0xc(%eax),%edx
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	83 ec 08             	sub    $0x8,%esp
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	e8 e4 03 00 00       	call   802168 <sys_free_user_mem>
  801d84:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d8b:	75 17                	jne    801da4 <free+0x60>
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	68 75 42 80 00       	push   $0x804275
  801d95:	68 84 00 00 00       	push   $0x84
  801d9a:	68 93 42 80 00       	push   $0x804293
  801d9f:	e8 11 ed ff ff       	call   800ab5 <_panic>
  801da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	85 c0                	test   %eax,%eax
  801dab:	74 10                	je     801dbd <free+0x79>
  801dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801db5:	8b 52 04             	mov    0x4(%edx),%edx
  801db8:	89 50 04             	mov    %edx,0x4(%eax)
  801dbb:	eb 0b                	jmp    801dc8 <free+0x84>
  801dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc0:	8b 40 04             	mov    0x4(%eax),%eax
  801dc3:	a3 44 50 80 00       	mov    %eax,0x805044
  801dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcb:	8b 40 04             	mov    0x4(%eax),%eax
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	74 0f                	je     801de1 <free+0x9d>
  801dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd5:	8b 40 04             	mov    0x4(%eax),%eax
  801dd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ddb:	8b 12                	mov    (%edx),%edx
  801ddd:	89 10                	mov    %edx,(%eax)
  801ddf:	eb 0a                	jmp    801deb <free+0xa7>
  801de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de4:	8b 00                	mov    (%eax),%eax
  801de6:	a3 40 50 80 00       	mov    %eax,0x805040
  801deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dfe:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e03:	48                   	dec    %eax
  801e04:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	ff 75 ec             	pushl  -0x14(%ebp)
  801e0f:	e8 63 12 00 00       	call   803077 <insert_sorted_with_merge_freeList>
  801e14:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801e17:	90                   	nop
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 38             	sub    $0x38,%esp
  801e20:	8b 45 10             	mov    0x10(%ebp),%eax
  801e23:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e26:	e8 c8 fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e2f:	75 0a                	jne    801e3b <smalloc+0x21>
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
  801e36:	e9 a0 00 00 00       	jmp    801edb <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801e3b:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801e42:	76 0a                	jbe    801e4e <smalloc+0x34>
		return NULL;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	e9 8d 00 00 00       	jmp    801edb <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e4e:	e8 1b 07 00 00       	call   80256e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e53:	85 c0                	test   %eax,%eax
  801e55:	74 7f                	je     801ed6 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801e57:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	01 d0                	add    %edx,%eax
  801e66:	48                   	dec    %eax
  801e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e72:	f7 75 f4             	divl   -0xc(%ebp)
  801e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e78:	29 d0                	sub    %edx,%eax
  801e7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	ff 75 ec             	pushl  -0x14(%ebp)
  801e83:	e8 65 0c 00 00       	call   802aed <alloc_block_FF>
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801e8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e92:	74 42                	je     801ed6 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	ff 75 e8             	pushl  -0x18(%ebp)
  801e9a:	e8 9f 0a 00 00       	call   80293e <insert_sorted_allocList>
  801e9f:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea5:	8b 40 08             	mov    0x8(%eax),%eax
  801ea8:	89 c2                	mov    %eax,%edx
  801eaa:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801eae:	52                   	push   %edx
  801eaf:	50                   	push   %eax
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	e8 38 04 00 00       	call   8022f3 <sys_createSharedObject>
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801ec1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ec5:	79 07                	jns    801ece <smalloc+0xb4>
	    		  return NULL;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	eb 0d                	jmp    801edb <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801ece:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed1:	8b 40 08             	mov    0x8(%eax),%eax
  801ed4:	eb 05                	jmp    801edb <smalloc+0xc1>


				}


		return NULL;
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ee3:	e8 0b fc ff ff       	call   801af3 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ee8:	e8 81 06 00 00       	call   80256e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eed:	85 c0                	test   %eax,%eax
  801eef:	0f 84 9f 00 00 00    	je     801f94 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ef5:	83 ec 08             	sub    $0x8,%esp
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	e8 1a 04 00 00       	call   80231d <sys_getSizeOfSharedObject>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801f09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0d:	79 0a                	jns    801f19 <sget+0x3c>
		return NULL;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	e9 80 00 00 00       	jmp    801f99 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801f19:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f26:	01 d0                	add    %edx,%eax
  801f28:	48                   	dec    %eax
  801f29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f34:	f7 75 f0             	divl   -0x10(%ebp)
  801f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3a:	29 d0                	sub    %edx,%eax
  801f3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	ff 75 e8             	pushl  -0x18(%ebp)
  801f45:	e8 a3 0b 00 00       	call   802aed <alloc_block_FF>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801f50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f54:	74 3e                	je     801f94 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f5c:	e8 dd 09 00 00       	call   80293e <insert_sorted_allocList>
  801f61:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f67:	8b 40 08             	mov    0x8(%eax),%eax
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	50                   	push   %eax
  801f6e:	ff 75 0c             	pushl  0xc(%ebp)
  801f71:	ff 75 08             	pushl  0x8(%ebp)
  801f74:	e8 c1 03 00 00       	call   80233a <sys_getSharedObject>
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801f7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f83:	79 07                	jns    801f8c <sget+0xaf>
	    		  return NULL;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	eb 0d                	jmp    801f99 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f8f:	8b 40 08             	mov    0x8(%eax),%eax
  801f92:	eb 05                	jmp    801f99 <sget+0xbc>
	      }
	}
	   return NULL;
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fa1:	e8 4d fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fa6:	83 ec 04             	sub    $0x4,%esp
  801fa9:	68 a0 42 80 00       	push   $0x8042a0
  801fae:	68 12 01 00 00       	push   $0x112
  801fb3:	68 93 42 80 00       	push   $0x804293
  801fb8:	e8 f8 ea ff ff       	call   800ab5 <_panic>

00801fbd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	68 c8 42 80 00       	push   $0x8042c8
  801fcb:	68 26 01 00 00       	push   $0x126
  801fd0:	68 93 42 80 00       	push   $0x804293
  801fd5:	e8 db ea ff ff       	call   800ab5 <_panic>

00801fda <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 ec 42 80 00       	push   $0x8042ec
  801fe8:	68 31 01 00 00       	push   $0x131
  801fed:	68 93 42 80 00       	push   $0x804293
  801ff2:	e8 be ea ff ff       	call   800ab5 <_panic>

00801ff7 <shrink>:

}
void shrink(uint32 newSize)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 ec 42 80 00       	push   $0x8042ec
  802005:	68 36 01 00 00       	push   $0x136
  80200a:	68 93 42 80 00       	push   $0x804293
  80200f:	e8 a1 ea ff ff       	call   800ab5 <_panic>

00802014 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	68 ec 42 80 00       	push   $0x8042ec
  802022:	68 3b 01 00 00       	push   $0x13b
  802027:	68 93 42 80 00       	push   $0x804293
  80202c:	e8 84 ea ff ff       	call   800ab5 <_panic>

00802031 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	57                   	push   %edi
  802035:	56                   	push   %esi
  802036:	53                   	push   %ebx
  802037:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802040:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802043:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802046:	8b 7d 18             	mov    0x18(%ebp),%edi
  802049:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80204c:	cd 30                	int    $0x30
  80204e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802051:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	8b 45 10             	mov    0x10(%ebp),%eax
  802065:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802068:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	52                   	push   %edx
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	50                   	push   %eax
  802078:	6a 00                	push   $0x0
  80207a:	e8 b2 ff ff ff       	call   802031 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	90                   	nop
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_cgetc>:

int
sys_cgetc(void)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 01                	push   $0x1
  802094:	e8 98 ff ff ff       	call   802031 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	52                   	push   %edx
  8020ae:	50                   	push   %eax
  8020af:	6a 05                	push   $0x5
  8020b1:	e8 7b ff ff ff       	call   802031 <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8020c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	56                   	push   %esi
  8020d0:	53                   	push   %ebx
  8020d1:	51                   	push   %ecx
  8020d2:	52                   	push   %edx
  8020d3:	50                   	push   %eax
  8020d4:	6a 06                	push   $0x6
  8020d6:	e8 56 ff ff ff       	call   802031 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    

008020e5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	52                   	push   %edx
  8020f5:	50                   	push   %eax
  8020f6:	6a 07                	push   $0x7
  8020f8:	e8 34 ff ff ff       	call   802031 <syscall>
  8020fd:	83 c4 18             	add    $0x18,%esp
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	ff 75 08             	pushl  0x8(%ebp)
  802111:	6a 08                	push   $0x8
  802113:	e8 19 ff ff ff       	call   802031 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 09                	push   $0x9
  80212c:	e8 00 ff ff ff       	call   802031 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 0a                	push   $0xa
  802145:	e8 e7 fe ff ff       	call   802031 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 0b                	push   $0xb
  80215e:	e8 ce fe ff ff       	call   802031 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	ff 75 0c             	pushl  0xc(%ebp)
  802174:	ff 75 08             	pushl  0x8(%ebp)
  802177:	6a 0f                	push   $0xf
  802179:	e8 b3 fe ff ff       	call   802031 <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
	return;
  802181:	90                   	nop
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	ff 75 08             	pushl  0x8(%ebp)
  802193:	6a 10                	push   $0x10
  802195:	e8 97 fe ff ff       	call   802031 <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
	return ;
  80219d:	90                   	nop
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	ff 75 10             	pushl  0x10(%ebp)
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	ff 75 08             	pushl  0x8(%ebp)
  8021b0:	6a 11                	push   $0x11
  8021b2:	e8 7a fe ff ff       	call   802031 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ba:	90                   	nop
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 0c                	push   $0xc
  8021cc:	e8 60 fe ff ff       	call   802031 <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	ff 75 08             	pushl  0x8(%ebp)
  8021e4:	6a 0d                	push   $0xd
  8021e6:	e8 46 fe ff ff       	call   802031 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 0e                	push   $0xe
  8021ff:	e8 2d fe ff ff       	call   802031 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	90                   	nop
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 13                	push   $0x13
  802219:	e8 13 fe ff ff       	call   802031 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	90                   	nop
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 14                	push   $0x14
  802233:	e8 f9 fd ff ff       	call   802031 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	90                   	nop
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <sys_cputc>:


void
sys_cputc(const char c)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80224a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	50                   	push   %eax
  802257:	6a 15                	push   $0x15
  802259:	e8 d3 fd ff ff       	call   802031 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	90                   	nop
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 16                	push   $0x16
  802273:	e8 b9 fd ff ff       	call   802031 <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
}
  80227b:	90                   	nop
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	50                   	push   %eax
  80228e:	6a 17                	push   $0x17
  802290:	e8 9c fd ff ff       	call   802031 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80229d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	52                   	push   %edx
  8022aa:	50                   	push   %eax
  8022ab:	6a 1a                	push   $0x1a
  8022ad:	e8 7f fd ff ff       	call   802031 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	52                   	push   %edx
  8022c7:	50                   	push   %eax
  8022c8:	6a 18                	push   $0x18
  8022ca:	e8 62 fd ff ff       	call   802031 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	90                   	nop
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	52                   	push   %edx
  8022e5:	50                   	push   %eax
  8022e6:	6a 19                	push   $0x19
  8022e8:	e8 44 fd ff ff       	call   802031 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	90                   	nop
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 04             	sub    $0x4,%esp
  8022f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802302:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	6a 00                	push   $0x0
  80230b:	51                   	push   %ecx
  80230c:	52                   	push   %edx
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	50                   	push   %eax
  802311:	6a 1b                	push   $0x1b
  802313:	e8 19 fd ff ff       	call   802031 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802320:	8b 55 0c             	mov    0xc(%ebp),%edx
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	52                   	push   %edx
  80232d:	50                   	push   %eax
  80232e:	6a 1c                	push   $0x1c
  802330:	e8 fc fc ff ff       	call   802031 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80233d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	51                   	push   %ecx
  80234b:	52                   	push   %edx
  80234c:	50                   	push   %eax
  80234d:	6a 1d                	push   $0x1d
  80234f:	e8 dd fc ff ff       	call   802031 <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	52                   	push   %edx
  802369:	50                   	push   %eax
  80236a:	6a 1e                	push   $0x1e
  80236c:	e8 c0 fc ff ff       	call   802031 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 1f                	push   $0x1f
  802385:	e8 a7 fc ff ff       	call   802031 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	6a 00                	push   $0x0
  802397:	ff 75 14             	pushl  0x14(%ebp)
  80239a:	ff 75 10             	pushl  0x10(%ebp)
  80239d:	ff 75 0c             	pushl  0xc(%ebp)
  8023a0:	50                   	push   %eax
  8023a1:	6a 20                	push   $0x20
  8023a3:	e8 89 fc ff ff       	call   802031 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	50                   	push   %eax
  8023bc:	6a 21                	push   $0x21
  8023be:	e8 6e fc ff ff       	call   802031 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	90                   	nop
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	50                   	push   %eax
  8023d8:	6a 22                	push   $0x22
  8023da:	e8 52 fc ff ff       	call   802031 <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 02                	push   $0x2
  8023f3:	e8 39 fc ff ff       	call   802031 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 03                	push   $0x3
  80240c:	e8 20 fc ff ff       	call   802031 <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 04                	push   $0x4
  802425:	e8 07 fc ff ff       	call   802031 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_exit_env>:


void sys_exit_env(void)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 23                	push   $0x23
  80243e:	e8 ee fb ff ff       	call   802031 <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
}
  802446:	90                   	nop
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80244f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802452:	8d 50 04             	lea    0x4(%eax),%edx
  802455:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	52                   	push   %edx
  80245f:	50                   	push   %eax
  802460:	6a 24                	push   $0x24
  802462:	e8 ca fb ff ff       	call   802031 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
	return result;
  80246a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802470:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802473:	89 01                	mov    %eax,(%ecx)
  802475:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	c9                   	leave  
  80247c:	c2 04 00             	ret    $0x4

0080247f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	ff 75 10             	pushl  0x10(%ebp)
  802489:	ff 75 0c             	pushl  0xc(%ebp)
  80248c:	ff 75 08             	pushl  0x8(%ebp)
  80248f:	6a 12                	push   $0x12
  802491:	e8 9b fb ff ff       	call   802031 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
	return ;
  802499:	90                   	nop
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_rcr2>:
uint32 sys_rcr2()
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 25                	push   $0x25
  8024ab:	e8 81 fb ff ff       	call   802031 <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	50                   	push   %eax
  8024ce:	6a 26                	push   $0x26
  8024d0:	e8 5c fb ff ff       	call   802031 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d8:	90                   	nop
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <rsttst>:
void rsttst()
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 28                	push   $0x28
  8024ea:	e8 42 fb ff ff       	call   802031 <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f2:	90                   	nop
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 04             	sub    $0x4,%esp
  8024fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8024fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802501:	8b 55 18             	mov    0x18(%ebp),%edx
  802504:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802508:	52                   	push   %edx
  802509:	50                   	push   %eax
  80250a:	ff 75 10             	pushl  0x10(%ebp)
  80250d:	ff 75 0c             	pushl  0xc(%ebp)
  802510:	ff 75 08             	pushl  0x8(%ebp)
  802513:	6a 27                	push   $0x27
  802515:	e8 17 fb ff ff       	call   802031 <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
	return ;
  80251d:	90                   	nop
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <chktst>:
void chktst(uint32 n)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	ff 75 08             	pushl  0x8(%ebp)
  80252e:	6a 29                	push   $0x29
  802530:	e8 fc fa ff ff       	call   802031 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
	return ;
  802538:	90                   	nop
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <inctst>:

void inctst()
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 2a                	push   $0x2a
  80254a:	e8 e2 fa ff ff       	call   802031 <syscall>
  80254f:	83 c4 18             	add    $0x18,%esp
	return ;
  802552:	90                   	nop
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <gettst>:
uint32 gettst()
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 2b                	push   $0x2b
  802564:	e8 c8 fa ff ff       	call   802031 <syscall>
  802569:	83 c4 18             	add    $0x18,%esp
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 2c                	push   $0x2c
  802580:	e8 ac fa ff ff       	call   802031 <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
  802588:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80258b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80258f:	75 07                	jne    802598 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802591:	b8 01 00 00 00       	mov    $0x1,%eax
  802596:	eb 05                	jmp    80259d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 2c                	push   $0x2c
  8025b1:	e8 7b fa ff ff       	call   802031 <syscall>
  8025b6:	83 c4 18             	add    $0x18,%esp
  8025b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025c0:	75 07                	jne    8025c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c7:	eb 05                	jmp    8025ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 2c                	push   $0x2c
  8025e2:	e8 4a fa ff ff       	call   802031 <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
  8025ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025f1:	75 07                	jne    8025fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f8:	eb 05                	jmp    8025ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 2c                	push   $0x2c
  802613:	e8 19 fa ff ff       	call   802031 <syscall>
  802618:	83 c4 18             	add    $0x18,%esp
  80261b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80261e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802622:	75 07                	jne    80262b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802624:	b8 01 00 00 00       	mov    $0x1,%eax
  802629:	eb 05                	jmp    802630 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	ff 75 08             	pushl  0x8(%ebp)
  802640:	6a 2d                	push   $0x2d
  802642:	e8 ea f9 ff ff       	call   802031 <syscall>
  802647:	83 c4 18             	add    $0x18,%esp
	return ;
  80264a:	90                   	nop
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802651:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802654:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	6a 00                	push   $0x0
  80265f:	53                   	push   %ebx
  802660:	51                   	push   %ecx
  802661:	52                   	push   %edx
  802662:	50                   	push   %eax
  802663:	6a 2e                	push   $0x2e
  802665:	e8 c7 f9 ff ff       	call   802031 <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
}
  80266d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802675:	8b 55 0c             	mov    0xc(%ebp),%edx
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	52                   	push   %edx
  802682:	50                   	push   %eax
  802683:	6a 2f                	push   $0x2f
  802685:	e8 a7 f9 ff ff       	call   802031 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	68 fc 42 80 00       	push   $0x8042fc
  80269d:	e8 c7 e6 ff ff       	call   800d69 <cprintf>
  8026a2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	68 28 43 80 00       	push   $0x804328
  8026b4:	e8 b0 e6 ff ff       	call   800d69 <cprintf>
  8026b9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026bc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c8:	eb 56                	jmp    802720 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ce:	74 1c                	je     8026ec <print_mem_block_lists+0x5d>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 50 08             	mov    0x8(%eax),%edx
  8026d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8026dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026df:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e2:	01 c8                	add    %ecx,%eax
  8026e4:	39 c2                	cmp    %eax,%edx
  8026e6:	73 04                	jae    8026ec <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026e8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 50 08             	mov    0x8(%eax),%edx
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f8:	01 c2                	add    %eax,%edx
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 08             	mov    0x8(%eax),%eax
  802700:	83 ec 04             	sub    $0x4,%esp
  802703:	52                   	push   %edx
  802704:	50                   	push   %eax
  802705:	68 3d 43 80 00       	push   $0x80433d
  80270a:	e8 5a e6 ff ff       	call   800d69 <cprintf>
  80270f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802718:	a1 40 51 80 00       	mov    0x805140,%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802724:	74 07                	je     80272d <print_mem_block_lists+0x9e>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	eb 05                	jmp    802732 <print_mem_block_lists+0xa3>
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
  802732:	a3 40 51 80 00       	mov    %eax,0x805140
  802737:	a1 40 51 80 00       	mov    0x805140,%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	75 8a                	jne    8026ca <print_mem_block_lists+0x3b>
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	75 84                	jne    8026ca <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802746:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80274a:	75 10                	jne    80275c <print_mem_block_lists+0xcd>
  80274c:	83 ec 0c             	sub    $0xc,%esp
  80274f:	68 4c 43 80 00       	push   $0x80434c
  802754:	e8 10 e6 ff ff       	call   800d69 <cprintf>
  802759:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80275c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802763:	83 ec 0c             	sub    $0xc,%esp
  802766:	68 70 43 80 00       	push   $0x804370
  80276b:	e8 f9 e5 ff ff       	call   800d69 <cprintf>
  802770:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802773:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802777:	a1 40 50 80 00       	mov    0x805040,%eax
  80277c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277f:	eb 56                	jmp    8027d7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802781:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802785:	74 1c                	je     8027a3 <print_mem_block_lists+0x114>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 50 08             	mov    0x8(%eax),%edx
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	8b 48 08             	mov    0x8(%eax),%ecx
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 40 0c             	mov    0xc(%eax),%eax
  802799:	01 c8                	add    %ecx,%eax
  80279b:	39 c2                	cmp    %eax,%edx
  80279d:	73 04                	jae    8027a3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80279f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 50 08             	mov    0x8(%eax),%edx
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8027af:	01 c2                	add    %eax,%edx
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 40 08             	mov    0x8(%eax),%eax
  8027b7:	83 ec 04             	sub    $0x4,%esp
  8027ba:	52                   	push   %edx
  8027bb:	50                   	push   %eax
  8027bc:	68 3d 43 80 00       	push   $0x80433d
  8027c1:	e8 a3 e5 ff ff       	call   800d69 <cprintf>
  8027c6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027cf:	a1 48 50 80 00       	mov    0x805048,%eax
  8027d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027db:	74 07                	je     8027e4 <print_mem_block_lists+0x155>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	eb 05                	jmp    8027e9 <print_mem_block_lists+0x15a>
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8027ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 8a                	jne    802781 <print_mem_block_lists+0xf2>
  8027f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fb:	75 84                	jne    802781 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027fd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802801:	75 10                	jne    802813 <print_mem_block_lists+0x184>
  802803:	83 ec 0c             	sub    $0xc,%esp
  802806:	68 88 43 80 00       	push   $0x804388
  80280b:	e8 59 e5 ff ff       	call   800d69 <cprintf>
  802810:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	68 fc 42 80 00       	push   $0x8042fc
  80281b:	e8 49 e5 ff ff       	call   800d69 <cprintf>
  802820:	83 c4 10             	add    $0x10,%esp

}
  802823:	90                   	nop
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80282c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802833:	00 00 00 
  802836:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80283d:	00 00 00 
  802840:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802847:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80284a:	a1 50 50 80 00       	mov    0x805050,%eax
  80284f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802859:	e9 9e 00 00 00       	jmp    8028fc <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80285e:	a1 50 50 80 00       	mov    0x805050,%eax
  802863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802866:	c1 e2 04             	shl    $0x4,%edx
  802869:	01 d0                	add    %edx,%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	75 14                	jne    802883 <initialize_MemBlocksList+0x5d>
  80286f:	83 ec 04             	sub    $0x4,%esp
  802872:	68 b0 43 80 00       	push   $0x8043b0
  802877:	6a 48                	push   $0x48
  802879:	68 d3 43 80 00       	push   $0x8043d3
  80287e:	e8 32 e2 ff ff       	call   800ab5 <_panic>
  802883:	a1 50 50 80 00       	mov    0x805050,%eax
  802888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288b:	c1 e2 04             	shl    $0x4,%edx
  80288e:	01 d0                	add    %edx,%eax
  802890:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802896:	89 10                	mov    %edx,(%eax)
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 18                	je     8028b6 <initialize_MemBlocksList+0x90>
  80289e:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028a9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028ac:	c1 e1 04             	shl    $0x4,%ecx
  8028af:	01 ca                	add    %ecx,%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%eax)
  8028b4:	eb 12                	jmp    8028c8 <initialize_MemBlocksList+0xa2>
  8028b6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028be:	c1 e2 04             	shl    $0x4,%edx
  8028c1:	01 d0                	add    %edx,%eax
  8028c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d0:	c1 e2 04             	shl    $0x4,%edx
  8028d3:	01 d0                	add    %edx,%eax
  8028d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8028da:	a1 50 50 80 00       	mov    0x805050,%eax
  8028df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e2:	c1 e2 04             	shl    $0x4,%edx
  8028e5:	01 d0                	add    %edx,%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8028f3:	40                   	inc    %eax
  8028f4:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8028f9:	ff 45 f4             	incl   -0xc(%ebp)
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802902:	0f 82 56 ff ff ff    	jb     80285e <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802908:	90                   	nop
  802909:	c9                   	leave  
  80290a:	c3                   	ret    

0080290b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802919:	eb 18                	jmp    802933 <find_block+0x28>
		{
			if(tmp->sva==va)
  80291b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291e:	8b 40 08             	mov    0x8(%eax),%eax
  802921:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802924:	75 05                	jne    80292b <find_block+0x20>
			{
				return tmp;
  802926:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802929:	eb 11                	jmp    80293c <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80292b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802933:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802937:	75 e2                	jne    80291b <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802939:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80293c:	c9                   	leave  
  80293d:	c3                   	ret    

0080293e <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802944:	a1 40 50 80 00       	mov    0x805040,%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	0f 85 83 00 00 00    	jne    8029d4 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802951:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802958:	00 00 00 
  80295b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802962:	00 00 00 
  802965:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80296c:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80296f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802973:	75 14                	jne    802989 <insert_sorted_allocList+0x4b>
  802975:	83 ec 04             	sub    $0x4,%esp
  802978:	68 b0 43 80 00       	push   $0x8043b0
  80297d:	6a 7f                	push   $0x7f
  80297f:	68 d3 43 80 00       	push   $0x8043d3
  802984:	e8 2c e1 ff ff       	call   800ab5 <_panic>
  802989:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	89 10                	mov    %edx,(%eax)
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 0d                	je     8029aa <insert_sorted_allocList+0x6c>
  80299d:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a5:	89 50 04             	mov    %edx,0x4(%eax)
  8029a8:	eb 08                	jmp    8029b2 <insert_sorted_allocList+0x74>
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	a3 40 50 80 00       	mov    %eax,0x805040
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c9:	40                   	inc    %eax
  8029ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029cf:	e9 16 01 00 00       	jmp    802aea <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	8b 50 08             	mov    0x8(%eax),%edx
  8029da:	a1 44 50 80 00       	mov    0x805044,%eax
  8029df:	8b 40 08             	mov    0x8(%eax),%eax
  8029e2:	39 c2                	cmp    %eax,%edx
  8029e4:	76 68                	jbe    802a4e <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8029e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ea:	75 17                	jne    802a03 <insert_sorted_allocList+0xc5>
  8029ec:	83 ec 04             	sub    $0x4,%esp
  8029ef:	68 ec 43 80 00       	push   $0x8043ec
  8029f4:	68 85 00 00 00       	push   $0x85
  8029f9:	68 d3 43 80 00       	push   $0x8043d3
  8029fe:	e8 b2 e0 ff ff       	call   800ab5 <_panic>
  802a03:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8b 40 04             	mov    0x4(%eax),%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	74 0c                	je     802a25 <insert_sorted_allocList+0xe7>
  802a19:	a1 44 50 80 00       	mov    0x805044,%eax
  802a1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a21:	89 10                	mov    %edx,(%eax)
  802a23:	eb 08                	jmp    802a2d <insert_sorted_allocList+0xef>
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	a3 40 50 80 00       	mov    %eax,0x805040
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	a3 44 50 80 00       	mov    %eax,0x805044
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a43:	40                   	inc    %eax
  802a44:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a49:	e9 9c 00 00 00       	jmp    802aea <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802a4e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802a56:	e9 85 00 00 00       	jmp    802ae0 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	8b 50 08             	mov    0x8(%eax),%edx
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 08             	mov    0x8(%eax),%eax
  802a67:	39 c2                	cmp    %eax,%edx
  802a69:	73 6d                	jae    802ad8 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6f:	74 06                	je     802a77 <insert_sorted_allocList+0x139>
  802a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a75:	75 17                	jne    802a8e <insert_sorted_allocList+0x150>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 10 44 80 00       	push   $0x804410
  802a7f:	68 90 00 00 00       	push   $0x90
  802a84:	68 d3 43 80 00       	push   $0x8043d3
  802a89:	e8 27 e0 ff ff       	call   800ab5 <_panic>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 50 04             	mov    0x4(%eax),%edx
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	89 50 04             	mov    %edx,0x4(%eax)
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa0:	89 10                	mov    %edx,(%eax)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 0d                	je     802ab9 <insert_sorted_allocList+0x17b>
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	eb 08                	jmp    802ac1 <insert_sorted_allocList+0x183>
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	a3 40 50 80 00       	mov    %eax,0x805040
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac7:	89 50 04             	mov    %edx,0x4(%eax)
  802aca:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802acf:	40                   	inc    %eax
  802ad0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ad5:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ad6:	eb 12                	jmp    802aea <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae4:	0f 85 71 ff ff ff    	jne    802a5b <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802aea:	90                   	nop
  802aeb:	c9                   	leave  
  802aec:	c3                   	ret    

00802aed <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802aed:	55                   	push   %ebp
  802aee:	89 e5                	mov    %esp,%ebp
  802af0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802af3:	a1 38 51 80 00       	mov    0x805138,%eax
  802af8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802afb:	e9 76 01 00 00       	jmp    802c76 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 40 0c             	mov    0xc(%eax),%eax
  802b06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b09:	0f 85 8a 00 00 00    	jne    802b99 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b13:	75 17                	jne    802b2c <alloc_block_FF+0x3f>
  802b15:	83 ec 04             	sub    $0x4,%esp
  802b18:	68 45 44 80 00       	push   $0x804445
  802b1d:	68 a8 00 00 00       	push   $0xa8
  802b22:	68 d3 43 80 00       	push   $0x8043d3
  802b27:	e8 89 df ff ff       	call   800ab5 <_panic>
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 10                	je     802b45 <alloc_block_FF+0x58>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3d:	8b 52 04             	mov    0x4(%edx),%edx
  802b40:	89 50 04             	mov    %edx,0x4(%eax)
  802b43:	eb 0b                	jmp    802b50 <alloc_block_FF+0x63>
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	74 0f                	je     802b69 <alloc_block_FF+0x7c>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b63:	8b 12                	mov    (%edx),%edx
  802b65:	89 10                	mov    %edx,(%eax)
  802b67:	eb 0a                	jmp    802b73 <alloc_block_FF+0x86>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b86:	a1 44 51 80 00       	mov    0x805144,%eax
  802b8b:	48                   	dec    %eax
  802b8c:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	e9 ea 00 00 00       	jmp    802c83 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba2:	0f 86 c6 00 00 00    	jbe    802c6e <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802ba8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb6:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 50 08             	mov    0x8(%eax),%edx
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcb:	2b 45 08             	sub    0x8(%ebp),%eax
  802bce:	89 c2                	mov    %eax,%edx
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 50 08             	mov    0x8(%eax),%edx
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	01 c2                	add    %eax,%edx
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802be7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802beb:	75 17                	jne    802c04 <alloc_block_FF+0x117>
  802bed:	83 ec 04             	sub    $0x4,%esp
  802bf0:	68 45 44 80 00       	push   $0x804445
  802bf5:	68 b6 00 00 00       	push   $0xb6
  802bfa:	68 d3 43 80 00       	push   $0x8043d3
  802bff:	e8 b1 de ff ff       	call   800ab5 <_panic>
  802c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	74 10                	je     802c1d <alloc_block_FF+0x130>
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c15:	8b 52 04             	mov    0x4(%edx),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	eb 0b                	jmp    802c28 <alloc_block_FF+0x13b>
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 0f                	je     802c41 <alloc_block_FF+0x154>
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	8b 40 04             	mov    0x4(%eax),%eax
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	8b 12                	mov    (%edx),%edx
  802c3d:	89 10                	mov    %edx,(%eax)
  802c3f:	eb 0a                	jmp    802c4b <alloc_block_FF+0x15e>
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	a3 48 51 80 00       	mov    %eax,0x805148
  802c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c63:	48                   	dec    %eax
  802c64:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	eb 15                	jmp    802c83 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7a:	0f 85 80 fe ff ff    	jne    802b00 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
  802c88:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802c8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802c93:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802c9a:	e9 c0 00 00 00       	jmp    802d5f <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca8:	0f 85 8a 00 00 00    	jne    802d38 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802cae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb2:	75 17                	jne    802ccb <alloc_block_BF+0x46>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 45 44 80 00       	push   $0x804445
  802cbc:	68 cf 00 00 00       	push   $0xcf
  802cc1:	68 d3 43 80 00       	push   $0x8043d3
  802cc6:	e8 ea dd ff ff       	call   800ab5 <_panic>
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 10                	je     802ce4 <alloc_block_BF+0x5f>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdc:	8b 52 04             	mov    0x4(%edx),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	eb 0b                	jmp    802cef <alloc_block_BF+0x6a>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 0f                	je     802d08 <alloc_block_BF+0x83>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d02:	8b 12                	mov    (%edx),%edx
  802d04:	89 10                	mov    %edx,(%eax)
  802d06:	eb 0a                	jmp    802d12 <alloc_block_BF+0x8d>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 44 51 80 00       	mov    0x805144,%eax
  802d2a:	48                   	dec    %eax
  802d2b:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	e9 2a 01 00 00       	jmp    802e62 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d41:	73 14                	jae    802d57 <alloc_block_BF+0xd2>
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 0c             	mov    0xc(%eax),%eax
  802d49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4c:	76 09                	jbe    802d57 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 40 0c             	mov    0xc(%eax),%eax
  802d54:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d63:	0f 85 36 ff ff ff    	jne    802c9f <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802d69:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802d71:	e9 dd 00 00 00       	jmp    802e53 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d7f:	0f 85 c6 00 00 00    	jne    802e4b <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802d85:	a1 48 51 80 00       	mov    0x805148,%eax
  802d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 50 08             	mov    0x8(%eax),%edx
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9f:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	01 c2                	add    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	2b 45 08             	sub    0x8(%ebp),%eax
  802dbc:	89 c2                	mov    %eax,%edx
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802dc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dc8:	75 17                	jne    802de1 <alloc_block_BF+0x15c>
  802dca:	83 ec 04             	sub    $0x4,%esp
  802dcd:	68 45 44 80 00       	push   $0x804445
  802dd2:	68 eb 00 00 00       	push   $0xeb
  802dd7:	68 d3 43 80 00       	push   $0x8043d3
  802ddc:	e8 d4 dc ff ff       	call   800ab5 <_panic>
  802de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 10                	je     802dfa <alloc_block_BF+0x175>
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802df2:	8b 52 04             	mov    0x4(%edx),%edx
  802df5:	89 50 04             	mov    %edx,0x4(%eax)
  802df8:	eb 0b                	jmp    802e05 <alloc_block_BF+0x180>
  802dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	74 0f                	je     802e1e <alloc_block_BF+0x199>
  802e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e18:	8b 12                	mov    (%edx),%edx
  802e1a:	89 10                	mov    %edx,(%eax)
  802e1c:	eb 0a                	jmp    802e28 <alloc_block_BF+0x1a3>
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	a3 48 51 80 00       	mov    %eax,0x805148
  802e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802e40:	48                   	dec    %eax
  802e41:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	eb 17                	jmp    802e62 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e57:	0f 85 19 ff ff ff    	jne    802d76 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802e5d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802e62:	c9                   	leave  
  802e63:	c3                   	ret    

00802e64 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802e6a:	a1 40 50 80 00       	mov    0x805040,%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	75 19                	jne    802e8c <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802e73:	83 ec 0c             	sub    $0xc,%esp
  802e76:	ff 75 08             	pushl  0x8(%ebp)
  802e79:	e8 6f fc ff ff       	call   802aed <alloc_block_FF>
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	e9 e9 01 00 00       	jmp    803075 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802e8c:	a1 44 50 80 00       	mov    0x805044,%eax
  802e91:	8b 40 08             	mov    0x8(%eax),%eax
  802e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802e97:	a1 44 50 80 00       	mov    0x805044,%eax
  802e9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9f:	a1 44 50 80 00       	mov    0x805044,%eax
  802ea4:	8b 40 08             	mov    0x8(%eax),%eax
  802ea7:	01 d0                	add    %edx,%eax
  802ea9:	83 ec 08             	sub    $0x8,%esp
  802eac:	50                   	push   %eax
  802ead:	68 38 51 80 00       	push   $0x805138
  802eb2:	e8 54 fa ff ff       	call   80290b <find_block>
  802eb7:	83 c4 10             	add    $0x10,%esp
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec6:	0f 85 9b 00 00 00    	jne    802f67 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 40 08             	mov    0x8(%eax),%eax
  802ed8:	01 d0                	add    %edx,%eax
  802eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee1:	75 17                	jne    802efa <alloc_block_NF+0x96>
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	68 45 44 80 00       	push   $0x804445
  802eeb:	68 1a 01 00 00       	push   $0x11a
  802ef0:	68 d3 43 80 00       	push   $0x8043d3
  802ef5:	e8 bb db ff ff       	call   800ab5 <_panic>
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 10                	je     802f13 <alloc_block_NF+0xaf>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0b:	8b 52 04             	mov    0x4(%edx),%edx
  802f0e:	89 50 04             	mov    %edx,0x4(%eax)
  802f11:	eb 0b                	jmp    802f1e <alloc_block_NF+0xba>
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 40 04             	mov    0x4(%eax),%eax
  802f19:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	74 0f                	je     802f37 <alloc_block_NF+0xd3>
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 04             	mov    0x4(%eax),%eax
  802f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f31:	8b 12                	mov    (%edx),%edx
  802f33:	89 10                	mov    %edx,(%eax)
  802f35:	eb 0a                	jmp    802f41 <alloc_block_NF+0xdd>
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f54:	a1 44 51 80 00       	mov    0x805144,%eax
  802f59:	48                   	dec    %eax
  802f5a:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	e9 0e 01 00 00       	jmp    803075 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f70:	0f 86 cf 00 00 00    	jbe    803045 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802f76:	a1 48 51 80 00       	mov    0x805148,%eax
  802f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f81:	8b 55 08             	mov    0x8(%ebp),%edx
  802f84:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 50 08             	mov    0x8(%eax),%edx
  802f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f90:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	01 c2                	add    %eax,%edx
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802faa:	2b 45 08             	sub    0x8(%ebp),%eax
  802fad:	89 c2                	mov    %eax,%edx
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802fbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fc2:	75 17                	jne    802fdb <alloc_block_NF+0x177>
  802fc4:	83 ec 04             	sub    $0x4,%esp
  802fc7:	68 45 44 80 00       	push   $0x804445
  802fcc:	68 28 01 00 00       	push   $0x128
  802fd1:	68 d3 43 80 00       	push   $0x8043d3
  802fd6:	e8 da da ff ff       	call   800ab5 <_panic>
  802fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	85 c0                	test   %eax,%eax
  802fe2:	74 10                	je     802ff4 <alloc_block_NF+0x190>
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fec:	8b 52 04             	mov    0x4(%edx),%edx
  802fef:	89 50 04             	mov    %edx,0x4(%eax)
  802ff2:	eb 0b                	jmp    802fff <alloc_block_NF+0x19b>
  802ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff7:	8b 40 04             	mov    0x4(%eax),%eax
  802ffa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0f                	je     803018 <alloc_block_NF+0x1b4>
  803009:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300c:	8b 40 04             	mov    0x4(%eax),%eax
  80300f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803012:	8b 12                	mov    (%edx),%edx
  803014:	89 10                	mov    %edx,(%eax)
  803016:	eb 0a                	jmp    803022 <alloc_block_NF+0x1be>
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	a3 48 51 80 00       	mov    %eax,0x805148
  803022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803035:	a1 54 51 80 00       	mov    0x805154,%eax
  80303a:	48                   	dec    %eax
  80303b:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	eb 30                	jmp    803075 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803045:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80304d:	75 0a                	jne    803059 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80304f:	a1 38 51 80 00       	mov    0x805138,%eax
  803054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803057:	eb 08                	jmp    803061 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 40 08             	mov    0x8(%eax),%eax
  803067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80306a:	0f 85 4d fe ff ff    	jne    802ebd <alloc_block_NF+0x59>

			return NULL;
  803070:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	53                   	push   %ebx
  80307b:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80307e:	a1 38 51 80 00       	mov    0x805138,%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	0f 85 86 00 00 00    	jne    803111 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80308b:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803092:	00 00 00 
  803095:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80309c:	00 00 00 
  80309f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8030a6:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ad:	75 17                	jne    8030c6 <insert_sorted_with_merge_freeList+0x4f>
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 b0 43 80 00       	push   $0x8043b0
  8030b7:	68 48 01 00 00       	push   $0x148
  8030bc:	68 d3 43 80 00       	push   $0x8043d3
  8030c1:	e8 ef d9 ff ff       	call   800ab5 <_panic>
  8030c6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 00                	mov    (%eax),%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	74 0d                	je     8030e7 <insert_sorted_with_merge_freeList+0x70>
  8030da:	a1 38 51 80 00       	mov    0x805138,%eax
  8030df:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	eb 08                	jmp    8030ef <insert_sorted_with_merge_freeList+0x78>
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 44 51 80 00       	mov    0x805144,%eax
  803106:	40                   	inc    %eax
  803107:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80310c:	e9 73 07 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 50 08             	mov    0x8(%eax),%edx
  803117:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80311c:	8b 40 08             	mov    0x8(%eax),%eax
  80311f:	39 c2                	cmp    %eax,%edx
  803121:	0f 86 84 00 00 00    	jbe    8031ab <insert_sorted_with_merge_freeList+0x134>
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	8b 50 08             	mov    0x8(%eax),%edx
  80312d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803132:	8b 48 0c             	mov    0xc(%eax),%ecx
  803135:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80313a:	8b 40 08             	mov    0x8(%eax),%eax
  80313d:	01 c8                	add    %ecx,%eax
  80313f:	39 c2                	cmp    %eax,%edx
  803141:	74 68                	je     8031ab <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803147:	75 17                	jne    803160 <insert_sorted_with_merge_freeList+0xe9>
  803149:	83 ec 04             	sub    $0x4,%esp
  80314c:	68 ec 43 80 00       	push   $0x8043ec
  803151:	68 4c 01 00 00       	push   $0x14c
  803156:	68 d3 43 80 00       	push   $0x8043d3
  80315b:	e8 55 d9 ff ff       	call   800ab5 <_panic>
  803160:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	85 c0                	test   %eax,%eax
  803174:	74 0c                	je     803182 <insert_sorted_with_merge_freeList+0x10b>
  803176:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80317b:	8b 55 08             	mov    0x8(%ebp),%edx
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	eb 08                	jmp    80318a <insert_sorted_with_merge_freeList+0x113>
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 38 51 80 00       	mov    %eax,0x805138
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319b:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a0:	40                   	inc    %eax
  8031a1:	a3 44 51 80 00       	mov    %eax,0x805144
  8031a6:	e9 d9 06 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	8b 50 08             	mov    0x8(%eax),%edx
  8031b1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031b6:	8b 40 08             	mov    0x8(%eax),%eax
  8031b9:	39 c2                	cmp    %eax,%edx
  8031bb:	0f 86 b5 00 00 00    	jbe    803276 <insert_sorted_with_merge_freeList+0x1ff>
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	8b 50 08             	mov    0x8(%eax),%edx
  8031c7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031cc:	8b 48 0c             	mov    0xc(%eax),%ecx
  8031cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	01 c8                	add    %ecx,%eax
  8031d9:	39 c2                	cmp    %eax,%edx
  8031db:	0f 85 95 00 00 00    	jne    803276 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8031e1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031e6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031ec:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8031f5:	01 ca                	add    %ecx,%edx
  8031f7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80320e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803212:	75 17                	jne    80322b <insert_sorted_with_merge_freeList+0x1b4>
  803214:	83 ec 04             	sub    $0x4,%esp
  803217:	68 b0 43 80 00       	push   $0x8043b0
  80321c:	68 54 01 00 00       	push   $0x154
  803221:	68 d3 43 80 00       	push   $0x8043d3
  803226:	e8 8a d8 ff ff       	call   800ab5 <_panic>
  80322b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	89 10                	mov    %edx,(%eax)
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	74 0d                	je     80324c <insert_sorted_with_merge_freeList+0x1d5>
  80323f:	a1 48 51 80 00       	mov    0x805148,%eax
  803244:	8b 55 08             	mov    0x8(%ebp),%edx
  803247:	89 50 04             	mov    %edx,0x4(%eax)
  80324a:	eb 08                	jmp    803254 <insert_sorted_with_merge_freeList+0x1dd>
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	a3 48 51 80 00       	mov    %eax,0x805148
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803266:	a1 54 51 80 00       	mov    0x805154,%eax
  80326b:	40                   	inc    %eax
  80326c:	a3 54 51 80 00       	mov    %eax,0x805154
  803271:	e9 0e 06 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	8b 50 08             	mov    0x8(%eax),%edx
  80327c:	a1 38 51 80 00       	mov    0x805138,%eax
  803281:	8b 40 08             	mov    0x8(%eax),%eax
  803284:	39 c2                	cmp    %eax,%edx
  803286:	0f 83 c1 00 00 00    	jae    80334d <insert_sorted_with_merge_freeList+0x2d6>
  80328c:	a1 38 51 80 00       	mov    0x805138,%eax
  803291:	8b 50 08             	mov    0x8(%eax),%edx
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	8b 48 08             	mov    0x8(%eax),%ecx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a0:	01 c8                	add    %ecx,%eax
  8032a2:	39 c2                	cmp    %eax,%edx
  8032a4:	0f 85 a3 00 00 00    	jne    80334d <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8032aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8032af:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b2:	8b 52 08             	mov    0x8(%edx),%edx
  8032b5:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8032b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032c3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8032c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8032cc:	01 ca                	add    %ecx,%edx
  8032ce:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e9:	75 17                	jne    803302 <insert_sorted_with_merge_freeList+0x28b>
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	68 b0 43 80 00       	push   $0x8043b0
  8032f3:	68 5d 01 00 00       	push   $0x15d
  8032f8:	68 d3 43 80 00       	push   $0x8043d3
  8032fd:	e8 b3 d7 ff ff       	call   800ab5 <_panic>
  803302:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	89 10                	mov    %edx,(%eax)
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	74 0d                	je     803323 <insert_sorted_with_merge_freeList+0x2ac>
  803316:	a1 48 51 80 00       	mov    0x805148,%eax
  80331b:	8b 55 08             	mov    0x8(%ebp),%edx
  80331e:	89 50 04             	mov    %edx,0x4(%eax)
  803321:	eb 08                	jmp    80332b <insert_sorted_with_merge_freeList+0x2b4>
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 48 51 80 00       	mov    %eax,0x805148
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333d:	a1 54 51 80 00       	mov    0x805154,%eax
  803342:	40                   	inc    %eax
  803343:	a3 54 51 80 00       	mov    %eax,0x805154
  803348:	e9 37 05 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80334d:	8b 45 08             	mov    0x8(%ebp),%eax
  803350:	8b 50 08             	mov    0x8(%eax),%edx
  803353:	a1 38 51 80 00       	mov    0x805138,%eax
  803358:	8b 40 08             	mov    0x8(%eax),%eax
  80335b:	39 c2                	cmp    %eax,%edx
  80335d:	0f 83 82 00 00 00    	jae    8033e5 <insert_sorted_with_merge_freeList+0x36e>
  803363:	a1 38 51 80 00       	mov    0x805138,%eax
  803368:	8b 50 08             	mov    0x8(%eax),%edx
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	8b 48 08             	mov    0x8(%eax),%ecx
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	8b 40 0c             	mov    0xc(%eax),%eax
  803377:	01 c8                	add    %ecx,%eax
  803379:	39 c2                	cmp    %eax,%edx
  80337b:	74 68                	je     8033e5 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80337d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803381:	75 17                	jne    80339a <insert_sorted_with_merge_freeList+0x323>
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	68 b0 43 80 00       	push   $0x8043b0
  80338b:	68 62 01 00 00       	push   $0x162
  803390:	68 d3 43 80 00       	push   $0x8043d3
  803395:	e8 1b d7 ff ff       	call   800ab5 <_panic>
  80339a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	89 10                	mov    %edx,(%eax)
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	74 0d                	je     8033bb <insert_sorted_with_merge_freeList+0x344>
  8033ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b6:	89 50 04             	mov    %edx,0x4(%eax)
  8033b9:	eb 08                	jmp    8033c3 <insert_sorted_with_merge_freeList+0x34c>
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033da:	40                   	inc    %eax
  8033db:	a3 44 51 80 00       	mov    %eax,0x805144
  8033e0:	e9 9f 04 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8033e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8033ef:	e9 84 04 00 00       	jmp    803878 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 50 08             	mov    0x8(%eax),%edx
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 40 08             	mov    0x8(%eax),%eax
  803400:	39 c2                	cmp    %eax,%edx
  803402:	0f 86 a9 00 00 00    	jbe    8034b1 <insert_sorted_with_merge_freeList+0x43a>
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 50 08             	mov    0x8(%eax),%edx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	8b 48 08             	mov    0x8(%eax),%ecx
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	8b 40 0c             	mov    0xc(%eax),%eax
  80341a:	01 c8                	add    %ecx,%eax
  80341c:	39 c2                	cmp    %eax,%edx
  80341e:	0f 84 8d 00 00 00    	je     8034b1 <insert_sorted_with_merge_freeList+0x43a>
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	8b 50 08             	mov    0x8(%eax),%edx
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	8b 40 04             	mov    0x4(%eax),%eax
  803430:	8b 48 08             	mov    0x8(%eax),%ecx
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	8b 40 04             	mov    0x4(%eax),%eax
  803439:	8b 40 0c             	mov    0xc(%eax),%eax
  80343c:	01 c8                	add    %ecx,%eax
  80343e:	39 c2                	cmp    %eax,%edx
  803440:	74 6f                	je     8034b1 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803446:	74 06                	je     80344e <insert_sorted_with_merge_freeList+0x3d7>
  803448:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80344c:	75 17                	jne    803465 <insert_sorted_with_merge_freeList+0x3ee>
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	68 10 44 80 00       	push   $0x804410
  803456:	68 6b 01 00 00       	push   $0x16b
  80345b:	68 d3 43 80 00       	push   $0x8043d3
  803460:	e8 50 d6 ff ff       	call   800ab5 <_panic>
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 50 04             	mov    0x4(%eax),%edx
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	89 50 04             	mov    %edx,0x4(%eax)
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803477:	89 10                	mov    %edx,(%eax)
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	8b 40 04             	mov    0x4(%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0d                	je     803490 <insert_sorted_with_merge_freeList+0x419>
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	8b 55 08             	mov    0x8(%ebp),%edx
  80348c:	89 10                	mov    %edx,(%eax)
  80348e:	eb 08                	jmp    803498 <insert_sorted_with_merge_freeList+0x421>
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	a3 38 51 80 00       	mov    %eax,0x805138
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	8b 55 08             	mov    0x8(%ebp),%edx
  80349e:	89 50 04             	mov    %edx,0x4(%eax)
  8034a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a6:	40                   	inc    %eax
  8034a7:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8034ac:	e9 d3 03 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	8b 50 08             	mov    0x8(%eax),%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 40 08             	mov    0x8(%eax),%eax
  8034bd:	39 c2                	cmp    %eax,%edx
  8034bf:	0f 86 da 00 00 00    	jbe    80359f <insert_sorted_with_merge_freeList+0x528>
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	8b 50 08             	mov    0x8(%eax),%edx
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d7:	01 c8                	add    %ecx,%eax
  8034d9:	39 c2                	cmp    %eax,%edx
  8034db:	0f 85 be 00 00 00    	jne    80359f <insert_sorted_with_merge_freeList+0x528>
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	8b 50 08             	mov    0x8(%eax),%edx
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 40 04             	mov    0x4(%eax),%eax
  8034ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	8b 40 04             	mov    0x4(%eax),%eax
  8034f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f9:	01 c8                	add    %ecx,%eax
  8034fb:	39 c2                	cmp    %eax,%edx
  8034fd:	0f 84 9c 00 00 00    	je     80359f <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	8b 50 08             	mov    0x8(%eax),%edx
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 50 0c             	mov    0xc(%eax),%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 40 0c             	mov    0xc(%eax),%eax
  80351b:	01 c2                	add    %eax,%edx
  80351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803520:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803537:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353b:	75 17                	jne    803554 <insert_sorted_with_merge_freeList+0x4dd>
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	68 b0 43 80 00       	push   $0x8043b0
  803545:	68 74 01 00 00       	push   $0x174
  80354a:	68 d3 43 80 00       	push   $0x8043d3
  80354f:	e8 61 d5 ff ff       	call   800ab5 <_panic>
  803554:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	89 10                	mov    %edx,(%eax)
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	85 c0                	test   %eax,%eax
  803566:	74 0d                	je     803575 <insert_sorted_with_merge_freeList+0x4fe>
  803568:	a1 48 51 80 00       	mov    0x805148,%eax
  80356d:	8b 55 08             	mov    0x8(%ebp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%eax)
  803573:	eb 08                	jmp    80357d <insert_sorted_with_merge_freeList+0x506>
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	a3 48 51 80 00       	mov    %eax,0x805148
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358f:	a1 54 51 80 00       	mov    0x805154,%eax
  803594:	40                   	inc    %eax
  803595:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80359a:	e9 e5 02 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 50 08             	mov    0x8(%eax),%edx
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	8b 40 08             	mov    0x8(%eax),%eax
  8035ab:	39 c2                	cmp    %eax,%edx
  8035ad:	0f 86 d7 00 00 00    	jbe    80368a <insert_sorted_with_merge_freeList+0x613>
  8035b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b6:	8b 50 08             	mov    0x8(%eax),%edx
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	8b 48 08             	mov    0x8(%eax),%ecx
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c5:	01 c8                	add    %ecx,%eax
  8035c7:	39 c2                	cmp    %eax,%edx
  8035c9:	0f 84 bb 00 00 00    	je     80368a <insert_sorted_with_merge_freeList+0x613>
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	8b 50 08             	mov    0x8(%eax),%edx
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	8b 40 04             	mov    0x4(%eax),%eax
  8035db:	8b 48 08             	mov    0x8(%eax),%ecx
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 40 04             	mov    0x4(%eax),%eax
  8035e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e7:	01 c8                	add    %ecx,%eax
  8035e9:	39 c2                	cmp    %eax,%edx
  8035eb:	0f 85 99 00 00 00    	jne    80368a <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	8b 40 04             	mov    0x4(%eax),%eax
  8035f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8035fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fd:	8b 50 0c             	mov    0xc(%eax),%edx
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 40 0c             	mov    0xc(%eax),%eax
  803606:	01 c2                	add    %eax,%edx
  803608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360b:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803622:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803626:	75 17                	jne    80363f <insert_sorted_with_merge_freeList+0x5c8>
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 b0 43 80 00       	push   $0x8043b0
  803630:	68 7d 01 00 00       	push   $0x17d
  803635:	68 d3 43 80 00       	push   $0x8043d3
  80363a:	e8 76 d4 ff ff       	call   800ab5 <_panic>
  80363f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	89 10                	mov    %edx,(%eax)
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	74 0d                	je     803660 <insert_sorted_with_merge_freeList+0x5e9>
  803653:	a1 48 51 80 00       	mov    0x805148,%eax
  803658:	8b 55 08             	mov    0x8(%ebp),%edx
  80365b:	89 50 04             	mov    %edx,0x4(%eax)
  80365e:	eb 08                	jmp    803668 <insert_sorted_with_merge_freeList+0x5f1>
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	a3 48 51 80 00       	mov    %eax,0x805148
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367a:	a1 54 51 80 00       	mov    0x805154,%eax
  80367f:	40                   	inc    %eax
  803680:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803685:	e9 fa 01 00 00       	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 50 08             	mov    0x8(%eax),%edx
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	8b 40 08             	mov    0x8(%eax),%eax
  803696:	39 c2                	cmp    %eax,%edx
  803698:	0f 86 d2 01 00 00    	jbe    803870 <insert_sorted_with_merge_freeList+0x7f9>
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	8b 50 08             	mov    0x8(%eax),%edx
  8036a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b0:	01 c8                	add    %ecx,%eax
  8036b2:	39 c2                	cmp    %eax,%edx
  8036b4:	0f 85 b6 01 00 00    	jne    803870 <insert_sorted_with_merge_freeList+0x7f9>
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 50 08             	mov    0x8(%eax),%edx
  8036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c3:	8b 40 04             	mov    0x4(%eax),%eax
  8036c6:	8b 48 08             	mov    0x8(%eax),%ecx
  8036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cc:	8b 40 04             	mov    0x4(%eax),%eax
  8036cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d2:	01 c8                	add    %ecx,%eax
  8036d4:	39 c2                	cmp    %eax,%edx
  8036d6:	0f 85 94 01 00 00    	jne    803870 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e5:	8b 52 04             	mov    0x4(%edx),%edx
  8036e8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8036eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ee:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8036f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8036f7:	01 da                	add    %ebx,%edx
  8036f9:	01 ca                	add    %ecx,%edx
  8036fb:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8036fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803701:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803716:	75 17                	jne    80372f <insert_sorted_with_merge_freeList+0x6b8>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 45 44 80 00       	push   $0x804445
  803720:	68 86 01 00 00       	push   $0x186
  803725:	68 d3 43 80 00       	push   $0x8043d3
  80372a:	e8 86 d3 ff ff       	call   800ab5 <_panic>
  80372f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	74 10                	je     803748 <insert_sorted_with_merge_freeList+0x6d1>
  803738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803740:	8b 52 04             	mov    0x4(%edx),%edx
  803743:	89 50 04             	mov    %edx,0x4(%eax)
  803746:	eb 0b                	jmp    803753 <insert_sorted_with_merge_freeList+0x6dc>
  803748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374b:	8b 40 04             	mov    0x4(%eax),%eax
  80374e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803756:	8b 40 04             	mov    0x4(%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 0f                	je     80376c <insert_sorted_with_merge_freeList+0x6f5>
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	8b 40 04             	mov    0x4(%eax),%eax
  803763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803766:	8b 12                	mov    (%edx),%edx
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	eb 0a                	jmp    803776 <insert_sorted_with_merge_freeList+0x6ff>
  80376c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	a3 38 51 80 00       	mov    %eax,0x805138
  803776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803789:	a1 44 51 80 00       	mov    0x805144,%eax
  80378e:	48                   	dec    %eax
  80378f:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803798:	75 17                	jne    8037b1 <insert_sorted_with_merge_freeList+0x73a>
  80379a:	83 ec 04             	sub    $0x4,%esp
  80379d:	68 b0 43 80 00       	push   $0x8043b0
  8037a2:	68 87 01 00 00       	push   $0x187
  8037a7:	68 d3 43 80 00       	push   $0x8043d3
  8037ac:	e8 04 d3 ff ff       	call   800ab5 <_panic>
  8037b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ba:	89 10                	mov    %edx,(%eax)
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	8b 00                	mov    (%eax),%eax
  8037c1:	85 c0                	test   %eax,%eax
  8037c3:	74 0d                	je     8037d2 <insert_sorted_with_merge_freeList+0x75b>
  8037c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037cd:	89 50 04             	mov    %edx,0x4(%eax)
  8037d0:	eb 08                	jmp    8037da <insert_sorted_with_merge_freeList+0x763>
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f1:	40                   	inc    %eax
  8037f2:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80380b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80380f:	75 17                	jne    803828 <insert_sorted_with_merge_freeList+0x7b1>
  803811:	83 ec 04             	sub    $0x4,%esp
  803814:	68 b0 43 80 00       	push   $0x8043b0
  803819:	68 8a 01 00 00       	push   $0x18a
  80381e:	68 d3 43 80 00       	push   $0x8043d3
  803823:	e8 8d d2 ff ff       	call   800ab5 <_panic>
  803828:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80382e:	8b 45 08             	mov    0x8(%ebp),%eax
  803831:	89 10                	mov    %edx,(%eax)
  803833:	8b 45 08             	mov    0x8(%ebp),%eax
  803836:	8b 00                	mov    (%eax),%eax
  803838:	85 c0                	test   %eax,%eax
  80383a:	74 0d                	je     803849 <insert_sorted_with_merge_freeList+0x7d2>
  80383c:	a1 48 51 80 00       	mov    0x805148,%eax
  803841:	8b 55 08             	mov    0x8(%ebp),%edx
  803844:	89 50 04             	mov    %edx,0x4(%eax)
  803847:	eb 08                	jmp    803851 <insert_sorted_with_merge_freeList+0x7da>
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803851:	8b 45 08             	mov    0x8(%ebp),%eax
  803854:	a3 48 51 80 00       	mov    %eax,0x805148
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803863:	a1 54 51 80 00       	mov    0x805154,%eax
  803868:	40                   	inc    %eax
  803869:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  80386e:	eb 14                	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80387c:	0f 85 72 fb ff ff    	jne    8033f4 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803882:	eb 00                	jmp    803884 <insert_sorted_with_merge_freeList+0x80d>
  803884:	90                   	nop
  803885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803888:	c9                   	leave  
  803889:	c3                   	ret    
  80388a:	66 90                	xchg   %ax,%ax

0080388c <__udivdi3>:
  80388c:	55                   	push   %ebp
  80388d:	57                   	push   %edi
  80388e:	56                   	push   %esi
  80388f:	53                   	push   %ebx
  803890:	83 ec 1c             	sub    $0x1c,%esp
  803893:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803897:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80389b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80389f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038a3:	89 ca                	mov    %ecx,%edx
  8038a5:	89 f8                	mov    %edi,%eax
  8038a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038ab:	85 f6                	test   %esi,%esi
  8038ad:	75 2d                	jne    8038dc <__udivdi3+0x50>
  8038af:	39 cf                	cmp    %ecx,%edi
  8038b1:	77 65                	ja     803918 <__udivdi3+0x8c>
  8038b3:	89 fd                	mov    %edi,%ebp
  8038b5:	85 ff                	test   %edi,%edi
  8038b7:	75 0b                	jne    8038c4 <__udivdi3+0x38>
  8038b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8038be:	31 d2                	xor    %edx,%edx
  8038c0:	f7 f7                	div    %edi
  8038c2:	89 c5                	mov    %eax,%ebp
  8038c4:	31 d2                	xor    %edx,%edx
  8038c6:	89 c8                	mov    %ecx,%eax
  8038c8:	f7 f5                	div    %ebp
  8038ca:	89 c1                	mov    %eax,%ecx
  8038cc:	89 d8                	mov    %ebx,%eax
  8038ce:	f7 f5                	div    %ebp
  8038d0:	89 cf                	mov    %ecx,%edi
  8038d2:	89 fa                	mov    %edi,%edx
  8038d4:	83 c4 1c             	add    $0x1c,%esp
  8038d7:	5b                   	pop    %ebx
  8038d8:	5e                   	pop    %esi
  8038d9:	5f                   	pop    %edi
  8038da:	5d                   	pop    %ebp
  8038db:	c3                   	ret    
  8038dc:	39 ce                	cmp    %ecx,%esi
  8038de:	77 28                	ja     803908 <__udivdi3+0x7c>
  8038e0:	0f bd fe             	bsr    %esi,%edi
  8038e3:	83 f7 1f             	xor    $0x1f,%edi
  8038e6:	75 40                	jne    803928 <__udivdi3+0x9c>
  8038e8:	39 ce                	cmp    %ecx,%esi
  8038ea:	72 0a                	jb     8038f6 <__udivdi3+0x6a>
  8038ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038f0:	0f 87 9e 00 00 00    	ja     803994 <__udivdi3+0x108>
  8038f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038fb:	89 fa                	mov    %edi,%edx
  8038fd:	83 c4 1c             	add    $0x1c,%esp
  803900:	5b                   	pop    %ebx
  803901:	5e                   	pop    %esi
  803902:	5f                   	pop    %edi
  803903:	5d                   	pop    %ebp
  803904:	c3                   	ret    
  803905:	8d 76 00             	lea    0x0(%esi),%esi
  803908:	31 ff                	xor    %edi,%edi
  80390a:	31 c0                	xor    %eax,%eax
  80390c:	89 fa                	mov    %edi,%edx
  80390e:	83 c4 1c             	add    $0x1c,%esp
  803911:	5b                   	pop    %ebx
  803912:	5e                   	pop    %esi
  803913:	5f                   	pop    %edi
  803914:	5d                   	pop    %ebp
  803915:	c3                   	ret    
  803916:	66 90                	xchg   %ax,%ax
  803918:	89 d8                	mov    %ebx,%eax
  80391a:	f7 f7                	div    %edi
  80391c:	31 ff                	xor    %edi,%edi
  80391e:	89 fa                	mov    %edi,%edx
  803920:	83 c4 1c             	add    $0x1c,%esp
  803923:	5b                   	pop    %ebx
  803924:	5e                   	pop    %esi
  803925:	5f                   	pop    %edi
  803926:	5d                   	pop    %ebp
  803927:	c3                   	ret    
  803928:	bd 20 00 00 00       	mov    $0x20,%ebp
  80392d:	89 eb                	mov    %ebp,%ebx
  80392f:	29 fb                	sub    %edi,%ebx
  803931:	89 f9                	mov    %edi,%ecx
  803933:	d3 e6                	shl    %cl,%esi
  803935:	89 c5                	mov    %eax,%ebp
  803937:	88 d9                	mov    %bl,%cl
  803939:	d3 ed                	shr    %cl,%ebp
  80393b:	89 e9                	mov    %ebp,%ecx
  80393d:	09 f1                	or     %esi,%ecx
  80393f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803943:	89 f9                	mov    %edi,%ecx
  803945:	d3 e0                	shl    %cl,%eax
  803947:	89 c5                	mov    %eax,%ebp
  803949:	89 d6                	mov    %edx,%esi
  80394b:	88 d9                	mov    %bl,%cl
  80394d:	d3 ee                	shr    %cl,%esi
  80394f:	89 f9                	mov    %edi,%ecx
  803951:	d3 e2                	shl    %cl,%edx
  803953:	8b 44 24 08          	mov    0x8(%esp),%eax
  803957:	88 d9                	mov    %bl,%cl
  803959:	d3 e8                	shr    %cl,%eax
  80395b:	09 c2                	or     %eax,%edx
  80395d:	89 d0                	mov    %edx,%eax
  80395f:	89 f2                	mov    %esi,%edx
  803961:	f7 74 24 0c          	divl   0xc(%esp)
  803965:	89 d6                	mov    %edx,%esi
  803967:	89 c3                	mov    %eax,%ebx
  803969:	f7 e5                	mul    %ebp
  80396b:	39 d6                	cmp    %edx,%esi
  80396d:	72 19                	jb     803988 <__udivdi3+0xfc>
  80396f:	74 0b                	je     80397c <__udivdi3+0xf0>
  803971:	89 d8                	mov    %ebx,%eax
  803973:	31 ff                	xor    %edi,%edi
  803975:	e9 58 ff ff ff       	jmp    8038d2 <__udivdi3+0x46>
  80397a:	66 90                	xchg   %ax,%ax
  80397c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803980:	89 f9                	mov    %edi,%ecx
  803982:	d3 e2                	shl    %cl,%edx
  803984:	39 c2                	cmp    %eax,%edx
  803986:	73 e9                	jae    803971 <__udivdi3+0xe5>
  803988:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80398b:	31 ff                	xor    %edi,%edi
  80398d:	e9 40 ff ff ff       	jmp    8038d2 <__udivdi3+0x46>
  803992:	66 90                	xchg   %ax,%ax
  803994:	31 c0                	xor    %eax,%eax
  803996:	e9 37 ff ff ff       	jmp    8038d2 <__udivdi3+0x46>
  80399b:	90                   	nop

0080399c <__umoddi3>:
  80399c:	55                   	push   %ebp
  80399d:	57                   	push   %edi
  80399e:	56                   	push   %esi
  80399f:	53                   	push   %ebx
  8039a0:	83 ec 1c             	sub    $0x1c,%esp
  8039a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039bb:	89 f3                	mov    %esi,%ebx
  8039bd:	89 fa                	mov    %edi,%edx
  8039bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039c3:	89 34 24             	mov    %esi,(%esp)
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	75 1a                	jne    8039e4 <__umoddi3+0x48>
  8039ca:	39 f7                	cmp    %esi,%edi
  8039cc:	0f 86 a2 00 00 00    	jbe    803a74 <__umoddi3+0xd8>
  8039d2:	89 c8                	mov    %ecx,%eax
  8039d4:	89 f2                	mov    %esi,%edx
  8039d6:	f7 f7                	div    %edi
  8039d8:	89 d0                	mov    %edx,%eax
  8039da:	31 d2                	xor    %edx,%edx
  8039dc:	83 c4 1c             	add    $0x1c,%esp
  8039df:	5b                   	pop    %ebx
  8039e0:	5e                   	pop    %esi
  8039e1:	5f                   	pop    %edi
  8039e2:	5d                   	pop    %ebp
  8039e3:	c3                   	ret    
  8039e4:	39 f0                	cmp    %esi,%eax
  8039e6:	0f 87 ac 00 00 00    	ja     803a98 <__umoddi3+0xfc>
  8039ec:	0f bd e8             	bsr    %eax,%ebp
  8039ef:	83 f5 1f             	xor    $0x1f,%ebp
  8039f2:	0f 84 ac 00 00 00    	je     803aa4 <__umoddi3+0x108>
  8039f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8039fd:	29 ef                	sub    %ebp,%edi
  8039ff:	89 fe                	mov    %edi,%esi
  803a01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a05:	89 e9                	mov    %ebp,%ecx
  803a07:	d3 e0                	shl    %cl,%eax
  803a09:	89 d7                	mov    %edx,%edi
  803a0b:	89 f1                	mov    %esi,%ecx
  803a0d:	d3 ef                	shr    %cl,%edi
  803a0f:	09 c7                	or     %eax,%edi
  803a11:	89 e9                	mov    %ebp,%ecx
  803a13:	d3 e2                	shl    %cl,%edx
  803a15:	89 14 24             	mov    %edx,(%esp)
  803a18:	89 d8                	mov    %ebx,%eax
  803a1a:	d3 e0                	shl    %cl,%eax
  803a1c:	89 c2                	mov    %eax,%edx
  803a1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a22:	d3 e0                	shl    %cl,%eax
  803a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a28:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a2c:	89 f1                	mov    %esi,%ecx
  803a2e:	d3 e8                	shr    %cl,%eax
  803a30:	09 d0                	or     %edx,%eax
  803a32:	d3 eb                	shr    %cl,%ebx
  803a34:	89 da                	mov    %ebx,%edx
  803a36:	f7 f7                	div    %edi
  803a38:	89 d3                	mov    %edx,%ebx
  803a3a:	f7 24 24             	mull   (%esp)
  803a3d:	89 c6                	mov    %eax,%esi
  803a3f:	89 d1                	mov    %edx,%ecx
  803a41:	39 d3                	cmp    %edx,%ebx
  803a43:	0f 82 87 00 00 00    	jb     803ad0 <__umoddi3+0x134>
  803a49:	0f 84 91 00 00 00    	je     803ae0 <__umoddi3+0x144>
  803a4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a53:	29 f2                	sub    %esi,%edx
  803a55:	19 cb                	sbb    %ecx,%ebx
  803a57:	89 d8                	mov    %ebx,%eax
  803a59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a5d:	d3 e0                	shl    %cl,%eax
  803a5f:	89 e9                	mov    %ebp,%ecx
  803a61:	d3 ea                	shr    %cl,%edx
  803a63:	09 d0                	or     %edx,%eax
  803a65:	89 e9                	mov    %ebp,%ecx
  803a67:	d3 eb                	shr    %cl,%ebx
  803a69:	89 da                	mov    %ebx,%edx
  803a6b:	83 c4 1c             	add    $0x1c,%esp
  803a6e:	5b                   	pop    %ebx
  803a6f:	5e                   	pop    %esi
  803a70:	5f                   	pop    %edi
  803a71:	5d                   	pop    %ebp
  803a72:	c3                   	ret    
  803a73:	90                   	nop
  803a74:	89 fd                	mov    %edi,%ebp
  803a76:	85 ff                	test   %edi,%edi
  803a78:	75 0b                	jne    803a85 <__umoddi3+0xe9>
  803a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7f:	31 d2                	xor    %edx,%edx
  803a81:	f7 f7                	div    %edi
  803a83:	89 c5                	mov    %eax,%ebp
  803a85:	89 f0                	mov    %esi,%eax
  803a87:	31 d2                	xor    %edx,%edx
  803a89:	f7 f5                	div    %ebp
  803a8b:	89 c8                	mov    %ecx,%eax
  803a8d:	f7 f5                	div    %ebp
  803a8f:	89 d0                	mov    %edx,%eax
  803a91:	e9 44 ff ff ff       	jmp    8039da <__umoddi3+0x3e>
  803a96:	66 90                	xchg   %ax,%ax
  803a98:	89 c8                	mov    %ecx,%eax
  803a9a:	89 f2                	mov    %esi,%edx
  803a9c:	83 c4 1c             	add    $0x1c,%esp
  803a9f:	5b                   	pop    %ebx
  803aa0:	5e                   	pop    %esi
  803aa1:	5f                   	pop    %edi
  803aa2:	5d                   	pop    %ebp
  803aa3:	c3                   	ret    
  803aa4:	3b 04 24             	cmp    (%esp),%eax
  803aa7:	72 06                	jb     803aaf <__umoddi3+0x113>
  803aa9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aad:	77 0f                	ja     803abe <__umoddi3+0x122>
  803aaf:	89 f2                	mov    %esi,%edx
  803ab1:	29 f9                	sub    %edi,%ecx
  803ab3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ab7:	89 14 24             	mov    %edx,(%esp)
  803aba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803abe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ac2:	8b 14 24             	mov    (%esp),%edx
  803ac5:	83 c4 1c             	add    $0x1c,%esp
  803ac8:	5b                   	pop    %ebx
  803ac9:	5e                   	pop    %esi
  803aca:	5f                   	pop    %edi
  803acb:	5d                   	pop    %ebp
  803acc:	c3                   	ret    
  803acd:	8d 76 00             	lea    0x0(%esi),%esi
  803ad0:	2b 04 24             	sub    (%esp),%eax
  803ad3:	19 fa                	sbb    %edi,%edx
  803ad5:	89 d1                	mov    %edx,%ecx
  803ad7:	89 c6                	mov    %eax,%esi
  803ad9:	e9 71 ff ff ff       	jmp    803a4f <__umoddi3+0xb3>
  803ade:	66 90                	xchg   %ax,%ax
  803ae0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ae4:	72 ea                	jb     803ad0 <__umoddi3+0x134>
  803ae6:	89 d9                	mov    %ebx,%ecx
  803ae8:	e9 62 ff ff ff       	jmp    803a4f <__umoddi3+0xb3>
