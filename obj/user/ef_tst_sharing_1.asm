
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
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
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 20 35 80 00       	push   $0x803520
  800092:	6a 12                	push   $0x12
  800094:	68 3c 35 80 00       	push   $0x80353c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 35 80 00       	push   $0x803554
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 8b 1a 00 00       	call   801b3e <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 8b 35 80 00       	push   $0x80358b
  8000c5:	e8 71 17 00 00       	call   80183b <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 90 35 80 00       	push   $0x803590
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 3c 35 80 00       	push   $0x80353c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 49 1a 00 00       	call   801b3e <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 38 1a 00 00       	call   801b3e <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 31 1a 00 00       	call   801b3e <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 fc 35 80 00       	push   $0x8035fc
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 3c 35 80 00       	push   $0x80353c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 13 1a 00 00       	call   801b3e <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 83 36 80 00       	push   $0x803683
  80013d:	e8 f9 16 00 00       	call   80183b <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address   ");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 88 36 80 00       	push   $0x803688
  800159:	6a 1f                	push   $0x1f
  80015b:	68 3c 35 80 00       	push   $0x80353c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 d1 19 00 00       	call   801b3e <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 c0 19 00 00       	call   801b3e <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 b9 19 00 00       	call   801b3e <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 fc 35 80 00       	push   $0x8035fc
  800192:	6a 21                	push   $0x21
  800194:	68 3c 35 80 00       	push   $0x80353c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 9b 19 00 00       	call   801b3e <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 f7 36 80 00       	push   $0x8036f7
  8001b2:	e8 84 16 00 00       	call   80183b <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 90 35 80 00       	push   $0x803590
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 3c 35 80 00       	push   $0x80353c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 5c 19 00 00       	call   801b3e <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 fc 36 80 00       	push   $0x8036fc
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 3c 35 80 00       	push   $0x80353c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 7c 37 80 00       	push   $0x80377c
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 a4 37 80 00       	push   $0x8037a4
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 cc 37 80 00       	push   $0x8037cc
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 3c 35 80 00       	push   $0x80353c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 cc 37 80 00       	push   $0x8037cc
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 3c 35 80 00       	push   $0x80353c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 cc 37 80 00       	push   $0x8037cc
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 3c 35 80 00       	push   $0x80353c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 cc 37 80 00       	push   $0x8037cc
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 3c 35 80 00       	push   $0x80353c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 cc 37 80 00       	push   $0x8037cc
  80031c:	6a 40                	push   $0x40
  80031e:	68 3c 35 80 00       	push   $0x80353c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 cc 37 80 00       	push   $0x8037cc
  80033f:	6a 41                	push   $0x41
  800341:	68 3c 35 80 00       	push   $0x80353c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 f8 37 80 00       	push   $0x8037f8
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 d7 1a 00 00       	call   801e37 <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 4c 38 80 00       	push   $0x80384c
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 7e 15 00 00       	call   8018fe <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 79 1a 00 00       	call   801e1e <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 1b 18 00 00       	call   801c2b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 74 38 80 00       	push   $0x803874
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 50 80 00       	mov    0x805020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 50 80 00       	mov    0x805020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 9c 38 80 00       	push   $0x80389c
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 50 80 00       	mov    0x805020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 50 80 00       	mov    0x805020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 c4 38 80 00       	push   $0x8038c4
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 1c 39 80 00       	push   $0x80391c
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 74 38 80 00       	push   $0x803874
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 9b 17 00 00       	call   801c45 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 28 19 00 00       	call   801dea <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 7d 19 00 00       	call   801e50 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 30 39 80 00       	push   $0x803930
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 35 39 80 00       	push   $0x803935
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 51 39 80 00       	push   $0x803951
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 50 80 00       	mov    0x805020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 54 39 80 00       	push   $0x803954
  800565:	6a 26                	push   $0x26
  800567:	68 a0 39 80 00       	push   $0x8039a0
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 50 80 00       	mov    0x805020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 ac 39 80 00       	push   $0x8039ac
  800637:	6a 3a                	push   $0x3a
  800639:	68 a0 39 80 00       	push   $0x8039a0
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 50 80 00       	mov    0x805020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 50 80 00       	mov    0x805020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 00 3a 80 00       	push   $0x803a00
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 a0 39 80 00       	push   $0x8039a0
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 50 80 00       	mov    0x805024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 7c 13 00 00       	call   801a7d <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 50 80 00       	mov    0x805024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 05 13 00 00       	call   801a7d <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 69 14 00 00       	call   801c2b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 63 14 00 00       	call   801c45 <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 80 2a 00 00       	call   8032ac <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 40 2b 00 00       	call   8033bc <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 74 3c 80 00       	add    $0x803c74,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 85 3c 80 00       	push   $0x803c85
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 8e 3c 80 00       	push   $0x803c8e
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 50 80 00       	mov    0x805004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 f0 3d 80 00       	push   $0x803df0
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80154b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801552:	00 00 00 
  801555:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80155c:	00 00 00 
  80155f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801566:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801569:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801570:	00 00 00 
  801573:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80157a:	00 00 00 
  80157d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801584:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801587:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80158e:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801591:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801598:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ac:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8015b1:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8015b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	6a 06                	push   $0x6
  8015ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cd:	50                   	push   %eax
  8015ce:	e8 ee 05 00 00       	call   801bc1 <sys_allocate_chunk>
  8015d3:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	50                   	push   %eax
  8015df:	e8 63 0c 00 00       	call   802247 <initialize_MemBlocksList>
  8015e4:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8015e7:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8015ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8015ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8015f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801605:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160a:	89 c2                	mov    %eax,%edx
  80160c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80160f:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801615:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80161c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801626:	8b 50 08             	mov    0x8(%eax),%edx
  801629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162c:	01 d0                	add    %edx,%eax
  80162e:	48                   	dec    %eax
  80162f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801632:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801635:	ba 00 00 00 00       	mov    $0x0,%edx
  80163a:	f7 75 e0             	divl   -0x20(%ebp)
  80163d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801640:	29 d0                	sub    %edx,%eax
  801642:	89 c2                	mov    %eax,%edx
  801644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801647:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80164a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80164e:	75 14                	jne    801664 <initialize_dyn_block_system+0x11f>
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	68 15 3e 80 00       	push   $0x803e15
  801658:	6a 34                	push   $0x34
  80165a:	68 33 3e 80 00       	push   $0x803e33
  80165f:	e8 72 ee ff ff       	call   8004d6 <_panic>
  801664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801667:	8b 00                	mov    (%eax),%eax
  801669:	85 c0                	test   %eax,%eax
  80166b:	74 10                	je     80167d <initialize_dyn_block_system+0x138>
  80166d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801675:	8b 52 04             	mov    0x4(%edx),%edx
  801678:	89 50 04             	mov    %edx,0x4(%eax)
  80167b:	eb 0b                	jmp    801688 <initialize_dyn_block_system+0x143>
  80167d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801680:	8b 40 04             	mov    0x4(%eax),%eax
  801683:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	85 c0                	test   %eax,%eax
  801690:	74 0f                	je     8016a1 <initialize_dyn_block_system+0x15c>
  801692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801695:	8b 40 04             	mov    0x4(%eax),%eax
  801698:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80169b:	8b 12                	mov    (%edx),%edx
  80169d:	89 10                	mov    %edx,(%eax)
  80169f:	eb 0a                	jmp    8016ab <initialize_dyn_block_system+0x166>
  8016a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a4:	8b 00                	mov    (%eax),%eax
  8016a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8016ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016be:	a1 54 51 80 00       	mov    0x805154,%eax
  8016c3:	48                   	dec    %eax
  8016c4:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8016c9:	83 ec 0c             	sub    $0xc,%esp
  8016cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8016cf:	e8 c4 13 00 00       	call   802a98 <insert_sorted_with_merge_freeList>
  8016d4:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016d7:	90                   	nop
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <malloc>:
//=================================



