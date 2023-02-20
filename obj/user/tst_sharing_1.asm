
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 2f 03 00 00       	call   800365 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80008d:	68 e0 34 80 00       	push   $0x8034e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 34 80 00       	push   $0x8034fc
  800099:	e8 03 04 00 00       	call   8004a1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 fd 15 00 00       	call   8016a5 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 14 35 80 00       	push   $0x803514
  8000b3:	e8 9d 06 00 00       	call   800755 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 49 1a 00 00       	call   801b09 <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 4b 35 80 00       	push   $0x80354b
  8000d2:	e8 2f 17 00 00       	call   801806 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address  %x        %x",x,USER_HEAP_START);
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 1c                	je     800102 <_main+0xca>
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 00 00 00 80       	push   $0x80000000
  8000ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f1:	68 50 35 80 00       	push   $0x803550
  8000f6:	6a 1e                	push   $0x1e
  8000f8:	68 fc 34 80 00       	push   $0x8034fc
  8000fd:	e8 9f 03 00 00       	call   8004a1 <_panic>
		expected = 1+1+2 ;
  800102:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800109:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80010c:	e8 f8 19 00 00       	call   801b09 <sys_calculate_free_frames>
  800111:	29 c3                	sub    %eax,%ebx
  800113:	89 d8                	mov    %ebx,%eax
  800115:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800118:	74 24                	je     80013e <_main+0x106>
  80011a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80011d:	e8 e7 19 00 00       	call   801b09 <sys_calculate_free_frames>
  800122:	29 c3                	sub    %eax,%ebx
  800124:	89 d8                	mov    %ebx,%eax
  800126:	83 ec 0c             	sub    $0xc,%esp
  800129:	ff 75 e0             	pushl  -0x20(%ebp)
  80012c:	50                   	push   %eax
  80012d:	68 cc 35 80 00       	push   $0x8035cc
  800132:	6a 20                	push   $0x20
  800134:	68 fc 34 80 00       	push   $0x8034fc
  800139:	e8 63 03 00 00       	call   8004a1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80013e:	e8 c6 19 00 00       	call   801b09 <sys_calculate_free_frames>
  800143:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	6a 01                	push   $0x1
  80014b:	68 04 10 00 00       	push   $0x1004
  800150:	68 64 36 80 00       	push   $0x803664
  800155:	e8 ac 16 00 00       	call   801806 <smalloc>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800160:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  800167:	74 14                	je     80017d <_main+0x145>
  800169:	83 ec 04             	sub    $0x4,%esp
  80016c:	68 68 36 80 00       	push   $0x803668
  800171:	6a 24                	push   $0x24
  800173:	68 fc 34 80 00       	push   $0x8034fc
  800178:	e8 24 03 00 00       	call   8004a1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80017d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800180:	e8 84 19 00 00       	call   801b09 <sys_calculate_free_frames>
  800185:	29 c3                	sub    %eax,%ebx
  800187:	89 d8                	mov    %ebx,%eax
  800189:	83 f8 04             	cmp    $0x4,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 d4 36 80 00       	push   $0x8036d4
  800196:	6a 25                	push   $0x25
  800198:	68 fc 34 80 00       	push   $0x8034fc
  80019d:	e8 ff 02 00 00       	call   8004a1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001a2:	e8 62 19 00 00       	call   801b09 <sys_calculate_free_frames>
  8001a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	6a 01                	push   $0x1
  8001af:	6a 04                	push   $0x4
  8001b1:	68 52 37 80 00       	push   $0x803752
  8001b6:	e8 4b 16 00 00       	call   801806 <smalloc>
  8001bb:	83 c4 10             	add    $0x10,%esp
  8001be:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001c1:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c8:	74 14                	je     8001de <_main+0x1a6>
  8001ca:	83 ec 04             	sub    $0x4,%esp
  8001cd:	68 68 36 80 00       	push   $0x803668
  8001d2:	6a 29                	push   $0x29
  8001d4:	68 fc 34 80 00       	push   $0x8034fc
  8001d9:	e8 c3 02 00 00       	call   8004a1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001de:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001e1:	e8 23 19 00 00       	call   801b09 <sys_calculate_free_frames>
  8001e6:	29 c3                	sub    %eax,%ebx
  8001e8:	89 d8                	mov    %ebx,%eax
  8001ea:	83 f8 03             	cmp    $0x3,%eax
  8001ed:	74 14                	je     800203 <_main+0x1cb>
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	68 d4 36 80 00       	push   $0x8036d4
  8001f7:	6a 2a                	push   $0x2a
  8001f9:	68 fc 34 80 00       	push   $0x8034fc
  8001fe:	e8 9e 02 00 00       	call   8004a1 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 54 37 80 00       	push   $0x803754
  80020b:	e8 45 05 00 00       	call   800755 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	68 7c 37 80 00       	push   $0x80377c
  80021b:	e8 35 05 00 00       	call   800755 <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800223:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  80022a:	eb 2d                	jmp    800259 <_main+0x221>
		{
			x[i] = -1;
  80022c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800239:	01 d0                	add    %edx,%eax
  80023b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024e:	01 d0                	add    %edx,%eax
  800250:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800256:	ff 45 ec             	incl   -0x14(%ebp)
  800259:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800260:	7e ca                	jle    80022c <_main+0x1f4>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800262:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800269:	eb 18                	jmp    800283 <_main+0x24b>
		{
			z[i] = -1;
  80026b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800278:	01 d0                	add    %edx,%eax
  80027a:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800280:	ff 45 ec             	incl   -0x14(%ebp)
  800283:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  80028a:	7e df                	jle    80026b <_main+0x233>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80028c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028f:	8b 00                	mov    (%eax),%eax
  800291:	83 f8 ff             	cmp    $0xffffffff,%eax
  800294:	74 14                	je     8002aa <_main+0x272>
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	68 a4 37 80 00       	push   $0x8037a4
  80029e:	6a 3e                	push   $0x3e
  8002a0:	68 fc 34 80 00       	push   $0x8034fc
  8002a5:	e8 f7 01 00 00       	call   8004a1 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ad:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002b2:	8b 00                	mov    (%eax),%eax
  8002b4:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b7:	74 14                	je     8002cd <_main+0x295>
  8002b9:	83 ec 04             	sub    $0x4,%esp
  8002bc:	68 a4 37 80 00       	push   $0x8037a4
  8002c1:	6a 3f                	push   $0x3f
  8002c3:	68 fc 34 80 00       	push   $0x8034fc
  8002c8:	e8 d4 01 00 00       	call   8004a1 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d0:	8b 00                	mov    (%eax),%eax
  8002d2:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d5:	74 14                	je     8002eb <_main+0x2b3>
  8002d7:	83 ec 04             	sub    $0x4,%esp
  8002da:	68 a4 37 80 00       	push   $0x8037a4
  8002df:	6a 41                	push   $0x41
  8002e1:	68 fc 34 80 00       	push   $0x8034fc
  8002e6:	e8 b6 01 00 00       	call   8004a1 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ee:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002f3:	8b 00                	mov    (%eax),%eax
  8002f5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f8:	74 14                	je     80030e <_main+0x2d6>
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	68 a4 37 80 00       	push   $0x8037a4
  800302:	6a 42                	push   $0x42
  800304:	68 fc 34 80 00       	push   $0x8034fc
  800309:	e8 93 01 00 00       	call   8004a1 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	83 f8 ff             	cmp    $0xffffffff,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 a4 37 80 00       	push   $0x8037a4
  800320:	6a 44                	push   $0x44
  800322:	68 fc 34 80 00       	push   $0x8034fc
  800327:	e8 75 01 00 00       	call   8004a1 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80032c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032f:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	83 f8 ff             	cmp    $0xffffffff,%eax
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 a4 37 80 00       	push   $0x8037a4
  800343:	6a 45                	push   $0x45
  800345:	68 fc 34 80 00       	push   $0x8034fc
  80034a:	e8 52 01 00 00       	call   8004a1 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 d0 37 80 00       	push   $0x8037d0
  800357:	e8 f9 03 00 00       	call   800755 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp

	return;
  80035f:	90                   	nop
}
  800360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800363:	c9                   	leave  
  800364:	c3                   	ret    

00800365 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80036b:	e8 79 1a 00 00       	call   801de9 <sys_getenvindex>
  800370:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800376:	89 d0                	mov    %edx,%eax
  800378:	c1 e0 03             	shl    $0x3,%eax
  80037b:	01 d0                	add    %edx,%eax
  80037d:	01 c0                	add    %eax,%eax
  80037f:	01 d0                	add    %edx,%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	01 d0                	add    %edx,%eax
  80038a:	c1 e0 04             	shl    $0x4,%eax
  80038d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800392:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a2:	84 c0                	test   %al,%al
  8003a4:	74 0f                	je     8003b5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ab:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b9:	7e 0a                	jle    8003c5 <libmain+0x60>
		binaryname = argv[0];
  8003bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	ff 75 0c             	pushl  0xc(%ebp)
  8003cb:	ff 75 08             	pushl  0x8(%ebp)
  8003ce:	e8 65 fc ff ff       	call   800038 <_main>
  8003d3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003d6:	e8 1b 18 00 00       	call   801bf6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003db:	83 ec 0c             	sub    $0xc,%esp
  8003de:	68 3c 38 80 00       	push   $0x80383c
  8003e3:	e8 6d 03 00 00       	call   800755 <cprintf>
  8003e8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	52                   	push   %edx
  800405:	50                   	push   %eax
  800406:	68 64 38 80 00       	push   $0x803864
  80040b:	e8 45 03 00 00       	call   800755 <cprintf>
  800410:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800413:	a1 20 40 80 00       	mov    0x804020,%eax
  800418:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80041e:	a1 20 40 80 00       	mov    0x804020,%eax
  800423:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800434:	51                   	push   %ecx
  800435:	52                   	push   %edx
  800436:	50                   	push   %eax
  800437:	68 8c 38 80 00       	push   $0x80388c
  80043c:	e8 14 03 00 00       	call   800755 <cprintf>
  800441:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	50                   	push   %eax
  800453:	68 e4 38 80 00       	push   $0x8038e4
  800458:	e8 f8 02 00 00       	call   800755 <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800460:	83 ec 0c             	sub    $0xc,%esp
  800463:	68 3c 38 80 00       	push   $0x80383c
  800468:	e8 e8 02 00 00       	call   800755 <cprintf>
  80046d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800470:	e8 9b 17 00 00       	call   801c10 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800475:	e8 19 00 00 00       	call   800493 <exit>
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	6a 00                	push   $0x0
  800488:	e8 28 19 00 00       	call   801db5 <sys_destroy_env>
  80048d:	83 c4 10             	add    $0x10,%esp
}
  800490:	90                   	nop
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <exit>:

void
exit(void)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800499:	e8 7d 19 00 00       	call   801e1b <sys_exit_env>
}
  80049e:	90                   	nop
  80049f:	c9                   	leave  
  8004a0:	c3                   	ret    

008004a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8004aa:	83 c0 04             	add    $0x4,%eax
  8004ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004b5:	85 c0                	test   %eax,%eax
  8004b7:	74 16                	je     8004cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	50                   	push   %eax
  8004c2:	68 f8 38 80 00       	push   $0x8038f8
  8004c7:	e8 89 02 00 00       	call   800755 <cprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004cf:	a1 00 40 80 00       	mov    0x804000,%eax
  8004d4:	ff 75 0c             	pushl  0xc(%ebp)
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	50                   	push   %eax
  8004db:	68 fd 38 80 00       	push   $0x8038fd
  8004e0:	e8 70 02 00 00       	call   800755 <cprintf>
  8004e5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f1:	50                   	push   %eax
  8004f2:	e8 f3 01 00 00       	call   8006ea <vcprintf>
  8004f7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	6a 00                	push   $0x0
  8004ff:	68 19 39 80 00       	push   $0x803919
  800504:	e8 e1 01 00 00       	call   8006ea <vcprintf>
  800509:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80050c:	e8 82 ff ff ff       	call   800493 <exit>

	// should not return here
	while (1) ;
  800511:	eb fe                	jmp    800511 <_panic+0x70>

00800513 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800519:	a1 20 40 80 00       	mov    0x804020,%eax
  80051e:	8b 50 74             	mov    0x74(%eax),%edx
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
  800524:	39 c2                	cmp    %eax,%edx
  800526:	74 14                	je     80053c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800528:	83 ec 04             	sub    $0x4,%esp
  80052b:	68 1c 39 80 00       	push   $0x80391c
  800530:	6a 26                	push   $0x26
  800532:	68 68 39 80 00       	push   $0x803968
  800537:	e8 65 ff ff ff       	call   8004a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80054a:	e9 c2 00 00 00       	jmp    800611 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80054f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	01 d0                	add    %edx,%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	85 c0                	test   %eax,%eax
  800562:	75 08                	jne    80056c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800564:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800567:	e9 a2 00 00 00       	jmp    80060e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80056c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800573:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80057a:	eb 69                	jmp    8005e5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80057c:	a1 20 40 80 00       	mov    0x804020,%eax
  800581:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800587:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058a:	89 d0                	mov    %edx,%eax
  80058c:	01 c0                	add    %eax,%eax
  80058e:	01 d0                	add    %edx,%eax
  800590:	c1 e0 03             	shl    $0x3,%eax
  800593:	01 c8                	add    %ecx,%eax
  800595:	8a 40 04             	mov    0x4(%eax),%al
  800598:	84 c0                	test   %al,%al
  80059a:	75 46                	jne    8005e2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059c:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005aa:	89 d0                	mov    %edx,%eax
  8005ac:	01 c0                	add    %eax,%eax
  8005ae:	01 d0                	add    %edx,%eax
  8005b0:	c1 e0 03             	shl    $0x3,%eax
  8005b3:	01 c8                	add    %ecx,%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	01 c8                	add    %ecx,%eax
  8005d3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d5:	39 c2                	cmp    %eax,%edx
  8005d7:	75 09                	jne    8005e2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e0:	eb 12                	jmp    8005f4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e2:	ff 45 e8             	incl   -0x18(%ebp)
  8005e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ea:	8b 50 74             	mov    0x74(%eax),%edx
  8005ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f0:	39 c2                	cmp    %eax,%edx
  8005f2:	77 88                	ja     80057c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f8:	75 14                	jne    80060e <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	68 74 39 80 00       	push   $0x803974
  800602:	6a 3a                	push   $0x3a
  800604:	68 68 39 80 00       	push   $0x803968
  800609:	e8 93 fe ff ff       	call   8004a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060e:	ff 45 f0             	incl   -0x10(%ebp)
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800614:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800617:	0f 8c 32 ff ff ff    	jl     80054f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800624:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80062b:	eb 26                	jmp    800653 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062d:	a1 20 40 80 00       	mov    0x804020,%eax
  800632:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800638:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063b:	89 d0                	mov    %edx,%eax
  80063d:	01 c0                	add    %eax,%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	c1 e0 03             	shl    $0x3,%eax
  800644:	01 c8                	add    %ecx,%eax
  800646:	8a 40 04             	mov    0x4(%eax),%al
  800649:	3c 01                	cmp    $0x1,%al
  80064b:	75 03                	jne    800650 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80064d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800650:	ff 45 e0             	incl   -0x20(%ebp)
  800653:	a1 20 40 80 00       	mov    0x804020,%eax
  800658:	8b 50 74             	mov    0x74(%eax),%edx
  80065b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065e:	39 c2                	cmp    %eax,%edx
  800660:	77 cb                	ja     80062d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800665:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800668:	74 14                	je     80067e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	68 c8 39 80 00       	push   $0x8039c8
  800672:	6a 44                	push   $0x44
  800674:	68 68 39 80 00       	push   $0x803968
  800679:	e8 23 fe ff ff       	call   8004a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80067e:	90                   	nop
  80067f:	c9                   	leave  
  800680:	c3                   	ret    

