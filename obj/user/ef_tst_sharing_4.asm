
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
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
_main(void)
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
  800092:	6a 12                	push   $0x12
  800094:	68 3c 37 80 00       	push   $0x80373c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 37 80 00       	push   $0x803754
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 88 37 80 00       	push   $0x803788
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 e4 37 80 00       	push   $0x8037e4
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 1d 1f 00 00       	call   801ffe <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 18 38 80 00       	push   $0x803818
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 3e 1c 00 00       	call   801d37 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 47 38 80 00       	push   $0x803847
  80010b:	e8 24 19 00 00       	call   801a34 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 4c 38 80 00       	push   $0x80384c
  800127:	6a 21                	push   $0x21
  800129:	68 3c 37 80 00       	push   $0x80373c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 fc 1b 00 00       	call   801d37 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 b8 38 80 00       	push   $0x8038b8
  80014c:	6a 22                	push   $0x22
  80014e:	68 3c 37 80 00       	push   $0x80373c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 74 1a 00 00       	call   801bd7 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 c9 1b 00 00       	call   801d37 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 38 39 80 00       	push   $0x803938
  80017f:	6a 25                	push   $0x25
  800181:	68 3c 37 80 00       	push   $0x80373c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 a7 1b 00 00       	call   801d37 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 90 39 80 00       	push   $0x803990
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 3c 37 80 00       	push   $0x80373c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 c0 39 80 00       	push   $0x8039c0
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 e4 39 80 00       	push   $0x8039e4
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 65 1b 00 00       	call   801d37 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 14 3a 80 00       	push   $0x803a14
  8001e4:	e8 4b 18 00 00       	call   801a34 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 47 38 80 00       	push   $0x803847
  8001fe:	e8 31 18 00 00       	call   801a34 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 38 39 80 00       	push   $0x803938
  800217:	6a 32                	push   $0x32
  800219:	68 3c 37 80 00       	push   $0x80373c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 0c 1b 00 00       	call   801d37 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 18 3a 80 00       	push   $0x803a18
  80023c:	6a 34                	push   $0x34
  80023e:	68 3c 37 80 00       	push   $0x80373c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 84 19 00 00       	call   801bd7 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 d9 1a 00 00       	call   801d37 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 6d 3a 80 00       	push   $0x803a6d
  80026f:	6a 37                	push   $0x37
  800271:	68 3c 37 80 00       	push   $0x80373c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 51 19 00 00       	call   801bd7 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 a9 1a 00 00       	call   801d37 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 6d 3a 80 00       	push   $0x803a6d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 3c 37 80 00       	push   $0x80373c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 8c 3a 80 00       	push   $0x803a8c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 b0 3a 80 00       	push   $0x803ab0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 67 1a 00 00       	call   801d37 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 e0 3a 80 00       	push   $0x803ae0
  8002e2:	e8 4d 17 00 00       	call   801a34 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 e2 3a 80 00       	push   $0x803ae2
  8002fc:	e8 33 17 00 00       	call   801a34 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 28 1a 00 00       	call   801d37 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 b8 38 80 00       	push   $0x8038b8
  800320:	6a 46                	push   $0x46
  800322:	68 3c 37 80 00       	push   $0x80373c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 a0 18 00 00       	call   801bd7 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 f5 19 00 00       	call   801d37 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 6d 3a 80 00       	push   $0x803a6d
  800353:	6a 49                	push   $0x49
  800355:	68 3c 37 80 00       	push   $0x80373c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 e4 3a 80 00       	push   $0x803ae4
  80036e:	e8 c1 16 00 00       	call   801a34 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 b6 19 00 00       	call   801d37 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 b8 38 80 00       	push   $0x8038b8
  800392:	6a 4e                	push   $0x4e
  800394:	68 3c 37 80 00       	push   $0x80373c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 2e 18 00 00       	call   801bd7 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 83 19 00 00       	call   801d37 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 6d 3a 80 00       	push   $0x803a6d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 3c 37 80 00       	push   $0x80373c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 fb 17 00 00       	call   801bd7 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 53 19 00 00       	call   801d37 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 6d 3a 80 00       	push   $0x803a6d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 3c 37 80 00       	push   $0x80373c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 31 19 00 00       	call   801d37 <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 e0 3a 80 00       	push   $0x803ae0
  800420:	e8 0f 16 00 00       	call   801a34 <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 e2 3a 80 00       	push   $0x803ae2
  800446:	e8 e9 15 00 00       	call   801a34 <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 e4 3a 80 00       	push   $0x803ae4
  800468:	e8 c7 15 00 00       	call   801a34 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 bc 18 00 00       	call   801d37 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 b8 38 80 00       	push   $0x8038b8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 3c 37 80 00       	push   $0x80373c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 32 17 00 00       	call   801bd7 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 87 18 00 00       	call   801d37 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 6d 3a 80 00       	push   $0x803a6d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 3c 37 80 00       	push   $0x80373c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 fd 16 00 00       	call   801bd7 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 52 18 00 00       	call   801d37 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 6d 3a 80 00       	push   $0x803a6d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 3c 37 80 00       	push   $0x80373c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 c8 16 00 00       	call   801bd7 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 20 18 00 00       	call   801d37 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 6d 3a 80 00       	push   $0x803a6d
  800528:	6a 66                	push   $0x66
  80052a:	68 3c 37 80 00       	push   $0x80373c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 e8 3a 80 00       	push   $0x803ae8
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 0c 3b 80 00       	push   $0x803b0c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 d7 1a 00 00       	call   802030 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 58 3b 80 00       	push   $0x803b58
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 7e 15 00 00       	call   801af7 <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 79 1a 00 00       	call   802017 <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 1b 18 00 00       	call   801e24 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 80 3b 80 00       	push   $0x803b80
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 a8 3b 80 00       	push   $0x803ba8
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 d0 3b 80 00       	push   $0x803bd0
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 28 3c 80 00       	push   $0x803c28
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 80 3b 80 00       	push   $0x803b80
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 9b 17 00 00       	call   801e3e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 28 19 00 00       	call   801fe3 <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 7d 19 00 00       	call   802049 <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 3c 3c 80 00       	push   $0x803c3c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 41 3c 80 00       	push   $0x803c41
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 5d 3c 80 00       	push   $0x803c5d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 60 3c 80 00       	push   $0x803c60
  80075e:	6a 26                	push   $0x26
  800760:	68 ac 3c 80 00       	push   $0x803cac
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 b8 3c 80 00       	push   $0x803cb8
  800830:	6a 3a                	push   $0x3a
  800832:	68 ac 3c 80 00       	push   $0x803cac
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 0c 3d 80 00       	push   $0x803d0c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 ac 3c 80 00       	push   $0x803cac
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 7c 13 00 00       	call   801c76 <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 05 13 00 00       	call   801c76 <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 69 14 00 00       	call   801e24 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 63 14 00 00       	call   801e3e <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 7f 2a 00 00       	call   8034a4 <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 3f 2b 00 00       	call   8035b4 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 74 3f 80 00       	add    $0x803f74,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 98 3f 80 00 	mov    0x803f98(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d e0 3d 80 00 	mov    0x803de0(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 85 3f 80 00       	push   $0x803f85
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 8e 3f 80 00       	push   $0x803f8e
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be 91 3f 80 00       	mov    $0x803f91,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 f0 40 80 00       	push   $0x8040f0
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801744:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174b:	00 00 00 
  80174e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801755:	00 00 00 
  801758:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80175f:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801762:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801769:	00 00 00 
  80176c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801773:	00 00 00 
  801776:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80177d:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801780:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801787:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80178a:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801791:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a5:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8017aa:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	6a 06                	push   $0x6
  8017c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c6:	50                   	push   %eax
  8017c7:	e8 ee 05 00 00       	call   801dba <sys_allocate_chunk>
  8017cc:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017cf:	a1 20 51 80 00       	mov    0x805120,%eax
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	50                   	push   %eax
  8017d8:	e8 63 0c 00 00       	call   802440 <initialize_MemBlocksList>
  8017dd:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8017e0:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8017e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8017e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017eb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8017f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801803:	89 c2                	mov    %eax,%edx
  801805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801808:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80180b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801815:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80181c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181f:	8b 50 08             	mov    0x8(%eax),%edx
  801822:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801825:	01 d0                	add    %edx,%eax
  801827:	48                   	dec    %eax
  801828:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80182b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	f7 75 e0             	divl   -0x20(%ebp)
  801836:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801839:	29 d0                	sub    %edx,%eax
  80183b:	89 c2                	mov    %eax,%edx
  80183d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801840:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801843:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801847:	75 14                	jne    80185d <initialize_dyn_block_system+0x11f>
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 15 41 80 00       	push   $0x804115
  801851:	6a 34                	push   $0x34
  801853:	68 33 41 80 00       	push   $0x804133
  801858:	e8 72 ee ff ff       	call   8006cf <_panic>
  80185d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	85 c0                	test   %eax,%eax
  801864:	74 10                	je     801876 <initialize_dyn_block_system+0x138>
  801866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801869:	8b 00                	mov    (%eax),%eax
  80186b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80186e:	8b 52 04             	mov    0x4(%edx),%edx
  801871:	89 50 04             	mov    %edx,0x4(%eax)
  801874:	eb 0b                	jmp    801881 <initialize_dyn_block_system+0x143>
  801876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801879:	8b 40 04             	mov    0x4(%eax),%eax
  80187c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801884:	8b 40 04             	mov    0x4(%eax),%eax
  801887:	85 c0                	test   %eax,%eax
  801889:	74 0f                	je     80189a <initialize_dyn_block_system+0x15c>
  80188b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188e:	8b 40 04             	mov    0x4(%eax),%eax
  801891:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801894:	8b 12                	mov    (%edx),%edx
  801896:	89 10                	mov    %edx,(%eax)
  801898:	eb 0a                	jmp    8018a4 <initialize_dyn_block_system+0x166>
  80189a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80189d:	8b 00                	mov    (%eax),%eax
  80189f:	a3 48 51 80 00       	mov    %eax,0x805148
  8018a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8018bc:	48                   	dec    %eax
  8018bd:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8018c2:	83 ec 0c             	sub    $0xc,%esp
  8018c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c8:	e8 c4 13 00 00       	call   802c91 <insert_sorted_with_merge_freeList>
  8018cd:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018d0:	90                   	nop
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d9:	e8 2f fe ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  8018de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e2:	75 07                	jne    8018eb <malloc+0x18>
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	eb 71                	jmp    80195c <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8018eb:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8018f2:	76 07                	jbe    8018fb <malloc+0x28>
	return NULL;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	eb 61                	jmp    80195c <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018fb:	e8 88 08 00 00       	call   802188 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801900:	85 c0                	test   %eax,%eax
  801902:	74 53                	je     801957 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801904:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80190b:	8b 55 08             	mov    0x8(%ebp),%edx
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	01 d0                	add    %edx,%eax
  801913:	48                   	dec    %eax
  801914:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	ba 00 00 00 00       	mov    $0x0,%edx
  80191f:	f7 75 f4             	divl   -0xc(%ebp)
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	29 d0                	sub    %edx,%eax
  801927:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80192a:	83 ec 0c             	sub    $0xc,%esp
  80192d:	ff 75 ec             	pushl  -0x14(%ebp)
  801930:	e8 d2 0d 00 00       	call   802707 <alloc_block_FF>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80193b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80193f:	74 16                	je     801957 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	ff 75 e8             	pushl  -0x18(%ebp)
  801947:	e8 0c 0c 00 00       	call   802558 <insert_sorted_allocList>
  80194c:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80194f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801952:	8b 40 08             	mov    0x8(%eax),%eax
  801955:	eb 05                	jmp    80195c <malloc+0x89>
    }

			}


	return NULL;
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801972:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	ff 75 f0             	pushl  -0x10(%ebp)
  80197b:	68 40 50 80 00       	push   $0x805040
  801980:	e8 a0 0b 00 00       	call   802525 <find_block>
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198e:	8b 50 0c             	mov    0xc(%eax),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	e8 e4 03 00 00       	call   801d82 <sys_free_user_mem>
  80199e:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8019a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a5:	75 17                	jne    8019be <free+0x60>
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	68 15 41 80 00       	push   $0x804115
  8019af:	68 84 00 00 00       	push   $0x84
  8019b4:	68 33 41 80 00       	push   $0x804133
  8019b9:	e8 11 ed ff ff       	call   8006cf <_panic>
  8019be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c1:	8b 00                	mov    (%eax),%eax
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	74 10                	je     8019d7 <free+0x79>
  8019c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019cf:	8b 52 04             	mov    0x4(%edx),%edx
  8019d2:	89 50 04             	mov    %edx,0x4(%eax)
  8019d5:	eb 0b                	jmp    8019e2 <free+0x84>
  8019d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019da:	8b 40 04             	mov    0x4(%eax),%eax
  8019dd:	a3 44 50 80 00       	mov    %eax,0x805044
  8019e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e5:	8b 40 04             	mov    0x4(%eax),%eax
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	74 0f                	je     8019fb <free+0x9d>
  8019ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ef:	8b 40 04             	mov    0x4(%eax),%eax
  8019f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019f5:	8b 12                	mov    (%edx),%edx
  8019f7:	89 10                	mov    %edx,(%eax)
  8019f9:	eb 0a                	jmp    801a05 <free+0xa7>
  8019fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	a3 40 50 80 00       	mov    %eax,0x805040
  801a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a18:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a1d:	48                   	dec    %eax
  801a1e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801a23:	83 ec 0c             	sub    $0xc,%esp
  801a26:	ff 75 ec             	pushl  -0x14(%ebp)
  801a29:	e8 63 12 00 00       	call   802c91 <insert_sorted_with_merge_freeList>
  801a2e:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801a31:	90                   	nop
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 38             	sub    $0x38,%esp
  801a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a40:	e8 c8 fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801a45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a49:	75 0a                	jne    801a55 <smalloc+0x21>
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a50:	e9 a0 00 00 00       	jmp    801af5 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801a55:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801a5c:	76 0a                	jbe    801a68 <smalloc+0x34>
		return NULL;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a63:	e9 8d 00 00 00       	jmp    801af5 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a68:	e8 1b 07 00 00       	call   802188 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	74 7f                	je     801af0 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801a71:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	48                   	dec    %eax
  801a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	f7 75 f4             	divl   -0xc(%ebp)
  801a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a92:	29 d0                	sub    %edx,%eax
  801a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801a97:	83 ec 0c             	sub    $0xc,%esp
  801a9a:	ff 75 ec             	pushl  -0x14(%ebp)
  801a9d:	e8 65 0c 00 00       	call   802707 <alloc_block_FF>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801aa8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801aac:	74 42                	je     801af0 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801aae:	83 ec 0c             	sub    $0xc,%esp
  801ab1:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab4:	e8 9f 0a 00 00       	call   802558 <insert_sorted_allocList>
  801ab9:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801abf:	8b 40 08             	mov    0x8(%eax),%eax
  801ac2:	89 c2                	mov    %eax,%edx
  801ac4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ac8:	52                   	push   %edx
  801ac9:	50                   	push   %eax
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	e8 38 04 00 00       	call   801f0d <sys_createSharedObject>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801adf:	79 07                	jns    801ae8 <smalloc+0xb4>
	    		  return NULL;
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae6:	eb 0d                	jmp    801af5 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aeb:	8b 40 08             	mov    0x8(%eax),%eax
  801aee:	eb 05                	jmp    801af5 <smalloc+0xc1>


				}


		return NULL;
  801af0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801afd:	e8 0b fc ff ff       	call   80170d <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b02:	e8 81 06 00 00       	call   802188 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b07:	85 c0                	test   %eax,%eax
  801b09:	0f 84 9f 00 00 00    	je     801bae <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	ff 75 08             	pushl  0x8(%ebp)
  801b18:	e8 1a 04 00 00       	call   801f37 <sys_getSizeOfSharedObject>
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b27:	79 0a                	jns    801b33 <sget+0x3c>
		return NULL;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2e:	e9 80 00 00 00       	jmp    801bb3 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b33:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	48                   	dec    %eax
  801b43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b49:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4e:	f7 75 f0             	divl   -0x10(%ebp)
  801b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b54:	29 d0                	sub    %edx,%eax
  801b56:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b5f:	e8 a3 0b 00 00       	call   802707 <alloc_block_FF>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801b6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b6e:	74 3e                	je     801bae <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b76:	e8 dd 09 00 00       	call   802558 <insert_sorted_allocList>
  801b7b:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b81:	8b 40 08             	mov    0x8(%eax),%eax
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	50                   	push   %eax
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 c1 03 00 00       	call   801f54 <sys_getSharedObject>
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801b99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b9d:	79 07                	jns    801ba6 <sget+0xaf>
	    		  return NULL;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba4:	eb 0d                	jmp    801bb3 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba9:	8b 40 08             	mov    0x8(%eax),%eax
  801bac:	eb 05                	jmp    801bb3 <sget+0xbc>
	      }
	}
	   return NULL;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bbb:	e8 4d fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	68 40 41 80 00       	push   $0x804140
  801bc8:	68 12 01 00 00       	push   $0x112
  801bcd:	68 33 41 80 00       	push   $0x804133
  801bd2:	e8 f8 ea ff ff       	call   8006cf <_panic>

