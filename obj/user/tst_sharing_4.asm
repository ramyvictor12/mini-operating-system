
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
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
  80008d:	68 00 37 80 00       	push   $0x803700
  800092:	6a 12                	push   $0x12
  800094:	68 1c 37 80 00       	push   $0x80371c
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 0f 18 00 00       	call   8018b7 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 34 37 80 00       	push   $0x803734
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 68 37 80 00       	push   $0x803768
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 c4 37 80 00       	push   $0x8037c4
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 f4 1e 00 00       	call   801fe2 <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 f8 37 80 00       	push   $0x8037f8
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 15 1c 00 00       	call   801d1b <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 27 38 80 00       	push   $0x803827
  800118:	e8 fb 18 00 00       	call   801a18 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 2c 38 80 00       	push   $0x80382c
  800134:	6a 24                	push   $0x24
  800136:	68 1c 37 80 00       	push   $0x80371c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 d3 1b 00 00       	call   801d1b <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 98 38 80 00       	push   $0x803898
  800159:	6a 25                	push   $0x25
  80015b:	68 1c 37 80 00       	push   $0x80371c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 4b 1a 00 00       	call   801bbb <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 a0 1b 00 00       	call   801d1b <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 18 39 80 00       	push   $0x803918
  80018c:	6a 28                	push   $0x28
  80018e:	68 1c 37 80 00       	push   $0x80371c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 7e 1b 00 00       	call   801d1b <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 70 39 80 00       	push   $0x803970
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 1c 37 80 00       	push   $0x80371c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 a0 39 80 00       	push   $0x8039a0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 c4 39 80 00       	push   $0x8039c4
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 3c 1b 00 00       	call   801d1b <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 f4 39 80 00       	push   $0x8039f4
  8001f1:	e8 22 18 00 00       	call   801a18 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 27 38 80 00       	push   $0x803827
  80020b:	e8 08 18 00 00       	call   801a18 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 18 39 80 00       	push   $0x803918
  800224:	6a 35                	push   $0x35
  800226:	68 1c 37 80 00       	push   $0x80371c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 e3 1a 00 00       	call   801d1b <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 f8 39 80 00       	push   $0x8039f8
  800249:	6a 37                	push   $0x37
  80024b:	68 1c 37 80 00       	push   $0x80371c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 5b 19 00 00       	call   801bbb <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 b0 1a 00 00       	call   801d1b <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 4d 3a 80 00       	push   $0x803a4d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 1c 37 80 00       	push   $0x80371c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 28 19 00 00       	call   801bbb <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 80 1a 00 00       	call   801d1b <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 4d 3a 80 00       	push   $0x803a4d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 1c 37 80 00       	push   $0x80371c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 6c 3a 80 00       	push   $0x803a6c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 90 3a 80 00       	push   $0x803a90
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 3e 1a 00 00       	call   801d1b <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 c0 3a 80 00       	push   $0x803ac0
  8002ef:	e8 24 17 00 00       	call   801a18 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 c2 3a 80 00       	push   $0x803ac2
  800309:	e8 0a 17 00 00       	call   801a18 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 ff 19 00 00       	call   801d1b <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 98 38 80 00       	push   $0x803898
  80032d:	6a 48                	push   $0x48
  80032f:	68 1c 37 80 00       	push   $0x80371c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 77 18 00 00       	call   801bbb <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 cc 19 00 00       	call   801d1b <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 4d 3a 80 00       	push   $0x803a4d
  800360:	6a 4b                	push   $0x4b
  800362:	68 1c 37 80 00       	push   $0x80371c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 c4 3a 80 00       	push   $0x803ac4
  80037b:	e8 98 16 00 00       	call   801a18 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 c6 3a 80 00       	push   $0x803ac6
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 7d 19 00 00       	call   801d1b <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 98 38 80 00       	push   $0x803898
  8003af:	6a 52                	push   $0x52
  8003b1:	68 1c 37 80 00       	push   $0x80371c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 f5 17 00 00       	call   801bbb <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 4a 19 00 00       	call   801d1b <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 4d 3a 80 00       	push   $0x803a4d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 1c 37 80 00       	push   $0x80371c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 c2 17 00 00       	call   801bbb <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 1a 19 00 00       	call   801d1b <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 4d 3a 80 00       	push   $0x803a4d
  800412:	6a 58                	push   $0x58
  800414:	68 1c 37 80 00       	push   $0x80371c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 f8 18 00 00       	call   801d1b <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 c0 3a 80 00       	push   $0x803ac0
  80043d:	e8 d6 15 00 00       	call   801a18 <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 c2 3a 80 00       	push   $0x803ac2
  800463:	e8 b0 15 00 00       	call   801a18 <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 c4 3a 80 00       	push   $0x803ac4
  800485:	e8 8e 15 00 00       	call   801a18 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 83 18 00 00       	call   801d1b <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 98 38 80 00       	push   $0x803898
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 1c 37 80 00       	push   $0x80371c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 f9 16 00 00       	call   801bbb <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 4e 18 00 00       	call   801d1b <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 4d 3a 80 00       	push   $0x803a4d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 1c 37 80 00       	push   $0x80371c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 c4 16 00 00       	call   801bbb <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 19 18 00 00       	call   801d1b <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 4d 3a 80 00       	push   $0x803a4d
  800515:	6a 67                	push   $0x67
  800517:	68 1c 37 80 00       	push   $0x80371c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 8f 16 00 00       	call   801bbb <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 e7 17 00 00       	call   801d1b <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 4d 3a 80 00       	push   $0x803a4d
  800545:	6a 6a                	push   $0x6a
  800547:	68 1c 37 80 00       	push   $0x80371c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 cc 3a 80 00       	push   $0x803acc
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 f0 3a 80 00       	push   $0x803af0
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 79 1a 00 00       	call   801ffb <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 1b 18 00 00       	call   801e08 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 54 3b 80 00       	push   $0x803b54
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 7c 3b 80 00       	push   $0x803b7c
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 a4 3b 80 00       	push   $0x803ba4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 fc 3b 80 00       	push   $0x803bfc
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 54 3b 80 00       	push   $0x803b54
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 9b 17 00 00       	call   801e22 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 28 19 00 00       	call   801fc7 <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 7d 19 00 00       	call   80202d <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 10 3c 80 00       	push   $0x803c10
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 15 3c 80 00       	push   $0x803c15
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 31 3c 80 00       	push   $0x803c31
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 34 3c 80 00       	push   $0x803c34
  800742:	6a 26                	push   $0x26
  800744:	68 80 3c 80 00       	push   $0x803c80
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 8c 3c 80 00       	push   $0x803c8c
  800814:	6a 3a                	push   $0x3a
  800816:	68 80 3c 80 00       	push   $0x803c80
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 e0 3c 80 00       	push   $0x803ce0
  800884:	6a 44                	push   $0x44
  800886:	68 80 3c 80 00       	push   $0x803c80
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 7c 13 00 00       	call   801c5a <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 05 13 00 00       	call   801c5a <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 69 14 00 00       	call   801e08 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 63 14 00 00       	call   801e22 <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 7f 2a 00 00       	call   803488 <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 3f 2b 00 00       	call   803598 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 54 3f 80 00       	add    $0x803f54,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 65 3f 80 00       	push   $0x803f65
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 6e 3f 80 00       	push   $0x803f6e
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 d0 40 80 00       	push   $0x8040d0
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801728:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80172f:	00 00 00 
  801732:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801739:	00 00 00 
  80173c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801743:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801746:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174d:	00 00 00 
  801750:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801757:	00 00 00 
  80175a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801761:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801764:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80176b:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80176e:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801775:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801784:	2d 00 10 00 00       	sub    $0x1000,%eax
  801789:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80178e:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801798:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80179d:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	6a 06                	push   $0x6
  8017a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	e8 ee 05 00 00       	call   801d9e <sys_allocate_chunk>
  8017b0:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017b3:	a1 20 51 80 00       	mov    0x805120,%eax
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	50                   	push   %eax
  8017bc:	e8 63 0c 00 00       	call   802424 <initialize_MemBlocksList>
  8017c1:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8017c4:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8017c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8017cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017cf:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8017d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e7:	89 c2                	mov    %eax,%edx
  8017e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ec:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8017ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8017f9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801803:	8b 50 08             	mov    0x8(%eax),%edx
  801806:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801809:	01 d0                	add    %edx,%eax
  80180b:	48                   	dec    %eax
  80180c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80180f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801812:	ba 00 00 00 00       	mov    $0x0,%edx
  801817:	f7 75 e0             	divl   -0x20(%ebp)
  80181a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80181d:	29 d0                	sub    %edx,%eax
  80181f:	89 c2                	mov    %eax,%edx
  801821:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801824:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801827:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80182b:	75 14                	jne    801841 <initialize_dyn_block_system+0x11f>
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	68 f5 40 80 00       	push   $0x8040f5
  801835:	6a 34                	push   $0x34
  801837:	68 13 41 80 00       	push   $0x804113
  80183c:	e8 72 ee ff ff       	call   8006b3 <_panic>
  801841:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801844:	8b 00                	mov    (%eax),%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	74 10                	je     80185a <initialize_dyn_block_system+0x138>
  80184a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184d:	8b 00                	mov    (%eax),%eax
  80184f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801852:	8b 52 04             	mov    0x4(%edx),%edx
  801855:	89 50 04             	mov    %edx,0x4(%eax)
  801858:	eb 0b                	jmp    801865 <initialize_dyn_block_system+0x143>
  80185a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185d:	8b 40 04             	mov    0x4(%eax),%eax
  801860:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801868:	8b 40 04             	mov    0x4(%eax),%eax
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 0f                	je     80187e <initialize_dyn_block_system+0x15c>
  80186f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801872:	8b 40 04             	mov    0x4(%eax),%eax
  801875:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801878:	8b 12                	mov    (%edx),%edx
  80187a:	89 10                	mov    %edx,(%eax)
  80187c:	eb 0a                	jmp    801888 <initialize_dyn_block_system+0x166>
  80187e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801881:	8b 00                	mov    (%eax),%eax
  801883:	a3 48 51 80 00       	mov    %eax,0x805148
  801888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801894:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80189b:	a1 54 51 80 00       	mov    0x805154,%eax
  8018a0:	48                   	dec    %eax
  8018a1:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ac:	e8 c4 13 00 00       	call   802c75 <insert_sorted_with_merge_freeList>
  8018b1:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018bd:	e8 2f fe ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c6:	75 07                	jne    8018cf <malloc+0x18>
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cd:	eb 71                	jmp    801940 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8018cf:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8018d6:	76 07                	jbe    8018df <malloc+0x28>
	return NULL;
  8018d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dd:	eb 61                	jmp    801940 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018df:	e8 88 08 00 00       	call   80216c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	74 53                	je     80193b <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8018e8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f5:	01 d0                	add    %edx,%eax
  8018f7:	48                   	dec    %eax
  8018f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801903:	f7 75 f4             	divl   -0xc(%ebp)
  801906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801909:	29 d0                	sub    %edx,%eax
  80190b:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80190e:	83 ec 0c             	sub    $0xc,%esp
  801911:	ff 75 ec             	pushl  -0x14(%ebp)
  801914:	e8 d2 0d 00 00       	call   8026eb <alloc_block_FF>
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80191f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801923:	74 16                	je     80193b <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	ff 75 e8             	pushl  -0x18(%ebp)
  80192b:	e8 0c 0c 00 00       	call   80253c <insert_sorted_allocList>
  801930:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801936:	8b 40 08             	mov    0x8(%eax),%eax
  801939:	eb 05                	jmp    801940 <malloc+0x89>
    }

			}


	return NULL;
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801951:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801956:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 f0             	pushl  -0x10(%ebp)
  80195f:	68 40 50 80 00       	push   $0x805040
  801964:	e8 a0 0b 00 00       	call   802509 <find_block>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80196f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801972:	8b 50 0c             	mov    0xc(%eax),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	e8 e4 03 00 00       	call   801d66 <sys_free_user_mem>
  801982:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801985:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801989:	75 17                	jne    8019a2 <free+0x60>
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	68 f5 40 80 00       	push   $0x8040f5
  801993:	68 84 00 00 00       	push   $0x84
  801998:	68 13 41 80 00       	push   $0x804113
  80199d:	e8 11 ed ff ff       	call   8006b3 <_panic>
  8019a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	74 10                	je     8019bb <free+0x79>
  8019ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b3:	8b 52 04             	mov    0x4(%edx),%edx
  8019b6:	89 50 04             	mov    %edx,0x4(%eax)
  8019b9:	eb 0b                	jmp    8019c6 <free+0x84>
  8019bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019be:	8b 40 04             	mov    0x4(%eax),%eax
  8019c1:	a3 44 50 80 00       	mov    %eax,0x805044
  8019c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c9:	8b 40 04             	mov    0x4(%eax),%eax
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	74 0f                	je     8019df <free+0x9d>
  8019d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d3:	8b 40 04             	mov    0x4(%eax),%eax
  8019d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d9:	8b 12                	mov    (%edx),%edx
  8019db:	89 10                	mov    %edx,(%eax)
  8019dd:	eb 0a                	jmp    8019e9 <free+0xa7>
  8019df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8019e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a01:	48                   	dec    %eax
  801a02:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801a07:	83 ec 0c             	sub    $0xc,%esp
  801a0a:	ff 75 ec             	pushl  -0x14(%ebp)
  801a0d:	e8 63 12 00 00       	call   802c75 <insert_sorted_with_merge_freeList>
  801a12:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 38             	sub    $0x38,%esp
  801a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a21:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a24:	e8 c8 fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a2d:	75 0a                	jne    801a39 <smalloc+0x21>
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a34:	e9 a0 00 00 00       	jmp    801ad9 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801a39:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801a40:	76 0a                	jbe    801a4c <smalloc+0x34>
		return NULL;
  801a42:	b8 00 00 00 00       	mov    $0x0,%eax
  801a47:	e9 8d 00 00 00       	jmp    801ad9 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a4c:	e8 1b 07 00 00       	call   80216c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a51:	85 c0                	test   %eax,%eax
  801a53:	74 7f                	je     801ad4 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801a55:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	48                   	dec    %eax
  801a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	f7 75 f4             	divl   -0xc(%ebp)
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	29 d0                	sub    %edx,%eax
  801a78:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	ff 75 ec             	pushl  -0x14(%ebp)
  801a81:	e8 65 0c 00 00       	call   8026eb <alloc_block_FF>
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801a8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a90:	74 42                	je     801ad4 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801a92:	83 ec 0c             	sub    $0xc,%esp
  801a95:	ff 75 e8             	pushl  -0x18(%ebp)
  801a98:	e8 9f 0a 00 00       	call   80253c <insert_sorted_allocList>
  801a9d:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aa3:	8b 40 08             	mov    0x8(%eax),%eax
  801aa6:	89 c2                	mov    %eax,%edx
  801aa8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	e8 38 04 00 00       	call   801ef1 <sys_createSharedObject>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ac3:	79 07                	jns    801acc <smalloc+0xb4>
	    		  return NULL;
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aca:	eb 0d                	jmp    801ad9 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801acf:	8b 40 08             	mov    0x8(%eax),%eax
  801ad2:	eb 05                	jmp    801ad9 <smalloc+0xc1>


				}


		return NULL;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ae1:	e8 0b fc ff ff       	call   8016f1 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ae6:	e8 81 06 00 00       	call   80216c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	0f 84 9f 00 00 00    	je     801b92 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801af3:	83 ec 08             	sub    $0x8,%esp
  801af6:	ff 75 0c             	pushl  0xc(%ebp)
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	e8 1a 04 00 00       	call   801f1b <sys_getSizeOfSharedObject>
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b0b:	79 0a                	jns    801b17 <sget+0x3c>
		return NULL;
  801b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b12:	e9 80 00 00 00       	jmp    801b97 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b17:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	48                   	dec    %eax
  801b27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b32:	f7 75 f0             	divl   -0x10(%ebp)
  801b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b38:	29 d0                	sub    %edx,%eax
  801b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801b3d:	83 ec 0c             	sub    $0xc,%esp
  801b40:	ff 75 e8             	pushl  -0x18(%ebp)
  801b43:	e8 a3 0b 00 00       	call   8026eb <alloc_block_FF>
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801b4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b52:	74 3e                	je     801b92 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b5a:	e8 dd 09 00 00       	call   80253c <insert_sorted_allocList>
  801b5f:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b65:	8b 40 08             	mov    0x8(%eax),%eax
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	50                   	push   %eax
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	ff 75 08             	pushl  0x8(%ebp)
  801b72:	e8 c1 03 00 00       	call   801f38 <sys_getSharedObject>
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801b7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b81:	79 07                	jns    801b8a <sget+0xaf>
	    		  return NULL;
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
  801b88:	eb 0d                	jmp    801b97 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801b8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b8d:	8b 40 08             	mov    0x8(%eax),%eax
  801b90:	eb 05                	jmp    801b97 <sget+0xbc>
	      }
	}
	   return NULL;
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b9f:	e8 4d fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	68 20 41 80 00       	push   $0x804120
  801bac:	68 12 01 00 00       	push   $0x112
  801bb1:	68 13 41 80 00       	push   $0x804113
  801bb6:	e8 f8 ea ff ff       	call   8006b3 <_panic>