00800681 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
  800684:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 48 01             	lea    0x1(%eax),%ecx
  80068f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800692:	89 0a                	mov    %ecx,(%edx)
  800694:	8b 55 08             	mov    0x8(%ebp),%edx
  800697:	88 d1                	mov    %dl,%cl
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006aa:	75 2c                	jne    8006d8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006ac:	a0 24 40 80 00       	mov    0x804024,%al
  8006b1:	0f b6 c0             	movzbl %al,%eax
  8006b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b7:	8b 12                	mov    (%edx),%edx
  8006b9:	89 d1                	mov    %edx,%ecx
  8006bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006be:	83 c2 08             	add    $0x8,%edx
  8006c1:	83 ec 04             	sub    $0x4,%esp
  8006c4:	50                   	push   %eax
  8006c5:	51                   	push   %ecx
  8006c6:	52                   	push   %edx
  8006c7:	e8 7c 13 00 00       	call   801a48 <sys_cputs>
  8006cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 40 04             	mov    0x4(%eax),%eax
  8006de:	8d 50 01             	lea    0x1(%eax),%edx
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e7:	90                   	nop
  8006e8:	c9                   	leave  
  8006e9:	c3                   	ret    

008006ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006fa:	00 00 00 
	b.cnt = 0;
  8006fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800704:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	ff 75 08             	pushl  0x8(%ebp)
  80070d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	68 81 06 80 00       	push   $0x800681
  800719:	e8 11 02 00 00       	call   80092f <vprintfmt>
  80071e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800721:	a0 24 40 80 00       	mov    0x804024,%al
  800726:	0f b6 c0             	movzbl %al,%eax
  800729:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	50                   	push   %eax
  800733:	52                   	push   %edx
  800734:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073a:	83 c0 08             	add    $0x8,%eax
  80073d:	50                   	push   %eax
  80073e:	e8 05 13 00 00       	call   801a48 <sys_cputs>
  800743:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800746:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80074d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800753:	c9                   	leave  
  800754:	c3                   	ret    

00800755 <cprintf>:

int cprintf(const char *fmt, ...) {
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800762:	8d 45 0c             	lea    0xc(%ebp),%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 f4             	pushl  -0xc(%ebp)
  800771:	50                   	push   %eax
  800772:	e8 73 ff ff ff       	call   8006ea <vcprintf>
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    

00800782 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800788:	e8 69 14 00 00       	call   801bf6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80078d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800790:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 f4             	pushl  -0xc(%ebp)
  80079c:	50                   	push   %eax
  80079d:	e8 48 ff ff ff       	call   8006ea <vcprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a8:	e8 63 14 00 00       	call   801c10 <sys_enable_interrupt>
	return cnt;
  8007ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    

008007b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	53                   	push   %ebx
  8007b6:	83 ec 14             	sub    $0x14,%esp
  8007b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d0:	77 55                	ja     800827 <printnum+0x75>
  8007d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d5:	72 05                	jb     8007dc <printnum+0x2a>
  8007d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007da:	77 4b                	ja     800827 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ea:	52                   	push   %edx
  8007eb:	50                   	push   %eax
  8007ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f2:	e8 81 2a 00 00       	call   803278 <__udivdi3>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	83 ec 04             	sub    $0x4,%esp
  8007fd:	ff 75 20             	pushl  0x20(%ebp)
  800800:	53                   	push   %ebx
  800801:	ff 75 18             	pushl  0x18(%ebp)
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	ff 75 08             	pushl  0x8(%ebp)
  80080c:	e8 a1 ff ff ff       	call   8007b2 <printnum>
  800811:	83 c4 20             	add    $0x20,%esp
  800814:	eb 1a                	jmp    800830 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	ff 75 20             	pushl  0x20(%ebp)
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800827:	ff 4d 1c             	decl   0x1c(%ebp)
  80082a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80082e:	7f e6                	jg     800816 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800830:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800833:	bb 00 00 00 00       	mov    $0x0,%ebx
  800838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083e:	53                   	push   %ebx
  80083f:	51                   	push   %ecx
  800840:	52                   	push   %edx
  800841:	50                   	push   %eax
  800842:	e8 41 2b 00 00       	call   803388 <__umoddi3>
  800847:	83 c4 10             	add    $0x10,%esp
  80084a:	05 34 3c 80 00       	add    $0x803c34,%eax
  80084f:	8a 00                	mov    (%eax),%al
  800851:	0f be c0             	movsbl %al,%eax
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	50                   	push   %eax
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
}
  800863:	90                   	nop
  800864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800867:	c9                   	leave  
  800868:	c3                   	ret    

00800869 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80086c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800870:	7e 1c                	jle    80088e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	8d 50 08             	lea    0x8(%eax),%edx
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	89 10                	mov    %edx,(%eax)
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	83 e8 08             	sub    $0x8,%eax
  800887:	8b 50 04             	mov    0x4(%eax),%edx
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	eb 40                	jmp    8008ce <getuint+0x65>
	else if (lflag)
  80088e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800892:	74 1e                	je     8008b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	8d 50 04             	lea    0x4(%eax),%edx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	89 10                	mov    %edx,(%eax)
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	83 e8 04             	sub    $0x4,%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b0:	eb 1c                	jmp    8008ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	89 10                	mov    %edx,(%eax)
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	83 e8 04             	sub    $0x4,%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d7:	7e 1c                	jle    8008f5 <getint+0x25>
		return va_arg(*ap, long long);
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 50 08             	lea    0x8(%eax),%edx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 10                	mov    %edx,(%eax)
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	83 e8 08             	sub    $0x8,%eax
  8008ee:	8b 50 04             	mov    0x4(%eax),%edx
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	eb 38                	jmp    80092d <getint+0x5d>
	else if (lflag)
  8008f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f9:	74 1a                	je     800915 <getint+0x45>
		return va_arg(*ap, long);
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	8d 50 04             	lea    0x4(%eax),%edx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	89 10                	mov    %edx,(%eax)
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	83 e8 04             	sub    $0x4,%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	99                   	cltd   
  800913:	eb 18                	jmp    80092d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
}
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800937:	eb 17                	jmp    800950 <vprintfmt+0x21>
			if (ch == '\0')
  800939:	85 db                	test   %ebx,%ebx
  80093b:	0f 84 af 03 00 00    	je     800cf0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	53                   	push   %ebx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800950:	8b 45 10             	mov    0x10(%ebp),%eax
  800953:	8d 50 01             	lea    0x1(%eax),%edx
  800956:	89 55 10             	mov    %edx,0x10(%ebp)
  800959:	8a 00                	mov    (%eax),%al
  80095b:	0f b6 d8             	movzbl %al,%ebx
  80095e:	83 fb 25             	cmp    $0x25,%ebx
  800961:	75 d6                	jne    800939 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800963:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800967:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80096e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800975:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80097c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	8d 50 01             	lea    0x1(%eax),%edx
  800989:	89 55 10             	mov    %edx,0x10(%ebp)
  80098c:	8a 00                	mov    (%eax),%al
  80098e:	0f b6 d8             	movzbl %al,%ebx
  800991:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800994:	83 f8 55             	cmp    $0x55,%eax
  800997:	0f 87 2b 03 00 00    	ja     800cc8 <vprintfmt+0x399>
  80099d:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
  8009a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009aa:	eb d7                	jmp    800983 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d1                	jmp    800983 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009bc:	89 d0                	mov    %edx,%eax
  8009be:	c1 e0 02             	shl    $0x2,%eax
  8009c1:	01 d0                	add    %edx,%eax
  8009c3:	01 c0                	add    %eax,%eax
  8009c5:	01 d8                	add    %ebx,%eax
  8009c7:	83 e8 30             	sub    $0x30,%eax
  8009ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d0:	8a 00                	mov    (%eax),%al
  8009d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d8:	7e 3e                	jle    800a18 <vprintfmt+0xe9>
  8009da:	83 fb 39             	cmp    $0x39,%ebx
  8009dd:	7f 39                	jg     800a18 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e2:	eb d5                	jmp    8009b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	83 c0 04             	add    $0x4,%eax
  8009ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	83 e8 04             	sub    $0x4,%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f8:	eb 1f                	jmp    800a19 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fe:	79 83                	jns    800983 <vprintfmt+0x54>
				width = 0;
  800a00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a07:	e9 77 ff ff ff       	jmp    800983 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a0c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a13:	e9 6b ff ff ff       	jmp    800983 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a18:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1d:	0f 89 60 ff ff ff    	jns    800983 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a29:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a30:	e9 4e ff ff ff       	jmp    800983 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a35:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a38:	e9 46 ff ff ff       	jmp    800983 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 c0 04             	add    $0x4,%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
  800a46:	8b 45 14             	mov    0x14(%ebp),%eax
  800a49:	83 e8 04             	sub    $0x4,%eax
  800a4c:	8b 00                	mov    (%eax),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
			break;
  800a5d:	e9 89 02 00 00       	jmp    800ceb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a73:	85 db                	test   %ebx,%ebx
  800a75:	79 02                	jns    800a79 <vprintfmt+0x14a>
				err = -err;
  800a77:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a79:	83 fb 64             	cmp    $0x64,%ebx
  800a7c:	7f 0b                	jg     800a89 <vprintfmt+0x15a>
  800a7e:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800a85:	85 f6                	test   %esi,%esi
  800a87:	75 19                	jne    800aa2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a89:	53                   	push   %ebx
  800a8a:	68 45 3c 80 00       	push   $0x803c45
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	ff 75 08             	pushl  0x8(%ebp)
  800a95:	e8 5e 02 00 00       	call   800cf8 <printfmt>
  800a9a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a9d:	e9 49 02 00 00       	jmp    800ceb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa2:	56                   	push   %esi
  800aa3:	68 4e 3c 80 00       	push   $0x803c4e
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	ff 75 08             	pushl  0x8(%ebp)
  800aae:	e8 45 02 00 00       	call   800cf8 <printfmt>
  800ab3:	83 c4 10             	add    $0x10,%esp
			break;
  800ab6:	e9 30 02 00 00       	jmp    800ceb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800abb:	8b 45 14             	mov    0x14(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	83 e8 04             	sub    $0x4,%eax
  800aca:	8b 30                	mov    (%eax),%esi
  800acc:	85 f6                	test   %esi,%esi
  800ace:	75 05                	jne    800ad5 <vprintfmt+0x1a6>
				p = "(null)";
  800ad0:	be 51 3c 80 00       	mov    $0x803c51,%esi
			if (width > 0 && padc != '-')
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7e 6d                	jle    800b48 <vprintfmt+0x219>
  800adb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800adf:	74 67                	je     800b48 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	50                   	push   %eax
  800ae8:	56                   	push   %esi
  800ae9:	e8 0c 03 00 00       	call   800dfa <strnlen>
  800aee:	83 c4 10             	add    $0x10,%esp
  800af1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800af4:	eb 16                	jmp    800b0c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800af6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	50                   	push   %eax
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b09:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b10:	7f e4                	jg     800af6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b12:	eb 34                	jmp    800b48 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b14:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b18:	74 1c                	je     800b36 <vprintfmt+0x207>
  800b1a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b1d:	7e 05                	jle    800b24 <vprintfmt+0x1f5>
  800b1f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b22:	7e 12                	jle    800b36 <vprintfmt+0x207>
					putch('?', putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	6a 3f                	push   $0x3f
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
  800b31:	83 c4 10             	add    $0x10,%esp
  800b34:	eb 0f                	jmp    800b45 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b36:	83 ec 08             	sub    $0x8,%esp
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	53                   	push   %ebx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	ff d0                	call   *%eax
  800b42:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b45:	ff 4d e4             	decl   -0x1c(%ebp)
  800b48:	89 f0                	mov    %esi,%eax
  800b4a:	8d 70 01             	lea    0x1(%eax),%esi
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	0f be d8             	movsbl %al,%ebx
  800b52:	85 db                	test   %ebx,%ebx
  800b54:	74 24                	je     800b7a <vprintfmt+0x24b>
  800b56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5a:	78 b8                	js     800b14 <vprintfmt+0x1e5>
  800b5c:	ff 4d e0             	decl   -0x20(%ebp)
  800b5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b63:	79 af                	jns    800b14 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b65:	eb 13                	jmp    800b7a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	6a 20                	push   $0x20
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	ff d0                	call   *%eax
  800b74:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b77:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7e:	7f e7                	jg     800b67 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b80:	e9 66 01 00 00       	jmp    800ceb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b85:	83 ec 08             	sub    $0x8,%esp
  800b88:	ff 75 e8             	pushl  -0x18(%ebp)
  800b8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8e:	50                   	push   %eax
  800b8f:	e8 3c fd ff ff       	call   8008d0 <getint>
  800b94:	83 c4 10             	add    $0x10,%esp
  800b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba3:	85 d2                	test   %edx,%edx
  800ba5:	79 23                	jns    800bca <vprintfmt+0x29b>
				putch('-', putdat);
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	6a 2d                	push   $0x2d
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	ff d0                	call   *%eax
  800bb4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	f7 d8                	neg    %eax
  800bbf:	83 d2 00             	adc    $0x0,%edx
  800bc2:	f7 da                	neg    %edx
  800bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd1:	e9 bc 00 00 00       	jmp    800c92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 84 fc ff ff       	call   800869 <getuint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf5:	e9 98 00 00 00       	jmp    800c92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	6a 58                	push   $0x58
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	ff d0                	call   *%eax
  800c07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	6a 58                	push   $0x58
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	ff d0                	call   *%eax
  800c17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 58                	push   $0x58
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			break;
  800c2a:	e9 bc 00 00 00       	jmp    800ceb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 30                	push   $0x30
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 78                	push   $0x78
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c71:	eb 1f                	jmp    800c92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 e8             	pushl  -0x18(%ebp)
  800c79:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7c:	50                   	push   %eax
  800c7d:	e8 e7 fb ff ff       	call   800869 <getuint>
  800c82:	83 c4 10             	add    $0x10,%esp
  800c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c99:	83 ec 04             	sub    $0x4,%esp
  800c9c:	52                   	push   %edx
  800c9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca0:	50                   	push   %eax
  800ca1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	ff 75 08             	pushl  0x8(%ebp)
  800cad:	e8 00 fb ff ff       	call   8007b2 <printnum>
  800cb2:	83 c4 20             	add    $0x20,%esp
			break;
  800cb5:	eb 34                	jmp    800ceb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	53                   	push   %ebx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	ff d0                	call   *%eax
  800cc3:	83 c4 10             	add    $0x10,%esp
			break;
  800cc6:	eb 23                	jmp    800ceb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	6a 25                	push   $0x25
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	ff d0                	call   *%eax
  800cd5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd8:	ff 4d 10             	decl   0x10(%ebp)
  800cdb:	eb 03                	jmp    800ce0 <vprintfmt+0x3b1>
  800cdd:	ff 4d 10             	decl   0x10(%ebp)
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	48                   	dec    %eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	3c 25                	cmp    $0x25,%al
  800ce8:	75 f3                	jne    800cdd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cea:	90                   	nop
		}
	}
  800ceb:	e9 47 fc ff ff       	jmp    800937 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cfe:	8d 45 10             	lea    0x10(%ebp),%eax
  800d01:	83 c0 04             	add    $0x4,%eax
  800d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d07:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0d:	50                   	push   %eax
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	ff 75 08             	pushl  0x8(%ebp)
  800d14:	e8 16 fc ff ff       	call   80092f <vprintfmt>
  800d19:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d1c:	90                   	nop
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8b 40 08             	mov    0x8(%eax),%eax
  800d28:	8d 50 01             	lea    0x1(%eax),%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 10                	mov    (%eax),%edx
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	8b 40 04             	mov    0x4(%eax),%eax
  800d3c:	39 c2                	cmp    %eax,%edx
  800d3e:	73 12                	jae    800d52 <sprintputch+0x33>
		*b->buf++ = ch;
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	8d 48 01             	lea    0x1(%eax),%ecx
  800d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4b:	89 0a                	mov    %ecx,(%edx)
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	88 10                	mov    %dl,(%eax)
}
  800d52:	90                   	nop
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	01 d0                	add    %edx,%eax
  800d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d7a:	74 06                	je     800d82 <vsnprintf+0x2d>
  800d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d80:	7f 07                	jg     800d89 <vsnprintf+0x34>
		return -E_INVAL;
  800d82:	b8 03 00 00 00       	mov    $0x3,%eax
  800d87:	eb 20                	jmp    800da9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d89:	ff 75 14             	pushl  0x14(%ebp)
  800d8c:	ff 75 10             	pushl  0x10(%ebp)
  800d8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d92:	50                   	push   %eax
  800d93:	68 1f 0d 80 00       	push   $0x800d1f
  800d98:	e8 92 fb ff ff       	call   80092f <vprintfmt>
  800d9d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db1:	8d 45 10             	lea    0x10(%ebp),%eax
  800db4:	83 c0 04             	add    $0x4,%eax
  800db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dba:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc0:	50                   	push   %eax
  800dc1:	ff 75 0c             	pushl  0xc(%ebp)
  800dc4:	ff 75 08             	pushl  0x8(%ebp)
  800dc7:	e8 89 ff ff ff       	call   800d55 <vsnprintf>
  800dcc:	83 c4 10             	add    $0x10,%esp
  800dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ddd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de4:	eb 06                	jmp    800dec <strlen+0x15>
		n++;
  800de6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de9:	ff 45 08             	incl   0x8(%ebp)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	84 c0                	test   %al,%al
  800df3:	75 f1                	jne    800de6 <strlen+0xf>
		n++;
	return n;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e07:	eb 09                	jmp    800e12 <strnlen+0x18>
		n++;
  800e09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	ff 4d 0c             	decl   0xc(%ebp)
  800e12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e16:	74 09                	je     800e21 <strnlen+0x27>
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	84 c0                	test   %al,%al
  800e1f:	75 e8                	jne    800e09 <strnlen+0xf>
		n++;
	return n;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e32:	90                   	nop
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	89 55 08             	mov    %edx,0x8(%ebp)
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e45:	8a 12                	mov    (%edx),%dl
  800e47:	88 10                	mov    %dl,(%eax)
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 e4                	jne    800e33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e67:	eb 1f                	jmp    800e88 <strncpy+0x34>
		*dst++ = *src;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8d 50 01             	lea    0x1(%eax),%edx
  800e6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	84 c0                	test   %al,%al
  800e80:	74 03                	je     800e85 <strncpy+0x31>
			src++;
  800e82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e85:	ff 45 fc             	incl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e8e:	72 d9                	jb     800e69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	74 30                	je     800ed7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea7:	eb 16                	jmp    800ebf <strlcpy+0x2a>
			*dst++ = *src++;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8d 50 01             	lea    0x1(%eax),%edx
  800eaf:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ebb:	8a 12                	mov    (%edx),%dl
  800ebd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ebf:	ff 4d 10             	decl   0x10(%ebp)
  800ec2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec6:	74 09                	je     800ed1 <strlcpy+0x3c>
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	84 c0                	test   %al,%al
  800ecf:	75 d8                	jne    800ea9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edd:	29 c2                	sub    %eax,%edx
  800edf:	89 d0                	mov    %edx,%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ee6:	eb 06                	jmp    800eee <strcmp+0xb>
		p++, q++;
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	84 c0                	test   %al,%al
  800ef5:	74 0e                	je     800f05 <strcmp+0x22>
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 10                	mov    (%eax),%dl
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	38 c2                	cmp    %al,%dl
  800f03:	74 e3                	je     800ee8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 d0             	movzbl %al,%edx
  800f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	0f b6 c0             	movzbl %al,%eax
  800f15:	29 c2                	sub    %eax,%edx
  800f17:	89 d0                	mov    %edx,%eax
}
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f1e:	eb 09                	jmp    800f29 <strncmp+0xe>
		n--, p++, q++;
  800f20:	ff 4d 10             	decl   0x10(%ebp)
  800f23:	ff 45 08             	incl   0x8(%ebp)
  800f26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2d:	74 17                	je     800f46 <strncmp+0x2b>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	84 c0                	test   %al,%al
  800f36:	74 0e                	je     800f46 <strncmp+0x2b>
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 10                	mov    (%eax),%dl
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	38 c2                	cmp    %al,%dl
  800f44:	74 da                	je     800f20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4a:	75 07                	jne    800f53 <strncmp+0x38>
		return 0;
  800f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f51:	eb 14                	jmp    800f67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 d0             	movzbl %al,%edx
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	0f b6 c0             	movzbl %al,%eax
  800f63:	29 c2                	sub    %eax,%edx
  800f65:	89 d0                	mov    %edx,%eax
}
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	83 ec 04             	sub    $0x4,%esp
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f75:	eb 12                	jmp    800f89 <strchr+0x20>
		if (*s == c)
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f7f:	75 05                	jne    800f86 <strchr+0x1d>
			return (char *) s;
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	eb 11                	jmp    800f97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f86:	ff 45 08             	incl   0x8(%ebp)
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	84 c0                	test   %al,%al
  800f90:	75 e5                	jne    800f77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 04             	sub    $0x4,%esp
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa5:	eb 0d                	jmp    800fb4 <strfind+0x1b>
		if (*s == c)
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800faf:	74 0e                	je     800fbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb1:	ff 45 08             	incl   0x8(%ebp)
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 ea                	jne    800fa7 <strfind+0xe>
  800fbd:	eb 01                	jmp    800fc0 <strfind+0x27>
		if (*s == c)
			break;
  800fbf:	90                   	nop
	return (char *) s;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc3:	c9                   	leave  
  800fc4:	c3                   	ret    