void* malloc(uint32 size)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e0:	e8 2f fe ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e9:	75 07                	jne    8016f2 <malloc+0x18>
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f0:	eb 71                	jmp    801763 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016f2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016f9:	76 07                	jbe    801702 <malloc+0x28>
	return NULL;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	eb 61                	jmp    801763 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801702:	e8 88 08 00 00       	call   801f8f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801707:	85 c0                	test   %eax,%eax
  801709:	74 53                	je     80175e <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80170b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801712:	8b 55 08             	mov    0x8(%ebp),%edx
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	48                   	dec    %eax
  80171b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801721:	ba 00 00 00 00       	mov    $0x0,%edx
  801726:	f7 75 f4             	divl   -0xc(%ebp)
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	29 d0                	sub    %edx,%eax
  80172e:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801731:	83 ec 0c             	sub    $0xc,%esp
  801734:	ff 75 ec             	pushl  -0x14(%ebp)
  801737:	e8 d2 0d 00 00       	call   80250e <alloc_block_FF>
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801742:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801746:	74 16                	je     80175e <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 e8             	pushl  -0x18(%ebp)
  80174e:	e8 0c 0c 00 00       	call   80235f <insert_sorted_allocList>
  801753:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801759:	8b 40 08             	mov    0x8(%eax),%eax
  80175c:	eb 05                	jmp    801763 <malloc+0x89>
    }

			}


	return NULL;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801774:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801779:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80177c:	83 ec 08             	sub    $0x8,%esp
  80177f:	ff 75 f0             	pushl  -0x10(%ebp)
  801782:	68 40 50 80 00       	push   $0x805040
  801787:	e8 a0 0b 00 00       	call   80232c <find_block>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801795:	8b 50 0c             	mov    0xc(%eax),%edx
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	83 ec 08             	sub    $0x8,%esp
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	e8 e4 03 00 00       	call   801b89 <sys_free_user_mem>
  8017a5:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8017a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ac:	75 17                	jne    8017c5 <free+0x60>
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 15 3e 80 00       	push   $0x803e15
  8017b6:	68 84 00 00 00       	push   $0x84
  8017bb:	68 33 3e 80 00       	push   $0x803e33
  8017c0:	e8 11 ed ff ff       	call   8004d6 <_panic>
  8017c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c8:	8b 00                	mov    (%eax),%eax
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	74 10                	je     8017de <free+0x79>
  8017ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d1:	8b 00                	mov    (%eax),%eax
  8017d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d6:	8b 52 04             	mov    0x4(%edx),%edx
  8017d9:	89 50 04             	mov    %edx,0x4(%eax)
  8017dc:	eb 0b                	jmp    8017e9 <free+0x84>
  8017de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e1:	8b 40 04             	mov    0x4(%eax),%eax
  8017e4:	a3 44 50 80 00       	mov    %eax,0x805044
  8017e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ec:	8b 40 04             	mov    0x4(%eax),%eax
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	74 0f                	je     801802 <free+0x9d>
  8017f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f6:	8b 40 04             	mov    0x4(%eax),%eax
  8017f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017fc:	8b 12                	mov    (%edx),%edx
  8017fe:	89 10                	mov    %edx,(%eax)
  801800:	eb 0a                	jmp    80180c <free+0xa7>
  801802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801805:	8b 00                	mov    (%eax),%eax
  801807:	a3 40 50 80 00       	mov    %eax,0x805040
  80180c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801818:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80181f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801824:	48                   	dec    %eax
  801825:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  80182a:	83 ec 0c             	sub    $0xc,%esp
  80182d:	ff 75 ec             	pushl  -0x14(%ebp)
  801830:	e8 63 12 00 00       	call   802a98 <insert_sorted_with_merge_freeList>
  801835:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 38             	sub    $0x38,%esp
  801841:	8b 45 10             	mov    0x10(%ebp),%eax
  801844:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801847:	e8 c8 fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80184c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801850:	75 0a                	jne    80185c <smalloc+0x21>
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	e9 a0 00 00 00       	jmp    8018fc <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80185c:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801863:	76 0a                	jbe    80186f <smalloc+0x34>
		return NULL;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	e9 8d 00 00 00       	jmp    8018fc <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80186f:	e8 1b 07 00 00       	call   801f8f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801874:	85 c0                	test   %eax,%eax
  801876:	74 7f                	je     8018f7 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801878:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80187f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801885:	01 d0                	add    %edx,%eax
  801887:	48                   	dec    %eax
  801888:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	f7 75 f4             	divl   -0xc(%ebp)
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	29 d0                	sub    %edx,%eax
  80189b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8018a4:	e8 65 0c 00 00       	call   80250e <alloc_block_FF>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8018af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018b3:	74 42                	je     8018f7 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8018b5:	83 ec 0c             	sub    $0xc,%esp
  8018b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8018bb:	e8 9f 0a 00 00       	call   80235f <insert_sorted_allocList>
  8018c0:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8018c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c6:	8b 40 08             	mov    0x8(%eax),%eax
  8018c9:	89 c2                	mov    %eax,%edx
  8018cb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	ff 75 08             	pushl  0x8(%ebp)
  8018d7:	e8 38 04 00 00       	call   801d14 <sys_createSharedObject>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8018e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e6:	79 07                	jns    8018ef <smalloc+0xb4>
	    		  return NULL;
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	eb 0d                	jmp    8018fc <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8018ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f2:	8b 40 08             	mov    0x8(%eax),%eax
  8018f5:	eb 05                	jmp    8018fc <smalloc+0xc1>


				}


		return NULL;
  8018f7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801904:	e8 0b fc ff ff       	call   801514 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801909:	e8 81 06 00 00       	call   801f8f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80190e:	85 c0                	test   %eax,%eax
  801910:	0f 84 9f 00 00 00    	je     8019b5 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 1a 04 00 00       	call   801d3e <sys_getSizeOfSharedObject>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80192a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80192e:	79 0a                	jns    80193a <sget+0x3c>
		return NULL;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	e9 80 00 00 00       	jmp    8019ba <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80193a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801941:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	48                   	dec    %eax
  80194a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80194d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	f7 75 f0             	divl   -0x10(%ebp)
  801958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80195b:	29 d0                	sub    %edx,%eax
  80195d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	ff 75 e8             	pushl  -0x18(%ebp)
  801966:	e8 a3 0b 00 00       	call   80250e <alloc_block_FF>
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801971:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801975:	74 3e                	je     8019b5 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80197d:	e8 dd 09 00 00       	call   80235f <insert_sorted_allocList>
  801982:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801988:	8b 40 08             	mov    0x8(%eax),%eax
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	50                   	push   %eax
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	e8 c1 03 00 00       	call   801d5b <sys_getSharedObject>
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8019a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019a4:	79 07                	jns    8019ad <sget+0xaf>
	    		  return NULL;
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ab:	eb 0d                	jmp    8019ba <sget+0xbc>
	  	return(void*) returned_block->sva;
  8019ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019b0:	8b 40 08             	mov    0x8(%eax),%eax
  8019b3:	eb 05                	jmp    8019ba <sget+0xbc>
	      }
	}
	   return NULL;
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019c2:	e8 4d fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019c7:	83 ec 04             	sub    $0x4,%esp
  8019ca:	68 40 3e 80 00       	push   $0x803e40
  8019cf:	68 12 01 00 00       	push   $0x112
  8019d4:	68 33 3e 80 00       	push   $0x803e33
  8019d9:	e8 f8 ea ff ff       	call   8004d6 <_panic>

008019de <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	68 68 3e 80 00       	push   $0x803e68
  8019ec:	68 26 01 00 00       	push   $0x126
  8019f1:	68 33 3e 80 00       	push   $0x803e33
  8019f6:	e8 db ea ff ff       	call   8004d6 <_panic>

008019fb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	68 8c 3e 80 00       	push   $0x803e8c
  801a09:	68 31 01 00 00       	push   $0x131
  801a0e:	68 33 3e 80 00       	push   $0x803e33
  801a13:	e8 be ea ff ff       	call   8004d6 <_panic>

00801a18 <shrink>:

}
void shrink(uint32 newSize)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	68 8c 3e 80 00       	push   $0x803e8c
  801a26:	68 36 01 00 00       	push   $0x136
  801a2b:	68 33 3e 80 00       	push   $0x803e33
  801a30:	e8 a1 ea ff ff       	call   8004d6 <_panic>

00801a35 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 8c 3e 80 00       	push   $0x803e8c
  801a43:	68 3b 01 00 00       	push   $0x13b
  801a48:	68 33 3e 80 00       	push   $0x803e33
  801a4d:	e8 84 ea ff ff       	call   8004d6 <_panic>

00801a52 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a67:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a6a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a6d:	cd 30                	int    $0x30
  801a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	5b                   	pop    %ebx
  801a79:	5e                   	pop    %esi
  801a7a:	5f                   	pop    %edi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    

00801a7d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	8b 45 10             	mov    0x10(%ebp),%eax
  801a86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a89:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	52                   	push   %edx
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	50                   	push   %eax
  801a99:	6a 00                	push   $0x0
  801a9b:	e8 b2 ff ff ff       	call   801a52 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 01                	push   $0x1
  801ab5:	e8 98 ff ff ff       	call   801a52 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	6a 05                	push   $0x5
  801ad2:	e8 7b ff ff ff       	call   801a52 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	56                   	push   %esi
  801ae0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ae1:	8b 75 18             	mov    0x18(%ebp),%esi
  801ae4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	51                   	push   %ecx
  801af3:	52                   	push   %edx
  801af4:	50                   	push   %eax
  801af5:	6a 06                	push   $0x6
  801af7:	e8 56 ff ff ff       	call   801a52 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b02:	5b                   	pop    %ebx
  801b03:	5e                   	pop    %esi
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    

00801b06 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 07                	push   $0x7
  801b19:	e8 34 ff ff ff       	call   801a52 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	6a 08                	push   $0x8
  801b34:	e8 19 ff ff ff       	call   801a52 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 09                	push   $0x9
  801b4d:	e8 00 ff ff ff       	call   801a52 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 0a                	push   $0xa
  801b66:	e8 e7 fe ff ff       	call   801a52 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 0b                	push   $0xb
  801b7f:	e8 ce fe ff ff       	call   801a52 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	6a 0f                	push   $0xf
  801b9a:	e8 b3 fe ff ff       	call   801a52 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
	return;
  801ba2:	90                   	nop
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	6a 10                	push   $0x10
  801bb6:	e8 97 fe ff ff       	call   801a52 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbe:	90                   	nop
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 10             	pushl  0x10(%ebp)
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	6a 11                	push   $0x11
  801bd3:	e8 7a fe ff ff       	call   801a52 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdb:	90                   	nop
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 0c                	push   $0xc
  801bed:	e8 60 fe ff ff       	call   801a52 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 0d                	push   $0xd
  801c07:	e8 46 fe ff ff       	call   801a52 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 0e                	push   $0xe
  801c20:	e8 2d fe ff ff       	call   801a52 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 13                	push   $0x13
  801c3a:	e8 13 fe ff ff       	call   801a52 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 14                	push   $0x14
  801c54:	e8 f9 fd ff ff       	call   801a52 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_cputc>:


void
sys_cputc(const char c)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c6b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	50                   	push   %eax
  801c78:	6a 15                	push   $0x15
  801c7a:	e8 d3 fd ff ff       	call   801a52 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	90                   	nop
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 16                	push   $0x16
  801c94:	e8 b9 fd ff ff       	call   801a52 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	50                   	push   %eax
  801caf:	6a 17                	push   $0x17
  801cb1:	e8 9c fd ff ff       	call   801a52 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	52                   	push   %edx
  801ccb:	50                   	push   %eax
  801ccc:	6a 1a                	push   $0x1a
  801cce:	e8 7f fd ff ff       	call   801a52 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	6a 18                	push   $0x18
  801ceb:	e8 62 fd ff ff       	call   801a52 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	6a 19                	push   $0x19
  801d09:	e8 44 fd ff ff       	call   801a52 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	90                   	nop
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d20:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d23:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	51                   	push   %ecx
  801d2d:	52                   	push   %edx
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	50                   	push   %eax
  801d32:	6a 1b                	push   $0x1b
  801d34:	e8 19 fd ff ff       	call   801a52 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 1c                	push   $0x1c
  801d51:	e8 fc fc ff ff       	call   801a52 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	51                   	push   %ecx
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 1d                	push   $0x1d
  801d70:	e8 dd fc ff ff       	call   801a52 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 1e                	push   $0x1e
  801d8d:	e8 c0 fc ff ff       	call   801a52 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 1f                	push   $0x1f
  801da6:	e8 a7 fc ff ff       	call   801a52 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	ff 75 14             	pushl  0x14(%ebp)
  801dbb:	ff 75 10             	pushl  0x10(%ebp)
  801dbe:	ff 75 0c             	pushl  0xc(%ebp)
  801dc1:	50                   	push   %eax
  801dc2:	6a 20                	push   $0x20
  801dc4:	e8 89 fc ff ff       	call   801a52 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	50                   	push   %eax
  801ddd:	6a 21                	push   $0x21
  801ddf:	e8 6e fc ff ff       	call   801a52 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	90                   	nop
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	50                   	push   %eax
  801df9:	6a 22                	push   $0x22
  801dfb:	e8 52 fc ff ff       	call   801a52 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 02                	push   $0x2
  801e14:	e8 39 fc ff ff       	call   801a52 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 03                	push   $0x3
  801e2d:	e8 20 fc ff ff       	call   801a52 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 04                	push   $0x4
  801e46:	e8 07 fc ff ff       	call   801a52 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_exit_env>:


void sys_exit_env(void)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 23                	push   $0x23
  801e5f:	e8 ee fb ff ff       	call   801a52 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	90                   	nop
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e70:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e73:	8d 50 04             	lea    0x4(%eax),%edx
  801e76:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	6a 24                	push   $0x24
  801e83:	e8 ca fb ff ff       	call   801a52 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return result;
  801e8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e94:	89 01                	mov    %eax,(%ecx)
  801e96:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	c9                   	leave  
  801e9d:	c2 04 00             	ret    $0x4

00801ea0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	ff 75 10             	pushl  0x10(%ebp)
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	6a 12                	push   $0x12
  801eb2:	e8 9b fb ff ff       	call   801a52 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eba:	90                   	nop
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_rcr2>:
uint32 sys_rcr2()
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 25                	push   $0x25
  801ecc:	e8 81 fb ff ff       	call   801a52 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ee2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	50                   	push   %eax
  801eef:	6a 26                	push   $0x26
  801ef1:	e8 5c fb ff ff       	call   801a52 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef9:	90                   	nop
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <rsttst>:
void rsttst()
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 28                	push   $0x28
  801f0b:	e8 42 fb ff ff       	call   801a52 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
	return ;
  801f13:	90                   	nop
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f22:	8b 55 18             	mov    0x18(%ebp),%edx
  801f25:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	ff 75 10             	pushl  0x10(%ebp)
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 27                	push   $0x27
  801f36:	e8 17 fb ff ff       	call   801a52 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <chktst>:
void chktst(uint32 n)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	ff 75 08             	pushl  0x8(%ebp)
  801f4f:	6a 29                	push   $0x29
  801f51:	e8 fc fa ff ff       	call   801a52 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
	return ;
  801f59:	90                   	nop
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <inctst>:

void inctst()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 2a                	push   $0x2a
  801f6b:	e8 e2 fa ff ff       	call   801a52 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
	return ;
  801f73:	90                   	nop
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <gettst>:
uint32 gettst()
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 2b                	push   $0x2b
  801f85:	e8 c8 fa ff ff       	call   801a52 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 2c                	push   $0x2c
  801fa1:	e8 ac fa ff ff       	call   801a52 <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
  801fa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fac:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fb0:	75 07                	jne    801fb9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb7:	eb 05                	jmp    801fbe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 2c                	push   $0x2c
  801fd2:	e8 7b fa ff ff       	call   801a52 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
  801fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fdd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fe1:	75 07                	jne    801fea <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fe3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe8:	eb 05                	jmp    801fef <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 2c                	push   $0x2c
  802003:	e8 4a fa ff ff       	call   801a52 <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
  80200b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80200e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802012:	75 07                	jne    80201b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802014:	b8 01 00 00 00       	mov    $0x1,%eax
  802019:	eb 05                	jmp    802020 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 2c                	push   $0x2c
  802034:	e8 19 fa ff ff       	call   801a52 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
  80203c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80203f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802043:	75 07                	jne    80204c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802045:	b8 01 00 00 00       	mov    $0x1,%eax
  80204a:	eb 05                	jmp    802051 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	6a 2d                	push   $0x2d
  802063:	e8 ea f9 ff ff       	call   801a52 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
	return ;
  80206b:	90                   	nop
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802072:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802075:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802078:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	6a 00                	push   $0x0
  802080:	53                   	push   %ebx
  802081:	51                   	push   %ecx
  802082:	52                   	push   %edx
  802083:	50                   	push   %eax
  802084:	6a 2e                	push   $0x2e
  802086:	e8 c7 f9 ff ff       	call   801a52 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802096:	8b 55 0c             	mov    0xc(%ebp),%edx
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	52                   	push   %edx
  8020a3:	50                   	push   %eax
  8020a4:	6a 2f                	push   $0x2f
  8020a6:	e8 a7 f9 ff ff       	call   801a52 <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	68 9c 3e 80 00       	push   $0x803e9c
  8020be:	e8 c7 e6 ff ff       	call   80078a <cprintf>
  8020c3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	68 c8 3e 80 00       	push   $0x803ec8
  8020d5:	e8 b0 e6 ff ff       	call   80078a <cprintf>
  8020da:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020dd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8020e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e9:	eb 56                	jmp    802141 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ef:	74 1c                	je     80210d <print_mem_block_lists+0x5d>
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 50 08             	mov    0x8(%eax),%edx
  8020f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	8b 40 0c             	mov    0xc(%eax),%eax
  802103:	01 c8                	add    %ecx,%eax
  802105:	39 c2                	cmp    %eax,%edx
  802107:	73 04                	jae    80210d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802109:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 50 08             	mov    0x8(%eax),%edx
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 40 0c             	mov    0xc(%eax),%eax
  802119:	01 c2                	add    %eax,%edx
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 40 08             	mov    0x8(%eax),%eax
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	68 dd 3e 80 00       	push   $0x803edd
  80212b:	e8 5a e6 ff ff       	call   80078a <cprintf>
  802130:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802139:	a1 40 51 80 00       	mov    0x805140,%eax
  80213e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802145:	74 07                	je     80214e <print_mem_block_lists+0x9e>
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	eb 05                	jmp    802153 <print_mem_block_lists+0xa3>
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	a3 40 51 80 00       	mov    %eax,0x805140
  802158:	a1 40 51 80 00       	mov    0x805140,%eax
  80215d:	85 c0                	test   %eax,%eax
  80215f:	75 8a                	jne    8020eb <print_mem_block_lists+0x3b>
  802161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802165:	75 84                	jne    8020eb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802167:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80216b:	75 10                	jne    80217d <print_mem_block_lists+0xcd>
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	68 ec 3e 80 00       	push   $0x803eec
  802175:	e8 10 e6 ff ff       	call   80078a <cprintf>
  80217a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80217d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	68 10 3f 80 00       	push   $0x803f10
  80218c:	e8 f9 e5 ff ff       	call   80078a <cprintf>
  802191:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802194:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802198:	a1 40 50 80 00       	mov    0x805040,%eax
  80219d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a0:	eb 56                	jmp    8021f8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a6:	74 1c                	je     8021c4 <print_mem_block_lists+0x114>
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 50 08             	mov    0x8(%eax),%edx
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	8b 48 08             	mov    0x8(%eax),%ecx
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ba:	01 c8                	add    %ecx,%eax
  8021bc:	39 c2                	cmp    %eax,%edx
  8021be:	73 04                	jae    8021c4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021c0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d0:	01 c2                	add    %eax,%edx
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 40 08             	mov    0x8(%eax),%eax
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	52                   	push   %edx
  8021dc:	50                   	push   %eax
  8021dd:	68 dd 3e 80 00       	push   $0x803edd
  8021e2:	e8 a3 e5 ff ff       	call   80078a <cprintf>
  8021e7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8021f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fc:	74 07                	je     802205 <print_mem_block_lists+0x155>
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	8b 00                	mov    (%eax),%eax
  802203:	eb 05                	jmp    80220a <print_mem_block_lists+0x15a>
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	a3 48 50 80 00       	mov    %eax,0x805048
  80220f:	a1 48 50 80 00       	mov    0x805048,%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	75 8a                	jne    8021a2 <print_mem_block_lists+0xf2>
  802218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221c:	75 84                	jne    8021a2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80221e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802222:	75 10                	jne    802234 <print_mem_block_lists+0x184>
  802224:	83 ec 0c             	sub    $0xc,%esp
  802227:	68 28 3f 80 00       	push   $0x803f28
  80222c:	e8 59 e5 ff ff       	call   80078a <cprintf>
  802231:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802234:	83 ec 0c             	sub    $0xc,%esp
  802237:	68 9c 3e 80 00       	push   $0x803e9c
  80223c:	e8 49 e5 ff ff       	call   80078a <cprintf>
  802241:	83 c4 10             	add    $0x10,%esp

}
  802244:	90                   	nop
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80224d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802254:	00 00 00 
  802257:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80225e:	00 00 00 
  802261:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802268:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80226b:	a1 50 50 80 00       	mov    0x805050,%eax
  802270:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802273:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80227a:	e9 9e 00 00 00       	jmp    80231d <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80227f:	a1 50 50 80 00       	mov    0x805050,%eax
  802284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802287:	c1 e2 04             	shl    $0x4,%edx
  80228a:	01 d0                	add    %edx,%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	75 14                	jne    8022a4 <initialize_MemBlocksList+0x5d>
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 50 3f 80 00       	push   $0x803f50
  802298:	6a 48                	push   $0x48
  80229a:	68 73 3f 80 00       	push   $0x803f73
  80229f:	e8 32 e2 ff ff       	call   8004d6 <_panic>
  8022a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	c1 e2 04             	shl    $0x4,%edx
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022b7:	89 10                	mov    %edx,(%eax)
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	74 18                	je     8022d7 <initialize_MemBlocksList+0x90>
  8022bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8022c4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022cd:	c1 e1 04             	shl    $0x4,%ecx
  8022d0:	01 ca                	add    %ecx,%edx
  8022d2:	89 50 04             	mov    %edx,0x4(%eax)
  8022d5:	eb 12                	jmp    8022e9 <initialize_MemBlocksList+0xa2>
  8022d7:	a1 50 50 80 00       	mov    0x805050,%eax
  8022dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022df:	c1 e2 04             	shl    $0x4,%edx
  8022e2:	01 d0                	add    %edx,%eax
  8022e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f1:	c1 e2 04             	shl    $0x4,%edx
  8022f4:	01 d0                	add    %edx,%eax
  8022f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8022fb:	a1 50 50 80 00       	mov    0x805050,%eax
  802300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802303:	c1 e2 04             	shl    $0x4,%edx
  802306:	01 d0                	add    %edx,%eax
  802308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230f:	a1 54 51 80 00       	mov    0x805154,%eax
  802314:	40                   	inc    %eax
  802315:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80231a:	ff 45 f4             	incl   -0xc(%ebp)
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	3b 45 08             	cmp    0x8(%ebp),%eax
  802323:	0f 82 56 ff ff ff    	jb     80227f <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802329:	90                   	nop
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80233a:	eb 18                	jmp    802354 <find_block+0x28>
		{
			if(tmp->sva==va)
  80233c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233f:	8b 40 08             	mov    0x8(%eax),%eax
  802342:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802345:	75 05                	jne    80234c <find_block+0x20>
			{
				return tmp;
  802347:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234a:	eb 11                	jmp    80235d <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80234c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802354:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802358:	75 e2                	jne    80233c <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80235a:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802365:	a1 40 50 80 00       	mov    0x805040,%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	0f 85 83 00 00 00    	jne    8023f5 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802372:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802379:	00 00 00 
  80237c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802383:	00 00 00 
  802386:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80238d:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802394:	75 14                	jne    8023aa <insert_sorted_allocList+0x4b>
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 50 3f 80 00       	push   $0x803f50
  80239e:	6a 7f                	push   $0x7f
  8023a0:	68 73 3f 80 00       	push   $0x803f73
  8023a5:	e8 2c e1 ff ff       	call   8004d6 <_panic>
  8023aa:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	89 10                	mov    %edx,(%eax)
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	8b 00                	mov    (%eax),%eax
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	74 0d                	je     8023cb <insert_sorted_allocList+0x6c>
  8023be:	a1 40 50 80 00       	mov    0x805040,%eax
  8023c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c6:	89 50 04             	mov    %edx,0x4(%eax)
  8023c9:	eb 08                	jmp    8023d3 <insert_sorted_allocList+0x74>
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	a3 44 50 80 00       	mov    %eax,0x805044
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	a3 40 50 80 00       	mov    %eax,0x805040
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023ea:	40                   	inc    %eax
  8023eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023f0:	e9 16 01 00 00       	jmp    80250b <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	8b 50 08             	mov    0x8(%eax),%edx
  8023fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802400:	8b 40 08             	mov    0x8(%eax),%eax
  802403:	39 c2                	cmp    %eax,%edx
  802405:	76 68                	jbe    80246f <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80240b:	75 17                	jne    802424 <insert_sorted_allocList+0xc5>
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	68 8c 3f 80 00       	push   $0x803f8c
  802415:	68 85 00 00 00       	push   $0x85
  80241a:	68 73 3f 80 00       	push   $0x803f73
  80241f:	e8 b2 e0 ff ff       	call   8004d6 <_panic>
  802424:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	89 50 04             	mov    %edx,0x4(%eax)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 0c                	je     802446 <insert_sorted_allocList+0xe7>
  80243a:	a1 44 50 80 00       	mov    0x805044,%eax
  80243f:	8b 55 08             	mov    0x8(%ebp),%edx
  802442:	89 10                	mov    %edx,(%eax)
  802444:	eb 08                	jmp    80244e <insert_sorted_allocList+0xef>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 40 50 80 00       	mov    %eax,0x805040
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	a3 44 50 80 00       	mov    %eax,0x805044
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802464:	40                   	inc    %eax
  802465:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80246a:	e9 9c 00 00 00       	jmp    80250b <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80246f:	a1 40 50 80 00       	mov    0x805040,%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802477:	e9 85 00 00 00       	jmp    802501 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	8b 50 08             	mov    0x8(%eax),%edx
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 40 08             	mov    0x8(%eax),%eax
  802488:	39 c2                	cmp    %eax,%edx
  80248a:	73 6d                	jae    8024f9 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80248c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802490:	74 06                	je     802498 <insert_sorted_allocList+0x139>
  802492:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802496:	75 17                	jne    8024af <insert_sorted_allocList+0x150>
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 b0 3f 80 00       	push   $0x803fb0
  8024a0:	68 90 00 00 00       	push   $0x90
  8024a5:	68 73 3f 80 00       	push   $0x803f73
  8024aa:	e8 27 e0 ff ff       	call   8004d6 <_panic>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 50 04             	mov    0x4(%eax),%edx
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 40 04             	mov    0x4(%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 0d                	je     8024da <insert_sorted_allocList+0x17b>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d6:	89 10                	mov    %edx,(%eax)
  8024d8:	eb 08                	jmp    8024e2 <insert_sorted_allocList+0x183>
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
  8024eb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024f0:	40                   	inc    %eax
  8024f1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024f6:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024f7:	eb 12                	jmp    80250b <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 00                	mov    (%eax),%eax
  8024fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802505:	0f 85 71 ff ff ff    	jne    80247c <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80250b:	90                   	nop
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802514:	a1 38 51 80 00       	mov    0x805138,%eax
  802519:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80251c:	e9 76 01 00 00       	jmp    802697 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 0c             	mov    0xc(%eax),%eax
  802527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252a:	0f 85 8a 00 00 00    	jne    8025ba <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802534:	75 17                	jne    80254d <alloc_block_FF+0x3f>
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 e5 3f 80 00       	push   $0x803fe5
  80253e:	68 a8 00 00 00       	push   $0xa8
  802543:	68 73 3f 80 00       	push   $0x803f73
  802548:	e8 89 df ff ff       	call   8004d6 <_panic>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	74 10                	je     802566 <alloc_block_FF+0x58>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255e:	8b 52 04             	mov    0x4(%edx),%edx
  802561:	89 50 04             	mov    %edx,0x4(%eax)
  802564:	eb 0b                	jmp    802571 <alloc_block_FF+0x63>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 04             	mov    0x4(%eax),%eax
  80256c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	74 0f                	je     80258a <alloc_block_FF+0x7c>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 40 04             	mov    0x4(%eax),%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	8b 12                	mov    (%edx),%edx
  802586:	89 10                	mov    %edx,(%eax)
  802588:	eb 0a                	jmp    802594 <alloc_block_FF+0x86>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	a3 38 51 80 00       	mov    %eax,0x805138
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8025ac:	48                   	dec    %eax
  8025ad:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	e9 ea 00 00 00       	jmp    8026a4 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c3:	0f 86 c6 00 00 00    	jbe    80268f <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8025ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d7:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 50 08             	mov    0x8(%eax),%edx
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e3:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ef:	89 c2                	mov    %eax,%edx
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 50 08             	mov    0x8(%eax),%edx
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	01 c2                	add    %eax,%edx
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802608:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260c:	75 17                	jne    802625 <alloc_block_FF+0x117>
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 e5 3f 80 00       	push   $0x803fe5
  802616:	68 b6 00 00 00       	push   $0xb6
  80261b:	68 73 3f 80 00       	push   $0x803f73
  802620:	e8 b1 de ff ff       	call   8004d6 <_panic>
  802625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 10                	je     80263e <alloc_block_FF+0x130>
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802636:	8b 52 04             	mov    0x4(%edx),%edx
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	eb 0b                	jmp    802649 <alloc_block_FF+0x13b>
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 0f                	je     802662 <alloc_block_FF+0x154>
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265c:	8b 12                	mov    (%edx),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	eb 0a                	jmp    80266c <alloc_block_FF+0x15e>
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	a3 48 51 80 00       	mov    %eax,0x805148
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267f:	a1 54 51 80 00       	mov    0x805154,%eax
  802684:	48                   	dec    %eax
  802685:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  80268a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268d:	eb 15                	jmp    8026a4 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	0f 85 80 fe ff ff    	jne    802521 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8026ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8026b4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8026bb:	e9 c0 00 00 00       	jmp    802780 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c9:	0f 85 8a 00 00 00    	jne    802759 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8026cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d3:	75 17                	jne    8026ec <alloc_block_BF+0x46>
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	68 e5 3f 80 00       	push   $0x803fe5
  8026dd:	68 cf 00 00 00       	push   $0xcf
  8026e2:	68 73 3f 80 00       	push   $0x803f73
  8026e7:	e8 ea dd ff ff       	call   8004d6 <_panic>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 10                	je     802705 <alloc_block_BF+0x5f>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fd:	8b 52 04             	mov    0x4(%edx),%edx
  802700:	89 50 04             	mov    %edx,0x4(%eax)
  802703:	eb 0b                	jmp    802710 <alloc_block_BF+0x6a>
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 0f                	je     802729 <alloc_block_BF+0x83>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 04             	mov    0x4(%eax),%eax
  802720:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802723:	8b 12                	mov    (%edx),%edx
  802725:	89 10                	mov    %edx,(%eax)
  802727:	eb 0a                	jmp    802733 <alloc_block_BF+0x8d>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	a3 38 51 80 00       	mov    %eax,0x805138
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802746:	a1 44 51 80 00       	mov    0x805144,%eax
  80274b:	48                   	dec    %eax
  80274c:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	e9 2a 01 00 00       	jmp    802883 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802762:	73 14                	jae    802778 <alloc_block_BF+0xd2>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 0c             	mov    0xc(%eax),%eax
  80276a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276d:	76 09                	jbe    802778 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 0c             	mov    0xc(%eax),%eax
  802775:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802784:	0f 85 36 ff ff ff    	jne    8026c0 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80278a:	a1 38 51 80 00       	mov    0x805138,%eax
  80278f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802792:	e9 dd 00 00 00       	jmp    802874 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027a0:	0f 85 c6 00 00 00    	jne    80286c <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8027ab:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b7:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c0:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 50 08             	mov    0x8(%eax),%edx
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	01 c2                	add    %eax,%edx
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	2b 45 08             	sub    0x8(%ebp),%eax
  8027dd:	89 c2                	mov    %eax,%edx
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e9:	75 17                	jne    802802 <alloc_block_BF+0x15c>
  8027eb:	83 ec 04             	sub    $0x4,%esp
  8027ee:	68 e5 3f 80 00       	push   $0x803fe5
  8027f3:	68 eb 00 00 00       	push   $0xeb
  8027f8:	68 73 3f 80 00       	push   $0x803f73
  8027fd:	e8 d4 dc ff ff       	call   8004d6 <_panic>
  802802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	74 10                	je     80281b <alloc_block_BF+0x175>
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802813:	8b 52 04             	mov    0x4(%edx),%edx
  802816:	89 50 04             	mov    %edx,0x4(%eax)
  802819:	eb 0b                	jmp    802826 <alloc_block_BF+0x180>
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	74 0f                	je     80283f <alloc_block_BF+0x199>
  802830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802833:	8b 40 04             	mov    0x4(%eax),%eax
  802836:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802839:	8b 12                	mov    (%edx),%edx
  80283b:	89 10                	mov    %edx,(%eax)
  80283d:	eb 0a                	jmp    802849 <alloc_block_BF+0x1a3>
  80283f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	a3 48 51 80 00       	mov    %eax,0x805148
  802849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285c:	a1 54 51 80 00       	mov    0x805154,%eax
  802861:	48                   	dec    %eax
  802862:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286a:	eb 17                	jmp    802883 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802878:	0f 85 19 ff ff ff    	jne    802797 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80287e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80288b:	a1 40 50 80 00       	mov    0x805040,%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	75 19                	jne    8028ad <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802894:	83 ec 0c             	sub    $0xc,%esp
  802897:	ff 75 08             	pushl  0x8(%ebp)
  80289a:	e8 6f fc ff ff       	call   80250e <alloc_block_FF>
  80289f:	83 c4 10             	add    $0x10,%esp
  8028a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	e9 e9 01 00 00       	jmp    802a96 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8028ad:	a1 44 50 80 00       	mov    0x805044,%eax
  8028b2:	8b 40 08             	mov    0x8(%eax),%eax
  8028b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8028b8:	a1 44 50 80 00       	mov    0x805044,%eax
  8028bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8028c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c5:	8b 40 08             	mov    0x8(%eax),%eax
  8028c8:	01 d0                	add    %edx,%eax
  8028ca:	83 ec 08             	sub    $0x8,%esp
  8028cd:	50                   	push   %eax
  8028ce:	68 38 51 80 00       	push   $0x805138
  8028d3:	e8 54 fa ff ff       	call   80232c <find_block>
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e7:	0f 85 9b 00 00 00    	jne    802988 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	01 d0                	add    %edx,%eax
  8028fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8028fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802902:	75 17                	jne    80291b <alloc_block_NF+0x96>
  802904:	83 ec 04             	sub    $0x4,%esp
  802907:	68 e5 3f 80 00       	push   $0x803fe5
  80290c:	68 1a 01 00 00       	push   $0x11a
  802911:	68 73 3f 80 00       	push   $0x803f73
  802916:	e8 bb db ff ff       	call   8004d6 <_panic>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 10                	je     802934 <alloc_block_NF+0xaf>
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	8b 52 04             	mov    0x4(%edx),%edx
  80292f:	89 50 04             	mov    %edx,0x4(%eax)
  802932:	eb 0b                	jmp    80293f <alloc_block_NF+0xba>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 04             	mov    0x4(%eax),%eax
  80293a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 40 04             	mov    0x4(%eax),%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	74 0f                	je     802958 <alloc_block_NF+0xd3>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802952:	8b 12                	mov    (%edx),%edx
  802954:	89 10                	mov    %edx,(%eax)
  802956:	eb 0a                	jmp    802962 <alloc_block_NF+0xdd>
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 00                	mov    (%eax),%eax
  80295d:	a3 38 51 80 00       	mov    %eax,0x805138
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802975:	a1 44 51 80 00       	mov    0x805144,%eax
  80297a:	48                   	dec    %eax
  80297b:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	e9 0e 01 00 00       	jmp    802a96 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 0c             	mov    0xc(%eax),%eax
  80298e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802991:	0f 86 cf 00 00 00    	jbe    802a66 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802997:	a1 48 51 80 00       	mov    0x805148,%eax
  80299c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a5:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 50 08             	mov    0x8(%eax),%edx
  8029ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b1:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	01 c2                	add    %eax,%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ce:	89 c2                	mov    %eax,%edx
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 08             	mov    0x8(%eax),%eax
  8029dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e3:	75 17                	jne    8029fc <alloc_block_NF+0x177>
  8029e5:	83 ec 04             	sub    $0x4,%esp
  8029e8:	68 e5 3f 80 00       	push   $0x803fe5
  8029ed:	68 28 01 00 00       	push   $0x128
  8029f2:	68 73 3f 80 00       	push   $0x803f73
  8029f7:	e8 da da ff ff       	call   8004d6 <_panic>
  8029fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	74 10                	je     802a15 <alloc_block_NF+0x190>
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a0d:	8b 52 04             	mov    0x4(%edx),%edx
  802a10:	89 50 04             	mov    %edx,0x4(%eax)
  802a13:	eb 0b                	jmp    802a20 <alloc_block_NF+0x19b>
  802a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	8b 40 04             	mov    0x4(%eax),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	74 0f                	je     802a39 <alloc_block_NF+0x1b4>
  802a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a33:	8b 12                	mov    (%edx),%edx
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	eb 0a                	jmp    802a43 <alloc_block_NF+0x1be>
  802a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a56:	a1 54 51 80 00       	mov    0x805154,%eax
  802a5b:	48                   	dec    %eax
  802a5c:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a64:	eb 30                	jmp    802a96 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802a66:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a6e:	75 0a                	jne    802a7a <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802a70:	a1 38 51 80 00       	mov    0x805138,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	eb 08                	jmp    802a82 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 08             	mov    0x8(%eax),%eax
  802a88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a8b:	0f 85 4d fe ff ff    	jne    8028de <alloc_block_NF+0x59>

			return NULL;
  802a91:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802a96:	c9                   	leave  
  802a97:	c3                   	ret    

00802a98 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a98:	55                   	push   %ebp
  802a99:	89 e5                	mov    %esp,%ebp
  802a9b:	53                   	push   %ebx
  802a9c:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802a9f:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	0f 85 86 00 00 00    	jne    802b32 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802aac:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802ab3:	00 00 00 
  802ab6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802abd:	00 00 00 
  802ac0:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802ac7:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802aca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ace:	75 17                	jne    802ae7 <insert_sorted_with_merge_freeList+0x4f>
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	68 50 3f 80 00       	push   $0x803f50
  802ad8:	68 48 01 00 00       	push   $0x148
  802add:	68 73 3f 80 00       	push   $0x803f73
  802ae2:	e8 ef d9 ff ff       	call   8004d6 <_panic>
  802ae7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	85 c0                	test   %eax,%eax
  802af9:	74 0d                	je     802b08 <insert_sorted_with_merge_freeList+0x70>
  802afb:	a1 38 51 80 00       	mov    0x805138,%eax
  802b00:	8b 55 08             	mov    0x8(%ebp),%edx
  802b03:	89 50 04             	mov    %edx,0x4(%eax)
  802b06:	eb 08                	jmp    802b10 <insert_sorted_with_merge_freeList+0x78>
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	a3 38 51 80 00       	mov    %eax,0x805138
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b22:	a1 44 51 80 00       	mov    0x805144,%eax
  802b27:	40                   	inc    %eax
  802b28:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802b2d:	e9 73 07 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	8b 50 08             	mov    0x8(%eax),%edx
  802b38:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b3d:	8b 40 08             	mov    0x8(%eax),%eax
  802b40:	39 c2                	cmp    %eax,%edx
  802b42:	0f 86 84 00 00 00    	jbe    802bcc <insert_sorted_with_merge_freeList+0x134>
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b53:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b56:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b5b:	8b 40 08             	mov    0x8(%eax),%eax
  802b5e:	01 c8                	add    %ecx,%eax
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	74 68                	je     802bcc <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b68:	75 17                	jne    802b81 <insert_sorted_with_merge_freeList+0xe9>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 8c 3f 80 00       	push   $0x803f8c
  802b72:	68 4c 01 00 00       	push   $0x14c
  802b77:	68 73 3f 80 00       	push   $0x803f73
  802b7c:	e8 55 d9 ff ff       	call   8004d6 <_panic>
  802b81:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0c                	je     802ba3 <insert_sorted_with_merge_freeList+0x10b>
  802b97:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	eb 08                	jmp    802bab <insert_sorted_with_merge_freeList+0x113>
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	a3 38 51 80 00       	mov    %eax,0x805138
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbc:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc1:	40                   	inc    %eax
  802bc2:	a3 44 51 80 00       	mov    %eax,0x805144
  802bc7:	e9 d9 06 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	8b 50 08             	mov    0x8(%eax),%edx
  802bd2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bd7:	8b 40 08             	mov    0x8(%eax),%eax
  802bda:	39 c2                	cmp    %eax,%edx
  802bdc:	0f 86 b5 00 00 00    	jbe    802c97 <insert_sorted_with_merge_freeList+0x1ff>
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bed:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bf0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bf5:	8b 40 08             	mov    0x8(%eax),%eax
  802bf8:	01 c8                	add    %ecx,%eax
  802bfa:	39 c2                	cmp    %eax,%edx
  802bfc:	0f 85 95 00 00 00    	jne    802c97 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802c02:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c07:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c0d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c10:	8b 55 08             	mov    0x8(%ebp),%edx
  802c13:	8b 52 0c             	mov    0xc(%edx),%edx
  802c16:	01 ca                	add    %ecx,%edx
  802c18:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c33:	75 17                	jne    802c4c <insert_sorted_with_merge_freeList+0x1b4>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 50 3f 80 00       	push   $0x803f50
  802c3d:	68 54 01 00 00       	push   $0x154
  802c42:	68 73 3f 80 00       	push   $0x803f73
  802c47:	e8 8a d8 ff ff       	call   8004d6 <_panic>
  802c4c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	89 10                	mov    %edx,(%eax)
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	74 0d                	je     802c6d <insert_sorted_with_merge_freeList+0x1d5>
  802c60:	a1 48 51 80 00       	mov    0x805148,%eax
  802c65:	8b 55 08             	mov    0x8(%ebp),%edx
  802c68:	89 50 04             	mov    %edx,0x4(%eax)
  802c6b:	eb 08                	jmp    802c75 <insert_sorted_with_merge_freeList+0x1dd>
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	a3 48 51 80 00       	mov    %eax,0x805148
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c87:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8c:	40                   	inc    %eax
  802c8d:	a3 54 51 80 00       	mov    %eax,0x805154
  802c92:	e9 0e 06 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	8b 50 08             	mov    0x8(%eax),%edx
  802c9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca2:	8b 40 08             	mov    0x8(%eax),%eax
  802ca5:	39 c2                	cmp    %eax,%edx
  802ca7:	0f 83 c1 00 00 00    	jae    802d6e <insert_sorted_with_merge_freeList+0x2d6>
  802cad:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	8b 48 08             	mov    0x8(%eax),%ecx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc1:	01 c8                	add    %ecx,%eax
  802cc3:	39 c2                	cmp    %eax,%edx
  802cc5:	0f 85 a3 00 00 00    	jne    802d6e <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ccb:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd3:	8b 52 08             	mov    0x8(%edx),%edx
  802cd6:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802cd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cde:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ce4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cea:	8b 52 0c             	mov    0xc(%edx),%edx
  802ced:	01 ca                	add    %ecx,%edx
  802cef:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0a:	75 17                	jne    802d23 <insert_sorted_with_merge_freeList+0x28b>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 50 3f 80 00       	push   $0x803f50
  802d14:	68 5d 01 00 00       	push   $0x15d
  802d19:	68 73 3f 80 00       	push   $0x803f73
  802d1e:	e8 b3 d7 ff ff       	call   8004d6 <_panic>
  802d23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0d                	je     802d44 <insert_sorted_with_merge_freeList+0x2ac>
  802d37:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 08                	jmp    802d4c <insert_sorted_with_merge_freeList+0x2b4>
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 54 51 80 00       	mov    %eax,0x805154
  802d69:	e9 37 05 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	a1 38 51 80 00       	mov    0x805138,%eax
  802d79:	8b 40 08             	mov    0x8(%eax),%eax
  802d7c:	39 c2                	cmp    %eax,%edx
  802d7e:	0f 83 82 00 00 00    	jae    802e06 <insert_sorted_with_merge_freeList+0x36e>
  802d84:	a1 38 51 80 00       	mov    0x805138,%eax
  802d89:	8b 50 08             	mov    0x8(%eax),%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 48 08             	mov    0x8(%eax),%ecx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 40 0c             	mov    0xc(%eax),%eax
  802d98:	01 c8                	add    %ecx,%eax
  802d9a:	39 c2                	cmp    %eax,%edx
  802d9c:	74 68                	je     802e06 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da2:	75 17                	jne    802dbb <insert_sorted_with_merge_freeList+0x323>
  802da4:	83 ec 04             	sub    $0x4,%esp
  802da7:	68 50 3f 80 00       	push   $0x803f50
  802dac:	68 62 01 00 00       	push   $0x162
  802db1:	68 73 3f 80 00       	push   $0x803f73
  802db6:	e8 1b d7 ff ff       	call   8004d6 <_panic>
  802dbb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	89 10                	mov    %edx,(%eax)
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0d                	je     802ddc <insert_sorted_with_merge_freeList+0x344>
  802dcf:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 08                	jmp    802de4 <insert_sorted_with_merge_freeList+0x34c>
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df6:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfb:	40                   	inc    %eax
  802dfc:	a3 44 51 80 00       	mov    %eax,0x805144
  802e01:	e9 9f 04 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802e06:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802e10:	e9 84 04 00 00       	jmp    803299 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 50 08             	mov    0x8(%eax),%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	8b 40 08             	mov    0x8(%eax),%eax
  802e21:	39 c2                	cmp    %eax,%edx
  802e23:	0f 86 a9 00 00 00    	jbe    802ed2 <insert_sorted_with_merge_freeList+0x43a>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 48 08             	mov    0x8(%eax),%ecx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3b:	01 c8                	add    %ecx,%eax
  802e3d:	39 c2                	cmp    %eax,%edx
  802e3f:	0f 84 8d 00 00 00    	je     802ed2 <insert_sorted_with_merge_freeList+0x43a>
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	8b 48 08             	mov    0x8(%eax),%ecx
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 04             	mov    0x4(%eax),%eax
  802e5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5d:	01 c8                	add    %ecx,%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	74 6f                	je     802ed2 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802e63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e67:	74 06                	je     802e6f <insert_sorted_with_merge_freeList+0x3d7>
  802e69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6d:	75 17                	jne    802e86 <insert_sorted_with_merge_freeList+0x3ee>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 b0 3f 80 00       	push   $0x803fb0
  802e77:	68 6b 01 00 00       	push   $0x16b
  802e7c:	68 73 3f 80 00       	push   $0x803f73
  802e81:	e8 50 d6 ff ff       	call   8004d6 <_panic>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 50 04             	mov    0x4(%eax),%edx
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e98:	89 10                	mov    %edx,(%eax)
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	74 0d                	je     802eb1 <insert_sorted_with_merge_freeList+0x419>
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 04             	mov    0x4(%eax),%eax
  802eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	eb 08                	jmp    802eb9 <insert_sorted_with_merge_freeList+0x421>
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec7:	40                   	inc    %eax
  802ec8:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  802ecd:	e9 d3 03 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 40 08             	mov    0x8(%eax),%eax
  802ede:	39 c2                	cmp    %eax,%edx
  802ee0:	0f 86 da 00 00 00    	jbe    802fc0 <insert_sorted_with_merge_freeList+0x528>
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 50 08             	mov    0x8(%eax),%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 48 08             	mov    0x8(%eax),%ecx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef8:	01 c8                	add    %ecx,%eax
  802efa:	39 c2                	cmp    %eax,%edx
  802efc:	0f 85 be 00 00 00    	jne    802fc0 <insert_sorted_with_merge_freeList+0x528>
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 40 04             	mov    0x4(%eax),%eax
  802f0e:	8b 48 08             	mov    0x8(%eax),%ecx
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1a:	01 c8                	add    %ecx,%eax
  802f1c:	39 c2                	cmp    %eax,%edx
  802f1e:	0f 84 9c 00 00 00    	je     802fc0 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 50 08             	mov    0x8(%eax),%edx
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 50 0c             	mov    0xc(%eax),%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3c:	01 c2                	add    %eax,%edx
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5c:	75 17                	jne    802f75 <insert_sorted_with_merge_freeList+0x4dd>
  802f5e:	83 ec 04             	sub    $0x4,%esp
  802f61:	68 50 3f 80 00       	push   $0x803f50
  802f66:	68 74 01 00 00       	push   $0x174
  802f6b:	68 73 3f 80 00       	push   $0x803f73
  802f70:	e8 61 d5 ff ff       	call   8004d6 <_panic>
  802f75:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	74 0d                	je     802f96 <insert_sorted_with_merge_freeList+0x4fe>
  802f89:	a1 48 51 80 00       	mov    0x805148,%eax
  802f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 08                	jmp    802f9e <insert_sorted_with_merge_freeList+0x506>
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb0:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb5:	40                   	inc    %eax
  802fb6:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  802fbb:	e9 e5 02 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	8b 50 08             	mov    0x8(%eax),%edx
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	8b 40 08             	mov    0x8(%eax),%eax
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	0f 86 d7 00 00 00    	jbe    8030ab <insert_sorted_with_merge_freeList+0x613>
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 48 08             	mov    0x8(%eax),%ecx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	01 c8                	add    %ecx,%eax
  802fe8:	39 c2                	cmp    %eax,%edx
  802fea:	0f 84 bb 00 00 00    	je     8030ab <insert_sorted_with_merge_freeList+0x613>
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 50 08             	mov    0x8(%eax),%edx
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	8b 48 08             	mov    0x8(%eax),%ecx
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	8b 40 0c             	mov    0xc(%eax),%eax
  803008:	01 c8                	add    %ecx,%eax
  80300a:	39 c2                	cmp    %eax,%edx
  80300c:	0f 85 99 00 00 00    	jne    8030ab <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 50 0c             	mov    0xc(%eax),%edx
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 40 0c             	mov    0xc(%eax),%eax
  803027:	01 c2                	add    %eax,%edx
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803043:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803047:	75 17                	jne    803060 <insert_sorted_with_merge_freeList+0x5c8>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 50 3f 80 00       	push   $0x803f50
  803051:	68 7d 01 00 00       	push   $0x17d
  803056:	68 73 3f 80 00       	push   $0x803f73
  80305b:	e8 76 d4 ff ff       	call   8004d6 <_panic>
  803060:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0d                	je     803081 <insert_sorted_with_merge_freeList+0x5e9>
  803074:	a1 48 51 80 00       	mov    0x805148,%eax
  803079:	8b 55 08             	mov    0x8(%ebp),%edx
  80307c:	89 50 04             	mov    %edx,0x4(%eax)
  80307f:	eb 08                	jmp    803089 <insert_sorted_with_merge_freeList+0x5f1>
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	a3 48 51 80 00       	mov    %eax,0x805148
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309b:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a0:	40                   	inc    %eax
  8030a1:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8030a6:	e9 fa 01 00 00       	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 50 08             	mov    0x8(%eax),%edx
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	39 c2                	cmp    %eax,%edx
  8030b9:	0f 86 d2 01 00 00    	jbe    803291 <insert_sorted_with_merge_freeList+0x7f9>
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 50 08             	mov    0x8(%eax),%edx
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 48 08             	mov    0x8(%eax),%ecx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d1:	01 c8                	add    %ecx,%eax
  8030d3:	39 c2                	cmp    %eax,%edx
  8030d5:	0f 85 b6 01 00 00    	jne    803291 <insert_sorted_with_merge_freeList+0x7f9>
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	8b 50 08             	mov    0x8(%eax),%edx
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	8b 48 08             	mov    0x8(%eax),%ecx
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f3:	01 c8                	add    %ecx,%eax
  8030f5:	39 c2                	cmp    %eax,%edx
  8030f7:	0f 85 94 01 00 00    	jne    803291 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803106:	8b 52 04             	mov    0x4(%edx),%edx
  803109:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803115:	8b 52 0c             	mov    0xc(%edx),%edx
  803118:	01 da                	add    %ebx,%edx
  80311a:	01 ca                	add    %ecx,%edx
  80311c:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803137:	75 17                	jne    803150 <insert_sorted_with_merge_freeList+0x6b8>
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	68 e5 3f 80 00       	push   $0x803fe5
  803141:	68 86 01 00 00       	push   $0x186
  803146:	68 73 3f 80 00       	push   $0x803f73
  80314b:	e8 86 d3 ff ff       	call   8004d6 <_panic>
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	85 c0                	test   %eax,%eax
  803157:	74 10                	je     803169 <insert_sorted_with_merge_freeList+0x6d1>
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803161:	8b 52 04             	mov    0x4(%edx),%edx
  803164:	89 50 04             	mov    %edx,0x4(%eax)
  803167:	eb 0b                	jmp    803174 <insert_sorted_with_merge_freeList+0x6dc>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	8b 40 04             	mov    0x4(%eax),%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	74 0f                	je     80318d <insert_sorted_with_merge_freeList+0x6f5>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803187:	8b 12                	mov    (%edx),%edx
  803189:	89 10                	mov    %edx,(%eax)
  80318b:	eb 0a                	jmp    803197 <insert_sorted_with_merge_freeList+0x6ff>
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	a3 38 51 80 00       	mov    %eax,0x805138
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8031af:	48                   	dec    %eax
  8031b0:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8031b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b9:	75 17                	jne    8031d2 <insert_sorted_with_merge_freeList+0x73a>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 50 3f 80 00       	push   $0x803f50
  8031c3:	68 87 01 00 00       	push   $0x187
  8031c8:	68 73 3f 80 00       	push   $0x803f73
  8031cd:	e8 04 d3 ff ff       	call   8004d6 <_panic>
  8031d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	89 10                	mov    %edx,(%eax)
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 0d                	je     8031f3 <insert_sorted_with_merge_freeList+0x75b>
  8031e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8031eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	eb 08                	jmp    8031fb <insert_sorted_with_merge_freeList+0x763>
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320d:	a1 54 51 80 00       	mov    0x805154,%eax
  803212:	40                   	inc    %eax
  803213:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80322c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803230:	75 17                	jne    803249 <insert_sorted_with_merge_freeList+0x7b1>
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	68 50 3f 80 00       	push   $0x803f50
  80323a:	68 8a 01 00 00       	push   $0x18a
  80323f:	68 73 3f 80 00       	push   $0x803f73
  803244:	e8 8d d2 ff ff       	call   8004d6 <_panic>
  803249:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	89 10                	mov    %edx,(%eax)
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 0d                	je     80326a <insert_sorted_with_merge_freeList+0x7d2>
  80325d:	a1 48 51 80 00       	mov    0x805148,%eax
  803262:	8b 55 08             	mov    0x8(%ebp),%edx
  803265:	89 50 04             	mov    %edx,0x4(%eax)
  803268:	eb 08                	jmp    803272 <insert_sorted_with_merge_freeList+0x7da>
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	a3 48 51 80 00       	mov    %eax,0x805148
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803284:	a1 54 51 80 00       	mov    0x805154,%eax
  803289:	40                   	inc    %eax
  80328a:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  80328f:	eb 14                	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329d:	0f 85 72 fb ff ff    	jne    802e15 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8032a3:	eb 00                	jmp    8032a5 <insert_sorted_with_merge_freeList+0x80d>
  8032a5:	90                   	nop
  8032a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032a9:	c9                   	leave  
  8032aa:	c3                   	ret    
  8032ab:	90                   	nop

008032ac <__udivdi3>:
  8032ac:	55                   	push   %ebp
  8032ad:	57                   	push   %edi
  8032ae:	56                   	push   %esi
  8032af:	53                   	push   %ebx
  8032b0:	83 ec 1c             	sub    $0x1c,%esp
  8032b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032c3:	89 ca                	mov    %ecx,%edx
  8032c5:	89 f8                	mov    %edi,%eax
  8032c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032cb:	85 f6                	test   %esi,%esi
  8032cd:	75 2d                	jne    8032fc <__udivdi3+0x50>
  8032cf:	39 cf                	cmp    %ecx,%edi
  8032d1:	77 65                	ja     803338 <__udivdi3+0x8c>
  8032d3:	89 fd                	mov    %edi,%ebp
  8032d5:	85 ff                	test   %edi,%edi
  8032d7:	75 0b                	jne    8032e4 <__udivdi3+0x38>
  8032d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032de:	31 d2                	xor    %edx,%edx
  8032e0:	f7 f7                	div    %edi
  8032e2:	89 c5                	mov    %eax,%ebp
  8032e4:	31 d2                	xor    %edx,%edx
  8032e6:	89 c8                	mov    %ecx,%eax
  8032e8:	f7 f5                	div    %ebp
  8032ea:	89 c1                	mov    %eax,%ecx
  8032ec:	89 d8                	mov    %ebx,%eax
  8032ee:	f7 f5                	div    %ebp
  8032f0:	89 cf                	mov    %ecx,%edi
  8032f2:	89 fa                	mov    %edi,%edx
  8032f4:	83 c4 1c             	add    $0x1c,%esp
  8032f7:	5b                   	pop    %ebx
  8032f8:	5e                   	pop    %esi
  8032f9:	5f                   	pop    %edi
  8032fa:	5d                   	pop    %ebp
  8032fb:	c3                   	ret    
  8032fc:	39 ce                	cmp    %ecx,%esi
  8032fe:	77 28                	ja     803328 <__udivdi3+0x7c>
  803300:	0f bd fe             	bsr    %esi,%edi
  803303:	83 f7 1f             	xor    $0x1f,%edi
  803306:	75 40                	jne    803348 <__udivdi3+0x9c>
  803308:	39 ce                	cmp    %ecx,%esi
  80330a:	72 0a                	jb     803316 <__udivdi3+0x6a>
  80330c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803310:	0f 87 9e 00 00 00    	ja     8033b4 <__udivdi3+0x108>
  803316:	b8 01 00 00 00       	mov    $0x1,%eax
  80331b:	89 fa                	mov    %edi,%edx
  80331d:	83 c4 1c             	add    $0x1c,%esp
  803320:	5b                   	pop    %ebx
  803321:	5e                   	pop    %esi
  803322:	5f                   	pop    %edi
  803323:	5d                   	pop    %ebp
  803324:	c3                   	ret    
  803325:	8d 76 00             	lea    0x0(%esi),%esi
  803328:	31 ff                	xor    %edi,%edi
  80332a:	31 c0                	xor    %eax,%eax
  80332c:	89 fa                	mov    %edi,%edx
  80332e:	83 c4 1c             	add    $0x1c,%esp
  803331:	5b                   	pop    %ebx
  803332:	5e                   	pop    %esi
  803333:	5f                   	pop    %edi
  803334:	5d                   	pop    %ebp
  803335:	c3                   	ret    
  803336:	66 90                	xchg   %ax,%ax
  803338:	89 d8                	mov    %ebx,%eax
  80333a:	f7 f7                	div    %edi
  80333c:	31 ff                	xor    %edi,%edi
  80333e:	89 fa                	mov    %edi,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	bd 20 00 00 00       	mov    $0x20,%ebp
  80334d:	89 eb                	mov    %ebp,%ebx
  80334f:	29 fb                	sub    %edi,%ebx
  803351:	89 f9                	mov    %edi,%ecx
  803353:	d3 e6                	shl    %cl,%esi
  803355:	89 c5                	mov    %eax,%ebp
  803357:	88 d9                	mov    %bl,%cl
  803359:	d3 ed                	shr    %cl,%ebp
  80335b:	89 e9                	mov    %ebp,%ecx
  80335d:	09 f1                	or     %esi,%ecx
  80335f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803363:	89 f9                	mov    %edi,%ecx
  803365:	d3 e0                	shl    %cl,%eax
  803367:	89 c5                	mov    %eax,%ebp
  803369:	89 d6                	mov    %edx,%esi
  80336b:	88 d9                	mov    %bl,%cl
  80336d:	d3 ee                	shr    %cl,%esi
  80336f:	89 f9                	mov    %edi,%ecx
  803371:	d3 e2                	shl    %cl,%edx
  803373:	8b 44 24 08          	mov    0x8(%esp),%eax
  803377:	88 d9                	mov    %bl,%cl
  803379:	d3 e8                	shr    %cl,%eax
  80337b:	09 c2                	or     %eax,%edx
  80337d:	89 d0                	mov    %edx,%eax
  80337f:	89 f2                	mov    %esi,%edx
  803381:	f7 74 24 0c          	divl   0xc(%esp)
  803385:	89 d6                	mov    %edx,%esi
  803387:	89 c3                	mov    %eax,%ebx
  803389:	f7 e5                	mul    %ebp
  80338b:	39 d6                	cmp    %edx,%esi
  80338d:	72 19                	jb     8033a8 <__udivdi3+0xfc>
  80338f:	74 0b                	je     80339c <__udivdi3+0xf0>
  803391:	89 d8                	mov    %ebx,%eax
  803393:	31 ff                	xor    %edi,%edi
  803395:	e9 58 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033a0:	89 f9                	mov    %edi,%ecx
  8033a2:	d3 e2                	shl    %cl,%edx
  8033a4:	39 c2                	cmp    %eax,%edx
  8033a6:	73 e9                	jae    803391 <__udivdi3+0xe5>
  8033a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033ab:	31 ff                	xor    %edi,%edi
  8033ad:	e9 40 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  8033b2:	66 90                	xchg   %ax,%ax
  8033b4:	31 c0                	xor    %eax,%eax
  8033b6:	e9 37 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  8033bb:	90                   	nop

008033bc <__umoddi3>:
  8033bc:	55                   	push   %ebp
  8033bd:	57                   	push   %edi
  8033be:	56                   	push   %esi
  8033bf:	53                   	push   %ebx
  8033c0:	83 ec 1c             	sub    $0x1c,%esp
  8033c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033db:	89 f3                	mov    %esi,%ebx
  8033dd:	89 fa                	mov    %edi,%edx
  8033df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033e3:	89 34 24             	mov    %esi,(%esp)
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	75 1a                	jne    803404 <__umoddi3+0x48>
  8033ea:	39 f7                	cmp    %esi,%edi
  8033ec:	0f 86 a2 00 00 00    	jbe    803494 <__umoddi3+0xd8>
  8033f2:	89 c8                	mov    %ecx,%eax
  8033f4:	89 f2                	mov    %esi,%edx
  8033f6:	f7 f7                	div    %edi
  8033f8:	89 d0                	mov    %edx,%eax
  8033fa:	31 d2                	xor    %edx,%edx
  8033fc:	83 c4 1c             	add    $0x1c,%esp
  8033ff:	5b                   	pop    %ebx
  803400:	5e                   	pop    %esi
  803401:	5f                   	pop    %edi
  803402:	5d                   	pop    %ebp
  803403:	c3                   	ret    
  803404:	39 f0                	cmp    %esi,%eax
  803406:	0f 87 ac 00 00 00    	ja     8034b8 <__umoddi3+0xfc>
  80340c:	0f bd e8             	bsr    %eax,%ebp
  80340f:	83 f5 1f             	xor    $0x1f,%ebp
  803412:	0f 84 ac 00 00 00    	je     8034c4 <__umoddi3+0x108>
  803418:	bf 20 00 00 00       	mov    $0x20,%edi
  80341d:	29 ef                	sub    %ebp,%edi
  80341f:	89 fe                	mov    %edi,%esi
  803421:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803425:	89 e9                	mov    %ebp,%ecx
  803427:	d3 e0                	shl    %cl,%eax
  803429:	89 d7                	mov    %edx,%edi
  80342b:	89 f1                	mov    %esi,%ecx
  80342d:	d3 ef                	shr    %cl,%edi
  80342f:	09 c7                	or     %eax,%edi
  803431:	89 e9                	mov    %ebp,%ecx
  803433:	d3 e2                	shl    %cl,%edx
  803435:	89 14 24             	mov    %edx,(%esp)
  803438:	89 d8                	mov    %ebx,%eax
  80343a:	d3 e0                	shl    %cl,%eax
  80343c:	89 c2                	mov    %eax,%edx
  80343e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803442:	d3 e0                	shl    %cl,%eax
  803444:	89 44 24 04          	mov    %eax,0x4(%esp)
  803448:	8b 44 24 08          	mov    0x8(%esp),%eax
  80344c:	89 f1                	mov    %esi,%ecx
  80344e:	d3 e8                	shr    %cl,%eax
  803450:	09 d0                	or     %edx,%eax
  803452:	d3 eb                	shr    %cl,%ebx
  803454:	89 da                	mov    %ebx,%edx
  803456:	f7 f7                	div    %edi
  803458:	89 d3                	mov    %edx,%ebx
  80345a:	f7 24 24             	mull   (%esp)
  80345d:	89 c6                	mov    %eax,%esi
  80345f:	89 d1                	mov    %edx,%ecx
  803461:	39 d3                	cmp    %edx,%ebx
  803463:	0f 82 87 00 00 00    	jb     8034f0 <__umoddi3+0x134>
  803469:	0f 84 91 00 00 00    	je     803500 <__umoddi3+0x144>
  80346f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803473:	29 f2                	sub    %esi,%edx
  803475:	19 cb                	sbb    %ecx,%ebx
  803477:	89 d8                	mov    %ebx,%eax
  803479:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80347d:	d3 e0                	shl    %cl,%eax
  80347f:	89 e9                	mov    %ebp,%ecx
  803481:	d3 ea                	shr    %cl,%edx
  803483:	09 d0                	or     %edx,%eax
  803485:	89 e9                	mov    %ebp,%ecx
  803487:	d3 eb                	shr    %cl,%ebx
  803489:	89 da                	mov    %ebx,%edx
  80348b:	83 c4 1c             	add    $0x1c,%esp
  80348e:	5b                   	pop    %ebx
  80348f:	5e                   	pop    %esi
  803490:	5f                   	pop    %edi
  803491:	5d                   	pop    %ebp
  803492:	c3                   	ret    
  803493:	90                   	nop
  803494:	89 fd                	mov    %edi,%ebp
  803496:	85 ff                	test   %edi,%edi
  803498:	75 0b                	jne    8034a5 <__umoddi3+0xe9>
  80349a:	b8 01 00 00 00       	mov    $0x1,%eax
  80349f:	31 d2                	xor    %edx,%edx
  8034a1:	f7 f7                	div    %edi
  8034a3:	89 c5                	mov    %eax,%ebp
  8034a5:	89 f0                	mov    %esi,%eax
  8034a7:	31 d2                	xor    %edx,%edx
  8034a9:	f7 f5                	div    %ebp
  8034ab:	89 c8                	mov    %ecx,%eax
  8034ad:	f7 f5                	div    %ebp
  8034af:	89 d0                	mov    %edx,%eax
  8034b1:	e9 44 ff ff ff       	jmp    8033fa <__umoddi3+0x3e>
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	89 c8                	mov    %ecx,%eax
  8034ba:	89 f2                	mov    %esi,%edx
  8034bc:	83 c4 1c             	add    $0x1c,%esp
  8034bf:	5b                   	pop    %ebx
  8034c0:	5e                   	pop    %esi
  8034c1:	5f                   	pop    %edi
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    
  8034c4:	3b 04 24             	cmp    (%esp),%eax
  8034c7:	72 06                	jb     8034cf <__umoddi3+0x113>
  8034c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034cd:	77 0f                	ja     8034de <__umoddi3+0x122>
  8034cf:	89 f2                	mov    %esi,%edx
  8034d1:	29 f9                	sub    %edi,%ecx
  8034d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034d7:	89 14 24             	mov    %edx,(%esp)
  8034da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034e2:	8b 14 24             	mov    (%esp),%edx
  8034e5:	83 c4 1c             	add    $0x1c,%esp
  8034e8:	5b                   	pop    %ebx
  8034e9:	5e                   	pop    %esi
  8034ea:	5f                   	pop    %edi
  8034eb:	5d                   	pop    %ebp
  8034ec:	c3                   	ret    
  8034ed:	8d 76 00             	lea    0x0(%esi),%esi
  8034f0:	2b 04 24             	sub    (%esp),%eax
  8034f3:	19 fa                	sbb    %edi,%edx
  8034f5:	89 d1                	mov    %edx,%ecx
  8034f7:	89 c6                	mov    %eax,%esi
  8034f9:	e9 71 ff ff ff       	jmp    80346f <__umoddi3+0xb3>
  8034fe:	66 90                	xchg   %ax,%ax
  803500:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803504:	72 ea                	jb     8034f0 <__umoddi3+0x134>
  803506:	89 d9                	mov    %ebx,%ecx
  803508:	e9 62 ff ff ff       	jmp    80346f <__umoddi3+0xb3>
