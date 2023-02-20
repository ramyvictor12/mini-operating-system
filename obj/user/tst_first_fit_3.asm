
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 50 0d 00 00       	call   800d86 <libmain>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 f5 29 00 00       	call   802a3f <sys_set_uheap_strategy>
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
  80009b:	68 00 3f 80 00       	push   $0x803f00
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 1c 3f 80 00       	push   $0x803f1c
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 40 27 00 00       	call   8027f1 <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 08 20 00 00       	call   8020c6 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 45 24 00 00       	call   80252a <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 dd 24 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 33 3f 80 00       	push   $0x803f33
  8000fe:	e8 24 21 00 00       	call   802227 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 38 3f 80 00       	push   $0x803f38
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 1c 3f 80 00       	push   $0x803f1c
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 fb 23 00 00       	call   80252a <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 a4 3f 80 00       	push   $0x803fa4
  800142:	6a 2b                	push   $0x2b
  800144:	68 1c 3f 80 00       	push   $0x803f1c
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 77 24 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 22 40 80 00       	push   $0x804022
  800160:	6a 2c                	push   $0x2c
  800162:	68 1c 3f 80 00       	push   $0x803f1c
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 b9 23 00 00       	call   80252a <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 51 24 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 3b 1f 00 00       	call   8020c6 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 40 40 80 00       	push   $0x804040
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 1c 3f 80 00       	push   $0x803f1c
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 0f 24 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 22 40 80 00       	push   $0x804022
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 1c 3f 80 00       	push   $0x803f1c
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 51 23 00 00       	call   80252a <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 70 40 80 00       	push   $0x804070
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 1c 3f 80 00       	push   $0x803f1c
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 2f 23 00 00       	call   80252a <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 c7 23 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800209:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 b1 1e 00 00       	call   8020c6 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800223:	01 c0                	add    %eax,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 40 40 80 00       	push   $0x804040
  800236:	6a 3b                	push   $0x3b
  800238:	68 1c 3f 80 00       	push   $0x803f1c
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 83 23 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 22 40 80 00       	push   $0x804022
  800254:	6a 3d                	push   $0x3d
  800256:	68 1c 3f 80 00       	push   $0x803f1c
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 c5 22 00 00       	call   80252a <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 70 40 80 00       	push   $0x804070
  800276:	6a 3e                	push   $0x3e
  800278:	68 1c 3f 80 00       	push   $0x803f1c
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 a3 22 00 00       	call   80252a <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 3b 23 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  80028f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800295:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 25 1e 00 00       	call   8020c6 <malloc>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002aa:	89 c1                	mov    %eax,%ecx
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ba:	39 c1                	cmp    %eax,%ecx
  8002bc:	74 14                	je     8002d2 <_main+0x29a>
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	68 40 40 80 00       	push   $0x804040
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 1c 3f 80 00       	push   $0x803f1c
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 f3 22 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 22 40 80 00       	push   $0x804022
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 1c 3f 80 00       	push   $0x803f1c
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 35 22 00 00       	call   80252a <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 70 40 80 00       	push   $0x804070
  800306:	6a 47                	push   $0x47
  800308:	68 1c 3f 80 00       	push   $0x803f1c
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 13 22 00 00       	call   80252a <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 ab 22 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  80031f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	50                   	push   %eax
  80032e:	e8 93 1d 00 00       	call   8020c6 <malloc>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800339:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800341:	c1 e0 02             	shl    $0x2,%eax
  800344:	05 00 00 00 80       	add    $0x80000000,%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <_main+0x329>
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 40 40 80 00       	push   $0x804040
  800355:	6a 4d                	push   $0x4d
  800357:	68 1c 3f 80 00       	push   $0x803f1c
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 64 22 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 22 40 80 00       	push   $0x804022
  800373:	6a 4f                	push   $0x4f
  800375:	68 1c 3f 80 00       	push   $0x803f1c
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 a6 21 00 00       	call   80252a <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 70 40 80 00       	push   $0x804070
  800395:	6a 50                	push   $0x50
  800397:	68 1c 3f 80 00       	push   $0x803f1c
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 84 21 00 00       	call   80252a <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 1c 22 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 83 40 80 00       	push   $0x804083
  8003c1:	e8 61 1e 00 00       	call   802227 <smalloc>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003cc:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	05 00 00 00 80       	add    $0x80000000,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 38 3f 80 00       	push   $0x803f38
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 1c 3f 80 00       	push   $0x803f1c
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 2b 21 00 00       	call   80252a <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 a4 3f 80 00       	push   $0x803fa4
  800412:	6a 57                	push   $0x57
  800414:	68 1c 3f 80 00       	push   $0x803f1c
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 a7 21 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 22 40 80 00       	push   $0x804022
  800430:	6a 58                	push   $0x58
  800432:	68 1c 3f 80 00       	push   $0x803f1c
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 e9 20 00 00       	call   80252a <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 81 21 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800449:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	89 c2                	mov    %eax,%edx
  800451:	01 d2                	add    %edx,%edx
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	50                   	push   %eax
  80045c:	e8 65 1c 00 00       	call   8020c6 <malloc>
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800467:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 03             	shl    $0x3,%eax
  800472:	05 00 00 00 80       	add    $0x80000000,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 40 40 80 00       	push   $0x804040
  800483:	6a 5e                	push   $0x5e
  800485:	68 1c 3f 80 00       	push   $0x803f1c
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 36 21 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 22 40 80 00       	push   $0x804022
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 1c 3f 80 00       	push   $0x803f1c
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 78 20 00 00       	call   80252a <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 70 40 80 00       	push   $0x804070
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 1c 3f 80 00       	push   $0x803f1c
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 56 20 00 00       	call   80252a <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 ee 20 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 85 40 80 00       	push   $0x804085
  8004f3:	e8 2f 1d 00 00       	call   802227 <smalloc>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8004fe:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	05 00 00 00 80       	add    $0x80000000,%eax
  800514:	39 c1                	cmp    %eax,%ecx
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 38 3f 80 00       	push   $0x803f38
  800520:	6a 67                	push   $0x67
  800522:	68 1c 3f 80 00       	push   $0x803f1c
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 f6 1f 00 00       	call   80252a <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 a4 3f 80 00       	push   $0x803fa4
  800547:	6a 68                	push   $0x68
  800549:	68 1c 3f 80 00       	push   $0x803f1c
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 72 20 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 22 40 80 00       	push   $0x804022
  800565:	6a 69                	push   $0x69
  800567:	68 1c 3f 80 00       	push   $0x803f1c
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 b4 1f 00 00       	call   80252a <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 4c 20 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 c4 1b 00 00       	call   802151 <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 35 20 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 87 40 80 00       	push   $0x804087
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 1c 3f 80 00       	push   $0x803f1c
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 77 1f 00 00       	call   80252a <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 9e 40 80 00       	push   $0x80409e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 1c 3f 80 00       	push   $0x803f1c
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 55 1f 00 00       	call   80252a <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 ed 1f 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 65 1b 00 00       	call   802151 <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 d6 1f 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 87 40 80 00       	push   $0x804087
  800601:	6a 7b                	push   $0x7b
  800603:	68 1c 3f 80 00       	push   $0x803f1c
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 18 1f 00 00       	call   80252a <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 9e 40 80 00       	push   $0x80409e
  800623:	6a 7c                	push   $0x7c
  800625:	68 1c 3f 80 00       	push   $0x803f1c
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 f6 1e 00 00       	call   80252a <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 8e 1f 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 06 1b 00 00       	call   802151 <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 77 1f 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 87 40 80 00       	push   $0x804087
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 1c 3f 80 00       	push   $0x803f1c
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 b6 1e 00 00       	call   80252a <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 9e 40 80 00       	push   $0x80409e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 1c 3f 80 00       	push   $0x803f1c
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 91 1e 00 00       	call   80252a <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 29 1f 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8006a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a7:	89 d0                	mov    %edx,%eax
  8006a9:	c1 e0 09             	shl    $0x9,%eax
  8006ac:	29 d0                	sub    %edx,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 0f 1a 00 00       	call   8020c6 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	74 17                	je     8006e5 <_main+0x6ad>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 40 40 80 00       	push   $0x804040
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 1c 3f 80 00       	push   $0x803f1c
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 e0 1e 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 22 40 80 00       	push   $0x804022
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 1c 3f 80 00       	push   $0x803f1c
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 1f 1e 00 00       	call   80252a <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 70 40 80 00       	push   $0x804070
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 1c 3f 80 00       	push   $0x803f1c
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 fa 1d 00 00       	call   80252a <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 92 1e 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80073b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	e8 7c 19 00 00       	call   8020c6 <malloc>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800753:	89 c2                	mov    %eax,%edx
  800755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800758:	c1 e0 02             	shl    $0x2,%eax
  80075b:	05 00 00 00 80       	add    $0x80000000,%eax
  800760:	39 c2                	cmp    %eax,%edx
  800762:	74 17                	je     80077b <_main+0x743>
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 40 40 80 00       	push   $0x804040
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 1c 3f 80 00       	push   $0x803f1c
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 4a 1e 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 22 40 80 00       	push   $0x804022
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 1c 3f 80 00       	push   $0x803f1c
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 89 1d 00 00       	call   80252a <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 70 40 80 00       	push   $0x804070
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 1c 3f 80 00       	push   $0x803f1c
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 64 1d 00 00       	call   80252a <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 fc 1d 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8007ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  8007d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	c1 e0 08             	shl    $0x8,%eax
  8007d9:	29 d0                	sub    %edx,%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	6a 00                	push   $0x0
  8007e0:	50                   	push   %eax
  8007e1:	68 ab 40 80 00       	push   $0x8040ab
  8007e6:	e8 3c 1a 00 00       	call   802227 <smalloc>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f9:	c1 e0 09             	shl    $0x9,%eax
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	05 00 00 00 80       	add    $0x80000000,%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	74 17                	je     800823 <_main+0x7eb>
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 40 40 80 00       	push   $0x804040
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 1c 3f 80 00       	push   $0x803f1c
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 a2 1d 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 22 40 80 00       	push   $0x804022
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 1c 3f 80 00       	push   $0x803f1c
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 de 1c 00 00       	call   80252a <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 cd 1c 00 00       	call   80252a <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 ad 40 80 00       	push   $0x8040ad
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 1c 3f 80 00       	push   $0x803f1c
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 af 1c 00 00       	call   80252a <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 47 1d 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800883:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	50                   	push   %eax
  80088f:	e8 32 18 00 00       	call   8020c6 <malloc>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80089a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 17                	je     8008c5 <_main+0x88d>
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 40 40 80 00       	push   $0x804040
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 1c 3f 80 00       	push   $0x803f1c
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 00 1d 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 22 40 80 00       	push   $0x804022
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 1c 3f 80 00       	push   $0x803f1c
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 3f 1c 00 00       	call   80252a <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 70 40 80 00       	push   $0x804070
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 1c 3f 80 00       	push   $0x803f1c
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 1a 1c 00 00       	call   80252a <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 b2 1c 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 c2 40 80 00       	push   $0x8040c2
  80092f:	e8 f3 18 00 00       	call   802227 <smalloc>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80093a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093d:	89 c1                	mov    %eax,%ecx
  80093f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	05 00 00 00 80       	add    $0x80000000,%eax
  800953:	39 c1                	cmp    %eax,%ecx
  800955:	74 17                	je     80096e <_main+0x936>
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 40 40 80 00       	push   $0x804040
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 1c 3f 80 00       	push   $0x803f1c
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 b4 1b 00 00       	call   80252a <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 70 40 80 00       	push   $0x804070
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 1c 3f 80 00       	push   $0x803f1c
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 2d 1c 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 22 40 80 00       	push   $0x804022
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 1c 3f 80 00       	push   $0x803f1c
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 6c 1b 00 00       	call   80252a <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 04 1c 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 7c 17 00 00       	call   802151 <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 ed 1b 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 87 40 80 00       	push   $0x804087
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 1c 3f 80 00       	push   $0x803f1c
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 2c 1b 00 00       	call   80252a <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 9e 40 80 00       	push   $0x80409e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 1c 3f 80 00       	push   $0x803f1c
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 07 1b 00 00       	call   80252a <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 9f 1b 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 17 17 00 00       	call   802151 <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 88 1b 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 87 40 80 00       	push   $0x804087
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 1c 3f 80 00       	push   $0x803f1c
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 c7 1a 00 00       	call   80252a <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 9e 40 80 00       	push   $0x80409e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 1c 3f 80 00       	push   $0x803f1c
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 a2 1a 00 00       	call   80252a <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 3a 1b 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 b2 16 00 00       	call   802151 <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 23 1b 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 87 40 80 00       	push   $0x804087
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 1c 3f 80 00       	push   $0x803f1c
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 62 1a 00 00       	call   80252a <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 9e 40 80 00       	push   $0x80409e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 1c 3f 80 00       	push   $0x803f1c
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 3d 1a 00 00       	call   80252a <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 d5 1a 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afb:	c1 e0 08             	shl    $0x8,%eax
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	e8 b5 15 00 00       	call   8020c6 <malloc>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 08             	shl    $0x8,%eax
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b34:	39 c1                	cmp    %eax,%ecx
  800b36:	74 17                	je     800b4f <_main+0xb17>
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	68 40 40 80 00       	push   $0x804040
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 1c 3f 80 00       	push   $0x803f1c
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 76 1a 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 22 40 80 00       	push   $0x804022
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 1c 3f 80 00       	push   $0x803f1c
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 b5 19 00 00       	call   80252a <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 70 40 80 00       	push   $0x804070
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 1c 3f 80 00       	push   $0x803f1c
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 90 19 00 00       	call   80252a <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 28 1a 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 c4 40 80 00       	push   $0x8040c4
  800bb6:	e8 6c 16 00 00       	call   802227 <smalloc>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800bc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	05 00 00 00 80       	add    $0x80000000,%eax
  800bd5:	39 c1                	cmp    %eax,%ecx
  800bd7:	74 17                	je     800bf0 <_main+0xbb8>
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	68 38 3f 80 00       	push   $0x803f38
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 1c 3f 80 00       	push   $0x803f1c
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 32 19 00 00       	call   80252a <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 a4 3f 80 00       	push   $0x803fa4
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 1c 3f 80 00       	push   $0x803f1c
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 ab 19 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 22 40 80 00       	push   $0x804022
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 1c 3f 80 00       	push   $0x803f1c
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 ea 18 00 00       	call   80252a <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 82 19 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 85 40 80 00       	push   $0x804085
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 8f 16 00 00       	call   8022ea <sget>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	01 c9                	add    %ecx,%ecx
  800c6b:	01 c8                	add    %ecx,%eax
  800c6d:	05 00 00 00 80       	add    $0x80000000,%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	74 17                	je     800c8d <_main+0xc55>
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 38 3f 80 00       	push   $0x803f38
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 1c 3f 80 00       	push   $0x803f1c
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 98 18 00 00       	call   80252a <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 a4 3f 80 00       	push   $0x803fa4
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 1c 3f 80 00       	push   $0x803f1c
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 13 19 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 22 40 80 00       	push   $0x804022
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 1c 3f 80 00       	push   $0x803f1c
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 52 18 00 00       	call   80252a <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 ea 18 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 33 3f 80 00       	push   $0x803f33
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 f7 15 00 00       	call   8022ea <sget>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cf9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 02             	shl    $0x2,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	05 00 00 00 80       	add    $0x80000000,%eax
  800d0d:	39 c1                	cmp    %eax,%ecx
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 38 3f 80 00       	push   $0x803f38
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 1c 3f 80 00       	push   $0x803f1c
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 fd 17 00 00       	call   80252a <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 a4 3f 80 00       	push   $0x803fa4
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 1c 3f 80 00       	push   $0x803f1c
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 78 18 00 00       	call   8025ca <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 22 40 80 00       	push   $0x804022
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 1c 3f 80 00       	push   $0x803f1c
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 c8 40 80 00       	push   $0x8040c8
  800d76:	e8 fb 03 00 00       	call   801176 <cprintf>
  800d7b:	83 c4 10             	add    $0x10,%esp

	return;
  800d7e:	90                   	nop
}
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d8c:	e8 79 1a 00 00       	call   80280a <sys_getenvindex>
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	01 c0                	add    %eax,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800da9:	01 d0                	add    %edx,%eax
  800dab:	c1 e0 04             	shl    $0x4,%eax
  800dae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800db3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800db8:	a1 20 50 80 00       	mov    0x805020,%eax
  800dbd:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800dc7:	a1 20 50 80 00       	mov    0x805020,%eax
  800dcc:	05 5c 05 00 00       	add    $0x55c,%eax
  800dd1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	7e 0a                	jle    800de6 <libmain+0x60>
		binaryname = argv[0];
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 44 f2 ff ff       	call   800038 <_main>
  800df4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800df7:	e8 1b 18 00 00       	call   802617 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 2c 41 80 00       	push   $0x80412c
  800e04:	e8 6d 03 00 00       	call   801176 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e11:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e17:	a1 20 50 80 00       	mov    0x805020,%eax
  800e1c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	52                   	push   %edx
  800e26:	50                   	push   %eax
  800e27:	68 54 41 80 00       	push   $0x804154
  800e2c:	e8 45 03 00 00       	call   801176 <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e34:	a1 20 50 80 00       	mov    0x805020,%eax
  800e39:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e44:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  800e4f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	50                   	push   %eax
  800e58:	68 7c 41 80 00       	push   $0x80417c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 d4 41 80 00       	push   $0x8041d4
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 2c 41 80 00       	push   $0x80412c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 9b 17 00 00       	call   802631 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e96:	e8 19 00 00 00       	call   800eb4 <exit>
}
  800e9b:	90                   	nop
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 28 19 00 00       	call   8027d6 <sys_destroy_env>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	90                   	nop
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <exit>:

void
exit(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800eba:	e8 7d 19 00 00       	call   80283c <sys_exit_env>
}
  800ebf:	90                   	nop
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ec8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ecb:	83 c0 04             	add    $0x4,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ed1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 16                	je     800ef0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800eda:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	50                   	push   %eax
  800ee3:	68 e8 41 80 00       	push   $0x8041e8
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 ed 41 80 00       	push   $0x8041ed
  800f01:	e8 70 02 00 00       	call   801176 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	e8 f3 01 00 00       	call   80110b <vcprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	6a 00                	push   $0x0
  800f20:	68 09 42 80 00       	push   $0x804209
  800f25:	e8 e1 01 00 00       	call   80110b <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f2d:	e8 82 ff ff ff       	call   800eb4 <exit>

	// should not return here
	while (1) ;
  800f32:	eb fe                	jmp    800f32 <_panic+0x70>

00800f34 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 50 74             	mov    0x74(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	39 c2                	cmp    %eax,%edx
  800f47:	74 14                	je     800f5d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	68 0c 42 80 00       	push   $0x80420c
  800f51:	6a 26                	push   $0x26
  800f53:	68 58 42 80 00       	push   $0x804258
  800f58:	e8 65 ff ff ff       	call   800ec2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f6b:	e9 c2 00 00 00       	jmp    801032 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 08                	jne    800f8d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800f85:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f88:	e9 a2 00 00 00       	jmp    80102f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800f8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f9b:	eb 69                	jmp    801006 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800fa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	01 c0                	add    %eax,%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	c1 e0 03             	shl    $0x3,%eax
  800fb4:	01 c8                	add    %ecx,%eax
  800fb6:	8a 40 04             	mov    0x4(%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 46                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fbd:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	c1 e0 03             	shl    $0x3,%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	75 09                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ffa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801001:	eb 12                	jmp    801015 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801003:	ff 45 e8             	incl   -0x18(%ebp)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 50 74             	mov    0x74(%eax),%edx
  80100e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801011:	39 c2                	cmp    %eax,%edx
  801013:	77 88                	ja     800f9d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801019:	75 14                	jne    80102f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 64 42 80 00       	push   $0x804264
  801023:	6a 3a                	push   $0x3a
  801025:	68 58 42 80 00       	push   $0x804258
  80102a:	e8 93 fe ff ff       	call   800ec2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80102f:	ff 45 f0             	incl   -0x10(%ebp)
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801038:	0f 8c 32 ff ff ff    	jl     800f70 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80103e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801045:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80104c:	eb 26                	jmp    801074 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80104e:	a1 20 50 80 00       	mov    0x805020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8a 40 04             	mov    0x4(%eax),%al
  80106a:	3c 01                	cmp    $0x1,%al
  80106c:	75 03                	jne    801071 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80106e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801071:	ff 45 e0             	incl   -0x20(%ebp)
  801074:	a1 20 50 80 00       	mov    0x805020,%eax
  801079:	8b 50 74             	mov    0x74(%eax),%edx
  80107c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	77 cb                	ja     80104e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801089:	74 14                	je     80109f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 b8 42 80 00       	push   $0x8042b8
  801093:	6a 44                	push   $0x44
  801095:	68 58 42 80 00       	push   $0x804258
  80109a:	e8 23 fe ff ff       	call   800ec2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	89 0a                	mov    %ecx,(%edx)
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	88 d1                	mov    %dl,%cl
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010cb:	75 2c                	jne    8010f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010cd:	a0 24 50 80 00       	mov    0x805024,%al
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 12                	mov    (%edx),%edx
  8010da:	89 d1                	mov    %edx,%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	50                   	push   %eax
  8010e6:	51                   	push   %ecx
  8010e7:	52                   	push   %edx
  8010e8:	e8 7c 13 00 00       	call   802469 <sys_cputs>
  8010ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 40 04             	mov    0x4(%eax),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 50 04             	mov    %edx,0x4(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80111b:	00 00 00 
	b.cnt = 0;
  80111e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801125:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	68 a2 10 80 00       	push   $0x8010a2
  80113a:	e8 11 02 00 00       	call   801350 <vprintfmt>
  80113f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801142:	a0 24 50 80 00       	mov    0x805024,%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801150:	83 ec 04             	sub    $0x4,%esp
  801153:	50                   	push   %eax
  801154:	52                   	push   %edx
  801155:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80115b:	83 c0 08             	add    $0x8,%eax
  80115e:	50                   	push   %eax
  80115f:	e8 05 13 00 00       	call   802469 <sys_cputs>
  801164:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801167:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80116e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <cprintf>:

int cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80117c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801183:	8d 45 0c             	lea    0xc(%ebp),%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 f4             	pushl  -0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	e8 73 ff ff ff       	call   80110b <vcprintf>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011a9:	e8 69 14 00 00       	call   802617 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 48 ff ff ff       	call   80110b <vcprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011c9:	e8 63 14 00 00       	call   802631 <sys_enable_interrupt>
	return cnt;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f1:	77 55                	ja     801248 <printnum+0x75>
  8011f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f6:	72 05                	jb     8011fd <printnum+0x2a>
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	77 4b                	ja     801248 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801200:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801203:	8b 45 18             	mov    0x18(%ebp),%eax
  801206:	ba 00 00 00 00       	mov    $0x0,%edx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	e8 80 2a 00 00       	call   803c98 <__udivdi3>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	ff 75 20             	pushl  0x20(%ebp)
  801221:	53                   	push   %ebx
  801222:	ff 75 18             	pushl  0x18(%ebp)
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 a1 ff ff ff       	call   8011d3 <printnum>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	eb 1a                	jmp    801251 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	ff 75 20             	pushl  0x20(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801248:	ff 4d 1c             	decl   0x1c(%ebp)
  80124b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80124f:	7f e6                	jg     801237 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	53                   	push   %ebx
  801260:	51                   	push   %ecx
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	e8 40 2b 00 00       	call   803da8 <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 34 45 80 00       	add    $0x804534,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	50                   	push   %eax
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	90                   	nop
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80128d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801291:	7e 1c                	jle    8012af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 50 08             	lea    0x8(%eax),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 10                	mov    %edx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	83 e8 08             	sub    $0x8,%eax
  8012a8:	8b 50 04             	mov    0x4(%eax),%edx
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	eb 40                	jmp    8012ef <getuint+0x65>
	else if (lflag)
  8012af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b3:	74 1e                	je     8012d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 50 04             	lea    0x4(%eax),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 10                	mov    %edx,(%eax)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
  8012ca:	8b 00                	mov    (%eax),%eax
  8012cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d1:	eb 1c                	jmp    8012ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 50 04             	lea    0x4(%eax),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 10                	mov    %edx,(%eax)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 e8 04             	sub    $0x4,%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012f8:	7e 1c                	jle    801316 <getint+0x25>
		return va_arg(*ap, long long);
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 50 08             	lea    0x8(%eax),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 10                	mov    %edx,(%eax)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 e8 08             	sub    $0x8,%eax
  80130f:	8b 50 04             	mov    0x4(%eax),%edx
  801312:	8b 00                	mov    (%eax),%eax
  801314:	eb 38                	jmp    80134e <getint+0x5d>
	else if (lflag)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 1a                	je     801336 <getint+0x45>
		return va_arg(*ap, long);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 10                	mov    %edx,(%eax)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	83 e8 04             	sub    $0x4,%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	99                   	cltd   
  801334:	eb 18                	jmp    80134e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 00                	mov    (%eax),%eax
  80133b:	8d 50 04             	lea    0x4(%eax),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 10                	mov    %edx,(%eax)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 e8 04             	sub    $0x4,%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	99                   	cltd   
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801358:	eb 17                	jmp    801371 <vprintfmt+0x21>
			if (ch == '\0')
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	0f 84 af 03 00 00    	je     801711 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	53                   	push   %ebx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 10             	mov    %edx,0x10(%ebp)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d8             	movzbl %al,%ebx
  80137f:	83 fb 25             	cmp    $0x25,%ebx
  801382:	75 d6                	jne    80135a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801384:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80138f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801396:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80139d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	0f b6 d8             	movzbl %al,%ebx
  8013b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 2b 03 00 00    	ja     8016e9 <vprintfmt+0x399>
  8013be:	8b 04 85 58 45 80 00 	mov    0x804558(,%eax,4),%eax
  8013c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013cb:	eb d7                	jmp    8013a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013d1:	eb d1                	jmp    8013a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	01 c0                	add    %eax,%eax
  8013e6:	01 d8                	add    %ebx,%eax
  8013e8:	83 e8 30             	sub    $0x30,%eax
  8013eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8013f9:	7e 3e                	jle    801439 <vprintfmt+0xe9>
  8013fb:	83 fb 39             	cmp    $0x39,%ebx
  8013fe:	7f 39                	jg     801439 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801400:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801403:	eb d5                	jmp    8013da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801419:	eb 1f                	jmp    80143a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80141b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141f:	79 83                	jns    8013a4 <vprintfmt+0x54>
				width = 0;
  801421:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801428:	e9 77 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80142d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801434:	e9 6b ff ff ff       	jmp    8013a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801439:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	0f 89 60 ff ff ff    	jns    8013a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801451:	e9 4e ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801456:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801459:	e9 46 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 14             	mov    %eax,0x14(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	83 e8 04             	sub    $0x4,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	ff d0                	call   *%eax
  80147b:	83 c4 10             	add    $0x10,%esp
			break;
  80147e:	e9 89 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	83 c0 04             	add    $0x4,%eax
  801489:	89 45 14             	mov    %eax,0x14(%ebp)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	83 e8 04             	sub    $0x4,%eax
  801492:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801494:	85 db                	test   %ebx,%ebx
  801496:	79 02                	jns    80149a <vprintfmt+0x14a>
				err = -err;
  801498:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80149a:	83 fb 64             	cmp    $0x64,%ebx
  80149d:	7f 0b                	jg     8014aa <vprintfmt+0x15a>
  80149f:	8b 34 9d a0 43 80 00 	mov    0x8043a0(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 45 45 80 00       	push   $0x804545
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 5e 02 00 00       	call   801719 <printfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014be:	e9 49 02 00 00       	jmp    80170c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014c3:	56                   	push   %esi
  8014c4:	68 4e 45 80 00       	push   $0x80454e
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 45 02 00 00       	call   801719 <printfmt>
  8014d4:	83 c4 10             	add    $0x10,%esp
			break;
  8014d7:	e9 30 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	83 c0 04             	add    $0x4,%eax
  8014e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	83 e8 04             	sub    $0x4,%eax
  8014eb:	8b 30                	mov    (%eax),%esi
  8014ed:	85 f6                	test   %esi,%esi
  8014ef:	75 05                	jne    8014f6 <vprintfmt+0x1a6>
				p = "(null)";
  8014f1:	be 51 45 80 00       	mov    $0x804551,%esi
			if (width > 0 && padc != '-')
  8014f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fa:	7e 6d                	jle    801569 <vprintfmt+0x219>
  8014fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801500:	74 67                	je     801569 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	e8 0c 03 00 00       	call   80181b <strnlen>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801515:	eb 16                	jmp    80152d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801517:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80152a:	ff 4d e4             	decl   -0x1c(%ebp)
  80152d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801531:	7f e4                	jg     801517 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801533:	eb 34                	jmp    801569 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801539:	74 1c                	je     801557 <vprintfmt+0x207>
  80153b:	83 fb 1f             	cmp    $0x1f,%ebx
  80153e:	7e 05                	jle    801545 <vprintfmt+0x1f5>
  801540:	83 fb 7e             	cmp    $0x7e,%ebx
  801543:	7e 12                	jle    801557 <vprintfmt+0x207>
					putch('?', putdat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	6a 3f                	push   $0x3f
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	ff d0                	call   *%eax
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb 0f                	jmp    801566 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	ff d0                	call   *%eax
  801563:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801566:	ff 4d e4             	decl   -0x1c(%ebp)
  801569:	89 f0                	mov    %esi,%eax
  80156b:	8d 70 01             	lea    0x1(%eax),%esi
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f be d8             	movsbl %al,%ebx
  801573:	85 db                	test   %ebx,%ebx
  801575:	74 24                	je     80159b <vprintfmt+0x24b>
  801577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157b:	78 b8                	js     801535 <vprintfmt+0x1e5>
  80157d:	ff 4d e0             	decl   -0x20(%ebp)
  801580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801584:	79 af                	jns    801535 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801586:	eb 13                	jmp    80159b <vprintfmt+0x24b>
				putch(' ', putdat);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	6a 20                	push   $0x20
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801598:	ff 4d e4             	decl   -0x1c(%ebp)
  80159b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159f:	7f e7                	jg     801588 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015a1:	e9 66 01 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 3c fd ff ff       	call   8012f1 <getint>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	79 23                	jns    8015eb <vprintfmt+0x29b>
				putch('-', putdat);
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	f7 d8                	neg    %eax
  8015e0:	83 d2 00             	adc    $0x0,%edx
  8015e3:	f7 da                	neg    %edx
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 bc 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	e8 84 fc ff ff       	call   80128a <getuint>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80160f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801616:	e9 98 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	6a 58                	push   $0x58
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	6a 58                	push   $0x58
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	6a 58                	push   $0x58
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	ff d0                	call   *%eax
  801648:	83 c4 10             	add    $0x10,%esp
			break;
  80164b:	e9 bc 00 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	6a 30                	push   $0x30
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	ff d0                	call   *%eax
  80165d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	6a 78                	push   $0x78
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	ff d0                	call   *%eax
  80166d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 e7 fb ff ff       	call   80128a <getuint>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8016ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	52                   	push   %edx
  8016be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 00 fb ff ff       	call   8011d3 <printnum>
  8016d3:	83 c4 20             	add    $0x20,%esp
			break;
  8016d6:	eb 34                	jmp    80170c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	53                   	push   %ebx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	ff d0                	call   *%eax
  8016e4:	83 c4 10             	add    $0x10,%esp
			break;
  8016e7:	eb 23                	jmp    80170c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f9:	ff 4d 10             	decl   0x10(%ebp)
  8016fc:	eb 03                	jmp    801701 <vprintfmt+0x3b1>
  8016fe:	ff 4d 10             	decl   0x10(%ebp)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	48                   	dec    %eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 25                	cmp    $0x25,%al
  801709:	75 f3                	jne    8016fe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80170b:	90                   	nop
		}
	}
  80170c:	e9 47 fc ff ff       	jmp    801358 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801711:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80171f:	8d 45 10             	lea    0x10(%ebp),%eax
  801722:	83 c0 04             	add    $0x4,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 16 fc ff ff       	call   801350 <vprintfmt>
  80173a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8b 10                	mov    (%eax),%edx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	8b 40 04             	mov    0x4(%eax),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	73 12                	jae    801773 <sprintputch+0x33>
		*b->buf++ = ch;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	8d 48 01             	lea    0x1(%eax),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 0a                	mov    %ecx,(%edx)
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	88 10                	mov    %dl,(%eax)
}
  801773:	90                   	nop
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8d 50 ff             	lea    -0x1(%eax),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	74 06                	je     8017a3 <vsnprintf+0x2d>
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	7f 07                	jg     8017aa <vsnprintf+0x34>
		return -E_INVAL;
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	eb 20                	jmp    8017ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017aa:	ff 75 14             	pushl  0x14(%ebp)
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	68 40 17 80 00       	push   $0x801740
  8017b9:	e8 92 fb ff ff       	call   801350 <vprintfmt>
  8017be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d5:	83 c0 04             	add    $0x4,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 89 ff ff ff       	call   801776 <vsnprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801805:	eb 06                	jmp    80180d <strlen+0x15>
		n++;
  801807:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	84 c0                	test   %al,%al
  801814:	75 f1                	jne    801807 <strlen+0xf>
		n++;
	return n;
  801816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801828:	eb 09                	jmp    801833 <strnlen+0x18>
		n++;
  80182a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	ff 4d 0c             	decl   0xc(%ebp)
  801833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801837:	74 09                	je     801842 <strnlen+0x27>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	84 c0                	test   %al,%al
  801840:	75 e8                	jne    80182a <strnlen+0xf>
		n++;
	return n;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801853:	90                   	nop
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8d 4a 01             	lea    0x1(%edx),%ecx
  801863:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801866:	8a 12                	mov    (%edx),%dl
  801868:	88 10                	mov    %dl,(%eax)
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	84 c0                	test   %al,%al
  80186e:	75 e4                	jne    801854 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strncpy+0x34>
		*dst++ = *src;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 08             	mov    %edx,0x8(%ebp)
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8a 12                	mov    (%edx),%dl
  801898:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8a 00                	mov    (%eax),%al
  80189f:	84 c0                	test   %al,%al
  8018a1:	74 03                	je     8018a6 <strncpy+0x31>
			src++;
  8018a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a6:	ff 45 fc             	incl   -0x4(%ebp)
  8018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018af:	72 d9                	jb     80188a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8018c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c6:	74 30                	je     8018f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018c8:	eb 16                	jmp    8018e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018e0:	ff 4d 10             	decl   0x10(%ebp)
  8018e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018e7:	74 09                	je     8018f2 <strlcpy+0x3c>
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	84 c0                	test   %al,%al
  8018f0:	75 d8                	jne    8018ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801907:	eb 06                	jmp    80190f <strcmp+0xb>
		p++, q++;
  801909:	ff 45 08             	incl   0x8(%ebp)
  80190c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	84 c0                	test   %al,%al
  801916:	74 0e                	je     801926 <strcmp+0x22>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 10                	mov    (%eax),%dl
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	38 c2                	cmp    %al,%dl
  801924:	74 e3                	je     801909 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	0f b6 d0             	movzbl %al,%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f b6 c0             	movzbl %al,%eax
  801936:	29 c2                	sub    %eax,%edx
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80193f:	eb 09                	jmp    80194a <strncmp+0xe>
		n--, p++, q++;
  801941:	ff 4d 10             	decl   0x10(%ebp)
  801944:	ff 45 08             	incl   0x8(%ebp)
  801947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80194a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194e:	74 17                	je     801967 <strncmp+0x2b>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 0e                	je     801967 <strncmp+0x2b>
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 10                	mov    (%eax),%dl
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	38 c2                	cmp    %al,%dl
  801965:	74 da                	je     801941 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 07                	jne    801974 <strncmp+0x38>
		return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 14                	jmp    801988 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	0f b6 d0             	movzbl %al,%edx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 d0                	mov    %edx,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801996:	eb 12                	jmp    8019aa <strchr+0x20>
		if (*s == c)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a0:	75 05                	jne    8019a7 <strchr+0x1d>
			return (char *) s;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	eb 11                	jmp    8019b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 e5                	jne    801998 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019c6:	eb 0d                	jmp    8019d5 <strfind+0x1b>
		if (*s == c)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019d0:	74 0e                	je     8019e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	ff 45 08             	incl   0x8(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	75 ea                	jne    8019c8 <strfind+0xe>
  8019de:	eb 01                	jmp    8019e1 <strfind+0x27>
		if (*s == c)
			break;
  8019e0:	90                   	nop
	return (char *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019f8:	eb 0e                	jmp    801a08 <memset+0x22>
		*p++ = c;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a08:	ff 4d f8             	decl   -0x8(%ebp)
  801a0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a0f:	79 e9                	jns    8019fa <memset+0x14>
		*p++ = c;

	return v;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a28:	eb 16                	jmp    801a40 <memcpy+0x2a>
		*d++ = *s++;
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	8d 50 01             	lea    0x1(%eax),%edx
  801a30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a3c:	8a 12                	mov    (%edx),%dl
  801a3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a46:	89 55 10             	mov    %edx,0x10(%ebp)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	75 dd                	jne    801a2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a6a:	73 50                	jae    801abc <memmove+0x6a>
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	01 d0                	add    %edx,%eax
  801a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a77:	76 43                	jbe    801abc <memmove+0x6a>
		s += n;
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a85:	eb 10                	jmp    801a97 <memmove+0x45>
			*--d = *--s;
  801a87:	ff 4d f8             	decl   -0x8(%ebp)
  801a8a:	ff 4d fc             	decl   -0x4(%ebp)
  801a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a90:	8a 10                	mov    (%eax),%dl
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 e3                	jne    801a87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aa4:	eb 23                	jmp    801ac9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ab8:	8a 12                	mov    (%edx),%dl
  801aba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 dd                	jne    801aa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ae0:	eb 2a                	jmp    801b0c <memcmp+0x3e>
		if (*s1 != *s2)
  801ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae5:	8a 10                	mov    (%eax),%dl
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	38 c2                	cmp    %al,%dl
  801aee:	74 16                	je     801b06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8a 00                	mov    (%eax),%al
  801af5:	0f b6 d0             	movzbl %al,%edx
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	0f b6 c0             	movzbl %al,%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	eb 18                	jmp    801b1e <memcmp+0x50>
		s1++, s2++;
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 c9                	jne    801ae2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b26:	8b 55 08             	mov    0x8(%ebp),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b31:	eb 15                	jmp    801b48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	0f b6 d0             	movzbl %al,%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	39 c2                	cmp    %eax,%edx
  801b43:	74 0d                	je     801b52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b45:	ff 45 08             	incl   0x8(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b4e:	72 e3                	jb     801b33 <memfind+0x13>
  801b50:	eb 01                	jmp    801b53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b52:	90                   	nop
	return (void *) s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b6c:	eb 03                	jmp    801b71 <strtol+0x19>
		s++;
  801b6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8a 00                	mov    (%eax),%al
  801b76:	3c 20                	cmp    $0x20,%al
  801b78:	74 f4                	je     801b6e <strtol+0x16>
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	3c 09                	cmp    $0x9,%al
  801b81:	74 eb                	je     801b6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 2b                	cmp    $0x2b,%al
  801b8a:	75 05                	jne    801b91 <strtol+0x39>
		s++;
  801b8c:	ff 45 08             	incl   0x8(%ebp)
  801b8f:	eb 13                	jmp    801ba4 <strtol+0x4c>
	else if (*s == '-')
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	3c 2d                	cmp    $0x2d,%al
  801b98:	75 0a                	jne    801ba4 <strtol+0x4c>
		s++, neg = 1;
  801b9a:	ff 45 08             	incl   0x8(%ebp)
  801b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba8:	74 06                	je     801bb0 <strtol+0x58>
  801baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801bae:	75 20                	jne    801bd0 <strtol+0x78>
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	3c 30                	cmp    $0x30,%al
  801bb7:	75 17                	jne    801bd0 <strtol+0x78>
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	40                   	inc    %eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	3c 78                	cmp    $0x78,%al
  801bc1:	75 0d                	jne    801bd0 <strtol+0x78>
		s += 2, base = 16;
  801bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801bce:	eb 28                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd4:	75 15                	jne    801beb <strtol+0x93>
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	3c 30                	cmp    $0x30,%al
  801bdd:	75 0c                	jne    801beb <strtol+0x93>
		s++, base = 8;
  801bdf:	ff 45 08             	incl   0x8(%ebp)
  801be2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801be9:	eb 0d                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0)
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	75 07                	jne    801bf8 <strtol+0xa0>
		base = 10;
  801bf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	3c 2f                	cmp    $0x2f,%al
  801bff:	7e 19                	jle    801c1a <strtol+0xc2>
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8a 00                	mov    (%eax),%al
  801c06:	3c 39                	cmp    $0x39,%al
  801c08:	7f 10                	jg     801c1a <strtol+0xc2>
			dig = *s - '0';
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8a 00                	mov    (%eax),%al
  801c0f:	0f be c0             	movsbl %al,%eax
  801c12:	83 e8 30             	sub    $0x30,%eax
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c18:	eb 42                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 60                	cmp    $0x60,%al
  801c21:	7e 19                	jle    801c3c <strtol+0xe4>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3c 7a                	cmp    $0x7a,%al
  801c2a:	7f 10                	jg     801c3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	83 e8 57             	sub    $0x57,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 20                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8a 00                	mov    (%eax),%al
  801c41:	3c 40                	cmp    $0x40,%al
  801c43:	7e 39                	jle    801c7e <strtol+0x126>
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 5a                	cmp    $0x5a,%al
  801c4c:	7f 30                	jg     801c7e <strtol+0x126>
			dig = *s - 'A' + 10;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	83 e8 37             	sub    $0x37,%eax
  801c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c62:	7d 19                	jge    801c7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c64:	ff 45 08             	incl   0x8(%ebp)
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c78:	e9 7b ff ff ff       	jmp    801bf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c82:	74 08                	je     801c8c <strtol+0x134>
		*endptr = (char *) s;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c90:	74 07                	je     801c99 <strtol+0x141>
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	f7 d8                	neg    %eax
  801c97:	eb 03                	jmp    801c9c <strtol+0x144>
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <ltostr>:

void
ltostr(long value, char *str)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801cab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	79 13                	jns    801ccb <ltostr+0x2d>
	{
		neg = 1;
  801cb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801cc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801cc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801cd3:	99                   	cltd   
  801cd4:	f7 f9                	idiv   %ecx
  801cd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdc:	8d 50 01             	lea    0x1(%eax),%edx
  801cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cec:	83 c2 30             	add    $0x30,%edx
  801cef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cf9:	f7 e9                	imul   %ecx
  801cfb:	c1 fa 02             	sar    $0x2,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	c1 f8 1f             	sar    $0x1f,%eax
  801d03:	29 c2                	sub    %eax,%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d12:	f7 e9                	imul   %ecx
  801d14:	c1 fa 02             	sar    $0x2,%edx
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	c1 f8 1f             	sar    $0x1f,%eax
  801d1c:	29 c2                	sub    %eax,%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	29 c1                	sub    %eax,%ecx
  801d29:	89 ca                	mov    %ecx,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	75 9c                	jne    801ccb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d41:	74 3d                	je     801d80 <ltostr+0xe2>
		start = 1 ;
  801d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d4a:	eb 34                	jmp    801d80 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 c8                	add    %ecx,%eax
  801d69:	8a 00                	mov    (%eax),%al
  801d6b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 c2                	add    %eax,%edx
  801d75:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d78:	88 02                	mov    %al,(%edx)
		start++ ;
  801d7a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d7d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d86:	7c c4                	jl     801d4c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d88:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d93:	90                   	nop
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 54 fa ff ff       	call   8017f8 <strlen>
  801da4:	83 c4 04             	add    $0x4,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	e8 46 fa ff ff       	call   8017f8 <strlen>
  801db2:	83 c4 04             	add    $0x4,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dc6:	eb 17                	jmp    801ddf <strcconcat+0x49>
		final[s] = str1[s] ;
  801dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ddc:	ff 45 fc             	incl   -0x4(%ebp)
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de5:	7c e1                	jl     801dc8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801df5:	eb 1f                	jmp    801e16 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	8d 50 01             	lea    0x1(%eax),%edx
  801dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e13:	ff 45 f8             	incl   -0x8(%ebp)
  801e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1c:	7c d9                	jl     801df7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e4f:	eb 0c                	jmp    801e5d <strsplit+0x31>
			*string++ = 0;
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8d 50 01             	lea    0x1(%eax),%edx
  801e57:	89 55 08             	mov    %edx,0x8(%ebp)
  801e5a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 18                	je     801e7e <strsplit+0x52>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 00                	mov    (%eax),%al
  801e6b:	0f be c0             	movsbl %al,%eax
  801e6e:	50                   	push   %eax
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 13 fb ff ff       	call   80198a <strchr>
  801e77:	83 c4 08             	add    $0x8,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 d3                	jne    801e51 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 5a                	je     801ee1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	83 f8 0f             	cmp    $0xf,%eax
  801e8f:	75 07                	jne    801e98 <strsplit+0x6c>
		{
			return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 66                	jmp    801efe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ea3:	89 0a                	mov    %ecx,(%edx)
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801eb6:	eb 03                	jmp    801ebb <strsplit+0x8f>
			string++;
  801eb8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	84 c0                	test   %al,%al
  801ec2:	74 8b                	je     801e4f <strsplit+0x23>
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8a 00                	mov    (%eax),%al
  801ec9:	0f be c0             	movsbl %al,%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 b5 fa ff ff       	call   80198a <strchr>
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 dc                	je     801eb8 <strsplit+0x8c>
			string++;
	}
  801edc:	e9 6e ff ff ff       	jmp    801e4f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ee1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801f06:	a1 04 50 80 00       	mov    0x805004,%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 1f                	je     801f2e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801f0f:	e8 1d 00 00 00       	call   801f31 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 b0 46 80 00       	push   $0x8046b0
  801f1c:	e8 55 f2 ff ff       	call   801176 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f24:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801f2b:	00 00 00 
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801f37:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801f3e:	00 00 00 
  801f41:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801f48:	00 00 00 
  801f4b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801f52:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801f55:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801f5c:	00 00 00 
  801f5f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801f66:	00 00 00 
  801f69:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801f70:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801f73:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801f7a:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801f7d:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801f84:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f93:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f98:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801f9d:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fac:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	6a 06                	push   $0x6
  801fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb9:	50                   	push   %eax
  801fba:	e8 ee 05 00 00       	call   8025ad <sys_allocate_chunk>
  801fbf:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fc2:	a1 20 51 80 00       	mov    0x805120,%eax
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	50                   	push   %eax
  801fcb:	e8 63 0c 00 00       	call   802c33 <initialize_MemBlocksList>
  801fd0:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801fd3:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801fd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fde:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  801feb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ff6:	89 c2                	mov    %eax,%edx
  801ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ffb:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802001:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  802008:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80200f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802012:	8b 50 08             	mov    0x8(%eax),%edx
  802015:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802018:	01 d0                	add    %edx,%eax
  80201a:	48                   	dec    %eax
  80201b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80201e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802021:	ba 00 00 00 00       	mov    $0x0,%edx
  802026:	f7 75 e0             	divl   -0x20(%ebp)
  802029:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80202c:	29 d0                	sub    %edx,%eax
  80202e:	89 c2                	mov    %eax,%edx
  802030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802033:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  802036:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80203a:	75 14                	jne    802050 <initialize_dyn_block_system+0x11f>
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	68 d5 46 80 00       	push   $0x8046d5
  802044:	6a 34                	push   $0x34
  802046:	68 f3 46 80 00       	push   $0x8046f3
  80204b:	e8 72 ee ff ff       	call   800ec2 <_panic>
  802050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802053:	8b 00                	mov    (%eax),%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	74 10                	je     802069 <initialize_dyn_block_system+0x138>
  802059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205c:	8b 00                	mov    (%eax),%eax
  80205e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802061:	8b 52 04             	mov    0x4(%edx),%edx
  802064:	89 50 04             	mov    %edx,0x4(%eax)
  802067:	eb 0b                	jmp    802074 <initialize_dyn_block_system+0x143>
  802069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206c:	8b 40 04             	mov    0x4(%eax),%eax
  80206f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802077:	8b 40 04             	mov    0x4(%eax),%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	74 0f                	je     80208d <initialize_dyn_block_system+0x15c>
  80207e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802081:	8b 40 04             	mov    0x4(%eax),%eax
  802084:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802087:	8b 12                	mov    (%edx),%edx
  802089:	89 10                	mov    %edx,(%eax)
  80208b:	eb 0a                	jmp    802097 <initialize_dyn_block_system+0x166>
  80208d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802090:	8b 00                	mov    (%eax),%eax
  802092:	a3 48 51 80 00       	mov    %eax,0x805148
  802097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80209a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8020af:	48                   	dec    %eax
  8020b0:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8020bb:	e8 c4 13 00 00       	call   803484 <insert_sorted_with_merge_freeList>
  8020c0:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8020c3:	90                   	nop
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020cc:	e8 2f fe ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  8020d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d5:	75 07                	jne    8020de <malloc+0x18>
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020dc:	eb 71                	jmp    80214f <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8020de:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8020e5:	76 07                	jbe    8020ee <malloc+0x28>
	return NULL;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	eb 61                	jmp    80214f <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020ee:	e8 88 08 00 00       	call   80297b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	74 53                	je     80214a <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8020f7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8020fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	01 d0                	add    %edx,%eax
  802106:	48                   	dec    %eax
  802107:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	ba 00 00 00 00       	mov    $0x0,%edx
  802112:	f7 75 f4             	divl   -0xc(%ebp)
  802115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802118:	29 d0                	sub    %edx,%eax
  80211a:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80211d:	83 ec 0c             	sub    $0xc,%esp
  802120:	ff 75 ec             	pushl  -0x14(%ebp)
  802123:	e8 d2 0d 00 00       	call   802efa <alloc_block_FF>
  802128:	83 c4 10             	add    $0x10,%esp
  80212b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80212e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802132:	74 16                	je     80214a <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	ff 75 e8             	pushl  -0x18(%ebp)
  80213a:	e8 0c 0c 00 00       	call   802d4b <insert_sorted_allocList>
  80213f:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  802142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802145:	8b 40 08             	mov    0x8(%eax),%eax
  802148:	eb 05                	jmp    80214f <malloc+0x89>
    }

			}


	return NULL;
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802165:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  802168:	83 ec 08             	sub    $0x8,%esp
  80216b:	ff 75 f0             	pushl  -0x10(%ebp)
  80216e:	68 40 50 80 00       	push   $0x805040
  802173:	e8 a0 0b 00 00       	call   802d18 <find_block>
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80217e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802181:	8b 50 0c             	mov    0xc(%eax),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	83 ec 08             	sub    $0x8,%esp
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	e8 e4 03 00 00       	call   802575 <sys_free_user_mem>
  802191:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  802194:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802198:	75 17                	jne    8021b1 <free+0x60>
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 d5 46 80 00       	push   $0x8046d5
  8021a2:	68 84 00 00 00       	push   $0x84
  8021a7:	68 f3 46 80 00       	push   $0x8046f3
  8021ac:	e8 11 ed ff ff       	call   800ec2 <_panic>
  8021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	74 10                	je     8021ca <free+0x79>
  8021ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021c2:	8b 52 04             	mov    0x4(%edx),%edx
  8021c5:	89 50 04             	mov    %edx,0x4(%eax)
  8021c8:	eb 0b                	jmp    8021d5 <free+0x84>
  8021ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cd:	8b 40 04             	mov    0x4(%eax),%eax
  8021d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8021d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d8:	8b 40 04             	mov    0x4(%eax),%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	74 0f                	je     8021ee <free+0x9d>
  8021df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e2:	8b 40 04             	mov    0x4(%eax),%eax
  8021e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021e8:	8b 12                	mov    (%edx),%edx
  8021ea:	89 10                	mov    %edx,(%eax)
  8021ec:	eb 0a                	jmp    8021f8 <free+0xa7>
  8021ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8021f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802204:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802210:	48                   	dec    %eax
  802211:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  802216:	83 ec 0c             	sub    $0xc,%esp
  802219:	ff 75 ec             	pushl  -0x14(%ebp)
  80221c:	e8 63 12 00 00       	call   803484 <insert_sorted_with_merge_freeList>
  802221:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  802224:	90                   	nop
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 38             	sub    $0x38,%esp
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802233:	e8 c8 fc ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802238:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80223c:	75 0a                	jne    802248 <smalloc+0x21>
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	e9 a0 00 00 00       	jmp    8022e8 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802248:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80224f:	76 0a                	jbe    80225b <smalloc+0x34>
		return NULL;
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	e9 8d 00 00 00       	jmp    8022e8 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80225b:	e8 1b 07 00 00       	call   80297b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802260:	85 c0                	test   %eax,%eax
  802262:	74 7f                	je     8022e3 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802264:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	48                   	dec    %eax
  802274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	ba 00 00 00 00       	mov    $0x0,%edx
  80227f:	f7 75 f4             	divl   -0xc(%ebp)
  802282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802285:	29 d0                	sub    %edx,%eax
  802287:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80228a:	83 ec 0c             	sub    $0xc,%esp
  80228d:	ff 75 ec             	pushl  -0x14(%ebp)
  802290:	e8 65 0c 00 00       	call   802efa <alloc_block_FF>
  802295:	83 c4 10             	add    $0x10,%esp
  802298:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80229b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80229f:	74 42                	je     8022e3 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8022a7:	e8 9f 0a 00 00       	call   802d4b <insert_sorted_allocList>
  8022ac:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8022af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b2:	8b 40 08             	mov    0x8(%eax),%eax
  8022b5:	89 c2                	mov    %eax,%edx
  8022b7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8022bb:	52                   	push   %edx
  8022bc:	50                   	push   %eax
  8022bd:	ff 75 0c             	pushl  0xc(%ebp)
  8022c0:	ff 75 08             	pushl  0x8(%ebp)
  8022c3:	e8 38 04 00 00       	call   802700 <sys_createSharedObject>
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8022ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022d2:	79 07                	jns    8022db <smalloc+0xb4>
	    		  return NULL;
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	eb 0d                	jmp    8022e8 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8022db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022de:	8b 40 08             	mov    0x8(%eax),%eax
  8022e1:	eb 05                	jmp    8022e8 <smalloc+0xc1>


				}


		return NULL;
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022f0:	e8 0b fc ff ff       	call   801f00 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8022f5:	e8 81 06 00 00       	call   80297b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	0f 84 9f 00 00 00    	je     8023a1 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802302:	83 ec 08             	sub    $0x8,%esp
  802305:	ff 75 0c             	pushl  0xc(%ebp)
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	e8 1a 04 00 00       	call   80272a <sys_getSizeOfSharedObject>
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	79 0a                	jns    802326 <sget+0x3c>
		return NULL;
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	e9 80 00 00 00       	jmp    8023a6 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802326:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80232d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802333:	01 d0                	add    %edx,%eax
  802335:	48                   	dec    %eax
  802336:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	ba 00 00 00 00       	mov    $0x0,%edx
  802341:	f7 75 f0             	divl   -0x10(%ebp)
  802344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802347:	29 d0                	sub    %edx,%eax
  802349:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80234c:	83 ec 0c             	sub    $0xc,%esp
  80234f:	ff 75 e8             	pushl  -0x18(%ebp)
  802352:	e8 a3 0b 00 00       	call   802efa <alloc_block_FF>
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80235d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802361:	74 3e                	je     8023a1 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	ff 75 e4             	pushl  -0x1c(%ebp)
  802369:	e8 dd 09 00 00       	call   802d4b <insert_sorted_allocList>
  80236e:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802374:	8b 40 08             	mov    0x8(%eax),%eax
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	50                   	push   %eax
  80237b:	ff 75 0c             	pushl  0xc(%ebp)
  80237e:	ff 75 08             	pushl  0x8(%ebp)
  802381:	e8 c1 03 00 00       	call   802747 <sys_getSharedObject>
  802386:	83 c4 10             	add    $0x10,%esp
  802389:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80238c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802390:	79 07                	jns    802399 <sget+0xaf>
	    		  return NULL;
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
  802397:	eb 0d                	jmp    8023a6 <sget+0xbc>
	  	return(void*) returned_block->sva;
  802399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80239c:	8b 40 08             	mov    0x8(%eax),%eax
  80239f:	eb 05                	jmp    8023a6 <sget+0xbc>
	      }
	}
	   return NULL;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8023ae:	e8 4d fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023b3:	83 ec 04             	sub    $0x4,%esp
  8023b6:	68 00 47 80 00       	push   $0x804700
  8023bb:	68 12 01 00 00       	push   $0x112
  8023c0:	68 f3 46 80 00       	push   $0x8046f3
  8023c5:	e8 f8 ea ff ff       	call   800ec2 <_panic>

008023ca <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	68 28 47 80 00       	push   $0x804728
  8023d8:	68 26 01 00 00       	push   $0x126
  8023dd:	68 f3 46 80 00       	push   $0x8046f3
  8023e2:	e8 db ea ff ff       	call   800ec2 <_panic>

008023e7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	68 4c 47 80 00       	push   $0x80474c
  8023f5:	68 31 01 00 00       	push   $0x131
  8023fa:	68 f3 46 80 00       	push   $0x8046f3
  8023ff:	e8 be ea ff ff       	call   800ec2 <_panic>

00802404 <shrink>:

}
void shrink(uint32 newSize)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 4c 47 80 00       	push   $0x80474c
  802412:	68 36 01 00 00       	push   $0x136
  802417:	68 f3 46 80 00       	push   $0x8046f3
  80241c:	e8 a1 ea ff ff       	call   800ec2 <_panic>

00802421 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	68 4c 47 80 00       	push   $0x80474c
  80242f:	68 3b 01 00 00       	push   $0x13b
  802434:	68 f3 46 80 00       	push   $0x8046f3
  802439:	e8 84 ea ff ff       	call   800ec2 <_panic>

0080243e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802450:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802453:	8b 7d 18             	mov    0x18(%ebp),%edi
  802456:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802459:	cd 30                	int    $0x30
  80245b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80245e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	5b                   	pop    %ebx
  802465:	5e                   	pop    %esi
  802466:	5f                   	pop    %edi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	8b 45 10             	mov    0x10(%ebp),%eax
  802472:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802475:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	52                   	push   %edx
  802481:	ff 75 0c             	pushl  0xc(%ebp)
  802484:	50                   	push   %eax
  802485:	6a 00                	push   $0x0
  802487:	e8 b2 ff ff ff       	call   80243e <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
}
  80248f:	90                   	nop
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <sys_cgetc>:

int
sys_cgetc(void)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 01                	push   $0x1
  8024a1:	e8 98 ff ff ff       	call   80243e <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	52                   	push   %edx
  8024bb:	50                   	push   %eax
  8024bc:	6a 05                	push   $0x5
  8024be:	e8 7b ff ff ff       	call   80243e <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	56                   	push   %esi
  8024cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8024d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	56                   	push   %esi
  8024dd:	53                   	push   %ebx
  8024de:	51                   	push   %ecx
  8024df:	52                   	push   %edx
  8024e0:	50                   	push   %eax
  8024e1:	6a 06                	push   $0x6
  8024e3:	e8 56 ff ff ff       	call   80243e <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ee:	5b                   	pop    %ebx
  8024ef:	5e                   	pop    %esi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    

008024f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	52                   	push   %edx
  802502:	50                   	push   %eax
  802503:	6a 07                	push   $0x7
  802505:	e8 34 ff ff ff       	call   80243e <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

0080250f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	ff 75 0c             	pushl  0xc(%ebp)
  80251b:	ff 75 08             	pushl  0x8(%ebp)
  80251e:	6a 08                	push   $0x8
  802520:	e8 19 ff ff ff       	call   80243e <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 09                	push   $0x9
  802539:	e8 00 ff ff ff       	call   80243e <syscall>
  80253e:	83 c4 18             	add    $0x18,%esp
}
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 0a                	push   $0xa
  802552:	e8 e7 fe ff ff       	call   80243e <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 0b                	push   $0xb
  80256b:	e8 ce fe ff ff       	call   80243e <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	ff 75 0c             	pushl  0xc(%ebp)
  802581:	ff 75 08             	pushl  0x8(%ebp)
  802584:	6a 0f                	push   $0xf
  802586:	e8 b3 fe ff ff       	call   80243e <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
	return;
  80258e:	90                   	nop
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	6a 10                	push   $0x10
  8025a2:	e8 97 fe ff ff       	call   80243e <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025aa:	90                   	nop
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	ff 75 10             	pushl  0x10(%ebp)
  8025b7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ba:	ff 75 08             	pushl  0x8(%ebp)
  8025bd:	6a 11                	push   $0x11
  8025bf:	e8 7a fe ff ff       	call   80243e <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c7:	90                   	nop
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 0c                	push   $0xc
  8025d9:	e8 60 fe ff ff       	call   80243e <syscall>
  8025de:	83 c4 18             	add    $0x18,%esp
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	ff 75 08             	pushl  0x8(%ebp)
  8025f1:	6a 0d                	push   $0xd
  8025f3:	e8 46 fe ff ff       	call   80243e <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 0e                	push   $0xe
  80260c:	e8 2d fe ff ff       	call   80243e <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	90                   	nop
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 13                	push   $0x13
  802626:	e8 13 fe ff ff       	call   80243e <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
}
  80262e:	90                   	nop
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 14                	push   $0x14
  802640:	e8 f9 fd ff ff       	call   80243e <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
}
  802648:	90                   	nop
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_cputc>:


