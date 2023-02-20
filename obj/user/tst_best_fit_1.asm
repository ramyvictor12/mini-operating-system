
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 77 27 00 00       	call   8027c1 <sys_set_uheap_strategy>
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
  80009b:	68 80 3c 80 00       	push   $0x803c80
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 9c 3c 80 00       	push   $0x803c9c
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 92 1d 00 00       	call   801e48 <malloc>
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
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 cf 21 00 00       	call   8022ac <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 67 22 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 4b 1d 00 00       	call   801e48 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 b4 3c 80 00       	push   $0x803cb4
  800115:	6a 26                	push   $0x26
  800117:	68 9c 3c 80 00       	push   $0x803c9c
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 26 22 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 e4 3c 80 00       	push   $0x803ce4
  800138:	6a 28                	push   $0x28
  80013a:	68 9c 3c 80 00       	push   $0x803c9c
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 60 21 00 00       	call   8022ac <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 01 3d 80 00       	push   $0x803d01
  80015d:	6a 29                	push   $0x29
  80015f:	68 9c 3c 80 00       	push   $0x803c9c
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 3e 21 00 00       	call   8022ac <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 d6 21 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 ba 1c 00 00       	call   801e48 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 b4 3c 80 00       	push   $0x803cb4
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 9c 3c 80 00       	push   $0x803c9c
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 88 21 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 e4 3c 80 00       	push   $0x803ce4
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 9c 3c 80 00       	push   $0x803c9c
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 c2 20 00 00       	call   8022ac <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 01 3d 80 00       	push   $0x803d01
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 9c 3c 80 00       	push   $0x803c9c
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 a0 20 00 00       	call   8022ac <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 38 21 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 20 1c 00 00       	call   801e48 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 b4 3c 80 00       	push   $0x803cb4
  80024f:	6a 38                	push   $0x38
  800251:	68 9c 3c 80 00       	push   $0x803c9c
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 ec 20 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 e4 3c 80 00       	push   $0x803ce4
  800272:	6a 3a                	push   $0x3a
  800274:	68 9c 3c 80 00       	push   $0x803c9c
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 29 20 00 00       	call   8022ac <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 01 3d 80 00       	push   $0x803d01
  800294:	6a 3b                	push   $0x3b
  800296:	68 9c 3c 80 00       	push   $0x803c9c
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 07 20 00 00       	call   8022ac <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 9f 20 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 87 1b 00 00       	call   801e48 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 b4 3c 80 00       	push   $0x803cb4
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 9c 3c 80 00       	push   $0x803c9c
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 58 20 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 e4 3c 80 00       	push   $0x803ce4
  800306:	6a 43                	push   $0x43
  800308:	68 9c 3c 80 00       	push   $0x803c9c
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 92 1f 00 00       	call   8022ac <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 01 3d 80 00       	push   $0x803d01
  80032b:	6a 44                	push   $0x44
  80032d:	68 9c 3c 80 00       	push   $0x803c9c
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 70 1f 00 00       	call   8022ac <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 08 20 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 f2 1a 00 00       	call   801e48 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 b4 3c 80 00       	push   $0x803cb4
  80037e:	6a 4a                	push   $0x4a
  800380:	68 9c 3c 80 00       	push   $0x803c9c
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 bd 1f 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 e4 3c 80 00       	push   $0x803ce4
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 9c 3c 80 00       	push   $0x803c9c
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 fa 1e 00 00       	call   8022ac <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 01 3d 80 00       	push   $0x803d01
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 9c 3c 80 00       	push   $0x803c9c
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 d8 1e 00 00       	call   8022ac <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 70 1f 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 5a 1a 00 00       	call   801e48 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 b4 3c 80 00       	push   $0x803cb4
  800418:	6a 53                	push   $0x53
  80041a:	68 9c 3c 80 00       	push   $0x803c9c
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 23 1f 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 e4 3c 80 00       	push   $0x803ce4
  80043b:	6a 55                	push   $0x55
  80043d:	68 9c 3c 80 00       	push   $0x803c9c
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 60 1e 00 00       	call   8022ac <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 01 3d 80 00       	push   $0x803d01
  80045d:	6a 56                	push   $0x56
  80045f:	68 9c 3c 80 00       	push   $0x803c9c
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 3e 1e 00 00       	call   8022ac <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 d6 1e 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 c0 19 00 00       	call   801e48 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 b4 3c 80 00       	push   $0x803cb4
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 9c 3c 80 00       	push   $0x803c9c
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 8b 1e 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 e4 3c 80 00       	push   $0x803ce4
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 9c 3c 80 00       	push   $0x803c9c
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 c5 1d 00 00       	call   8022ac <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 01 3d 80 00       	push   $0x803d01
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 9c 3c 80 00       	push   $0x803c9c
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 a3 1d 00 00       	call   8022ac <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 3b 1e 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 25 19 00 00       	call   801e48 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 b4 3c 80 00       	push   $0x803cb4
  80054d:	6a 65                	push   $0x65
  80054f:	68 9c 3c 80 00       	push   $0x803c9c
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 ee 1d 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 e4 3c 80 00       	push   $0x803ce4
  800570:	6a 67                	push   $0x67
  800572:	68 9c 3c 80 00       	push   $0x803c9c
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 2b 1d 00 00       	call   8022ac <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 01 3d 80 00       	push   $0x803d01
  800592:	6a 68                	push   $0x68
  800594:	68 9c 3c 80 00       	push   $0x803c9c
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 09 1d 00 00       	call   8022ac <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 a1 1d 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 19 19 00 00       	call   801ed3 <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 8a 1d 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 14 3d 80 00       	push   $0x803d14
  8005d8:	6a 72                	push   $0x72
  8005da:	68 9c 3c 80 00       	push   $0x803c9c
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 c3 1c 00 00       	call   8022ac <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 2b 3d 80 00       	push   $0x803d2b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 9c 3c 80 00       	push   $0x803c9c
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 a1 1c 00 00       	call   8022ac <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 39 1d 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 b1 18 00 00       	call   801ed3 <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 22 1d 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 14 3d 80 00       	push   $0x803d14
  800640:	6a 7a                	push   $0x7a
  800642:	68 9c 3c 80 00       	push   $0x803c9c
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 5b 1c 00 00       	call   8022ac <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 2b 3d 80 00       	push   $0x803d2b
  800662:	6a 7b                	push   $0x7b
  800664:	68 9c 3c 80 00       	push   $0x803c9c
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 39 1c 00 00       	call   8022ac <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 d1 1c 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 49 18 00 00       	call   801ed3 <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 ba 1c 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 14 3d 80 00       	push   $0x803d14
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 9c 3c 80 00       	push   $0x803c9c
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 f0 1b 00 00       	call   8022ac <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 2b 3d 80 00       	push   $0x803d2b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 9c 3c 80 00       	push   $0x803c9c
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 cb 1b 00 00       	call   8022ac <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 63 1c 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 4d 17 00 00       	call   801e48 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 b4 3c 80 00       	push   $0x803cb4
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 9c 3c 80 00       	push   $0x803c9c
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 13 1c 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 e4 3c 80 00       	push   $0x803ce4
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 9c 3c 80 00       	push   $0x803c9c
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 4d 1b 00 00       	call   8022ac <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 01 3d 80 00       	push   $0x803d01
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 9c 3c 80 00       	push   $0x803c9c
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 28 1b 00 00       	call   8022ac <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 c0 1b 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 aa 16 00 00       	call   801e48 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 b4 3c 80 00       	push   $0x803cb4
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 9c 3c 80 00       	push   $0x803c9c
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 78 1b 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 e4 3c 80 00       	push   $0x803ce4
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 9c 3c 80 00       	push   $0x803c9c
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 b2 1a 00 00       	call   8022ac <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 01 3d 80 00       	push   $0x803d01
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 9c 3c 80 00       	push   $0x803c9c
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 8d 1a 00 00       	call   8022ac <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 25 1b 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 0b 16 00 00       	call   801e48 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 b4 3c 80 00       	push   $0x803cb4
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 9c 3c 80 00       	push   $0x803c9c
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 c7 1a 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 e4 3c 80 00       	push   $0x803ce4
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 9c 3c 80 00       	push   $0x803c9c
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 03 1a 00 00       	call   8022ac <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 01 3d 80 00       	push   $0x803d01
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 9c 3c 80 00       	push   $0x803c9c
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 de 19 00 00       	call   8022ac <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 76 1a 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 5d 15 00 00       	call   801e48 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 b4 3c 80 00       	push   $0x803cb4
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 9c 3c 80 00       	push   $0x803c9c
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 22 1a 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 e4 3c 80 00       	push   $0x803ce4
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 9c 3c 80 00       	push   $0x803c9c
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 59 19 00 00       	call   8022ac <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 01 3d 80 00       	push   $0x803d01
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 9c 3c 80 00       	push   $0x803c9c
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 34 19 00 00       	call   8022ac <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 cc 19 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 44 15 00 00       	call   801ed3 <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 b5 19 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 14 3d 80 00       	push   $0x803d14
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 9c 3c 80 00       	push   $0x803c9c
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 eb 18 00 00       	call   8022ac <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 2b 3d 80 00       	push   $0x803d2b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 9c 3c 80 00       	push   $0x803c9c
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 c6 18 00 00       	call   8022ac <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 5e 19 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 d6 14 00 00       	call   801ed3 <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 47 19 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 14 3d 80 00       	push   $0x803d14
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 9c 3c 80 00       	push   $0x803c9c
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 7d 18 00 00       	call   8022ac <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 2b 3d 80 00       	push   $0x803d2b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 9c 3c 80 00       	push   $0x803c9c
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 58 18 00 00       	call   8022ac <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 f0 18 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 d8 13 00 00       	call   801e48 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 b4 3c 80 00       	push   $0x803cb4
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 9c 3c 80 00       	push   $0x803c9c
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 a2 18 00 00       	call   80234c <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 e4 3c 80 00       	push   $0x803ce4
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 9c 3c 80 00       	push   $0x803c9c
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 dc 17 00 00       	call   8022ac <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 01 3d 80 00       	push   $0x803d01
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 9c 3c 80 00       	push   $0x803c9c
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 38 3d 80 00       	push   $0x803d38
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 79 1a 00 00       	call   80258c <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 1b 18 00 00       	call   802399 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 98 3d 80 00       	push   $0x803d98
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 c0 3d 80 00       	push   $0x803dc0
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 e8 3d 80 00       	push   $0x803de8
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 40 3e 80 00       	push   $0x803e40
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 98 3d 80 00       	push   $0x803d98
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 9b 17 00 00       	call   8023b3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 28 19 00 00       	call   802558 <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 7d 19 00 00       	call   8025be <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 54 3e 80 00       	push   $0x803e54
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 59 3e 80 00       	push   $0x803e59
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 75 3e 80 00       	push   $0x803e75
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 78 3e 80 00       	push   $0x803e78
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 c4 3e 80 00       	push   $0x803ec4
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 d0 3e 80 00       	push   $0x803ed0
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 c4 3e 80 00       	push   $0x803ec4
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 24 3f 80 00       	push   $0x803f24
  800e15:	6a 44                	push   $0x44
  800e17:	68 c4 3e 80 00       	push   $0x803ec4
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 7c 13 00 00       	call   8021eb <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 05 13 00 00       	call   8021eb <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 69 14 00 00       	call   802399 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 63 14 00 00       	call   8023b3 <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 82 2a 00 00       	call   803a1c <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 42 2b 00 00       	call   803b2c <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 94 41 80 00       	add    $0x804194,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 a5 41 80 00       	push   $0x8041a5
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 ae 41 80 00       	push   $0x8041ae
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be b1 41 80 00       	mov    $0x8041b1,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 10 43 80 00       	push   $0x804310
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801cb9:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cc0:	00 00 00 
  801cc3:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801cca:	00 00 00 
  801ccd:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cd4:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801cd7:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cde:	00 00 00 
  801ce1:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801ce8:	00 00 00 
  801ceb:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cf2:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801cf5:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801cfc:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801cff:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801d06:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d15:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d1a:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801d1f:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d2e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	6a 06                	push   $0x6
  801d38:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3b:	50                   	push   %eax
  801d3c:	e8 ee 05 00 00       	call   80232f <sys_allocate_chunk>
  801d41:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d44:	a1 20 51 80 00       	mov    0x805120,%eax
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	50                   	push   %eax
  801d4d:	e8 63 0c 00 00       	call   8029b5 <initialize_MemBlocksList>
  801d52:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801d55:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801d5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d60:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d78:	89 c2                	mov    %eax,%edx
  801d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7d:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d83:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801d8a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d94:	8b 50 08             	mov    0x8(%eax),%edx
  801d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	48                   	dec    %eax
  801d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	f7 75 e0             	divl   -0x20(%ebp)
  801dab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dae:	29 d0                	sub    %edx,%eax
  801db0:	89 c2                	mov    %eax,%edx
  801db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db5:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801db8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dbc:	75 14                	jne    801dd2 <initialize_dyn_block_system+0x11f>
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	68 35 43 80 00       	push   $0x804335
  801dc6:	6a 34                	push   $0x34
  801dc8:	68 53 43 80 00       	push   $0x804353
  801dcd:	e8 72 ee ff ff       	call   800c44 <_panic>
  801dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd5:	8b 00                	mov    (%eax),%eax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	74 10                	je     801deb <initialize_dyn_block_system+0x138>
  801ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801de3:	8b 52 04             	mov    0x4(%edx),%edx
  801de6:	89 50 04             	mov    %edx,0x4(%eax)
  801de9:	eb 0b                	jmp    801df6 <initialize_dyn_block_system+0x143>
  801deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dee:	8b 40 04             	mov    0x4(%eax),%eax
  801df1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df9:	8b 40 04             	mov    0x4(%eax),%eax
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	74 0f                	je     801e0f <initialize_dyn_block_system+0x15c>
  801e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e03:	8b 40 04             	mov    0x4(%eax),%eax
  801e06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e09:	8b 12                	mov    (%edx),%edx
  801e0b:	89 10                	mov    %edx,(%eax)
  801e0d:	eb 0a                	jmp    801e19 <initialize_dyn_block_system+0x166>
  801e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e12:	8b 00                	mov    (%eax),%eax
  801e14:	a3 48 51 80 00       	mov    %eax,0x805148
  801e19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e2c:	a1 54 51 80 00       	mov    0x805154,%eax
  801e31:	48                   	dec    %eax
  801e32:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801e37:	83 ec 0c             	sub    $0xc,%esp
  801e3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801e3d:	e8 c4 13 00 00       	call   803206 <insert_sorted_with_merge_freeList>
  801e42:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801e45:	90                   	nop
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4e:	e8 2f fe ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e57:	75 07                	jne    801e60 <malloc+0x18>
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	eb 71                	jmp    801ed1 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801e60:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e67:	76 07                	jbe    801e70 <malloc+0x28>
	return NULL;
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6e:	eb 61                	jmp    801ed1 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e70:	e8 88 08 00 00       	call   8026fd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e75:	85 c0                	test   %eax,%eax
  801e77:	74 53                	je     801ecc <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801e79:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e80:	8b 55 08             	mov    0x8(%ebp),%edx
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	01 d0                	add    %edx,%eax
  801e88:	48                   	dec    %eax
  801e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e94:	f7 75 f4             	divl   -0xc(%ebp)
  801e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9a:	29 d0                	sub    %edx,%eax
  801e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 ec             	pushl  -0x14(%ebp)
  801ea5:	e8 d2 0d 00 00       	call   802c7c <alloc_block_FF>
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801eb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801eb4:	74 16                	je     801ecc <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801eb6:	83 ec 0c             	sub    $0xc,%esp
  801eb9:	ff 75 e8             	pushl  -0x18(%ebp)
  801ebc:	e8 0c 0c 00 00       	call   802acd <insert_sorted_allocList>
  801ec1:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ec7:	8b 40 08             	mov    0x8(%eax),%eax
  801eca:	eb 05                	jmp    801ed1 <malloc+0x89>
    }

			}


	return NULL;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801eea:	83 ec 08             	sub    $0x8,%esp
  801eed:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef0:	68 40 50 80 00       	push   $0x805040
  801ef5:	e8 a0 0b 00 00       	call   802a9a <find_block>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f03:	8b 50 0c             	mov    0xc(%eax),%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	83 ec 08             	sub    $0x8,%esp
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	e8 e4 03 00 00       	call   8022f7 <sys_free_user_mem>
  801f13:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801f16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f1a:	75 17                	jne    801f33 <free+0x60>
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 35 43 80 00       	push   $0x804335
  801f24:	68 84 00 00 00       	push   $0x84
  801f29:	68 53 43 80 00       	push   $0x804353
  801f2e:	e8 11 ed ff ff       	call   800c44 <_panic>
  801f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	74 10                	je     801f4c <free+0x79>
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	8b 00                	mov    (%eax),%eax
  801f41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f44:	8b 52 04             	mov    0x4(%edx),%edx
  801f47:	89 50 04             	mov    %edx,0x4(%eax)
  801f4a:	eb 0b                	jmp    801f57 <free+0x84>
  801f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4f:	8b 40 04             	mov    0x4(%eax),%eax
  801f52:	a3 44 50 80 00       	mov    %eax,0x805044
  801f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5a:	8b 40 04             	mov    0x4(%eax),%eax
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	74 0f                	je     801f70 <free+0x9d>
  801f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f64:	8b 40 04             	mov    0x4(%eax),%eax
  801f67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f6a:	8b 12                	mov    (%edx),%edx
  801f6c:	89 10                	mov    %edx,(%eax)
  801f6e:	eb 0a                	jmp    801f7a <free+0xa7>
  801f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f73:	8b 00                	mov    (%eax),%eax
  801f75:	a3 40 50 80 00       	mov    %eax,0x805040
  801f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f8d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f92:	48                   	dec    %eax
  801f93:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	ff 75 ec             	pushl  -0x14(%ebp)
  801f9e:	e8 63 12 00 00       	call   803206 <insert_sorted_with_merge_freeList>
  801fa3:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801fa6:	90                   	nop
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 38             	sub    $0x38,%esp
  801faf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb2:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb5:	e8 c8 fc ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fbe:	75 0a                	jne    801fca <smalloc+0x21>
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc5:	e9 a0 00 00 00       	jmp    80206a <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801fca:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801fd1:	76 0a                	jbe    801fdd <smalloc+0x34>
		return NULL;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	e9 8d 00 00 00       	jmp    80206a <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801fdd:	e8 1b 07 00 00       	call   8026fd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	74 7f                	je     802065 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801fe6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	01 d0                	add    %edx,%eax
  801ff5:	48                   	dec    %eax
  801ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffc:	ba 00 00 00 00       	mov    $0x0,%edx
  802001:	f7 75 f4             	divl   -0xc(%ebp)
  802004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802007:	29 d0                	sub    %edx,%eax
  802009:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	ff 75 ec             	pushl  -0x14(%ebp)
  802012:	e8 65 0c 00 00       	call   802c7c <alloc_block_FF>
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80201d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802021:	74 42                	je     802065 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	ff 75 e8             	pushl  -0x18(%ebp)
  802029:	e8 9f 0a 00 00       	call   802acd <insert_sorted_allocList>
  80202e:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802034:	8b 40 08             	mov    0x8(%eax),%eax
  802037:	89 c2                	mov    %eax,%edx
  802039:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 38 04 00 00       	call   802482 <sys_createSharedObject>
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  802050:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802054:	79 07                	jns    80205d <smalloc+0xb4>
	    		  return NULL;
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	eb 0d                	jmp    80206a <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80205d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802060:	8b 40 08             	mov    0x8(%eax),%eax
  802063:	eb 05                	jmp    80206a <smalloc+0xc1>


				}


		return NULL;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802072:	e8 0b fc ff ff       	call   801c82 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802077:	e8 81 06 00 00       	call   8026fd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80207c:	85 c0                	test   %eax,%eax
  80207e:	0f 84 9f 00 00 00    	je     802123 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802084:	83 ec 08             	sub    $0x8,%esp
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	e8 1a 04 00 00       	call   8024ac <sys_getSizeOfSharedObject>
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  802098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209c:	79 0a                	jns    8020a8 <sget+0x3c>
		return NULL;
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	e9 80 00 00 00       	jmp    802128 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8020a8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	48                   	dec    %eax
  8020b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020be:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c3:	f7 75 f0             	divl   -0x10(%ebp)
  8020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c9:	29 d0                	sub    %edx,%eax
  8020cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8020ce:	83 ec 0c             	sub    $0xc,%esp
  8020d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8020d4:	e8 a3 0b 00 00       	call   802c7c <alloc_block_FF>
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8020df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020e3:	74 3e                	je     802123 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020eb:	e8 dd 09 00 00       	call   802acd <insert_sorted_allocList>
  8020f0:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8020f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f6:	8b 40 08             	mov    0x8(%eax),%eax
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	50                   	push   %eax
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	e8 c1 03 00 00       	call   8024c9 <sys_getSharedObject>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80210e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802112:	79 07                	jns    80211b <sget+0xaf>
	    		  return NULL;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	eb 0d                	jmp    802128 <sget+0xbc>
	  	return(void*) returned_block->sva;
  80211b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80211e:	8b 40 08             	mov    0x8(%eax),%eax
  802121:	eb 05                	jmp    802128 <sget+0xbc>
	      }
	}
	   return NULL;
  802123:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802130:	e8 4d fb ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	68 60 43 80 00       	push   $0x804360
  80213d:	68 12 01 00 00       	push   $0x112
  802142:	68 53 43 80 00       	push   $0x804353
  802147:	e8 f8 ea ff ff       	call   800c44 <_panic>