00801bbb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	68 48 41 80 00       	push   $0x804148
  801bc9:	68 26 01 00 00       	push   $0x126
  801bce:	68 13 41 80 00       	push   $0x804113
  801bd3:	e8 db ea ff ff       	call   8006b3 <_panic>

00801bd8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	68 6c 41 80 00       	push   $0x80416c
  801be6:	68 31 01 00 00       	push   $0x131
  801beb:	68 13 41 80 00       	push   $0x804113
  801bf0:	e8 be ea ff ff       	call   8006b3 <_panic>

00801bf5 <shrink>:

}
void shrink(uint32 newSize)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	68 6c 41 80 00       	push   $0x80416c
  801c03:	68 36 01 00 00       	push   $0x136
  801c08:	68 13 41 80 00       	push   $0x804113
  801c0d:	e8 a1 ea ff ff       	call   8006b3 <_panic>

00801c12 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c18:	83 ec 04             	sub    $0x4,%esp
  801c1b:	68 6c 41 80 00       	push   $0x80416c
  801c20:	68 3b 01 00 00       	push   $0x13b
  801c25:	68 13 41 80 00       	push   $0x804113
  801c2a:	e8 84 ea ff ff       	call   8006b3 <_panic>

00801c2f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	57                   	push   %edi
  801c33:	56                   	push   %esi
  801c34:	53                   	push   %ebx
  801c35:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c44:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c47:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c4a:	cd 30                	int    $0x30
  801c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    

00801c5a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	8b 45 10             	mov    0x10(%ebp),%eax
  801c63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	52                   	push   %edx
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	50                   	push   %eax
  801c76:	6a 00                	push   $0x0
  801c78:	e8 b2 ff ff ff       	call   801c2f <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	90                   	nop
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 01                	push   $0x1
  801c92:	e8 98 ff ff ff       	call   801c2f <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	6a 05                	push   $0x5
  801caf:	e8 7b ff ff ff       	call   801c2f <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cbe:	8b 75 18             	mov    0x18(%ebp),%esi
  801cc1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	51                   	push   %ecx
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 06                	push   $0x6
  801cd4:	e8 56 ff ff ff       	call   801c2f <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	52                   	push   %edx
  801cf3:	50                   	push   %eax
  801cf4:	6a 07                	push   $0x7
  801cf6:	e8 34 ff ff ff       	call   801c2f <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	ff 75 08             	pushl  0x8(%ebp)
  801d0f:	6a 08                	push   $0x8
  801d11:	e8 19 ff ff ff       	call   801c2f <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 09                	push   $0x9
  801d2a:	e8 00 ff ff ff       	call   801c2f <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 0a                	push   $0xa
  801d43:	e8 e7 fe ff ff       	call   801c2f <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 0b                	push   $0xb
  801d5c:	e8 ce fe ff ff       	call   801c2f <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 0f                	push   $0xf
  801d77:	e8 b3 fe ff ff       	call   801c2f <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	6a 10                	push   $0x10
  801d93:	e8 97 fe ff ff       	call   801c2f <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9b:	90                   	nop
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 10             	pushl  0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	6a 11                	push   $0x11
  801db0:	e8 7a fe ff ff       	call   801c2f <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
	return ;
  801db8:	90                   	nop
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 0c                	push   $0xc
  801dca:	e8 60 fe ff ff       	call   801c2f <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	ff 75 08             	pushl  0x8(%ebp)
  801de2:	6a 0d                	push   $0xd
  801de4:	e8 46 fe ff ff       	call   801c2f <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 0e                	push   $0xe
  801dfd:	e8 2d fe ff ff       	call   801c2f <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	90                   	nop
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 13                	push   $0x13
  801e17:	e8 13 fe ff ff       	call   801c2f <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	90                   	nop
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 14                	push   $0x14
  801e31:	e8 f9 fd ff ff       	call   801c2f <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_cputc>:


void
sys_cputc(const char c)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e48:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	50                   	push   %eax
  801e55:	6a 15                	push   $0x15
  801e57:	e8 d3 fd ff ff       	call   801c2f <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 16                	push   $0x16
  801e71:	e8 b9 fd ff ff       	call   801c2f <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	90                   	nop
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	50                   	push   %eax
  801e8c:	6a 17                	push   $0x17
  801e8e:	e8 9c fd ff ff       	call   801c2f <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	52                   	push   %edx
  801ea8:	50                   	push   %eax
  801ea9:	6a 1a                	push   $0x1a
  801eab:	e8 7f fd ff ff       	call   801c2f <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	6a 18                	push   $0x18
  801ec8:	e8 62 fd ff ff       	call   801c2f <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	90                   	nop
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	52                   	push   %edx
  801ee3:	50                   	push   %eax
  801ee4:	6a 19                	push   $0x19
  801ee6:	e8 44 fd ff ff       	call   801c2f <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	90                   	nop
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801efd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f00:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	51                   	push   %ecx
  801f0a:	52                   	push   %edx
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	50                   	push   %eax
  801f0f:	6a 1b                	push   $0x1b
  801f11:	e8 19 fd ff ff       	call   801c2f <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	6a 1c                	push   $0x1c
  801f2e:	e8 fc fc ff ff       	call   801c2f <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	51                   	push   %ecx
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 1d                	push   $0x1d
  801f4d:	e8 dd fc ff ff       	call   801c2f <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	6a 1e                	push   $0x1e
  801f6a:	e8 c0 fc ff ff       	call   801c2f <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 1f                	push   $0x1f
  801f83:	e8 a7 fc ff ff       	call   801c2f <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 14             	pushl  0x14(%ebp)
  801f98:	ff 75 10             	pushl  0x10(%ebp)
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	50                   	push   %eax
  801f9f:	6a 20                	push   $0x20
  801fa1:	e8 89 fc ff ff       	call   801c2f <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	50                   	push   %eax
  801fba:	6a 21                	push   $0x21
  801fbc:	e8 6e fc ff ff       	call   801c2f <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	90                   	nop
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	50                   	push   %eax
  801fd6:	6a 22                	push   $0x22
  801fd8:	e8 52 fc ff ff       	call   801c2f <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 02                	push   $0x2
  801ff1:	e8 39 fc ff ff       	call   801c2f <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 03                	push   $0x3
  80200a:	e8 20 fc ff ff       	call   801c2f <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 04                	push   $0x4
  802023:	e8 07 fc ff ff       	call   801c2f <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_exit_env>:


void sys_exit_env(void)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 23                	push   $0x23
  80203c:	e8 ee fb ff ff       	call   801c2f <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	90                   	nop
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80204d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802050:	8d 50 04             	lea    0x4(%eax),%edx
  802053:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	52                   	push   %edx
  80205d:	50                   	push   %eax
  80205e:	6a 24                	push   $0x24
  802060:	e8 ca fb ff ff       	call   801c2f <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
	return result;
  802068:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80206e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802071:	89 01                	mov    %eax,(%ecx)
  802073:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	c9                   	leave  
  80207a:	c2 04 00             	ret    $0x4

0080207d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	ff 75 10             	pushl  0x10(%ebp)
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	6a 12                	push   $0x12
  80208f:	e8 9b fb ff ff       	call   801c2f <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
	return ;
  802097:	90                   	nop
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_rcr2>:
uint32 sys_rcr2()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 25                	push   $0x25
  8020a9:	e8 81 fb ff ff       	call   801c2f <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020bf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	50                   	push   %eax
  8020cc:	6a 26                	push   $0x26
  8020ce:	e8 5c fb ff ff       	call   801c2f <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d6:	90                   	nop
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <rsttst>:
void rsttst()
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 28                	push   $0x28
  8020e8:	e8 42 fb ff ff       	call   801c2f <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f0:	90                   	nop
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020ff:	8b 55 18             	mov    0x18(%ebp),%edx
  802102:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802106:	52                   	push   %edx
  802107:	50                   	push   %eax
  802108:	ff 75 10             	pushl  0x10(%ebp)
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	ff 75 08             	pushl  0x8(%ebp)
  802111:	6a 27                	push   $0x27
  802113:	e8 17 fb ff ff       	call   801c2f <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
	return ;
  80211b:	90                   	nop
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <chktst>:
void chktst(uint32 n)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	6a 29                	push   $0x29
  80212e:	e8 fc fa ff ff       	call   801c2f <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
	return ;
  802136:	90                   	nop
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <inctst>:

void inctst()
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 2a                	push   $0x2a
  802148:	e8 e2 fa ff ff       	call   801c2f <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
	return ;
  802150:	90                   	nop
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <gettst>:
uint32 gettst()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 2b                	push   $0x2b
  802162:	e8 c8 fa ff ff       	call   801c2f <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 2c                	push   $0x2c
  80217e:	e8 ac fa ff ff       	call   801c2f <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
  802186:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802189:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80218d:	75 07                	jne    802196 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80218f:	b8 01 00 00 00       	mov    $0x1,%eax
  802194:	eb 05                	jmp    80219b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 2c                	push   $0x2c
  8021af:	e8 7b fa ff ff       	call   801c2f <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
  8021b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021ba:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021be:	75 07                	jne    8021c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c5:	eb 05                	jmp    8021cc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 2c                	push   $0x2c
  8021e0:	e8 4a fa ff ff       	call   801c2f <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
  8021e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021eb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021ef:	75 07                	jne    8021f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f6:	eb 05                	jmp    8021fd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 2c                	push   $0x2c
  802211:	e8 19 fa ff ff       	call   801c2f <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
  802219:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80221c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802220:	75 07                	jne    802229 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	eb 05                	jmp    80222e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802229:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	ff 75 08             	pushl  0x8(%ebp)
  80223e:	6a 2d                	push   $0x2d
  802240:	e8 ea f9 ff ff       	call   801c2f <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
	return ;
  802248:	90                   	nop
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80224f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802252:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802255:	8b 55 0c             	mov    0xc(%ebp),%edx
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	6a 00                	push   $0x0
  80225d:	53                   	push   %ebx
  80225e:	51                   	push   %ecx
  80225f:	52                   	push   %edx
  802260:	50                   	push   %eax
  802261:	6a 2e                	push   $0x2e
  802263:	e8 c7 f9 ff ff       	call   801c2f <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802273:	8b 55 0c             	mov    0xc(%ebp),%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	6a 2f                	push   $0x2f
  802283:	e8 a7 f9 ff ff       	call   801c2f <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	68 7c 41 80 00       	push   $0x80417c
  80229b:	e8 c7 e6 ff ff       	call   800967 <cprintf>
  8022a0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	68 a8 41 80 00       	push   $0x8041a8
  8022b2:	e8 b0 e6 ff ff       	call   800967 <cprintf>
  8022b7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022ba:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022be:	a1 38 51 80 00       	mov    0x805138,%eax
  8022c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c6:	eb 56                	jmp    80231e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022cc:	74 1c                	je     8022ea <print_mem_block_lists+0x5d>
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 50 08             	mov    0x8(%eax),%edx
  8022d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d7:	8b 48 08             	mov    0x8(%eax),%ecx
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e0:	01 c8                	add    %ecx,%eax
  8022e2:	39 c2                	cmp    %eax,%edx
  8022e4:	73 04                	jae    8022ea <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022e6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 50 08             	mov    0x8(%eax),%edx
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f6:	01 c2                	add    %eax,%edx
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 40 08             	mov    0x8(%eax),%eax
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	52                   	push   %edx
  802302:	50                   	push   %eax
  802303:	68 bd 41 80 00       	push   $0x8041bd
  802308:	e8 5a e6 ff ff       	call   800967 <cprintf>
  80230d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802316:	a1 40 51 80 00       	mov    0x805140,%eax
  80231b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802322:	74 07                	je     80232b <print_mem_block_lists+0x9e>
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	eb 05                	jmp    802330 <print_mem_block_lists+0xa3>
  80232b:	b8 00 00 00 00       	mov    $0x0,%eax
  802330:	a3 40 51 80 00       	mov    %eax,0x805140
  802335:	a1 40 51 80 00       	mov    0x805140,%eax
  80233a:	85 c0                	test   %eax,%eax
  80233c:	75 8a                	jne    8022c8 <print_mem_block_lists+0x3b>
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	75 84                	jne    8022c8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802344:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802348:	75 10                	jne    80235a <print_mem_block_lists+0xcd>
  80234a:	83 ec 0c             	sub    $0xc,%esp
  80234d:	68 cc 41 80 00       	push   $0x8041cc
  802352:	e8 10 e6 ff ff       	call   800967 <cprintf>
  802357:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80235a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802361:	83 ec 0c             	sub    $0xc,%esp
  802364:	68 f0 41 80 00       	push   $0x8041f0
  802369:	e8 f9 e5 ff ff       	call   800967 <cprintf>
  80236e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802371:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802375:	a1 40 50 80 00       	mov    0x805040,%eax
  80237a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237d:	eb 56                	jmp    8023d5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80237f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802383:	74 1c                	je     8023a1 <print_mem_block_lists+0x114>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 50 08             	mov    0x8(%eax),%edx
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	8b 48 08             	mov    0x8(%eax),%ecx
  802391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802394:	8b 40 0c             	mov    0xc(%eax),%eax
  802397:	01 c8                	add    %ecx,%eax
  802399:	39 c2                	cmp    %eax,%edx
  80239b:	73 04                	jae    8023a1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80239d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 50 08             	mov    0x8(%eax),%edx
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ad:	01 c2                	add    %eax,%edx
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	52                   	push   %edx
  8023b9:	50                   	push   %eax
  8023ba:	68 bd 41 80 00       	push   $0x8041bd
  8023bf:	e8 a3 e5 ff ff       	call   800967 <cprintf>
  8023c4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023cd:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d9:	74 07                	je     8023e2 <print_mem_block_lists+0x155>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	eb 05                	jmp    8023e7 <print_mem_block_lists+0x15a>
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e7:	a3 48 50 80 00       	mov    %eax,0x805048
  8023ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	75 8a                	jne    80237f <print_mem_block_lists+0xf2>
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	75 84                	jne    80237f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023fb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023ff:	75 10                	jne    802411 <print_mem_block_lists+0x184>
  802401:	83 ec 0c             	sub    $0xc,%esp
  802404:	68 08 42 80 00       	push   $0x804208
  802409:	e8 59 e5 ff ff       	call   800967 <cprintf>
  80240e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	68 7c 41 80 00       	push   $0x80417c
  802419:	e8 49 e5 ff ff       	call   800967 <cprintf>
  80241e:	83 c4 10             	add    $0x10,%esp

}
  802421:	90                   	nop
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80242a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802431:	00 00 00 
  802434:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80243b:	00 00 00 
  80243e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802445:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802448:	a1 50 50 80 00       	mov    0x805050,%eax
  80244d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802450:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802457:	e9 9e 00 00 00       	jmp    8024fa <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80245c:	a1 50 50 80 00       	mov    0x805050,%eax
  802461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802464:	c1 e2 04             	shl    $0x4,%edx
  802467:	01 d0                	add    %edx,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 14                	jne    802481 <initialize_MemBlocksList+0x5d>
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 30 42 80 00       	push   $0x804230
  802475:	6a 48                	push   $0x48
  802477:	68 53 42 80 00       	push   $0x804253
  80247c:	e8 32 e2 ff ff       	call   8006b3 <_panic>
  802481:	a1 50 50 80 00       	mov    0x805050,%eax
  802486:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802489:	c1 e2 04             	shl    $0x4,%edx
  80248c:	01 d0                	add    %edx,%eax
  80248e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	8b 00                	mov    (%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 18                	je     8024b4 <initialize_MemBlocksList+0x90>
  80249c:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024aa:	c1 e1 04             	shl    $0x4,%ecx
  8024ad:	01 ca                	add    %ecx,%edx
  8024af:	89 50 04             	mov    %edx,0x4(%eax)
  8024b2:	eb 12                	jmp    8024c6 <initialize_MemBlocksList+0xa2>
  8024b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bc:	c1 e2 04             	shl    $0x4,%edx
  8024bf:	01 d0                	add    %edx,%eax
  8024c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8024cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ce:	c1 e2 04             	shl    $0x4,%edx
  8024d1:	01 d0                	add    %edx,%eax
  8024d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8024d8:	a1 50 50 80 00       	mov    0x805050,%eax
  8024dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e0:	c1 e2 04             	shl    $0x4,%edx
  8024e3:	01 d0                	add    %edx,%eax
  8024e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8024f1:	40                   	inc    %eax
  8024f2:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8024f7:	ff 45 f4             	incl   -0xc(%ebp)
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802500:	0f 82 56 ff ff ff    	jb     80245c <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802506:	90                   	nop
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802517:	eb 18                	jmp    802531 <find_block+0x28>
		{
			if(tmp->sva==va)
  802519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80251c:	8b 40 08             	mov    0x8(%eax),%eax
  80251f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802522:	75 05                	jne    802529 <find_block+0x20>
			{
				return tmp;
  802524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802527:	eb 11                	jmp    80253a <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802531:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802535:	75 e2                	jne    802519 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802537:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802542:	a1 40 50 80 00       	mov    0x805040,%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	0f 85 83 00 00 00    	jne    8025d2 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80254f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802556:	00 00 00 
  802559:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802560:	00 00 00 
  802563:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80256a:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80256d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802571:	75 14                	jne    802587 <insert_sorted_allocList+0x4b>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 30 42 80 00       	push   $0x804230
  80257b:	6a 7f                	push   $0x7f
  80257d:	68 53 42 80 00       	push   $0x804253
  802582:	e8 2c e1 ff ff       	call   8006b3 <_panic>
  802587:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	89 10                	mov    %edx,(%eax)
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	74 0d                	je     8025a8 <insert_sorted_allocList+0x6c>
  80259b:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a3:	89 50 04             	mov    %edx,0x4(%eax)
  8025a6:	eb 08                	jmp    8025b0 <insert_sorted_allocList+0x74>
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	a3 44 50 80 00       	mov    %eax,0x805044
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	a3 40 50 80 00       	mov    %eax,0x805040
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c7:	40                   	inc    %eax
  8025c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8025cd:	e9 16 01 00 00       	jmp    8026e8 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	8b 50 08             	mov    0x8(%eax),%edx
  8025d8:	a1 44 50 80 00       	mov    0x805044,%eax
  8025dd:	8b 40 08             	mov    0x8(%eax),%eax
  8025e0:	39 c2                	cmp    %eax,%edx
  8025e2:	76 68                	jbe    80264c <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8025e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025e8:	75 17                	jne    802601 <insert_sorted_allocList+0xc5>
  8025ea:	83 ec 04             	sub    $0x4,%esp
  8025ed:	68 6c 42 80 00       	push   $0x80426c
  8025f2:	68 85 00 00 00       	push   $0x85
  8025f7:	68 53 42 80 00       	push   $0x804253
  8025fc:	e8 b2 e0 ff ff       	call   8006b3 <_panic>
  802601:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	89 50 04             	mov    %edx,0x4(%eax)
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	85 c0                	test   %eax,%eax
  802615:	74 0c                	je     802623 <insert_sorted_allocList+0xe7>
  802617:	a1 44 50 80 00       	mov    0x805044,%eax
  80261c:	8b 55 08             	mov    0x8(%ebp),%edx
  80261f:	89 10                	mov    %edx,(%eax)
  802621:	eb 08                	jmp    80262b <insert_sorted_allocList+0xef>
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	a3 40 50 80 00       	mov    %eax,0x805040
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	a3 44 50 80 00       	mov    %eax,0x805044
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802641:	40                   	inc    %eax
  802642:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802647:	e9 9c 00 00 00       	jmp    8026e8 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80264c:	a1 40 50 80 00       	mov    0x805040,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802654:	e9 85 00 00 00       	jmp    8026de <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	8b 50 08             	mov    0x8(%eax),%edx
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 08             	mov    0x8(%eax),%eax
  802665:	39 c2                	cmp    %eax,%edx
  802667:	73 6d                	jae    8026d6 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	74 06                	je     802675 <insert_sorted_allocList+0x139>
  80266f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802673:	75 17                	jne    80268c <insert_sorted_allocList+0x150>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 90 42 80 00       	push   $0x804290
  80267d:	68 90 00 00 00       	push   $0x90
  802682:	68 53 42 80 00       	push   $0x804253
  802687:	e8 27 e0 ff ff       	call   8006b3 <_panic>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 50 04             	mov    0x4(%eax),%edx
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	89 50 04             	mov    %edx,0x4(%eax)
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269e:	89 10                	mov    %edx,(%eax)
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 0d                	je     8026b7 <insert_sorted_allocList+0x17b>
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b3:	89 10                	mov    %edx,(%eax)
  8026b5:	eb 08                	jmp    8026bf <insert_sorted_allocList+0x183>
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026cd:	40                   	inc    %eax
  8026ce:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026d3:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026d4:	eb 12                	jmp    8026e8 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	0f 85 71 ff ff ff    	jne    802659 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026e8:	90                   	nop
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8026f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8026f9:	e9 76 01 00 00       	jmp    802874 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	3b 45 08             	cmp    0x8(%ebp),%eax
  802707:	0f 85 8a 00 00 00    	jne    802797 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80270d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802711:	75 17                	jne    80272a <alloc_block_FF+0x3f>
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	68 c5 42 80 00       	push   $0x8042c5
  80271b:	68 a8 00 00 00       	push   $0xa8
  802720:	68 53 42 80 00       	push   $0x804253
  802725:	e8 89 df ff ff       	call   8006b3 <_panic>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 10                	je     802743 <alloc_block_FF+0x58>
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273b:	8b 52 04             	mov    0x4(%edx),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	eb 0b                	jmp    80274e <alloc_block_FF+0x63>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 0f                	je     802767 <alloc_block_FF+0x7c>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802761:	8b 12                	mov    (%edx),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	eb 0a                	jmp    802771 <alloc_block_FF+0x86>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	a3 38 51 80 00       	mov    %eax,0x805138
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802784:	a1 44 51 80 00       	mov    0x805144,%eax
  802789:	48                   	dec    %eax
  80278a:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	e9 ea 00 00 00       	jmp    802881 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a0:	0f 86 c6 00 00 00    	jbe    80286c <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8027ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8027ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b4:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 50 08             	mov    0x8(%eax),%edx
  8027bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c0:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cc:	89 c2                	mov    %eax,%edx
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 50 08             	mov    0x8(%eax),%edx
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	01 c2                	add    %eax,%edx
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e9:	75 17                	jne    802802 <alloc_block_FF+0x117>
  8027eb:	83 ec 04             	sub    $0x4,%esp
  8027ee:	68 c5 42 80 00       	push   $0x8042c5
  8027f3:	68 b6 00 00 00       	push   $0xb6
  8027f8:	68 53 42 80 00       	push   $0x804253
  8027fd:	e8 b1 de ff ff       	call   8006b3 <_panic>
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	74 10                	je     80281b <alloc_block_FF+0x130>
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802813:	8b 52 04             	mov    0x4(%edx),%edx
  802816:	89 50 04             	mov    %edx,0x4(%eax)
  802819:	eb 0b                	jmp    802826 <alloc_block_FF+0x13b>
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	74 0f                	je     80283f <alloc_block_FF+0x154>
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 40 04             	mov    0x4(%eax),%eax
  802836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802839:	8b 12                	mov    (%edx),%edx
  80283b:	89 10                	mov    %edx,(%eax)
  80283d:	eb 0a                	jmp    802849 <alloc_block_FF+0x15e>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	a3 48 51 80 00       	mov    %eax,0x805148
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285c:	a1 54 51 80 00       	mov    0x805154,%eax
  802861:	48                   	dec    %eax
  802862:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	eb 15                	jmp    802881 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802878:	0f 85 80 fe ff ff    	jne    8026fe <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802889:	a1 38 51 80 00       	mov    0x805138,%eax
  80288e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802891:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802898:	e9 c0 00 00 00       	jmp    80295d <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a6:	0f 85 8a 00 00 00    	jne    802936 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8028ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b0:	75 17                	jne    8028c9 <alloc_block_BF+0x46>
  8028b2:	83 ec 04             	sub    $0x4,%esp
  8028b5:	68 c5 42 80 00       	push   $0x8042c5
  8028ba:	68 cf 00 00 00       	push   $0xcf
  8028bf:	68 53 42 80 00       	push   $0x804253
  8028c4:	e8 ea dd ff ff       	call   8006b3 <_panic>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	74 10                	je     8028e2 <alloc_block_BF+0x5f>
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028da:	8b 52 04             	mov    0x4(%edx),%edx
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	eb 0b                	jmp    8028ed <alloc_block_BF+0x6a>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 40 04             	mov    0x4(%eax),%eax
  8028e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	74 0f                	je     802906 <alloc_block_BF+0x83>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 04             	mov    0x4(%eax),%eax
  8028fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802900:	8b 12                	mov    (%edx),%edx
  802902:	89 10                	mov    %edx,(%eax)
  802904:	eb 0a                	jmp    802910 <alloc_block_BF+0x8d>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	a3 38 51 80 00       	mov    %eax,0x805138
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802923:	a1 44 51 80 00       	mov    0x805144,%eax
  802928:	48                   	dec    %eax
  802929:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	e9 2a 01 00 00       	jmp    802a60 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80293f:	73 14                	jae    802955 <alloc_block_BF+0xd2>
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 0c             	mov    0xc(%eax),%eax
  802947:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294a:	76 09                	jbe    802955 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 0c             	mov    0xc(%eax),%eax
  802952:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80295d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802961:	0f 85 36 ff ff ff    	jne    80289d <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802967:	a1 38 51 80 00       	mov    0x805138,%eax
  80296c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80296f:	e9 dd 00 00 00       	jmp    802a51 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 0c             	mov    0xc(%eax),%eax
  80297a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80297d:	0f 85 c6 00 00 00    	jne    802a49 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802983:	a1 48 51 80 00       	mov    0x805148,%eax
  802988:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 50 08             	mov    0x8(%eax),%edx
  802991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802994:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299a:	8b 55 08             	mov    0x8(%ebp),%edx
  80299d:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 50 08             	mov    0x8(%eax),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	01 c2                	add    %eax,%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ba:	89 c2                	mov    %eax,%edx
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c6:	75 17                	jne    8029df <alloc_block_BF+0x15c>
  8029c8:	83 ec 04             	sub    $0x4,%esp
  8029cb:	68 c5 42 80 00       	push   $0x8042c5
  8029d0:	68 eb 00 00 00       	push   $0xeb
  8029d5:	68 53 42 80 00       	push   $0x804253
  8029da:	e8 d4 dc ff ff       	call   8006b3 <_panic>
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	74 10                	je     8029f8 <alloc_block_BF+0x175>
  8029e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f0:	8b 52 04             	mov    0x4(%edx),%edx
  8029f3:	89 50 04             	mov    %edx,0x4(%eax)
  8029f6:	eb 0b                	jmp    802a03 <alloc_block_BF+0x180>
  8029f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fb:	8b 40 04             	mov    0x4(%eax),%eax
  8029fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a06:	8b 40 04             	mov    0x4(%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 0f                	je     802a1c <alloc_block_BF+0x199>
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a16:	8b 12                	mov    (%edx),%edx
  802a18:	89 10                	mov    %edx,(%eax)
  802a1a:	eb 0a                	jmp    802a26 <alloc_block_BF+0x1a3>
  802a1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	a3 48 51 80 00       	mov    %eax,0x805148
  802a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a39:	a1 54 51 80 00       	mov    0x805154,%eax
  802a3e:	48                   	dec    %eax
  802a3f:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a47:	eb 17                	jmp    802a60 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a55:	0f 85 19 ff ff ff    	jne    802974 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a60:	c9                   	leave  
  802a61:	c3                   	ret    

00802a62 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802a62:	55                   	push   %ebp
  802a63:	89 e5                	mov    %esp,%ebp
  802a65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802a68:	a1 40 50 80 00       	mov    0x805040,%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	75 19                	jne    802a8a <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802a71:	83 ec 0c             	sub    $0xc,%esp
  802a74:	ff 75 08             	pushl  0x8(%ebp)
  802a77:	e8 6f fc ff ff       	call   8026eb <alloc_block_FF>
  802a7c:	83 c4 10             	add    $0x10,%esp
  802a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	e9 e9 01 00 00       	jmp    802c73 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802a8a:	a1 44 50 80 00       	mov    0x805044,%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802a95:	a1 44 50 80 00       	mov    0x805044,%eax
  802a9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a9d:	a1 44 50 80 00       	mov    0x805044,%eax
  802aa2:	8b 40 08             	mov    0x8(%eax),%eax
  802aa5:	01 d0                	add    %edx,%eax
  802aa7:	83 ec 08             	sub    $0x8,%esp
  802aaa:	50                   	push   %eax
  802aab:	68 38 51 80 00       	push   $0x805138
  802ab0:	e8 54 fa ff ff       	call   802509 <find_block>
  802ab5:	83 c4 10             	add    $0x10,%esp
  802ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac4:	0f 85 9b 00 00 00    	jne    802b65 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 08             	mov    0x8(%eax),%eax
  802ad6:	01 d0                	add    %edx,%eax
  802ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adf:	75 17                	jne    802af8 <alloc_block_NF+0x96>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 c5 42 80 00       	push   $0x8042c5
  802ae9:	68 1a 01 00 00       	push   $0x11a
  802aee:	68 53 42 80 00       	push   $0x804253
  802af3:	e8 bb db ff ff       	call   8006b3 <_panic>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 10                	je     802b11 <alloc_block_NF+0xaf>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b09:	8b 52 04             	mov    0x4(%edx),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 0b                	jmp    802b1c <alloc_block_NF+0xba>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0f                	je     802b35 <alloc_block_NF+0xd3>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2f:	8b 12                	mov    (%edx),%edx
  802b31:	89 10                	mov    %edx,(%eax)
  802b33:	eb 0a                	jmp    802b3f <alloc_block_NF+0xdd>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b52:	a1 44 51 80 00       	mov    0x805144,%eax
  802b57:	48                   	dec    %eax
  802b58:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	e9 0e 01 00 00       	jmp    802c73 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6e:	0f 86 cf 00 00 00    	jbe    802c43 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802b74:	a1 48 51 80 00       	mov    0x805148,%eax
  802b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b82:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 50 08             	mov    0x8(%eax),%edx
  802b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8e:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 50 08             	mov    0x8(%eax),%edx
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	01 c2                	add    %eax,%edx
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	2b 45 08             	sub    0x8(%ebp),%eax
  802bab:	89 c2                	mov    %eax,%edx
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 08             	mov    0x8(%eax),%eax
  802bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802bbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc0:	75 17                	jne    802bd9 <alloc_block_NF+0x177>
  802bc2:	83 ec 04             	sub    $0x4,%esp
  802bc5:	68 c5 42 80 00       	push   $0x8042c5
  802bca:	68 28 01 00 00       	push   $0x128
  802bcf:	68 53 42 80 00       	push   $0x804253
  802bd4:	e8 da da ff ff       	call   8006b3 <_panic>
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	74 10                	je     802bf2 <alloc_block_NF+0x190>
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bea:	8b 52 04             	mov    0x4(%edx),%edx
  802bed:	89 50 04             	mov    %edx,0x4(%eax)
  802bf0:	eb 0b                	jmp    802bfd <alloc_block_NF+0x19b>
  802bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0f                	je     802c16 <alloc_block_NF+0x1b4>
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c10:	8b 12                	mov    (%edx),%edx
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	eb 0a                	jmp    802c20 <alloc_block_NF+0x1be>
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c33:	a1 54 51 80 00       	mov    0x805154,%eax
  802c38:	48                   	dec    %eax
  802c39:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c41:	eb 30                	jmp    802c73 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802c43:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c4b:	75 0a                	jne    802c57 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802c4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c55:	eb 08                	jmp    802c5f <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 08             	mov    0x8(%eax),%eax
  802c65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c68:	0f 85 4d fe ff ff    	jne    802abb <alloc_block_NF+0x59>

			return NULL;
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802c73:	c9                   	leave  
  802c74:	c3                   	ret    

00802c75 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
  802c78:	53                   	push   %ebx
  802c79:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802c7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	0f 85 86 00 00 00    	jne    802d0f <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802c89:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802c90:	00 00 00 
  802c93:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802c9a:	00 00 00 
  802c9d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802ca4:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ca7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cab:	75 17                	jne    802cc4 <insert_sorted_with_merge_freeList+0x4f>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 30 42 80 00       	push   $0x804230
  802cb5:	68 48 01 00 00       	push   $0x148
  802cba:	68 53 42 80 00       	push   $0x804253
  802cbf:	e8 ef d9 ff ff       	call   8006b3 <_panic>
  802cc4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0d                	je     802ce5 <insert_sorted_with_merge_freeList+0x70>
  802cd8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	eb 08                	jmp    802ced <insert_sorted_with_merge_freeList+0x78>
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cff:	a1 44 51 80 00       	mov    0x805144,%eax
  802d04:	40                   	inc    %eax
  802d05:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802d0a:	e9 73 07 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	8b 50 08             	mov    0x8(%eax),%edx
  802d15:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d1a:	8b 40 08             	mov    0x8(%eax),%eax
  802d1d:	39 c2                	cmp    %eax,%edx
  802d1f:	0f 86 84 00 00 00    	jbe    802da9 <insert_sorted_with_merge_freeList+0x134>
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	8b 50 08             	mov    0x8(%eax),%edx
  802d2b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d30:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d33:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d38:	8b 40 08             	mov    0x8(%eax),%eax
  802d3b:	01 c8                	add    %ecx,%eax
  802d3d:	39 c2                	cmp    %eax,%edx
  802d3f:	74 68                	je     802da9 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802d41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d45:	75 17                	jne    802d5e <insert_sorted_with_merge_freeList+0xe9>
  802d47:	83 ec 04             	sub    $0x4,%esp
  802d4a:	68 6c 42 80 00       	push   $0x80426c
  802d4f:	68 4c 01 00 00       	push   $0x14c
  802d54:	68 53 42 80 00       	push   $0x804253
  802d59:	e8 55 d9 ff ff       	call   8006b3 <_panic>
  802d5e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	89 50 04             	mov    %edx,0x4(%eax)
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0c                	je     802d80 <insert_sorted_with_merge_freeList+0x10b>
  802d74:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d79:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7c:	89 10                	mov    %edx,(%eax)
  802d7e:	eb 08                	jmp    802d88 <insert_sorted_with_merge_freeList+0x113>
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	a3 38 51 80 00       	mov    %eax,0x805138
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d99:	a1 44 51 80 00       	mov    0x805144,%eax
  802d9e:	40                   	inc    %eax
  802d9f:	a3 44 51 80 00       	mov    %eax,0x805144
  802da4:	e9 d9 06 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 50 08             	mov    0x8(%eax),%edx
  802daf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802db4:	8b 40 08             	mov    0x8(%eax),%eax
  802db7:	39 c2                	cmp    %eax,%edx
  802db9:	0f 86 b5 00 00 00    	jbe    802e74 <insert_sorted_with_merge_freeList+0x1ff>
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 50 08             	mov    0x8(%eax),%edx
  802dc5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dca:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dcd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dd2:	8b 40 08             	mov    0x8(%eax),%eax
  802dd5:	01 c8                	add    %ecx,%eax
  802dd7:	39 c2                	cmp    %eax,%edx
  802dd9:	0f 85 95 00 00 00    	jne    802e74 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802ddf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802dea:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ded:	8b 55 08             	mov    0x8(%ebp),%edx
  802df0:	8b 52 0c             	mov    0xc(%edx),%edx
  802df3:	01 ca                	add    %ecx,%edx
  802df5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e10:	75 17                	jne    802e29 <insert_sorted_with_merge_freeList+0x1b4>
  802e12:	83 ec 04             	sub    $0x4,%esp
  802e15:	68 30 42 80 00       	push   $0x804230
  802e1a:	68 54 01 00 00       	push   $0x154
  802e1f:	68 53 42 80 00       	push   $0x804253
  802e24:	e8 8a d8 ff ff       	call   8006b3 <_panic>
  802e29:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	89 10                	mov    %edx,(%eax)
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	74 0d                	je     802e4a <insert_sorted_with_merge_freeList+0x1d5>
  802e3d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e42:	8b 55 08             	mov    0x8(%ebp),%edx
  802e45:	89 50 04             	mov    %edx,0x4(%eax)
  802e48:	eb 08                	jmp    802e52 <insert_sorted_with_merge_freeList+0x1dd>
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e64:	a1 54 51 80 00       	mov    0x805154,%eax
  802e69:	40                   	inc    %eax
  802e6a:	a3 54 51 80 00       	mov    %eax,0x805154
  802e6f:	e9 0e 06 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 50 08             	mov    0x8(%eax),%edx
  802e7a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7f:	8b 40 08             	mov    0x8(%eax),%eax
  802e82:	39 c2                	cmp    %eax,%edx
  802e84:	0f 83 c1 00 00 00    	jae    802f4b <insert_sorted_with_merge_freeList+0x2d6>
  802e8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8f:	8b 50 08             	mov    0x8(%eax),%edx
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 48 08             	mov    0x8(%eax),%ecx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	01 c8                	add    %ecx,%eax
  802ea0:	39 c2                	cmp    %eax,%edx
  802ea2:	0f 85 a3 00 00 00    	jne    802f4b <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ea8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ead:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb0:	8b 52 08             	mov    0x8(%edx),%edx
  802eb3:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802eb6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ec1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec7:	8b 52 0c             	mov    0xc(%edx),%edx
  802eca:	01 ca                	add    %ecx,%edx
  802ecc:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ee3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee7:	75 17                	jne    802f00 <insert_sorted_with_merge_freeList+0x28b>
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	68 30 42 80 00       	push   $0x804230
  802ef1:	68 5d 01 00 00       	push   $0x15d
  802ef6:	68 53 42 80 00       	push   $0x804253
  802efb:	e8 b3 d7 ff ff       	call   8006b3 <_panic>
  802f00:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	89 10                	mov    %edx,(%eax)
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 0d                	je     802f21 <insert_sorted_with_merge_freeList+0x2ac>
  802f14:	a1 48 51 80 00       	mov    0x805148,%eax
  802f19:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1c:	89 50 04             	mov    %edx,0x4(%eax)
  802f1f:	eb 08                	jmp    802f29 <insert_sorted_with_merge_freeList+0x2b4>
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f40:	40                   	inc    %eax
  802f41:	a3 54 51 80 00       	mov    %eax,0x805154
  802f46:	e9 37 05 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 50 08             	mov    0x8(%eax),%edx
  802f51:	a1 38 51 80 00       	mov    0x805138,%eax
  802f56:	8b 40 08             	mov    0x8(%eax),%eax
  802f59:	39 c2                	cmp    %eax,%edx
  802f5b:	0f 83 82 00 00 00    	jae    802fe3 <insert_sorted_with_merge_freeList+0x36e>
  802f61:	a1 38 51 80 00       	mov    0x805138,%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	8b 48 08             	mov    0x8(%eax),%ecx
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	01 c8                	add    %ecx,%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	74 68                	je     802fe3 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7f:	75 17                	jne    802f98 <insert_sorted_with_merge_freeList+0x323>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 30 42 80 00       	push   $0x804230
  802f89:	68 62 01 00 00       	push   $0x162
  802f8e:	68 53 42 80 00       	push   $0x804253
  802f93:	e8 1b d7 ff ff       	call   8006b3 <_panic>
  802f98:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	89 10                	mov    %edx,(%eax)
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0d                	je     802fb9 <insert_sorted_with_merge_freeList+0x344>
  802fac:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb4:	89 50 04             	mov    %edx,0x4(%eax)
  802fb7:	eb 08                	jmp    802fc1 <insert_sorted_with_merge_freeList+0x34c>
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd8:	40                   	inc    %eax
  802fd9:	a3 44 51 80 00       	mov    %eax,0x805144
  802fde:	e9 9f 04 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802fe3:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802fed:	e9 84 04 00 00       	jmp    803476 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	8b 40 08             	mov    0x8(%eax),%eax
  802ffe:	39 c2                	cmp    %eax,%edx
  803000:	0f 86 a9 00 00 00    	jbe    8030af <insert_sorted_with_merge_freeList+0x43a>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 50 08             	mov    0x8(%eax),%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 48 08             	mov    0x8(%eax),%ecx
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 40 0c             	mov    0xc(%eax),%eax
  803018:	01 c8                	add    %ecx,%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	0f 84 8d 00 00 00    	je     8030af <insert_sorted_with_merge_freeList+0x43a>
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 50 08             	mov    0x8(%eax),%edx
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 40 04             	mov    0x4(%eax),%eax
  80302e:	8b 48 08             	mov    0x8(%eax),%ecx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 40 04             	mov    0x4(%eax),%eax
  803037:	8b 40 0c             	mov    0xc(%eax),%eax
  80303a:	01 c8                	add    %ecx,%eax
  80303c:	39 c2                	cmp    %eax,%edx
  80303e:	74 6f                	je     8030af <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803040:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803044:	74 06                	je     80304c <insert_sorted_with_merge_freeList+0x3d7>
  803046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304a:	75 17                	jne    803063 <insert_sorted_with_merge_freeList+0x3ee>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 90 42 80 00       	push   $0x804290
  803054:	68 6b 01 00 00       	push   $0x16b
  803059:	68 53 42 80 00       	push   $0x804253
  80305e:	e8 50 d6 ff ff       	call   8006b3 <_panic>
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	8b 50 04             	mov    0x4(%eax),%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803075:	89 10                	mov    %edx,(%eax)
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	74 0d                	je     80308e <insert_sorted_with_merge_freeList+0x419>
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 40 04             	mov    0x4(%eax),%eax
  803087:	8b 55 08             	mov    0x8(%ebp),%edx
  80308a:	89 10                	mov    %edx,(%eax)
  80308c:	eb 08                	jmp    803096 <insert_sorted_with_merge_freeList+0x421>
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	a3 38 51 80 00       	mov    %eax,0x805138
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 55 08             	mov    0x8(%ebp),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a4:	40                   	inc    %eax
  8030a5:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8030aa:	e9 d3 03 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 50 08             	mov    0x8(%eax),%edx
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	8b 40 08             	mov    0x8(%eax),%eax
  8030bb:	39 c2                	cmp    %eax,%edx
  8030bd:	0f 86 da 00 00 00    	jbe    80319d <insert_sorted_with_merge_freeList+0x528>
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 50 08             	mov    0x8(%eax),%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	8b 48 08             	mov    0x8(%eax),%ecx
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d5:	01 c8                	add    %ecx,%eax
  8030d7:	39 c2                	cmp    %eax,%edx
  8030d9:	0f 85 be 00 00 00    	jne    80319d <insert_sorted_with_merge_freeList+0x528>
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 50 08             	mov    0x8(%eax),%edx
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	01 c8                	add    %ecx,%eax
  8030f9:	39 c2                	cmp    %eax,%edx
  8030fb:	0f 84 9c 00 00 00    	je     80319d <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	8b 50 08             	mov    0x8(%eax),%edx
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 50 0c             	mov    0xc(%eax),%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	8b 40 0c             	mov    0xc(%eax),%eax
  803119:	01 c2                	add    %eax,%edx
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803139:	75 17                	jne    803152 <insert_sorted_with_merge_freeList+0x4dd>
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	68 30 42 80 00       	push   $0x804230
  803143:	68 74 01 00 00       	push   $0x174
  803148:	68 53 42 80 00       	push   $0x804253
  80314d:	e8 61 d5 ff ff       	call   8006b3 <_panic>
  803152:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	89 10                	mov    %edx,(%eax)
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	74 0d                	je     803173 <insert_sorted_with_merge_freeList+0x4fe>
  803166:	a1 48 51 80 00       	mov    0x805148,%eax
  80316b:	8b 55 08             	mov    0x8(%ebp),%edx
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	eb 08                	jmp    80317b <insert_sorted_with_merge_freeList+0x506>
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	a3 48 51 80 00       	mov    %eax,0x805148
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318d:	a1 54 51 80 00       	mov    0x805154,%eax
  803192:	40                   	inc    %eax
  803193:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803198:	e9 e5 02 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	8b 50 08             	mov    0x8(%eax),%edx
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 40 08             	mov    0x8(%eax),%eax
  8031a9:	39 c2                	cmp    %eax,%edx
  8031ab:	0f 86 d7 00 00 00    	jbe    803288 <insert_sorted_with_merge_freeList+0x613>
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	8b 50 08             	mov    0x8(%eax),%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 48 08             	mov    0x8(%eax),%ecx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c3:	01 c8                	add    %ecx,%eax
  8031c5:	39 c2                	cmp    %eax,%edx
  8031c7:	0f 84 bb 00 00 00    	je     803288 <insert_sorted_with_merge_freeList+0x613>
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	8b 50 08             	mov    0x8(%eax),%edx
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 04             	mov    0x4(%eax),%eax
  8031e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e5:	01 c8                	add    %ecx,%eax
  8031e7:	39 c2                	cmp    %eax,%edx
  8031e9:	0f 85 99 00 00 00    	jne    803288 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	8b 40 0c             	mov    0xc(%eax),%eax
  803204:	01 c2                	add    %eax,%edx
  803206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803209:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803224:	75 17                	jne    80323d <insert_sorted_with_merge_freeList+0x5c8>
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	68 30 42 80 00       	push   $0x804230
  80322e:	68 7d 01 00 00       	push   $0x17d
  803233:	68 53 42 80 00       	push   $0x804253
  803238:	e8 76 d4 ff ff       	call   8006b3 <_panic>
  80323d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	89 10                	mov    %edx,(%eax)
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	85 c0                	test   %eax,%eax
  80324f:	74 0d                	je     80325e <insert_sorted_with_merge_freeList+0x5e9>
  803251:	a1 48 51 80 00       	mov    0x805148,%eax
  803256:	8b 55 08             	mov    0x8(%ebp),%edx
  803259:	89 50 04             	mov    %edx,0x4(%eax)
  80325c:	eb 08                	jmp    803266 <insert_sorted_with_merge_freeList+0x5f1>
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	a3 48 51 80 00       	mov    %eax,0x805148
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803278:	a1 54 51 80 00       	mov    0x805154,%eax
  80327d:	40                   	inc    %eax
  80327e:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803283:	e9 fa 01 00 00       	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 50 08             	mov    0x8(%eax),%edx
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	0f 86 d2 01 00 00    	jbe    80346e <insert_sorted_with_merge_freeList+0x7f9>
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	8b 50 08             	mov    0x8(%eax),%edx
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	8b 48 08             	mov    0x8(%eax),%ecx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ae:	01 c8                	add    %ecx,%eax
  8032b0:	39 c2                	cmp    %eax,%edx
  8032b2:	0f 85 b6 01 00 00    	jne    80346e <insert_sorted_with_merge_freeList+0x7f9>
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 50 08             	mov    0x8(%eax),%edx
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 04             	mov    0x4(%eax),%eax
  8032c4:	8b 48 08             	mov    0x8(%eax),%ecx
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 40 04             	mov    0x4(%eax),%eax
  8032cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d0:	01 c8                	add    %ecx,%eax
  8032d2:	39 c2                	cmp    %eax,%edx
  8032d4:	0f 85 94 01 00 00    	jne    80346e <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e3:	8b 52 04             	mov    0x4(%edx),%edx
  8032e6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8032e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ec:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8032ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8032f5:	01 da                	add    %ebx,%edx
  8032f7:	01 ca                	add    %ecx,%edx
  8032f9:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803314:	75 17                	jne    80332d <insert_sorted_with_merge_freeList+0x6b8>
  803316:	83 ec 04             	sub    $0x4,%esp
  803319:	68 c5 42 80 00       	push   $0x8042c5
  80331e:	68 86 01 00 00       	push   $0x186
  803323:	68 53 42 80 00       	push   $0x804253
  803328:	e8 86 d3 ff ff       	call   8006b3 <_panic>
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 10                	je     803346 <insert_sorted_with_merge_freeList+0x6d1>
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333e:	8b 52 04             	mov    0x4(%edx),%edx
  803341:	89 50 04             	mov    %edx,0x4(%eax)
  803344:	eb 0b                	jmp    803351 <insert_sorted_with_merge_freeList+0x6dc>
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	8b 40 04             	mov    0x4(%eax),%eax
  80334c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 40 04             	mov    0x4(%eax),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	74 0f                	je     80336a <insert_sorted_with_merge_freeList+0x6f5>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803364:	8b 12                	mov    (%edx),%edx
  803366:	89 10                	mov    %edx,(%eax)
  803368:	eb 0a                	jmp    803374 <insert_sorted_with_merge_freeList+0x6ff>
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	a3 38 51 80 00       	mov    %eax,0x805138
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803387:	a1 44 51 80 00       	mov    0x805144,%eax
  80338c:	48                   	dec    %eax
  80338d:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803392:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803396:	75 17                	jne    8033af <insert_sorted_with_merge_freeList+0x73a>
  803398:	83 ec 04             	sub    $0x4,%esp
  80339b:	68 30 42 80 00       	push   $0x804230
  8033a0:	68 87 01 00 00       	push   $0x187
  8033a5:	68 53 42 80 00       	push   $0x804253
  8033aa:	e8 04 d3 ff ff       	call   8006b3 <_panic>
  8033af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	89 10                	mov    %edx,(%eax)
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	74 0d                	je     8033d0 <insert_sorted_with_merge_freeList+0x75b>
  8033c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033cb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ce:	eb 08                	jmp    8033d8 <insert_sorted_with_merge_freeList+0x763>
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ef:	40                   	inc    %eax
  8033f0:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803409:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340d:	75 17                	jne    803426 <insert_sorted_with_merge_freeList+0x7b1>
  80340f:	83 ec 04             	sub    $0x4,%esp
  803412:	68 30 42 80 00       	push   $0x804230
  803417:	68 8a 01 00 00       	push   $0x18a
  80341c:	68 53 42 80 00       	push   $0x804253
  803421:	e8 8d d2 ff ff       	call   8006b3 <_panic>
  803426:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	89 10                	mov    %edx,(%eax)
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	74 0d                	je     803447 <insert_sorted_with_merge_freeList+0x7d2>
  80343a:	a1 48 51 80 00       	mov    0x805148,%eax
  80343f:	8b 55 08             	mov    0x8(%ebp),%edx
  803442:	89 50 04             	mov    %edx,0x4(%eax)
  803445:	eb 08                	jmp    80344f <insert_sorted_with_merge_freeList+0x7da>
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	a3 48 51 80 00       	mov    %eax,0x805148
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803461:	a1 54 51 80 00       	mov    0x805154,%eax
  803466:	40                   	inc    %eax
  803467:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  80346c:	eb 14                	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 00                	mov    (%eax),%eax
  803473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347a:	0f 85 72 fb ff ff    	jne    802ff2 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803480:	eb 00                	jmp    803482 <insert_sorted_with_merge_freeList+0x80d>
  803482:	90                   	nop
  803483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803486:	c9                   	leave  
  803487:	c3                   	ret    

00803488 <__udivdi3>:
  803488:	55                   	push   %ebp
  803489:	57                   	push   %edi
  80348a:	56                   	push   %esi
  80348b:	53                   	push   %ebx
  80348c:	83 ec 1c             	sub    $0x1c,%esp
  80348f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803493:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803497:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80349b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80349f:	89 ca                	mov    %ecx,%edx
  8034a1:	89 f8                	mov    %edi,%eax
  8034a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034a7:	85 f6                	test   %esi,%esi
  8034a9:	75 2d                	jne    8034d8 <__udivdi3+0x50>
  8034ab:	39 cf                	cmp    %ecx,%edi
  8034ad:	77 65                	ja     803514 <__udivdi3+0x8c>
  8034af:	89 fd                	mov    %edi,%ebp
  8034b1:	85 ff                	test   %edi,%edi
  8034b3:	75 0b                	jne    8034c0 <__udivdi3+0x38>
  8034b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ba:	31 d2                	xor    %edx,%edx
  8034bc:	f7 f7                	div    %edi
  8034be:	89 c5                	mov    %eax,%ebp
  8034c0:	31 d2                	xor    %edx,%edx
  8034c2:	89 c8                	mov    %ecx,%eax
  8034c4:	f7 f5                	div    %ebp
  8034c6:	89 c1                	mov    %eax,%ecx
  8034c8:	89 d8                	mov    %ebx,%eax
  8034ca:	f7 f5                	div    %ebp
  8034cc:	89 cf                	mov    %ecx,%edi
  8034ce:	89 fa                	mov    %edi,%edx
  8034d0:	83 c4 1c             	add    $0x1c,%esp
  8034d3:	5b                   	pop    %ebx
  8034d4:	5e                   	pop    %esi
  8034d5:	5f                   	pop    %edi
  8034d6:	5d                   	pop    %ebp
  8034d7:	c3                   	ret    
  8034d8:	39 ce                	cmp    %ecx,%esi
  8034da:	77 28                	ja     803504 <__udivdi3+0x7c>
  8034dc:	0f bd fe             	bsr    %esi,%edi
  8034df:	83 f7 1f             	xor    $0x1f,%edi
  8034e2:	75 40                	jne    803524 <__udivdi3+0x9c>
  8034e4:	39 ce                	cmp    %ecx,%esi
  8034e6:	72 0a                	jb     8034f2 <__udivdi3+0x6a>
  8034e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034ec:	0f 87 9e 00 00 00    	ja     803590 <__udivdi3+0x108>
  8034f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f7:	89 fa                	mov    %edi,%edx
  8034f9:	83 c4 1c             	add    $0x1c,%esp
  8034fc:	5b                   	pop    %ebx
  8034fd:	5e                   	pop    %esi
  8034fe:	5f                   	pop    %edi
  8034ff:	5d                   	pop    %ebp
  803500:	c3                   	ret    
  803501:	8d 76 00             	lea    0x0(%esi),%esi
  803504:	31 ff                	xor    %edi,%edi
  803506:	31 c0                	xor    %eax,%eax
  803508:	89 fa                	mov    %edi,%edx
  80350a:	83 c4 1c             	add    $0x1c,%esp
  80350d:	5b                   	pop    %ebx
  80350e:	5e                   	pop    %esi
  80350f:	5f                   	pop    %edi
  803510:	5d                   	pop    %ebp
  803511:	c3                   	ret    
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 d8                	mov    %ebx,%eax
  803516:	f7 f7                	div    %edi
  803518:	31 ff                	xor    %edi,%edi
  80351a:	89 fa                	mov    %edi,%edx
  80351c:	83 c4 1c             	add    $0x1c,%esp
  80351f:	5b                   	pop    %ebx
  803520:	5e                   	pop    %esi
  803521:	5f                   	pop    %edi
  803522:	5d                   	pop    %ebp
  803523:	c3                   	ret    
  803524:	bd 20 00 00 00       	mov    $0x20,%ebp
  803529:	89 eb                	mov    %ebp,%ebx
  80352b:	29 fb                	sub    %edi,%ebx
  80352d:	89 f9                	mov    %edi,%ecx
  80352f:	d3 e6                	shl    %cl,%esi
  803531:	89 c5                	mov    %eax,%ebp
  803533:	88 d9                	mov    %bl,%cl
  803535:	d3 ed                	shr    %cl,%ebp
  803537:	89 e9                	mov    %ebp,%ecx
  803539:	09 f1                	or     %esi,%ecx
  80353b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80353f:	89 f9                	mov    %edi,%ecx
  803541:	d3 e0                	shl    %cl,%eax
  803543:	89 c5                	mov    %eax,%ebp
  803545:	89 d6                	mov    %edx,%esi
  803547:	88 d9                	mov    %bl,%cl
  803549:	d3 ee                	shr    %cl,%esi
  80354b:	89 f9                	mov    %edi,%ecx
  80354d:	d3 e2                	shl    %cl,%edx
  80354f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803553:	88 d9                	mov    %bl,%cl
  803555:	d3 e8                	shr    %cl,%eax
  803557:	09 c2                	or     %eax,%edx
  803559:	89 d0                	mov    %edx,%eax
  80355b:	89 f2                	mov    %esi,%edx
  80355d:	f7 74 24 0c          	divl   0xc(%esp)
  803561:	89 d6                	mov    %edx,%esi
  803563:	89 c3                	mov    %eax,%ebx
  803565:	f7 e5                	mul    %ebp
  803567:	39 d6                	cmp    %edx,%esi
  803569:	72 19                	jb     803584 <__udivdi3+0xfc>
  80356b:	74 0b                	je     803578 <__udivdi3+0xf0>
  80356d:	89 d8                	mov    %ebx,%eax
  80356f:	31 ff                	xor    %edi,%edi
  803571:	e9 58 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  803576:	66 90                	xchg   %ax,%ax
  803578:	8b 54 24 08          	mov    0x8(%esp),%edx
  80357c:	89 f9                	mov    %edi,%ecx
  80357e:	d3 e2                	shl    %cl,%edx
  803580:	39 c2                	cmp    %eax,%edx
  803582:	73 e9                	jae    80356d <__udivdi3+0xe5>
  803584:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803587:	31 ff                	xor    %edi,%edi
  803589:	e9 40 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  80358e:	66 90                	xchg   %ax,%ax
  803590:	31 c0                	xor    %eax,%eax
  803592:	e9 37 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  803597:	90                   	nop

00803598 <__umoddi3>:
  803598:	55                   	push   %ebp
  803599:	57                   	push   %edi
  80359a:	56                   	push   %esi
  80359b:	53                   	push   %ebx
  80359c:	83 ec 1c             	sub    $0x1c,%esp
  80359f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035b7:	89 f3                	mov    %esi,%ebx
  8035b9:	89 fa                	mov    %edi,%edx
  8035bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035bf:	89 34 24             	mov    %esi,(%esp)
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 1a                	jne    8035e0 <__umoddi3+0x48>
  8035c6:	39 f7                	cmp    %esi,%edi
  8035c8:	0f 86 a2 00 00 00    	jbe    803670 <__umoddi3+0xd8>
  8035ce:	89 c8                	mov    %ecx,%eax
  8035d0:	89 f2                	mov    %esi,%edx
  8035d2:	f7 f7                	div    %edi
  8035d4:	89 d0                	mov    %edx,%eax
  8035d6:	31 d2                	xor    %edx,%edx
  8035d8:	83 c4 1c             	add    $0x1c,%esp
  8035db:	5b                   	pop    %ebx
  8035dc:	5e                   	pop    %esi
  8035dd:	5f                   	pop    %edi
  8035de:	5d                   	pop    %ebp
  8035df:	c3                   	ret    
  8035e0:	39 f0                	cmp    %esi,%eax
  8035e2:	0f 87 ac 00 00 00    	ja     803694 <__umoddi3+0xfc>
  8035e8:	0f bd e8             	bsr    %eax,%ebp
  8035eb:	83 f5 1f             	xor    $0x1f,%ebp
  8035ee:	0f 84 ac 00 00 00    	je     8036a0 <__umoddi3+0x108>
  8035f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035f9:	29 ef                	sub    %ebp,%edi
  8035fb:	89 fe                	mov    %edi,%esi
  8035fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803601:	89 e9                	mov    %ebp,%ecx
  803603:	d3 e0                	shl    %cl,%eax
  803605:	89 d7                	mov    %edx,%edi
  803607:	89 f1                	mov    %esi,%ecx
  803609:	d3 ef                	shr    %cl,%edi
  80360b:	09 c7                	or     %eax,%edi
  80360d:	89 e9                	mov    %ebp,%ecx
  80360f:	d3 e2                	shl    %cl,%edx
  803611:	89 14 24             	mov    %edx,(%esp)
  803614:	89 d8                	mov    %ebx,%eax
  803616:	d3 e0                	shl    %cl,%eax
  803618:	89 c2                	mov    %eax,%edx
  80361a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361e:	d3 e0                	shl    %cl,%eax
  803620:	89 44 24 04          	mov    %eax,0x4(%esp)
  803624:	8b 44 24 08          	mov    0x8(%esp),%eax
  803628:	89 f1                	mov    %esi,%ecx
  80362a:	d3 e8                	shr    %cl,%eax
  80362c:	09 d0                	or     %edx,%eax
  80362e:	d3 eb                	shr    %cl,%ebx
  803630:	89 da                	mov    %ebx,%edx
  803632:	f7 f7                	div    %edi
  803634:	89 d3                	mov    %edx,%ebx
  803636:	f7 24 24             	mull   (%esp)
  803639:	89 c6                	mov    %eax,%esi
  80363b:	89 d1                	mov    %edx,%ecx
  80363d:	39 d3                	cmp    %edx,%ebx
  80363f:	0f 82 87 00 00 00    	jb     8036cc <__umoddi3+0x134>
  803645:	0f 84 91 00 00 00    	je     8036dc <__umoddi3+0x144>
  80364b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80364f:	29 f2                	sub    %esi,%edx
  803651:	19 cb                	sbb    %ecx,%ebx
  803653:	89 d8                	mov    %ebx,%eax
  803655:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803659:	d3 e0                	shl    %cl,%eax
  80365b:	89 e9                	mov    %ebp,%ecx
  80365d:	d3 ea                	shr    %cl,%edx
  80365f:	09 d0                	or     %edx,%eax
  803661:	89 e9                	mov    %ebp,%ecx
  803663:	d3 eb                	shr    %cl,%ebx
  803665:	89 da                	mov    %ebx,%edx
  803667:	83 c4 1c             	add    $0x1c,%esp
  80366a:	5b                   	pop    %ebx
  80366b:	5e                   	pop    %esi
  80366c:	5f                   	pop    %edi
  80366d:	5d                   	pop    %ebp
  80366e:	c3                   	ret    
  80366f:	90                   	nop
  803670:	89 fd                	mov    %edi,%ebp
  803672:	85 ff                	test   %edi,%edi
  803674:	75 0b                	jne    803681 <__umoddi3+0xe9>
  803676:	b8 01 00 00 00       	mov    $0x1,%eax
  80367b:	31 d2                	xor    %edx,%edx
  80367d:	f7 f7                	div    %edi
  80367f:	89 c5                	mov    %eax,%ebp
  803681:	89 f0                	mov    %esi,%eax
  803683:	31 d2                	xor    %edx,%edx
  803685:	f7 f5                	div    %ebp
  803687:	89 c8                	mov    %ecx,%eax
  803689:	f7 f5                	div    %ebp
  80368b:	89 d0                	mov    %edx,%eax
  80368d:	e9 44 ff ff ff       	jmp    8035d6 <__umoddi3+0x3e>
  803692:	66 90                	xchg   %ax,%ax
  803694:	89 c8                	mov    %ecx,%eax
  803696:	89 f2                	mov    %esi,%edx
  803698:	83 c4 1c             	add    $0x1c,%esp
  80369b:	5b                   	pop    %ebx
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	3b 04 24             	cmp    (%esp),%eax
  8036a3:	72 06                	jb     8036ab <__umoddi3+0x113>
  8036a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036a9:	77 0f                	ja     8036ba <__umoddi3+0x122>
  8036ab:	89 f2                	mov    %esi,%edx
  8036ad:	29 f9                	sub    %edi,%ecx
  8036af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036b3:	89 14 24             	mov    %edx,(%esp)
  8036b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036be:	8b 14 24             	mov    (%esp),%edx
  8036c1:	83 c4 1c             	add    $0x1c,%esp
  8036c4:	5b                   	pop    %ebx
  8036c5:	5e                   	pop    %esi
  8036c6:	5f                   	pop    %edi
  8036c7:	5d                   	pop    %ebp
  8036c8:	c3                   	ret    
  8036c9:	8d 76 00             	lea    0x0(%esi),%esi
  8036cc:	2b 04 24             	sub    (%esp),%eax
  8036cf:	19 fa                	sbb    %edi,%edx
  8036d1:	89 d1                	mov    %edx,%ecx
  8036d3:	89 c6                	mov    %eax,%esi
  8036d5:	e9 71 ff ff ff       	jmp    80364b <__umoddi3+0xb3>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e0:	72 ea                	jb     8036cc <__umoddi3+0x134>
  8036e2:	89 d9                	mov    %ebx,%ecx
  8036e4:	e9 62 ff ff ff       	jmp    80364b <__umoddi3+0xb3>