void
sys_cputc(const char c)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 04             	sub    $0x4,%esp
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802657:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	50                   	push   %eax
  802664:	6a 15                	push   $0x15
  802666:	e8 d3 fd ff ff       	call   80243e <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	90                   	nop
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 16                	push   $0x16
  802680:	e8 b9 fd ff ff       	call   80243e <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	90                   	nop
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	ff 75 0c             	pushl  0xc(%ebp)
  80269a:	50                   	push   %eax
  80269b:	6a 17                	push   $0x17
  80269d:	e8 9c fd ff ff       	call   80243e <syscall>
  8026a2:	83 c4 18             	add    $0x18,%esp
}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	52                   	push   %edx
  8026b7:	50                   	push   %eax
  8026b8:	6a 1a                	push   $0x1a
  8026ba:	e8 7f fd ff ff       	call   80243e <syscall>
  8026bf:	83 c4 18             	add    $0x18,%esp
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	52                   	push   %edx
  8026d4:	50                   	push   %eax
  8026d5:	6a 18                	push   $0x18
  8026d7:	e8 62 fd ff ff       	call   80243e <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	90                   	nop
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	52                   	push   %edx
  8026f2:	50                   	push   %eax
  8026f3:	6a 19                	push   $0x19
  8026f5:	e8 44 fd ff ff       	call   80243e <syscall>
  8026fa:	83 c4 18             	add    $0x18,%esp
}
  8026fd:	90                   	nop
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 04             	sub    $0x4,%esp
  802706:	8b 45 10             	mov    0x10(%ebp),%eax
  802709:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80270c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80270f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	6a 00                	push   $0x0
  802718:	51                   	push   %ecx
  802719:	52                   	push   %edx
  80271a:	ff 75 0c             	pushl  0xc(%ebp)
  80271d:	50                   	push   %eax
  80271e:	6a 1b                	push   $0x1b
  802720:	e8 19 fd ff ff       	call   80243e <syscall>
  802725:	83 c4 18             	add    $0x18,%esp
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80272d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	52                   	push   %edx
  80273a:	50                   	push   %eax
  80273b:	6a 1c                	push   $0x1c
  80273d:	e8 fc fc ff ff       	call   80243e <syscall>
  802742:	83 c4 18             	add    $0x18,%esp
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80274a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	51                   	push   %ecx
  802758:	52                   	push   %edx
  802759:	50                   	push   %eax
  80275a:	6a 1d                	push   $0x1d
  80275c:	e8 dd fc ff ff       	call   80243e <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	52                   	push   %edx
  802776:	50                   	push   %eax
  802777:	6a 1e                	push   $0x1e
  802779:	e8 c0 fc ff ff       	call   80243e <syscall>
  80277e:	83 c4 18             	add    $0x18,%esp
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 1f                	push   $0x1f
  802792:	e8 a7 fc ff ff       	call   80243e <syscall>
  802797:	83 c4 18             	add    $0x18,%esp
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	6a 00                	push   $0x0
  8027a4:	ff 75 14             	pushl  0x14(%ebp)
  8027a7:	ff 75 10             	pushl  0x10(%ebp)
  8027aa:	ff 75 0c             	pushl  0xc(%ebp)
  8027ad:	50                   	push   %eax
  8027ae:	6a 20                	push   $0x20
  8027b0:	e8 89 fc ff ff       	call   80243e <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	50                   	push   %eax
  8027c9:	6a 21                	push   $0x21
  8027cb:	e8 6e fc ff ff       	call   80243e <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
}
  8027d3:	90                   	nop
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	50                   	push   %eax
  8027e5:	6a 22                	push   $0x22
  8027e7:	e8 52 fc ff ff       	call   80243e <syscall>
  8027ec:	83 c4 18             	add    $0x18,%esp
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 02                	push   $0x2
  802800:	e8 39 fc ff ff       	call   80243e <syscall>
  802805:	83 c4 18             	add    $0x18,%esp
}
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 03                	push   $0x3
  802819:	e8 20 fc ff ff       	call   80243e <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 04                	push   $0x4
  802832:	e8 07 fc ff ff       	call   80243e <syscall>
  802837:	83 c4 18             	add    $0x18,%esp
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <sys_exit_env>:


void sys_exit_env(void)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	6a 00                	push   $0x0
  802849:	6a 23                	push   $0x23
  80284b:	e8 ee fb ff ff       	call   80243e <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
}
  802853:	90                   	nop
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80285c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80285f:	8d 50 04             	lea    0x4(%eax),%edx
  802862:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	52                   	push   %edx
  80286c:	50                   	push   %eax
  80286d:	6a 24                	push   $0x24
  80286f:	e8 ca fb ff ff       	call   80243e <syscall>
  802874:	83 c4 18             	add    $0x18,%esp
	return result;
  802877:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80287a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80287d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802880:	89 01                	mov    %eax,(%ecx)
  802882:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	c9                   	leave  
  802889:	c2 04 00             	ret    $0x4