0080214c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	68 88 43 80 00       	push   $0x804388
  80215a:	68 26 01 00 00       	push   $0x126
  80215f:	68 53 43 80 00       	push   $0x804353
  802164:	e8 db ea ff ff       	call   800c44 <_panic>

00802169 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 ac 43 80 00       	push   $0x8043ac
  802177:	68 31 01 00 00       	push   $0x131
  80217c:	68 53 43 80 00       	push   $0x804353
  802181:	e8 be ea ff ff       	call   800c44 <_panic>

00802186 <shrink>:

}
void shrink(uint32 newSize)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	68 ac 43 80 00       	push   $0x8043ac
  802194:	68 36 01 00 00       	push   $0x136
  802199:	68 53 43 80 00       	push   $0x804353
  80219e:	e8 a1 ea ff ff       	call   800c44 <_panic>

008021a3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	68 ac 43 80 00       	push   $0x8043ac
  8021b1:	68 3b 01 00 00       	push   $0x13b
  8021b6:	68 53 43 80 00       	push   $0x804353
  8021bb:	e8 84 ea ff ff       	call   800c44 <_panic>

008021c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	57                   	push   %edi
  8021c4:	56                   	push   %esi
  8021c5:	53                   	push   %ebx
  8021c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021db:	cd 30                	int    $0x30
  8021dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5e                   	pop    %esi
  8021e8:	5f                   	pop    %edi
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	52                   	push   %edx
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	50                   	push   %eax
  802207:	6a 00                	push   $0x0
  802209:	e8 b2 ff ff ff       	call   8021c0 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_cgetc>:

int
sys_cgetc(void)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 01                	push   $0x1
  802223:	e8 98 ff ff ff       	call   8021c0 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802230:	8b 55 0c             	mov    0xc(%ebp),%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	52                   	push   %edx
  80223d:	50                   	push   %eax
  80223e:	6a 05                	push   $0x5
  802240:	e8 7b ff ff ff       	call   8021c0 <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	56                   	push   %esi
  80224e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80224f:	8b 75 18             	mov    0x18(%ebp),%esi
  802252:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802255:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	51                   	push   %ecx
  802261:	52                   	push   %edx
  802262:	50                   	push   %eax
  802263:	6a 06                	push   $0x6
  802265:	e8 56 ff ff ff       	call   8021c0 <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    

00802274 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	52                   	push   %edx
  802284:	50                   	push   %eax
  802285:	6a 07                	push   $0x7
  802287:	e8 34 ff ff ff       	call   8021c0 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	ff 75 08             	pushl  0x8(%ebp)
  8022a0:	6a 08                	push   $0x8
  8022a2:	e8 19 ff ff ff       	call   8021c0 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 09                	push   $0x9
  8022bb:	e8 00 ff ff ff       	call   8021c0 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 0a                	push   $0xa
  8022d4:	e8 e7 fe ff ff       	call   8021c0 <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 0b                	push   $0xb
  8022ed:	e8 ce fe ff ff       	call   8021c0 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	6a 0f                	push   $0xf
  802308:	e8 b3 fe ff ff       	call   8021c0 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
	return;
  802310:	90                   	nop
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	ff 75 0c             	pushl  0xc(%ebp)
  80231f:	ff 75 08             	pushl  0x8(%ebp)
  802322:	6a 10                	push   $0x10
  802324:	e8 97 fe ff ff       	call   8021c0 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
	return ;
  80232c:	90                   	nop
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	ff 75 10             	pushl  0x10(%ebp)
  802339:	ff 75 0c             	pushl  0xc(%ebp)
  80233c:	ff 75 08             	pushl  0x8(%ebp)
  80233f:	6a 11                	push   $0x11
  802341:	e8 7a fe ff ff       	call   8021c0 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
	return ;
  802349:	90                   	nop
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 0c                	push   $0xc
  80235b:	e8 60 fe ff ff       	call   8021c0 <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	ff 75 08             	pushl  0x8(%ebp)
  802373:	6a 0d                	push   $0xd
  802375:	e8 46 fe ff ff       	call   8021c0 <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 0e                	push   $0xe
  80238e:	e8 2d fe ff ff       	call   8021c0 <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	90                   	nop
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 13                	push   $0x13
  8023a8:	e8 13 fe ff ff       	call   8021c0 <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	90                   	nop
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 14                	push   $0x14
  8023c2:	e8 f9 fd ff ff       	call   8021c0 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	90                   	nop
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_cputc>:


void
sys_cputc(const char c)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	50                   	push   %eax
  8023e6:	6a 15                	push   $0x15
  8023e8:	e8 d3 fd ff ff       	call   8021c0 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	90                   	nop
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 16                	push   $0x16
  802402:	e8 b9 fd ff ff       	call   8021c0 <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
}
  80240a:	90                   	nop
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	ff 75 0c             	pushl  0xc(%ebp)
  80241c:	50                   	push   %eax
  80241d:	6a 17                	push   $0x17
  80241f:	e8 9c fd ff ff       	call   8021c0 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80242c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	52                   	push   %edx
  802439:	50                   	push   %eax
  80243a:	6a 1a                	push   $0x1a
  80243c:	e8 7f fd ff ff       	call   8021c0 <syscall>
  802441:	83 c4 18             	add    $0x18,%esp
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	52                   	push   %edx
  802456:	50                   	push   %eax
  802457:	6a 18                	push   $0x18
  802459:	e8 62 fd ff ff       	call   8021c0 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
}
  802461:	90                   	nop
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	52                   	push   %edx
  802474:	50                   	push   %eax
  802475:	6a 19                	push   $0x19
  802477:	e8 44 fd ff ff       	call   8021c0 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	90                   	nop
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 04             	sub    $0x4,%esp
  802488:	8b 45 10             	mov    0x10(%ebp),%eax
  80248b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80248e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802491:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	51                   	push   %ecx
  80249b:	52                   	push   %edx
  80249c:	ff 75 0c             	pushl  0xc(%ebp)
  80249f:	50                   	push   %eax
  8024a0:	6a 1b                	push   $0x1b
  8024a2:	e8 19 fd ff ff       	call   8021c0 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	52                   	push   %edx
  8024bc:	50                   	push   %eax
  8024bd:	6a 1c                	push   $0x1c
  8024bf:	e8 fc fc ff ff       	call   8021c0 <syscall>
  8024c4:	83 c4 18             	add    $0x18,%esp
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	51                   	push   %ecx
  8024da:	52                   	push   %edx
  8024db:	50                   	push   %eax
  8024dc:	6a 1d                	push   $0x1d
  8024de:	e8 dd fc ff ff       	call   8021c0 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	6a 1e                	push   $0x1e
  8024fb:	e8 c0 fc ff ff       	call   8021c0 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 1f                	push   $0x1f
  802514:	e8 a7 fc ff ff       	call   8021c0 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	ff 75 14             	pushl  0x14(%ebp)
  802529:	ff 75 10             	pushl  0x10(%ebp)
  80252c:	ff 75 0c             	pushl  0xc(%ebp)
  80252f:	50                   	push   %eax
  802530:	6a 20                	push   $0x20
  802532:	e8 89 fc ff ff       	call   8021c0 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	50                   	push   %eax
  80254b:	6a 21                	push   $0x21
  80254d:	e8 6e fc ff ff       	call   8021c0 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	90                   	nop
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	50                   	push   %eax
  802567:	6a 22                	push   $0x22
  802569:	e8 52 fc ff ff       	call   8021c0 <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 02                	push   $0x2
  802582:	e8 39 fc ff ff       	call   8021c0 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 03                	push   $0x3
  80259b:	e8 20 fc ff ff       	call   8021c0 <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 04                	push   $0x4
  8025b4:	e8 07 fc ff ff       	call   8021c0 <syscall>
  8025b9:	83 c4 18             	add    $0x18,%esp
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <sys_exit_env>:


void sys_exit_env(void)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 23                	push   $0x23
  8025cd:	e8 ee fb ff ff       	call   8021c0 <syscall>
  8025d2:	83 c4 18             	add    $0x18,%esp
}
  8025d5:	90                   	nop
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025e1:	8d 50 04             	lea    0x4(%eax),%edx
  8025e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	52                   	push   %edx
  8025ee:	50                   	push   %eax
  8025ef:	6a 24                	push   $0x24
  8025f1:	e8 ca fb ff ff       	call   8021c0 <syscall>
  8025f6:	83 c4 18             	add    $0x18,%esp
	return result;
  8025f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802602:	89 01                	mov    %eax,(%ecx)
  802604:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	c9                   	leave  
  80260b:	c2 04 00             	ret    $0x4

0080260e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	ff 75 10             	pushl  0x10(%ebp)
  802618:	ff 75 0c             	pushl  0xc(%ebp)
  80261b:	ff 75 08             	pushl  0x8(%ebp)
  80261e:	6a 12                	push   $0x12
  802620:	e8 9b fb ff ff       	call   8021c0 <syscall>
  802625:	83 c4 18             	add    $0x18,%esp
	return ;
  802628:	90                   	nop
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_rcr2>:
uint32 sys_rcr2()
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 25                	push   $0x25
  80263a:	e8 81 fb ff ff       	call   8021c0 <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 04             	sub    $0x4,%esp
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802650:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	50                   	push   %eax
  80265d:	6a 26                	push   $0x26
  80265f:	e8 5c fb ff ff       	call   8021c0 <syscall>
  802664:	83 c4 18             	add    $0x18,%esp
	return ;
  802667:	90                   	nop
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <rsttst>:
void rsttst()
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 28                	push   $0x28
  802679:	e8 42 fb ff ff       	call   8021c0 <syscall>
  80267e:	83 c4 18             	add    $0x18,%esp
	return ;
  802681:	90                   	nop
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 04             	sub    $0x4,%esp
  80268a:	8b 45 14             	mov    0x14(%ebp),%eax
  80268d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802690:	8b 55 18             	mov    0x18(%ebp),%edx
  802693:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	ff 75 10             	pushl  0x10(%ebp)
  80269c:	ff 75 0c             	pushl  0xc(%ebp)
  80269f:	ff 75 08             	pushl  0x8(%ebp)
  8026a2:	6a 27                	push   $0x27
  8026a4:	e8 17 fb ff ff       	call   8021c0 <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ac:	90                   	nop
}
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    

008026af <chktst>:
void chktst(uint32 n)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	ff 75 08             	pushl  0x8(%ebp)
  8026bd:	6a 29                	push   $0x29
  8026bf:	e8 fc fa ff ff       	call   8021c0 <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c7:	90                   	nop
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <inctst>:

void inctst()
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 2a                	push   $0x2a
  8026d9:	e8 e2 fa ff ff       	call   8021c0 <syscall>
  8026de:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e1:	90                   	nop
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <gettst>:
uint32 gettst()
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 2b                	push   $0x2b
  8026f3:	e8 c8 fa ff ff       	call   8021c0 <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 2c                	push   $0x2c
  80270f:	e8 ac fa ff ff       	call   8021c0 <syscall>
  802714:	83 c4 18             	add    $0x18,%esp
  802717:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80271a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80271e:	75 07                	jne    802727 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802720:	b8 01 00 00 00       	mov    $0x1,%eax
  802725:	eb 05                	jmp    80272c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 2c                	push   $0x2c
  802740:	e8 7b fa ff ff       	call   8021c0 <syscall>
  802745:	83 c4 18             	add    $0x18,%esp
  802748:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80274b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80274f:	75 07                	jne    802758 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802751:	b8 01 00 00 00       	mov    $0x1,%eax
  802756:	eb 05                	jmp    80275d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    

0080275f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 2c                	push   $0x2c
  802771:	e8 4a fa ff ff       	call   8021c0 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
  802779:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80277c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802780:	75 07                	jne    802789 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802782:	b8 01 00 00 00       	mov    $0x1,%eax
  802787:	eb 05                	jmp    80278e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 2c                	push   $0x2c
  8027a2:	e8 19 fa ff ff       	call   8021c0 <syscall>
  8027a7:	83 c4 18             	add    $0x18,%esp
  8027aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027b1:	75 07                	jne    8027ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b8:	eb 05                	jmp    8027bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	ff 75 08             	pushl  0x8(%ebp)
  8027cf:	6a 2d                	push   $0x2d
  8027d1:	e8 ea f9 ff ff       	call   8021c0 <syscall>
  8027d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d9:	90                   	nop
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	6a 00                	push   $0x0
  8027ee:	53                   	push   %ebx
  8027ef:	51                   	push   %ecx
  8027f0:	52                   	push   %edx
  8027f1:	50                   	push   %eax
  8027f2:	6a 2e                	push   $0x2e
  8027f4:	e8 c7 f9 ff ff       	call   8021c0 <syscall>
  8027f9:	83 c4 18             	add    $0x18,%esp
}
  8027fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802804:	8b 55 0c             	mov    0xc(%ebp),%edx
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	52                   	push   %edx
  802811:	50                   	push   %eax
  802812:	6a 2f                	push   $0x2f
  802814:	e8 a7 f9 ff ff       	call   8021c0 <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
}
  80281c:	c9                   	leave  
  80281d:	c3                   	ret    