00801bd7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	68 68 41 80 00       	push   $0x804168
  801be5:	68 26 01 00 00       	push   $0x126
  801bea:	68 33 41 80 00       	push   $0x804133
  801bef:	e8 db ea ff ff       	call   8006cf <_panic>

00801bf4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 8c 41 80 00       	push   $0x80418c
  801c02:	68 31 01 00 00       	push   $0x131
  801c07:	68 33 41 80 00       	push   $0x804133
  801c0c:	e8 be ea ff ff       	call   8006cf <_panic>

00801c11 <shrink>:

}
void shrink(uint32 newSize)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 8c 41 80 00       	push   $0x80418c
  801c1f:	68 36 01 00 00       	push   $0x136
  801c24:	68 33 41 80 00       	push   $0x804133
  801c29:	e8 a1 ea ff ff       	call   8006cf <_panic>

00801c2e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	68 8c 41 80 00       	push   $0x80418c
  801c3c:	68 3b 01 00 00       	push   $0x13b
  801c41:	68 33 41 80 00       	push   $0x804133
  801c46:	e8 84 ea ff ff       	call   8006cf <_panic>

00801c4b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	57                   	push   %edi
  801c4f:	56                   	push   %esi
  801c50:	53                   	push   %ebx
  801c51:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c60:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c63:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c66:	cd 30                	int    $0x30
  801c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	5b                   	pop    %ebx
  801c72:	5e                   	pop    %esi
  801c73:	5f                   	pop    %edi
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c82:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	52                   	push   %edx
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	50                   	push   %eax
  801c92:	6a 00                	push   $0x0
  801c94:	e8 b2 ff ff ff       	call   801c4b <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_cgetc>:

int
sys_cgetc(void)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 01                	push   $0x1
  801cae:	e8 98 ff ff ff       	call   801c4b <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	6a 05                	push   $0x5
  801ccb:	e8 7b ff ff ff       	call   801c4b <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cda:	8b 75 18             	mov    0x18(%ebp),%esi
  801cdd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	56                   	push   %esi
  801cea:	53                   	push   %ebx
  801ceb:	51                   	push   %ecx
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	6a 06                	push   $0x6
  801cf0:	e8 56 ff ff ff       	call   801c4b <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	6a 07                	push   $0x7
  801d12:	e8 34 ff ff ff       	call   801c4b <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 08                	push   $0x8
  801d2d:	e8 19 ff ff ff       	call   801c4b <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 09                	push   $0x9
  801d46:	e8 00 ff ff ff       	call   801c4b <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 0a                	push   $0xa
  801d5f:	e8 e7 fe ff ff       	call   801c4b <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 0b                	push   $0xb
  801d78:	e8 ce fe ff ff       	call   801c4b <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	6a 0f                	push   $0xf
  801d93:	e8 b3 fe ff ff       	call   801c4b <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return;
  801d9b:	90                   	nop
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	6a 10                	push   $0x10
  801daf:	e8 97 fe ff ff       	call   801c4b <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return ;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	ff 75 10             	pushl  0x10(%ebp)
  801dc4:	ff 75 0c             	pushl  0xc(%ebp)
  801dc7:	ff 75 08             	pushl  0x8(%ebp)
  801dca:	6a 11                	push   $0x11
  801dcc:	e8 7a fe ff ff       	call   801c4b <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd4:	90                   	nop
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 0c                	push   $0xc
  801de6:	e8 60 fe ff ff       	call   801c4b <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	6a 0d                	push   $0xd
  801e00:	e8 46 fe ff ff       	call   801c4b <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 0e                	push   $0xe
  801e19:	e8 2d fe ff ff       	call   801c4b <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	90                   	nop
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 13                	push   $0x13
  801e33:	e8 13 fe ff ff       	call   801c4b <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	90                   	nop
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 14                	push   $0x14
  801e4d:	e8 f9 fd ff ff       	call   801c4b <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	90                   	nop
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e64:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 15                	push   $0x15
  801e73:	e8 d3 fd ff ff       	call   801c4b <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	90                   	nop
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 16                	push   $0x16
  801e8d:	e8 b9 fd ff ff       	call   801c4b <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	90                   	nop
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	ff 75 0c             	pushl  0xc(%ebp)
  801ea7:	50                   	push   %eax
  801ea8:	6a 17                	push   $0x17
  801eaa:	e8 9c fd ff ff       	call   801c4b <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	6a 1a                	push   $0x1a
  801ec7:	e8 7f fd ff ff       	call   801c4b <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	52                   	push   %edx
  801ee1:	50                   	push   %eax
  801ee2:	6a 18                	push   $0x18
  801ee4:	e8 62 fd ff ff       	call   801c4b <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
}
  801eec:	90                   	nop
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	6a 19                	push   $0x19
  801f02:	e8 44 fd ff ff       	call   801c4b <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	90                   	nop
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 04             	sub    $0x4,%esp
  801f13:	8b 45 10             	mov    0x10(%ebp),%eax
  801f16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	6a 00                	push   $0x0
  801f25:	51                   	push   %ecx
  801f26:	52                   	push   %edx
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	50                   	push   %eax
  801f2b:	6a 1b                	push   $0x1b
  801f2d:	e8 19 fd ff ff       	call   801c4b <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	52                   	push   %edx
  801f47:	50                   	push   %eax
  801f48:	6a 1c                	push   $0x1c
  801f4a:	e8 fc fc ff ff       	call   801c4b <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	51                   	push   %ecx
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	6a 1d                	push   $0x1d
  801f69:	e8 dd fc ff ff       	call   801c4b <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	6a 1e                	push   $0x1e
  801f86:	e8 c0 fc ff ff       	call   801c4b <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 1f                	push   $0x1f
  801f9f:	e8 a7 fc ff ff       	call   801c4b <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	ff 75 14             	pushl  0x14(%ebp)
  801fb4:	ff 75 10             	pushl  0x10(%ebp)
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	50                   	push   %eax
  801fbb:	6a 20                	push   $0x20
  801fbd:	e8 89 fc ff ff       	call   801c4b <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	50                   	push   %eax
  801fd6:	6a 21                	push   $0x21
  801fd8:	e8 6e fc ff ff       	call   801c4b <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	90                   	nop
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	50                   	push   %eax
  801ff2:	6a 22                	push   $0x22
  801ff4:	e8 52 fc ff ff       	call   801c4b <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 02                	push   $0x2
  80200d:	e8 39 fc ff ff       	call   801c4b <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 03                	push   $0x3
  802026:	e8 20 fc ff ff       	call   801c4b <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 04                	push   $0x4
  80203f:	e8 07 fc ff ff       	call   801c4b <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_exit_env>:


void sys_exit_env(void)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 23                	push   $0x23
  802058:	e8 ee fb ff ff       	call   801c4b <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	90                   	nop
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802069:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80206c:	8d 50 04             	lea    0x4(%eax),%edx
  80206f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 24                	push   $0x24
  80207c:	e8 ca fb ff ff       	call   801c4b <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
	return result;
  802084:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802087:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80208a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80208d:	89 01                	mov    %eax,(%ecx)
  80208f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	c9                   	leave  
  802096:	c2 04 00             	ret    $0x4

00802099 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	ff 75 10             	pushl  0x10(%ebp)
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	6a 12                	push   $0x12
  8020ab:	e8 9b fb ff ff       	call   801c4b <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b3:	90                   	nop
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 25                	push   $0x25
  8020c5:	e8 81 fb ff ff       	call   801c4b <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020db:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	50                   	push   %eax
  8020e8:	6a 26                	push   $0x26
  8020ea:	e8 5c fb ff ff       	call   801c4b <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f2:	90                   	nop
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <rsttst>:
void rsttst()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 28                	push   $0x28
  802104:	e8 42 fb ff ff       	call   801c4b <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
	return ;
  80210c:	90                   	nop
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	8b 45 14             	mov    0x14(%ebp),%eax
  802118:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80211b:	8b 55 18             	mov    0x18(%ebp),%edx
  80211e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	ff 75 10             	pushl  0x10(%ebp)
  802127:	ff 75 0c             	pushl  0xc(%ebp)
  80212a:	ff 75 08             	pushl  0x8(%ebp)
  80212d:	6a 27                	push   $0x27
  80212f:	e8 17 fb ff ff       	call   801c4b <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
	return ;
  802137:	90                   	nop
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <chktst>:
void chktst(uint32 n)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	6a 29                	push   $0x29
  80214a:	e8 fc fa ff ff       	call   801c4b <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
	return ;
  802152:	90                   	nop
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <inctst>:

void inctst()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 2a                	push   $0x2a
  802164:	e8 e2 fa ff ff       	call   801c4b <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
	return ;
  80216c:	90                   	nop
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <gettst>:
uint32 gettst()
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 2b                	push   $0x2b
  80217e:	e8 c8 fa ff ff       	call   801c4b <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 2c                	push   $0x2c
  80219a:	e8 ac fa ff ff       	call   801c4b <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
  8021a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021a5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021a9:	75 07                	jne    8021b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b0:	eb 05                	jmp    8021b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 2c                	push   $0x2c
  8021cb:	e8 7b fa ff ff       	call   801c4b <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
  8021d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021d6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021da:	75 07                	jne    8021e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e1:	eb 05                	jmp    8021e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 2c                	push   $0x2c
  8021fc:	e8 4a fa ff ff       	call   801c4b <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
  802204:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802207:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80220b:	75 07                	jne    802214 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80220d:	b8 01 00 00 00       	mov    $0x1,%eax
  802212:	eb 05                	jmp    802219 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 2c                	push   $0x2c
  80222d:	e8 19 fa ff ff       	call   801c4b <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
  802235:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802238:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80223c:	75 07                	jne    802245 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	eb 05                	jmp    80224a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	ff 75 08             	pushl  0x8(%ebp)
  80225a:	6a 2d                	push   $0x2d
  80225c:	e8 ea f9 ff ff       	call   801c4b <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
	return ;
  802264:	90                   	nop
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80226b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80226e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802271:	8b 55 0c             	mov    0xc(%ebp),%edx
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	6a 00                	push   $0x0
  802279:	53                   	push   %ebx
  80227a:	51                   	push   %ecx
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 2e                	push   $0x2e
  80227f:	e8 c7 f9 ff ff       	call   801c4b <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80228f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	52                   	push   %edx
  80229c:	50                   	push   %eax
  80229d:	6a 2f                	push   $0x2f
  80229f:	e8 a7 f9 ff ff       	call   801c4b <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022af:	83 ec 0c             	sub    $0xc,%esp
  8022b2:	68 9c 41 80 00       	push   $0x80419c
  8022b7:	e8 c7 e6 ff ff       	call   800983 <cprintf>
  8022bc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022c6:	83 ec 0c             	sub    $0xc,%esp
  8022c9:	68 c8 41 80 00       	push   $0x8041c8
  8022ce:	e8 b0 e6 ff ff       	call   800983 <cprintf>
  8022d3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022d6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022da:	a1 38 51 80 00       	mov    0x805138,%eax
  8022df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e2:	eb 56                	jmp    80233a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e8:	74 1c                	je     802306 <print_mem_block_lists+0x5d>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 50 08             	mov    0x8(%eax),%edx
  8022f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f3:	8b 48 08             	mov    0x8(%eax),%ecx
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fc:	01 c8                	add    %ecx,%eax
  8022fe:	39 c2                	cmp    %eax,%edx
  802300:	73 04                	jae    802306 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802302:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	8b 50 08             	mov    0x8(%eax),%edx
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 0c             	mov    0xc(%eax),%eax
  802312:	01 c2                	add    %eax,%edx
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 40 08             	mov    0x8(%eax),%eax
  80231a:	83 ec 04             	sub    $0x4,%esp
  80231d:	52                   	push   %edx
  80231e:	50                   	push   %eax
  80231f:	68 dd 41 80 00       	push   $0x8041dd
  802324:	e8 5a e6 ff ff       	call   800983 <cprintf>
  802329:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802332:	a1 40 51 80 00       	mov    0x805140,%eax
  802337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	74 07                	je     802347 <print_mem_block_lists+0x9e>
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	eb 05                	jmp    80234c <print_mem_block_lists+0xa3>
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
  80234c:	a3 40 51 80 00       	mov    %eax,0x805140
  802351:	a1 40 51 80 00       	mov    0x805140,%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 8a                	jne    8022e4 <print_mem_block_lists+0x3b>
  80235a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235e:	75 84                	jne    8022e4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802360:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802364:	75 10                	jne    802376 <print_mem_block_lists+0xcd>
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	68 ec 41 80 00       	push   $0x8041ec
  80236e:	e8 10 e6 ff ff       	call   800983 <cprintf>
  802373:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802376:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80237d:	83 ec 0c             	sub    $0xc,%esp
  802380:	68 10 42 80 00       	push   $0x804210
  802385:	e8 f9 e5 ff ff       	call   800983 <cprintf>
  80238a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80238d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802391:	a1 40 50 80 00       	mov    0x805040,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802399:	eb 56                	jmp    8023f1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80239b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80239f:	74 1c                	je     8023bd <print_mem_block_lists+0x114>
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 50 08             	mov    0x8(%eax),%edx
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b3:	01 c8                	add    %ecx,%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	73 04                	jae    8023bd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023b9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 50 08             	mov    0x8(%eax),%edx
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c9:	01 c2                	add    %eax,%edx
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 40 08             	mov    0x8(%eax),%eax
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	52                   	push   %edx
  8023d5:	50                   	push   %eax
  8023d6:	68 dd 41 80 00       	push   $0x8041dd
  8023db:	e8 a3 e5 ff ff       	call   800983 <cprintf>
  8023e0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023e9:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f5:	74 07                	je     8023fe <print_mem_block_lists+0x155>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	eb 05                	jmp    802403 <print_mem_block_lists+0x15a>
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	a3 48 50 80 00       	mov    %eax,0x805048
  802408:	a1 48 50 80 00       	mov    0x805048,%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 8a                	jne    80239b <print_mem_block_lists+0xf2>
  802411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802415:	75 84                	jne    80239b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802417:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80241b:	75 10                	jne    80242d <print_mem_block_lists+0x184>
  80241d:	83 ec 0c             	sub    $0xc,%esp
  802420:	68 28 42 80 00       	push   $0x804228
  802425:	e8 59 e5 ff ff       	call   800983 <cprintf>
  80242a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80242d:	83 ec 0c             	sub    $0xc,%esp
  802430:	68 9c 41 80 00       	push   $0x80419c
  802435:	e8 49 e5 ff ff       	call   800983 <cprintf>
  80243a:	83 c4 10             	add    $0x10,%esp

}
  80243d:	90                   	nop
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802446:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80244d:	00 00 00 
  802450:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802457:	00 00 00 
  80245a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802461:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802464:	a1 50 50 80 00       	mov    0x805050,%eax
  802469:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80246c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802473:	e9 9e 00 00 00       	jmp    802516 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802478:	a1 50 50 80 00       	mov    0x805050,%eax
  80247d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802480:	c1 e2 04             	shl    $0x4,%edx
  802483:	01 d0                	add    %edx,%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	75 14                	jne    80249d <initialize_MemBlocksList+0x5d>
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	68 50 42 80 00       	push   $0x804250
  802491:	6a 48                	push   $0x48
  802493:	68 73 42 80 00       	push   $0x804273
  802498:	e8 32 e2 ff ff       	call   8006cf <_panic>
  80249d:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a5:	c1 e2 04             	shl    $0x4,%edx
  8024a8:	01 d0                	add    %edx,%eax
  8024aa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024b0:	89 10                	mov    %edx,(%eax)
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	74 18                	je     8024d0 <initialize_MemBlocksList+0x90>
  8024b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8024bd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024c3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024c6:	c1 e1 04             	shl    $0x4,%ecx
  8024c9:	01 ca                	add    %ecx,%edx
  8024cb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ce:	eb 12                	jmp    8024e2 <initialize_MemBlocksList+0xa2>
  8024d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d8:	c1 e2 04             	shl    $0x4,%edx
  8024db:	01 d0                	add    %edx,%eax
  8024dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	c1 e2 04             	shl    $0x4,%edx
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8024f4:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	c1 e2 04             	shl    $0x4,%edx
  8024ff:	01 d0                	add    %edx,%eax
  802501:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802508:	a1 54 51 80 00       	mov    0x805154,%eax
  80250d:	40                   	inc    %eax
  80250e:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802513:	ff 45 f4             	incl   -0xc(%ebp)
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251c:	0f 82 56 ff ff ff    	jb     802478 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802522:	90                   	nop
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
  802528:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802533:	eb 18                	jmp    80254d <find_block+0x28>
		{
			if(tmp->sva==va)
  802535:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802538:	8b 40 08             	mov    0x8(%eax),%eax
  80253b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80253e:	75 05                	jne    802545 <find_block+0x20>
			{
				return tmp;
  802540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802543:	eb 11                	jmp    802556 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802545:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80254d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802551:	75 e2                	jne    802535 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802553:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80255e:	a1 40 50 80 00       	mov    0x805040,%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	0f 85 83 00 00 00    	jne    8025ee <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80256b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802572:	00 00 00 
  802575:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80257c:	00 00 00 
  80257f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802586:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80258d:	75 14                	jne    8025a3 <insert_sorted_allocList+0x4b>
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	68 50 42 80 00       	push   $0x804250
  802597:	6a 7f                	push   $0x7f
  802599:	68 73 42 80 00       	push   $0x804273
  80259e:	e8 2c e1 ff ff       	call   8006cf <_panic>
  8025a3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 0d                	je     8025c4 <insert_sorted_allocList+0x6c>
  8025b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8025bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bf:	89 50 04             	mov    %edx,0x4(%eax)
  8025c2:	eb 08                	jmp    8025cc <insert_sorted_allocList+0x74>
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025e3:	40                   	inc    %eax
  8025e4:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8025e9:	e9 16 01 00 00       	jmp    802704 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	8b 50 08             	mov    0x8(%eax),%edx
  8025f4:	a1 44 50 80 00       	mov    0x805044,%eax
  8025f9:	8b 40 08             	mov    0x8(%eax),%eax
  8025fc:	39 c2                	cmp    %eax,%edx
  8025fe:	76 68                	jbe    802668 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802600:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802604:	75 17                	jne    80261d <insert_sorted_allocList+0xc5>
  802606:	83 ec 04             	sub    $0x4,%esp
  802609:	68 8c 42 80 00       	push   $0x80428c
  80260e:	68 85 00 00 00       	push   $0x85
  802613:	68 73 42 80 00       	push   $0x804273
  802618:	e8 b2 e0 ff ff       	call   8006cf <_panic>
  80261d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	89 50 04             	mov    %edx,0x4(%eax)
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	8b 40 04             	mov    0x4(%eax),%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	74 0c                	je     80263f <insert_sorted_allocList+0xe7>
  802633:	a1 44 50 80 00       	mov    0x805044,%eax
  802638:	8b 55 08             	mov    0x8(%ebp),%edx
  80263b:	89 10                	mov    %edx,(%eax)
  80263d:	eb 08                	jmp    802647 <insert_sorted_allocList+0xef>
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	a3 40 50 80 00       	mov    %eax,0x805040
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	a3 44 50 80 00       	mov    %eax,0x805044
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802658:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80265d:	40                   	inc    %eax
  80265e:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802663:	e9 9c 00 00 00       	jmp    802704 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802668:	a1 40 50 80 00       	mov    0x805040,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802670:	e9 85 00 00 00       	jmp    8026fa <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802675:	8b 45 08             	mov    0x8(%ebp),%eax
  802678:	8b 50 08             	mov    0x8(%eax),%edx
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 08             	mov    0x8(%eax),%eax
  802681:	39 c2                	cmp    %eax,%edx
  802683:	73 6d                	jae    8026f2 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	74 06                	je     802691 <insert_sorted_allocList+0x139>
  80268b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268f:	75 17                	jne    8026a8 <insert_sorted_allocList+0x150>
  802691:	83 ec 04             	sub    $0x4,%esp
  802694:	68 b0 42 80 00       	push   $0x8042b0
  802699:	68 90 00 00 00       	push   $0x90
  80269e:	68 73 42 80 00       	push   $0x804273
  8026a3:	e8 27 e0 ff ff       	call   8006cf <_panic>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 50 04             	mov    0x4(%eax),%edx
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	89 50 04             	mov    %edx,0x4(%eax)
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ba:	89 10                	mov    %edx,(%eax)
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	74 0d                	je     8026d3 <insert_sorted_allocList+0x17b>
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 40 04             	mov    0x4(%eax),%eax
  8026cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cf:	89 10                	mov    %edx,(%eax)
  8026d1:	eb 08                	jmp    8026db <insert_sorted_allocList+0x183>
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	a3 40 50 80 00       	mov    %eax,0x805040
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e1:	89 50 04             	mov    %edx,0x4(%eax)
  8026e4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026e9:	40                   	inc    %eax
  8026ea:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026ef:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026f0:	eb 12                	jmp    802704 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 00                	mov    (%eax),%eax
  8026f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8026fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fe:	0f 85 71 ff ff ff    	jne    802675 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802704:	90                   	nop
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80270d:	a1 38 51 80 00       	mov    0x805138,%eax
  802712:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802715:	e9 76 01 00 00       	jmp    802890 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 0c             	mov    0xc(%eax),%eax
  802720:	3b 45 08             	cmp    0x8(%ebp),%eax
  802723:	0f 85 8a 00 00 00    	jne    8027b3 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_FF+0x3f>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 e5 42 80 00       	push   $0x8042e5
  802737:	68 a8 00 00 00       	push   $0xa8
  80273c:	68 73 42 80 00       	push   $0x804273
  802741:	e8 89 df ff ff       	call   8006cf <_panic>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <alloc_block_FF+0x58>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 0b                	jmp    80276a <alloc_block_FF+0x63>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 0f                	je     802783 <alloc_block_FF+0x7c>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277d:	8b 12                	mov    (%edx),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 0a                	jmp    80278d <alloc_block_FF+0x86>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	a3 38 51 80 00       	mov    %eax,0x805138
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	e9 ea 00 00 00       	jmp    80289d <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bc:	0f 86 c6 00 00 00    	jbe    802888 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8027c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d0:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 50 08             	mov    0x8(%eax),%edx
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e8:	89 c2                	mov    %eax,%edx
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 50 08             	mov    0x8(%eax),%edx
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	01 c2                	add    %eax,%edx
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802801:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802805:	75 17                	jne    80281e <alloc_block_FF+0x117>
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 e5 42 80 00       	push   $0x8042e5
  80280f:	68 b6 00 00 00       	push   $0xb6
  802814:	68 73 42 80 00       	push   $0x804273
  802819:	e8 b1 de ff ff       	call   8006cf <_panic>
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 10                	je     802837 <alloc_block_FF+0x130>
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282f:	8b 52 04             	mov    0x4(%edx),%edx
  802832:	89 50 04             	mov    %edx,0x4(%eax)
  802835:	eb 0b                	jmp    802842 <alloc_block_FF+0x13b>
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	8b 40 04             	mov    0x4(%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 0f                	je     80285b <alloc_block_FF+0x154>
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802855:	8b 12                	mov    (%edx),%edx
  802857:	89 10                	mov    %edx,(%eax)
  802859:	eb 0a                	jmp    802865 <alloc_block_FF+0x15e>
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	a3 48 51 80 00       	mov    %eax,0x805148
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802878:	a1 54 51 80 00       	mov    0x805154,%eax
  80287d:	48                   	dec    %eax
  80287e:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	eb 15                	jmp    80289d <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	0f 85 80 fe ff ff    	jne    80271a <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8028a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8028aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8028ad:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8028b4:	e9 c0 00 00 00       	jmp    802979 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c2:	0f 85 8a 00 00 00    	jne    802952 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cc:	75 17                	jne    8028e5 <alloc_block_BF+0x46>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 e5 42 80 00       	push   $0x8042e5
  8028d6:	68 cf 00 00 00       	push   $0xcf
  8028db:	68 73 42 80 00       	push   $0x804273
  8028e0:	e8 ea dd ff ff       	call   8006cf <_panic>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 10                	je     8028fe <alloc_block_BF+0x5f>
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 00                	mov    (%eax),%eax
  8028f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f6:	8b 52 04             	mov    0x4(%edx),%edx
  8028f9:	89 50 04             	mov    %edx,0x4(%eax)
  8028fc:	eb 0b                	jmp    802909 <alloc_block_BF+0x6a>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	74 0f                	je     802922 <alloc_block_BF+0x83>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291c:	8b 12                	mov    (%edx),%edx
  80291e:	89 10                	mov    %edx,(%eax)
  802920:	eb 0a                	jmp    80292c <alloc_block_BF+0x8d>
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	a3 38 51 80 00       	mov    %eax,0x805138
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293f:	a1 44 51 80 00       	mov    0x805144,%eax
  802944:	48                   	dec    %eax
  802945:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	e9 2a 01 00 00       	jmp    802a7c <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 0c             	mov    0xc(%eax),%eax
  802958:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80295b:	73 14                	jae    802971 <alloc_block_BF+0xd2>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 0c             	mov    0xc(%eax),%eax
  802963:	3b 45 08             	cmp    0x8(%ebp),%eax
  802966:	76 09                	jbe    802971 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 0c             	mov    0xc(%eax),%eax
  80296e:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	0f 85 36 ff ff ff    	jne    8028b9 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802983:	a1 38 51 80 00       	mov    0x805138,%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80298b:	e9 dd 00 00 00       	jmp    802a6d <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 0c             	mov    0xc(%eax),%eax
  802996:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802999:	0f 85 c6 00 00 00    	jne    802a65 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80299f:	a1 48 51 80 00       	mov    0x805148,%eax
  8029a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b9:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 50 08             	mov    0x8(%eax),%edx
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	01 c2                	add    %eax,%edx
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d6:	89 c2                	mov    %eax,%edx
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e2:	75 17                	jne    8029fb <alloc_block_BF+0x15c>
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	68 e5 42 80 00       	push   $0x8042e5
  8029ec:	68 eb 00 00 00       	push   $0xeb
  8029f1:	68 73 42 80 00       	push   $0x804273
  8029f6:	e8 d4 dc ff ff       	call   8006cf <_panic>
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 10                	je     802a14 <alloc_block_BF+0x175>
  802a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a0c:	8b 52 04             	mov    0x4(%edx),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%eax)
  802a12:	eb 0b                	jmp    802a1f <alloc_block_BF+0x180>
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0f                	je     802a38 <alloc_block_BF+0x199>
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	8b 40 04             	mov    0x4(%eax),%eax
  802a2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a32:	8b 12                	mov    (%edx),%edx
  802a34:	89 10                	mov    %edx,(%eax)
  802a36:	eb 0a                	jmp    802a42 <alloc_block_BF+0x1a3>
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	a3 48 51 80 00       	mov    %eax,0x805148
  802a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a55:	a1 54 51 80 00       	mov    0x805154,%eax
  802a5a:	48                   	dec    %eax
  802a5b:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a63:	eb 17                	jmp    802a7c <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a71:	0f 85 19 ff ff ff    	jne    802990 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a7c:	c9                   	leave  
  802a7d:	c3                   	ret    

00802a7e <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802a7e:	55                   	push   %ebp
  802a7f:	89 e5                	mov    %esp,%ebp
  802a81:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802a84:	a1 40 50 80 00       	mov    0x805040,%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	75 19                	jne    802aa6 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802a8d:	83 ec 0c             	sub    $0xc,%esp
  802a90:	ff 75 08             	pushl  0x8(%ebp)
  802a93:	e8 6f fc ff ff       	call   802707 <alloc_block_FF>
  802a98:	83 c4 10             	add    $0x10,%esp
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	e9 e9 01 00 00       	jmp    802c8f <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802aa6:	a1 44 50 80 00       	mov    0x805044,%eax
  802aab:	8b 40 08             	mov    0x8(%eax),%eax
  802aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802ab1:	a1 44 50 80 00       	mov    0x805044,%eax
  802ab6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab9:	a1 44 50 80 00       	mov    0x805044,%eax
  802abe:	8b 40 08             	mov    0x8(%eax),%eax
  802ac1:	01 d0                	add    %edx,%eax
  802ac3:	83 ec 08             	sub    $0x8,%esp
  802ac6:	50                   	push   %eax
  802ac7:	68 38 51 80 00       	push   $0x805138
  802acc:	e8 54 fa ff ff       	call   802525 <find_block>
  802ad1:	83 c4 10             	add    $0x10,%esp
  802ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 0c             	mov    0xc(%eax),%eax
  802add:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae0:	0f 85 9b 00 00 00    	jne    802b81 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 50 0c             	mov    0xc(%eax),%edx
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 08             	mov    0x8(%eax),%eax
  802af2:	01 d0                	add    %edx,%eax
  802af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	75 17                	jne    802b14 <alloc_block_NF+0x96>
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 e5 42 80 00       	push   $0x8042e5
  802b05:	68 1a 01 00 00       	push   $0x11a
  802b0a:	68 73 42 80 00       	push   $0x804273
  802b0f:	e8 bb db ff ff       	call   8006cf <_panic>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 10                	je     802b2d <alloc_block_NF+0xaf>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b25:	8b 52 04             	mov    0x4(%edx),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%eax)
  802b2b:	eb 0b                	jmp    802b38 <alloc_block_NF+0xba>
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 0f                	je     802b51 <alloc_block_NF+0xd3>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4b:	8b 12                	mov    (%edx),%edx
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	eb 0a                	jmp    802b5b <alloc_block_NF+0xdd>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	a3 38 51 80 00       	mov    %eax,0x805138
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b73:	48                   	dec    %eax
  802b74:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	e9 0e 01 00 00       	jmp    802c8f <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 0c             	mov    0xc(%eax),%eax
  802b87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8a:	0f 86 cf 00 00 00    	jbe    802c5f <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802b90:	a1 48 51 80 00       	mov    0x805148,%eax
  802b95:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9e:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 50 08             	mov    0x8(%eax),%edx
  802ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baa:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	01 c2                	add    %eax,%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc4:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc7:	89 c2                	mov    %eax,%edx
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 40 08             	mov    0x8(%eax),%eax
  802bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802bd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bdc:	75 17                	jne    802bf5 <alloc_block_NF+0x177>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 e5 42 80 00       	push   $0x8042e5
  802be6:	68 28 01 00 00       	push   $0x128
  802beb:	68 73 42 80 00       	push   $0x804273
  802bf0:	e8 da da ff ff       	call   8006cf <_panic>
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 10                	je     802c0e <alloc_block_NF+0x190>
  802bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c06:	8b 52 04             	mov    0x4(%edx),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	eb 0b                	jmp    802c19 <alloc_block_NF+0x19b>
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0f                	je     802c32 <alloc_block_NF+0x1b4>
  802c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2c:	8b 12                	mov    (%edx),%edx
  802c2e:	89 10                	mov    %edx,(%eax)
  802c30:	eb 0a                	jmp    802c3c <alloc_block_NF+0x1be>
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c54:	48                   	dec    %eax
  802c55:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	eb 30                	jmp    802c8f <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802c5f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c67:	75 0a                	jne    802c73 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802c69:	a1 38 51 80 00       	mov    0x805138,%eax
  802c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c71:	eb 08                	jmp    802c7b <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 08             	mov    0x8(%eax),%eax
  802c81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c84:	0f 85 4d fe ff ff    	jne    802ad7 <alloc_block_NF+0x59>

			return NULL;
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802c8f:	c9                   	leave  
  802c90:	c3                   	ret    

00802c91 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	53                   	push   %ebx
  802c95:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802c98:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	0f 85 86 00 00 00    	jne    802d2b <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802ca5:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802cac:	00 00 00 
  802caf:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802cb6:	00 00 00 
  802cb9:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802cc0:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc7:	75 17                	jne    802ce0 <insert_sorted_with_merge_freeList+0x4f>
  802cc9:	83 ec 04             	sub    $0x4,%esp
  802ccc:	68 50 42 80 00       	push   $0x804250
  802cd1:	68 48 01 00 00       	push   $0x148
  802cd6:	68 73 42 80 00       	push   $0x804273
  802cdb:	e8 ef d9 ff ff       	call   8006cf <_panic>
  802ce0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	89 10                	mov    %edx,(%eax)
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 0d                	je     802d01 <insert_sorted_with_merge_freeList+0x70>
  802cf4:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfc:	89 50 04             	mov    %edx,0x4(%eax)
  802cff:	eb 08                	jmp    802d09 <insert_sorted_with_merge_freeList+0x78>
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d20:	40                   	inc    %eax
  802d21:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802d26:	e9 73 07 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 50 08             	mov    0x8(%eax),%edx
  802d31:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d36:	8b 40 08             	mov    0x8(%eax),%eax
  802d39:	39 c2                	cmp    %eax,%edx
  802d3b:	0f 86 84 00 00 00    	jbe    802dc5 <insert_sorted_with_merge_freeList+0x134>
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d4c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d4f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	01 c8                	add    %ecx,%eax
  802d59:	39 c2                	cmp    %eax,%edx
  802d5b:	74 68                	je     802dc5 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d61:	75 17                	jne    802d7a <insert_sorted_with_merge_freeList+0xe9>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 8c 42 80 00       	push   $0x80428c
  802d6b:	68 4c 01 00 00       	push   $0x14c
  802d70:	68 73 42 80 00       	push   $0x804273
  802d75:	e8 55 d9 ff ff       	call   8006cf <_panic>
  802d7a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	89 50 04             	mov    %edx,0x4(%eax)
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 0c                	je     802d9c <insert_sorted_with_merge_freeList+0x10b>
  802d90:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d95:	8b 55 08             	mov    0x8(%ebp),%edx
  802d98:	89 10                	mov    %edx,(%eax)
  802d9a:	eb 08                	jmp    802da4 <insert_sorted_with_merge_freeList+0x113>
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db5:	a1 44 51 80 00       	mov    0x805144,%eax
  802dba:	40                   	inc    %eax
  802dbb:	a3 44 51 80 00       	mov    %eax,0x805144
  802dc0:	e9 d9 06 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	8b 50 08             	mov    0x8(%eax),%edx
  802dcb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dd0:	8b 40 08             	mov    0x8(%eax),%eax
  802dd3:	39 c2                	cmp    %eax,%edx
  802dd5:	0f 86 b5 00 00 00    	jbe    802e90 <insert_sorted_with_merge_freeList+0x1ff>
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	8b 50 08             	mov    0x8(%eax),%edx
  802de1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802de9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dee:	8b 40 08             	mov    0x8(%eax),%eax
  802df1:	01 c8                	add    %ecx,%eax
  802df3:	39 c2                	cmp    %eax,%edx
  802df5:	0f 85 95 00 00 00    	jne    802e90 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802dfb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e00:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e06:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e09:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0c:	8b 52 0c             	mov    0xc(%edx),%edx
  802e0f:	01 ca                	add    %ecx,%edx
  802e11:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2c:	75 17                	jne    802e45 <insert_sorted_with_merge_freeList+0x1b4>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 50 42 80 00       	push   $0x804250
  802e36:	68 54 01 00 00       	push   $0x154
  802e3b:	68 73 42 80 00       	push   $0x804273
  802e40:	e8 8a d8 ff ff       	call   8006cf <_panic>
  802e45:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0d                	je     802e66 <insert_sorted_with_merge_freeList+0x1d5>
  802e59:	a1 48 51 80 00       	mov    0x805148,%eax
  802e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e61:	89 50 04             	mov    %edx,0x4(%eax)
  802e64:	eb 08                	jmp    802e6e <insert_sorted_with_merge_freeList+0x1dd>
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	a3 48 51 80 00       	mov    %eax,0x805148
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e80:	a1 54 51 80 00       	mov    0x805154,%eax
  802e85:	40                   	inc    %eax
  802e86:	a3 54 51 80 00       	mov    %eax,0x805154
  802e8b:	e9 0e 06 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 50 08             	mov    0x8(%eax),%edx
  802e96:	a1 38 51 80 00       	mov    0x805138,%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
  802e9e:	39 c2                	cmp    %eax,%edx
  802ea0:	0f 83 c1 00 00 00    	jae    802f67 <insert_sorted_with_merge_freeList+0x2d6>
  802ea6:	a1 38 51 80 00       	mov    0x805138,%eax
  802eab:	8b 50 08             	mov    0x8(%eax),%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	8b 48 08             	mov    0x8(%eax),%ecx
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eba:	01 c8                	add    %ecx,%eax
  802ebc:	39 c2                	cmp    %eax,%edx
  802ebe:	0f 85 a3 00 00 00    	jne    802f67 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ec4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	8b 52 08             	mov    0x8(%edx),%edx
  802ecf:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ed2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802edd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee3:	8b 52 0c             	mov    0xc(%edx),%edx
  802ee6:	01 ca                	add    %ecx,%edx
  802ee8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802eff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f03:	75 17                	jne    802f1c <insert_sorted_with_merge_freeList+0x28b>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 50 42 80 00       	push   $0x804250
  802f0d:	68 5d 01 00 00       	push   $0x15d
  802f12:	68 73 42 80 00       	push   $0x804273
  802f17:	e8 b3 d7 ff ff       	call   8006cf <_panic>
  802f1c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	89 10                	mov    %edx,(%eax)
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0d                	je     802f3d <insert_sorted_with_merge_freeList+0x2ac>
  802f30:	a1 48 51 80 00       	mov    0x805148,%eax
  802f35:	8b 55 08             	mov    0x8(%ebp),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	eb 08                	jmp    802f45 <insert_sorted_with_merge_freeList+0x2b4>
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f57:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5c:	40                   	inc    %eax
  802f5d:	a3 54 51 80 00       	mov    %eax,0x805154
  802f62:	e9 37 05 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 50 08             	mov    0x8(%eax),%edx
  802f6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f72:	8b 40 08             	mov    0x8(%eax),%eax
  802f75:	39 c2                	cmp    %eax,%edx
  802f77:	0f 83 82 00 00 00    	jae    802fff <insert_sorted_with_merge_freeList+0x36e>
  802f7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 48 08             	mov    0x8(%eax),%ecx
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f91:	01 c8                	add    %ecx,%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	74 68                	je     802fff <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9b:	75 17                	jne    802fb4 <insert_sorted_with_merge_freeList+0x323>
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	68 50 42 80 00       	push   $0x804250
  802fa5:	68 62 01 00 00       	push   $0x162
  802faa:	68 73 42 80 00       	push   $0x804273
  802faf:	e8 1b d7 ff ff       	call   8006cf <_panic>
  802fb4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 0d                	je     802fd5 <insert_sorted_with_merge_freeList+0x344>
  802fc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd0:	89 50 04             	mov    %edx,0x4(%eax)
  802fd3:	eb 08                	jmp    802fdd <insert_sorted_with_merge_freeList+0x34c>
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fef:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff4:	40                   	inc    %eax
  802ff5:	a3 44 51 80 00       	mov    %eax,0x805144
  802ffa:	e9 9f 04 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802fff:	a1 38 51 80 00       	mov    0x805138,%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803009:	e9 84 04 00 00       	jmp    803492 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 50 08             	mov    0x8(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 40 08             	mov    0x8(%eax),%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	0f 86 a9 00 00 00    	jbe    8030cb <insert_sorted_with_merge_freeList+0x43a>
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 50 08             	mov    0x8(%eax),%edx
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 48 08             	mov    0x8(%eax),%ecx
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	8b 40 0c             	mov    0xc(%eax),%eax
  803034:	01 c8                	add    %ecx,%eax
  803036:	39 c2                	cmp    %eax,%edx
  803038:	0f 84 8d 00 00 00    	je     8030cb <insert_sorted_with_merge_freeList+0x43a>
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 50 08             	mov    0x8(%eax),%edx
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 40 04             	mov    0x4(%eax),%eax
  80304a:	8b 48 08             	mov    0x8(%eax),%ecx
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	8b 40 0c             	mov    0xc(%eax),%eax
  803056:	01 c8                	add    %ecx,%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	74 6f                	je     8030cb <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  80305c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803060:	74 06                	je     803068 <insert_sorted_with_merge_freeList+0x3d7>
  803062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803066:	75 17                	jne    80307f <insert_sorted_with_merge_freeList+0x3ee>
  803068:	83 ec 04             	sub    $0x4,%esp
  80306b:	68 b0 42 80 00       	push   $0x8042b0
  803070:	68 6b 01 00 00       	push   $0x16b
  803075:	68 73 42 80 00       	push   $0x804273
  80307a:	e8 50 d6 ff ff       	call   8006cf <_panic>
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 50 04             	mov    0x4(%eax),%edx
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	89 50 04             	mov    %edx,0x4(%eax)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803091:	89 10                	mov    %edx,(%eax)
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	74 0d                	je     8030aa <insert_sorted_with_merge_freeList+0x419>
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a6:	89 10                	mov    %edx,(%eax)
  8030a8:	eb 08                	jmp    8030b2 <insert_sorted_with_merge_freeList+0x421>
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b8:	89 50 04             	mov    %edx,0x4(%eax)
  8030bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c0:	40                   	inc    %eax
  8030c1:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8030c6:	e9 d3 03 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 50 08             	mov    0x8(%eax),%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 40 08             	mov    0x8(%eax),%eax
  8030d7:	39 c2                	cmp    %eax,%edx
  8030d9:	0f 86 da 00 00 00    	jbe    8031b9 <insert_sorted_with_merge_freeList+0x528>
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 50 08             	mov    0x8(%eax),%edx
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f1:	01 c8                	add    %ecx,%eax
  8030f3:	39 c2                	cmp    %eax,%edx
  8030f5:	0f 85 be 00 00 00    	jne    8031b9 <insert_sorted_with_merge_freeList+0x528>
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	8b 50 08             	mov    0x8(%eax),%edx
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 40 04             	mov    0x4(%eax),%eax
  803107:	8b 48 08             	mov    0x8(%eax),%ecx
  80310a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	01 c8                	add    %ecx,%eax
  803115:	39 c2                	cmp    %eax,%edx
  803117:	0f 84 9c 00 00 00    	je     8031b9 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 50 08             	mov    0x8(%eax),%edx
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 50 0c             	mov    0xc(%eax),%edx
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	01 c2                	add    %eax,%edx
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803155:	75 17                	jne    80316e <insert_sorted_with_merge_freeList+0x4dd>
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 50 42 80 00       	push   $0x804250
  80315f:	68 74 01 00 00       	push   $0x174
  803164:	68 73 42 80 00       	push   $0x804273
  803169:	e8 61 d5 ff ff       	call   8006cf <_panic>
  80316e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	89 10                	mov    %edx,(%eax)
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0d                	je     80318f <insert_sorted_with_merge_freeList+0x4fe>
  803182:	a1 48 51 80 00       	mov    0x805148,%eax
  803187:	8b 55 08             	mov    0x8(%ebp),%edx
  80318a:	89 50 04             	mov    %edx,0x4(%eax)
  80318d:	eb 08                	jmp    803197 <insert_sorted_with_merge_freeList+0x506>
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	a3 48 51 80 00       	mov    %eax,0x805148
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ae:	40                   	inc    %eax
  8031af:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8031b4:	e9 e5 02 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	8b 50 08             	mov    0x8(%eax),%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	8b 40 08             	mov    0x8(%eax),%eax
  8031c5:	39 c2                	cmp    %eax,%edx
  8031c7:	0f 86 d7 00 00 00    	jbe    8032a4 <insert_sorted_with_merge_freeList+0x613>
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 50 08             	mov    0x8(%eax),%edx
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 48 08             	mov    0x8(%eax),%ecx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	01 c8                	add    %ecx,%eax
  8031e1:	39 c2                	cmp    %eax,%edx
  8031e3:	0f 84 bb 00 00 00    	je     8032a4 <insert_sorted_with_merge_freeList+0x613>
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 50 08             	mov    0x8(%eax),%edx
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	8b 48 08             	mov    0x8(%eax),%ecx
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803201:	01 c8                	add    %ecx,%eax
  803203:	39 c2                	cmp    %eax,%edx
  803205:	0f 85 99 00 00 00    	jne    8032a4 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 40 04             	mov    0x4(%eax),%eax
  803211:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	8b 50 0c             	mov    0xc(%eax),%edx
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	8b 40 0c             	mov    0xc(%eax),%eax
  803220:	01 c2                	add    %eax,%edx
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80323c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803240:	75 17                	jne    803259 <insert_sorted_with_merge_freeList+0x5c8>
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	68 50 42 80 00       	push   $0x804250
  80324a:	68 7d 01 00 00       	push   $0x17d
  80324f:	68 73 42 80 00       	push   $0x804273
  803254:	e8 76 d4 ff ff       	call   8006cf <_panic>
  803259:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	89 10                	mov    %edx,(%eax)
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0d                	je     80327a <insert_sorted_with_merge_freeList+0x5e9>
  80326d:	a1 48 51 80 00       	mov    0x805148,%eax
  803272:	8b 55 08             	mov    0x8(%ebp),%edx
  803275:	89 50 04             	mov    %edx,0x4(%eax)
  803278:	eb 08                	jmp    803282 <insert_sorted_with_merge_freeList+0x5f1>
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	a3 48 51 80 00       	mov    %eax,0x805148
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803294:	a1 54 51 80 00       	mov    0x805154,%eax
  803299:	40                   	inc    %eax
  80329a:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80329f:	e9 fa 01 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 50 08             	mov    0x8(%eax),%edx
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 40 08             	mov    0x8(%eax),%eax
  8032b0:	39 c2                	cmp    %eax,%edx
  8032b2:	0f 86 d2 01 00 00    	jbe    80348a <insert_sorted_with_merge_freeList+0x7f9>
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 50 08             	mov    0x8(%eax),%edx
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ca:	01 c8                	add    %ecx,%eax
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	0f 85 b6 01 00 00    	jne    80348a <insert_sorted_with_merge_freeList+0x7f9>
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 50 08             	mov    0x8(%eax),%edx
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	8b 48 08             	mov    0x8(%eax),%ecx
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	8b 40 04             	mov    0x4(%eax),%eax
  8032e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ec:	01 c8                	add    %ecx,%eax
  8032ee:	39 c2                	cmp    %eax,%edx
  8032f0:	0f 85 94 01 00 00    	jne    80348a <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 40 04             	mov    0x4(%eax),%eax
  8032fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ff:	8b 52 04             	mov    0x4(%edx),%edx
  803302:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803305:	8b 55 08             	mov    0x8(%ebp),%edx
  803308:	8b 5a 0c             	mov    0xc(%edx),%ebx
  80330b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330e:	8b 52 0c             	mov    0xc(%edx),%edx
  803311:	01 da                	add    %ebx,%edx
  803313:	01 ca                	add    %ecx,%edx
  803315:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80332c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803330:	75 17                	jne    803349 <insert_sorted_with_merge_freeList+0x6b8>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 e5 42 80 00       	push   $0x8042e5
  80333a:	68 86 01 00 00       	push   $0x186
  80333f:	68 73 42 80 00       	push   $0x804273
  803344:	e8 86 d3 ff ff       	call   8006cf <_panic>
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 10                	je     803362 <insert_sorted_with_merge_freeList+0x6d1>
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335a:	8b 52 04             	mov    0x4(%edx),%edx
  80335d:	89 50 04             	mov    %edx,0x4(%eax)
  803360:	eb 0b                	jmp    80336d <insert_sorted_with_merge_freeList+0x6dc>
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 40 04             	mov    0x4(%eax),%eax
  803368:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 0f                	je     803386 <insert_sorted_with_merge_freeList+0x6f5>
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 40 04             	mov    0x4(%eax),%eax
  80337d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803380:	8b 12                	mov    (%edx),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	eb 0a                	jmp    803390 <insert_sorted_with_merge_freeList+0x6ff>
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	a3 38 51 80 00       	mov    %eax,0x805138
  803390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a8:	48                   	dec    %eax
  8033a9:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8033ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b2:	75 17                	jne    8033cb <insert_sorted_with_merge_freeList+0x73a>
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 50 42 80 00       	push   $0x804250
  8033bc:	68 87 01 00 00       	push   $0x187
  8033c1:	68 73 42 80 00       	push   $0x804273
  8033c6:	e8 04 d3 ff ff       	call   8006cf <_panic>
  8033cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	89 10                	mov    %edx,(%eax)
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 0d                	je     8033ec <insert_sorted_with_merge_freeList+0x75b>
  8033df:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	eb 08                	jmp    8033f4 <insert_sorted_with_merge_freeList+0x763>
  8033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803406:	a1 54 51 80 00       	mov    0x805154,%eax
  80340b:	40                   	inc    %eax
  80340c:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803429:	75 17                	jne    803442 <insert_sorted_with_merge_freeList+0x7b1>
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	68 50 42 80 00       	push   $0x804250
  803433:	68 8a 01 00 00       	push   $0x18a
  803438:	68 73 42 80 00       	push   $0x804273
  80343d:	e8 8d d2 ff ff       	call   8006cf <_panic>
  803442:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	89 10                	mov    %edx,(%eax)
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	74 0d                	je     803463 <insert_sorted_with_merge_freeList+0x7d2>
  803456:	a1 48 51 80 00       	mov    0x805148,%eax
  80345b:	8b 55 08             	mov    0x8(%ebp),%edx
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	eb 08                	jmp    80346b <insert_sorted_with_merge_freeList+0x7da>
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	a3 48 51 80 00       	mov    %eax,0x805148
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347d:	a1 54 51 80 00       	mov    0x805154,%eax
  803482:	40                   	inc    %eax
  803483:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803488:	eb 14                	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803496:	0f 85 72 fb ff ff    	jne    80300e <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80349c:	eb 00                	jmp    80349e <insert_sorted_with_merge_freeList+0x80d>
  80349e:	90                   	nop
  80349f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034a2:	c9                   	leave  
  8034a3:	c3                   	ret    

008034a4 <__udivdi3>:
  8034a4:	55                   	push   %ebp
  8034a5:	57                   	push   %edi
  8034a6:	56                   	push   %esi
  8034a7:	53                   	push   %ebx
  8034a8:	83 ec 1c             	sub    $0x1c,%esp
  8034ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034bb:	89 ca                	mov    %ecx,%edx
  8034bd:	89 f8                	mov    %edi,%eax
  8034bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034c3:	85 f6                	test   %esi,%esi
  8034c5:	75 2d                	jne    8034f4 <__udivdi3+0x50>
  8034c7:	39 cf                	cmp    %ecx,%edi
  8034c9:	77 65                	ja     803530 <__udivdi3+0x8c>
  8034cb:	89 fd                	mov    %edi,%ebp
  8034cd:	85 ff                	test   %edi,%edi
  8034cf:	75 0b                	jne    8034dc <__udivdi3+0x38>
  8034d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d6:	31 d2                	xor    %edx,%edx
  8034d8:	f7 f7                	div    %edi
  8034da:	89 c5                	mov    %eax,%ebp
  8034dc:	31 d2                	xor    %edx,%edx
  8034de:	89 c8                	mov    %ecx,%eax
  8034e0:	f7 f5                	div    %ebp
  8034e2:	89 c1                	mov    %eax,%ecx
  8034e4:	89 d8                	mov    %ebx,%eax
  8034e6:	f7 f5                	div    %ebp
  8034e8:	89 cf                	mov    %ecx,%edi
  8034ea:	89 fa                	mov    %edi,%edx
  8034ec:	83 c4 1c             	add    $0x1c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
  8034f4:	39 ce                	cmp    %ecx,%esi
  8034f6:	77 28                	ja     803520 <__udivdi3+0x7c>
  8034f8:	0f bd fe             	bsr    %esi,%edi
  8034fb:	83 f7 1f             	xor    $0x1f,%edi
  8034fe:	75 40                	jne    803540 <__udivdi3+0x9c>
  803500:	39 ce                	cmp    %ecx,%esi
  803502:	72 0a                	jb     80350e <__udivdi3+0x6a>
  803504:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803508:	0f 87 9e 00 00 00    	ja     8035ac <__udivdi3+0x108>
  80350e:	b8 01 00 00 00       	mov    $0x1,%eax
  803513:	89 fa                	mov    %edi,%edx
  803515:	83 c4 1c             	add    $0x1c,%esp
  803518:	5b                   	pop    %ebx
  803519:	5e                   	pop    %esi
  80351a:	5f                   	pop    %edi
  80351b:	5d                   	pop    %ebp
  80351c:	c3                   	ret    
  80351d:	8d 76 00             	lea    0x0(%esi),%esi
  803520:	31 ff                	xor    %edi,%edi
  803522:	31 c0                	xor    %eax,%eax
  803524:	89 fa                	mov    %edi,%edx
  803526:	83 c4 1c             	add    $0x1c,%esp
  803529:	5b                   	pop    %ebx
  80352a:	5e                   	pop    %esi
  80352b:	5f                   	pop    %edi
  80352c:	5d                   	pop    %ebp
  80352d:	c3                   	ret    
  80352e:	66 90                	xchg   %ax,%ax
  803530:	89 d8                	mov    %ebx,%eax
  803532:	f7 f7                	div    %edi
  803534:	31 ff                	xor    %edi,%edi
  803536:	89 fa                	mov    %edi,%edx
  803538:	83 c4 1c             	add    $0x1c,%esp
  80353b:	5b                   	pop    %ebx
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	bd 20 00 00 00       	mov    $0x20,%ebp
  803545:	89 eb                	mov    %ebp,%ebx
  803547:	29 fb                	sub    %edi,%ebx
  803549:	89 f9                	mov    %edi,%ecx
  80354b:	d3 e6                	shl    %cl,%esi
  80354d:	89 c5                	mov    %eax,%ebp
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 ed                	shr    %cl,%ebp
  803553:	89 e9                	mov    %ebp,%ecx
  803555:	09 f1                	or     %esi,%ecx
  803557:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80355b:	89 f9                	mov    %edi,%ecx
  80355d:	d3 e0                	shl    %cl,%eax
  80355f:	89 c5                	mov    %eax,%ebp
  803561:	89 d6                	mov    %edx,%esi
  803563:	88 d9                	mov    %bl,%cl
  803565:	d3 ee                	shr    %cl,%esi
  803567:	89 f9                	mov    %edi,%ecx
  803569:	d3 e2                	shl    %cl,%edx
  80356b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 e8                	shr    %cl,%eax
  803573:	09 c2                	or     %eax,%edx
  803575:	89 d0                	mov    %edx,%eax
  803577:	89 f2                	mov    %esi,%edx
  803579:	f7 74 24 0c          	divl   0xc(%esp)
  80357d:	89 d6                	mov    %edx,%esi
  80357f:	89 c3                	mov    %eax,%ebx
  803581:	f7 e5                	mul    %ebp
  803583:	39 d6                	cmp    %edx,%esi
  803585:	72 19                	jb     8035a0 <__udivdi3+0xfc>
  803587:	74 0b                	je     803594 <__udivdi3+0xf0>
  803589:	89 d8                	mov    %ebx,%eax
  80358b:	31 ff                	xor    %edi,%edi
  80358d:	e9 58 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  803592:	66 90                	xchg   %ax,%ax
  803594:	8b 54 24 08          	mov    0x8(%esp),%edx
  803598:	89 f9                	mov    %edi,%ecx
  80359a:	d3 e2                	shl    %cl,%edx
  80359c:	39 c2                	cmp    %eax,%edx
  80359e:	73 e9                	jae    803589 <__udivdi3+0xe5>
  8035a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035a3:	31 ff                	xor    %edi,%edi
  8035a5:	e9 40 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  8035aa:	66 90                	xchg   %ax,%ax
  8035ac:	31 c0                	xor    %eax,%eax
  8035ae:	e9 37 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  8035b3:	90                   	nop

008035b4 <__umoddi3>:
  8035b4:	55                   	push   %ebp
  8035b5:	57                   	push   %edi
  8035b6:	56                   	push   %esi
  8035b7:	53                   	push   %ebx
  8035b8:	83 ec 1c             	sub    $0x1c,%esp
  8035bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035d3:	89 f3                	mov    %esi,%ebx
  8035d5:	89 fa                	mov    %edi,%edx
  8035d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035db:	89 34 24             	mov    %esi,(%esp)
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	75 1a                	jne    8035fc <__umoddi3+0x48>
  8035e2:	39 f7                	cmp    %esi,%edi
  8035e4:	0f 86 a2 00 00 00    	jbe    80368c <__umoddi3+0xd8>
  8035ea:	89 c8                	mov    %ecx,%eax
  8035ec:	89 f2                	mov    %esi,%edx
  8035ee:	f7 f7                	div    %edi
  8035f0:	89 d0                	mov    %edx,%eax
  8035f2:	31 d2                	xor    %edx,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	39 f0                	cmp    %esi,%eax
  8035fe:	0f 87 ac 00 00 00    	ja     8036b0 <__umoddi3+0xfc>
  803604:	0f bd e8             	bsr    %eax,%ebp
  803607:	83 f5 1f             	xor    $0x1f,%ebp
  80360a:	0f 84 ac 00 00 00    	je     8036bc <__umoddi3+0x108>
  803610:	bf 20 00 00 00       	mov    $0x20,%edi
  803615:	29 ef                	sub    %ebp,%edi
  803617:	89 fe                	mov    %edi,%esi
  803619:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80361d:	89 e9                	mov    %ebp,%ecx
  80361f:	d3 e0                	shl    %cl,%eax
  803621:	89 d7                	mov    %edx,%edi
  803623:	89 f1                	mov    %esi,%ecx
  803625:	d3 ef                	shr    %cl,%edi
  803627:	09 c7                	or     %eax,%edi
  803629:	89 e9                	mov    %ebp,%ecx
  80362b:	d3 e2                	shl    %cl,%edx
  80362d:	89 14 24             	mov    %edx,(%esp)
  803630:	89 d8                	mov    %ebx,%eax
  803632:	d3 e0                	shl    %cl,%eax
  803634:	89 c2                	mov    %eax,%edx
  803636:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363a:	d3 e0                	shl    %cl,%eax
  80363c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803640:	8b 44 24 08          	mov    0x8(%esp),%eax
  803644:	89 f1                	mov    %esi,%ecx
  803646:	d3 e8                	shr    %cl,%eax
  803648:	09 d0                	or     %edx,%eax
  80364a:	d3 eb                	shr    %cl,%ebx
  80364c:	89 da                	mov    %ebx,%edx
  80364e:	f7 f7                	div    %edi
  803650:	89 d3                	mov    %edx,%ebx
  803652:	f7 24 24             	mull   (%esp)
  803655:	89 c6                	mov    %eax,%esi
  803657:	89 d1                	mov    %edx,%ecx
  803659:	39 d3                	cmp    %edx,%ebx
  80365b:	0f 82 87 00 00 00    	jb     8036e8 <__umoddi3+0x134>
  803661:	0f 84 91 00 00 00    	je     8036f8 <__umoddi3+0x144>
  803667:	8b 54 24 04          	mov    0x4(%esp),%edx
  80366b:	29 f2                	sub    %esi,%edx
  80366d:	19 cb                	sbb    %ecx,%ebx
  80366f:	89 d8                	mov    %ebx,%eax
  803671:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803675:	d3 e0                	shl    %cl,%eax
  803677:	89 e9                	mov    %ebp,%ecx
  803679:	d3 ea                	shr    %cl,%edx
  80367b:	09 d0                	or     %edx,%eax
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 eb                	shr    %cl,%ebx
  803681:	89 da                	mov    %ebx,%edx
  803683:	83 c4 1c             	add    $0x1c,%esp
  803686:	5b                   	pop    %ebx
  803687:	5e                   	pop    %esi
  803688:	5f                   	pop    %edi
  803689:	5d                   	pop    %ebp
  80368a:	c3                   	ret    
  80368b:	90                   	nop
  80368c:	89 fd                	mov    %edi,%ebp
  80368e:	85 ff                	test   %edi,%edi
  803690:	75 0b                	jne    80369d <__umoddi3+0xe9>
  803692:	b8 01 00 00 00       	mov    $0x1,%eax
  803697:	31 d2                	xor    %edx,%edx
  803699:	f7 f7                	div    %edi
  80369b:	89 c5                	mov    %eax,%ebp
  80369d:	89 f0                	mov    %esi,%eax
  80369f:	31 d2                	xor    %edx,%edx
  8036a1:	f7 f5                	div    %ebp
  8036a3:	89 c8                	mov    %ecx,%eax
  8036a5:	f7 f5                	div    %ebp
  8036a7:	89 d0                	mov    %edx,%eax
  8036a9:	e9 44 ff ff ff       	jmp    8035f2 <__umoddi3+0x3e>
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	89 c8                	mov    %ecx,%eax
  8036b2:	89 f2                	mov    %esi,%edx
  8036b4:	83 c4 1c             	add    $0x1c,%esp
  8036b7:	5b                   	pop    %ebx
  8036b8:	5e                   	pop    %esi
  8036b9:	5f                   	pop    %edi
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    
  8036bc:	3b 04 24             	cmp    (%esp),%eax
  8036bf:	72 06                	jb     8036c7 <__umoddi3+0x113>
  8036c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036c5:	77 0f                	ja     8036d6 <__umoddi3+0x122>
  8036c7:	89 f2                	mov    %esi,%edx
  8036c9:	29 f9                	sub    %edi,%ecx
  8036cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036cf:	89 14 24             	mov    %edx,(%esp)
  8036d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036da:	8b 14 24             	mov    (%esp),%edx
  8036dd:	83 c4 1c             	add    $0x1c,%esp
  8036e0:	5b                   	pop    %ebx
  8036e1:	5e                   	pop    %esi
  8036e2:	5f                   	pop    %edi
  8036e3:	5d                   	pop    %ebp
  8036e4:	c3                   	ret    
  8036e5:	8d 76 00             	lea    0x0(%esi),%esi
  8036e8:	2b 04 24             	sub    (%esp),%eax
  8036eb:	19 fa                	sbb    %edi,%edx
  8036ed:	89 d1                	mov    %edx,%ecx
  8036ef:	89 c6                	mov    %eax,%esi
  8036f1:	e9 71 ff ff ff       	jmp    803667 <__umoddi3+0xb3>
  8036f6:	66 90                	xchg   %ax,%ax
  8036f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036fc:	72 ea                	jb     8036e8 <__umoddi3+0x134>
  8036fe:	89 d9                	mov    %ebx,%ecx
  803700:	e9 62 ff ff ff       	jmp    803667 <__umoddi3+0xb3>