0080288c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	ff 75 10             	pushl  0x10(%ebp)
  802896:	ff 75 0c             	pushl  0xc(%ebp)
  802899:	ff 75 08             	pushl  0x8(%ebp)
  80289c:	6a 12                	push   $0x12
  80289e:	e8 9b fb ff ff       	call   80243e <syscall>
  8028a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a6:	90                   	nop
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 25                	push   $0x25
  8028b8:	e8 81 fb ff ff       	call   80243e <syscall>
  8028bd:	83 c4 18             	add    $0x18,%esp
}
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    

008028c2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028ce:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	50                   	push   %eax
  8028db:	6a 26                	push   $0x26
  8028dd:	e8 5c fb ff ff       	call   80243e <syscall>
  8028e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e5:	90                   	nop
}
  8028e6:	c9                   	leave  
  8028e7:	c3                   	ret    

008028e8 <rsttst>:
void rsttst()
{
  8028e8:	55                   	push   %ebp
  8028e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 28                	push   $0x28
  8028f7:	e8 42 fb ff ff       	call   80243e <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8028ff:	90                   	nop
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	8b 45 14             	mov    0x14(%ebp),%eax
  80290b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80290e:	8b 55 18             	mov    0x18(%ebp),%edx
  802911:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802915:	52                   	push   %edx
  802916:	50                   	push   %eax
  802917:	ff 75 10             	pushl  0x10(%ebp)
  80291a:	ff 75 0c             	pushl  0xc(%ebp)
  80291d:	ff 75 08             	pushl  0x8(%ebp)
  802920:	6a 27                	push   $0x27
  802922:	e8 17 fb ff ff       	call   80243e <syscall>
  802927:	83 c4 18             	add    $0x18,%esp
	return ;
  80292a:	90                   	nop
}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    

0080292d <chktst>:
void chktst(uint32 n)
{
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802930:	6a 00                	push   $0x0
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	ff 75 08             	pushl  0x8(%ebp)
  80293b:	6a 29                	push   $0x29
  80293d:	e8 fc fa ff ff       	call   80243e <syscall>
  802942:	83 c4 18             	add    $0x18,%esp
	return ;
  802945:	90                   	nop
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    

00802948 <inctst>:

void inctst()
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 2a                	push   $0x2a
  802957:	e8 e2 fa ff ff       	call   80243e <syscall>
  80295c:	83 c4 18             	add    $0x18,%esp
	return ;
  80295f:	90                   	nop
}
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <gettst>:
uint32 gettst()
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 2b                	push   $0x2b
  802971:	e8 c8 fa ff ff       	call   80243e <syscall>
  802976:	83 c4 18             	add    $0x18,%esp
}
  802979:	c9                   	leave  
  80297a:	c3                   	ret    

0080297b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 2c                	push   $0x2c
  80298d:	e8 ac fa ff ff       	call   80243e <syscall>
  802992:	83 c4 18             	add    $0x18,%esp
  802995:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802998:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80299c:	75 07                	jne    8029a5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	eb 05                	jmp    8029aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029b2:	6a 00                	push   $0x0
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 2c                	push   $0x2c
  8029be:	e8 7b fa ff ff       	call   80243e <syscall>
  8029c3:	83 c4 18             	add    $0x18,%esp
  8029c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029c9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029cd:	75 07                	jne    8029d6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d4:	eb 05                	jmp    8029db <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029db:	c9                   	leave  
  8029dc:	c3                   	ret    

008029dd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
  8029e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 2c                	push   $0x2c
  8029ef:	e8 4a fa ff ff       	call   80243e <syscall>
  8029f4:	83 c4 18             	add    $0x18,%esp
  8029f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029fa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029fe:	75 07                	jne    802a07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a00:	b8 01 00 00 00       	mov    $0x1,%eax
  802a05:	eb 05                	jmp    802a0c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a0c:	c9                   	leave  
  802a0d:	c3                   	ret    

00802a0e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a0e:	55                   	push   %ebp
  802a0f:	89 e5                	mov    %esp,%ebp
  802a11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 2c                	push   $0x2c
  802a20:	e8 19 fa ff ff       	call   80243e <syscall>
  802a25:	83 c4 18             	add    $0x18,%esp
  802a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a2b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a2f:	75 07                	jne    802a38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a31:	b8 01 00 00 00       	mov    $0x1,%eax
  802a36:	eb 05                	jmp    802a3d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	ff 75 08             	pushl  0x8(%ebp)
  802a4d:	6a 2d                	push   $0x2d
  802a4f:	e8 ea f9 ff ff       	call   80243e <syscall>
  802a54:	83 c4 18             	add    $0x18,%esp
	return ;
  802a57:	90                   	nop
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
  802a5d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a5e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	6a 00                	push   $0x0
  802a6c:	53                   	push   %ebx
  802a6d:	51                   	push   %ecx
  802a6e:	52                   	push   %edx
  802a6f:	50                   	push   %eax
  802a70:	6a 2e                	push   $0x2e
  802a72:	e8 c7 f9 ff ff       	call   80243e <syscall>
  802a77:	83 c4 18             	add    $0x18,%esp
}
  802a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	52                   	push   %edx
  802a8f:	50                   	push   %eax
  802a90:	6a 2f                	push   $0x2f
  802a92:	e8 a7 f9 ff ff       	call   80243e <syscall>
  802a97:	83 c4 18             	add    $0x18,%esp
}
  802a9a:	c9                   	leave  
  802a9b:	c3                   	ret    

00802a9c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802a9c:	55                   	push   %ebp
  802a9d:	89 e5                	mov    %esp,%ebp
  802a9f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802aa2:	83 ec 0c             	sub    $0xc,%esp
  802aa5:	68 5c 47 80 00       	push   $0x80475c
  802aaa:	e8 c7 e6 ff ff       	call   801176 <cprintf>
  802aaf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802ab2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802ab9:	83 ec 0c             	sub    $0xc,%esp
  802abc:	68 88 47 80 00       	push   $0x804788
  802ac1:	e8 b0 e6 ff ff       	call   801176 <cprintf>
  802ac6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802ac9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802acd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad5:	eb 56                	jmp    802b2d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adb:	74 1c                	je     802af9 <print_mem_block_lists+0x5d>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 50 08             	mov    0x8(%eax),%edx
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 48 08             	mov    0x8(%eax),%ecx
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	01 c8                	add    %ecx,%eax
  802af1:	39 c2                	cmp    %eax,%edx
  802af3:	73 04                	jae    802af9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802af5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 50 08             	mov    0x8(%eax),%edx
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 0c             	mov    0xc(%eax),%eax
  802b05:	01 c2                	add    %eax,%edx
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 08             	mov    0x8(%eax),%eax
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	52                   	push   %edx
  802b11:	50                   	push   %eax
  802b12:	68 9d 47 80 00       	push   $0x80479d
  802b17:	e8 5a e6 ff ff       	call   801176 <cprintf>
  802b1c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b25:	a1 40 51 80 00       	mov    0x805140,%eax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b31:	74 07                	je     802b3a <print_mem_block_lists+0x9e>
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	eb 05                	jmp    802b3f <print_mem_block_lists+0xa3>
  802b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b44:	a1 40 51 80 00       	mov    0x805140,%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	75 8a                	jne    802ad7 <print_mem_block_lists+0x3b>
  802b4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b51:	75 84                	jne    802ad7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802b53:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b57:	75 10                	jne    802b69 <print_mem_block_lists+0xcd>
  802b59:	83 ec 0c             	sub    $0xc,%esp
  802b5c:	68 ac 47 80 00       	push   $0x8047ac
  802b61:	e8 10 e6 ff ff       	call   801176 <cprintf>
  802b66:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802b69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802b70:	83 ec 0c             	sub    $0xc,%esp
  802b73:	68 d0 47 80 00       	push   $0x8047d0
  802b78:	e8 f9 e5 ff ff       	call   801176 <cprintf>
  802b7d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802b80:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b84:	a1 40 50 80 00       	mov    0x805040,%eax
  802b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8c:	eb 56                	jmp    802be4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b92:	74 1c                	je     802bb0 <print_mem_block_lists+0x114>
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	8b 48 08             	mov    0x8(%eax),%ecx
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba6:	01 c8                	add    %ecx,%eax
  802ba8:	39 c2                	cmp    %eax,%edx
  802baa:	73 04                	jae    802bb0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802bac:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	01 c2                	add    %eax,%edx
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	52                   	push   %edx
  802bc8:	50                   	push   %eax
  802bc9:	68 9d 47 80 00       	push   $0x80479d
  802bce:	e8 a3 e5 ff ff       	call   801176 <cprintf>
  802bd3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802bdc:	a1 48 50 80 00       	mov    0x805048,%eax
  802be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be8:	74 07                	je     802bf1 <print_mem_block_lists+0x155>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 00                	mov    (%eax),%eax
  802bef:	eb 05                	jmp    802bf6 <print_mem_block_lists+0x15a>
  802bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf6:	a3 48 50 80 00       	mov    %eax,0x805048
  802bfb:	a1 48 50 80 00       	mov    0x805048,%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	75 8a                	jne    802b8e <print_mem_block_lists+0xf2>
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	75 84                	jne    802b8e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802c0a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c0e:	75 10                	jne    802c20 <print_mem_block_lists+0x184>
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	68 e8 47 80 00       	push   $0x8047e8
  802c18:	e8 59 e5 ff ff       	call   801176 <cprintf>
  802c1d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802c20:	83 ec 0c             	sub    $0xc,%esp
  802c23:	68 5c 47 80 00       	push   $0x80475c
  802c28:	e8 49 e5 ff ff       	call   801176 <cprintf>
  802c2d:	83 c4 10             	add    $0x10,%esp

}
  802c30:	90                   	nop
  802c31:	c9                   	leave  
  802c32:	c3                   	ret    

