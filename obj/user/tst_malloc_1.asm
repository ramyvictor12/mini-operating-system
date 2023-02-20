
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
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
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 20 37 80 00       	push   $0x803720
  800092:	6a 14                	push   $0x14
  800094:	68 3c 37 80 00       	push   $0x80373c
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 3d 18 00 00       	call   8018e5 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 7a 1c 00 00       	call   801d49 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 12 1d 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 fa 17 00 00       	call   8018e5 <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 50 37 80 00       	push   $0x803750
  80010a:	6a 23                	push   $0x23
  80010c:	68 3c 37 80 00       	push   $0x80373c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 2e 1c 00 00       	call   801d49 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 80 37 80 00       	push   $0x803780
  80012c:	6a 27                	push   $0x27
  80012e:	68 3c 37 80 00       	push   $0x80373c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 ac 1c 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 ec 37 80 00       	push   $0x8037ec
  80014a:	6a 28                	push   $0x28
  80014c:	68 3c 37 80 00       	push   $0x80373c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 ee 1b 00 00       	call   801d49 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 86 1c 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 6e 17 00 00       	call   8018e5 <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 50 37 80 00       	push   $0x803750
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 3c 37 80 00       	push   $0x80373c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 8d 1b 00 00       	call   801d49 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 80 37 80 00       	push   $0x803780
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 3c 37 80 00       	push   $0x80373c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 0b 1c 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ec 37 80 00       	push   $0x8037ec
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 3c 37 80 00       	push   $0x80373c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 4d 1b 00 00       	call   801d49 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 e5 1b 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 cc 16 00 00       	call   8018e5 <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 50 37 80 00       	push   $0x803750
  80024f:	6a 35                	push   $0x35
  800251:	68 3c 37 80 00       	push   $0x80373c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 e9 1a 00 00       	call   801d49 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 80 37 80 00       	push   $0x803780
  800271:	6a 37                	push   $0x37
  800273:	68 3c 37 80 00       	push   $0x80373c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 67 1b 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ec 37 80 00       	push   $0x8037ec
  80028f:	6a 38                	push   $0x38
  800291:	68 3c 37 80 00       	push   $0x80373c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 a9 1a 00 00       	call   801d49 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 41 1b 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 28 16 00 00       	call   8018e5 <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 50 37 80 00       	push   $0x803750
  800307:	6a 3d                	push   $0x3d
  800309:	68 3c 37 80 00       	push   $0x80373c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 31 1a 00 00       	call   801d49 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 80 37 80 00       	push   $0x803780
  800329:	6a 3f                	push   $0x3f
  80032b:	68 3c 37 80 00       	push   $0x80373c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 af 1a 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 ec 37 80 00       	push   $0x8037ec
  800347:	6a 40                	push   $0x40
  800349:	68 3c 37 80 00       	push   $0x80373c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 f1 19 00 00       	call   801d49 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 89 1a 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 6c 15 00 00       	call   8018e5 <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 50 37 80 00       	push   $0x803750
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 3c 37 80 00       	push   $0x80373c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 75 19 00 00       	call   801d49 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 80 37 80 00       	push   $0x803780
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 3c 37 80 00       	push   $0x80373c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 f3 19 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 ec 37 80 00       	push   $0x8037ec
  800403:	6a 48                	push   $0x48
  800405:	68 3c 37 80 00       	push   $0x80373c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 35 19 00 00       	call   801d49 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 cd 19 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 b1 14 00 00       	call   8018e5 <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 50 37 80 00       	push   $0x803750
  80047e:	6a 4d                	push   $0x4d
  800480:	68 3c 37 80 00       	push   $0x80373c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 ba 18 00 00       	call   801d49 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 1a 38 80 00       	push   $0x80381a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 3c 37 80 00       	push   $0x80373c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 38 19 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 ec 37 80 00       	push   $0x8037ec
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 3c 37 80 00       	push   $0x80373c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 7a 18 00 00       	call   801d49 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 12 19 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 fa 13 00 00       	call   8018e5 <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 50 37 80 00       	push   $0x803750
  800543:	6a 54                	push   $0x54
  800545:	68 3c 37 80 00       	push   $0x80373c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 f5 17 00 00       	call   801d49 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 1a 38 80 00       	push   $0x80381a
  800565:	6a 55                	push   $0x55
  800567:	68 3c 37 80 00       	push   $0x80373c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 73 18 00 00       	call   801de9 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 ec 37 80 00       	push   $0x8037ec
  800583:	6a 56                	push   $0x56
  800585:	68 3c 37 80 00       	push   $0x80373c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 30 38 80 00       	push   $0x803830
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 79 1a 00 00       	call   802029 <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 1b 18 00 00       	call   801e36 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 84 38 80 00       	push   $0x803884
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 50 80 00       	mov    0x805020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 ac 38 80 00       	push   $0x8038ac
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 50 80 00       	mov    0x805020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 50 80 00       	mov    0x805020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 d4 38 80 00       	push   $0x8038d4
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 2c 39 80 00       	push   $0x80392c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 84 38 80 00       	push   $0x803884
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 9b 17 00 00       	call   801e50 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 28 19 00 00       	call   801ff5 <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 7d 19 00 00       	call   80205b <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 40 39 80 00       	push   $0x803940
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 45 39 80 00       	push   $0x803945
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 61 39 80 00       	push   $0x803961
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 50 80 00       	mov    0x805020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 64 39 80 00       	push   $0x803964
  800770:	6a 26                	push   $0x26
  800772:	68 b0 39 80 00       	push   $0x8039b0
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 bc 39 80 00       	push   $0x8039bc
  800842:	6a 3a                	push   $0x3a
  800844:	68 b0 39 80 00       	push   $0x8039b0
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 50 80 00       	mov    0x805020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 50 80 00       	mov    0x805020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 10 3a 80 00       	push   $0x803a10
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 b0 39 80 00       	push   $0x8039b0
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 50 80 00       	mov    0x805024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 7c 13 00 00       	call   801c88 <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 50 80 00       	mov    0x805024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 05 13 00 00       	call   801c88 <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 69 14 00 00       	call   801e36 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 63 14 00 00       	call   801e50 <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 81 2a 00 00       	call   8034b8 <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 41 2b 00 00       	call   8035c8 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 74 3c 80 00       	add    $0x803c74,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 85 3c 80 00       	push   $0x803c85
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 8e 3c 80 00       	push   $0x803c8e
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 50 80 00       	mov    0x805004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 f0 3d 80 00       	push   $0x803df0
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801756:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80175d:	00 00 00 
  801760:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801767:	00 00 00 
  80176a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801771:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801774:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80177b:	00 00 00 
  80177e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801785:	00 00 00 
  801788:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80178f:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801792:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801799:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80179c:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8017a3:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8017aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b7:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8017bc:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8017c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017cb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	6a 06                	push   $0x6
  8017d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d8:	50                   	push   %eax
  8017d9:	e8 ee 05 00 00       	call   801dcc <sys_allocate_chunk>
  8017de:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e1:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	50                   	push   %eax
  8017ea:	e8 63 0c 00 00       	call   802452 <initialize_MemBlocksList>
  8017ef:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8017f2:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8017f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8017fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801807:	8b 40 0c             	mov    0xc(%eax),%eax
  80180a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80180d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801810:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801815:	89 c2                	mov    %eax,%edx
  801817:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181a:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80181d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801820:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801827:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80182e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801831:	8b 50 08             	mov    0x8(%eax),%edx
  801834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	48                   	dec    %eax
  80183a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80183d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801840:	ba 00 00 00 00       	mov    $0x0,%edx
  801845:	f7 75 e0             	divl   -0x20(%ebp)
  801848:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80184b:	29 d0                	sub    %edx,%eax
  80184d:	89 c2                	mov    %eax,%edx
  80184f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801852:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801859:	75 14                	jne    80186f <initialize_dyn_block_system+0x11f>
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	68 15 3e 80 00       	push   $0x803e15
  801863:	6a 34                	push   $0x34
  801865:	68 33 3e 80 00       	push   $0x803e33
  80186a:	e8 72 ee ff ff       	call   8006e1 <_panic>
  80186f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801872:	8b 00                	mov    (%eax),%eax
  801874:	85 c0                	test   %eax,%eax
  801876:	74 10                	je     801888 <initialize_dyn_block_system+0x138>
  801878:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187b:	8b 00                	mov    (%eax),%eax
  80187d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801880:	8b 52 04             	mov    0x4(%edx),%edx
  801883:	89 50 04             	mov    %edx,0x4(%eax)
  801886:	eb 0b                	jmp    801893 <initialize_dyn_block_system+0x143>
  801888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188b:	8b 40 04             	mov    0x4(%eax),%eax
  80188e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801896:	8b 40 04             	mov    0x4(%eax),%eax
  801899:	85 c0                	test   %eax,%eax
  80189b:	74 0f                	je     8018ac <initialize_dyn_block_system+0x15c>
  80189d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a0:	8b 40 04             	mov    0x4(%eax),%eax
  8018a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018a6:	8b 12                	mov    (%edx),%edx
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	eb 0a                	jmp    8018b6 <initialize_dyn_block_system+0x166>
  8018ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018af:	8b 00                	mov    (%eax),%eax
  8018b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8018b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8018ce:	48                   	dec    %eax
  8018cf:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8018da:	e8 c4 13 00 00       	call   802ca3 <insert_sorted_with_merge_freeList>
  8018df:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018e2:	90                   	nop
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018eb:	e8 2f fe ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  8018f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f4:	75 07                	jne    8018fd <malloc+0x18>
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	eb 71                	jmp    80196e <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8018fd:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801904:	76 07                	jbe    80190d <malloc+0x28>
	return NULL;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	eb 61                	jmp    80196e <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80190d:	e8 88 08 00 00       	call   80219a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801912:	85 c0                	test   %eax,%eax
  801914:	74 53                	je     801969 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801916:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80191d:	8b 55 08             	mov    0x8(%ebp),%edx
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	48                   	dec    %eax
  801926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	ba 00 00 00 00       	mov    $0x0,%edx
  801931:	f7 75 f4             	divl   -0xc(%ebp)
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	29 d0                	sub    %edx,%eax
  801939:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 ec             	pushl  -0x14(%ebp)
  801942:	e8 d2 0d 00 00       	call   802719 <alloc_block_FF>
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80194d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801951:	74 16                	je     801969 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	ff 75 e8             	pushl  -0x18(%ebp)
  801959:	e8 0c 0c 00 00       	call   80256a <insert_sorted_allocList>
  80195e:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801964:	8b 40 08             	mov    0x8(%eax),%eax
  801967:	eb 05                	jmp    80196e <malloc+0x89>
    }

			}


	return NULL;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801984:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	ff 75 f0             	pushl  -0x10(%ebp)
  80198d:	68 40 50 80 00       	push   $0x805040
  801992:	e8 a0 0b 00 00       	call   802537 <find_block>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80199d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	e8 e4 03 00 00       	call   801d94 <sys_free_user_mem>
  8019b0:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8019b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019b7:	75 17                	jne    8019d0 <free+0x60>
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 15 3e 80 00       	push   $0x803e15
  8019c1:	68 84 00 00 00       	push   $0x84
  8019c6:	68 33 3e 80 00       	push   $0x803e33
  8019cb:	e8 11 ed ff ff       	call   8006e1 <_panic>
  8019d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	74 10                	je     8019e9 <free+0x79>
  8019d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019dc:	8b 00                	mov    (%eax),%eax
  8019de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019e1:	8b 52 04             	mov    0x4(%edx),%edx
  8019e4:	89 50 04             	mov    %edx,0x4(%eax)
  8019e7:	eb 0b                	jmp    8019f4 <free+0x84>
  8019e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ec:	8b 40 04             	mov    0x4(%eax),%eax
  8019ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8019f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f7:	8b 40 04             	mov    0x4(%eax),%eax
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	74 0f                	je     801a0d <free+0x9d>
  8019fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a01:	8b 40 04             	mov    0x4(%eax),%eax
  801a04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a07:	8b 12                	mov    (%edx),%edx
  801a09:	89 10                	mov    %edx,(%eax)
  801a0b:	eb 0a                	jmp    801a17 <free+0xa7>
  801a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a10:	8b 00                	mov    (%eax),%eax
  801a12:	a3 40 50 80 00       	mov    %eax,0x805040
  801a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a2a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a2f:	48                   	dec    %eax
  801a30:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	ff 75 ec             	pushl  -0x14(%ebp)
  801a3b:	e8 63 12 00 00       	call   802ca3 <insert_sorted_with_merge_freeList>
  801a40:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 38             	sub    $0x38,%esp
  801a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a52:	e8 c8 fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801a57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a5b:	75 0a                	jne    801a67 <smalloc+0x21>
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a62:	e9 a0 00 00 00       	jmp    801b07 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801a67:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801a6e:	76 0a                	jbe    801a7a <smalloc+0x34>
		return NULL;
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	e9 8d 00 00 00       	jmp    801b07 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a7a:	e8 1b 07 00 00       	call   80219a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	74 7f                	je     801b02 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801a83:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a90:	01 d0                	add    %edx,%eax
  801a92:	48                   	dec    %eax
  801a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a99:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9e:	f7 75 f4             	divl   -0xc(%ebp)
  801aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa4:	29 d0                	sub    %edx,%eax
  801aa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	ff 75 ec             	pushl  -0x14(%ebp)
  801aaf:	e8 65 0c 00 00       	call   802719 <alloc_block_FF>
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801aba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801abe:	74 42                	je     801b02 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ac6:	e8 9f 0a 00 00       	call   80256a <insert_sorted_allocList>
  801acb:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad1:	8b 40 08             	mov    0x8(%eax),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	ff 75 08             	pushl  0x8(%ebp)
  801ae2:	e8 38 04 00 00       	call   801f1f <sys_createSharedObject>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801aed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801af1:	79 07                	jns    801afa <smalloc+0xb4>
	    		  return NULL;
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax
  801af8:	eb 0d                	jmp    801b07 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801afd:	8b 40 08             	mov    0x8(%eax),%eax
  801b00:	eb 05                	jmp    801b07 <smalloc+0xc1>


				}


		return NULL;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b0f:	e8 0b fc ff ff       	call   80171f <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b14:	e8 81 06 00 00       	call   80219a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	0f 84 9f 00 00 00    	je     801bc0 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b21:	83 ec 08             	sub    $0x8,%esp
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	e8 1a 04 00 00       	call   801f49 <sys_getSizeOfSharedObject>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b39:	79 0a                	jns    801b45 <sget+0x3c>
		return NULL;
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b40:	e9 80 00 00 00       	jmp    801bc5 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b45:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	48                   	dec    %eax
  801b55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b60:	f7 75 f0             	divl   -0x10(%ebp)
  801b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b66:	29 d0                	sub    %edx,%eax
  801b68:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801b6b:	83 ec 0c             	sub    $0xc,%esp
  801b6e:	ff 75 e8             	pushl  -0x18(%ebp)
  801b71:	e8 a3 0b 00 00       	call   802719 <alloc_block_FF>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801b7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b80:	74 3e                	je     801bc0 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b88:	e8 dd 09 00 00       	call   80256a <insert_sorted_allocList>
  801b8d:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b93:	8b 40 08             	mov    0x8(%eax),%eax
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	50                   	push   %eax
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	e8 c1 03 00 00       	call   801f66 <sys_getSharedObject>
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801bab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801baf:	79 07                	jns    801bb8 <sget+0xaf>
	    		  return NULL;
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb6:	eb 0d                	jmp    801bc5 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbb:	8b 40 08             	mov    0x8(%eax),%eax
  801bbe:	eb 05                	jmp    801bc5 <sget+0xbc>
	      }
	}
	   return NULL;
  801bc0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bcd:	e8 4d fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	68 40 3e 80 00       	push   $0x803e40
  801bda:	68 12 01 00 00       	push   $0x112
  801bdf:	68 33 3e 80 00       	push   $0x803e33
  801be4:	e8 f8 ea ff ff       	call   8006e1 <_panic>