0080281e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	68 bc 43 80 00       	push   $0x8043bc
  80282c:	e8 c7 e6 ff ff       	call   800ef8 <cprintf>
  802831:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802834:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	68 e8 43 80 00       	push   $0x8043e8
  802843:	e8 b0 e6 ff ff       	call   800ef8 <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80284b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80284f:	a1 38 51 80 00       	mov    0x805138,%eax
  802854:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802857:	eb 56                	jmp    8028af <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802859:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80285d:	74 1c                	je     80287b <print_mem_block_lists+0x5d>
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 50 08             	mov    0x8(%eax),%edx
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	8b 48 08             	mov    0x8(%eax),%ecx
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	01 c8                	add    %ecx,%eax
  802873:	39 c2                	cmp    %eax,%edx
  802875:	73 04                	jae    80287b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802877:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 50 08             	mov    0x8(%eax),%edx
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	01 c2                	add    %eax,%edx
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 40 08             	mov    0x8(%eax),%eax
  80288f:	83 ec 04             	sub    $0x4,%esp
  802892:	52                   	push   %edx
  802893:	50                   	push   %eax
  802894:	68 fd 43 80 00       	push   $0x8043fd
  802899:	e8 5a e6 ff ff       	call   800ef8 <cprintf>
  80289e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b3:	74 07                	je     8028bc <print_mem_block_lists+0x9e>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	eb 05                	jmp    8028c1 <print_mem_block_lists+0xa3>
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8028c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	75 8a                	jne    802859 <print_mem_block_lists+0x3b>
  8028cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d3:	75 84                	jne    802859 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028d9:	75 10                	jne    8028eb <print_mem_block_lists+0xcd>
  8028db:	83 ec 0c             	sub    $0xc,%esp
  8028de:	68 0c 44 80 00       	push   $0x80440c
  8028e3:	e8 10 e6 ff ff       	call   800ef8 <cprintf>
  8028e8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028f2:	83 ec 0c             	sub    $0xc,%esp
  8028f5:	68 30 44 80 00       	push   $0x804430
  8028fa:	e8 f9 e5 ff ff       	call   800ef8 <cprintf>
  8028ff:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802902:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802906:	a1 40 50 80 00       	mov    0x805040,%eax
  80290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290e:	eb 56                	jmp    802966 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802910:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802914:	74 1c                	je     802932 <print_mem_block_lists+0x114>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 50 08             	mov    0x8(%eax),%edx
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	8b 48 08             	mov    0x8(%eax),%ecx
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	01 c8                	add    %ecx,%eax
  80292a:	39 c2                	cmp    %eax,%edx
  80292c:	73 04                	jae    802932 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80292e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 50 08             	mov    0x8(%eax),%edx
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 40 0c             	mov    0xc(%eax),%eax
  80293e:	01 c2                	add    %eax,%edx
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 08             	mov    0x8(%eax),%eax
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	52                   	push   %edx
  80294a:	50                   	push   %eax
  80294b:	68 fd 43 80 00       	push   $0x8043fd
  802950:	e8 a3 e5 ff ff       	call   800ef8 <cprintf>
  802955:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80295e:	a1 48 50 80 00       	mov    0x805048,%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	74 07                	je     802973 <print_mem_block_lists+0x155>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	eb 05                	jmp    802978 <print_mem_block_lists+0x15a>
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	a3 48 50 80 00       	mov    %eax,0x805048
  80297d:	a1 48 50 80 00       	mov    0x805048,%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	75 8a                	jne    802910 <print_mem_block_lists+0xf2>
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	75 84                	jne    802910 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80298c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802990:	75 10                	jne    8029a2 <print_mem_block_lists+0x184>
  802992:	83 ec 0c             	sub    $0xc,%esp
  802995:	68 48 44 80 00       	push   $0x804448
  80299a:	e8 59 e5 ff ff       	call   800ef8 <cprintf>
  80299f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029a2:	83 ec 0c             	sub    $0xc,%esp
  8029a5:	68 bc 43 80 00       	push   $0x8043bc
  8029aa:	e8 49 e5 ff ff       	call   800ef8 <cprintf>
  8029af:	83 c4 10             	add    $0x10,%esp

}
  8029b2:	90                   	nop
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8029bb:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029c2:	00 00 00 
  8029c5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029cc:	00 00 00 
  8029cf:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029d6:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8029d9:	a1 50 50 80 00       	mov    0x805050,%eax
  8029de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8029e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029e8:	e9 9e 00 00 00       	jmp    802a8b <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8029ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	c1 e2 04             	shl    $0x4,%edx
  8029f8:	01 d0                	add    %edx,%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	75 14                	jne    802a12 <initialize_MemBlocksList+0x5d>
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	68 70 44 80 00       	push   $0x804470
  802a06:	6a 48                	push   $0x48
  802a08:	68 93 44 80 00       	push   $0x804493
  802a0d:	e8 32 e2 ff ff       	call   800c44 <_panic>
  802a12:	a1 50 50 80 00       	mov    0x805050,%eax
  802a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1a:	c1 e2 04             	shl    $0x4,%edx
  802a1d:	01 d0                	add    %edx,%eax
  802a1f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a25:	89 10                	mov    %edx,(%eax)
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 18                	je     802a45 <initialize_MemBlocksList+0x90>
  802a2d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a32:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a38:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a3b:	c1 e1 04             	shl    $0x4,%ecx
  802a3e:	01 ca                	add    %ecx,%edx
  802a40:	89 50 04             	mov    %edx,0x4(%eax)
  802a43:	eb 12                	jmp    802a57 <initialize_MemBlocksList+0xa2>
  802a45:	a1 50 50 80 00       	mov    0x805050,%eax
  802a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4d:	c1 e2 04             	shl    $0x4,%edx
  802a50:	01 d0                	add    %edx,%eax
  802a52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a57:	a1 50 50 80 00       	mov    0x805050,%eax
  802a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5f:	c1 e2 04             	shl    $0x4,%edx
  802a62:	01 d0                	add    %edx,%eax
  802a64:	a3 48 51 80 00       	mov    %eax,0x805148
  802a69:	a1 50 50 80 00       	mov    0x805050,%eax
  802a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a71:	c1 e2 04             	shl    $0x4,%edx
  802a74:	01 d0                	add    %edx,%eax
  802a76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7d:	a1 54 51 80 00       	mov    0x805154,%eax
  802a82:	40                   	inc    %eax
  802a83:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802a88:	ff 45 f4             	incl   -0xc(%ebp)
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a91:	0f 82 56 ff ff ff    	jb     8029ed <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802a97:	90                   	nop
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802aa8:	eb 18                	jmp    802ac2 <find_block+0x28>
		{
			if(tmp->sva==va)
  802aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aad:	8b 40 08             	mov    0x8(%eax),%eax
  802ab0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ab3:	75 05                	jne    802aba <find_block+0x20>
			{
				return tmp;
  802ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ab8:	eb 11                	jmp    802acb <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802ac2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ac6:	75 e2                	jne    802aaa <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802acb:	c9                   	leave  
  802acc:	c3                   	ret    

00802acd <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802acd:	55                   	push   %ebp
  802ace:	89 e5                	mov    %esp,%ebp
  802ad0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802ad3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	0f 85 83 00 00 00    	jne    802b63 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802ae0:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802ae7:	00 00 00 
  802aea:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802af1:	00 00 00 
  802af4:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802afb:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802afe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b02:	75 14                	jne    802b18 <insert_sorted_allocList+0x4b>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 70 44 80 00       	push   $0x804470
  802b0c:	6a 7f                	push   $0x7f
  802b0e:	68 93 44 80 00       	push   $0x804493
  802b13:	e8 2c e1 ff ff       	call   800c44 <_panic>
  802b18:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	89 10                	mov    %edx,(%eax)
  802b23:	8b 45 08             	mov    0x8(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 0d                	je     802b39 <insert_sorted_allocList+0x6c>
  802b2c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b31:	8b 55 08             	mov    0x8(%ebp),%edx
  802b34:	89 50 04             	mov    %edx,0x4(%eax)
  802b37:	eb 08                	jmp    802b41 <insert_sorted_allocList+0x74>
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	a3 44 50 80 00       	mov    %eax,0x805044
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	a3 40 50 80 00       	mov    %eax,0x805040
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b53:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b58:	40                   	inc    %eax
  802b59:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802b5e:	e9 16 01 00 00       	jmp    802c79 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	a1 44 50 80 00       	mov    0x805044,%eax
  802b6e:	8b 40 08             	mov    0x8(%eax),%eax
  802b71:	39 c2                	cmp    %eax,%edx
  802b73:	76 68                	jbe    802bdd <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802b75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b79:	75 17                	jne    802b92 <insert_sorted_allocList+0xc5>
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 ac 44 80 00       	push   $0x8044ac
  802b83:	68 85 00 00 00       	push   $0x85
  802b88:	68 93 44 80 00       	push   $0x804493
  802b8d:	e8 b2 e0 ff ff       	call   800c44 <_panic>
  802b92:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0c                	je     802bb4 <insert_sorted_allocList+0xe7>
  802ba8:	a1 44 50 80 00       	mov    0x805044,%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	eb 08                	jmp    802bbc <insert_sorted_allocList+0xef>
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	a3 40 50 80 00       	mov    %eax,0x805040
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bd2:	40                   	inc    %eax
  802bd3:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802bd8:	e9 9c 00 00 00       	jmp    802c79 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802bdd:	a1 40 50 80 00       	mov    0x805040,%eax
  802be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802be5:	e9 85 00 00 00       	jmp    802c6f <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	8b 50 08             	mov    0x8(%eax),%edx
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 08             	mov    0x8(%eax),%eax
  802bf6:	39 c2                	cmp    %eax,%edx
  802bf8:	73 6d                	jae    802c67 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfe:	74 06                	je     802c06 <insert_sorted_allocList+0x139>
  802c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c04:	75 17                	jne    802c1d <insert_sorted_allocList+0x150>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 d0 44 80 00       	push   $0x8044d0
  802c0e:	68 90 00 00 00       	push   $0x90
  802c13:	68 93 44 80 00       	push   $0x804493
  802c18:	e8 27 e0 ff ff       	call   800c44 <_panic>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 50 04             	mov    0x4(%eax),%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 50 04             	mov    %edx,0x4(%eax)
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 0d                	je     802c48 <insert_sorted_allocList+0x17b>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	8b 55 08             	mov    0x8(%ebp),%edx
  802c44:	89 10                	mov    %edx,(%eax)
  802c46:	eb 08                	jmp    802c50 <insert_sorted_allocList+0x183>
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	a3 40 50 80 00       	mov    %eax,0x805040
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 55 08             	mov    0x8(%ebp),%edx
  802c56:	89 50 04             	mov    %edx,0x4(%eax)
  802c59:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c5e:	40                   	inc    %eax
  802c5f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c64:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802c65:	eb 12                	jmp    802c79 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	0f 85 71 ff ff ff    	jne    802bea <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802c79:	90                   	nop
  802c7a:	c9                   	leave  
  802c7b:	c3                   	ret    

00802c7c <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802c7c:	55                   	push   %ebp
  802c7d:	89 e5                	mov    %esp,%ebp
  802c7f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802c82:	a1 38 51 80 00       	mov    0x805138,%eax
  802c87:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802c8a:	e9 76 01 00 00       	jmp    802e05 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 40 0c             	mov    0xc(%eax),%eax
  802c95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c98:	0f 85 8a 00 00 00    	jne    802d28 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca2:	75 17                	jne    802cbb <alloc_block_FF+0x3f>
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 05 45 80 00       	push   $0x804505
  802cac:	68 a8 00 00 00       	push   $0xa8
  802cb1:	68 93 44 80 00       	push   $0x804493
  802cb6:	e8 89 df ff ff       	call   800c44 <_panic>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 10                	je     802cd4 <alloc_block_FF+0x58>
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccc:	8b 52 04             	mov    0x4(%edx),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	eb 0b                	jmp    802cdf <alloc_block_FF+0x63>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 04             	mov    0x4(%eax),%eax
  802cda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 0f                	je     802cf8 <alloc_block_FF+0x7c>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 04             	mov    0x4(%eax),%eax
  802cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf2:	8b 12                	mov    (%edx),%edx
  802cf4:	89 10                	mov    %edx,(%eax)
  802cf6:	eb 0a                	jmp    802d02 <alloc_block_FF+0x86>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	a3 38 51 80 00       	mov    %eax,0x805138
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d15:	a1 44 51 80 00       	mov    0x805144,%eax
  802d1a:	48                   	dec    %eax
  802d1b:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	e9 ea 00 00 00       	jmp    802e12 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d31:	0f 86 c6 00 00 00    	jbe    802dfd <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802d37:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 50 08             	mov    0x8(%eax),%edx
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d5d:	89 c2                	mov    %eax,%edx
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 50 08             	mov    0x8(%eax),%edx
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	01 c2                	add    %eax,%edx
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802d76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7a:	75 17                	jne    802d93 <alloc_block_FF+0x117>
  802d7c:	83 ec 04             	sub    $0x4,%esp
  802d7f:	68 05 45 80 00       	push   $0x804505
  802d84:	68 b6 00 00 00       	push   $0xb6
  802d89:	68 93 44 80 00       	push   $0x804493
  802d8e:	e8 b1 de ff ff       	call   800c44 <_panic>
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	85 c0                	test   %eax,%eax
  802d9a:	74 10                	je     802dac <alloc_block_FF+0x130>
  802d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da4:	8b 52 04             	mov    0x4(%edx),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%eax)
  802daa:	eb 0b                	jmp    802db7 <alloc_block_FF+0x13b>
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	8b 40 04             	mov    0x4(%eax),%eax
  802db2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 0f                	je     802dd0 <alloc_block_FF+0x154>
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dca:	8b 12                	mov    (%edx),%edx
  802dcc:	89 10                	mov    %edx,(%eax)
  802dce:	eb 0a                	jmp    802dda <alloc_block_FF+0x15e>
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	a3 48 51 80 00       	mov    %eax,0x805148
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ded:	a1 54 51 80 00       	mov    0x805154,%eax
  802df2:	48                   	dec    %eax
  802df3:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	eb 15                	jmp    802e12 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802e05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e09:	0f 85 80 fe ff ff    	jne    802c8f <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802e12:	c9                   	leave  
  802e13:	c3                   	ret    

00802e14 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
  802e17:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802e1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802e22:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802e29:	e9 c0 00 00 00       	jmp    802eee <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e37:	0f 85 8a 00 00 00    	jne    802ec7 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	75 17                	jne    802e5a <alloc_block_BF+0x46>
  802e43:	83 ec 04             	sub    $0x4,%esp
  802e46:	68 05 45 80 00       	push   $0x804505
  802e4b:	68 cf 00 00 00       	push   $0xcf
  802e50:	68 93 44 80 00       	push   $0x804493
  802e55:	e8 ea dd ff ff       	call   800c44 <_panic>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	74 10                	je     802e73 <alloc_block_BF+0x5f>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6b:	8b 52 04             	mov    0x4(%edx),%edx
  802e6e:	89 50 04             	mov    %edx,0x4(%eax)
  802e71:	eb 0b                	jmp    802e7e <alloc_block_BF+0x6a>
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 40 04             	mov    0x4(%eax),%eax
  802e79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 40 04             	mov    0x4(%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 0f                	je     802e97 <alloc_block_BF+0x83>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 40 04             	mov    0x4(%eax),%eax
  802e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e91:	8b 12                	mov    (%edx),%edx
  802e93:	89 10                	mov    %edx,(%eax)
  802e95:	eb 0a                	jmp    802ea1 <alloc_block_BF+0x8d>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb4:	a1 44 51 80 00       	mov    0x805144,%eax
  802eb9:	48                   	dec    %eax
  802eba:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	e9 2a 01 00 00       	jmp    802ff1 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ed0:	73 14                	jae    802ee6 <alloc_block_BF+0xd2>
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802edb:	76 09                	jbe    802ee6 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef2:	0f 85 36 ff ff ff    	jne    802e2e <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802ef8:	a1 38 51 80 00       	mov    0x805138,%eax
  802efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802f00:	e9 dd 00 00 00       	jmp    802fe2 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f0e:	0f 85 c6 00 00 00    	jne    802fda <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802f14:	a1 48 51 80 00       	mov    0x805148,%eax
  802f19:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 50 08             	mov    0x8(%eax),%edx
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2e:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	01 c2                	add    %eax,%edx
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 40 0c             	mov    0xc(%eax),%eax
  802f48:	2b 45 08             	sub    0x8(%ebp),%eax
  802f4b:	89 c2                	mov    %eax,%edx
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802f53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f57:	75 17                	jne    802f70 <alloc_block_BF+0x15c>
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	68 05 45 80 00       	push   $0x804505
  802f61:	68 eb 00 00 00       	push   $0xeb
  802f66:	68 93 44 80 00       	push   $0x804493
  802f6b:	e8 d4 dc ff ff       	call   800c44 <_panic>
  802f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 10                	je     802f89 <alloc_block_BF+0x175>
  802f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f81:	8b 52 04             	mov    0x4(%edx),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	eb 0b                	jmp    802f94 <alloc_block_BF+0x180>
  802f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	74 0f                	je     802fad <alloc_block_BF+0x199>
  802f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fa7:	8b 12                	mov    (%edx),%edx
  802fa9:	89 10                	mov    %edx,(%eax)
  802fab:	eb 0a                	jmp    802fb7 <alloc_block_BF+0x1a3>
  802fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fca:	a1 54 51 80 00       	mov    0x805154,%eax
  802fcf:	48                   	dec    %eax
  802fd0:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd8:	eb 17                	jmp    802ff1 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe6:	0f 85 19 ff ff ff    	jne    802f05 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802fec:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
  802ff6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802ff9:	a1 40 50 80 00       	mov    0x805040,%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	75 19                	jne    80301b <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803002:	83 ec 0c             	sub    $0xc,%esp
  803005:	ff 75 08             	pushl  0x8(%ebp)
  803008:	e8 6f fc ff ff       	call   802c7c <alloc_block_FF>
  80300d:	83 c4 10             	add    $0x10,%esp
  803010:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	e9 e9 01 00 00       	jmp    803204 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80301b:	a1 44 50 80 00       	mov    0x805044,%eax
  803020:	8b 40 08             	mov    0x8(%eax),%eax
  803023:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  803026:	a1 44 50 80 00       	mov    0x805044,%eax
  80302b:	8b 50 0c             	mov    0xc(%eax),%edx
  80302e:	a1 44 50 80 00       	mov    0x805044,%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	01 d0                	add    %edx,%eax
  803038:	83 ec 08             	sub    $0x8,%esp
  80303b:	50                   	push   %eax
  80303c:	68 38 51 80 00       	push   $0x805138
  803041:	e8 54 fa ff ff       	call   802a9a <find_block>
  803046:	83 c4 10             	add    $0x10,%esp
  803049:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 40 0c             	mov    0xc(%eax),%eax
  803052:	3b 45 08             	cmp    0x8(%ebp),%eax
  803055:	0f 85 9b 00 00 00    	jne    8030f6 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 50 0c             	mov    0xc(%eax),%edx
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 40 08             	mov    0x8(%eax),%eax
  803067:	01 d0                	add    %edx,%eax
  803069:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80306c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803070:	75 17                	jne    803089 <alloc_block_NF+0x96>
  803072:	83 ec 04             	sub    $0x4,%esp
  803075:	68 05 45 80 00       	push   $0x804505
  80307a:	68 1a 01 00 00       	push   $0x11a
  80307f:	68 93 44 80 00       	push   $0x804493
  803084:	e8 bb db ff ff       	call   800c44 <_panic>
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	74 10                	je     8030a2 <alloc_block_NF+0xaf>
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309a:	8b 52 04             	mov    0x4(%edx),%edx
  80309d:	89 50 04             	mov    %edx,0x4(%eax)
  8030a0:	eb 0b                	jmp    8030ad <alloc_block_NF+0xba>
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	8b 40 04             	mov    0x4(%eax),%eax
  8030a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 40 04             	mov    0x4(%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 0f                	je     8030c6 <alloc_block_NF+0xd3>
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c0:	8b 12                	mov    (%edx),%edx
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	eb 0a                	jmp    8030d0 <alloc_block_NF+0xdd>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e8:	48                   	dec    %eax
  8030e9:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	e9 0e 01 00 00       	jmp    803204 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ff:	0f 86 cf 00 00 00    	jbe    8031d4 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803105:	a1 48 51 80 00       	mov    0x805148,%eax
  80310a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80310d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803110:	8b 55 08             	mov    0x8(%ebp),%edx
  803113:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 50 08             	mov    0x8(%eax),%edx
  80311c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311f:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 50 08             	mov    0x8(%eax),%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	01 c2                	add    %eax,%edx
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 0c             	mov    0xc(%eax),%eax
  803139:	2b 45 08             	sub    0x8(%ebp),%eax
  80313c:	89 c2                	mov    %eax,%edx
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	8b 40 08             	mov    0x8(%eax),%eax
  80314a:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80314d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803151:	75 17                	jne    80316a <alloc_block_NF+0x177>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 05 45 80 00       	push   $0x804505
  80315b:	68 28 01 00 00       	push   $0x128
  803160:	68 93 44 80 00       	push   $0x804493
  803165:	e8 da da ff ff       	call   800c44 <_panic>
  80316a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 10                	je     803183 <alloc_block_NF+0x190>
  803173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80317b:	8b 52 04             	mov    0x4(%edx),%edx
  80317e:	89 50 04             	mov    %edx,0x4(%eax)
  803181:	eb 0b                	jmp    80318e <alloc_block_NF+0x19b>
  803183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80318e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0f                	je     8031a7 <alloc_block_NF+0x1b4>
  803198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a1:	8b 12                	mov    (%edx),%edx
  8031a3:	89 10                	mov    %edx,(%eax)
  8031a5:	eb 0a                	jmp    8031b1 <alloc_block_NF+0x1be>
  8031a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c9:	48                   	dec    %eax
  8031ca:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  8031cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d2:	eb 30                	jmp    803204 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8031d4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8031dc:	75 0a                	jne    8031e8 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8031de:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e6:	eb 08                	jmp    8031f0 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 08             	mov    0x8(%eax),%eax
  8031f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031f9:	0f 85 4d fe ff ff    	jne    80304c <alloc_block_NF+0x59>

			return NULL;
  8031ff:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803204:	c9                   	leave  
  803205:	c3                   	ret    

00803206 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803206:	55                   	push   %ebp
  803207:	89 e5                	mov    %esp,%ebp
  803209:	53                   	push   %ebx
  80320a:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80320d:	a1 38 51 80 00       	mov    0x805138,%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	0f 85 86 00 00 00    	jne    8032a0 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80321a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803221:	00 00 00 
  803224:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80322b:	00 00 00 
  80322e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803235:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803238:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323c:	75 17                	jne    803255 <insert_sorted_with_merge_freeList+0x4f>
  80323e:	83 ec 04             	sub    $0x4,%esp
  803241:	68 70 44 80 00       	push   $0x804470
  803246:	68 48 01 00 00       	push   $0x148
  80324b:	68 93 44 80 00       	push   $0x804493
  803250:	e8 ef d9 ff ff       	call   800c44 <_panic>
  803255:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 0d                	je     803276 <insert_sorted_with_merge_freeList+0x70>
  803269:	a1 38 51 80 00       	mov    0x805138,%eax
  80326e:	8b 55 08             	mov    0x8(%ebp),%edx
  803271:	89 50 04             	mov    %edx,0x4(%eax)
  803274:	eb 08                	jmp    80327e <insert_sorted_with_merge_freeList+0x78>
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	a3 38 51 80 00       	mov    %eax,0x805138
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803290:	a1 44 51 80 00       	mov    0x805144,%eax
  803295:	40                   	inc    %eax
  803296:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80329b:	e9 73 07 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	8b 50 08             	mov    0x8(%eax),%edx
  8032a6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032ab:	8b 40 08             	mov    0x8(%eax),%eax
  8032ae:	39 c2                	cmp    %eax,%edx
  8032b0:	0f 86 84 00 00 00    	jbe    80333a <insert_sorted_with_merge_freeList+0x134>
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 50 08             	mov    0x8(%eax),%edx
  8032bc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032c1:	8b 48 0c             	mov    0xc(%eax),%ecx
  8032c4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032c9:	8b 40 08             	mov    0x8(%eax),%eax
  8032cc:	01 c8                	add    %ecx,%eax
  8032ce:	39 c2                	cmp    %eax,%edx
  8032d0:	74 68                	je     80333a <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8032d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d6:	75 17                	jne    8032ef <insert_sorted_with_merge_freeList+0xe9>
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	68 ac 44 80 00       	push   $0x8044ac
  8032e0:	68 4c 01 00 00       	push   $0x14c
  8032e5:	68 93 44 80 00       	push   $0x804493
  8032ea:	e8 55 d9 ff ff       	call   800c44 <_panic>
  8032ef:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	89 50 04             	mov    %edx,0x4(%eax)
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	85 c0                	test   %eax,%eax
  803303:	74 0c                	je     803311 <insert_sorted_with_merge_freeList+0x10b>
  803305:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80330a:	8b 55 08             	mov    0x8(%ebp),%edx
  80330d:	89 10                	mov    %edx,(%eax)
  80330f:	eb 08                	jmp    803319 <insert_sorted_with_merge_freeList+0x113>
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	a3 38 51 80 00       	mov    %eax,0x805138
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332a:	a1 44 51 80 00       	mov    0x805144,%eax
  80332f:	40                   	inc    %eax
  803330:	a3 44 51 80 00       	mov    %eax,0x805144
  803335:	e9 d9 06 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	8b 50 08             	mov    0x8(%eax),%edx
  803340:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803345:	8b 40 08             	mov    0x8(%eax),%eax
  803348:	39 c2                	cmp    %eax,%edx
  80334a:	0f 86 b5 00 00 00    	jbe    803405 <insert_sorted_with_merge_freeList+0x1ff>
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	8b 50 08             	mov    0x8(%eax),%edx
  803356:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80335b:	8b 48 0c             	mov    0xc(%eax),%ecx
  80335e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803363:	8b 40 08             	mov    0x8(%eax),%eax
  803366:	01 c8                	add    %ecx,%eax
  803368:	39 c2                	cmp    %eax,%edx
  80336a:	0f 85 95 00 00 00    	jne    803405 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803370:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803375:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80337b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80337e:	8b 55 08             	mov    0x8(%ebp),%edx
  803381:	8b 52 0c             	mov    0xc(%edx),%edx
  803384:	01 ca                	add    %ecx,%edx
  803386:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80339d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a1:	75 17                	jne    8033ba <insert_sorted_with_merge_freeList+0x1b4>
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	68 70 44 80 00       	push   $0x804470
  8033ab:	68 54 01 00 00       	push   $0x154
  8033b0:	68 93 44 80 00       	push   $0x804493
  8033b5:	e8 8a d8 ff ff       	call   800c44 <_panic>
  8033ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	89 10                	mov    %edx,(%eax)
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 0d                	je     8033db <insert_sorted_with_merge_freeList+0x1d5>
  8033ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d6:	89 50 04             	mov    %edx,0x4(%eax)
  8033d9:	eb 08                	jmp    8033e3 <insert_sorted_with_merge_freeList+0x1dd>
  8033db:	8b 45 08             	mov    0x8(%ebp),%eax
  8033de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033fa:	40                   	inc    %eax
  8033fb:	a3 54 51 80 00       	mov    %eax,0x805154
  803400:	e9 0e 06 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	8b 50 08             	mov    0x8(%eax),%edx
  80340b:	a1 38 51 80 00       	mov    0x805138,%eax
  803410:	8b 40 08             	mov    0x8(%eax),%eax
  803413:	39 c2                	cmp    %eax,%edx
  803415:	0f 83 c1 00 00 00    	jae    8034dc <insert_sorted_with_merge_freeList+0x2d6>
  80341b:	a1 38 51 80 00       	mov    0x805138,%eax
  803420:	8b 50 08             	mov    0x8(%eax),%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 48 08             	mov    0x8(%eax),%ecx
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 40 0c             	mov    0xc(%eax),%eax
  80342f:	01 c8                	add    %ecx,%eax
  803431:	39 c2                	cmp    %eax,%edx
  803433:	0f 85 a3 00 00 00    	jne    8034dc <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803439:	a1 38 51 80 00       	mov    0x805138,%eax
  80343e:	8b 55 08             	mov    0x8(%ebp),%edx
  803441:	8b 52 08             	mov    0x8(%edx),%edx
  803444:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  803447:	a1 38 51 80 00       	mov    0x805138,%eax
  80344c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803452:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803455:	8b 55 08             	mov    0x8(%ebp),%edx
  803458:	8b 52 0c             	mov    0xc(%edx),%edx
  80345b:	01 ca                	add    %ecx,%edx
  80345d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803474:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803478:	75 17                	jne    803491 <insert_sorted_with_merge_freeList+0x28b>
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	68 70 44 80 00       	push   $0x804470
  803482:	68 5d 01 00 00       	push   $0x15d
  803487:	68 93 44 80 00       	push   $0x804493
  80348c:	e8 b3 d7 ff ff       	call   800c44 <_panic>
  803491:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 0d                	je     8034b2 <insert_sorted_with_merge_freeList+0x2ac>
  8034a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8034aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ad:	89 50 04             	mov    %edx,0x4(%eax)
  8034b0:	eb 08                	jmp    8034ba <insert_sorted_with_merge_freeList+0x2b4>
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d1:	40                   	inc    %eax
  8034d2:	a3 54 51 80 00       	mov    %eax,0x805154
  8034d7:	e9 37 05 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	8b 50 08             	mov    0x8(%eax),%edx
  8034e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034e7:	8b 40 08             	mov    0x8(%eax),%eax
  8034ea:	39 c2                	cmp    %eax,%edx
  8034ec:	0f 83 82 00 00 00    	jae    803574 <insert_sorted_with_merge_freeList+0x36e>
  8034f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034f7:	8b 50 08             	mov    0x8(%eax),%edx
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	8b 48 08             	mov    0x8(%eax),%ecx
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	8b 40 0c             	mov    0xc(%eax),%eax
  803506:	01 c8                	add    %ecx,%eax
  803508:	39 c2                	cmp    %eax,%edx
  80350a:	74 68                	je     803574 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80350c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803510:	75 17                	jne    803529 <insert_sorted_with_merge_freeList+0x323>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 70 44 80 00       	push   $0x804470
  80351a:	68 62 01 00 00       	push   $0x162
  80351f:	68 93 44 80 00       	push   $0x804493
  803524:	e8 1b d7 ff ff       	call   800c44 <_panic>
  803529:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	89 10                	mov    %edx,(%eax)
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0d                	je     80354a <insert_sorted_with_merge_freeList+0x344>
  80353d:	a1 38 51 80 00       	mov    0x805138,%eax
  803542:	8b 55 08             	mov    0x8(%ebp),%edx
  803545:	89 50 04             	mov    %edx,0x4(%eax)
  803548:	eb 08                	jmp    803552 <insert_sorted_with_merge_freeList+0x34c>
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	a3 38 51 80 00       	mov    %eax,0x805138
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803564:	a1 44 51 80 00       	mov    0x805144,%eax
  803569:	40                   	inc    %eax
  80356a:	a3 44 51 80 00       	mov    %eax,0x805144
  80356f:	e9 9f 04 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803574:	a1 38 51 80 00       	mov    0x805138,%eax
  803579:	8b 00                	mov    (%eax),%eax
  80357b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80357e:	e9 84 04 00 00       	jmp    803a07 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 50 08             	mov    0x8(%eax),%edx
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	8b 40 08             	mov    0x8(%eax),%eax
  80358f:	39 c2                	cmp    %eax,%edx
  803591:	0f 86 a9 00 00 00    	jbe    803640 <insert_sorted_with_merge_freeList+0x43a>
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	8b 50 08             	mov    0x8(%eax),%edx
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a9:	01 c8                	add    %ecx,%eax
  8035ab:	39 c2                	cmp    %eax,%edx
  8035ad:	0f 84 8d 00 00 00    	je     803640 <insert_sorted_with_merge_freeList+0x43a>
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	8b 50 08             	mov    0x8(%eax),%edx
  8035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bc:	8b 40 04             	mov    0x4(%eax),%eax
  8035bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	8b 40 04             	mov    0x4(%eax),%eax
  8035c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cb:	01 c8                	add    %ecx,%eax
  8035cd:	39 c2                	cmp    %eax,%edx
  8035cf:	74 6f                	je     803640 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8035d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d5:	74 06                	je     8035dd <insert_sorted_with_merge_freeList+0x3d7>
  8035d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035db:	75 17                	jne    8035f4 <insert_sorted_with_merge_freeList+0x3ee>
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	68 d0 44 80 00       	push   $0x8044d0
  8035e5:	68 6b 01 00 00       	push   $0x16b
  8035ea:	68 93 44 80 00       	push   $0x804493
  8035ef:	e8 50 d6 ff ff       	call   800c44 <_panic>
  8035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f7:	8b 50 04             	mov    0x4(%eax),%edx
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	89 50 04             	mov    %edx,0x4(%eax)
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803606:	89 10                	mov    %edx,(%eax)
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0d                	je     80361f <insert_sorted_with_merge_freeList+0x419>
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	8b 55 08             	mov    0x8(%ebp),%edx
  80361b:	89 10                	mov    %edx,(%eax)
  80361d:	eb 08                	jmp    803627 <insert_sorted_with_merge_freeList+0x421>
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	a3 38 51 80 00       	mov    %eax,0x805138
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	8b 55 08             	mov    0x8(%ebp),%edx
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	a1 44 51 80 00       	mov    0x805144,%eax
  803635:	40                   	inc    %eax
  803636:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80363b:	e9 d3 03 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	8b 50 08             	mov    0x8(%eax),%edx
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	8b 40 08             	mov    0x8(%eax),%eax
  80364c:	39 c2                	cmp    %eax,%edx
  80364e:	0f 86 da 00 00 00    	jbe    80372e <insert_sorted_with_merge_freeList+0x528>
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	8b 50 08             	mov    0x8(%eax),%edx
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	8b 48 08             	mov    0x8(%eax),%ecx
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	8b 40 0c             	mov    0xc(%eax),%eax
  803666:	01 c8                	add    %ecx,%eax
  803668:	39 c2                	cmp    %eax,%edx
  80366a:	0f 85 be 00 00 00    	jne    80372e <insert_sorted_with_merge_freeList+0x528>
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	8b 50 08             	mov    0x8(%eax),%edx
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	8b 40 04             	mov    0x4(%eax),%eax
  80367c:	8b 48 08             	mov    0x8(%eax),%ecx
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	8b 40 04             	mov    0x4(%eax),%eax
  803685:	8b 40 0c             	mov    0xc(%eax),%eax
  803688:	01 c8                	add    %ecx,%eax
  80368a:	39 c2                	cmp    %eax,%edx
  80368c:	0f 84 9c 00 00 00    	je     80372e <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	8b 50 08             	mov    0x8(%eax),%edx
  803698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369b:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8036a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036aa:	01 c2                	add    %eax,%edx
  8036ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036af:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ca:	75 17                	jne    8036e3 <insert_sorted_with_merge_freeList+0x4dd>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 70 44 80 00       	push   $0x804470
  8036d4:	68 74 01 00 00       	push   $0x174
  8036d9:	68 93 44 80 00       	push   $0x804493
  8036de:	e8 61 d5 ff ff       	call   800c44 <_panic>
  8036e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	85 c0                	test   %eax,%eax
  8036f5:	74 0d                	je     803704 <insert_sorted_with_merge_freeList+0x4fe>
  8036f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8036fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ff:	89 50 04             	mov    %edx,0x4(%eax)
  803702:	eb 08                	jmp    80370c <insert_sorted_with_merge_freeList+0x506>
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80370c:	8b 45 08             	mov    0x8(%ebp),%eax
  80370f:	a3 48 51 80 00       	mov    %eax,0x805148
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371e:	a1 54 51 80 00       	mov    0x805154,%eax
  803723:	40                   	inc    %eax
  803724:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803729:	e9 e5 02 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	8b 50 08             	mov    0x8(%eax),%edx
  803734:	8b 45 08             	mov    0x8(%ebp),%eax
  803737:	8b 40 08             	mov    0x8(%eax),%eax
  80373a:	39 c2                	cmp    %eax,%edx
  80373c:	0f 86 d7 00 00 00    	jbe    803819 <insert_sorted_with_merge_freeList+0x613>
  803742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803745:	8b 50 08             	mov    0x8(%eax),%edx
  803748:	8b 45 08             	mov    0x8(%ebp),%eax
  80374b:	8b 48 08             	mov    0x8(%eax),%ecx
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	8b 40 0c             	mov    0xc(%eax),%eax
  803754:	01 c8                	add    %ecx,%eax
  803756:	39 c2                	cmp    %eax,%edx
  803758:	0f 84 bb 00 00 00    	je     803819 <insert_sorted_with_merge_freeList+0x613>
  80375e:	8b 45 08             	mov    0x8(%ebp),%eax
  803761:	8b 50 08             	mov    0x8(%eax),%edx
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	8b 40 04             	mov    0x4(%eax),%eax
  80376a:	8b 48 08             	mov    0x8(%eax),%ecx
  80376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803770:	8b 40 04             	mov    0x4(%eax),%eax
  803773:	8b 40 0c             	mov    0xc(%eax),%eax
  803776:	01 c8                	add    %ecx,%eax
  803778:	39 c2                	cmp    %eax,%edx
  80377a:	0f 85 99 00 00 00    	jne    803819 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803783:	8b 40 04             	mov    0x4(%eax),%eax
  803786:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378c:	8b 50 0c             	mov    0xc(%eax),%edx
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 40 0c             	mov    0xc(%eax),%eax
  803795:	01 c2                	add    %eax,%edx
  803797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379a:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b5:	75 17                	jne    8037ce <insert_sorted_with_merge_freeList+0x5c8>
  8037b7:	83 ec 04             	sub    $0x4,%esp
  8037ba:	68 70 44 80 00       	push   $0x804470
  8037bf:	68 7d 01 00 00       	push   $0x17d
  8037c4:	68 93 44 80 00       	push   $0x804493
  8037c9:	e8 76 d4 ff ff       	call   800c44 <_panic>
  8037ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d7:	89 10                	mov    %edx,(%eax)
  8037d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dc:	8b 00                	mov    (%eax),%eax
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	74 0d                	je     8037ef <insert_sorted_with_merge_freeList+0x5e9>
  8037e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ea:	89 50 04             	mov    %edx,0x4(%eax)
  8037ed:	eb 08                	jmp    8037f7 <insert_sorted_with_merge_freeList+0x5f1>
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8037ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803802:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803809:	a1 54 51 80 00       	mov    0x805154,%eax
  80380e:	40                   	inc    %eax
  80380f:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803814:	e9 fa 01 00 00       	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381c:	8b 50 08             	mov    0x8(%eax),%edx
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	8b 40 08             	mov    0x8(%eax),%eax
  803825:	39 c2                	cmp    %eax,%edx
  803827:	0f 86 d2 01 00 00    	jbe    8039ff <insert_sorted_with_merge_freeList+0x7f9>
  80382d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803830:	8b 50 08             	mov    0x8(%eax),%edx
  803833:	8b 45 08             	mov    0x8(%ebp),%eax
  803836:	8b 48 08             	mov    0x8(%eax),%ecx
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	8b 40 0c             	mov    0xc(%eax),%eax
  80383f:	01 c8                	add    %ecx,%eax
  803841:	39 c2                	cmp    %eax,%edx
  803843:	0f 85 b6 01 00 00    	jne    8039ff <insert_sorted_with_merge_freeList+0x7f9>
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	8b 50 08             	mov    0x8(%eax),%edx
  80384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	8b 48 08             	mov    0x8(%eax),%ecx
  803858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385b:	8b 40 04             	mov    0x4(%eax),%eax
  80385e:	8b 40 0c             	mov    0xc(%eax),%eax
  803861:	01 c8                	add    %ecx,%eax
  803863:	39 c2                	cmp    %eax,%edx
  803865:	0f 85 94 01 00 00    	jne    8039ff <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  80386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386e:	8b 40 04             	mov    0x4(%eax),%eax
  803871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803874:	8b 52 04             	mov    0x4(%edx),%edx
  803877:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80387a:	8b 55 08             	mov    0x8(%ebp),%edx
  80387d:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803883:	8b 52 0c             	mov    0xc(%edx),%edx
  803886:	01 da                	add    %ebx,%edx
  803888:	01 ca                	add    %ecx,%edx
  80388a:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  80388d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803890:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8038a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a5:	75 17                	jne    8038be <insert_sorted_with_merge_freeList+0x6b8>
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	68 05 45 80 00       	push   $0x804505
  8038af:	68 86 01 00 00       	push   $0x186
  8038b4:	68 93 44 80 00       	push   $0x804493
  8038b9:	e8 86 d3 ff ff       	call   800c44 <_panic>
  8038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c1:	8b 00                	mov    (%eax),%eax
  8038c3:	85 c0                	test   %eax,%eax
  8038c5:	74 10                	je     8038d7 <insert_sorted_with_merge_freeList+0x6d1>
  8038c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038cf:	8b 52 04             	mov    0x4(%edx),%edx
  8038d2:	89 50 04             	mov    %edx,0x4(%eax)
  8038d5:	eb 0b                	jmp    8038e2 <insert_sorted_with_merge_freeList+0x6dc>
  8038d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038da:	8b 40 04             	mov    0x4(%eax),%eax
  8038dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e5:	8b 40 04             	mov    0x4(%eax),%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	74 0f                	je     8038fb <insert_sorted_with_merge_freeList+0x6f5>
  8038ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ef:	8b 40 04             	mov    0x4(%eax),%eax
  8038f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038f5:	8b 12                	mov    (%edx),%edx
  8038f7:	89 10                	mov    %edx,(%eax)
  8038f9:	eb 0a                	jmp    803905 <insert_sorted_with_merge_freeList+0x6ff>
  8038fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fe:	8b 00                	mov    (%eax),%eax
  803900:	a3 38 51 80 00       	mov    %eax,0x805138
  803905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803911:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803918:	a1 44 51 80 00       	mov    0x805144,%eax
  80391d:	48                   	dec    %eax
  80391e:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803927:	75 17                	jne    803940 <insert_sorted_with_merge_freeList+0x73a>
  803929:	83 ec 04             	sub    $0x4,%esp
  80392c:	68 70 44 80 00       	push   $0x804470
  803931:	68 87 01 00 00       	push   $0x187
  803936:	68 93 44 80 00       	push   $0x804493
  80393b:	e8 04 d3 ff ff       	call   800c44 <_panic>
  803940:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803949:	89 10                	mov    %edx,(%eax)
  80394b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	74 0d                	je     803961 <insert_sorted_with_merge_freeList+0x75b>
  803954:	a1 48 51 80 00       	mov    0x805148,%eax
  803959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395c:	89 50 04             	mov    %edx,0x4(%eax)
  80395f:	eb 08                	jmp    803969 <insert_sorted_with_merge_freeList+0x763>
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396c:	a3 48 51 80 00       	mov    %eax,0x805148
  803971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803974:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397b:	a1 54 51 80 00       	mov    0x805154,%eax
  803980:	40                   	inc    %eax
  803981:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80399a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80399e:	75 17                	jne    8039b7 <insert_sorted_with_merge_freeList+0x7b1>
  8039a0:	83 ec 04             	sub    $0x4,%esp
  8039a3:	68 70 44 80 00       	push   $0x804470
  8039a8:	68 8a 01 00 00       	push   $0x18a
  8039ad:	68 93 44 80 00       	push   $0x804493
  8039b2:	e8 8d d2 ff ff       	call   800c44 <_panic>
  8039b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c0:	89 10                	mov    %edx,(%eax)
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	8b 00                	mov    (%eax),%eax
  8039c7:	85 c0                	test   %eax,%eax
  8039c9:	74 0d                	je     8039d8 <insert_sorted_with_merge_freeList+0x7d2>
  8039cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8039d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d3:	89 50 04             	mov    %edx,0x4(%eax)
  8039d6:	eb 08                	jmp    8039e0 <insert_sorted_with_merge_freeList+0x7da>
  8039d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8039e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8039f7:	40                   	inc    %eax
  8039f8:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8039fd:	eb 14                	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8039ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a02:	8b 00                	mov    (%eax),%eax
  803a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a0b:	0f 85 72 fb ff ff    	jne    803583 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803a11:	eb 00                	jmp    803a13 <insert_sorted_with_merge_freeList+0x80d>
  803a13:	90                   	nop
  803a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a17:	c9                   	leave  
  803a18:	c3                   	ret    
  803a19:	66 90                	xchg   %ax,%ax
  803a1b:	90                   	nop

00803a1c <__udivdi3>:
  803a1c:	55                   	push   %ebp
  803a1d:	57                   	push   %edi
  803a1e:	56                   	push   %esi
  803a1f:	53                   	push   %ebx
  803a20:	83 ec 1c             	sub    $0x1c,%esp
  803a23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a33:	89 ca                	mov    %ecx,%edx
  803a35:	89 f8                	mov    %edi,%eax
  803a37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a3b:	85 f6                	test   %esi,%esi
  803a3d:	75 2d                	jne    803a6c <__udivdi3+0x50>
  803a3f:	39 cf                	cmp    %ecx,%edi
  803a41:	77 65                	ja     803aa8 <__udivdi3+0x8c>
  803a43:	89 fd                	mov    %edi,%ebp
  803a45:	85 ff                	test   %edi,%edi
  803a47:	75 0b                	jne    803a54 <__udivdi3+0x38>
  803a49:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4e:	31 d2                	xor    %edx,%edx
  803a50:	f7 f7                	div    %edi
  803a52:	89 c5                	mov    %eax,%ebp
  803a54:	31 d2                	xor    %edx,%edx
  803a56:	89 c8                	mov    %ecx,%eax
  803a58:	f7 f5                	div    %ebp
  803a5a:	89 c1                	mov    %eax,%ecx
  803a5c:	89 d8                	mov    %ebx,%eax
  803a5e:	f7 f5                	div    %ebp
  803a60:	89 cf                	mov    %ecx,%edi
  803a62:	89 fa                	mov    %edi,%edx
  803a64:	83 c4 1c             	add    $0x1c,%esp
  803a67:	5b                   	pop    %ebx
  803a68:	5e                   	pop    %esi
  803a69:	5f                   	pop    %edi
  803a6a:	5d                   	pop    %ebp
  803a6b:	c3                   	ret    
  803a6c:	39 ce                	cmp    %ecx,%esi
  803a6e:	77 28                	ja     803a98 <__udivdi3+0x7c>
  803a70:	0f bd fe             	bsr    %esi,%edi
  803a73:	83 f7 1f             	xor    $0x1f,%edi
  803a76:	75 40                	jne    803ab8 <__udivdi3+0x9c>
  803a78:	39 ce                	cmp    %ecx,%esi
  803a7a:	72 0a                	jb     803a86 <__udivdi3+0x6a>
  803a7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a80:	0f 87 9e 00 00 00    	ja     803b24 <__udivdi3+0x108>
  803a86:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8b:	89 fa                	mov    %edi,%edx
  803a8d:	83 c4 1c             	add    $0x1c,%esp
  803a90:	5b                   	pop    %ebx
  803a91:	5e                   	pop    %esi
  803a92:	5f                   	pop    %edi
  803a93:	5d                   	pop    %ebp
  803a94:	c3                   	ret    
  803a95:	8d 76 00             	lea    0x0(%esi),%esi
  803a98:	31 ff                	xor    %edi,%edi
  803a9a:	31 c0                	xor    %eax,%eax
  803a9c:	89 fa                	mov    %edi,%edx
  803a9e:	83 c4 1c             	add    $0x1c,%esp
  803aa1:	5b                   	pop    %ebx
  803aa2:	5e                   	pop    %esi
  803aa3:	5f                   	pop    %edi
  803aa4:	5d                   	pop    %ebp
  803aa5:	c3                   	ret    
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	89 d8                	mov    %ebx,%eax
  803aaa:	f7 f7                	div    %edi
  803aac:	31 ff                	xor    %edi,%edi
  803aae:	89 fa                	mov    %edi,%edx
  803ab0:	83 c4 1c             	add    $0x1c,%esp
  803ab3:	5b                   	pop    %ebx
  803ab4:	5e                   	pop    %esi
  803ab5:	5f                   	pop    %edi
  803ab6:	5d                   	pop    %ebp
  803ab7:	c3                   	ret    
  803ab8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803abd:	89 eb                	mov    %ebp,%ebx
  803abf:	29 fb                	sub    %edi,%ebx
  803ac1:	89 f9                	mov    %edi,%ecx
  803ac3:	d3 e6                	shl    %cl,%esi
  803ac5:	89 c5                	mov    %eax,%ebp
  803ac7:	88 d9                	mov    %bl,%cl
  803ac9:	d3 ed                	shr    %cl,%ebp
  803acb:	89 e9                	mov    %ebp,%ecx
  803acd:	09 f1                	or     %esi,%ecx
  803acf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ad3:	89 f9                	mov    %edi,%ecx
  803ad5:	d3 e0                	shl    %cl,%eax
  803ad7:	89 c5                	mov    %eax,%ebp
  803ad9:	89 d6                	mov    %edx,%esi
  803adb:	88 d9                	mov    %bl,%cl
  803add:	d3 ee                	shr    %cl,%esi
  803adf:	89 f9                	mov    %edi,%ecx
  803ae1:	d3 e2                	shl    %cl,%edx
  803ae3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ae7:	88 d9                	mov    %bl,%cl
  803ae9:	d3 e8                	shr    %cl,%eax
  803aeb:	09 c2                	or     %eax,%edx
  803aed:	89 d0                	mov    %edx,%eax
  803aef:	89 f2                	mov    %esi,%edx
  803af1:	f7 74 24 0c          	divl   0xc(%esp)
  803af5:	89 d6                	mov    %edx,%esi
  803af7:	89 c3                	mov    %eax,%ebx
  803af9:	f7 e5                	mul    %ebp
  803afb:	39 d6                	cmp    %edx,%esi
  803afd:	72 19                	jb     803b18 <__udivdi3+0xfc>
  803aff:	74 0b                	je     803b0c <__udivdi3+0xf0>
  803b01:	89 d8                	mov    %ebx,%eax
  803b03:	31 ff                	xor    %edi,%edi
  803b05:	e9 58 ff ff ff       	jmp    803a62 <__udivdi3+0x46>
  803b0a:	66 90                	xchg   %ax,%ax
  803b0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b10:	89 f9                	mov    %edi,%ecx
  803b12:	d3 e2                	shl    %cl,%edx
  803b14:	39 c2                	cmp    %eax,%edx
  803b16:	73 e9                	jae    803b01 <__udivdi3+0xe5>
  803b18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b1b:	31 ff                	xor    %edi,%edi
  803b1d:	e9 40 ff ff ff       	jmp    803a62 <__udivdi3+0x46>
  803b22:	66 90                	xchg   %ax,%ax
  803b24:	31 c0                	xor    %eax,%eax
  803b26:	e9 37 ff ff ff       	jmp    803a62 <__udivdi3+0x46>
  803b2b:	90                   	nop

00803b2c <__umoddi3>:
  803b2c:	55                   	push   %ebp
  803b2d:	57                   	push   %edi
  803b2e:	56                   	push   %esi
  803b2f:	53                   	push   %ebx
  803b30:	83 ec 1c             	sub    $0x1c,%esp
  803b33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b4b:	89 f3                	mov    %esi,%ebx
  803b4d:	89 fa                	mov    %edi,%edx
  803b4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b53:	89 34 24             	mov    %esi,(%esp)
  803b56:	85 c0                	test   %eax,%eax
  803b58:	75 1a                	jne    803b74 <__umoddi3+0x48>
  803b5a:	39 f7                	cmp    %esi,%edi
  803b5c:	0f 86 a2 00 00 00    	jbe    803c04 <__umoddi3+0xd8>
  803b62:	89 c8                	mov    %ecx,%eax
  803b64:	89 f2                	mov    %esi,%edx
  803b66:	f7 f7                	div    %edi
  803b68:	89 d0                	mov    %edx,%eax
  803b6a:	31 d2                	xor    %edx,%edx
  803b6c:	83 c4 1c             	add    $0x1c,%esp
  803b6f:	5b                   	pop    %ebx
  803b70:	5e                   	pop    %esi
  803b71:	5f                   	pop    %edi
  803b72:	5d                   	pop    %ebp
  803b73:	c3                   	ret    
  803b74:	39 f0                	cmp    %esi,%eax
  803b76:	0f 87 ac 00 00 00    	ja     803c28 <__umoddi3+0xfc>
  803b7c:	0f bd e8             	bsr    %eax,%ebp
  803b7f:	83 f5 1f             	xor    $0x1f,%ebp
  803b82:	0f 84 ac 00 00 00    	je     803c34 <__umoddi3+0x108>
  803b88:	bf 20 00 00 00       	mov    $0x20,%edi
  803b8d:	29 ef                	sub    %ebp,%edi
  803b8f:	89 fe                	mov    %edi,%esi
  803b91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b95:	89 e9                	mov    %ebp,%ecx
  803b97:	d3 e0                	shl    %cl,%eax
  803b99:	89 d7                	mov    %edx,%edi
  803b9b:	89 f1                	mov    %esi,%ecx
  803b9d:	d3 ef                	shr    %cl,%edi
  803b9f:	09 c7                	or     %eax,%edi
  803ba1:	89 e9                	mov    %ebp,%ecx
  803ba3:	d3 e2                	shl    %cl,%edx
  803ba5:	89 14 24             	mov    %edx,(%esp)
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	d3 e0                	shl    %cl,%eax
  803bac:	89 c2                	mov    %eax,%edx
  803bae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb2:	d3 e0                	shl    %cl,%eax
  803bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bbc:	89 f1                	mov    %esi,%ecx
  803bbe:	d3 e8                	shr    %cl,%eax
  803bc0:	09 d0                	or     %edx,%eax
  803bc2:	d3 eb                	shr    %cl,%ebx
  803bc4:	89 da                	mov    %ebx,%edx
  803bc6:	f7 f7                	div    %edi
  803bc8:	89 d3                	mov    %edx,%ebx
  803bca:	f7 24 24             	mull   (%esp)
  803bcd:	89 c6                	mov    %eax,%esi
  803bcf:	89 d1                	mov    %edx,%ecx
  803bd1:	39 d3                	cmp    %edx,%ebx
  803bd3:	0f 82 87 00 00 00    	jb     803c60 <__umoddi3+0x134>
  803bd9:	0f 84 91 00 00 00    	je     803c70 <__umoddi3+0x144>
  803bdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803be3:	29 f2                	sub    %esi,%edx
  803be5:	19 cb                	sbb    %ecx,%ebx
  803be7:	89 d8                	mov    %ebx,%eax
  803be9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bed:	d3 e0                	shl    %cl,%eax
  803bef:	89 e9                	mov    %ebp,%ecx
  803bf1:	d3 ea                	shr    %cl,%edx
  803bf3:	09 d0                	or     %edx,%eax
  803bf5:	89 e9                	mov    %ebp,%ecx
  803bf7:	d3 eb                	shr    %cl,%ebx
  803bf9:	89 da                	mov    %ebx,%edx
  803bfb:	83 c4 1c             	add    $0x1c,%esp
  803bfe:	5b                   	pop    %ebx
  803bff:	5e                   	pop    %esi
  803c00:	5f                   	pop    %edi
  803c01:	5d                   	pop    %ebp
  803c02:	c3                   	ret    
  803c03:	90                   	nop
  803c04:	89 fd                	mov    %edi,%ebp
  803c06:	85 ff                	test   %edi,%edi
  803c08:	75 0b                	jne    803c15 <__umoddi3+0xe9>
  803c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c0f:	31 d2                	xor    %edx,%edx
  803c11:	f7 f7                	div    %edi
  803c13:	89 c5                	mov    %eax,%ebp
  803c15:	89 f0                	mov    %esi,%eax
  803c17:	31 d2                	xor    %edx,%edx
  803c19:	f7 f5                	div    %ebp
  803c1b:	89 c8                	mov    %ecx,%eax
  803c1d:	f7 f5                	div    %ebp
  803c1f:	89 d0                	mov    %edx,%eax
  803c21:	e9 44 ff ff ff       	jmp    803b6a <__umoddi3+0x3e>
  803c26:	66 90                	xchg   %ax,%ax
  803c28:	89 c8                	mov    %ecx,%eax
  803c2a:	89 f2                	mov    %esi,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	3b 04 24             	cmp    (%esp),%eax
  803c37:	72 06                	jb     803c3f <__umoddi3+0x113>
  803c39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c3d:	77 0f                	ja     803c4e <__umoddi3+0x122>
  803c3f:	89 f2                	mov    %esi,%edx
  803c41:	29 f9                	sub    %edi,%ecx
  803c43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c47:	89 14 24             	mov    %edx,(%esp)
  803c4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c52:	8b 14 24             	mov    (%esp),%edx
  803c55:	83 c4 1c             	add    $0x1c,%esp
  803c58:	5b                   	pop    %ebx
  803c59:	5e                   	pop    %esi
  803c5a:	5f                   	pop    %edi
  803c5b:	5d                   	pop    %ebp
  803c5c:	c3                   	ret    
  803c5d:	8d 76 00             	lea    0x0(%esi),%esi
  803c60:	2b 04 24             	sub    (%esp),%eax
  803c63:	19 fa                	sbb    %edi,%edx
  803c65:	89 d1                	mov    %edx,%ecx
  803c67:	89 c6                	mov    %eax,%esi
  803c69:	e9 71 ff ff ff       	jmp    803bdf <__umoddi3+0xb3>
  803c6e:	66 90                	xchg   %ax,%ax
  803c70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c74:	72 ea                	jb     803c60 <__umoddi3+0x134>
  803c76:	89 d9                	mov    %ebx,%ecx
  803c78:	e9 62 ff ff ff       	jmp    803bdf <__umoddi3+0xb3>