00800fc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fd7:	eb 0e                	jmp    800fe7 <memset+0x22>
		*p++ = c;
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	8d 50 01             	lea    0x1(%eax),%edx
  800fdf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fe7:	ff 4d f8             	decl   -0x8(%ebp)
  800fea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fee:	79 e9                	jns    800fd9 <memset+0x14>
		*p++ = c;

	return v;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff3:	c9                   	leave  
  800ff4:	c3                   	ret    

00800ff5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801007:	eb 16                	jmp    80101f <memcpy+0x2a>
		*d++ = *s++;
  801009:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100c:	8d 50 01             	lea    0x1(%eax),%edx
  80100f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801012:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801015:	8d 4a 01             	lea    0x1(%edx),%ecx
  801018:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80101b:	8a 12                	mov    (%edx),%dl
  80101d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80101f:	8b 45 10             	mov    0x10(%ebp),%eax
  801022:	8d 50 ff             	lea    -0x1(%eax),%edx
  801025:	89 55 10             	mov    %edx,0x10(%ebp)
  801028:	85 c0                	test   %eax,%eax
  80102a:	75 dd                	jne    801009 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801046:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801049:	73 50                	jae    80109b <memmove+0x6a>
  80104b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	01 d0                	add    %edx,%eax
  801053:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801056:	76 43                	jbe    80109b <memmove+0x6a>
		s += n;
  801058:	8b 45 10             	mov    0x10(%ebp),%eax
  80105b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801064:	eb 10                	jmp    801076 <memmove+0x45>
			*--d = *--s;
  801066:	ff 4d f8             	decl   -0x8(%ebp)
  801069:	ff 4d fc             	decl   -0x4(%ebp)
  80106c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106f:	8a 10                	mov    (%eax),%dl
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107c:	89 55 10             	mov    %edx,0x10(%ebp)
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 e3                	jne    801066 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801083:	eb 23                	jmp    8010a8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801085:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801088:	8d 50 01             	lea    0x1(%eax),%edx
  80108b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801091:	8d 4a 01             	lea    0x1(%edx),%ecx
  801094:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801097:	8a 12                	mov    (%edx),%dl
  801099:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	75 dd                	jne    801085 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010bf:	eb 2a                	jmp    8010eb <memcmp+0x3e>
		if (*s1 != *s2)
  8010c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c4:	8a 10                	mov    (%eax),%dl
  8010c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	38 c2                	cmp    %al,%dl
  8010cd:	74 16                	je     8010e5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 d0             	movzbl %al,%edx
  8010d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	0f b6 c0             	movzbl %al,%eax
  8010df:	29 c2                	sub    %eax,%edx
  8010e1:	89 d0                	mov    %edx,%eax
  8010e3:	eb 18                	jmp    8010fd <memcmp+0x50>
		s1++, s2++;
  8010e5:	ff 45 fc             	incl   -0x4(%ebp)
  8010e8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	75 c9                	jne    8010c1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    

008010ff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	01 d0                	add    %edx,%eax
  80110d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801110:	eb 15                	jmp    801127 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	0f b6 d0             	movzbl %al,%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	0f b6 c0             	movzbl %al,%eax
  801120:	39 c2                	cmp    %eax,%edx
  801122:	74 0d                	je     801131 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801124:	ff 45 08             	incl   0x8(%ebp)
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80112d:	72 e3                	jb     801112 <memfind+0x13>
  80112f:	eb 01                	jmp    801132 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801131:	90                   	nop
	return (void *) s;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80113d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801144:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80114b:	eb 03                	jmp    801150 <strtol+0x19>
		s++;
  80114d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	3c 20                	cmp    $0x20,%al
  801157:	74 f4                	je     80114d <strtol+0x16>
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	3c 09                	cmp    $0x9,%al
  801160:	74 eb                	je     80114d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	3c 2b                	cmp    $0x2b,%al
  801169:	75 05                	jne    801170 <strtol+0x39>
		s++;
  80116b:	ff 45 08             	incl   0x8(%ebp)
  80116e:	eb 13                	jmp    801183 <strtol+0x4c>
	else if (*s == '-')
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3c 2d                	cmp    $0x2d,%al
  801177:	75 0a                	jne    801183 <strtol+0x4c>
		s++, neg = 1;
  801179:	ff 45 08             	incl   0x8(%ebp)
  80117c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801183:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801187:	74 06                	je     80118f <strtol+0x58>
  801189:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80118d:	75 20                	jne    8011af <strtol+0x78>
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 30                	cmp    $0x30,%al
  801196:	75 17                	jne    8011af <strtol+0x78>
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	40                   	inc    %eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	3c 78                	cmp    $0x78,%al
  8011a0:	75 0d                	jne    8011af <strtol+0x78>
		s += 2, base = 16;
  8011a2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011a6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011ad:	eb 28                	jmp    8011d7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b3:	75 15                	jne    8011ca <strtol+0x93>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 30                	cmp    $0x30,%al
  8011bc:	75 0c                	jne    8011ca <strtol+0x93>
		s++, base = 8;
  8011be:	ff 45 08             	incl   0x8(%ebp)
  8011c1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c8:	eb 0d                	jmp    8011d7 <strtol+0xa0>
	else if (base == 0)
  8011ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ce:	75 07                	jne    8011d7 <strtol+0xa0>
		base = 10;
  8011d0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 2f                	cmp    $0x2f,%al
  8011de:	7e 19                	jle    8011f9 <strtol+0xc2>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 39                	cmp    $0x39,%al
  8011e7:	7f 10                	jg     8011f9 <strtol+0xc2>
			dig = *s - '0';
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	0f be c0             	movsbl %al,%eax
  8011f1:	83 e8 30             	sub    $0x30,%eax
  8011f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f7:	eb 42                	jmp    80123b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 60                	cmp    $0x60,%al
  801200:	7e 19                	jle    80121b <strtol+0xe4>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 7a                	cmp    $0x7a,%al
  801209:	7f 10                	jg     80121b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f be c0             	movsbl %al,%eax
  801213:	83 e8 57             	sub    $0x57,%eax
  801216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801219:	eb 20                	jmp    80123b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3c 40                	cmp    $0x40,%al
  801222:	7e 39                	jle    80125d <strtol+0x126>
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3c 5a                	cmp    $0x5a,%al
  80122b:	7f 30                	jg     80125d <strtol+0x126>
			dig = *s - 'A' + 10;
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	0f be c0             	movsbl %al,%eax
  801235:	83 e8 37             	sub    $0x37,%eax
  801238:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80123b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801241:	7d 19                	jge    80125c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801243:	ff 45 08             	incl   0x8(%ebp)
  801246:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801249:	0f af 45 10          	imul   0x10(%ebp),%eax
  80124d:	89 c2                	mov    %eax,%edx
  80124f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801252:	01 d0                	add    %edx,%eax
  801254:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801257:	e9 7b ff ff ff       	jmp    8011d7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80125c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80125d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801261:	74 08                	je     80126b <strtol+0x134>
		*endptr = (char *) s;
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	8b 55 08             	mov    0x8(%ebp),%edx
  801269:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80126b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126f:	74 07                	je     801278 <strtol+0x141>
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801274:	f7 d8                	neg    %eax
  801276:	eb 03                	jmp    80127b <strtol+0x144>
  801278:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <ltostr>:

void
ltostr(long value, char *str)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80128a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801291:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801295:	79 13                	jns    8012aa <ltostr+0x2d>
	{
		neg = 1;
  801297:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b2:	99                   	cltd   
  8012b3:	f7 f9                	idiv   %ecx
  8012b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bb:	8d 50 01             	lea    0x1(%eax),%edx
  8012be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c1:	89 c2                	mov    %eax,%edx
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	01 d0                	add    %edx,%eax
  8012c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012cb:	83 c2 30             	add    $0x30,%edx
  8012ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d8:	f7 e9                	imul   %ecx
  8012da:	c1 fa 02             	sar    $0x2,%edx
  8012dd:	89 c8                	mov    %ecx,%eax
  8012df:	c1 f8 1f             	sar    $0x1f,%eax
  8012e2:	29 c2                	sub    %eax,%edx
  8012e4:	89 d0                	mov    %edx,%eax
  8012e6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f1:	f7 e9                	imul   %ecx
  8012f3:	c1 fa 02             	sar    $0x2,%edx
  8012f6:	89 c8                	mov    %ecx,%eax
  8012f8:	c1 f8 1f             	sar    $0x1f,%eax
  8012fb:	29 c2                	sub    %eax,%edx
  8012fd:	89 d0                	mov    %edx,%eax
  8012ff:	c1 e0 02             	shl    $0x2,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	29 c1                	sub    %eax,%ecx
  801308:	89 ca                	mov    %ecx,%edx
  80130a:	85 d2                	test   %edx,%edx
  80130c:	75 9c                	jne    8012aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80130e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801318:	48                   	dec    %eax
  801319:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80131c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801320:	74 3d                	je     80135f <ltostr+0xe2>
		start = 1 ;
  801322:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801329:	eb 34                	jmp    80135f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80132b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801338:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c2                	add    %eax,%edx
  801340:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	01 c8                	add    %ecx,%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80134c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 c2                	add    %eax,%edx
  801354:	8a 45 eb             	mov    -0x15(%ebp),%al
  801357:	88 02                	mov    %al,(%edx)
		start++ ;
  801359:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80135c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801362:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801365:	7c c4                	jl     80132b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801367:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801372:	90                   	nop
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80137b:	ff 75 08             	pushl  0x8(%ebp)
  80137e:	e8 54 fa ff ff       	call   800dd7 <strlen>
  801383:	83 c4 04             	add    $0x4,%esp
  801386:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 46 fa ff ff       	call   800dd7 <strlen>
  801391:	83 c4 04             	add    $0x4,%esp
  801394:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801397:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80139e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a5:	eb 17                	jmp    8013be <strcconcat+0x49>
		final[s] = str1[s] ;
  8013a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 c2                	add    %eax,%edx
  8013af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	01 c8                	add    %ecx,%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013bb:	ff 45 fc             	incl   -0x4(%ebp)
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013c4:	7c e1                	jl     8013a7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013d4:	eb 1f                	jmp    8013f5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d9:	8d 50 01             	lea    0x1(%eax),%edx
  8013dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013df:	89 c2                	mov    %eax,%edx
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	01 c2                	add    %eax,%edx
  8013e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	01 c8                	add    %ecx,%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f2:	ff 45 f8             	incl   -0x8(%ebp)
  8013f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013fb:	7c d9                	jl     8013d6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801400:	8b 45 10             	mov    0x10(%ebp),%eax
  801403:	01 d0                	add    %edx,%eax
  801405:	c6 00 00             	movb   $0x0,(%eax)
}
  801408:	90                   	nop
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801417:	8b 45 14             	mov    0x14(%ebp),%eax
  80141a:	8b 00                	mov    (%eax),%eax
  80141c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80142e:	eb 0c                	jmp    80143c <strsplit+0x31>
			*string++ = 0;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8d 50 01             	lea    0x1(%eax),%edx
  801436:	89 55 08             	mov    %edx,0x8(%ebp)
  801439:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	84 c0                	test   %al,%al
  801443:	74 18                	je     80145d <strsplit+0x52>
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be c0             	movsbl %al,%eax
  80144d:	50                   	push   %eax
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	e8 13 fb ff ff       	call   800f69 <strchr>
  801456:	83 c4 08             	add    $0x8,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	75 d3                	jne    801430 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	84 c0                	test   %al,%al
  801464:	74 5a                	je     8014c0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801466:	8b 45 14             	mov    0x14(%ebp),%eax
  801469:	8b 00                	mov    (%eax),%eax
  80146b:	83 f8 0f             	cmp    $0xf,%eax
  80146e:	75 07                	jne    801477 <strsplit+0x6c>
		{
			return 0;
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 66                	jmp    8014dd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801477:	8b 45 14             	mov    0x14(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	8d 48 01             	lea    0x1(%eax),%ecx
  80147f:	8b 55 14             	mov    0x14(%ebp),%edx
  801482:	89 0a                	mov    %ecx,(%edx)
  801484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 c2                	add    %eax,%edx
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801495:	eb 03                	jmp    80149a <strsplit+0x8f>
			string++;
  801497:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	84 c0                	test   %al,%al
  8014a1:	74 8b                	je     80142e <strsplit+0x23>
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	0f be c0             	movsbl %al,%eax
  8014ab:	50                   	push   %eax
  8014ac:	ff 75 0c             	pushl  0xc(%ebp)
  8014af:	e8 b5 fa ff ff       	call   800f69 <strchr>
  8014b4:	83 c4 08             	add    $0x8,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	74 dc                	je     801497 <strsplit+0x8c>
			string++;
	}
  8014bb:	e9 6e ff ff ff       	jmp    80142e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c4:	8b 00                	mov    (%eax),%eax
  8014c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014e5:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 1f                	je     80150d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014ee:	e8 1d 00 00 00       	call   801510 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	68 b0 3d 80 00       	push   $0x803db0
  8014fb:	e8 55 f2 ff ff       	call   800755 <cprintf>
  801500:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801503:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80150a:	00 00 00 
	}
}
  80150d:	90                   	nop
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801516:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80151d:	00 00 00 
  801520:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801527:	00 00 00 
  80152a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801531:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801534:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80153b:	00 00 00 
  80153e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801545:	00 00 00 
  801548:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80154f:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801552:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801559:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80155c:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801563:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801572:	2d 00 10 00 00       	sub    $0x1000,%eax
  801577:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80157c:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801590:	83 ec 04             	sub    $0x4,%esp
  801593:	6a 06                	push   $0x6
  801595:	ff 75 f4             	pushl  -0xc(%ebp)
  801598:	50                   	push   %eax
  801599:	e8 ee 05 00 00       	call   801b8c <sys_allocate_chunk>
  80159e:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015a1:	a1 20 41 80 00       	mov    0x804120,%eax
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	50                   	push   %eax
  8015aa:	e8 63 0c 00 00       	call   802212 <initialize_MemBlocksList>
  8015af:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8015b2:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8015ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015bd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8015c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015da:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8015dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8015e7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8015ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f1:	8b 50 08             	mov    0x8(%eax),%edx
  8015f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	48                   	dec    %eax
  8015fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8015fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801600:	ba 00 00 00 00       	mov    $0x0,%edx
  801605:	f7 75 e0             	divl   -0x20(%ebp)
  801608:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80160b:	29 d0                	sub    %edx,%eax
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801612:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801615:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801619:	75 14                	jne    80162f <initialize_dyn_block_system+0x11f>
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 d5 3d 80 00       	push   $0x803dd5
  801623:	6a 34                	push   $0x34
  801625:	68 f3 3d 80 00       	push   $0x803df3
  80162a:	e8 72 ee ff ff       	call   8004a1 <_panic>
  80162f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	85 c0                	test   %eax,%eax
  801636:	74 10                	je     801648 <initialize_dyn_block_system+0x138>
  801638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801640:	8b 52 04             	mov    0x4(%edx),%edx
  801643:	89 50 04             	mov    %edx,0x4(%eax)
  801646:	eb 0b                	jmp    801653 <initialize_dyn_block_system+0x143>
  801648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164b:	8b 40 04             	mov    0x4(%eax),%eax
  80164e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801656:	8b 40 04             	mov    0x4(%eax),%eax
  801659:	85 c0                	test   %eax,%eax
  80165b:	74 0f                	je     80166c <initialize_dyn_block_system+0x15c>
  80165d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801660:	8b 40 04             	mov    0x4(%eax),%eax
  801663:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801666:	8b 12                	mov    (%edx),%edx
  801668:	89 10                	mov    %edx,(%eax)
  80166a:	eb 0a                	jmp    801676 <initialize_dyn_block_system+0x166>
  80166c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166f:	8b 00                	mov    (%eax),%eax
  801671:	a3 48 41 80 00       	mov    %eax,0x804148
  801676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801689:	a1 54 41 80 00       	mov    0x804154,%eax
  80168e:	48                   	dec    %eax
  80168f:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	e8 c4 13 00 00       	call   802a63 <insert_sorted_with_merge_freeList>
  80169f:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016a2:	90                   	nop
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ab:	e8 2f fe ff ff       	call   8014df <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016b4:	75 07                	jne    8016bd <malloc+0x18>
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	eb 71                	jmp    80172e <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016bd:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016c4:	76 07                	jbe    8016cd <malloc+0x28>
	return NULL;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cb:	eb 61                	jmp    80172e <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016cd:	e8 88 08 00 00       	call   801f5a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	74 53                	je     801729 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016d6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	01 d0                	add    %edx,%eax
  8016e5:	48                   	dec    %eax
  8016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f1:	f7 75 f4             	divl   -0xc(%ebp)
  8016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f7:	29 d0                	sub    %edx,%eax
  8016f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801702:	e8 d2 0d 00 00       	call   8024d9 <alloc_block_FF>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80170d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801711:	74 16                	je     801729 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801713:	83 ec 0c             	sub    $0xc,%esp
  801716:	ff 75 e8             	pushl  -0x18(%ebp)
  801719:	e8 0c 0c 00 00       	call   80232a <insert_sorted_allocList>
  80171e:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801724:	8b 40 08             	mov    0x8(%eax),%eax
  801727:	eb 05                	jmp    80172e <malloc+0x89>
    }

			}


	return NULL;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80173c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	ff 75 f0             	pushl  -0x10(%ebp)
  80174d:	68 40 40 80 00       	push   $0x804040
  801752:	e8 a0 0b 00 00       	call   8022f7 <find_block>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	8b 50 0c             	mov    0xc(%eax),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	e8 e4 03 00 00       	call   801b54 <sys_free_user_mem>
  801770:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801773:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801777:	75 17                	jne    801790 <free+0x60>
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	68 d5 3d 80 00       	push   $0x803dd5
  801781:	68 84 00 00 00       	push   $0x84
  801786:	68 f3 3d 80 00       	push   $0x803df3
  80178b:	e8 11 ed ff ff       	call   8004a1 <_panic>
  801790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801793:	8b 00                	mov    (%eax),%eax
  801795:	85 c0                	test   %eax,%eax
  801797:	74 10                	je     8017a9 <free+0x79>
  801799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179c:	8b 00                	mov    (%eax),%eax
  80179e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a1:	8b 52 04             	mov    0x4(%edx),%edx
  8017a4:	89 50 04             	mov    %edx,0x4(%eax)
  8017a7:	eb 0b                	jmp    8017b4 <free+0x84>
  8017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ac:	8b 40 04             	mov    0x4(%eax),%eax
  8017af:	a3 44 40 80 00       	mov    %eax,0x804044
  8017b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b7:	8b 40 04             	mov    0x4(%eax),%eax
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	74 0f                	je     8017cd <free+0x9d>
  8017be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c1:	8b 40 04             	mov    0x4(%eax),%eax
  8017c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c7:	8b 12                	mov    (%edx),%edx
  8017c9:	89 10                	mov    %edx,(%eax)
  8017cb:	eb 0a                	jmp    8017d7 <free+0xa7>
  8017cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d0:	8b 00                	mov    (%eax),%eax
  8017d2:	a3 40 40 80 00       	mov    %eax,0x804040
  8017d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017ea:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017ef:	48                   	dec    %eax
  8017f0:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8017f5:	83 ec 0c             	sub    $0xc,%esp
  8017f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8017fb:	e8 63 12 00 00       	call   802a63 <insert_sorted_with_merge_freeList>
  801800:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 38             	sub    $0x38,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801812:	e8 c8 fc ff ff       	call   8014df <InitializeUHeap>
	if (size == 0) return NULL ;
  801817:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181b:	75 0a                	jne    801827 <smalloc+0x21>
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	e9 a0 00 00 00       	jmp    8018c7 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801827:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80182e:	76 0a                	jbe    80183a <smalloc+0x34>
		return NULL;
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	e9 8d 00 00 00       	jmp    8018c7 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80183a:	e8 1b 07 00 00       	call   801f5a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80183f:	85 c0                	test   %eax,%eax
  801841:	74 7f                	je     8018c2 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801843:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801850:	01 d0                	add    %edx,%eax
  801852:	48                   	dec    %eax
  801853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	ba 00 00 00 00       	mov    $0x0,%edx
  80185e:	f7 75 f4             	divl   -0xc(%ebp)
  801861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801864:	29 d0                	sub    %edx,%eax
  801866:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801869:	83 ec 0c             	sub    $0xc,%esp
  80186c:	ff 75 ec             	pushl  -0x14(%ebp)
  80186f:	e8 65 0c 00 00       	call   8024d9 <alloc_block_FF>
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80187a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80187e:	74 42                	je     8018c2 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801880:	83 ec 0c             	sub    $0xc,%esp
  801883:	ff 75 e8             	pushl  -0x18(%ebp)
  801886:	e8 9f 0a 00 00       	call   80232a <insert_sorted_allocList>
  80188b:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80188e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801891:	8b 40 08             	mov    0x8(%eax),%eax
  801894:	89 c2                	mov    %eax,%edx
  801896:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 38 04 00 00       	call   801cdf <sys_createSharedObject>
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8018ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018b1:	79 07                	jns    8018ba <smalloc+0xb4>
	    		  return NULL;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b8:	eb 0d                	jmp    8018c7 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8018ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018bd:	8b 40 08             	mov    0x8(%eax),%eax
  8018c0:	eb 05                	jmp    8018c7 <smalloc+0xc1>


				}


		return NULL;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018cf:	e8 0b fc ff ff       	call   8014df <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018d4:	e8 81 06 00 00       	call   801f5a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	0f 84 9f 00 00 00    	je     801980 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	e8 1a 04 00 00       	call   801d09 <sys_getSizeOfSharedObject>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8018f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018f9:	79 0a                	jns    801905 <sget+0x3c>
		return NULL;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	e9 80 00 00 00       	jmp    801985 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801905:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80190c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	01 d0                	add    %edx,%eax
  801914:	48                   	dec    %eax
  801915:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191b:	ba 00 00 00 00       	mov    $0x0,%edx
  801920:	f7 75 f0             	divl   -0x10(%ebp)
  801923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801926:	29 d0                	sub    %edx,%eax
  801928:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80192b:	83 ec 0c             	sub    $0xc,%esp
  80192e:	ff 75 e8             	pushl  -0x18(%ebp)
  801931:	e8 a3 0b 00 00       	call   8024d9 <alloc_block_FF>
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80193c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801940:	74 3e                	je     801980 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801942:	83 ec 0c             	sub    $0xc,%esp
  801945:	ff 75 e4             	pushl  -0x1c(%ebp)
  801948:	e8 dd 09 00 00       	call   80232a <insert_sorted_allocList>
  80194d:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801950:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801953:	8b 40 08             	mov    0x8(%eax),%eax
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	50                   	push   %eax
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	e8 c1 03 00 00       	call   801d26 <sys_getSharedObject>
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80196b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196f:	79 07                	jns    801978 <sget+0xaf>
	    		  return NULL;
  801971:	b8 00 00 00 00       	mov    $0x0,%eax
  801976:	eb 0d                	jmp    801985 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80197b:	8b 40 08             	mov    0x8(%eax),%eax
  80197e:	eb 05                	jmp    801985 <sget+0xbc>
	      }
	}
	   return NULL;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80198d:	e8 4d fb ff ff       	call   8014df <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 00 3e 80 00       	push   $0x803e00
  80199a:	68 12 01 00 00       	push   $0x112
  80199f:	68 f3 3d 80 00       	push   $0x803df3
  8019a4:	e8 f8 ea ff ff       	call   8004a1 <_panic>

008019a9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	68 28 3e 80 00       	push   $0x803e28
  8019b7:	68 26 01 00 00       	push   $0x126
  8019bc:	68 f3 3d 80 00       	push   $0x803df3
  8019c1:	e8 db ea ff ff       	call   8004a1 <_panic>

008019c6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 4c 3e 80 00       	push   $0x803e4c
  8019d4:	68 31 01 00 00       	push   $0x131
  8019d9:	68 f3 3d 80 00       	push   $0x803df3
  8019de:	e8 be ea ff ff       	call   8004a1 <_panic>

008019e3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	68 4c 3e 80 00       	push   $0x803e4c
  8019f1:	68 36 01 00 00       	push   $0x136
  8019f6:	68 f3 3d 80 00       	push   $0x803df3
  8019fb:	e8 a1 ea ff ff       	call   8004a1 <_panic>

00801a00 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 4c 3e 80 00       	push   $0x803e4c
  801a0e:	68 3b 01 00 00       	push   $0x13b
  801a13:	68 f3 3d 80 00       	push   $0x803df3
  801a18:	e8 84 ea ff ff       	call   8004a1 <_panic>

00801a1d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	57                   	push   %edi
  801a21:	56                   	push   %esi
  801a22:	53                   	push   %ebx
  801a23:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a32:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a35:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a38:	cd 30                	int    $0x30
  801a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5f                   	pop    %edi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    

00801a48 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a54:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	52                   	push   %edx
  801a60:	ff 75 0c             	pushl  0xc(%ebp)
  801a63:	50                   	push   %eax
  801a64:	6a 00                	push   $0x0
  801a66:	e8 b2 ff ff ff       	call   801a1d <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 01                	push   $0x1
  801a80:	e8 98 ff ff ff       	call   801a1d <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 05                	push   $0x5
  801a9d:	e8 7b ff ff ff       	call   801a1d <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	56                   	push   %esi
  801aab:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aac:	8b 75 18             	mov    0x18(%ebp),%esi
  801aaf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	56                   	push   %esi
  801abc:	53                   	push   %ebx
  801abd:	51                   	push   %ecx
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 06                	push   $0x6
  801ac2:	e8 56 ff ff ff       	call   801a1d <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5e                   	pop    %esi
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    