00802c33 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802c33:	55                   	push   %ebp
  802c34:	89 e5                	mov    %esp,%ebp
  802c36:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802c39:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802c40:	00 00 00 
  802c43:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802c4a:	00 00 00 
  802c4d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802c54:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802c57:	a1 50 50 80 00       	mov    0x805050,%eax
  802c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c66:	e9 9e 00 00 00       	jmp    802d09 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802c6b:	a1 50 50 80 00       	mov    0x805050,%eax
  802c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c73:	c1 e2 04             	shl    $0x4,%edx
  802c76:	01 d0                	add    %edx,%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	75 14                	jne    802c90 <initialize_MemBlocksList+0x5d>
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	68 10 48 80 00       	push   $0x804810
  802c84:	6a 48                	push   $0x48
  802c86:	68 33 48 80 00       	push   $0x804833
  802c8b:	e8 32 e2 ff ff       	call   800ec2 <_panic>
  802c90:	a1 50 50 80 00       	mov    0x805050,%eax
  802c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c98:	c1 e2 04             	shl    $0x4,%edx
  802c9b:	01 d0                	add    %edx,%eax
  802c9d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ca3:	89 10                	mov    %edx,(%eax)
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 18                	je     802cc3 <initialize_MemBlocksList+0x90>
  802cab:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802cb6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802cb9:	c1 e1 04             	shl    $0x4,%ecx
  802cbc:	01 ca                	add    %ecx,%edx
  802cbe:	89 50 04             	mov    %edx,0x4(%eax)
  802cc1:	eb 12                	jmp    802cd5 <initialize_MemBlocksList+0xa2>
  802cc3:	a1 50 50 80 00       	mov    0x805050,%eax
  802cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccb:	c1 e2 04             	shl    $0x4,%edx
  802cce:	01 d0                	add    %edx,%eax
  802cd0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd5:	a1 50 50 80 00       	mov    0x805050,%eax
  802cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdd:	c1 e2 04             	shl    $0x4,%edx
  802ce0:	01 d0                	add    %edx,%eax
  802ce2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ce7:	a1 50 50 80 00       	mov    0x805050,%eax
  802cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cef:	c1 e2 04             	shl    $0x4,%edx
  802cf2:	01 d0                	add    %edx,%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802d00:	40                   	inc    %eax
  802d01:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802d06:	ff 45 f4             	incl   -0xc(%ebp)
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d0f:	0f 82 56 ff ff ff    	jb     802c6b <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802d15:	90                   	nop
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802d26:	eb 18                	jmp    802d40 <find_block+0x28>
		{
			if(tmp->sva==va)
  802d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d2b:	8b 40 08             	mov    0x8(%eax),%eax
  802d2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d31:	75 05                	jne    802d38 <find_block+0x20>
			{
				return tmp;
  802d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d36:	eb 11                	jmp    802d49 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802d40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d44:	75 e2                	jne    802d28 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802d49:	c9                   	leave  
  802d4a:	c3                   	ret    

00802d4b <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802d51:	a1 40 50 80 00       	mov    0x805040,%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	0f 85 83 00 00 00    	jne    802de1 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802d5e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802d65:	00 00 00 
  802d68:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802d6f:	00 00 00 
  802d72:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802d79:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d80:	75 14                	jne    802d96 <insert_sorted_allocList+0x4b>
  802d82:	83 ec 04             	sub    $0x4,%esp
  802d85:	68 10 48 80 00       	push   $0x804810
  802d8a:	6a 7f                	push   $0x7f
  802d8c:	68 33 48 80 00       	push   $0x804833
  802d91:	e8 2c e1 ff ff       	call   800ec2 <_panic>
  802d96:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	89 10                	mov    %edx,(%eax)
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 0d                	je     802db7 <insert_sorted_allocList+0x6c>
  802daa:	a1 40 50 80 00       	mov    0x805040,%eax
  802daf:	8b 55 08             	mov    0x8(%ebp),%edx
  802db2:	89 50 04             	mov    %edx,0x4(%eax)
  802db5:	eb 08                	jmp    802dbf <insert_sorted_allocList+0x74>
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	a3 44 50 80 00       	mov    %eax,0x805044
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	a3 40 50 80 00       	mov    %eax,0x805040
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dd6:	40                   	inc    %eax
  802dd7:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ddc:	e9 16 01 00 00       	jmp    802ef7 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	8b 50 08             	mov    0x8(%eax),%edx
  802de7:	a1 44 50 80 00       	mov    0x805044,%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	39 c2                	cmp    %eax,%edx
  802df1:	76 68                	jbe    802e5b <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802df3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df7:	75 17                	jne    802e10 <insert_sorted_allocList+0xc5>
  802df9:	83 ec 04             	sub    $0x4,%esp
  802dfc:	68 4c 48 80 00       	push   $0x80484c
  802e01:	68 85 00 00 00       	push   $0x85
  802e06:	68 33 48 80 00       	push   $0x804833
  802e0b:	e8 b2 e0 ff ff       	call   800ec2 <_panic>
  802e10:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	89 50 04             	mov    %edx,0x4(%eax)
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	74 0c                	je     802e32 <insert_sorted_allocList+0xe7>
  802e26:	a1 44 50 80 00       	mov    0x805044,%eax
  802e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 08                	jmp    802e3a <insert_sorted_allocList+0xef>
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	a3 40 50 80 00       	mov    %eax,0x805040
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	a3 44 50 80 00       	mov    %eax,0x805044
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e50:	40                   	inc    %eax
  802e51:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802e56:	e9 9c 00 00 00       	jmp    802ef7 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802e5b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802e63:	e9 85 00 00 00       	jmp    802eed <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 40 08             	mov    0x8(%eax),%eax
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	73 6d                	jae    802ee5 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802e78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7c:	74 06                	je     802e84 <insert_sorted_allocList+0x139>
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	75 17                	jne    802e9b <insert_sorted_allocList+0x150>
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	68 70 48 80 00       	push   $0x804870
  802e8c:	68 90 00 00 00       	push   $0x90
  802e91:	68 33 48 80 00       	push   $0x804833
  802e96:	e8 27 e0 ff ff       	call   800ec2 <_panic>
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 50 04             	mov    0x4(%eax),%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 0d                	je     802ec6 <insert_sorted_allocList+0x17b>
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec2:	89 10                	mov    %edx,(%eax)
  802ec4:	eb 08                	jmp    802ece <insert_sorted_allocList+0x183>
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	a3 40 50 80 00       	mov    %eax,0x805040
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802edc:	40                   	inc    %eax
  802edd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ee2:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ee3:	eb 12                	jmp    802ef7 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 00                	mov    (%eax),%eax
  802eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef1:	0f 85 71 ff ff ff    	jne    802e68 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ef7:	90                   	nop
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
  802efd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802f00:	a1 38 51 80 00       	mov    0x805138,%eax
  802f05:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802f08:	e9 76 01 00 00       	jmp    803083 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f16:	0f 85 8a 00 00 00    	jne    802fa6 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f20:	75 17                	jne    802f39 <alloc_block_FF+0x3f>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 a5 48 80 00       	push   $0x8048a5
  802f2a:	68 a8 00 00 00       	push   $0xa8
  802f2f:	68 33 48 80 00       	push   $0x804833
  802f34:	e8 89 df ff ff       	call   800ec2 <_panic>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 10                	je     802f52 <alloc_block_FF+0x58>
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4a:	8b 52 04             	mov    0x4(%edx),%edx
  802f4d:	89 50 04             	mov    %edx,0x4(%eax)
  802f50:	eb 0b                	jmp    802f5d <alloc_block_FF+0x63>
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 0f                	je     802f76 <alloc_block_FF+0x7c>
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f70:	8b 12                	mov    (%edx),%edx
  802f72:	89 10                	mov    %edx,(%eax)
  802f74:	eb 0a                	jmp    802f80 <alloc_block_FF+0x86>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f93:	a1 44 51 80 00       	mov    0x805144,%eax
  802f98:	48                   	dec    %eax
  802f99:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	e9 ea 00 00 00       	jmp    803090 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802faf:	0f 86 c6 00 00 00    	jbe    80307b <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802fb5:	a1 48 51 80 00       	mov    0x805148,%eax
  802fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc3:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	2b 45 08             	sub    0x8(%ebp),%eax
  802fdb:	89 c2                	mov    %eax,%edx
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 50 08             	mov    0x8(%eax),%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	01 c2                	add    %eax,%edx
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ff4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff8:	75 17                	jne    803011 <alloc_block_FF+0x117>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 a5 48 80 00       	push   $0x8048a5
  803002:	68 b6 00 00 00       	push   $0xb6
  803007:	68 33 48 80 00       	push   $0x804833
  80300c:	e8 b1 de ff ff       	call   800ec2 <_panic>
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 10                	je     80302a <alloc_block_FF+0x130>
  80301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803022:	8b 52 04             	mov    0x4(%edx),%edx
  803025:	89 50 04             	mov    %edx,0x4(%eax)
  803028:	eb 0b                	jmp    803035 <alloc_block_FF+0x13b>
  80302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0f                	je     80304e <alloc_block_FF+0x154>
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803048:	8b 12                	mov    (%edx),%edx
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	eb 0a                	jmp    803058 <alloc_block_FF+0x15e>
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	a3 48 51 80 00       	mov    %eax,0x805148
  803058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 54 51 80 00       	mov    0x805154,%eax
  803070:	48                   	dec    %eax
  803071:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  803076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803079:	eb 15                	jmp    803090 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  803083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803087:	0f 85 80 fe ff ff    	jne    802f0d <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  803098:	a1 38 51 80 00       	mov    0x805138,%eax
  80309d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8030a0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8030a7:	e9 c0 00 00 00       	jmp    80316c <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b5:	0f 85 8a 00 00 00    	jne    803145 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8030bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bf:	75 17                	jne    8030d8 <alloc_block_BF+0x46>
  8030c1:	83 ec 04             	sub    $0x4,%esp
  8030c4:	68 a5 48 80 00       	push   $0x8048a5
  8030c9:	68 cf 00 00 00       	push   $0xcf
  8030ce:	68 33 48 80 00       	push   $0x804833
  8030d3:	e8 ea dd ff ff       	call   800ec2 <_panic>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 10                	je     8030f1 <alloc_block_BF+0x5f>
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e9:	8b 52 04             	mov    0x4(%edx),%edx
  8030ec:	89 50 04             	mov    %edx,0x4(%eax)
  8030ef:	eb 0b                	jmp    8030fc <alloc_block_BF+0x6a>
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 40 04             	mov    0x4(%eax),%eax
  8030f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	74 0f                	je     803115 <alloc_block_BF+0x83>
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310f:	8b 12                	mov    (%edx),%edx
  803111:	89 10                	mov    %edx,(%eax)
  803113:	eb 0a                	jmp    80311f <alloc_block_BF+0x8d>
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	a3 38 51 80 00       	mov    %eax,0x805138
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803132:	a1 44 51 80 00       	mov    0x805144,%eax
  803137:	48                   	dec    %eax
  803138:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	e9 2a 01 00 00       	jmp    80326f <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 40 0c             	mov    0xc(%eax),%eax
  80314b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80314e:	73 14                	jae    803164 <alloc_block_BF+0xd2>
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 40 0c             	mov    0xc(%eax),%eax
  803156:	3b 45 08             	cmp    0x8(%ebp),%eax
  803159:	76 09                	jbe    803164 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 40 0c             	mov    0xc(%eax),%eax
  803161:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80316c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803170:	0f 85 36 ff ff ff    	jne    8030ac <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  803176:	a1 38 51 80 00       	mov    0x805138,%eax
  80317b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80317e:	e9 dd 00 00 00       	jmp    803260 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80318c:	0f 85 c6 00 00 00    	jne    803258 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803192:	a1 48 51 80 00       	mov    0x805148,%eax
  803197:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 50 08             	mov    0x8(%eax),%edx
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8031a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ac:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 50 08             	mov    0x8(%eax),%edx
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	01 c2                	add    %eax,%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8031c9:	89 c2                	mov    %eax,%edx
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8031d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d5:	75 17                	jne    8031ee <alloc_block_BF+0x15c>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 a5 48 80 00       	push   $0x8048a5
  8031df:	68 eb 00 00 00       	push   $0xeb
  8031e4:	68 33 48 80 00       	push   $0x804833
  8031e9:	e8 d4 dc ff ff       	call   800ec2 <_panic>
  8031ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	74 10                	je     803207 <alloc_block_BF+0x175>
  8031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031ff:	8b 52 04             	mov    0x4(%edx),%edx
  803202:	89 50 04             	mov    %edx,0x4(%eax)
  803205:	eb 0b                	jmp    803212 <alloc_block_BF+0x180>
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	8b 40 04             	mov    0x4(%eax),%eax
  80320d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	85 c0                	test   %eax,%eax
  80321a:	74 0f                	je     80322b <alloc_block_BF+0x199>
  80321c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321f:	8b 40 04             	mov    0x4(%eax),%eax
  803222:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803225:	8b 12                	mov    (%edx),%edx
  803227:	89 10                	mov    %edx,(%eax)
  803229:	eb 0a                	jmp    803235 <alloc_block_BF+0x1a3>
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	a3 48 51 80 00       	mov    %eax,0x805148
  803235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803248:	a1 54 51 80 00       	mov    0x805154,%eax
  80324d:	48                   	dec    %eax
  80324e:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  803253:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803256:	eb 17                	jmp    80326f <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803264:	0f 85 19 ff ff ff    	jne    803183 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80326a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80326f:	c9                   	leave  
  803270:	c3                   	ret    

00803271 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  803271:	55                   	push   %ebp
  803272:	89 e5                	mov    %esp,%ebp
  803274:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  803277:	a1 40 50 80 00       	mov    0x805040,%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	75 19                	jne    803299 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803280:	83 ec 0c             	sub    $0xc,%esp
  803283:	ff 75 08             	pushl  0x8(%ebp)
  803286:	e8 6f fc ff ff       	call   802efa <alloc_block_FF>
  80328b:	83 c4 10             	add    $0x10,%esp
  80328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	e9 e9 01 00 00       	jmp    803482 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  803299:	a1 44 50 80 00       	mov    0x805044,%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8032a4:	a1 44 50 80 00       	mov    0x805044,%eax
  8032a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ac:	a1 44 50 80 00       	mov    0x805044,%eax
  8032b1:	8b 40 08             	mov    0x8(%eax),%eax
  8032b4:	01 d0                	add    %edx,%eax
  8032b6:	83 ec 08             	sub    $0x8,%esp
  8032b9:	50                   	push   %eax
  8032ba:	68 38 51 80 00       	push   $0x805138
  8032bf:	e8 54 fa ff ff       	call   802d18 <find_block>
  8032c4:	83 c4 10             	add    $0x10,%esp
  8032c7:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d3:	0f 85 9b 00 00 00    	jne    803374 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8032df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e2:	8b 40 08             	mov    0x8(%eax),%eax
  8032e5:	01 d0                	add    %edx,%eax
  8032e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8032ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ee:	75 17                	jne    803307 <alloc_block_NF+0x96>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 a5 48 80 00       	push   $0x8048a5
  8032f8:	68 1a 01 00 00       	push   $0x11a
  8032fd:	68 33 48 80 00       	push   $0x804833
  803302:	e8 bb db ff ff       	call   800ec2 <_panic>
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 10                	je     803320 <alloc_block_NF+0xaf>
  803310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803318:	8b 52 04             	mov    0x4(%edx),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	eb 0b                	jmp    80332b <alloc_block_NF+0xba>
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	8b 40 04             	mov    0x4(%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 0f                	je     803344 <alloc_block_NF+0xd3>
  803335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803338:	8b 40 04             	mov    0x4(%eax),%eax
  80333b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333e:	8b 12                	mov    (%edx),%edx
  803340:	89 10                	mov    %edx,(%eax)
  803342:	eb 0a                	jmp    80334e <alloc_block_NF+0xdd>
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	a3 38 51 80 00       	mov    %eax,0x805138
  80334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803351:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803361:	a1 44 51 80 00       	mov    0x805144,%eax
  803366:	48                   	dec    %eax
  803367:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	e9 0e 01 00 00       	jmp    803482 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	8b 40 0c             	mov    0xc(%eax),%eax
  80337a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337d:	0f 86 cf 00 00 00    	jbe    803452 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803383:	a1 48 51 80 00       	mov    0x805148,%eax
  803388:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80338b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338e:	8b 55 08             	mov    0x8(%ebp),%edx
  803391:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 50 08             	mov    0x8(%eax),%edx
  80339a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339d:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 50 08             	mov    0x8(%eax),%edx
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	01 c2                	add    %eax,%edx
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8033ba:	89 c2                	mov    %eax,%edx
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 40 08             	mov    0x8(%eax),%eax
  8033c8:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8033cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033cf:	75 17                	jne    8033e8 <alloc_block_NF+0x177>
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	68 a5 48 80 00       	push   $0x8048a5
  8033d9:	68 28 01 00 00       	push   $0x128
  8033de:	68 33 48 80 00       	push   $0x804833
  8033e3:	e8 da da ff ff       	call   800ec2 <_panic>
  8033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	74 10                	je     803401 <alloc_block_NF+0x190>
  8033f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033f9:	8b 52 04             	mov    0x4(%edx),%edx
  8033fc:	89 50 04             	mov    %edx,0x4(%eax)
  8033ff:	eb 0b                	jmp    80340c <alloc_block_NF+0x19b>
  803401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803404:	8b 40 04             	mov    0x4(%eax),%eax
  803407:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340f:	8b 40 04             	mov    0x4(%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	74 0f                	je     803425 <alloc_block_NF+0x1b4>
  803416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803419:	8b 40 04             	mov    0x4(%eax),%eax
  80341c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80341f:	8b 12                	mov    (%edx),%edx
  803421:	89 10                	mov    %edx,(%eax)
  803423:	eb 0a                	jmp    80342f <alloc_block_NF+0x1be>
  803425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	a3 48 51 80 00       	mov    %eax,0x805148
  80342f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803442:	a1 54 51 80 00       	mov    0x805154,%eax
  803447:	48                   	dec    %eax
  803448:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  80344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803450:	eb 30                	jmp    803482 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803452:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803457:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80345a:	75 0a                	jne    803466 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80345c:	a1 38 51 80 00       	mov    0x805138,%eax
  803461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803464:	eb 08                	jmp    80346e <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 40 08             	mov    0x8(%eax),%eax
  803474:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803477:	0f 85 4d fe ff ff    	jne    8032ca <alloc_block_NF+0x59>

			return NULL;
  80347d:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803482:	c9                   	leave  
  803483:	c3                   	ret    

00803484 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803484:	55                   	push   %ebp
  803485:	89 e5                	mov    %esp,%ebp
  803487:	53                   	push   %ebx
  803488:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80348b:	a1 38 51 80 00       	mov    0x805138,%eax
  803490:	85 c0                	test   %eax,%eax
  803492:	0f 85 86 00 00 00    	jne    80351e <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  803498:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80349f:	00 00 00 
  8034a2:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8034a9:	00 00 00 
  8034ac:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8034b3:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8034b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ba:	75 17                	jne    8034d3 <insert_sorted_with_merge_freeList+0x4f>
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	68 10 48 80 00       	push   $0x804810
  8034c4:	68 48 01 00 00       	push   $0x148
  8034c9:	68 33 48 80 00       	push   $0x804833
  8034ce:	e8 ef d9 ff ff       	call   800ec2 <_panic>
  8034d3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 00                	mov    (%eax),%eax
  8034e3:	85 c0                	test   %eax,%eax
  8034e5:	74 0d                	je     8034f4 <insert_sorted_with_merge_freeList+0x70>
  8034e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8034ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ef:	89 50 04             	mov    %edx,0x4(%eax)
  8034f2:	eb 08                	jmp    8034fc <insert_sorted_with_merge_freeList+0x78>
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350e:	a1 44 51 80 00       	mov    0x805144,%eax
  803513:	40                   	inc    %eax
  803514:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803519:	e9 73 07 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	8b 50 08             	mov    0x8(%eax),%edx
  803524:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803529:	8b 40 08             	mov    0x8(%eax),%eax
  80352c:	39 c2                	cmp    %eax,%edx
  80352e:	0f 86 84 00 00 00    	jbe    8035b8 <insert_sorted_with_merge_freeList+0x134>
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 50 08             	mov    0x8(%eax),%edx
  80353a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80353f:	8b 48 0c             	mov    0xc(%eax),%ecx
  803542:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803547:	8b 40 08             	mov    0x8(%eax),%eax
  80354a:	01 c8                	add    %ecx,%eax
  80354c:	39 c2                	cmp    %eax,%edx
  80354e:	74 68                	je     8035b8 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803550:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803554:	75 17                	jne    80356d <insert_sorted_with_merge_freeList+0xe9>
  803556:	83 ec 04             	sub    $0x4,%esp
  803559:	68 4c 48 80 00       	push   $0x80484c
  80355e:	68 4c 01 00 00       	push   $0x14c
  803563:	68 33 48 80 00       	push   $0x804833
  803568:	e8 55 d9 ff ff       	call   800ec2 <_panic>
  80356d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	89 50 04             	mov    %edx,0x4(%eax)
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	8b 40 04             	mov    0x4(%eax),%eax
  80357f:	85 c0                	test   %eax,%eax
  803581:	74 0c                	je     80358f <insert_sorted_with_merge_freeList+0x10b>
  803583:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803588:	8b 55 08             	mov    0x8(%ebp),%edx
  80358b:	89 10                	mov    %edx,(%eax)
  80358d:	eb 08                	jmp    803597 <insert_sorted_with_merge_freeList+0x113>
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	a3 38 51 80 00       	mov    %eax,0x805138
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ad:	40                   	inc    %eax
  8035ae:	a3 44 51 80 00       	mov    %eax,0x805144
  8035b3:	e9 d9 06 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	8b 50 08             	mov    0x8(%eax),%edx
  8035be:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035c3:	8b 40 08             	mov    0x8(%eax),%eax
  8035c6:	39 c2                	cmp    %eax,%edx
  8035c8:	0f 86 b5 00 00 00    	jbe    803683 <insert_sorted_with_merge_freeList+0x1ff>
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	8b 50 08             	mov    0x8(%eax),%edx
  8035d4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035d9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8035dc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035e1:	8b 40 08             	mov    0x8(%eax),%eax
  8035e4:	01 c8                	add    %ecx,%eax
  8035e6:	39 c2                	cmp    %eax,%edx
  8035e8:	0f 85 95 00 00 00    	jne    803683 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8035ee:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035f3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035f9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8035fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ff:	8b 52 0c             	mov    0xc(%edx),%edx
  803602:	01 ca                	add    %ecx,%edx
  803604:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80361b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361f:	75 17                	jne    803638 <insert_sorted_with_merge_freeList+0x1b4>
  803621:	83 ec 04             	sub    $0x4,%esp
  803624:	68 10 48 80 00       	push   $0x804810
  803629:	68 54 01 00 00       	push   $0x154
  80362e:	68 33 48 80 00       	push   $0x804833
  803633:	e8 8a d8 ff ff       	call   800ec2 <_panic>
  803638:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	89 10                	mov    %edx,(%eax)
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	74 0d                	je     803659 <insert_sorted_with_merge_freeList+0x1d5>
  80364c:	a1 48 51 80 00       	mov    0x805148,%eax
  803651:	8b 55 08             	mov    0x8(%ebp),%edx
  803654:	89 50 04             	mov    %edx,0x4(%eax)
  803657:	eb 08                	jmp    803661 <insert_sorted_with_merge_freeList+0x1dd>
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	a3 48 51 80 00       	mov    %eax,0x805148
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803673:	a1 54 51 80 00       	mov    0x805154,%eax
  803678:	40                   	inc    %eax
  803679:	a3 54 51 80 00       	mov    %eax,0x805154
  80367e:	e9 0e 06 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	8b 50 08             	mov    0x8(%eax),%edx
  803689:	a1 38 51 80 00       	mov    0x805138,%eax
  80368e:	8b 40 08             	mov    0x8(%eax),%eax
  803691:	39 c2                	cmp    %eax,%edx
  803693:	0f 83 c1 00 00 00    	jae    80375a <insert_sorted_with_merge_freeList+0x2d6>
  803699:	a1 38 51 80 00       	mov    0x805138,%eax
  80369e:	8b 50 08             	mov    0x8(%eax),%edx
  8036a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a4:	8b 48 08             	mov    0x8(%eax),%ecx
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ad:	01 c8                	add    %ecx,%eax
  8036af:	39 c2                	cmp    %eax,%edx
  8036b1:	0f 85 a3 00 00 00    	jne    80375a <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8036b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8036bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036bf:	8b 52 08             	mov    0x8(%edx),%edx
  8036c2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8036c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ca:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036d0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8036d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d6:	8b 52 0c             	mov    0xc(%edx),%edx
  8036d9:	01 ca                	add    %ecx,%edx
  8036db:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f6:	75 17                	jne    80370f <insert_sorted_with_merge_freeList+0x28b>
  8036f8:	83 ec 04             	sub    $0x4,%esp
  8036fb:	68 10 48 80 00       	push   $0x804810
  803700:	68 5d 01 00 00       	push   $0x15d
  803705:	68 33 48 80 00       	push   $0x804833
  80370a:	e8 b3 d7 ff ff       	call   800ec2 <_panic>
  80370f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	89 10                	mov    %edx,(%eax)
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	74 0d                	je     803730 <insert_sorted_with_merge_freeList+0x2ac>
  803723:	a1 48 51 80 00       	mov    0x805148,%eax
  803728:	8b 55 08             	mov    0x8(%ebp),%edx
  80372b:	89 50 04             	mov    %edx,0x4(%eax)
  80372e:	eb 08                	jmp    803738 <insert_sorted_with_merge_freeList+0x2b4>
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803738:	8b 45 08             	mov    0x8(%ebp),%eax
  80373b:	a3 48 51 80 00       	mov    %eax,0x805148
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374a:	a1 54 51 80 00       	mov    0x805154,%eax
  80374f:	40                   	inc    %eax
  803750:	a3 54 51 80 00       	mov    %eax,0x805154
  803755:	e9 37 05 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	8b 50 08             	mov    0x8(%eax),%edx
  803760:	a1 38 51 80 00       	mov    0x805138,%eax
  803765:	8b 40 08             	mov    0x8(%eax),%eax
  803768:	39 c2                	cmp    %eax,%edx
  80376a:	0f 83 82 00 00 00    	jae    8037f2 <insert_sorted_with_merge_freeList+0x36e>
  803770:	a1 38 51 80 00       	mov    0x805138,%eax
  803775:	8b 50 08             	mov    0x8(%eax),%edx
  803778:	8b 45 08             	mov    0x8(%ebp),%eax
  80377b:	8b 48 08             	mov    0x8(%eax),%ecx
  80377e:	8b 45 08             	mov    0x8(%ebp),%eax
  803781:	8b 40 0c             	mov    0xc(%eax),%eax
  803784:	01 c8                	add    %ecx,%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	74 68                	je     8037f2 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80378a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378e:	75 17                	jne    8037a7 <insert_sorted_with_merge_freeList+0x323>
  803790:	83 ec 04             	sub    $0x4,%esp
  803793:	68 10 48 80 00       	push   $0x804810
  803798:	68 62 01 00 00       	push   $0x162
  80379d:	68 33 48 80 00       	push   $0x804833
  8037a2:	e8 1b d7 ff ff       	call   800ec2 <_panic>
  8037a7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	89 10                	mov    %edx,(%eax)
  8037b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	74 0d                	je     8037c8 <insert_sorted_with_merge_freeList+0x344>
  8037bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8037c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c3:	89 50 04             	mov    %edx,0x4(%eax)
  8037c6:	eb 08                	jmp    8037d0 <insert_sorted_with_merge_freeList+0x34c>
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e7:	40                   	inc    %eax
  8037e8:	a3 44 51 80 00       	mov    %eax,0x805144
  8037ed:	e9 9f 04 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8037f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8037fc:	e9 84 04 00 00       	jmp    803c85 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803804:	8b 50 08             	mov    0x8(%eax),%edx
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	8b 40 08             	mov    0x8(%eax),%eax
  80380d:	39 c2                	cmp    %eax,%edx
  80380f:	0f 86 a9 00 00 00    	jbe    8038be <insert_sorted_with_merge_freeList+0x43a>
  803815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803818:	8b 50 08             	mov    0x8(%eax),%edx
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	8b 48 08             	mov    0x8(%eax),%ecx
  803821:	8b 45 08             	mov    0x8(%ebp),%eax
  803824:	8b 40 0c             	mov    0xc(%eax),%eax
  803827:	01 c8                	add    %ecx,%eax
  803829:	39 c2                	cmp    %eax,%edx
  80382b:	0f 84 8d 00 00 00    	je     8038be <insert_sorted_with_merge_freeList+0x43a>
  803831:	8b 45 08             	mov    0x8(%ebp),%eax
  803834:	8b 50 08             	mov    0x8(%eax),%edx
  803837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383a:	8b 40 04             	mov    0x4(%eax),%eax
  80383d:	8b 48 08             	mov    0x8(%eax),%ecx
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 40 04             	mov    0x4(%eax),%eax
  803846:	8b 40 0c             	mov    0xc(%eax),%eax
  803849:	01 c8                	add    %ecx,%eax
  80384b:	39 c2                	cmp    %eax,%edx
  80384d:	74 6f                	je     8038be <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  80384f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803853:	74 06                	je     80385b <insert_sorted_with_merge_freeList+0x3d7>
  803855:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803859:	75 17                	jne    803872 <insert_sorted_with_merge_freeList+0x3ee>
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	68 70 48 80 00       	push   $0x804870
  803863:	68 6b 01 00 00       	push   $0x16b
  803868:	68 33 48 80 00       	push   $0x804833
  80386d:	e8 50 d6 ff ff       	call   800ec2 <_panic>
  803872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803875:	8b 50 04             	mov    0x4(%eax),%edx
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	89 50 04             	mov    %edx,0x4(%eax)
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803884:	89 10                	mov    %edx,(%eax)
  803886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803889:	8b 40 04             	mov    0x4(%eax),%eax
  80388c:	85 c0                	test   %eax,%eax
  80388e:	74 0d                	je     80389d <insert_sorted_with_merge_freeList+0x419>
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	8b 40 04             	mov    0x4(%eax),%eax
  803896:	8b 55 08             	mov    0x8(%ebp),%edx
  803899:	89 10                	mov    %edx,(%eax)
  80389b:	eb 08                	jmp    8038a5 <insert_sorted_with_merge_freeList+0x421>
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8038a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ab:	89 50 04             	mov    %edx,0x4(%eax)
  8038ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b3:	40                   	inc    %eax
  8038b4:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8038b9:	e9 d3 03 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c1:	8b 50 08             	mov    0x8(%eax),%edx
  8038c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c7:	8b 40 08             	mov    0x8(%eax),%eax
  8038ca:	39 c2                	cmp    %eax,%edx
  8038cc:	0f 86 da 00 00 00    	jbe    8039ac <insert_sorted_with_merge_freeList+0x528>
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	8b 50 08             	mov    0x8(%eax),%edx
  8038d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038db:	8b 48 08             	mov    0x8(%eax),%ecx
  8038de:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e4:	01 c8                	add    %ecx,%eax
  8038e6:	39 c2                	cmp    %eax,%edx
  8038e8:	0f 85 be 00 00 00    	jne    8039ac <insert_sorted_with_merge_freeList+0x528>
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	8b 50 08             	mov    0x8(%eax),%edx
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 40 04             	mov    0x4(%eax),%eax
  8038fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 40 04             	mov    0x4(%eax),%eax
  803903:	8b 40 0c             	mov    0xc(%eax),%eax
  803906:	01 c8                	add    %ecx,%eax
  803908:	39 c2                	cmp    %eax,%edx
  80390a:	0f 84 9c 00 00 00    	je     8039ac <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	8b 50 08             	mov    0x8(%eax),%edx
  803916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803919:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391f:	8b 50 0c             	mov    0xc(%eax),%edx
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	8b 40 0c             	mov    0xc(%eax),%eax
  803928:	01 c2                	add    %eax,%edx
  80392a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392d:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803930:	8b 45 08             	mov    0x8(%ebp),%eax
  803933:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
  80393d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803944:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803948:	75 17                	jne    803961 <insert_sorted_with_merge_freeList+0x4dd>
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 10 48 80 00       	push   $0x804810
  803952:	68 74 01 00 00       	push   $0x174
  803957:	68 33 48 80 00       	push   $0x804833
  80395c:	e8 61 d5 ff ff       	call   800ec2 <_panic>
  803961:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	89 10                	mov    %edx,(%eax)
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	8b 00                	mov    (%eax),%eax
  803971:	85 c0                	test   %eax,%eax
  803973:	74 0d                	je     803982 <insert_sorted_with_merge_freeList+0x4fe>
  803975:	a1 48 51 80 00       	mov    0x805148,%eax
  80397a:	8b 55 08             	mov    0x8(%ebp),%edx
  80397d:	89 50 04             	mov    %edx,0x4(%eax)
  803980:	eb 08                	jmp    80398a <insert_sorted_with_merge_freeList+0x506>
  803982:	8b 45 08             	mov    0x8(%ebp),%eax
  803985:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80398a:	8b 45 08             	mov    0x8(%ebp),%eax
  80398d:	a3 48 51 80 00       	mov    %eax,0x805148
  803992:	8b 45 08             	mov    0x8(%ebp),%eax
  803995:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399c:	a1 54 51 80 00       	mov    0x805154,%eax
  8039a1:	40                   	inc    %eax
  8039a2:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8039a7:	e9 e5 02 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	8b 50 08             	mov    0x8(%eax),%edx
  8039b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b5:	8b 40 08             	mov    0x8(%eax),%eax
  8039b8:	39 c2                	cmp    %eax,%edx
  8039ba:	0f 86 d7 00 00 00    	jbe    803a97 <insert_sorted_with_merge_freeList+0x613>
  8039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c3:	8b 50 08             	mov    0x8(%eax),%edx
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	8b 48 08             	mov    0x8(%eax),%ecx
  8039cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d2:	01 c8                	add    %ecx,%eax
  8039d4:	39 c2                	cmp    %eax,%edx
  8039d6:	0f 84 bb 00 00 00    	je     803a97 <insert_sorted_with_merge_freeList+0x613>
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	8b 50 08             	mov    0x8(%eax),%edx
  8039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e5:	8b 40 04             	mov    0x4(%eax),%eax
  8039e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	8b 40 04             	mov    0x4(%eax),%eax
  8039f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039f4:	01 c8                	add    %ecx,%eax
  8039f6:	39 c2                	cmp    %eax,%edx
  8039f8:	0f 85 99 00 00 00    	jne    803a97 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8039fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a01:	8b 40 04             	mov    0x4(%eax),%eax
  803a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0a:	8b 50 0c             	mov    0xc(%eax),%edx
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	8b 40 0c             	mov    0xc(%eax),%eax
  803a13:	01 c2                	add    %eax,%edx
  803a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a18:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803a25:	8b 45 08             	mov    0x8(%ebp),%eax
  803a28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a33:	75 17                	jne    803a4c <insert_sorted_with_merge_freeList+0x5c8>
  803a35:	83 ec 04             	sub    $0x4,%esp
  803a38:	68 10 48 80 00       	push   $0x804810
  803a3d:	68 7d 01 00 00       	push   $0x17d
  803a42:	68 33 48 80 00       	push   $0x804833
  803a47:	e8 76 d4 ff ff       	call   800ec2 <_panic>
  803a4c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a52:	8b 45 08             	mov    0x8(%ebp),%eax
  803a55:	89 10                	mov    %edx,(%eax)
  803a57:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5a:	8b 00                	mov    (%eax),%eax
  803a5c:	85 c0                	test   %eax,%eax
  803a5e:	74 0d                	je     803a6d <insert_sorted_with_merge_freeList+0x5e9>
  803a60:	a1 48 51 80 00       	mov    0x805148,%eax
  803a65:	8b 55 08             	mov    0x8(%ebp),%edx
  803a68:	89 50 04             	mov    %edx,0x4(%eax)
  803a6b:	eb 08                	jmp    803a75 <insert_sorted_with_merge_freeList+0x5f1>
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a75:	8b 45 08             	mov    0x8(%ebp),%eax
  803a78:	a3 48 51 80 00       	mov    %eax,0x805148
  803a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a87:	a1 54 51 80 00       	mov    0x805154,%eax
  803a8c:	40                   	inc    %eax
  803a8d:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803a92:	e9 fa 01 00 00       	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9a:	8b 50 08             	mov    0x8(%eax),%edx
  803a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa0:	8b 40 08             	mov    0x8(%eax),%eax
  803aa3:	39 c2                	cmp    %eax,%edx
  803aa5:	0f 86 d2 01 00 00    	jbe    803c7d <insert_sorted_with_merge_freeList+0x7f9>
  803aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aae:	8b 50 08             	mov    0x8(%eax),%edx
  803ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab4:	8b 48 08             	mov    0x8(%eax),%ecx
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	8b 40 0c             	mov    0xc(%eax),%eax
  803abd:	01 c8                	add    %ecx,%eax
  803abf:	39 c2                	cmp    %eax,%edx
  803ac1:	0f 85 b6 01 00 00    	jne    803c7d <insert_sorted_with_merge_freeList+0x7f9>
  803ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aca:	8b 50 08             	mov    0x8(%eax),%edx
  803acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad0:	8b 40 04             	mov    0x4(%eax),%eax
  803ad3:	8b 48 08             	mov    0x8(%eax),%ecx
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	8b 40 04             	mov    0x4(%eax),%eax
  803adc:	8b 40 0c             	mov    0xc(%eax),%eax
  803adf:	01 c8                	add    %ecx,%eax
  803ae1:	39 c2                	cmp    %eax,%edx
  803ae3:	0f 85 94 01 00 00    	jne    803c7d <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	8b 40 04             	mov    0x4(%eax),%eax
  803aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af2:	8b 52 04             	mov    0x4(%edx),%edx
  803af5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803af8:	8b 55 08             	mov    0x8(%ebp),%edx
  803afb:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b01:	8b 52 0c             	mov    0xc(%edx),%edx
  803b04:	01 da                	add    %ebx,%edx
  803b06:	01 ca                	add    %ecx,%edx
  803b08:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b23:	75 17                	jne    803b3c <insert_sorted_with_merge_freeList+0x6b8>
  803b25:	83 ec 04             	sub    $0x4,%esp
  803b28:	68 a5 48 80 00       	push   $0x8048a5
  803b2d:	68 86 01 00 00       	push   $0x186
  803b32:	68 33 48 80 00       	push   $0x804833
  803b37:	e8 86 d3 ff ff       	call   800ec2 <_panic>
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	8b 00                	mov    (%eax),%eax
  803b41:	85 c0                	test   %eax,%eax
  803b43:	74 10                	je     803b55 <insert_sorted_with_merge_freeList+0x6d1>
  803b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b48:	8b 00                	mov    (%eax),%eax
  803b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b4d:	8b 52 04             	mov    0x4(%edx),%edx
  803b50:	89 50 04             	mov    %edx,0x4(%eax)
  803b53:	eb 0b                	jmp    803b60 <insert_sorted_with_merge_freeList+0x6dc>
  803b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b58:	8b 40 04             	mov    0x4(%eax),%eax
  803b5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b63:	8b 40 04             	mov    0x4(%eax),%eax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	74 0f                	je     803b79 <insert_sorted_with_merge_freeList+0x6f5>
  803b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6d:	8b 40 04             	mov    0x4(%eax),%eax
  803b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b73:	8b 12                	mov    (%edx),%edx
  803b75:	89 10                	mov    %edx,(%eax)
  803b77:	eb 0a                	jmp    803b83 <insert_sorted_with_merge_freeList+0x6ff>
  803b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7c:	8b 00                	mov    (%eax),%eax
  803b7e:	a3 38 51 80 00       	mov    %eax,0x805138
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b96:	a1 44 51 80 00       	mov    0x805144,%eax
  803b9b:	48                   	dec    %eax
  803b9c:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba5:	75 17                	jne    803bbe <insert_sorted_with_merge_freeList+0x73a>
  803ba7:	83 ec 04             	sub    $0x4,%esp
  803baa:	68 10 48 80 00       	push   $0x804810
  803baf:	68 87 01 00 00       	push   $0x187
  803bb4:	68 33 48 80 00       	push   $0x804833
  803bb9:	e8 04 d3 ff ff       	call   800ec2 <_panic>
  803bbe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc7:	89 10                	mov    %edx,(%eax)
  803bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcc:	8b 00                	mov    (%eax),%eax
  803bce:	85 c0                	test   %eax,%eax
  803bd0:	74 0d                	je     803bdf <insert_sorted_with_merge_freeList+0x75b>
  803bd2:	a1 48 51 80 00       	mov    0x805148,%eax
  803bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bda:	89 50 04             	mov    %edx,0x4(%eax)
  803bdd:	eb 08                	jmp    803be7 <insert_sorted_with_merge_freeList+0x763>
  803bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bea:	a3 48 51 80 00       	mov    %eax,0x805148
  803bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf9:	a1 54 51 80 00       	mov    0x805154,%eax
  803bfe:	40                   	inc    %eax
  803bff:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803c04:	8b 45 08             	mov    0x8(%ebp),%eax
  803c07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803c18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c1c:	75 17                	jne    803c35 <insert_sorted_with_merge_freeList+0x7b1>
  803c1e:	83 ec 04             	sub    $0x4,%esp
  803c21:	68 10 48 80 00       	push   $0x804810
  803c26:	68 8a 01 00 00       	push   $0x18a
  803c2b:	68 33 48 80 00       	push   $0x804833
  803c30:	e8 8d d2 ff ff       	call   800ec2 <_panic>
  803c35:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	89 10                	mov    %edx,(%eax)
  803c40:	8b 45 08             	mov    0x8(%ebp),%eax
  803c43:	8b 00                	mov    (%eax),%eax
  803c45:	85 c0                	test   %eax,%eax
  803c47:	74 0d                	je     803c56 <insert_sorted_with_merge_freeList+0x7d2>
  803c49:	a1 48 51 80 00       	mov    0x805148,%eax
  803c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  803c51:	89 50 04             	mov    %edx,0x4(%eax)
  803c54:	eb 08                	jmp    803c5e <insert_sorted_with_merge_freeList+0x7da>
  803c56:	8b 45 08             	mov    0x8(%ebp),%eax
  803c59:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	a3 48 51 80 00       	mov    %eax,0x805148
  803c66:	8b 45 08             	mov    0x8(%ebp),%eax
  803c69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c70:	a1 54 51 80 00       	mov    0x805154,%eax
  803c75:	40                   	inc    %eax
  803c76:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803c7b:	eb 14                	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c80:	8b 00                	mov    (%eax),%eax
  803c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c89:	0f 85 72 fb ff ff    	jne    803801 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803c8f:	eb 00                	jmp    803c91 <insert_sorted_with_merge_freeList+0x80d>
  803c91:	90                   	nop
  803c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803c95:	c9                   	leave  
  803c96:	c3                   	ret    
  803c97:	90                   	nop

00803c98 <__udivdi3>:
  803c98:	55                   	push   %ebp
  803c99:	57                   	push   %edi
  803c9a:	56                   	push   %esi
  803c9b:	53                   	push   %ebx
  803c9c:	83 ec 1c             	sub    $0x1c,%esp
  803c9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ca3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803caf:	89 ca                	mov    %ecx,%edx
  803cb1:	89 f8                	mov    %edi,%eax
  803cb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cb7:	85 f6                	test   %esi,%esi
  803cb9:	75 2d                	jne    803ce8 <__udivdi3+0x50>
  803cbb:	39 cf                	cmp    %ecx,%edi
  803cbd:	77 65                	ja     803d24 <__udivdi3+0x8c>
  803cbf:	89 fd                	mov    %edi,%ebp
  803cc1:	85 ff                	test   %edi,%edi
  803cc3:	75 0b                	jne    803cd0 <__udivdi3+0x38>
  803cc5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cca:	31 d2                	xor    %edx,%edx
  803ccc:	f7 f7                	div    %edi
  803cce:	89 c5                	mov    %eax,%ebp
  803cd0:	31 d2                	xor    %edx,%edx
  803cd2:	89 c8                	mov    %ecx,%eax
  803cd4:	f7 f5                	div    %ebp
  803cd6:	89 c1                	mov    %eax,%ecx
  803cd8:	89 d8                	mov    %ebx,%eax
  803cda:	f7 f5                	div    %ebp
  803cdc:	89 cf                	mov    %ecx,%edi
  803cde:	89 fa                	mov    %edi,%edx
  803ce0:	83 c4 1c             	add    $0x1c,%esp
  803ce3:	5b                   	pop    %ebx
  803ce4:	5e                   	pop    %esi
  803ce5:	5f                   	pop    %edi
  803ce6:	5d                   	pop    %ebp
  803ce7:	c3                   	ret    
  803ce8:	39 ce                	cmp    %ecx,%esi
  803cea:	77 28                	ja     803d14 <__udivdi3+0x7c>
  803cec:	0f bd fe             	bsr    %esi,%edi
  803cef:	83 f7 1f             	xor    $0x1f,%edi
  803cf2:	75 40                	jne    803d34 <__udivdi3+0x9c>
  803cf4:	39 ce                	cmp    %ecx,%esi
  803cf6:	72 0a                	jb     803d02 <__udivdi3+0x6a>
  803cf8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cfc:	0f 87 9e 00 00 00    	ja     803da0 <__udivdi3+0x108>
  803d02:	b8 01 00 00 00       	mov    $0x1,%eax
  803d07:	89 fa                	mov    %edi,%edx
  803d09:	83 c4 1c             	add    $0x1c,%esp
  803d0c:	5b                   	pop    %ebx
  803d0d:	5e                   	pop    %esi
  803d0e:	5f                   	pop    %edi
  803d0f:	5d                   	pop    %ebp
  803d10:	c3                   	ret    
  803d11:	8d 76 00             	lea    0x0(%esi),%esi
  803d14:	31 ff                	xor    %edi,%edi
  803d16:	31 c0                	xor    %eax,%eax
  803d18:	89 fa                	mov    %edi,%edx
  803d1a:	83 c4 1c             	add    $0x1c,%esp
  803d1d:	5b                   	pop    %ebx
  803d1e:	5e                   	pop    %esi
  803d1f:	5f                   	pop    %edi
  803d20:	5d                   	pop    %ebp
  803d21:	c3                   	ret    
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	89 d8                	mov    %ebx,%eax
  803d26:	f7 f7                	div    %edi
  803d28:	31 ff                	xor    %edi,%edi
  803d2a:	89 fa                	mov    %edi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d39:	89 eb                	mov    %ebp,%ebx
  803d3b:	29 fb                	sub    %edi,%ebx
  803d3d:	89 f9                	mov    %edi,%ecx
  803d3f:	d3 e6                	shl    %cl,%esi
  803d41:	89 c5                	mov    %eax,%ebp
  803d43:	88 d9                	mov    %bl,%cl
  803d45:	d3 ed                	shr    %cl,%ebp
  803d47:	89 e9                	mov    %ebp,%ecx
  803d49:	09 f1                	or     %esi,%ecx
  803d4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d4f:	89 f9                	mov    %edi,%ecx
  803d51:	d3 e0                	shl    %cl,%eax
  803d53:	89 c5                	mov    %eax,%ebp
  803d55:	89 d6                	mov    %edx,%esi
  803d57:	88 d9                	mov    %bl,%cl
  803d59:	d3 ee                	shr    %cl,%esi
  803d5b:	89 f9                	mov    %edi,%ecx
  803d5d:	d3 e2                	shl    %cl,%edx
  803d5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d63:	88 d9                	mov    %bl,%cl
  803d65:	d3 e8                	shr    %cl,%eax
  803d67:	09 c2                	or     %eax,%edx
  803d69:	89 d0                	mov    %edx,%eax
  803d6b:	89 f2                	mov    %esi,%edx
  803d6d:	f7 74 24 0c          	divl   0xc(%esp)
  803d71:	89 d6                	mov    %edx,%esi
  803d73:	89 c3                	mov    %eax,%ebx
  803d75:	f7 e5                	mul    %ebp
  803d77:	39 d6                	cmp    %edx,%esi
  803d79:	72 19                	jb     803d94 <__udivdi3+0xfc>
  803d7b:	74 0b                	je     803d88 <__udivdi3+0xf0>
  803d7d:	89 d8                	mov    %ebx,%eax
  803d7f:	31 ff                	xor    %edi,%edi
  803d81:	e9 58 ff ff ff       	jmp    803cde <__udivdi3+0x46>
  803d86:	66 90                	xchg   %ax,%ax
  803d88:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d8c:	89 f9                	mov    %edi,%ecx
  803d8e:	d3 e2                	shl    %cl,%edx
  803d90:	39 c2                	cmp    %eax,%edx
  803d92:	73 e9                	jae    803d7d <__udivdi3+0xe5>
  803d94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d97:	31 ff                	xor    %edi,%edi
  803d99:	e9 40 ff ff ff       	jmp    803cde <__udivdi3+0x46>
  803d9e:	66 90                	xchg   %ax,%ax
  803da0:	31 c0                	xor    %eax,%eax
  803da2:	e9 37 ff ff ff       	jmp    803cde <__udivdi3+0x46>
  803da7:	90                   	nop

00803da8 <__umoddi3>:
  803da8:	55                   	push   %ebp
  803da9:	57                   	push   %edi
  803daa:	56                   	push   %esi
  803dab:	53                   	push   %ebx
  803dac:	83 ec 1c             	sub    $0x1c,%esp
  803daf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803db3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803db7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803dbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dc7:	89 f3                	mov    %esi,%ebx
  803dc9:	89 fa                	mov    %edi,%edx
  803dcb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dcf:	89 34 24             	mov    %esi,(%esp)
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	75 1a                	jne    803df0 <__umoddi3+0x48>
  803dd6:	39 f7                	cmp    %esi,%edi
  803dd8:	0f 86 a2 00 00 00    	jbe    803e80 <__umoddi3+0xd8>
  803dde:	89 c8                	mov    %ecx,%eax
  803de0:	89 f2                	mov    %esi,%edx
  803de2:	f7 f7                	div    %edi
  803de4:	89 d0                	mov    %edx,%eax
  803de6:	31 d2                	xor    %edx,%edx
  803de8:	83 c4 1c             	add    $0x1c,%esp
  803deb:	5b                   	pop    %ebx
  803dec:	5e                   	pop    %esi
  803ded:	5f                   	pop    %edi
  803dee:	5d                   	pop    %ebp
  803def:	c3                   	ret    
  803df0:	39 f0                	cmp    %esi,%eax
  803df2:	0f 87 ac 00 00 00    	ja     803ea4 <__umoddi3+0xfc>
  803df8:	0f bd e8             	bsr    %eax,%ebp
  803dfb:	83 f5 1f             	xor    $0x1f,%ebp
  803dfe:	0f 84 ac 00 00 00    	je     803eb0 <__umoddi3+0x108>
  803e04:	bf 20 00 00 00       	mov    $0x20,%edi
  803e09:	29 ef                	sub    %ebp,%edi
  803e0b:	89 fe                	mov    %edi,%esi
  803e0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e11:	89 e9                	mov    %ebp,%ecx
  803e13:	d3 e0                	shl    %cl,%eax
  803e15:	89 d7                	mov    %edx,%edi
  803e17:	89 f1                	mov    %esi,%ecx
  803e19:	d3 ef                	shr    %cl,%edi
  803e1b:	09 c7                	or     %eax,%edi
  803e1d:	89 e9                	mov    %ebp,%ecx
  803e1f:	d3 e2                	shl    %cl,%edx
  803e21:	89 14 24             	mov    %edx,(%esp)
  803e24:	89 d8                	mov    %ebx,%eax
  803e26:	d3 e0                	shl    %cl,%eax
  803e28:	89 c2                	mov    %eax,%edx
  803e2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e2e:	d3 e0                	shl    %cl,%eax
  803e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e34:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e38:	89 f1                	mov    %esi,%ecx
  803e3a:	d3 e8                	shr    %cl,%eax
  803e3c:	09 d0                	or     %edx,%eax
  803e3e:	d3 eb                	shr    %cl,%ebx
  803e40:	89 da                	mov    %ebx,%edx
  803e42:	f7 f7                	div    %edi
  803e44:	89 d3                	mov    %edx,%ebx
  803e46:	f7 24 24             	mull   (%esp)
  803e49:	89 c6                	mov    %eax,%esi
  803e4b:	89 d1                	mov    %edx,%ecx
  803e4d:	39 d3                	cmp    %edx,%ebx
  803e4f:	0f 82 87 00 00 00    	jb     803edc <__umoddi3+0x134>
  803e55:	0f 84 91 00 00 00    	je     803eec <__umoddi3+0x144>
  803e5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e5f:	29 f2                	sub    %esi,%edx
  803e61:	19 cb                	sbb    %ecx,%ebx
  803e63:	89 d8                	mov    %ebx,%eax
  803e65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e69:	d3 e0                	shl    %cl,%eax
  803e6b:	89 e9                	mov    %ebp,%ecx
  803e6d:	d3 ea                	shr    %cl,%edx
  803e6f:	09 d0                	or     %edx,%eax
  803e71:	89 e9                	mov    %ebp,%ecx
  803e73:	d3 eb                	shr    %cl,%ebx
  803e75:	89 da                	mov    %ebx,%edx
  803e77:	83 c4 1c             	add    $0x1c,%esp
  803e7a:	5b                   	pop    %ebx
  803e7b:	5e                   	pop    %esi
  803e7c:	5f                   	pop    %edi
  803e7d:	5d                   	pop    %ebp
  803e7e:	c3                   	ret    
  803e7f:	90                   	nop
  803e80:	89 fd                	mov    %edi,%ebp
  803e82:	85 ff                	test   %edi,%edi
  803e84:	75 0b                	jne    803e91 <__umoddi3+0xe9>
  803e86:	b8 01 00 00 00       	mov    $0x1,%eax
  803e8b:	31 d2                	xor    %edx,%edx
  803e8d:	f7 f7                	div    %edi
  803e8f:	89 c5                	mov    %eax,%ebp
  803e91:	89 f0                	mov    %esi,%eax
  803e93:	31 d2                	xor    %edx,%edx
  803e95:	f7 f5                	div    %ebp
  803e97:	89 c8                	mov    %ecx,%eax
  803e99:	f7 f5                	div    %ebp
  803e9b:	89 d0                	mov    %edx,%eax
  803e9d:	e9 44 ff ff ff       	jmp    803de6 <__umoddi3+0x3e>
  803ea2:	66 90                	xchg   %ax,%ax
  803ea4:	89 c8                	mov    %ecx,%eax
  803ea6:	89 f2                	mov    %esi,%edx
  803ea8:	83 c4 1c             	add    $0x1c,%esp
  803eab:	5b                   	pop    %ebx
  803eac:	5e                   	pop    %esi
  803ead:	5f                   	pop    %edi
  803eae:	5d                   	pop    %ebp
  803eaf:	c3                   	ret    
  803eb0:	3b 04 24             	cmp    (%esp),%eax
  803eb3:	72 06                	jb     803ebb <__umoddi3+0x113>
  803eb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803eb9:	77 0f                	ja     803eca <__umoddi3+0x122>
  803ebb:	89 f2                	mov    %esi,%edx
  803ebd:	29 f9                	sub    %edi,%ecx
  803ebf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ec3:	89 14 24             	mov    %edx,(%esp)
  803ec6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eca:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ece:	8b 14 24             	mov    (%esp),%edx
  803ed1:	83 c4 1c             	add    $0x1c,%esp
  803ed4:	5b                   	pop    %ebx
  803ed5:	5e                   	pop    %esi
  803ed6:	5f                   	pop    %edi
  803ed7:	5d                   	pop    %ebp
  803ed8:	c3                   	ret    
  803ed9:	8d 76 00             	lea    0x0(%esi),%esi
  803edc:	2b 04 24             	sub    (%esp),%eax
  803edf:	19 fa                	sbb    %edi,%edx
  803ee1:	89 d1                	mov    %edx,%ecx
  803ee3:	89 c6                	mov    %eax,%esi
  803ee5:	e9 71 ff ff ff       	jmp    803e5b <__umoddi3+0xb3>
  803eea:	66 90                	xchg   %ax,%ax
  803eec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ef0:	72 ea                	jb     803edc <__umoddi3+0x134>
  803ef2:	89 d9                	mov    %ebx,%ecx
  803ef4:	e9 62 ff ff ff       	jmp    803e5b <__umoddi3+0xb3>