00801be9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 68 3e 80 00       	push   $0x803e68
  801bf7:	68 26 01 00 00       	push   $0x126
  801bfc:	68 33 3e 80 00       	push   $0x803e33
  801c01:	e8 db ea ff ff       	call   8006e1 <_panic>

00801c06 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	68 8c 3e 80 00       	push   $0x803e8c
  801c14:	68 31 01 00 00       	push   $0x131
  801c19:	68 33 3e 80 00       	push   $0x803e33
  801c1e:	e8 be ea ff ff       	call   8006e1 <_panic>

00801c23 <shrink>:

}
void shrink(uint32 newSize)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	68 8c 3e 80 00       	push   $0x803e8c
  801c31:	68 36 01 00 00       	push   $0x136
  801c36:	68 33 3e 80 00       	push   $0x803e33
  801c3b:	e8 a1 ea ff ff       	call   8006e1 <_panic>

00801c40 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	68 8c 3e 80 00       	push   $0x803e8c
  801c4e:	68 3b 01 00 00       	push   $0x13b
  801c53:	68 33 3e 80 00       	push   $0x803e33
  801c58:	e8 84 ea ff ff       	call   8006e1 <_panic>

00801c5d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	57                   	push   %edi
  801c61:	56                   	push   %esi
  801c62:	53                   	push   %ebx
  801c63:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c72:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c75:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c78:	cd 30                	int    $0x30
  801c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5f                   	pop    %edi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    

00801c88 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c94:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	52                   	push   %edx
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	50                   	push   %eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	e8 b2 ff ff ff       	call   801c5d <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 01                	push   $0x1
  801cc0:	e8 98 ff ff ff       	call   801c5d <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	6a 05                	push   $0x5
  801cdd:	e8 7b ff ff ff       	call   801c5d <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	56                   	push   %esi
  801ceb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cec:	8b 75 18             	mov    0x18(%ebp),%esi
  801cef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	56                   	push   %esi
  801cfc:	53                   	push   %ebx
  801cfd:	51                   	push   %ecx
  801cfe:	52                   	push   %edx
  801cff:	50                   	push   %eax
  801d00:	6a 06                	push   $0x6
  801d02:	e8 56 ff ff ff       	call   801c5d <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	52                   	push   %edx
  801d21:	50                   	push   %eax
  801d22:	6a 07                	push   $0x7
  801d24:	e8 34 ff ff ff       	call   801c5d <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 0c             	pushl  0xc(%ebp)
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	6a 08                	push   $0x8
  801d3f:	e8 19 ff ff ff       	call   801c5d <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 09                	push   $0x9
  801d58:	e8 00 ff ff ff       	call   801c5d <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 0a                	push   $0xa
  801d71:	e8 e7 fe ff ff       	call   801c5d <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 0b                	push   $0xb
  801d8a:	e8 ce fe ff ff       	call   801c5d <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	ff 75 0c             	pushl  0xc(%ebp)
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	6a 0f                	push   $0xf
  801da5:	e8 b3 fe ff ff       	call   801c5d <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return;
  801dad:	90                   	nop
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	ff 75 08             	pushl  0x8(%ebp)
  801dbf:	6a 10                	push   $0x10
  801dc1:	e8 97 fe ff ff       	call   801c5d <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc9:	90                   	nop
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	ff 75 10             	pushl  0x10(%ebp)
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	6a 11                	push   $0x11
  801dde:	e8 7a fe ff ff       	call   801c5d <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
	return ;
  801de6:	90                   	nop
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 0c                	push   $0xc
  801df8:	e8 60 fe ff ff       	call   801c5d <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 08             	pushl  0x8(%ebp)
  801e10:	6a 0d                	push   $0xd
  801e12:	e8 46 fe ff ff       	call   801c5d <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 0e                	push   $0xe
  801e2b:	e8 2d fe ff ff       	call   801c5d <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 13                	push   $0x13
  801e45:	e8 13 fe ff ff       	call   801c5d <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 14                	push   $0x14
  801e5f:	e8 f9 fd ff ff       	call   801c5d <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	90                   	nop
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_cputc>:


void
sys_cputc(const char c)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e76:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	50                   	push   %eax
  801e83:	6a 15                	push   $0x15
  801e85:	e8 d3 fd ff ff       	call   801c5d <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	90                   	nop
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 16                	push   $0x16
  801e9f:	e8 b9 fd ff ff       	call   801c5d <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
}
  801ea7:	90                   	nop
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	50                   	push   %eax
  801eba:	6a 17                	push   $0x17
  801ebc:	e8 9c fd ff ff       	call   801c5d <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	6a 1a                	push   $0x1a
  801ed9:	e8 7f fd ff ff       	call   801c5d <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	6a 18                	push   $0x18
  801ef6:	e8 62 fd ff ff       	call   801c5d <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	90                   	nop
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 19                	push   $0x19
  801f14:	e8 44 fd ff ff       	call   801c5d <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	90                   	nop
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 04             	sub    $0x4,%esp
  801f25:	8b 45 10             	mov    0x10(%ebp),%eax
  801f28:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f2b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f2e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	6a 00                	push   $0x0
  801f37:	51                   	push   %ecx
  801f38:	52                   	push   %edx
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	50                   	push   %eax
  801f3d:	6a 1b                	push   $0x1b
  801f3f:	e8 19 fd ff ff       	call   801c5d <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	52                   	push   %edx
  801f59:	50                   	push   %eax
  801f5a:	6a 1c                	push   $0x1c
  801f5c:	e8 fc fc ff ff       	call   801c5d <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	51                   	push   %ecx
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 1d                	push   $0x1d
  801f7b:	e8 dd fc ff ff       	call   801c5d <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	52                   	push   %edx
  801f95:	50                   	push   %eax
  801f96:	6a 1e                	push   $0x1e
  801f98:	e8 c0 fc ff ff       	call   801c5d <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 1f                	push   $0x1f
  801fb1:	e8 a7 fc ff ff       	call   801c5d <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	ff 75 14             	pushl  0x14(%ebp)
  801fc6:	ff 75 10             	pushl  0x10(%ebp)
  801fc9:	ff 75 0c             	pushl  0xc(%ebp)
  801fcc:	50                   	push   %eax
  801fcd:	6a 20                	push   $0x20
  801fcf:	e8 89 fc ff ff       	call   801c5d <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	50                   	push   %eax
  801fe8:	6a 21                	push   $0x21
  801fea:	e8 6e fc ff ff       	call   801c5d <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	90                   	nop
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	50                   	push   %eax
  802004:	6a 22                	push   $0x22
  802006:	e8 52 fc ff ff       	call   801c5d <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 02                	push   $0x2
  80201f:	e8 39 fc ff ff       	call   801c5d <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 03                	push   $0x3
  802038:	e8 20 fc ff ff       	call   801c5d <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 04                	push   $0x4
  802051:	e8 07 fc ff ff       	call   801c5d <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_exit_env>:


void sys_exit_env(void)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 23                	push   $0x23
  80206a:	e8 ee fb ff ff       	call   801c5d <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	90                   	nop
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80207b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80207e:	8d 50 04             	lea    0x4(%eax),%edx
  802081:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	52                   	push   %edx
  80208b:	50                   	push   %eax
  80208c:	6a 24                	push   $0x24
  80208e:	e8 ca fb ff ff       	call   801c5d <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
	return result;
  802096:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80209c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80209f:	89 01                	mov    %eax,(%ecx)
  8020a1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	c9                   	leave  
  8020a8:	c2 04 00             	ret    $0x4

008020ab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	ff 75 10             	pushl  0x10(%ebp)
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	6a 12                	push   $0x12
  8020bd:	e8 9b fb ff ff       	call   801c5d <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c5:	90                   	nop
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 25                	push   $0x25
  8020d7:	e8 81 fb ff ff       	call   801c5d <syscall>
  8020dc:	83 c4 18             	add    $0x18,%esp
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020ed:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	50                   	push   %eax
  8020fa:	6a 26                	push   $0x26
  8020fc:	e8 5c fb ff ff       	call   801c5d <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return ;
  802104:	90                   	nop
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <rsttst>:
void rsttst()
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 28                	push   $0x28
  802116:	e8 42 fb ff ff       	call   801c5d <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
	return ;
  80211e:	90                   	nop
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	8b 45 14             	mov    0x14(%ebp),%eax
  80212a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80212d:	8b 55 18             	mov    0x18(%ebp),%edx
  802130:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802134:	52                   	push   %edx
  802135:	50                   	push   %eax
  802136:	ff 75 10             	pushl  0x10(%ebp)
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	6a 27                	push   $0x27
  802141:	e8 17 fb ff ff       	call   801c5d <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
	return ;
  802149:	90                   	nop
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <chktst>:
void chktst(uint32 n)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	ff 75 08             	pushl  0x8(%ebp)
  80215a:	6a 29                	push   $0x29
  80215c:	e8 fc fa ff ff       	call   801c5d <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
	return ;
  802164:	90                   	nop
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <inctst>:

void inctst()
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 2a                	push   $0x2a
  802176:	e8 e2 fa ff ff       	call   801c5d <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
	return ;
  80217e:	90                   	nop
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <gettst>:
uint32 gettst()
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 2b                	push   $0x2b
  802190:	e8 c8 fa ff ff       	call   801c5d <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 2c                	push   $0x2c
  8021ac:	e8 ac fa ff ff       	call   801c5d <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
  8021b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021b7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021bb:	75 07                	jne    8021c4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c2:	eb 05                	jmp    8021c9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 2c                	push   $0x2c
  8021dd:	e8 7b fa ff ff       	call   801c5d <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
  8021e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021e8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021ec:	75 07                	jne    8021f5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	eb 05                	jmp    8021fa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 2c                	push   $0x2c
  80220e:	e8 4a fa ff ff       	call   801c5d <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
  802216:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802219:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80221d:	75 07                	jne    802226 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80221f:	b8 01 00 00 00       	mov    $0x1,%eax
  802224:	eb 05                	jmp    80222b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 2c                	push   $0x2c
  80223f:	e8 19 fa ff ff       	call   801c5d <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
  802247:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80224a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80224e:	75 07                	jne    802257 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802250:	b8 01 00 00 00       	mov    $0x1,%eax
  802255:	eb 05                	jmp    80225c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	ff 75 08             	pushl  0x8(%ebp)
  80226c:	6a 2d                	push   $0x2d
  80226e:	e8 ea f9 ff ff       	call   801c5d <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
	return ;
  802276:	90                   	nop
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80227d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802280:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	53                   	push   %ebx
  80228c:	51                   	push   %ecx
  80228d:	52                   	push   %edx
  80228e:	50                   	push   %eax
  80228f:	6a 2e                	push   $0x2e
  802291:	e8 c7 f9 ff ff       	call   801c5d <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	52                   	push   %edx
  8022ae:	50                   	push   %eax
  8022af:	6a 2f                	push   $0x2f
  8022b1:	e8 a7 f9 ff ff       	call   801c5d <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022c1:	83 ec 0c             	sub    $0xc,%esp
  8022c4:	68 9c 3e 80 00       	push   $0x803e9c
  8022c9:	e8 c7 e6 ff ff       	call   800995 <cprintf>
  8022ce:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	68 c8 3e 80 00       	push   $0x803ec8
  8022e0:	e8 b0 e6 ff ff       	call   800995 <cprintf>
  8022e5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022e8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8022f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f4:	eb 56                	jmp    80234c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fa:	74 1c                	je     802318 <print_mem_block_lists+0x5d>
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 50 08             	mov    0x8(%eax),%edx
  802302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802305:	8b 48 08             	mov    0x8(%eax),%ecx
  802308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230b:	8b 40 0c             	mov    0xc(%eax),%eax
  80230e:	01 c8                	add    %ecx,%eax
  802310:	39 c2                	cmp    %eax,%edx
  802312:	73 04                	jae    802318 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802314:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 50 08             	mov    0x8(%eax),%edx
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 40 0c             	mov    0xc(%eax),%eax
  802324:	01 c2                	add    %eax,%edx
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 40 08             	mov    0x8(%eax),%eax
  80232c:	83 ec 04             	sub    $0x4,%esp
  80232f:	52                   	push   %edx
  802330:	50                   	push   %eax
  802331:	68 dd 3e 80 00       	push   $0x803edd
  802336:	e8 5a e6 ff ff       	call   800995 <cprintf>
  80233b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802344:	a1 40 51 80 00       	mov    0x805140,%eax
  802349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802350:	74 07                	je     802359 <print_mem_block_lists+0x9e>
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 00                	mov    (%eax),%eax
  802357:	eb 05                	jmp    80235e <print_mem_block_lists+0xa3>
  802359:	b8 00 00 00 00       	mov    $0x0,%eax
  80235e:	a3 40 51 80 00       	mov    %eax,0x805140
  802363:	a1 40 51 80 00       	mov    0x805140,%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	75 8a                	jne    8022f6 <print_mem_block_lists+0x3b>
  80236c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802370:	75 84                	jne    8022f6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802372:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802376:	75 10                	jne    802388 <print_mem_block_lists+0xcd>
  802378:	83 ec 0c             	sub    $0xc,%esp
  80237b:	68 ec 3e 80 00       	push   $0x803eec
  802380:	e8 10 e6 ff ff       	call   800995 <cprintf>
  802385:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80238f:	83 ec 0c             	sub    $0xc,%esp
  802392:	68 10 3f 80 00       	push   $0x803f10
  802397:	e8 f9 e5 ff ff       	call   800995 <cprintf>
  80239c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80239f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ab:	eb 56                	jmp    802403 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b1:	74 1c                	je     8023cf <print_mem_block_lists+0x114>
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 50 08             	mov    0x8(%eax),%edx
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	8b 48 08             	mov    0x8(%eax),%ecx
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c5:	01 c8                	add    %ecx,%eax
  8023c7:	39 c2                	cmp    %eax,%edx
  8023c9:	73 04                	jae    8023cf <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023cb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 50 08             	mov    0x8(%eax),%edx
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023db:	01 c2                	add    %eax,%edx
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 40 08             	mov    0x8(%eax),%eax
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	52                   	push   %edx
  8023e7:	50                   	push   %eax
  8023e8:	68 dd 3e 80 00       	push   $0x803edd
  8023ed:	e8 a3 e5 ff ff       	call   800995 <cprintf>
  8023f2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023fb:	a1 48 50 80 00       	mov    0x805048,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	74 07                	je     802410 <print_mem_block_lists+0x155>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	eb 05                	jmp    802415 <print_mem_block_lists+0x15a>
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	a3 48 50 80 00       	mov    %eax,0x805048
  80241a:	a1 48 50 80 00       	mov    0x805048,%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	75 8a                	jne    8023ad <print_mem_block_lists+0xf2>
  802423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802427:	75 84                	jne    8023ad <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802429:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80242d:	75 10                	jne    80243f <print_mem_block_lists+0x184>
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	68 28 3f 80 00       	push   $0x803f28
  802437:	e8 59 e5 ff ff       	call   800995 <cprintf>
  80243c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80243f:	83 ec 0c             	sub    $0xc,%esp
  802442:	68 9c 3e 80 00       	push   $0x803e9c
  802447:	e8 49 e5 ff ff       	call   800995 <cprintf>
  80244c:	83 c4 10             	add    $0x10,%esp

}
  80244f:	90                   	nop
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802458:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80245f:	00 00 00 
  802462:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802469:	00 00 00 
  80246c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802473:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802476:	a1 50 50 80 00       	mov    0x805050,%eax
  80247b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80247e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802485:	e9 9e 00 00 00       	jmp    802528 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80248a:	a1 50 50 80 00       	mov    0x805050,%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	c1 e2 04             	shl    $0x4,%edx
  802495:	01 d0                	add    %edx,%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 14                	jne    8024af <initialize_MemBlocksList+0x5d>
  80249b:	83 ec 04             	sub    $0x4,%esp
  80249e:	68 50 3f 80 00       	push   $0x803f50
  8024a3:	6a 48                	push   $0x48
  8024a5:	68 73 3f 80 00       	push   $0x803f73
  8024aa:	e8 32 e2 ff ff       	call   8006e1 <_panic>
  8024af:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b7:	c1 e2 04             	shl    $0x4,%edx
  8024ba:	01 d0                	add    %edx,%eax
  8024bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024c2:	89 10                	mov    %edx,(%eax)
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	74 18                	je     8024e2 <initialize_MemBlocksList+0x90>
  8024ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8024cf:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024d8:	c1 e1 04             	shl    $0x4,%ecx
  8024db:	01 ca                	add    %ecx,%edx
  8024dd:	89 50 04             	mov    %edx,0x4(%eax)
  8024e0:	eb 12                	jmp    8024f4 <initialize_MemBlocksList+0xa2>
  8024e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	c1 e2 04             	shl    $0x4,%edx
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024f4:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	c1 e2 04             	shl    $0x4,%edx
  8024ff:	01 d0                	add    %edx,%eax
  802501:	a3 48 51 80 00       	mov    %eax,0x805148
  802506:	a1 50 50 80 00       	mov    0x805050,%eax
  80250b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250e:	c1 e2 04             	shl    $0x4,%edx
  802511:	01 d0                	add    %edx,%eax
  802513:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251a:	a1 54 51 80 00       	mov    0x805154,%eax
  80251f:	40                   	inc    %eax
  802520:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802525:	ff 45 f4             	incl   -0xc(%ebp)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252e:	0f 82 56 ff ff ff    	jb     80248a <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802534:	90                   	nop
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802545:	eb 18                	jmp    80255f <find_block+0x28>
		{
			if(tmp->sva==va)
  802547:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254a:	8b 40 08             	mov    0x8(%eax),%eax
  80254d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802550:	75 05                	jne    802557 <find_block+0x20>
			{
				return tmp;
  802552:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802555:	eb 11                	jmp    802568 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802557:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80255f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802563:	75 e2                	jne    802547 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802565:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802570:	a1 40 50 80 00       	mov    0x805040,%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	0f 85 83 00 00 00    	jne    802600 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80257d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802584:	00 00 00 
  802587:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80258e:	00 00 00 
  802591:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802598:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80259b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80259f:	75 14                	jne    8025b5 <insert_sorted_allocList+0x4b>
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	68 50 3f 80 00       	push   $0x803f50
  8025a9:	6a 7f                	push   $0x7f
  8025ab:	68 73 3f 80 00       	push   $0x803f73
  8025b0:	e8 2c e1 ff ff       	call   8006e1 <_panic>
  8025b5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	89 10                	mov    %edx,(%eax)
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 0d                	je     8025d6 <insert_sorted_allocList+0x6c>
  8025c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d1:	89 50 04             	mov    %edx,0x4(%eax)
  8025d4:	eb 08                	jmp    8025de <insert_sorted_allocList+0x74>
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	a3 44 50 80 00       	mov    %eax,0x805044
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	a3 40 50 80 00       	mov    %eax,0x805040
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f5:	40                   	inc    %eax
  8025f6:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8025fb:	e9 16 01 00 00       	jmp    802716 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	8b 50 08             	mov    0x8(%eax),%edx
  802606:	a1 44 50 80 00       	mov    0x805044,%eax
  80260b:	8b 40 08             	mov    0x8(%eax),%eax
  80260e:	39 c2                	cmp    %eax,%edx
  802610:	76 68                	jbe    80267a <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802616:	75 17                	jne    80262f <insert_sorted_allocList+0xc5>
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	68 8c 3f 80 00       	push   $0x803f8c
  802620:	68 85 00 00 00       	push   $0x85
  802625:	68 73 3f 80 00       	push   $0x803f73
  80262a:	e8 b2 e0 ff ff       	call   8006e1 <_panic>
  80262f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	89 50 04             	mov    %edx,0x4(%eax)
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	74 0c                	je     802651 <insert_sorted_allocList+0xe7>
  802645:	a1 44 50 80 00       	mov    0x805044,%eax
  80264a:	8b 55 08             	mov    0x8(%ebp),%edx
  80264d:	89 10                	mov    %edx,(%eax)
  80264f:	eb 08                	jmp    802659 <insert_sorted_allocList+0xef>
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	a3 40 50 80 00       	mov    %eax,0x805040
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	a3 44 50 80 00       	mov    %eax,0x805044
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80266f:	40                   	inc    %eax
  802670:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802675:	e9 9c 00 00 00       	jmp    802716 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80267a:	a1 40 50 80 00       	mov    0x805040,%eax
  80267f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802682:	e9 85 00 00 00       	jmp    80270c <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8b 50 08             	mov    0x8(%eax),%edx
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 08             	mov    0x8(%eax),%eax
  802693:	39 c2                	cmp    %eax,%edx
  802695:	73 6d                	jae    802704 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	74 06                	je     8026a3 <insert_sorted_allocList+0x139>
  80269d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026a1:	75 17                	jne    8026ba <insert_sorted_allocList+0x150>
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 b0 3f 80 00       	push   $0x803fb0
  8026ab:	68 90 00 00 00       	push   $0x90
  8026b0:	68 73 3f 80 00       	push   $0x803f73
  8026b5:	e8 27 e0 ff ff       	call   8006e1 <_panic>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 50 04             	mov    0x4(%eax),%edx
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	89 50 04             	mov    %edx,0x4(%eax)
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cc:	89 10                	mov    %edx,(%eax)
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 0d                	je     8026e5 <insert_sorted_allocList+0x17b>
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e1:	89 10                	mov    %edx,(%eax)
  8026e3:	eb 08                	jmp    8026ed <insert_sorted_allocList+0x183>
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f3:	89 50 04             	mov    %edx,0x4(%eax)
  8026f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026fb:	40                   	inc    %eax
  8026fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802701:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802702:	eb 12                	jmp    802716 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  80270c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802710:	0f 85 71 ff ff ff    	jne    802687 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802716:	90                   	nop
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80271f:	a1 38 51 80 00       	mov    0x805138,%eax
  802724:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802727:	e9 76 01 00 00       	jmp    8028a2 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	3b 45 08             	cmp    0x8(%ebp),%eax
  802735:	0f 85 8a 00 00 00    	jne    8027c5 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	75 17                	jne    802758 <alloc_block_FF+0x3f>
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	68 e5 3f 80 00       	push   $0x803fe5
  802749:	68 a8 00 00 00       	push   $0xa8
  80274e:	68 73 3f 80 00       	push   $0x803f73
  802753:	e8 89 df ff ff       	call   8006e1 <_panic>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 10                	je     802771 <alloc_block_FF+0x58>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802769:	8b 52 04             	mov    0x4(%edx),%edx
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	eb 0b                	jmp    80277c <alloc_block_FF+0x63>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 0f                	je     802795 <alloc_block_FF+0x7c>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 04             	mov    0x4(%eax),%eax
  80278c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278f:	8b 12                	mov    (%edx),%edx
  802791:	89 10                	mov    %edx,(%eax)
  802793:	eb 0a                	jmp    80279f <alloc_block_FF+0x86>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	a3 38 51 80 00       	mov    %eax,0x805138
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8027b7:	48                   	dec    %eax
  8027b8:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	e9 ea 00 00 00       	jmp    8028af <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ce:	0f 86 c6 00 00 00    	jbe    80289a <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8027dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027df:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e2:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 50 08             	mov    0x8(%eax),%edx
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027fa:	89 c2                	mov    %eax,%edx
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 50 08             	mov    0x8(%eax),%edx
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	01 c2                	add    %eax,%edx
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802817:	75 17                	jne    802830 <alloc_block_FF+0x117>
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	68 e5 3f 80 00       	push   $0x803fe5
  802821:	68 b6 00 00 00       	push   $0xb6
  802826:	68 73 3f 80 00       	push   $0x803f73
  80282b:	e8 b1 de ff ff       	call   8006e1 <_panic>
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	74 10                	je     802849 <alloc_block_FF+0x130>
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802841:	8b 52 04             	mov    0x4(%edx),%edx
  802844:	89 50 04             	mov    %edx,0x4(%eax)
  802847:	eb 0b                	jmp    802854 <alloc_block_FF+0x13b>
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	74 0f                	je     80286d <alloc_block_FF+0x154>
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	8b 40 04             	mov    0x4(%eax),%eax
  802864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802867:	8b 12                	mov    (%edx),%edx
  802869:	89 10                	mov    %edx,(%eax)
  80286b:	eb 0a                	jmp    802877 <alloc_block_FF+0x15e>
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	a3 48 51 80 00       	mov    %eax,0x805148
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802883:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288a:	a1 54 51 80 00       	mov    0x805154,%eax
  80288f:	48                   	dec    %eax
  802890:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	eb 15                	jmp    8028af <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8028a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a6:	0f 85 80 fe ff ff    	jne    80272c <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8028b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8028bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8028bf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8028c6:	e9 c0 00 00 00       	jmp    80298b <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d4:	0f 85 8a 00 00 00    	jne    802964 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8028da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028de:	75 17                	jne    8028f7 <alloc_block_BF+0x46>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 e5 3f 80 00       	push   $0x803fe5
  8028e8:	68 cf 00 00 00       	push   $0xcf
  8028ed:	68 73 3f 80 00       	push   $0x803f73
  8028f2:	e8 ea dd ff ff       	call   8006e1 <_panic>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 10                	je     802910 <alloc_block_BF+0x5f>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802908:	8b 52 04             	mov    0x4(%edx),%edx
  80290b:	89 50 04             	mov    %edx,0x4(%eax)
  80290e:	eb 0b                	jmp    80291b <alloc_block_BF+0x6a>
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0f                	je     802934 <alloc_block_BF+0x83>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292e:	8b 12                	mov    (%edx),%edx
  802930:	89 10                	mov    %edx,(%eax)
  802932:	eb 0a                	jmp    80293e <alloc_block_BF+0x8d>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	a3 38 51 80 00       	mov    %eax,0x805138
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802951:	a1 44 51 80 00       	mov    0x805144,%eax
  802956:	48                   	dec    %eax
  802957:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	e9 2a 01 00 00       	jmp    802a8e <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 0c             	mov    0xc(%eax),%eax
  80296a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80296d:	73 14                	jae    802983 <alloc_block_BF+0xd2>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 0c             	mov    0xc(%eax),%eax
  802975:	3b 45 08             	cmp    0x8(%ebp),%eax
  802978:	76 09                	jbe    802983 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	0f 85 36 ff ff ff    	jne    8028cb <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802995:	a1 38 51 80 00       	mov    0x805138,%eax
  80299a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80299d:	e9 dd 00 00 00       	jmp    802a7f <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029ab:	0f 85 c6 00 00 00    	jne    802a77 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8029b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8029b6:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 50 08             	mov    0x8(%eax),%edx
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 50 08             	mov    0x8(%eax),%edx
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	01 c2                	add    %eax,%edx
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e8:	89 c2                	mov    %eax,%edx
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f4:	75 17                	jne    802a0d <alloc_block_BF+0x15c>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 e5 3f 80 00       	push   $0x803fe5
  8029fe:	68 eb 00 00 00       	push   $0xeb
  802a03:	68 73 3f 80 00       	push   $0x803f73
  802a08:	e8 d4 dc ff ff       	call   8006e1 <_panic>
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 10                	je     802a26 <alloc_block_BF+0x175>
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1e:	8b 52 04             	mov    0x4(%edx),%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 0b                	jmp    802a31 <alloc_block_BF+0x180>
  802a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0f                	je     802a4a <alloc_block_BF+0x199>
  802a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a44:	8b 12                	mov    (%edx),%edx
  802a46:	89 10                	mov    %edx,(%eax)
  802a48:	eb 0a                	jmp    802a54 <alloc_block_BF+0x1a3>
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	a3 48 51 80 00       	mov    %eax,0x805148
  802a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6c:	48                   	dec    %eax
  802a6d:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a75:	eb 17                	jmp    802a8e <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a83:	0f 85 19 ff ff ff    	jne    8029a2 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802a96:	a1 40 50 80 00       	mov    0x805040,%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	75 19                	jne    802ab8 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802a9f:	83 ec 0c             	sub    $0xc,%esp
  802aa2:	ff 75 08             	pushl  0x8(%ebp)
  802aa5:	e8 6f fc ff ff       	call   802719 <alloc_block_FF>
  802aaa:	83 c4 10             	add    $0x10,%esp
  802aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	e9 e9 01 00 00       	jmp    802ca1 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802ab8:	a1 44 50 80 00       	mov    0x805044,%eax
  802abd:	8b 40 08             	mov    0x8(%eax),%eax
  802ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802ac3:	a1 44 50 80 00       	mov    0x805044,%eax
  802ac8:	8b 50 0c             	mov    0xc(%eax),%edx
  802acb:	a1 44 50 80 00       	mov    0x805044,%eax
  802ad0:	8b 40 08             	mov    0x8(%eax),%eax
  802ad3:	01 d0                	add    %edx,%eax
  802ad5:	83 ec 08             	sub    $0x8,%esp
  802ad8:	50                   	push   %eax
  802ad9:	68 38 51 80 00       	push   $0x805138
  802ade:	e8 54 fa ff ff       	call   802537 <find_block>
  802ae3:	83 c4 10             	add    $0x10,%esp
  802ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af2:	0f 85 9b 00 00 00    	jne    802b93 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 50 0c             	mov    0xc(%eax),%edx
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 08             	mov    0x8(%eax),%eax
  802b04:	01 d0                	add    %edx,%eax
  802b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0d:	75 17                	jne    802b26 <alloc_block_NF+0x96>
  802b0f:	83 ec 04             	sub    $0x4,%esp
  802b12:	68 e5 3f 80 00       	push   $0x803fe5
  802b17:	68 1a 01 00 00       	push   $0x11a
  802b1c:	68 73 3f 80 00       	push   $0x803f73
  802b21:	e8 bb db ff ff       	call   8006e1 <_panic>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 10                	je     802b3f <alloc_block_NF+0xaf>
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 00                	mov    (%eax),%eax
  802b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b37:	8b 52 04             	mov    0x4(%edx),%edx
  802b3a:	89 50 04             	mov    %edx,0x4(%eax)
  802b3d:	eb 0b                	jmp    802b4a <alloc_block_NF+0xba>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	85 c0                	test   %eax,%eax
  802b52:	74 0f                	je     802b63 <alloc_block_NF+0xd3>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 04             	mov    0x4(%eax),%eax
  802b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5d:	8b 12                	mov    (%edx),%edx
  802b5f:	89 10                	mov    %edx,(%eax)
  802b61:	eb 0a                	jmp    802b6d <alloc_block_NF+0xdd>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	a3 38 51 80 00       	mov    %eax,0x805138
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b80:	a1 44 51 80 00       	mov    0x805144,%eax
  802b85:	48                   	dec    %eax
  802b86:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	e9 0e 01 00 00       	jmp    802ca1 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9c:	0f 86 cf 00 00 00    	jbe    802c71 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802ba2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 50 08             	mov    0x8(%eax),%edx
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	01 c2                	add    %eax,%edx
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd9:	89 c2                	mov    %eax,%edx
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 40 08             	mov    0x8(%eax),%eax
  802be7:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bee:	75 17                	jne    802c07 <alloc_block_NF+0x177>
  802bf0:	83 ec 04             	sub    $0x4,%esp
  802bf3:	68 e5 3f 80 00       	push   $0x803fe5
  802bf8:	68 28 01 00 00       	push   $0x128
  802bfd:	68 73 3f 80 00       	push   $0x803f73
  802c02:	e8 da da ff ff       	call   8006e1 <_panic>
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 10                	je     802c20 <alloc_block_NF+0x190>
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c18:	8b 52 04             	mov    0x4(%edx),%edx
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	eb 0b                	jmp    802c2b <alloc_block_NF+0x19b>
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	8b 40 04             	mov    0x4(%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	74 0f                	je     802c44 <alloc_block_NF+0x1b4>
  802c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c38:	8b 40 04             	mov    0x4(%eax),%eax
  802c3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3e:	8b 12                	mov    (%edx),%edx
  802c40:	89 10                	mov    %edx,(%eax)
  802c42:	eb 0a                	jmp    802c4e <alloc_block_NF+0x1be>
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	a3 48 51 80 00       	mov    %eax,0x805148
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c61:	a1 54 51 80 00       	mov    0x805154,%eax
  802c66:	48                   	dec    %eax
  802c67:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6f:	eb 30                	jmp    802ca1 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802c71:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c79:	75 0a                	jne    802c85 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802c7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c83:	eb 08                	jmp    802c8d <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 08             	mov    0x8(%eax),%eax
  802c93:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c96:	0f 85 4d fe ff ff    	jne    802ae9 <alloc_block_NF+0x59>

			return NULL;
  802c9c:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802ca1:	c9                   	leave  
  802ca2:	c3                   	ret    

00802ca3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ca3:	55                   	push   %ebp
  802ca4:	89 e5                	mov    %esp,%ebp
  802ca6:	53                   	push   %ebx
  802ca7:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802caa:	a1 38 51 80 00       	mov    0x805138,%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	0f 85 86 00 00 00    	jne    802d3d <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802cb7:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802cbe:	00 00 00 
  802cc1:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802cc8:	00 00 00 
  802ccb:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802cd2:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cd5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd9:	75 17                	jne    802cf2 <insert_sorted_with_merge_freeList+0x4f>
  802cdb:	83 ec 04             	sub    $0x4,%esp
  802cde:	68 50 3f 80 00       	push   $0x803f50
  802ce3:	68 48 01 00 00       	push   $0x148
  802ce8:	68 73 3f 80 00       	push   $0x803f73
  802ced:	e8 ef d9 ff ff       	call   8006e1 <_panic>
  802cf2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	89 10                	mov    %edx,(%eax)
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 0d                	je     802d13 <insert_sorted_with_merge_freeList+0x70>
  802d06:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0e:	89 50 04             	mov    %edx,0x4(%eax)
  802d11:	eb 08                	jmp    802d1b <insert_sorted_with_merge_freeList+0x78>
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d32:	40                   	inc    %eax
  802d33:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802d38:	e9 73 07 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	8b 50 08             	mov    0x8(%eax),%edx
  802d43:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d48:	8b 40 08             	mov    0x8(%eax),%eax
  802d4b:	39 c2                	cmp    %eax,%edx
  802d4d:	0f 86 84 00 00 00    	jbe    802dd7 <insert_sorted_with_merge_freeList+0x134>
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d5e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d61:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d66:	8b 40 08             	mov    0x8(%eax),%eax
  802d69:	01 c8                	add    %ecx,%eax
  802d6b:	39 c2                	cmp    %eax,%edx
  802d6d:	74 68                	je     802dd7 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	75 17                	jne    802d8c <insert_sorted_with_merge_freeList+0xe9>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 8c 3f 80 00       	push   $0x803f8c
  802d7d:	68 4c 01 00 00       	push   $0x14c
  802d82:	68 73 3f 80 00       	push   $0x803f73
  802d87:	e8 55 d9 ff ff       	call   8006e1 <_panic>
  802d8c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	89 50 04             	mov    %edx,0x4(%eax)
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 0c                	je     802dae <insert_sorted_with_merge_freeList+0x10b>
  802da2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802da7:	8b 55 08             	mov    0x8(%ebp),%edx
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	eb 08                	jmp    802db6 <insert_sorted_with_merge_freeList+0x113>
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	a3 38 51 80 00       	mov    %eax,0x805138
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dcc:	40                   	inc    %eax
  802dcd:	a3 44 51 80 00       	mov    %eax,0x805144
  802dd2:	e9 d9 06 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 50 08             	mov    0x8(%eax),%edx
  802ddd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 86 b5 00 00 00    	jbe    802ea2 <insert_sorted_with_merge_freeList+0x1ff>
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 50 08             	mov    0x8(%eax),%edx
  802df3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802df8:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dfb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e00:	8b 40 08             	mov    0x8(%eax),%eax
  802e03:	01 c8                	add    %ecx,%eax
  802e05:	39 c2                	cmp    %eax,%edx
  802e07:	0f 85 95 00 00 00    	jne    802ea2 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802e0d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e12:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e18:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1e:	8b 52 0c             	mov    0xc(%edx),%edx
  802e21:	01 ca                	add    %ecx,%edx
  802e23:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3e:	75 17                	jne    802e57 <insert_sorted_with_merge_freeList+0x1b4>
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 50 3f 80 00       	push   $0x803f50
  802e48:	68 54 01 00 00       	push   $0x154
  802e4d:	68 73 3f 80 00       	push   $0x803f73
  802e52:	e8 8a d8 ff ff       	call   8006e1 <_panic>
  802e57:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0d                	je     802e78 <insert_sorted_with_merge_freeList+0x1d5>
  802e6b:	a1 48 51 80 00       	mov    0x805148,%eax
  802e70:	8b 55 08             	mov    0x8(%ebp),%edx
  802e73:	89 50 04             	mov    %edx,0x4(%eax)
  802e76:	eb 08                	jmp    802e80 <insert_sorted_with_merge_freeList+0x1dd>
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	a3 48 51 80 00       	mov    %eax,0x805148
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e92:	a1 54 51 80 00       	mov    0x805154,%eax
  802e97:	40                   	inc    %eax
  802e98:	a3 54 51 80 00       	mov    %eax,0x805154
  802e9d:	e9 0e 06 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	8b 50 08             	mov    0x8(%eax),%edx
  802ea8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ead:	8b 40 08             	mov    0x8(%eax),%eax
  802eb0:	39 c2                	cmp    %eax,%edx
  802eb2:	0f 83 c1 00 00 00    	jae    802f79 <insert_sorted_with_merge_freeList+0x2d6>
  802eb8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebd:	8b 50 08             	mov    0x8(%eax),%edx
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c8                	add    %ecx,%eax
  802ece:	39 c2                	cmp    %eax,%edx
  802ed0:	0f 85 a3 00 00 00    	jne    802f79 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ed6:	a1 38 51 80 00       	mov    0x805138,%eax
  802edb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ede:	8b 52 08             	mov    0x8(%edx),%edx
  802ee1:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ee4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eef:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef5:	8b 52 0c             	mov    0xc(%edx),%edx
  802ef8:	01 ca                	add    %ecx,%edx
  802efa:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f15:	75 17                	jne    802f2e <insert_sorted_with_merge_freeList+0x28b>
  802f17:	83 ec 04             	sub    $0x4,%esp
  802f1a:	68 50 3f 80 00       	push   $0x803f50
  802f1f:	68 5d 01 00 00       	push   $0x15d
  802f24:	68 73 3f 80 00       	push   $0x803f73
  802f29:	e8 b3 d7 ff ff       	call   8006e1 <_panic>
  802f2e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 0d                	je     802f4f <insert_sorted_with_merge_freeList+0x2ac>
  802f42:	a1 48 51 80 00       	mov    0x805148,%eax
  802f47:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4a:	89 50 04             	mov    %edx,0x4(%eax)
  802f4d:	eb 08                	jmp    802f57 <insert_sorted_with_merge_freeList+0x2b4>
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f69:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6e:	40                   	inc    %eax
  802f6f:	a3 54 51 80 00       	mov    %eax,0x805154
  802f74:	e9 37 05 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	8b 50 08             	mov    0x8(%eax),%edx
  802f7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	39 c2                	cmp    %eax,%edx
  802f89:	0f 83 82 00 00 00    	jae    803011 <insert_sorted_with_merge_freeList+0x36e>
  802f8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f94:	8b 50 08             	mov    0x8(%eax),%edx
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	8b 48 08             	mov    0x8(%eax),%ecx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa3:	01 c8                	add    %ecx,%eax
  802fa5:	39 c2                	cmp    %eax,%edx
  802fa7:	74 68                	je     803011 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fad:	75 17                	jne    802fc6 <insert_sorted_with_merge_freeList+0x323>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 50 3f 80 00       	push   $0x803f50
  802fb7:	68 62 01 00 00       	push   $0x162
  802fbc:	68 73 3f 80 00       	push   $0x803f73
  802fc1:	e8 1b d7 ff ff       	call   8006e1 <_panic>
  802fc6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0d                	je     802fe7 <insert_sorted_with_merge_freeList+0x344>
  802fda:	a1 38 51 80 00       	mov    0x805138,%eax
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	eb 08                	jmp    802fef <insert_sorted_with_merge_freeList+0x34c>
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803001:	a1 44 51 80 00       	mov    0x805144,%eax
  803006:	40                   	inc    %eax
  803007:	a3 44 51 80 00       	mov    %eax,0x805144
  80300c:	e9 9f 04 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803011:	a1 38 51 80 00       	mov    0x805138,%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80301b:	e9 84 04 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 50 08             	mov    0x8(%eax),%edx
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	8b 40 08             	mov    0x8(%eax),%eax
  80302c:	39 c2                	cmp    %eax,%edx
  80302e:	0f 86 a9 00 00 00    	jbe    8030dd <insert_sorted_with_merge_freeList+0x43a>
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 50 08             	mov    0x8(%eax),%edx
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 48 08             	mov    0x8(%eax),%ecx
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	8b 40 0c             	mov    0xc(%eax),%eax
  803046:	01 c8                	add    %ecx,%eax
  803048:	39 c2                	cmp    %eax,%edx
  80304a:	0f 84 8d 00 00 00    	je     8030dd <insert_sorted_with_merge_freeList+0x43a>
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	8b 50 08             	mov    0x8(%eax),%edx
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	8b 40 04             	mov    0x4(%eax),%eax
  80305c:	8b 48 08             	mov    0x8(%eax),%ecx
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	8b 40 0c             	mov    0xc(%eax),%eax
  803068:	01 c8                	add    %ecx,%eax
  80306a:	39 c2                	cmp    %eax,%edx
  80306c:	74 6f                	je     8030dd <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	74 06                	je     80307a <insert_sorted_with_merge_freeList+0x3d7>
  803074:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803078:	75 17                	jne    803091 <insert_sorted_with_merge_freeList+0x3ee>
  80307a:	83 ec 04             	sub    $0x4,%esp
  80307d:	68 b0 3f 80 00       	push   $0x803fb0
  803082:	68 6b 01 00 00       	push   $0x16b
  803087:	68 73 3f 80 00       	push   $0x803f73
  80308c:	e8 50 d6 ff ff       	call   8006e1 <_panic>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 50 04             	mov    0x4(%eax),%edx
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	89 50 04             	mov    %edx,0x4(%eax)
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a3:	89 10                	mov    %edx,(%eax)
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	74 0d                	je     8030bc <insert_sorted_with_merge_freeList+0x419>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b8:	89 10                	mov    %edx,(%eax)
  8030ba:	eb 08                	jmp    8030c4 <insert_sorted_with_merge_freeList+0x421>
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ca:	89 50 04             	mov    %edx,0x4(%eax)
  8030cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d2:	40                   	inc    %eax
  8030d3:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8030d8:	e9 d3 03 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	8b 50 08             	mov    0x8(%eax),%edx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 40 08             	mov    0x8(%eax),%eax
  8030e9:	39 c2                	cmp    %eax,%edx
  8030eb:	0f 86 da 00 00 00    	jbe    8031cb <insert_sorted_with_merge_freeList+0x528>
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 50 08             	mov    0x8(%eax),%edx
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	01 c8                	add    %ecx,%eax
  803105:	39 c2                	cmp    %eax,%edx
  803107:	0f 85 be 00 00 00    	jne    8031cb <insert_sorted_with_merge_freeList+0x528>
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 50 08             	mov    0x8(%eax),%edx
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	8b 48 08             	mov    0x8(%eax),%ecx
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	8b 40 04             	mov    0x4(%eax),%eax
  803122:	8b 40 0c             	mov    0xc(%eax),%eax
  803125:	01 c8                	add    %ecx,%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	0f 84 9c 00 00 00    	je     8031cb <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 50 08             	mov    0x8(%eax),%edx
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 50 0c             	mov    0xc(%eax),%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	8b 40 0c             	mov    0xc(%eax),%eax
  803147:	01 c2                	add    %eax,%edx
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803163:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803167:	75 17                	jne    803180 <insert_sorted_with_merge_freeList+0x4dd>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 50 3f 80 00       	push   $0x803f50
  803171:	68 74 01 00 00       	push   $0x174
  803176:	68 73 3f 80 00       	push   $0x803f73
  80317b:	e8 61 d5 ff ff       	call   8006e1 <_panic>
  803180:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	89 10                	mov    %edx,(%eax)
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	85 c0                	test   %eax,%eax
  803192:	74 0d                	je     8031a1 <insert_sorted_with_merge_freeList+0x4fe>
  803194:	a1 48 51 80 00       	mov    0x805148,%eax
  803199:	8b 55 08             	mov    0x8(%ebp),%edx
  80319c:	89 50 04             	mov    %edx,0x4(%eax)
  80319f:	eb 08                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x506>
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c0:	40                   	inc    %eax
  8031c1:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8031c6:	e9 e5 02 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	8b 50 08             	mov    0x8(%eax),%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	39 c2                	cmp    %eax,%edx
  8031d9:	0f 86 d7 00 00 00    	jbe    8032b6 <insert_sorted_with_merge_freeList+0x613>
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 50 08             	mov    0x8(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f1:	01 c8                	add    %ecx,%eax
  8031f3:	39 c2                	cmp    %eax,%edx
  8031f5:	0f 84 bb 00 00 00    	je     8032b6 <insert_sorted_with_merge_freeList+0x613>
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	8b 50 08             	mov    0x8(%eax),%edx
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 40 04             	mov    0x4(%eax),%eax
  803207:	8b 48 08             	mov    0x8(%eax),%ecx
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 40 04             	mov    0x4(%eax),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	01 c8                	add    %ecx,%eax
  803215:	39 c2                	cmp    %eax,%edx
  803217:	0f 85 99 00 00 00    	jne    8032b6 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803229:	8b 50 0c             	mov    0xc(%eax),%edx
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 40 0c             	mov    0xc(%eax),%eax
  803232:	01 c2                	add    %eax,%edx
  803234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803237:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80324e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803252:	75 17                	jne    80326b <insert_sorted_with_merge_freeList+0x5c8>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 50 3f 80 00       	push   $0x803f50
  80325c:	68 7d 01 00 00       	push   $0x17d
  803261:	68 73 3f 80 00       	push   $0x803f73
  803266:	e8 76 d4 ff ff       	call   8006e1 <_panic>
  80326b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	89 10                	mov    %edx,(%eax)
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 0d                	je     80328c <insert_sorted_with_merge_freeList+0x5e9>
  80327f:	a1 48 51 80 00       	mov    0x805148,%eax
  803284:	8b 55 08             	mov    0x8(%ebp),%edx
  803287:	89 50 04             	mov    %edx,0x4(%eax)
  80328a:	eb 08                	jmp    803294 <insert_sorted_with_merge_freeList+0x5f1>
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	a3 48 51 80 00       	mov    %eax,0x805148
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ab:	40                   	inc    %eax
  8032ac:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8032b1:	e9 fa 01 00 00       	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 50 08             	mov    0x8(%eax),%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 40 08             	mov    0x8(%eax),%eax
  8032c2:	39 c2                	cmp    %eax,%edx
  8032c4:	0f 86 d2 01 00 00    	jbe    80349c <insert_sorted_with_merge_freeList+0x7f9>
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 50 08             	mov    0x8(%eax),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 48 08             	mov    0x8(%eax),%ecx
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032dc:	01 c8                	add    %ecx,%eax
  8032de:	39 c2                	cmp    %eax,%edx
  8032e0:	0f 85 b6 01 00 00    	jne    80349c <insert_sorted_with_merge_freeList+0x7f9>
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 50 08             	mov    0x8(%eax),%edx
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 40 04             	mov    0x4(%eax),%eax
  8032f2:	8b 48 08             	mov    0x8(%eax),%ecx
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 40 04             	mov    0x4(%eax),%eax
  8032fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fe:	01 c8                	add    %ecx,%eax
  803300:	39 c2                	cmp    %eax,%edx
  803302:	0f 85 94 01 00 00    	jne    80349c <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803311:	8b 52 04             	mov    0x4(%edx),%edx
  803314:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803317:	8b 55 08             	mov    0x8(%ebp),%edx
  80331a:	8b 5a 0c             	mov    0xc(%edx),%ebx
  80331d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803320:	8b 52 0c             	mov    0xc(%edx),%edx
  803323:	01 da                	add    %ebx,%edx
  803325:	01 ca                	add    %ecx,%edx
  803327:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80333e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803342:	75 17                	jne    80335b <insert_sorted_with_merge_freeList+0x6b8>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 e5 3f 80 00       	push   $0x803fe5
  80334c:	68 86 01 00 00       	push   $0x186
  803351:	68 73 3f 80 00       	push   $0x803f73
  803356:	e8 86 d3 ff ff       	call   8006e1 <_panic>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	85 c0                	test   %eax,%eax
  803362:	74 10                	je     803374 <insert_sorted_with_merge_freeList+0x6d1>
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80336c:	8b 52 04             	mov    0x4(%edx),%edx
  80336f:	89 50 04             	mov    %edx,0x4(%eax)
  803372:	eb 0b                	jmp    80337f <insert_sorted_with_merge_freeList+0x6dc>
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	8b 40 04             	mov    0x4(%eax),%eax
  80337a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 40 04             	mov    0x4(%eax),%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	74 0f                	je     803398 <insert_sorted_with_merge_freeList+0x6f5>
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	8b 40 04             	mov    0x4(%eax),%eax
  80338f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803392:	8b 12                	mov    (%edx),%edx
  803394:	89 10                	mov    %edx,(%eax)
  803396:	eb 0a                	jmp    8033a2 <insert_sorted_with_merge_freeList+0x6ff>
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 00                	mov    (%eax),%eax
  80339d:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ba:	48                   	dec    %eax
  8033bb:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8033c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c4:	75 17                	jne    8033dd <insert_sorted_with_merge_freeList+0x73a>
  8033c6:	83 ec 04             	sub    $0x4,%esp
  8033c9:	68 50 3f 80 00       	push   $0x803f50
  8033ce:	68 87 01 00 00       	push   $0x187
  8033d3:	68 73 3f 80 00       	push   $0x803f73
  8033d8:	e8 04 d3 ff ff       	call   8006e1 <_panic>
  8033dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	89 10                	mov    %edx,(%eax)
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	74 0d                	je     8033fe <insert_sorted_with_merge_freeList+0x75b>
  8033f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	eb 08                	jmp    803406 <insert_sorted_with_merge_freeList+0x763>
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803409:	a3 48 51 80 00       	mov    %eax,0x805148
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803418:	a1 54 51 80 00       	mov    0x805154,%eax
  80341d:	40                   	inc    %eax
  80341e:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803437:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343b:	75 17                	jne    803454 <insert_sorted_with_merge_freeList+0x7b1>
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	68 50 3f 80 00       	push   $0x803f50
  803445:	68 8a 01 00 00       	push   $0x18a
  80344a:	68 73 3f 80 00       	push   $0x803f73
  80344f:	e8 8d d2 ff ff       	call   8006e1 <_panic>
  803454:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	89 10                	mov    %edx,(%eax)
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 0d                	je     803475 <insert_sorted_with_merge_freeList+0x7d2>
  803468:	a1 48 51 80 00       	mov    0x805148,%eax
  80346d:	8b 55 08             	mov    0x8(%ebp),%edx
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	eb 08                	jmp    80347d <insert_sorted_with_merge_freeList+0x7da>
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	a3 48 51 80 00       	mov    %eax,0x805148
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348f:	a1 54 51 80 00       	mov    0x805154,%eax
  803494:	40                   	inc    %eax
  803495:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  80349a:	eb 14                	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	0f 85 72 fb ff ff    	jne    803020 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8034ae:	eb 00                	jmp    8034b0 <insert_sorted_with_merge_freeList+0x80d>
  8034b0:	90                   	nop
  8034b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034b4:	c9                   	leave  
  8034b5:	c3                   	ret    
  8034b6:	66 90                	xchg   %ax,%ax

008034b8 <__udivdi3>:
  8034b8:	55                   	push   %ebp
  8034b9:	57                   	push   %edi
  8034ba:	56                   	push   %esi
  8034bb:	53                   	push   %ebx
  8034bc:	83 ec 1c             	sub    $0x1c,%esp
  8034bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034cf:	89 ca                	mov    %ecx,%edx
  8034d1:	89 f8                	mov    %edi,%eax
  8034d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034d7:	85 f6                	test   %esi,%esi
  8034d9:	75 2d                	jne    803508 <__udivdi3+0x50>
  8034db:	39 cf                	cmp    %ecx,%edi
  8034dd:	77 65                	ja     803544 <__udivdi3+0x8c>
  8034df:	89 fd                	mov    %edi,%ebp
  8034e1:	85 ff                	test   %edi,%edi
  8034e3:	75 0b                	jne    8034f0 <__udivdi3+0x38>
  8034e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ea:	31 d2                	xor    %edx,%edx
  8034ec:	f7 f7                	div    %edi
  8034ee:	89 c5                	mov    %eax,%ebp
  8034f0:	31 d2                	xor    %edx,%edx
  8034f2:	89 c8                	mov    %ecx,%eax
  8034f4:	f7 f5                	div    %ebp
  8034f6:	89 c1                	mov    %eax,%ecx
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	f7 f5                	div    %ebp
  8034fc:	89 cf                	mov    %ecx,%edi
  8034fe:	89 fa                	mov    %edi,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	39 ce                	cmp    %ecx,%esi
  80350a:	77 28                	ja     803534 <__udivdi3+0x7c>
  80350c:	0f bd fe             	bsr    %esi,%edi
  80350f:	83 f7 1f             	xor    $0x1f,%edi
  803512:	75 40                	jne    803554 <__udivdi3+0x9c>
  803514:	39 ce                	cmp    %ecx,%esi
  803516:	72 0a                	jb     803522 <__udivdi3+0x6a>
  803518:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80351c:	0f 87 9e 00 00 00    	ja     8035c0 <__udivdi3+0x108>
  803522:	b8 01 00 00 00       	mov    $0x1,%eax
  803527:	89 fa                	mov    %edi,%edx
  803529:	83 c4 1c             	add    $0x1c,%esp
  80352c:	5b                   	pop    %ebx
  80352d:	5e                   	pop    %esi
  80352e:	5f                   	pop    %edi
  80352f:	5d                   	pop    %ebp
  803530:	c3                   	ret    
  803531:	8d 76 00             	lea    0x0(%esi),%esi
  803534:	31 ff                	xor    %edi,%edi
  803536:	31 c0                	xor    %eax,%eax
  803538:	89 fa                	mov    %edi,%edx
  80353a:	83 c4 1c             	add    $0x1c,%esp
  80353d:	5b                   	pop    %ebx
  80353e:	5e                   	pop    %esi
  80353f:	5f                   	pop    %edi
  803540:	5d                   	pop    %ebp
  803541:	c3                   	ret    
  803542:	66 90                	xchg   %ax,%ax
  803544:	89 d8                	mov    %ebx,%eax
  803546:	f7 f7                	div    %edi
  803548:	31 ff                	xor    %edi,%edi
  80354a:	89 fa                	mov    %edi,%edx
  80354c:	83 c4 1c             	add    $0x1c,%esp
  80354f:	5b                   	pop    %ebx
  803550:	5e                   	pop    %esi
  803551:	5f                   	pop    %edi
  803552:	5d                   	pop    %ebp
  803553:	c3                   	ret    
  803554:	bd 20 00 00 00       	mov    $0x20,%ebp
  803559:	89 eb                	mov    %ebp,%ebx
  80355b:	29 fb                	sub    %edi,%ebx
  80355d:	89 f9                	mov    %edi,%ecx
  80355f:	d3 e6                	shl    %cl,%esi
  803561:	89 c5                	mov    %eax,%ebp
  803563:	88 d9                	mov    %bl,%cl
  803565:	d3 ed                	shr    %cl,%ebp
  803567:	89 e9                	mov    %ebp,%ecx
  803569:	09 f1                	or     %esi,%ecx
  80356b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80356f:	89 f9                	mov    %edi,%ecx
  803571:	d3 e0                	shl    %cl,%eax
  803573:	89 c5                	mov    %eax,%ebp
  803575:	89 d6                	mov    %edx,%esi
  803577:	88 d9                	mov    %bl,%cl
  803579:	d3 ee                	shr    %cl,%esi
  80357b:	89 f9                	mov    %edi,%ecx
  80357d:	d3 e2                	shl    %cl,%edx
  80357f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803583:	88 d9                	mov    %bl,%cl
  803585:	d3 e8                	shr    %cl,%eax
  803587:	09 c2                	or     %eax,%edx
  803589:	89 d0                	mov    %edx,%eax
  80358b:	89 f2                	mov    %esi,%edx
  80358d:	f7 74 24 0c          	divl   0xc(%esp)
  803591:	89 d6                	mov    %edx,%esi
  803593:	89 c3                	mov    %eax,%ebx
  803595:	f7 e5                	mul    %ebp
  803597:	39 d6                	cmp    %edx,%esi
  803599:	72 19                	jb     8035b4 <__udivdi3+0xfc>
  80359b:	74 0b                	je     8035a8 <__udivdi3+0xf0>
  80359d:	89 d8                	mov    %ebx,%eax
  80359f:	31 ff                	xor    %edi,%edi
  8035a1:	e9 58 ff ff ff       	jmp    8034fe <__udivdi3+0x46>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035ac:	89 f9                	mov    %edi,%ecx
  8035ae:	d3 e2                	shl    %cl,%edx
  8035b0:	39 c2                	cmp    %eax,%edx
  8035b2:	73 e9                	jae    80359d <__udivdi3+0xe5>
  8035b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035b7:	31 ff                	xor    %edi,%edi
  8035b9:	e9 40 ff ff ff       	jmp    8034fe <__udivdi3+0x46>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	31 c0                	xor    %eax,%eax
  8035c2:	e9 37 ff ff ff       	jmp    8034fe <__udivdi3+0x46>
  8035c7:	90                   	nop

008035c8 <__umoddi3>:
  8035c8:	55                   	push   %ebp
  8035c9:	57                   	push   %edi
  8035ca:	56                   	push   %esi
  8035cb:	53                   	push   %ebx
  8035cc:	83 ec 1c             	sub    $0x1c,%esp
  8035cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035e7:	89 f3                	mov    %esi,%ebx
  8035e9:	89 fa                	mov    %edi,%edx
  8035eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ef:	89 34 24             	mov    %esi,(%esp)
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	75 1a                	jne    803610 <__umoddi3+0x48>
  8035f6:	39 f7                	cmp    %esi,%edi
  8035f8:	0f 86 a2 00 00 00    	jbe    8036a0 <__umoddi3+0xd8>
  8035fe:	89 c8                	mov    %ecx,%eax
  803600:	89 f2                	mov    %esi,%edx
  803602:	f7 f7                	div    %edi
  803604:	89 d0                	mov    %edx,%eax
  803606:	31 d2                	xor    %edx,%edx
  803608:	83 c4 1c             	add    $0x1c,%esp
  80360b:	5b                   	pop    %ebx
  80360c:	5e                   	pop    %esi
  80360d:	5f                   	pop    %edi
  80360e:	5d                   	pop    %ebp
  80360f:	c3                   	ret    
  803610:	39 f0                	cmp    %esi,%eax
  803612:	0f 87 ac 00 00 00    	ja     8036c4 <__umoddi3+0xfc>
  803618:	0f bd e8             	bsr    %eax,%ebp
  80361b:	83 f5 1f             	xor    $0x1f,%ebp
  80361e:	0f 84 ac 00 00 00    	je     8036d0 <__umoddi3+0x108>
  803624:	bf 20 00 00 00       	mov    $0x20,%edi
  803629:	29 ef                	sub    %ebp,%edi
  80362b:	89 fe                	mov    %edi,%esi
  80362d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803631:	89 e9                	mov    %ebp,%ecx
  803633:	d3 e0                	shl    %cl,%eax
  803635:	89 d7                	mov    %edx,%edi
  803637:	89 f1                	mov    %esi,%ecx
  803639:	d3 ef                	shr    %cl,%edi
  80363b:	09 c7                	or     %eax,%edi
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 e2                	shl    %cl,%edx
  803641:	89 14 24             	mov    %edx,(%esp)
  803644:	89 d8                	mov    %ebx,%eax
  803646:	d3 e0                	shl    %cl,%eax
  803648:	89 c2                	mov    %eax,%edx
  80364a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80364e:	d3 e0                	shl    %cl,%eax
  803650:	89 44 24 04          	mov    %eax,0x4(%esp)
  803654:	8b 44 24 08          	mov    0x8(%esp),%eax
  803658:	89 f1                	mov    %esi,%ecx
  80365a:	d3 e8                	shr    %cl,%eax
  80365c:	09 d0                	or     %edx,%eax
  80365e:	d3 eb                	shr    %cl,%ebx
  803660:	89 da                	mov    %ebx,%edx
  803662:	f7 f7                	div    %edi
  803664:	89 d3                	mov    %edx,%ebx
  803666:	f7 24 24             	mull   (%esp)
  803669:	89 c6                	mov    %eax,%esi
  80366b:	89 d1                	mov    %edx,%ecx
  80366d:	39 d3                	cmp    %edx,%ebx
  80366f:	0f 82 87 00 00 00    	jb     8036fc <__umoddi3+0x134>
  803675:	0f 84 91 00 00 00    	je     80370c <__umoddi3+0x144>
  80367b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80367f:	29 f2                	sub    %esi,%edx
  803681:	19 cb                	sbb    %ecx,%ebx
  803683:	89 d8                	mov    %ebx,%eax
  803685:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803689:	d3 e0                	shl    %cl,%eax
  80368b:	89 e9                	mov    %ebp,%ecx
  80368d:	d3 ea                	shr    %cl,%edx
  80368f:	09 d0                	or     %edx,%eax
  803691:	89 e9                	mov    %ebp,%ecx
  803693:	d3 eb                	shr    %cl,%ebx
  803695:	89 da                	mov    %ebx,%edx
  803697:	83 c4 1c             	add    $0x1c,%esp
  80369a:	5b                   	pop    %ebx
  80369b:	5e                   	pop    %esi
  80369c:	5f                   	pop    %edi
  80369d:	5d                   	pop    %ebp
  80369e:	c3                   	ret    
  80369f:	90                   	nop
  8036a0:	89 fd                	mov    %edi,%ebp
  8036a2:	85 ff                	test   %edi,%edi
  8036a4:	75 0b                	jne    8036b1 <__umoddi3+0xe9>
  8036a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ab:	31 d2                	xor    %edx,%edx
  8036ad:	f7 f7                	div    %edi
  8036af:	89 c5                	mov    %eax,%ebp
  8036b1:	89 f0                	mov    %esi,%eax
  8036b3:	31 d2                	xor    %edx,%edx
  8036b5:	f7 f5                	div    %ebp
  8036b7:	89 c8                	mov    %ecx,%eax
  8036b9:	f7 f5                	div    %ebp
  8036bb:	89 d0                	mov    %edx,%eax
  8036bd:	e9 44 ff ff ff       	jmp    803606 <__umoddi3+0x3e>
  8036c2:	66 90                	xchg   %ax,%ax
  8036c4:	89 c8                	mov    %ecx,%eax
  8036c6:	89 f2                	mov    %esi,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	3b 04 24             	cmp    (%esp),%eax
  8036d3:	72 06                	jb     8036db <__umoddi3+0x113>
  8036d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036d9:	77 0f                	ja     8036ea <__umoddi3+0x122>
  8036db:	89 f2                	mov    %esi,%edx
  8036dd:	29 f9                	sub    %edi,%ecx
  8036df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036e3:	89 14 24             	mov    %edx,(%esp)
  8036e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036ee:	8b 14 24             	mov    (%esp),%edx
  8036f1:	83 c4 1c             	add    $0x1c,%esp
  8036f4:	5b                   	pop    %ebx
  8036f5:	5e                   	pop    %esi
  8036f6:	5f                   	pop    %edi
  8036f7:	5d                   	pop    %ebp
  8036f8:	c3                   	ret    
  8036f9:	8d 76 00             	lea    0x0(%esi),%esi
  8036fc:	2b 04 24             	sub    (%esp),%eax
  8036ff:	19 fa                	sbb    %edi,%edx
  803701:	89 d1                	mov    %edx,%ecx
  803703:	89 c6                	mov    %eax,%esi
  803705:	e9 71 ff ff ff       	jmp    80367b <__umoddi3+0xb3>
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803710:	72 ea                	jb     8036fc <__umoddi3+0x134>
  803712:	89 d9                	mov    %ebx,%ecx
  803714:	e9 62 ff ff ff       	jmp    80367b <__umoddi3+0xb3>