00801ad1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 07                	push   $0x7
  801ae4:	e8 34 ff ff ff       	call   801a1d <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	6a 08                	push   $0x8
  801aff:	e8 19 ff ff ff       	call   801a1d <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 09                	push   $0x9
  801b18:	e8 00 ff ff ff       	call   801a1d <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 0a                	push   $0xa
  801b31:	e8 e7 fe ff ff       	call   801a1d <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 0b                	push   $0xb
  801b4a:	e8 ce fe ff ff       	call   801a1d <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 0f                	push   $0xf
  801b65:	e8 b3 fe ff ff       	call   801a1d <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	6a 10                	push   $0x10
  801b81:	e8 97 fe ff ff       	call   801a1d <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 10             	pushl  0x10(%ebp)
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	6a 11                	push   $0x11
  801b9e:	e8 7a fe ff ff       	call   801a1d <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 0c                	push   $0xc
  801bb8:	e8 60 fe ff ff       	call   801a1d <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 0d                	push   $0xd
  801bd2:	e8 46 fe ff ff       	call   801a1d <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 0e                	push   $0xe
  801beb:	e8 2d fe ff ff       	call   801a1d <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	90                   	nop
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 13                	push   $0x13
  801c05:	e8 13 fe ff ff       	call   801a1d <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	90                   	nop
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 14                	push   $0x14
  801c1f:	e8 f9 fd ff ff       	call   801a1d <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	90                   	nop
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_cputc>:


void
sys_cputc(const char c)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c36:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	50                   	push   %eax
  801c43:	6a 15                	push   $0x15
  801c45:	e8 d3 fd ff ff       	call   801a1d <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 16                	push   $0x16
  801c5f:	e8 b9 fd ff ff       	call   801a1d <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	90                   	nop
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	6a 17                	push   $0x17
  801c7c:	e8 9c fd ff ff       	call   801a1d <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	52                   	push   %edx
  801c96:	50                   	push   %eax
  801c97:	6a 1a                	push   $0x1a
  801c99:	e8 7f fd ff ff       	call   801a1d <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	52                   	push   %edx
  801cb3:	50                   	push   %eax
  801cb4:	6a 18                	push   $0x18
  801cb6:	e8 62 fd ff ff       	call   801a1d <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 19                	push   $0x19
  801cd4:	e8 44 fd ff ff       	call   801a1d <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ceb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	51                   	push   %ecx
  801cf8:	52                   	push   %edx
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	50                   	push   %eax
  801cfd:	6a 1b                	push   $0x1b
  801cff:	e8 19 fd ff ff       	call   801a1d <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	52                   	push   %edx
  801d19:	50                   	push   %eax
  801d1a:	6a 1c                	push   $0x1c
  801d1c:	e8 fc fc ff ff       	call   801a1d <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	51                   	push   %ecx
  801d37:	52                   	push   %edx
  801d38:	50                   	push   %eax
  801d39:	6a 1d                	push   $0x1d
  801d3b:	e8 dd fc ff ff       	call   801a1d <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	6a 1e                	push   $0x1e
  801d58:	e8 c0 fc ff ff       	call   801a1d <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 1f                	push   $0x1f
  801d71:	e8 a7 fc ff ff       	call   801a1d <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	6a 00                	push   $0x0
  801d83:	ff 75 14             	pushl  0x14(%ebp)
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	50                   	push   %eax
  801d8d:	6a 20                	push   $0x20
  801d8f:	e8 89 fc ff ff       	call   801a1d <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	50                   	push   %eax
  801da8:	6a 21                	push   $0x21
  801daa:	e8 6e fc ff ff       	call   801a1d <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	90                   	nop
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	50                   	push   %eax
  801dc4:	6a 22                	push   $0x22
  801dc6:	e8 52 fc ff ff       	call   801a1d <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 02                	push   $0x2
  801ddf:	e8 39 fc ff ff       	call   801a1d <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 03                	push   $0x3
  801df8:	e8 20 fc ff ff       	call   801a1d <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 04                	push   $0x4
  801e11:	e8 07 fc ff ff       	call   801a1d <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_exit_env>:


void sys_exit_env(void)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 23                	push   $0x23
  801e2a:	e8 ee fb ff ff       	call   801a1d <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	90                   	nop
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e3e:	8d 50 04             	lea    0x4(%eax),%edx
  801e41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 24                	push   $0x24
  801e4e:	e8 ca fb ff ff       	call   801a1d <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return result;
  801e56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e5f:	89 01                	mov    %eax,(%ecx)
  801e61:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	c9                   	leave  
  801e68:	c2 04 00             	ret    $0x4

00801e6b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	ff 75 10             	pushl  0x10(%ebp)
  801e75:	ff 75 0c             	pushl  0xc(%ebp)
  801e78:	ff 75 08             	pushl  0x8(%ebp)
  801e7b:	6a 12                	push   $0x12
  801e7d:	e8 9b fb ff ff       	call   801a1d <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
	return ;
  801e85:	90                   	nop
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 25                	push   $0x25
  801e97:	e8 81 fb ff ff       	call   801a1d <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ead:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	50                   	push   %eax
  801eba:	6a 26                	push   $0x26
  801ebc:	e8 5c fb ff ff       	call   801a1d <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec4:	90                   	nop
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <rsttst>:
void rsttst()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 28                	push   $0x28
  801ed6:	e8 42 fb ff ff       	call   801a1d <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ede:	90                   	nop
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eed:	8b 55 18             	mov    0x18(%ebp),%edx
  801ef0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef4:	52                   	push   %edx
  801ef5:	50                   	push   %eax
  801ef6:	ff 75 10             	pushl  0x10(%ebp)
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	ff 75 08             	pushl  0x8(%ebp)
  801eff:	6a 27                	push   $0x27
  801f01:	e8 17 fb ff ff       	call   801a1d <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
	return ;
  801f09:	90                   	nop
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <chktst>:
void chktst(uint32 n)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	6a 29                	push   $0x29
  801f1c:	e8 fc fa ff ff       	call   801a1d <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
	return ;
  801f24:	90                   	nop
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <inctst>:

void inctst()
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 2a                	push   $0x2a
  801f36:	e8 e2 fa ff ff       	call   801a1d <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <gettst>:
uint32 gettst()
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 2b                	push   $0x2b
  801f50:	e8 c8 fa ff ff       	call   801a1d <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 2c                	push   $0x2c
  801f6c:	e8 ac fa ff ff       	call   801a1d <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
  801f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f77:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f7b:	75 07                	jne    801f84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f82:	eb 05                	jmp    801f89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 2c                	push   $0x2c
  801f9d:	e8 7b fa ff ff       	call   801a1d <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
  801fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fa8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fac:	75 07                	jne    801fb5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	eb 05                	jmp    801fba <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 2c                	push   $0x2c
  801fce:	e8 4a fa ff ff       	call   801a1d <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
  801fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fd9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fdd:	75 07                	jne    801fe6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fdf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe4:	eb 05                	jmp    801feb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 2c                	push   $0x2c
  801fff:	e8 19 fa ff ff       	call   801a1d <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80200a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80200e:	75 07                	jne    802017 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802010:	b8 01 00 00 00       	mov    $0x1,%eax
  802015:	eb 05                	jmp    80201c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	ff 75 08             	pushl  0x8(%ebp)
  80202c:	6a 2d                	push   $0x2d
  80202e:	e8 ea f9 ff ff       	call   801a1d <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
	return ;
  802036:	90                   	nop
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80203d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802040:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802043:	8b 55 0c             	mov    0xc(%ebp),%edx
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	6a 00                	push   $0x0
  80204b:	53                   	push   %ebx
  80204c:	51                   	push   %ecx
  80204d:	52                   	push   %edx
  80204e:	50                   	push   %eax
  80204f:	6a 2e                	push   $0x2e
  802051:	e8 c7 f9 ff ff       	call   801a1d <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802061:	8b 55 0c             	mov    0xc(%ebp),%edx
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	52                   	push   %edx
  80206e:	50                   	push   %eax
  80206f:	6a 2f                	push   $0x2f
  802071:	e8 a7 f9 ff ff       	call   801a1d <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	68 5c 3e 80 00       	push   $0x803e5c
  802089:	e8 c7 e6 ff ff       	call   800755 <cprintf>
  80208e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802091:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	68 88 3e 80 00       	push   $0x803e88
  8020a0:	e8 b0 e6 ff ff       	call   800755 <cprintf>
  8020a5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020a8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8020b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b4:	eb 56                	jmp    80210c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ba:	74 1c                	je     8020d8 <print_mem_block_lists+0x5d>
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 50 08             	mov    0x8(%eax),%edx
  8020c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c5:	8b 48 08             	mov    0x8(%eax),%ecx
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ce:	01 c8                	add    %ecx,%eax
  8020d0:	39 c2                	cmp    %eax,%edx
  8020d2:	73 04                	jae    8020d8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020d4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 50 08             	mov    0x8(%eax),%edx
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e4:	01 c2                	add    %eax,%edx
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	68 9d 3e 80 00       	push   $0x803e9d
  8020f6:	e8 5a e6 ff ff       	call   800755 <cprintf>
  8020fb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802104:	a1 40 41 80 00       	mov    0x804140,%eax
  802109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80210c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802110:	74 07                	je     802119 <print_mem_block_lists+0x9e>
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 00                	mov    (%eax),%eax
  802117:	eb 05                	jmp    80211e <print_mem_block_lists+0xa3>
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	a3 40 41 80 00       	mov    %eax,0x804140
  802123:	a1 40 41 80 00       	mov    0x804140,%eax
  802128:	85 c0                	test   %eax,%eax
  80212a:	75 8a                	jne    8020b6 <print_mem_block_lists+0x3b>
  80212c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802130:	75 84                	jne    8020b6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802132:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802136:	75 10                	jne    802148 <print_mem_block_lists+0xcd>
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	68 ac 3e 80 00       	push   $0x803eac
  802140:	e8 10 e6 ff ff       	call   800755 <cprintf>
  802145:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802148:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	68 d0 3e 80 00       	push   $0x803ed0
  802157:	e8 f9 e5 ff ff       	call   800755 <cprintf>
  80215c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80215f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802163:	a1 40 40 80 00       	mov    0x804040,%eax
  802168:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216b:	eb 56                	jmp    8021c3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80216d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802171:	74 1c                	je     80218f <print_mem_block_lists+0x114>
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 50 08             	mov    0x8(%eax),%edx
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	8b 48 08             	mov    0x8(%eax),%ecx
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8b 40 0c             	mov    0xc(%eax),%eax
  802185:	01 c8                	add    %ecx,%eax
  802187:	39 c2                	cmp    %eax,%edx
  802189:	73 04                	jae    80218f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80218b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 50 08             	mov    0x8(%eax),%edx
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 40 0c             	mov    0xc(%eax),%eax
  80219b:	01 c2                	add    %eax,%edx
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	68 9d 3e 80 00       	push   $0x803e9d
  8021ad:	e8 a3 e5 ff ff       	call   800755 <cprintf>
  8021b2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021bb:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	74 07                	je     8021d0 <print_mem_block_lists+0x155>
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	eb 05                	jmp    8021d5 <print_mem_block_lists+0x15a>
  8021d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021da:	a1 48 40 80 00       	mov    0x804048,%eax
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	75 8a                	jne    80216d <print_mem_block_lists+0xf2>
  8021e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e7:	75 84                	jne    80216d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021e9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021ed:	75 10                	jne    8021ff <print_mem_block_lists+0x184>
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	68 e8 3e 80 00       	push   $0x803ee8
  8021f7:	e8 59 e5 ff ff       	call   800755 <cprintf>
  8021fc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	68 5c 3e 80 00       	push   $0x803e5c
  802207:	e8 49 e5 ff ff       	call   800755 <cprintf>
  80220c:	83 c4 10             	add    $0x10,%esp

}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802218:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80221f:	00 00 00 
  802222:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802229:	00 00 00 
  80222c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802233:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802236:	a1 50 40 80 00       	mov    0x804050,%eax
  80223b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80223e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802245:	e9 9e 00 00 00       	jmp    8022e8 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80224a:	a1 50 40 80 00       	mov    0x804050,%eax
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	c1 e2 04             	shl    $0x4,%edx
  802255:	01 d0                	add    %edx,%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	75 14                	jne    80226f <initialize_MemBlocksList+0x5d>
  80225b:	83 ec 04             	sub    $0x4,%esp
  80225e:	68 10 3f 80 00       	push   $0x803f10
  802263:	6a 48                	push   $0x48
  802265:	68 33 3f 80 00       	push   $0x803f33
  80226a:	e8 32 e2 ff ff       	call   8004a1 <_panic>
  80226f:	a1 50 40 80 00       	mov    0x804050,%eax
  802274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802277:	c1 e2 04             	shl    $0x4,%edx
  80227a:	01 d0                	add    %edx,%eax
  80227c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802282:	89 10                	mov    %edx,(%eax)
  802284:	8b 00                	mov    (%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 18                	je     8022a2 <initialize_MemBlocksList+0x90>
  80228a:	a1 48 41 80 00       	mov    0x804148,%eax
  80228f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802295:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802298:	c1 e1 04             	shl    $0x4,%ecx
  80229b:	01 ca                	add    %ecx,%edx
  80229d:	89 50 04             	mov    %edx,0x4(%eax)
  8022a0:	eb 12                	jmp    8022b4 <initialize_MemBlocksList+0xa2>
  8022a2:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022aa:	c1 e2 04             	shl    $0x4,%edx
  8022ad:	01 d0                	add    %edx,%eax
  8022af:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022b4:	a1 50 40 80 00       	mov    0x804050,%eax
  8022b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bc:	c1 e2 04             	shl    $0x4,%edx
  8022bf:	01 d0                	add    %edx,%eax
  8022c1:	a3 48 41 80 00       	mov    %eax,0x804148
  8022c6:	a1 50 40 80 00       	mov    0x804050,%eax
  8022cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ce:	c1 e2 04             	shl    $0x4,%edx
  8022d1:	01 d0                	add    %edx,%eax
  8022d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022da:	a1 54 41 80 00       	mov    0x804154,%eax
  8022df:	40                   	inc    %eax
  8022e0:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8022e5:	ff 45 f4             	incl   -0xc(%ebp)
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ee:	0f 82 56 ff ff ff    	jb     80224a <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8022f4:	90                   	nop
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802305:	eb 18                	jmp    80231f <find_block+0x28>
		{
			if(tmp->sva==va)
  802307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802310:	75 05                	jne    802317 <find_block+0x20>
			{
				return tmp;
  802312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802315:	eb 11                	jmp    802328 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80231f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802323:	75 e2                	jne    802307 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802325:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802330:	a1 40 40 80 00       	mov    0x804040,%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	0f 85 83 00 00 00    	jne    8023c0 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80233d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802344:	00 00 00 
  802347:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80234e:	00 00 00 
  802351:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802358:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80235b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235f:	75 14                	jne    802375 <insert_sorted_allocList+0x4b>
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	68 10 3f 80 00       	push   $0x803f10
  802369:	6a 7f                	push   $0x7f
  80236b:	68 33 3f 80 00       	push   $0x803f33
  802370:	e8 2c e1 ff ff       	call   8004a1 <_panic>
  802375:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	74 0d                	je     802396 <insert_sorted_allocList+0x6c>
  802389:	a1 40 40 80 00       	mov    0x804040,%eax
  80238e:	8b 55 08             	mov    0x8(%ebp),%edx
  802391:	89 50 04             	mov    %edx,0x4(%eax)
  802394:	eb 08                	jmp    80239e <insert_sorted_allocList+0x74>
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	a3 44 40 80 00       	mov    %eax,0x804044
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023b5:	40                   	inc    %eax
  8023b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023bb:	e9 16 01 00 00       	jmp    8024d6 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	8b 50 08             	mov    0x8(%eax),%edx
  8023c6:	a1 44 40 80 00       	mov    0x804044,%eax
  8023cb:	8b 40 08             	mov    0x8(%eax),%eax
  8023ce:	39 c2                	cmp    %eax,%edx
  8023d0:	76 68                	jbe    80243a <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8023d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d6:	75 17                	jne    8023ef <insert_sorted_allocList+0xc5>
  8023d8:	83 ec 04             	sub    $0x4,%esp
  8023db:	68 4c 3f 80 00       	push   $0x803f4c
  8023e0:	68 85 00 00 00       	push   $0x85
  8023e5:	68 33 3f 80 00       	push   $0x803f33
  8023ea:	e8 b2 e0 ff ff       	call   8004a1 <_panic>
  8023ef:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	89 50 04             	mov    %edx,0x4(%eax)
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	74 0c                	je     802411 <insert_sorted_allocList+0xe7>
  802405:	a1 44 40 80 00       	mov    0x804044,%eax
  80240a:	8b 55 08             	mov    0x8(%ebp),%edx
  80240d:	89 10                	mov    %edx,(%eax)
  80240f:	eb 08                	jmp    802419 <insert_sorted_allocList+0xef>
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	a3 40 40 80 00       	mov    %eax,0x804040
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	a3 44 40 80 00       	mov    %eax,0x804044
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80242f:	40                   	inc    %eax
  802430:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802435:	e9 9c 00 00 00       	jmp    8024d6 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80243a:	a1 40 40 80 00       	mov    0x804040,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802442:	e9 85 00 00 00       	jmp    8024cc <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	8b 50 08             	mov    0x8(%eax),%edx
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 40 08             	mov    0x8(%eax),%eax
  802453:	39 c2                	cmp    %eax,%edx
  802455:	73 6d                	jae    8024c4 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245b:	74 06                	je     802463 <insert_sorted_allocList+0x139>
  80245d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802461:	75 17                	jne    80247a <insert_sorted_allocList+0x150>
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	68 70 3f 80 00       	push   $0x803f70
  80246b:	68 90 00 00 00       	push   $0x90
  802470:	68 33 3f 80 00       	push   $0x803f33
  802475:	e8 27 e0 ff ff       	call   8004a1 <_panic>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 50 04             	mov    0x4(%eax),%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	89 50 04             	mov    %edx,0x4(%eax)
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248c:	89 10                	mov    %edx,(%eax)
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 0d                	je     8024a5 <insert_sorted_allocList+0x17b>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a1:	89 10                	mov    %edx,(%eax)
  8024a3:	eb 08                	jmp    8024ad <insert_sorted_allocList+0x183>
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%eax)
  8024b6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024bb:	40                   	inc    %eax
  8024bc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8024c1:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024c2:	eb 12                	jmp    8024d6 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8024cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d0:	0f 85 71 ff ff ff    	jne    802447 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024d6:	90                   	nop
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024df:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8024e7:	e9 76 01 00 00       	jmp    802662 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f5:	0f 85 8a 00 00 00    	jne    802585 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ff:	75 17                	jne    802518 <alloc_block_FF+0x3f>
  802501:	83 ec 04             	sub    $0x4,%esp
  802504:	68 a5 3f 80 00       	push   $0x803fa5
  802509:	68 a8 00 00 00       	push   $0xa8
  80250e:	68 33 3f 80 00       	push   $0x803f33
  802513:	e8 89 df ff ff       	call   8004a1 <_panic>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	85 c0                	test   %eax,%eax
  80251f:	74 10                	je     802531 <alloc_block_FF+0x58>
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802529:	8b 52 04             	mov    0x4(%edx),%edx
  80252c:	89 50 04             	mov    %edx,0x4(%eax)
  80252f:	eb 0b                	jmp    80253c <alloc_block_FF+0x63>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 40 04             	mov    0x4(%eax),%eax
  802537:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 0f                	je     802555 <alloc_block_FF+0x7c>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254f:	8b 12                	mov    (%edx),%edx
  802551:	89 10                	mov    %edx,(%eax)
  802553:	eb 0a                	jmp    80255f <alloc_block_FF+0x86>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	a3 38 41 80 00       	mov    %eax,0x804138
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802572:	a1 44 41 80 00       	mov    0x804144,%eax
  802577:	48                   	dec    %eax
  802578:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	e9 ea 00 00 00       	jmp    80266f <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258e:	0f 86 c6 00 00 00    	jbe    80265a <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802594:	a1 48 41 80 00       	mov    0x804148,%eax
  802599:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80259c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259f:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a2:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ba:	89 c2                	mov    %eax,%edx
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 50 08             	mov    0x8(%eax),%edx
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	01 c2                	add    %eax,%edx
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025d7:	75 17                	jne    8025f0 <alloc_block_FF+0x117>
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	68 a5 3f 80 00       	push   $0x803fa5
  8025e1:	68 b6 00 00 00       	push   $0xb6
  8025e6:	68 33 3f 80 00       	push   $0x803f33
  8025eb:	e8 b1 de ff ff       	call   8004a1 <_panic>
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 10                	je     802609 <alloc_block_FF+0x130>
  8025f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802601:	8b 52 04             	mov    0x4(%edx),%edx
  802604:	89 50 04             	mov    %edx,0x4(%eax)
  802607:	eb 0b                	jmp    802614 <alloc_block_FF+0x13b>
  802609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 0f                	je     80262d <alloc_block_FF+0x154>
  80261e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802627:	8b 12                	mov    (%edx),%edx
  802629:	89 10                	mov    %edx,(%eax)
  80262b:	eb 0a                	jmp    802637 <alloc_block_FF+0x15e>
  80262d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	a3 48 41 80 00       	mov    %eax,0x804148
  802637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264a:	a1 54 41 80 00       	mov    0x804154,%eax
  80264f:	48                   	dec    %eax
  802650:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802658:	eb 15                	jmp    80266f <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802666:	0f 85 80 fe ff ff    	jne    8024ec <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802677:	a1 38 41 80 00       	mov    0x804138,%eax
  80267c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80267f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802686:	e9 c0 00 00 00       	jmp    80274b <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 0c             	mov    0xc(%eax),%eax
  802691:	3b 45 08             	cmp    0x8(%ebp),%eax
  802694:	0f 85 8a 00 00 00    	jne    802724 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	75 17                	jne    8026b7 <alloc_block_BF+0x46>
  8026a0:	83 ec 04             	sub    $0x4,%esp
  8026a3:	68 a5 3f 80 00       	push   $0x803fa5
  8026a8:	68 cf 00 00 00       	push   $0xcf
  8026ad:	68 33 3f 80 00       	push   $0x803f33
  8026b2:	e8 ea dd ff ff       	call   8004a1 <_panic>
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	74 10                	je     8026d0 <alloc_block_BF+0x5f>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c8:	8b 52 04             	mov    0x4(%edx),%edx
  8026cb:	89 50 04             	mov    %edx,0x4(%eax)
  8026ce:	eb 0b                	jmp    8026db <alloc_block_BF+0x6a>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 04             	mov    0x4(%eax),%eax
  8026d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 40 04             	mov    0x4(%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 0f                	je     8026f4 <alloc_block_BF+0x83>
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 04             	mov    0x4(%eax),%eax
  8026eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ee:	8b 12                	mov    (%edx),%edx
  8026f0:	89 10                	mov    %edx,(%eax)
  8026f2:	eb 0a                	jmp    8026fe <alloc_block_BF+0x8d>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802711:	a1 44 41 80 00       	mov    0x804144,%eax
  802716:	48                   	dec    %eax
  802717:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	e9 2a 01 00 00       	jmp    80284e <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80272d:	73 14                	jae    802743 <alloc_block_BF+0xd2>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 0c             	mov    0xc(%eax),%eax
  802735:	3b 45 08             	cmp    0x8(%ebp),%eax
  802738:	76 09                	jbe    802743 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80274b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274f:	0f 85 36 ff ff ff    	jne    80268b <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802755:	a1 38 41 80 00       	mov    0x804138,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80275d:	e9 dd 00 00 00       	jmp    80283f <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80276b:	0f 85 c6 00 00 00    	jne    802837 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802771:	a1 48 41 80 00       	mov    0x804148,%eax
  802776:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 50 08             	mov    0x8(%eax),%edx
  80277f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802782:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 55 08             	mov    0x8(%ebp),%edx
  80278b:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 50 08             	mov    0x8(%eax),%edx
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	01 c2                	add    %eax,%edx
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a8:	89 c2                	mov    %eax,%edx
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027b4:	75 17                	jne    8027cd <alloc_block_BF+0x15c>
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	68 a5 3f 80 00       	push   $0x803fa5
  8027be:	68 eb 00 00 00       	push   $0xeb
  8027c3:	68 33 3f 80 00       	push   $0x803f33
  8027c8:	e8 d4 dc ff ff       	call   8004a1 <_panic>
  8027cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 10                	je     8027e6 <alloc_block_BF+0x175>
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027de:	8b 52 04             	mov    0x4(%edx),%edx
  8027e1:	89 50 04             	mov    %edx,0x4(%eax)
  8027e4:	eb 0b                	jmp    8027f1 <alloc_block_BF+0x180>
  8027e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 0f                	je     80280a <alloc_block_BF+0x199>
  8027fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802804:	8b 12                	mov    (%edx),%edx
  802806:	89 10                	mov    %edx,(%eax)
  802808:	eb 0a                	jmp    802814 <alloc_block_BF+0x1a3>
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	a3 48 41 80 00       	mov    %eax,0x804148
  802814:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802820:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802827:	a1 54 41 80 00       	mov    0x804154,%eax
  80282c:	48                   	dec    %eax
  80282d:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802835:	eb 17                	jmp    80284e <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80283f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802843:	0f 85 19 ff ff ff    	jne    802762 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802849:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80284e:	c9                   	leave  
  80284f:	c3                   	ret    

00802850 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802856:	a1 40 40 80 00       	mov    0x804040,%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	75 19                	jne    802878 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80285f:	83 ec 0c             	sub    $0xc,%esp
  802862:	ff 75 08             	pushl  0x8(%ebp)
  802865:	e8 6f fc ff ff       	call   8024d9 <alloc_block_FF>
  80286a:	83 c4 10             	add    $0x10,%esp
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	e9 e9 01 00 00       	jmp    802a61 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802878:	a1 44 40 80 00       	mov    0x804044,%eax
  80287d:	8b 40 08             	mov    0x8(%eax),%eax
  802880:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802883:	a1 44 40 80 00       	mov    0x804044,%eax
  802888:	8b 50 0c             	mov    0xc(%eax),%edx
  80288b:	a1 44 40 80 00       	mov    0x804044,%eax
  802890:	8b 40 08             	mov    0x8(%eax),%eax
  802893:	01 d0                	add    %edx,%eax
  802895:	83 ec 08             	sub    $0x8,%esp
  802898:	50                   	push   %eax
  802899:	68 38 41 80 00       	push   $0x804138
  80289e:	e8 54 fa ff ff       	call   8022f7 <find_block>
  8028a3:	83 c4 10             	add    $0x10,%esp
  8028a6:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8028af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b2:	0f 85 9b 00 00 00    	jne    802953 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 08             	mov    0x8(%eax),%eax
  8028c4:	01 d0                	add    %edx,%eax
  8028c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8028c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cd:	75 17                	jne    8028e6 <alloc_block_NF+0x96>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 a5 3f 80 00       	push   $0x803fa5
  8028d7:	68 1a 01 00 00       	push   $0x11a
  8028dc:	68 33 3f 80 00       	push   $0x803f33
  8028e1:	e8 bb db ff ff       	call   8004a1 <_panic>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 10                	je     8028ff <alloc_block_NF+0xaf>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f7:	8b 52 04             	mov    0x4(%edx),%edx
  8028fa:	89 50 04             	mov    %edx,0x4(%eax)
  8028fd:	eb 0b                	jmp    80290a <alloc_block_NF+0xba>
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	74 0f                	je     802923 <alloc_block_NF+0xd3>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291d:	8b 12                	mov    (%edx),%edx
  80291f:	89 10                	mov    %edx,(%eax)
  802921:	eb 0a                	jmp    80292d <alloc_block_NF+0xdd>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	a3 38 41 80 00       	mov    %eax,0x804138
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802940:	a1 44 41 80 00       	mov    0x804144,%eax
  802945:	48                   	dec    %eax
  802946:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	e9 0e 01 00 00       	jmp    802a61 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 0c             	mov    0xc(%eax),%eax
  802959:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295c:	0f 86 cf 00 00 00    	jbe    802a31 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802962:	a1 48 41 80 00       	mov    0x804148,%eax
  802967:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	8b 55 08             	mov    0x8(%ebp),%edx
  802970:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 50 08             	mov    0x8(%eax),%edx
  802979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297c:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 50 08             	mov    0x8(%eax),%edx
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	01 c2                	add    %eax,%edx
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 0c             	mov    0xc(%eax),%eax
  802996:	2b 45 08             	sub    0x8(%ebp),%eax
  802999:	89 c2                	mov    %eax,%edx
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 08             	mov    0x8(%eax),%eax
  8029a7:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ae:	75 17                	jne    8029c7 <alloc_block_NF+0x177>
  8029b0:	83 ec 04             	sub    $0x4,%esp
  8029b3:	68 a5 3f 80 00       	push   $0x803fa5
  8029b8:	68 28 01 00 00       	push   $0x128
  8029bd:	68 33 3f 80 00       	push   $0x803f33
  8029c2:	e8 da da ff ff       	call   8004a1 <_panic>
  8029c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	74 10                	je     8029e0 <alloc_block_NF+0x190>
  8029d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d8:	8b 52 04             	mov    0x4(%edx),%edx
  8029db:	89 50 04             	mov    %edx,0x4(%eax)
  8029de:	eb 0b                	jmp    8029eb <alloc_block_NF+0x19b>
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	8b 40 04             	mov    0x4(%eax),%eax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	74 0f                	je     802a04 <alloc_block_NF+0x1b4>
  8029f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f8:	8b 40 04             	mov    0x4(%eax),%eax
  8029fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fe:	8b 12                	mov    (%edx),%edx
  802a00:	89 10                	mov    %edx,(%eax)
  802a02:	eb 0a                	jmp    802a0e <alloc_block_NF+0x1be>
  802a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	a3 48 41 80 00       	mov    %eax,0x804148
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a21:	a1 54 41 80 00       	mov    0x804154,%eax
  802a26:	48                   	dec    %eax
  802a27:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802a2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2f:	eb 30                	jmp    802a61 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802a31:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a39:	75 0a                	jne    802a45 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802a3b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a43:	eb 08                	jmp    802a4d <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 08             	mov    0x8(%eax),%eax
  802a53:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a56:	0f 85 4d fe ff ff    	jne    8028a9 <alloc_block_NF+0x59>

			return NULL;
  802a5c:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802a61:	c9                   	leave  
  802a62:	c3                   	ret    

00802a63 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a63:	55                   	push   %ebp
  802a64:	89 e5                	mov    %esp,%ebp
  802a66:	53                   	push   %ebx
  802a67:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802a6a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	0f 85 86 00 00 00    	jne    802afd <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802a77:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802a7e:	00 00 00 
  802a81:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802a88:	00 00 00 
  802a8b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802a92:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a99:	75 17                	jne    802ab2 <insert_sorted_with_merge_freeList+0x4f>
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	68 10 3f 80 00       	push   $0x803f10
  802aa3:	68 48 01 00 00       	push   $0x148
  802aa8:	68 33 3f 80 00       	push   $0x803f33
  802aad:	e8 ef d9 ff ff       	call   8004a1 <_panic>
  802ab2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0d                	je     802ad3 <insert_sorted_with_merge_freeList+0x70>
  802ac6:	a1 38 41 80 00       	mov    0x804138,%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 08                	jmp    802adb <insert_sorted_with_merge_freeList+0x78>
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aed:	a1 44 41 80 00       	mov    0x804144,%eax
  802af2:	40                   	inc    %eax
  802af3:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802af8:	e9 73 07 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	8b 50 08             	mov    0x8(%eax),%edx
  802b03:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	0f 86 84 00 00 00    	jbe    802b97 <insert_sorted_with_merge_freeList+0x134>
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 50 08             	mov    0x8(%eax),%edx
  802b19:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b1e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b21:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b26:	8b 40 08             	mov    0x8(%eax),%eax
  802b29:	01 c8                	add    %ecx,%eax
  802b2b:	39 c2                	cmp    %eax,%edx
  802b2d:	74 68                	je     802b97 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b33:	75 17                	jne    802b4c <insert_sorted_with_merge_freeList+0xe9>
  802b35:	83 ec 04             	sub    $0x4,%esp
  802b38:	68 4c 3f 80 00       	push   $0x803f4c
  802b3d:	68 4c 01 00 00       	push   $0x14c
  802b42:	68 33 3f 80 00       	push   $0x803f33
  802b47:	e8 55 d9 ff ff       	call   8004a1 <_panic>
  802b4c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	89 50 04             	mov    %edx,0x4(%eax)
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0c                	je     802b6e <insert_sorted_with_merge_freeList+0x10b>
  802b62:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b67:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	eb 08                	jmp    802b76 <insert_sorted_with_merge_freeList+0x113>
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 38 41 80 00       	mov    %eax,0x804138
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b87:	a1 44 41 80 00       	mov    0x804144,%eax
  802b8c:	40                   	inc    %eax
  802b8d:	a3 44 41 80 00       	mov    %eax,0x804144
  802b92:	e9 d9 06 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 50 08             	mov    0x8(%eax),%edx
  802b9d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba2:	8b 40 08             	mov    0x8(%eax),%eax
  802ba5:	39 c2                	cmp    %eax,%edx
  802ba7:	0f 86 b5 00 00 00    	jbe    802c62 <insert_sorted_with_merge_freeList+0x1ff>
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bb8:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bbb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc0:	8b 40 08             	mov    0x8(%eax),%eax
  802bc3:	01 c8                	add    %ecx,%eax
  802bc5:	39 c2                	cmp    %eax,%edx
  802bc7:	0f 85 95 00 00 00    	jne    802c62 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802bcd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bd2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bd8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bde:	8b 52 0c             	mov    0xc(%edx),%edx
  802be1:	01 ca                	add    %ecx,%edx
  802be3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfe:	75 17                	jne    802c17 <insert_sorted_with_merge_freeList+0x1b4>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 10 3f 80 00       	push   $0x803f10
  802c08:	68 54 01 00 00       	push   $0x154
  802c0d:	68 33 3f 80 00       	push   $0x803f33
  802c12:	e8 8a d8 ff ff       	call   8004a1 <_panic>
  802c17:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 0d                	je     802c38 <insert_sorted_with_merge_freeList+0x1d5>
  802c2b:	a1 48 41 80 00       	mov    0x804148,%eax
  802c30:	8b 55 08             	mov    0x8(%ebp),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	eb 08                	jmp    802c40 <insert_sorted_with_merge_freeList+0x1dd>
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	a3 48 41 80 00       	mov    %eax,0x804148
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c52:	a1 54 41 80 00       	mov    0x804154,%eax
  802c57:	40                   	inc    %eax
  802c58:	a3 54 41 80 00       	mov    %eax,0x804154
  802c5d:	e9 0e 06 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	8b 50 08             	mov    0x8(%eax),%edx
  802c68:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6d:	8b 40 08             	mov    0x8(%eax),%eax
  802c70:	39 c2                	cmp    %eax,%edx
  802c72:	0f 83 c1 00 00 00    	jae    802d39 <insert_sorted_with_merge_freeList+0x2d6>
  802c78:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7d:	8b 50 08             	mov    0x8(%eax),%edx
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	8b 48 08             	mov    0x8(%eax),%ecx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8c:	01 c8                	add    %ecx,%eax
  802c8e:	39 c2                	cmp    %eax,%edx
  802c90:	0f 85 a3 00 00 00    	jne    802d39 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c96:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9e:	8b 52 08             	mov    0x8(%edx),%edx
  802ca1:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ca4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802caf:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	8b 52 0c             	mov    0xc(%edx),%edx
  802cb8:	01 ca                	add    %ecx,%edx
  802cba:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd5:	75 17                	jne    802cee <insert_sorted_with_merge_freeList+0x28b>
  802cd7:	83 ec 04             	sub    $0x4,%esp
  802cda:	68 10 3f 80 00       	push   $0x803f10
  802cdf:	68 5d 01 00 00       	push   $0x15d
  802ce4:	68 33 3f 80 00       	push   $0x803f33
  802ce9:	e8 b3 d7 ff ff       	call   8004a1 <_panic>
  802cee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	89 10                	mov    %edx,(%eax)
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 0d                	je     802d0f <insert_sorted_with_merge_freeList+0x2ac>
  802d02:	a1 48 41 80 00       	mov    0x804148,%eax
  802d07:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0a:	89 50 04             	mov    %edx,0x4(%eax)
  802d0d:	eb 08                	jmp    802d17 <insert_sorted_with_merge_freeList+0x2b4>
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d29:	a1 54 41 80 00       	mov    0x804154,%eax
  802d2e:	40                   	inc    %eax
  802d2f:	a3 54 41 80 00       	mov    %eax,0x804154
  802d34:	e9 37 05 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 50 08             	mov    0x8(%eax),%edx
  802d3f:	a1 38 41 80 00       	mov    0x804138,%eax
  802d44:	8b 40 08             	mov    0x8(%eax),%eax
  802d47:	39 c2                	cmp    %eax,%edx
  802d49:	0f 83 82 00 00 00    	jae    802dd1 <insert_sorted_with_merge_freeList+0x36e>
  802d4f:	a1 38 41 80 00       	mov    0x804138,%eax
  802d54:	8b 50 08             	mov    0x8(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 48 08             	mov    0x8(%eax),%ecx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	01 c8                	add    %ecx,%eax
  802d65:	39 c2                	cmp    %eax,%edx
  802d67:	74 68                	je     802dd1 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6d:	75 17                	jne    802d86 <insert_sorted_with_merge_freeList+0x323>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 10 3f 80 00       	push   $0x803f10
  802d77:	68 62 01 00 00       	push   $0x162
  802d7c:	68 33 3f 80 00       	push   $0x803f33
  802d81:	e8 1b d7 ff ff       	call   8004a1 <_panic>
  802d86:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0d                	je     802da7 <insert_sorted_with_merge_freeList+0x344>
  802d9a:	a1 38 41 80 00       	mov    0x804138,%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 08                	jmp    802daf <insert_sorted_with_merge_freeList+0x34c>
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	a3 38 41 80 00       	mov    %eax,0x804138
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 44 41 80 00       	mov    0x804144,%eax
  802dc6:	40                   	inc    %eax
  802dc7:	a3 44 41 80 00       	mov    %eax,0x804144
  802dcc:	e9 9f 04 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802dd1:	a1 38 41 80 00       	mov    0x804138,%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802ddb:	e9 84 04 00 00       	jmp    803264 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 50 08             	mov    0x8(%eax),%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 40 08             	mov    0x8(%eax),%eax
  802dec:	39 c2                	cmp    %eax,%edx
  802dee:	0f 86 a9 00 00 00    	jbe    802e9d <insert_sorted_with_merge_freeList+0x43a>
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 50 08             	mov    0x8(%eax),%edx
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	8b 48 08             	mov    0x8(%eax),%ecx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 40 0c             	mov    0xc(%eax),%eax
  802e06:	01 c8                	add    %ecx,%eax
  802e08:	39 c2                	cmp    %eax,%edx
  802e0a:	0f 84 8d 00 00 00    	je     802e9d <insert_sorted_with_merge_freeList+0x43a>
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	8b 50 08             	mov    0x8(%eax),%edx
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	8b 48 08             	mov    0x8(%eax),%ecx
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	01 c8                	add    %ecx,%eax
  802e2a:	39 c2                	cmp    %eax,%edx
  802e2c:	74 6f                	je     802e9d <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802e2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e32:	74 06                	je     802e3a <insert_sorted_with_merge_freeList+0x3d7>
  802e34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e38:	75 17                	jne    802e51 <insert_sorted_with_merge_freeList+0x3ee>
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	68 70 3f 80 00       	push   $0x803f70
  802e42:	68 6b 01 00 00       	push   $0x16b
  802e47:	68 33 3f 80 00       	push   $0x803f33
  802e4c:	e8 50 d6 ff ff       	call   8004a1 <_panic>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 50 04             	mov    0x4(%eax),%edx
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e63:	89 10                	mov    %edx,(%eax)
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 0d                	je     802e7c <insert_sorted_with_merge_freeList+0x419>
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	8b 55 08             	mov    0x8(%ebp),%edx
  802e78:	89 10                	mov    %edx,(%eax)
  802e7a:	eb 08                	jmp    802e84 <insert_sorted_with_merge_freeList+0x421>
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	a3 38 41 80 00       	mov    %eax,0x804138
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8a:	89 50 04             	mov    %edx,0x4(%eax)
  802e8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802e92:	40                   	inc    %eax
  802e93:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802e98:	e9 d3 03 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	0f 86 da 00 00 00    	jbe    802f8b <insert_sorted_with_merge_freeList+0x528>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 50 08             	mov    0x8(%eax),%edx
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 48 08             	mov    0x8(%eax),%ecx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	01 c8                	add    %ecx,%eax
  802ec5:	39 c2                	cmp    %eax,%edx
  802ec7:	0f 85 be 00 00 00    	jne    802f8b <insert_sorted_with_merge_freeList+0x528>
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	8b 50 08             	mov    0x8(%eax),%edx
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	8b 48 08             	mov    0x8(%eax),%ecx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 04             	mov    0x4(%eax),%eax
  802ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee5:	01 c8                	add    %ecx,%eax
  802ee7:	39 c2                	cmp    %eax,%edx
  802ee9:	0f 84 9c 00 00 00    	je     802f8b <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 50 08             	mov    0x8(%eax),%edx
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 50 0c             	mov    0xc(%eax),%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	8b 40 0c             	mov    0xc(%eax),%eax
  802f07:	01 c2                	add    %eax,%edx
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f27:	75 17                	jne    802f40 <insert_sorted_with_merge_freeList+0x4dd>
  802f29:	83 ec 04             	sub    $0x4,%esp
  802f2c:	68 10 3f 80 00       	push   $0x803f10
  802f31:	68 74 01 00 00       	push   $0x174
  802f36:	68 33 3f 80 00       	push   $0x803f33
  802f3b:	e8 61 d5 ff ff       	call   8004a1 <_panic>
  802f40:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	89 10                	mov    %edx,(%eax)
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 0d                	je     802f61 <insert_sorted_with_merge_freeList+0x4fe>
  802f54:	a1 48 41 80 00       	mov    0x804148,%eax
  802f59:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5c:	89 50 04             	mov    %edx,0x4(%eax)
  802f5f:	eb 08                	jmp    802f69 <insert_sorted_with_merge_freeList+0x506>
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	a3 48 41 80 00       	mov    %eax,0x804148
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f80:	40                   	inc    %eax
  802f81:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f86:	e9 e5 02 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 40 08             	mov    0x8(%eax),%eax
  802f97:	39 c2                	cmp    %eax,%edx
  802f99:	0f 86 d7 00 00 00    	jbe    803076 <insert_sorted_with_merge_freeList+0x613>
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 50 08             	mov    0x8(%eax),%edx
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 48 08             	mov    0x8(%eax),%ecx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	01 c8                	add    %ecx,%eax
  802fb3:	39 c2                	cmp    %eax,%edx
  802fb5:	0f 84 bb 00 00 00    	je     803076 <insert_sorted_with_merge_freeList+0x613>
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	8b 50 08             	mov    0x8(%eax),%edx
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	8b 48 08             	mov    0x8(%eax),%ecx
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd3:	01 c8                	add    %ecx,%eax
  802fd5:	39 c2                	cmp    %eax,%edx
  802fd7:	0f 85 99 00 00 00    	jne    803076 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 04             	mov    0x4(%eax),%eax
  802fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80300e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803012:	75 17                	jne    80302b <insert_sorted_with_merge_freeList+0x5c8>
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	68 10 3f 80 00       	push   $0x803f10
  80301c:	68 7d 01 00 00       	push   $0x17d
  803021:	68 33 3f 80 00       	push   $0x803f33
  803026:	e8 76 d4 ff ff       	call   8004a1 <_panic>
  80302b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	89 10                	mov    %edx,(%eax)
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0d                	je     80304c <insert_sorted_with_merge_freeList+0x5e9>
  80303f:	a1 48 41 80 00       	mov    0x804148,%eax
  803044:	8b 55 08             	mov    0x8(%ebp),%edx
  803047:	89 50 04             	mov    %edx,0x4(%eax)
  80304a:	eb 08                	jmp    803054 <insert_sorted_with_merge_freeList+0x5f1>
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 48 41 80 00       	mov    %eax,0x804148
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 54 41 80 00       	mov    0x804154,%eax
  80306b:	40                   	inc    %eax
  80306c:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  803071:	e9 fa 01 00 00       	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 50 08             	mov    0x8(%eax),%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 40 08             	mov    0x8(%eax),%eax
  803082:	39 c2                	cmp    %eax,%edx
  803084:	0f 86 d2 01 00 00    	jbe    80325c <insert_sorted_with_merge_freeList+0x7f9>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 50 08             	mov    0x8(%eax),%edx
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 48 08             	mov    0x8(%eax),%ecx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 40 0c             	mov    0xc(%eax),%eax
  80309c:	01 c8                	add    %ecx,%eax
  80309e:	39 c2                	cmp    %eax,%edx
  8030a0:	0f 85 b6 01 00 00    	jne    80325c <insert_sorted_with_merge_freeList+0x7f9>
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 50 08             	mov    0x8(%eax),%edx
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	8b 48 08             	mov    0x8(%eax),%ecx
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030be:	01 c8                	add    %ecx,%eax
  8030c0:	39 c2                	cmp    %eax,%edx
  8030c2:	0f 85 94 01 00 00    	jne    80325c <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d1:	8b 52 04             	mov    0x4(%edx),%edx
  8030d4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030da:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8030dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e0:	8b 52 0c             	mov    0xc(%edx),%edx
  8030e3:	01 da                	add    %ebx,%edx
  8030e5:	01 ca                	add    %ecx,%edx
  8030e7:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8030fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803102:	75 17                	jne    80311b <insert_sorted_with_merge_freeList+0x6b8>
  803104:	83 ec 04             	sub    $0x4,%esp
  803107:	68 a5 3f 80 00       	push   $0x803fa5
  80310c:	68 86 01 00 00       	push   $0x186
  803111:	68 33 3f 80 00       	push   $0x803f33
  803116:	e8 86 d3 ff ff       	call   8004a1 <_panic>
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 10                	je     803134 <insert_sorted_with_merge_freeList+0x6d1>
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312c:	8b 52 04             	mov    0x4(%edx),%edx
  80312f:	89 50 04             	mov    %edx,0x4(%eax)
  803132:	eb 0b                	jmp    80313f <insert_sorted_with_merge_freeList+0x6dc>
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0f                	je     803158 <insert_sorted_with_merge_freeList+0x6f5>
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 40 04             	mov    0x4(%eax),%eax
  80314f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803152:	8b 12                	mov    (%edx),%edx
  803154:	89 10                	mov    %edx,(%eax)
  803156:	eb 0a                	jmp    803162 <insert_sorted_with_merge_freeList+0x6ff>
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	a3 38 41 80 00       	mov    %eax,0x804138
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803175:	a1 44 41 80 00       	mov    0x804144,%eax
  80317a:	48                   	dec    %eax
  80317b:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803184:	75 17                	jne    80319d <insert_sorted_with_merge_freeList+0x73a>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 10 3f 80 00       	push   $0x803f10
  80318e:	68 87 01 00 00       	push   $0x187
  803193:	68 33 3f 80 00       	push   $0x803f33
  803198:	e8 04 d3 ff ff       	call   8004a1 <_panic>
  80319d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 0d                	je     8031be <insert_sorted_with_merge_freeList+0x75b>
  8031b1:	a1 48 41 80 00       	mov    0x804148,%eax
  8031b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 08                	jmp    8031c6 <insert_sorted_with_merge_freeList+0x763>
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	a3 48 41 80 00       	mov    %eax,0x804148
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 54 41 80 00       	mov    0x804154,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fb:	75 17                	jne    803214 <insert_sorted_with_merge_freeList+0x7b1>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 10 3f 80 00       	push   $0x803f10
  803205:	68 8a 01 00 00       	push   $0x18a
  80320a:	68 33 3f 80 00       	push   $0x803f33
  80320f:	e8 8d d2 ff ff       	call   8004a1 <_panic>
  803214:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 0d                	je     803235 <insert_sorted_with_merge_freeList+0x7d2>
  803228:	a1 48 41 80 00       	mov    0x804148,%eax
  80322d:	8b 55 08             	mov    0x8(%ebp),%edx
  803230:	89 50 04             	mov    %edx,0x4(%eax)
  803233:	eb 08                	jmp    80323d <insert_sorted_with_merge_freeList+0x7da>
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	a3 48 41 80 00       	mov    %eax,0x804148
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324f:	a1 54 41 80 00       	mov    0x804154,%eax
  803254:	40                   	inc    %eax
  803255:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  80325a:	eb 14                	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803268:	0f 85 72 fb ff ff    	jne    802de0 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80326e:	eb 00                	jmp    803270 <insert_sorted_with_merge_freeList+0x80d>
  803270:	90                   	nop
  803271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803274:	c9                   	leave  
  803275:	c3                   	ret    
  803276:	66 90                	xchg   %ax,%ax

00803278 <__udivdi3>:
  803278:	55                   	push   %ebp
  803279:	57                   	push   %edi
  80327a:	56                   	push   %esi
  80327b:	53                   	push   %ebx
  80327c:	83 ec 1c             	sub    $0x1c,%esp
  80327f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803283:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803287:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80328b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80328f:	89 ca                	mov    %ecx,%edx
  803291:	89 f8                	mov    %edi,%eax
  803293:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803297:	85 f6                	test   %esi,%esi
  803299:	75 2d                	jne    8032c8 <__udivdi3+0x50>
  80329b:	39 cf                	cmp    %ecx,%edi
  80329d:	77 65                	ja     803304 <__udivdi3+0x8c>
  80329f:	89 fd                	mov    %edi,%ebp
  8032a1:	85 ff                	test   %edi,%edi
  8032a3:	75 0b                	jne    8032b0 <__udivdi3+0x38>
  8032a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032aa:	31 d2                	xor    %edx,%edx
  8032ac:	f7 f7                	div    %edi
  8032ae:	89 c5                	mov    %eax,%ebp
  8032b0:	31 d2                	xor    %edx,%edx
  8032b2:	89 c8                	mov    %ecx,%eax
  8032b4:	f7 f5                	div    %ebp
  8032b6:	89 c1                	mov    %eax,%ecx
  8032b8:	89 d8                	mov    %ebx,%eax
  8032ba:	f7 f5                	div    %ebp
  8032bc:	89 cf                	mov    %ecx,%edi
  8032be:	89 fa                	mov    %edi,%edx
  8032c0:	83 c4 1c             	add    $0x1c,%esp
  8032c3:	5b                   	pop    %ebx
  8032c4:	5e                   	pop    %esi
  8032c5:	5f                   	pop    %edi
  8032c6:	5d                   	pop    %ebp
  8032c7:	c3                   	ret    
  8032c8:	39 ce                	cmp    %ecx,%esi
  8032ca:	77 28                	ja     8032f4 <__udivdi3+0x7c>
  8032cc:	0f bd fe             	bsr    %esi,%edi
  8032cf:	83 f7 1f             	xor    $0x1f,%edi
  8032d2:	75 40                	jne    803314 <__udivdi3+0x9c>
  8032d4:	39 ce                	cmp    %ecx,%esi
  8032d6:	72 0a                	jb     8032e2 <__udivdi3+0x6a>
  8032d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032dc:	0f 87 9e 00 00 00    	ja     803380 <__udivdi3+0x108>
  8032e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e7:	89 fa                	mov    %edi,%edx
  8032e9:	83 c4 1c             	add    $0x1c,%esp
  8032ec:	5b                   	pop    %ebx
  8032ed:	5e                   	pop    %esi
  8032ee:	5f                   	pop    %edi
  8032ef:	5d                   	pop    %ebp
  8032f0:	c3                   	ret    
  8032f1:	8d 76 00             	lea    0x0(%esi),%esi
  8032f4:	31 ff                	xor    %edi,%edi
  8032f6:	31 c0                	xor    %eax,%eax
  8032f8:	89 fa                	mov    %edi,%edx
  8032fa:	83 c4 1c             	add    $0x1c,%esp
  8032fd:	5b                   	pop    %ebx
  8032fe:	5e                   	pop    %esi
  8032ff:	5f                   	pop    %edi
  803300:	5d                   	pop    %ebp
  803301:	c3                   	ret    
  803302:	66 90                	xchg   %ax,%ax
  803304:	89 d8                	mov    %ebx,%eax
  803306:	f7 f7                	div    %edi
  803308:	31 ff                	xor    %edi,%edi
  80330a:	89 fa                	mov    %edi,%edx
  80330c:	83 c4 1c             	add    $0x1c,%esp
  80330f:	5b                   	pop    %ebx
  803310:	5e                   	pop    %esi
  803311:	5f                   	pop    %edi
  803312:	5d                   	pop    %ebp
  803313:	c3                   	ret    
  803314:	bd 20 00 00 00       	mov    $0x20,%ebp
  803319:	89 eb                	mov    %ebp,%ebx
  80331b:	29 fb                	sub    %edi,%ebx
  80331d:	89 f9                	mov    %edi,%ecx
  80331f:	d3 e6                	shl    %cl,%esi
  803321:	89 c5                	mov    %eax,%ebp
  803323:	88 d9                	mov    %bl,%cl
  803325:	d3 ed                	shr    %cl,%ebp
  803327:	89 e9                	mov    %ebp,%ecx
  803329:	09 f1                	or     %esi,%ecx
  80332b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80332f:	89 f9                	mov    %edi,%ecx
  803331:	d3 e0                	shl    %cl,%eax
  803333:	89 c5                	mov    %eax,%ebp
  803335:	89 d6                	mov    %edx,%esi
  803337:	88 d9                	mov    %bl,%cl
  803339:	d3 ee                	shr    %cl,%esi
  80333b:	89 f9                	mov    %edi,%ecx
  80333d:	d3 e2                	shl    %cl,%edx
  80333f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803343:	88 d9                	mov    %bl,%cl
  803345:	d3 e8                	shr    %cl,%eax
  803347:	09 c2                	or     %eax,%edx
  803349:	89 d0                	mov    %edx,%eax
  80334b:	89 f2                	mov    %esi,%edx
  80334d:	f7 74 24 0c          	divl   0xc(%esp)
  803351:	89 d6                	mov    %edx,%esi
  803353:	89 c3                	mov    %eax,%ebx
  803355:	f7 e5                	mul    %ebp
  803357:	39 d6                	cmp    %edx,%esi
  803359:	72 19                	jb     803374 <__udivdi3+0xfc>
  80335b:	74 0b                	je     803368 <__udivdi3+0xf0>
  80335d:	89 d8                	mov    %ebx,%eax
  80335f:	31 ff                	xor    %edi,%edi
  803361:	e9 58 ff ff ff       	jmp    8032be <__udivdi3+0x46>
  803366:	66 90                	xchg   %ax,%ax
  803368:	8b 54 24 08          	mov    0x8(%esp),%edx
  80336c:	89 f9                	mov    %edi,%ecx
  80336e:	d3 e2                	shl    %cl,%edx
  803370:	39 c2                	cmp    %eax,%edx
  803372:	73 e9                	jae    80335d <__udivdi3+0xe5>
  803374:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803377:	31 ff                	xor    %edi,%edi
  803379:	e9 40 ff ff ff       	jmp    8032be <__udivdi3+0x46>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	31 c0                	xor    %eax,%eax
  803382:	e9 37 ff ff ff       	jmp    8032be <__udivdi3+0x46>
  803387:	90                   	nop

00803388 <__umoddi3>:
  803388:	55                   	push   %ebp
  803389:	57                   	push   %edi
  80338a:	56                   	push   %esi
  80338b:	53                   	push   %ebx
  80338c:	83 ec 1c             	sub    $0x1c,%esp
  80338f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803393:	8b 74 24 34          	mov    0x34(%esp),%esi
  803397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80339f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033a7:	89 f3                	mov    %esi,%ebx
  8033a9:	89 fa                	mov    %edi,%edx
  8033ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033af:	89 34 24             	mov    %esi,(%esp)
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	75 1a                	jne    8033d0 <__umoddi3+0x48>
  8033b6:	39 f7                	cmp    %esi,%edi
  8033b8:	0f 86 a2 00 00 00    	jbe    803460 <__umoddi3+0xd8>
  8033be:	89 c8                	mov    %ecx,%eax
  8033c0:	89 f2                	mov    %esi,%edx
  8033c2:	f7 f7                	div    %edi
  8033c4:	89 d0                	mov    %edx,%eax
  8033c6:	31 d2                	xor    %edx,%edx
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	39 f0                	cmp    %esi,%eax
  8033d2:	0f 87 ac 00 00 00    	ja     803484 <__umoddi3+0xfc>
  8033d8:	0f bd e8             	bsr    %eax,%ebp
  8033db:	83 f5 1f             	xor    $0x1f,%ebp
  8033de:	0f 84 ac 00 00 00    	je     803490 <__umoddi3+0x108>
  8033e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8033e9:	29 ef                	sub    %ebp,%edi
  8033eb:	89 fe                	mov    %edi,%esi
  8033ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033f1:	89 e9                	mov    %ebp,%ecx
  8033f3:	d3 e0                	shl    %cl,%eax
  8033f5:	89 d7                	mov    %edx,%edi
  8033f7:	89 f1                	mov    %esi,%ecx
  8033f9:	d3 ef                	shr    %cl,%edi
  8033fb:	09 c7                	or     %eax,%edi
  8033fd:	89 e9                	mov    %ebp,%ecx
  8033ff:	d3 e2                	shl    %cl,%edx
  803401:	89 14 24             	mov    %edx,(%esp)
  803404:	89 d8                	mov    %ebx,%eax
  803406:	d3 e0                	shl    %cl,%eax
  803408:	89 c2                	mov    %eax,%edx
  80340a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80340e:	d3 e0                	shl    %cl,%eax
  803410:	89 44 24 04          	mov    %eax,0x4(%esp)
  803414:	8b 44 24 08          	mov    0x8(%esp),%eax
  803418:	89 f1                	mov    %esi,%ecx
  80341a:	d3 e8                	shr    %cl,%eax
  80341c:	09 d0                	or     %edx,%eax
  80341e:	d3 eb                	shr    %cl,%ebx
  803420:	89 da                	mov    %ebx,%edx
  803422:	f7 f7                	div    %edi
  803424:	89 d3                	mov    %edx,%ebx
  803426:	f7 24 24             	mull   (%esp)
  803429:	89 c6                	mov    %eax,%esi
  80342b:	89 d1                	mov    %edx,%ecx
  80342d:	39 d3                	cmp    %edx,%ebx
  80342f:	0f 82 87 00 00 00    	jb     8034bc <__umoddi3+0x134>
  803435:	0f 84 91 00 00 00    	je     8034cc <__umoddi3+0x144>
  80343b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80343f:	29 f2                	sub    %esi,%edx
  803441:	19 cb                	sbb    %ecx,%ebx
  803443:	89 d8                	mov    %ebx,%eax
  803445:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803449:	d3 e0                	shl    %cl,%eax
  80344b:	89 e9                	mov    %ebp,%ecx
  80344d:	d3 ea                	shr    %cl,%edx
  80344f:	09 d0                	or     %edx,%eax
  803451:	89 e9                	mov    %ebp,%ecx
  803453:	d3 eb                	shr    %cl,%ebx
  803455:	89 da                	mov    %ebx,%edx
  803457:	83 c4 1c             	add    $0x1c,%esp
  80345a:	5b                   	pop    %ebx
  80345b:	5e                   	pop    %esi
  80345c:	5f                   	pop    %edi
  80345d:	5d                   	pop    %ebp
  80345e:	c3                   	ret    
  80345f:	90                   	nop
  803460:	89 fd                	mov    %edi,%ebp
  803462:	85 ff                	test   %edi,%edi
  803464:	75 0b                	jne    803471 <__umoddi3+0xe9>
  803466:	b8 01 00 00 00       	mov    $0x1,%eax
  80346b:	31 d2                	xor    %edx,%edx
  80346d:	f7 f7                	div    %edi
  80346f:	89 c5                	mov    %eax,%ebp
  803471:	89 f0                	mov    %esi,%eax
  803473:	31 d2                	xor    %edx,%edx
  803475:	f7 f5                	div    %ebp
  803477:	89 c8                	mov    %ecx,%eax
  803479:	f7 f5                	div    %ebp
  80347b:	89 d0                	mov    %edx,%eax
  80347d:	e9 44 ff ff ff       	jmp    8033c6 <__umoddi3+0x3e>
  803482:	66 90                	xchg   %ax,%ax
  803484:	89 c8                	mov    %ecx,%eax
  803486:	89 f2                	mov    %esi,%edx
  803488:	83 c4 1c             	add    $0x1c,%esp
  80348b:	5b                   	pop    %ebx
  80348c:	5e                   	pop    %esi
  80348d:	5f                   	pop    %edi
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    
  803490:	3b 04 24             	cmp    (%esp),%eax
  803493:	72 06                	jb     80349b <__umoddi3+0x113>
  803495:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803499:	77 0f                	ja     8034aa <__umoddi3+0x122>
  80349b:	89 f2                	mov    %esi,%edx
  80349d:	29 f9                	sub    %edi,%ecx
  80349f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034a3:	89 14 24             	mov    %edx,(%esp)
  8034a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034ae:	8b 14 24             	mov    (%esp),%edx
  8034b1:	83 c4 1c             	add    $0x1c,%esp
  8034b4:	5b                   	pop    %ebx
  8034b5:	5e                   	pop    %esi
  8034b6:	5f                   	pop    %edi
  8034b7:	5d                   	pop    %ebp
  8034b8:	c3                   	ret    
  8034b9:	8d 76 00             	lea    0x0(%esi),%esi
  8034bc:	2b 04 24             	sub    (%esp),%eax
  8034bf:	19 fa                	sbb    %edi,%edx
  8034c1:	89 d1                	mov    %edx,%ecx
  8034c3:	89 c6                	mov    %eax,%esi
  8034c5:	e9 71 ff ff ff       	jmp    80343b <__umoddi3+0xb3>
  8034ca:	66 90                	xchg   %ax,%ax
  8034cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034d0:	72 ea                	jb     8034bc <__umoddi3+0x134>
  8034d2:	89 d9                	mov    %ebx,%ecx
  8034d4:	e9 62 ff ff ff       	jmp    80343b <__umoddi3+0xb3>
