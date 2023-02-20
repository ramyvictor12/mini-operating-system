
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 0a 1a 00 00       	call   801a5c <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 83 15 00 00       	call   8015f8 <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 dc 19 00 00       	call   801a5c <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 ed 19 00 00       	call   801a75 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 40 34 80 00       	push   $0x803440
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 22 15 00 00       	call   801683 <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 40 80 00       	mov    0x804020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 60 34 80 00       	push   $0x803460
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 8e 34 80 00       	push   $0x80348e
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 57 18 00 00       	call   801a5c <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 68 18 00 00       	call   801a75 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 60 18 00 00       	call   801a75 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 40 18 00 00       	call   801a5c <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 a4 34 80 00       	push   $0x8034a4
  80023a:	6a 53                	push   $0x53
  80023c:	68 8e 34 80 00       	push   $0x80348e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 f8 34 80 00       	push   $0x8034f8
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 54 35 80 00       	push   $0x803554
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 38 36 80 00       	push   $0x803638
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 8e 34 80 00       	push   $0x80348e
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 79 1a 00 00       	call   801d3c <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 1b 18 00 00       	call   801b49 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 58 37 80 00       	push   $0x803758
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 40 80 00       	mov    0x804020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 80 37 80 00       	push   $0x803780
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 40 80 00       	mov    0x804020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 a8 37 80 00       	push   $0x8037a8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 00 38 80 00       	push   $0x803800
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 58 37 80 00       	push   $0x803758
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 9b 17 00 00       	call   801b63 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 28 19 00 00       	call   801d08 <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 7d 19 00 00       	call   801d6e <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 14 38 80 00       	push   $0x803814
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 40 80 00       	mov    0x804000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 19 38 80 00       	push   $0x803819
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 35 38 80 00       	push   $0x803835
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 40 80 00       	mov    0x804020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 38 38 80 00       	push   $0x803838
  800483:	6a 26                	push   $0x26
  800485:	68 84 38 80 00       	push   $0x803884
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 90 38 80 00       	push   $0x803890
  800555:	6a 3a                	push   $0x3a
  800557:	68 84 38 80 00       	push   $0x803884
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 40 80 00       	mov    0x804020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 e4 38 80 00       	push   $0x8038e4
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 84 38 80 00       	push   $0x803884
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 40 80 00       	mov    0x804024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 7c 13 00 00       	call   80199b <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 40 80 00       	mov    0x804024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 05 13 00 00       	call   80199b <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 69 14 00 00       	call   801b49 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 63 14 00 00       	call   801b63 <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 82 2a 00 00       	call   8031cc <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 42 2b 00 00       	call   8032dc <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 54 3b 80 00       	add    $0x803b54,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 65 3b 80 00       	push   $0x803b65
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 6e 3b 80 00       	push   $0x803b6e
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be 71 3b 80 00       	mov    $0x803b71,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 d0 3c 80 00       	push   $0x803cd0
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801469:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801470:	00 00 00 
  801473:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80147a:	00 00 00 
  80147d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801484:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801487:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80148e:	00 00 00 
  801491:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801498:	00 00 00 
  80149b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8014a2:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8014a5:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014ac:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8014af:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8014b6:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ca:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8014cf:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8014d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	6a 06                	push   $0x6
  8014e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8014eb:	50                   	push   %eax
  8014ec:	e8 ee 05 00 00       	call   801adf <sys_allocate_chunk>
  8014f1:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	50                   	push   %eax
  8014fd:	e8 63 0c 00 00       	call   802165 <initialize_MemBlocksList>
  801502:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801505:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80150a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80150d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801510:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151a:	8b 40 0c             	mov    0xc(%eax),%eax
  80151d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801523:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801528:	89 c2                	mov    %eax,%edx
  80152a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152d:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801533:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80153a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801544:	8b 50 08             	mov    0x8(%eax),%edx
  801547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	48                   	dec    %eax
  80154d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801550:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801553:	ba 00 00 00 00       	mov    $0x0,%edx
  801558:	f7 75 e0             	divl   -0x20(%ebp)
  80155b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80155e:	29 d0                	sub    %edx,%eax
  801560:	89 c2                	mov    %eax,%edx
  801562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801565:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801568:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80156c:	75 14                	jne    801582 <initialize_dyn_block_system+0x11f>
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	68 f5 3c 80 00       	push   $0x803cf5
  801576:	6a 34                	push   $0x34
  801578:	68 13 3d 80 00       	push   $0x803d13
  80157d:	e8 72 ee ff ff       	call   8003f4 <_panic>
  801582:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	85 c0                	test   %eax,%eax
  801589:	74 10                	je     80159b <initialize_dyn_block_system+0x138>
  80158b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158e:	8b 00                	mov    (%eax),%eax
  801590:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801593:	8b 52 04             	mov    0x4(%edx),%edx
  801596:	89 50 04             	mov    %edx,0x4(%eax)
  801599:	eb 0b                	jmp    8015a6 <initialize_dyn_block_system+0x143>
  80159b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159e:	8b 40 04             	mov    0x4(%eax),%eax
  8015a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8015a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a9:	8b 40 04             	mov    0x4(%eax),%eax
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	74 0f                	je     8015bf <initialize_dyn_block_system+0x15c>
  8015b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b3:	8b 40 04             	mov    0x4(%eax),%eax
  8015b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015b9:	8b 12                	mov    (%edx),%edx
  8015bb:	89 10                	mov    %edx,(%eax)
  8015bd:	eb 0a                	jmp    8015c9 <initialize_dyn_block_system+0x166>
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8015c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8015e1:	48                   	dec    %eax
  8015e2:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ed:	e8 c4 13 00 00       	call   8029b6 <insert_sorted_with_merge_freeList>
  8015f2:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015f5:	90                   	nop
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fe:	e8 2f fe ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  801603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801607:	75 07                	jne    801610 <malloc+0x18>
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
  80160e:	eb 71                	jmp    801681 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801610:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801617:	76 07                	jbe    801620 <malloc+0x28>
	return NULL;
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
  80161e:	eb 61                	jmp    801681 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801620:	e8 88 08 00 00       	call   801ead <sys_isUHeapPlacementStrategyFIRSTFIT>
  801625:	85 c0                	test   %eax,%eax
  801627:	74 53                	je     80167c <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801629:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801630:	8b 55 08             	mov    0x8(%ebp),%edx
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	01 d0                	add    %edx,%eax
  801638:	48                   	dec    %eax
  801639:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	f7 75 f4             	divl   -0xc(%ebp)
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	29 d0                	sub    %edx,%eax
  80164c:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	ff 75 ec             	pushl  -0x14(%ebp)
  801655:	e8 d2 0d 00 00       	call   80242c <alloc_block_FF>
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801660:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801664:	74 16                	je     80167c <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801666:	83 ec 0c             	sub    $0xc,%esp
  801669:	ff 75 e8             	pushl  -0x18(%ebp)
  80166c:	e8 0c 0c 00 00       	call   80227d <insert_sorted_allocList>
  801671:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	eb 05                	jmp    801681 <malloc+0x89>
    }

			}


	return NULL;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801697:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80169a:	83 ec 08             	sub    $0x8,%esp
  80169d:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a0:	68 40 40 80 00       	push   $0x804040
  8016a5:	e8 a0 0b 00 00       	call   80224a <find_block>
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8016b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	e8 e4 03 00 00       	call   801aa7 <sys_free_user_mem>
  8016c3:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8016c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ca:	75 17                	jne    8016e3 <free+0x60>
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 f5 3c 80 00       	push   $0x803cf5
  8016d4:	68 84 00 00 00       	push   $0x84
  8016d9:	68 13 3d 80 00       	push   $0x803d13
  8016de:	e8 11 ed ff ff       	call   8003f4 <_panic>
  8016e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 10                	je     8016fc <free+0x79>
  8016ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ef:	8b 00                	mov    (%eax),%eax
  8016f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f4:	8b 52 04             	mov    0x4(%edx),%edx
  8016f7:	89 50 04             	mov    %edx,0x4(%eax)
  8016fa:	eb 0b                	jmp    801707 <free+0x84>
  8016fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ff:	8b 40 04             	mov    0x4(%eax),%eax
  801702:	a3 44 40 80 00       	mov    %eax,0x804044
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	8b 40 04             	mov    0x4(%eax),%eax
  80170d:	85 c0                	test   %eax,%eax
  80170f:	74 0f                	je     801720 <free+0x9d>
  801711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801714:	8b 40 04             	mov    0x4(%eax),%eax
  801717:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171a:	8b 12                	mov    (%edx),%edx
  80171c:	89 10                	mov    %edx,(%eax)
  80171e:	eb 0a                	jmp    80172a <free+0xa7>
  801720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801723:	8b 00                	mov    (%eax),%eax
  801725:	a3 40 40 80 00       	mov    %eax,0x804040
  80172a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80173d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801742:	48                   	dec    %eax
  801743:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 ec             	pushl  -0x14(%ebp)
  80174e:	e8 63 12 00 00       	call   8029b6 <insert_sorted_with_merge_freeList>
  801753:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801756:	90                   	nop
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 38             	sub    $0x38,%esp
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801765:	e8 c8 fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  80176a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176e:	75 0a                	jne    80177a <smalloc+0x21>
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	e9 a0 00 00 00       	jmp    80181a <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80177a:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801781:	76 0a                	jbe    80178d <smalloc+0x34>
		return NULL;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	e9 8d 00 00 00       	jmp    80181a <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80178d:	e8 1b 07 00 00       	call   801ead <sys_isUHeapPlacementStrategyFIRSTFIT>
  801792:	85 c0                	test   %eax,%eax
  801794:	74 7f                	je     801815 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801796:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	01 d0                	add    %edx,%eax
  8017a5:	48                   	dec    %eax
  8017a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	f7 75 f4             	divl   -0xc(%ebp)
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	29 d0                	sub    %edx,%eax
  8017b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8017bc:	83 ec 0c             	sub    $0xc,%esp
  8017bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8017c2:	e8 65 0c 00 00       	call   80242c <alloc_block_FF>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8017cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017d1:	74 42                	je     801815 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8017d3:	83 ec 0c             	sub    $0xc,%esp
  8017d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d9:	e8 9f 0a 00 00       	call   80227d <insert_sorted_allocList>
  8017de:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8017e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e4:	8b 40 08             	mov    0x8(%eax),%eax
  8017e7:	89 c2                	mov    %eax,%edx
  8017e9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017ed:	52                   	push   %edx
  8017ee:	50                   	push   %eax
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 38 04 00 00       	call   801c32 <sys_createSharedObject>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801804:	79 07                	jns    80180d <smalloc+0xb4>
	    		  return NULL;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb 0d                	jmp    80181a <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80180d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801810:	8b 40 08             	mov    0x8(%eax),%eax
  801813:	eb 05                	jmp    80181a <smalloc+0xc1>


				}


		return NULL;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801822:	e8 0b fc ff ff       	call   801432 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801827:	e8 81 06 00 00       	call   801ead <sys_isUHeapPlacementStrategyFIRSTFIT>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	0f 84 9f 00 00 00    	je     8018d3 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	e8 1a 04 00 00       	call   801c5c <sys_getSizeOfSharedObject>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80184c:	79 0a                	jns    801858 <sget+0x3c>
		return NULL;
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	e9 80 00 00 00       	jmp    8018d8 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801858:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80185f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801865:	01 d0                	add    %edx,%eax
  801867:	48                   	dec    %eax
  801868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80186b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	f7 75 f0             	divl   -0x10(%ebp)
  801876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801879:	29 d0                	sub    %edx,%eax
  80187b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80187e:	83 ec 0c             	sub    $0xc,%esp
  801881:	ff 75 e8             	pushl  -0x18(%ebp)
  801884:	e8 a3 0b 00 00       	call   80242c <alloc_block_FF>
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80188f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801893:	74 3e                	je     8018d3 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	ff 75 e4             	pushl  -0x1c(%ebp)
  80189b:	e8 dd 09 00 00       	call   80227d <insert_sorted_allocList>
  8018a0:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8018a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a6:	8b 40 08             	mov    0x8(%eax),%eax
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	50                   	push   %eax
  8018ad:	ff 75 0c             	pushl  0xc(%ebp)
  8018b0:	ff 75 08             	pushl  0x8(%ebp)
  8018b3:	e8 c1 03 00 00       	call   801c79 <sys_getSharedObject>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8018be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c2:	79 07                	jns    8018cb <sget+0xaf>
	    		  return NULL;
  8018c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c9:	eb 0d                	jmp    8018d8 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8018cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ce:	8b 40 08             	mov    0x8(%eax),%eax
  8018d1:	eb 05                	jmp    8018d8 <sget+0xbc>
	      }
	}
	   return NULL;
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e0:	e8 4d fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	68 20 3d 80 00       	push   $0x803d20
  8018ed:	68 12 01 00 00       	push   $0x112
  8018f2:	68 13 3d 80 00       	push   $0x803d13
  8018f7:	e8 f8 ea ff ff       	call   8003f4 <_panic>

008018fc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	68 48 3d 80 00       	push   $0x803d48
  80190a:	68 26 01 00 00       	push   $0x126
  80190f:	68 13 3d 80 00       	push   $0x803d13
  801914:	e8 db ea ff ff       	call   8003f4 <_panic>

00801919 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	68 6c 3d 80 00       	push   $0x803d6c
  801927:	68 31 01 00 00       	push   $0x131
  80192c:	68 13 3d 80 00       	push   $0x803d13
  801931:	e8 be ea ff ff       	call   8003f4 <_panic>

00801936 <shrink>:

}
void shrink(uint32 newSize)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 6c 3d 80 00       	push   $0x803d6c
  801944:	68 36 01 00 00       	push   $0x136
  801949:	68 13 3d 80 00       	push   $0x803d13
  80194e:	e8 a1 ea ff ff       	call   8003f4 <_panic>

00801953 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	68 6c 3d 80 00       	push   $0x803d6c
  801961:	68 3b 01 00 00       	push   $0x13b
  801966:	68 13 3d 80 00       	push   $0x803d13
  80196b:	e8 84 ea ff ff       	call   8003f4 <_panic>

00801970 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	57                   	push   %edi
  801974:	56                   	push   %esi
  801975:	53                   	push   %ebx
  801976:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801982:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801985:	8b 7d 18             	mov    0x18(%ebp),%edi
  801988:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198b:	cd 30                	int    $0x30
  80198d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801990:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5f                   	pop    %edi
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    

0080199b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	52                   	push   %edx
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	e8 b2 ff ff ff       	call   801970 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 01                	push   $0x1
  8019d3:	e8 98 ff ff ff       	call   801970 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 05                	push   $0x5
  8019f0:	e8 7b ff ff ff       	call   801970 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801a02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	51                   	push   %ecx
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 06                	push   $0x6
  801a15:	e8 56 ff ff ff       	call   801970 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	52                   	push   %edx
  801a34:	50                   	push   %eax
  801a35:	6a 07                	push   $0x7
  801a37:	e8 34 ff ff ff       	call   801970 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 08                	push   $0x8
  801a52:	e8 19 ff ff ff       	call   801970 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 09                	push   $0x9
  801a6b:	e8 00 ff ff ff       	call   801970 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 0a                	push   $0xa
  801a84:	e8 e7 fe ff ff       	call   801970 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 0b                	push   $0xb
  801a9d:	e8 ce fe ff ff       	call   801970 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	6a 0f                	push   $0xf
  801ab8:	e8 b3 fe ff ff       	call   801970 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
	return;
  801ac0:	90                   	nop
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	6a 10                	push   $0x10
  801ad4:	e8 97 fe ff ff       	call   801970 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
	return ;
  801adc:	90                   	nop
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	ff 75 10             	pushl  0x10(%ebp)
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 11                	push   $0x11
  801af1:	e8 7a fe ff ff       	call   801970 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return ;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 0c                	push   $0xc
  801b0b:	e8 60 fe ff ff       	call   801970 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 0d                	push   $0xd
  801b25:	e8 46 fe ff ff       	call   801970 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 0e                	push   $0xe
  801b3e:	e8 2d fe ff ff       	call   801970 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	90                   	nop
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 13                	push   $0x13
  801b58:	e8 13 fe ff ff       	call   801970 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 14                	push   $0x14
  801b72:	e8 f9 fd ff ff       	call   801970 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_cputc>:


void
sys_cputc(const char c)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b89:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	50                   	push   %eax
  801b96:	6a 15                	push   $0x15
  801b98:	e8 d3 fd ff ff       	call   801970 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	90                   	nop
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 16                	push   $0x16
  801bb2:	e8 b9 fd ff ff       	call   801970 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	50                   	push   %eax
  801bcd:	6a 17                	push   $0x17
  801bcf:	e8 9c fd ff ff       	call   801970 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	6a 1a                	push   $0x1a
  801bec:	e8 7f fd ff ff       	call   801970 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	52                   	push   %edx
  801c06:	50                   	push   %eax
  801c07:	6a 18                	push   $0x18
  801c09:	e8 62 fd ff ff       	call   801970 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	6a 19                	push   $0x19
  801c27:	e8 44 fd ff ff       	call   801970 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 04             	sub    $0x4,%esp
  801c38:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c41:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	51                   	push   %ecx
  801c4b:	52                   	push   %edx
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	50                   	push   %eax
  801c50:	6a 1b                	push   $0x1b
  801c52:	e8 19 fd ff ff       	call   801970 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	52                   	push   %edx
  801c6c:	50                   	push   %eax
  801c6d:	6a 1c                	push   $0x1c
  801c6f:	e8 fc fc ff ff       	call   801970 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	51                   	push   %ecx
  801c8a:	52                   	push   %edx
  801c8b:	50                   	push   %eax
  801c8c:	6a 1d                	push   $0x1d
  801c8e:	e8 dd fc ff ff       	call   801970 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	52                   	push   %edx
  801ca8:	50                   	push   %eax
  801ca9:	6a 1e                	push   $0x1e
  801cab:	e8 c0 fc ff ff       	call   801970 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 1f                	push   $0x1f
  801cc4:	e8 a7 fc ff ff       	call   801970 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	ff 75 14             	pushl  0x14(%ebp)
  801cd9:	ff 75 10             	pushl  0x10(%ebp)
  801cdc:	ff 75 0c             	pushl  0xc(%ebp)
  801cdf:	50                   	push   %eax
  801ce0:	6a 20                	push   $0x20
  801ce2:	e8 89 fc ff ff       	call   801970 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	50                   	push   %eax
  801cfb:	6a 21                	push   $0x21
  801cfd:	e8 6e fc ff ff       	call   801970 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	90                   	nop
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	50                   	push   %eax
  801d17:	6a 22                	push   $0x22
  801d19:	e8 52 fc ff ff       	call   801970 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 02                	push   $0x2
  801d32:	e8 39 fc ff ff       	call   801970 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 03                	push   $0x3
  801d4b:	e8 20 fc ff ff       	call   801970 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 04                	push   $0x4
  801d64:	e8 07 fc ff ff       	call   801970 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_exit_env>:


void sys_exit_env(void)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 23                	push   $0x23
  801d7d:	e8 ee fb ff ff       	call   801970 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	90                   	nop
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d8e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d91:	8d 50 04             	lea    0x4(%eax),%edx
  801d94:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	6a 24                	push   $0x24
  801da1:	e8 ca fb ff ff       	call   801970 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
	return result;
  801da9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801daf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db2:	89 01                	mov    %eax,(%ecx)
  801db4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	c9                   	leave  
  801dbb:	c2 04 00             	ret    $0x4

00801dbe <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	ff 75 10             	pushl  0x10(%ebp)
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	6a 12                	push   $0x12
  801dd0:	e8 9b fb ff ff       	call   801970 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd8:	90                   	nop
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_rcr2>:
uint32 sys_rcr2()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 25                	push   $0x25
  801dea:	e8 81 fb ff ff       	call   801970 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e00:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	50                   	push   %eax
  801e0d:	6a 26                	push   $0x26
  801e0f:	e8 5c fb ff ff       	call   801970 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <rsttst>:
void rsttst()
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 28                	push   $0x28
  801e29:	e8 42 fb ff ff       	call   801970 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e31:	90                   	nop
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e40:	8b 55 18             	mov    0x18(%ebp),%edx
  801e43:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e47:	52                   	push   %edx
  801e48:	50                   	push   %eax
  801e49:	ff 75 10             	pushl  0x10(%ebp)
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	6a 27                	push   $0x27
  801e54:	e8 17 fb ff ff       	call   801970 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5c:	90                   	nop
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <chktst>:
void chktst(uint32 n)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	6a 29                	push   $0x29
  801e6f:	e8 fc fa ff ff       	call   801970 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
	return ;
  801e77:	90                   	nop
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <inctst>:

void inctst()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 2a                	push   $0x2a
  801e89:	e8 e2 fa ff ff       	call   801970 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e91:	90                   	nop
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <gettst>:
uint32 gettst()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 2b                	push   $0x2b
  801ea3:	e8 c8 fa ff ff       	call   801970 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 2c                	push   $0x2c
  801ebf:	e8 ac fa ff ff       	call   801970 <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
  801ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eca:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ece:	75 07                	jne    801ed7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ed0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed5:	eb 05                	jmp    801edc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 2c                	push   $0x2c
  801ef0:	e8 7b fa ff ff       	call   801970 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
  801ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801efb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eff:	75 07                	jne    801f08 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f01:	b8 01 00 00 00       	mov    $0x1,%eax
  801f06:	eb 05                	jmp    801f0d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 2c                	push   $0x2c
  801f21:	e8 4a fa ff ff       	call   801970 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
  801f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f2c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f30:	75 07                	jne    801f39 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f32:	b8 01 00 00 00       	mov    $0x1,%eax
  801f37:	eb 05                	jmp    801f3e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 2c                	push   $0x2c
  801f52:	e8 19 fa ff ff       	call   801970 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
  801f5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f5d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f61:	75 07                	jne    801f6a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f63:	b8 01 00 00 00       	mov    $0x1,%eax
  801f68:	eb 05                	jmp    801f6f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	ff 75 08             	pushl  0x8(%ebp)
  801f7f:	6a 2d                	push   $0x2d
  801f81:	e8 ea f9 ff ff       	call   801970 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
	return ;
  801f89:	90                   	nop
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f90:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	6a 00                	push   $0x0
  801f9e:	53                   	push   %ebx
  801f9f:	51                   	push   %ecx
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	6a 2e                	push   $0x2e
  801fa4:	e8 c7 f9 ff ff       	call   801970 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	6a 2f                	push   $0x2f
  801fc4:	e8 a7 f9 ff ff       	call   801970 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	68 7c 3d 80 00       	push   $0x803d7c
  801fdc:	e8 c7 e6 ff ff       	call   8006a8 <cprintf>
  801fe1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fe4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	68 a8 3d 80 00       	push   $0x803da8
  801ff3:	e8 b0 e6 ff ff       	call   8006a8 <cprintf>
  801ff8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ffb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fff:	a1 38 41 80 00       	mov    0x804138,%eax
  802004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802007:	eb 56                	jmp    80205f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802009:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200d:	74 1c                	je     80202b <print_mem_block_lists+0x5d>
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	8b 50 08             	mov    0x8(%eax),%edx
  802015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802018:	8b 48 08             	mov    0x8(%eax),%ecx
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	8b 40 0c             	mov    0xc(%eax),%eax
  802021:	01 c8                	add    %ecx,%eax
  802023:	39 c2                	cmp    %eax,%edx
  802025:	73 04                	jae    80202b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802027:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 50 08             	mov    0x8(%eax),%edx
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 40 0c             	mov    0xc(%eax),%eax
  802037:	01 c2                	add    %eax,%edx
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 40 08             	mov    0x8(%eax),%eax
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	52                   	push   %edx
  802043:	50                   	push   %eax
  802044:	68 bd 3d 80 00       	push   $0x803dbd
  802049:	e8 5a e6 ff ff       	call   8006a8 <cprintf>
  80204e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802057:	a1 40 41 80 00       	mov    0x804140,%eax
  80205c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802063:	74 07                	je     80206c <print_mem_block_lists+0x9e>
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	eb 05                	jmp    802071 <print_mem_block_lists+0xa3>
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	a3 40 41 80 00       	mov    %eax,0x804140
  802076:	a1 40 41 80 00       	mov    0x804140,%eax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	75 8a                	jne    802009 <print_mem_block_lists+0x3b>
  80207f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802083:	75 84                	jne    802009 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802085:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802089:	75 10                	jne    80209b <print_mem_block_lists+0xcd>
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	68 cc 3d 80 00       	push   $0x803dcc
  802093:	e8 10 e6 ff ff       	call   8006a8 <cprintf>
  802098:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80209b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	68 f0 3d 80 00       	push   $0x803df0
  8020aa:	e8 f9 e5 ff ff       	call   8006a8 <cprintf>
  8020af:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020b2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b6:	a1 40 40 80 00       	mov    0x804040,%eax
  8020bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020be:	eb 56                	jmp    802116 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c4:	74 1c                	je     8020e2 <print_mem_block_lists+0x114>
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 50 08             	mov    0x8(%eax),%edx
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cf:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d8:	01 c8                	add    %ecx,%eax
  8020da:	39 c2                	cmp    %eax,%edx
  8020dc:	73 04                	jae    8020e2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020de:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 50 08             	mov    0x8(%eax),%edx
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ee:	01 c2                	add    %eax,%edx
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	52                   	push   %edx
  8020fa:	50                   	push   %eax
  8020fb:	68 bd 3d 80 00       	push   $0x803dbd
  802100:	e8 a3 e5 ff ff       	call   8006a8 <cprintf>
  802105:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80210e:	a1 48 40 80 00       	mov    0x804048,%eax
  802113:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211a:	74 07                	je     802123 <print_mem_block_lists+0x155>
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 00                	mov    (%eax),%eax
  802121:	eb 05                	jmp    802128 <print_mem_block_lists+0x15a>
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	a3 48 40 80 00       	mov    %eax,0x804048
  80212d:	a1 48 40 80 00       	mov    0x804048,%eax
  802132:	85 c0                	test   %eax,%eax
  802134:	75 8a                	jne    8020c0 <print_mem_block_lists+0xf2>
  802136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213a:	75 84                	jne    8020c0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80213c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802140:	75 10                	jne    802152 <print_mem_block_lists+0x184>
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	68 08 3e 80 00       	push   $0x803e08
  80214a:	e8 59 e5 ff ff       	call   8006a8 <cprintf>
  80214f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	68 7c 3d 80 00       	push   $0x803d7c
  80215a:	e8 49 e5 ff ff       	call   8006a8 <cprintf>
  80215f:	83 c4 10             	add    $0x10,%esp

}
  802162:	90                   	nop
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80216b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802172:	00 00 00 
  802175:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80217c:	00 00 00 
  80217f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802186:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802189:	a1 50 40 80 00       	mov    0x804050,%eax
  80218e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802198:	e9 9e 00 00 00       	jmp    80223b <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80219d:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a5:	c1 e2 04             	shl    $0x4,%edx
  8021a8:	01 d0                	add    %edx,%eax
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	75 14                	jne    8021c2 <initialize_MemBlocksList+0x5d>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 30 3e 80 00       	push   $0x803e30
  8021b6:	6a 48                	push   $0x48
  8021b8:	68 53 3e 80 00       	push   $0x803e53
  8021bd:	e8 32 e2 ff ff       	call   8003f4 <_panic>
  8021c2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ca:	c1 e2 04             	shl    $0x4,%edx
  8021cd:	01 d0                	add    %edx,%eax
  8021cf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021d5:	89 10                	mov    %edx,(%eax)
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 18                	je     8021f5 <initialize_MemBlocksList+0x90>
  8021dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8021e2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021e8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021eb:	c1 e1 04             	shl    $0x4,%ecx
  8021ee:	01 ca                	add    %ecx,%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	eb 12                	jmp    802207 <initialize_MemBlocksList+0xa2>
  8021f5:	a1 50 40 80 00       	mov    0x804050,%eax
  8021fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fd:	c1 e2 04             	shl    $0x4,%edx
  802200:	01 d0                	add    %edx,%eax
  802202:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802207:	a1 50 40 80 00       	mov    0x804050,%eax
  80220c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220f:	c1 e2 04             	shl    $0x4,%edx
  802212:	01 d0                	add    %edx,%eax
  802214:	a3 48 41 80 00       	mov    %eax,0x804148
  802219:	a1 50 40 80 00       	mov    0x804050,%eax
  80221e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802221:	c1 e2 04             	shl    $0x4,%edx
  802224:	01 d0                	add    %edx,%eax
  802226:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222d:	a1 54 41 80 00       	mov    0x804154,%eax
  802232:	40                   	inc    %eax
  802233:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802238:	ff 45 f4             	incl   -0xc(%ebp)
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802241:	0f 82 56 ff ff ff    	jb     80219d <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802247:	90                   	nop
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802258:	eb 18                	jmp    802272 <find_block+0x28>
		{
			if(tmp->sva==va)
  80225a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225d:	8b 40 08             	mov    0x8(%eax),%eax
  802260:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802263:	75 05                	jne    80226a <find_block+0x20>
			{
				return tmp;
  802265:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802268:	eb 11                	jmp    80227b <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80226a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802272:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802276:	75 e2                	jne    80225a <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802278:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802283:	a1 40 40 80 00       	mov    0x804040,%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	0f 85 83 00 00 00    	jne    802313 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802290:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802297:	00 00 00 
  80229a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8022a1:	00 00 00 
  8022a4:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8022ab:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b2:	75 14                	jne    8022c8 <insert_sorted_allocList+0x4b>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 30 3e 80 00       	push   $0x803e30
  8022bc:	6a 7f                	push   $0x7f
  8022be:	68 53 3e 80 00       	push   $0x803e53
  8022c3:	e8 2c e1 ff ff       	call   8003f4 <_panic>
  8022c8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 10                	mov    %edx,(%eax)
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	8b 00                	mov    (%eax),%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	74 0d                	je     8022e9 <insert_sorted_allocList+0x6c>
  8022dc:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	eb 08                	jmp    8022f1 <insert_sorted_allocList+0x74>
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 44 40 80 00       	mov    %eax,0x804044
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802303:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802308:	40                   	inc    %eax
  802309:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80230e:	e9 16 01 00 00       	jmp    802429 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8b 50 08             	mov    0x8(%eax),%edx
  802319:	a1 44 40 80 00       	mov    0x804044,%eax
  80231e:	8b 40 08             	mov    0x8(%eax),%eax
  802321:	39 c2                	cmp    %eax,%edx
  802323:	76 68                	jbe    80238d <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802329:	75 17                	jne    802342 <insert_sorted_allocList+0xc5>
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	68 6c 3e 80 00       	push   $0x803e6c
  802333:	68 85 00 00 00       	push   $0x85
  802338:	68 53 3e 80 00       	push   $0x803e53
  80233d:	e8 b2 e0 ff ff       	call   8003f4 <_panic>
  802342:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 40 04             	mov    0x4(%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 0c                	je     802364 <insert_sorted_allocList+0xe7>
  802358:	a1 44 40 80 00       	mov    0x804044,%eax
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	89 10                	mov    %edx,(%eax)
  802362:	eb 08                	jmp    80236c <insert_sorted_allocList+0xef>
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 40 40 80 00       	mov    %eax,0x804040
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	a3 44 40 80 00       	mov    %eax,0x804044
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802382:	40                   	inc    %eax
  802383:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802388:	e9 9c 00 00 00       	jmp    802429 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80238d:	a1 40 40 80 00       	mov    0x804040,%eax
  802392:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802395:	e9 85 00 00 00       	jmp    80241f <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8b 50 08             	mov    0x8(%eax),%edx
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 40 08             	mov    0x8(%eax),%eax
  8023a6:	39 c2                	cmp    %eax,%edx
  8023a8:	73 6d                	jae    802417 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8023aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ae:	74 06                	je     8023b6 <insert_sorted_allocList+0x139>
  8023b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b4:	75 17                	jne    8023cd <insert_sorted_allocList+0x150>
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	68 90 3e 80 00       	push   $0x803e90
  8023be:	68 90 00 00 00       	push   $0x90
  8023c3:	68 53 3e 80 00       	push   $0x803e53
  8023c8:	e8 27 e0 ff ff       	call   8003f4 <_panic>
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 50 04             	mov    0x4(%eax),%edx
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	89 50 04             	mov    %edx,0x4(%eax)
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023df:	89 10                	mov    %edx,(%eax)
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 04             	mov    0x4(%eax),%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 0d                	je     8023f8 <insert_sorted_allocList+0x17b>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 04             	mov    0x4(%eax),%eax
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f4:	89 10                	mov    %edx,(%eax)
  8023f6:	eb 08                	jmp    802400 <insert_sorted_allocList+0x183>
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	a3 40 40 80 00       	mov    %eax,0x804040
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 55 08             	mov    0x8(%ebp),%edx
  802406:	89 50 04             	mov    %edx,0x4(%eax)
  802409:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80240e:	40                   	inc    %eax
  80240f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802414:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802415:	eb 12                	jmp    802429 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  80241f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802423:	0f 85 71 ff ff ff    	jne    80239a <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802429:	90                   	nop
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802432:	a1 38 41 80 00       	mov    0x804138,%eax
  802437:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80243a:	e9 76 01 00 00       	jmp    8025b5 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 0c             	mov    0xc(%eax),%eax
  802445:	3b 45 08             	cmp    0x8(%ebp),%eax
  802448:	0f 85 8a 00 00 00    	jne    8024d8 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80244e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802452:	75 17                	jne    80246b <alloc_block_FF+0x3f>
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	68 c5 3e 80 00       	push   $0x803ec5
  80245c:	68 a8 00 00 00       	push   $0xa8
  802461:	68 53 3e 80 00       	push   $0x803e53
  802466:	e8 89 df ff ff       	call   8003f4 <_panic>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 10                	je     802484 <alloc_block_FF+0x58>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247c:	8b 52 04             	mov    0x4(%edx),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	eb 0b                	jmp    80248f <alloc_block_FF+0x63>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 04             	mov    0x4(%eax),%eax
  80248a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 0f                	je     8024a8 <alloc_block_FF+0x7c>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a2:	8b 12                	mov    (%edx),%edx
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	eb 0a                	jmp    8024b2 <alloc_block_FF+0x86>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ca:	48                   	dec    %eax
  8024cb:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	e9 ea 00 00 00       	jmp    8025c2 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 0c             	mov    0xc(%eax),%eax
  8024de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e1:	0f 86 c6 00 00 00    	jbe    8025ad <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8024e7:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f5:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 50 08             	mov    0x8(%eax),%edx
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 0c             	mov    0xc(%eax),%eax
  80250a:	2b 45 08             	sub    0x8(%ebp),%eax
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 50 08             	mov    0x8(%eax),%edx
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	01 c2                	add    %eax,%edx
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802526:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252a:	75 17                	jne    802543 <alloc_block_FF+0x117>
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	68 c5 3e 80 00       	push   $0x803ec5
  802534:	68 b6 00 00 00       	push   $0xb6
  802539:	68 53 3e 80 00       	push   $0x803e53
  80253e:	e8 b1 de ff ff       	call   8003f4 <_panic>
  802543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 10                	je     80255c <alloc_block_FF+0x130>
  80254c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802554:	8b 52 04             	mov    0x4(%edx),%edx
  802557:	89 50 04             	mov    %edx,0x4(%eax)
  80255a:	eb 0b                	jmp    802567 <alloc_block_FF+0x13b>
  80255c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255f:	8b 40 04             	mov    0x4(%eax),%eax
  802562:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256a:	8b 40 04             	mov    0x4(%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 0f                	je     802580 <alloc_block_FF+0x154>
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257a:	8b 12                	mov    (%edx),%edx
  80257c:	89 10                	mov    %edx,(%eax)
  80257e:	eb 0a                	jmp    80258a <alloc_block_FF+0x15e>
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	a3 48 41 80 00       	mov    %eax,0x804148
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259d:	a1 54 41 80 00       	mov    0x804154,%eax
  8025a2:	48                   	dec    %eax
  8025a3:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	eb 15                	jmp    8025c2 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	0f 85 80 fe ff ff    	jne    80243f <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8025ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8025cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8025d2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8025d9:	e9 c0 00 00 00       	jmp    80269e <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e7:	0f 85 8a 00 00 00    	jne    802677 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8025ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f1:	75 17                	jne    80260a <alloc_block_BF+0x46>
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 c5 3e 80 00       	push   $0x803ec5
  8025fb:	68 cf 00 00 00       	push   $0xcf
  802600:	68 53 3e 80 00       	push   $0x803e53
  802605:	e8 ea dd ff ff       	call   8003f4 <_panic>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 10                	je     802623 <alloc_block_BF+0x5f>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261b:	8b 52 04             	mov    0x4(%edx),%edx
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
  802621:	eb 0b                	jmp    80262e <alloc_block_BF+0x6a>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 0f                	je     802647 <alloc_block_BF+0x83>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	8b 12                	mov    (%edx),%edx
  802643:	89 10                	mov    %edx,(%eax)
  802645:	eb 0a                	jmp    802651 <alloc_block_BF+0x8d>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	a3 38 41 80 00       	mov    %eax,0x804138
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802664:	a1 44 41 80 00       	mov    0x804144,%eax
  802669:	48                   	dec    %eax
  80266a:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	e9 2a 01 00 00       	jmp    8027a1 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 0c             	mov    0xc(%eax),%eax
  80267d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802680:	73 14                	jae    802696 <alloc_block_BF+0xd2>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 0c             	mov    0xc(%eax),%eax
  802688:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268b:	76 09                	jbe    802696 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	0f 85 36 ff ff ff    	jne    8025de <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8026a8:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8026b0:	e9 dd 00 00 00       	jmp    802792 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026be:	0f 85 c6 00 00 00    	jne    80278a <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8026c4:	a1 48 41 80 00       	mov    0x804148,%eax
  8026c9:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 50 08             	mov    0x8(%eax),%edx
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	8b 55 08             	mov    0x8(%ebp),%edx
  8026de:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 50 08             	mov    0x8(%eax),%edx
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	01 c2                	add    %eax,%edx
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f8:	2b 45 08             	sub    0x8(%ebp),%eax
  8026fb:	89 c2                	mov    %eax,%edx
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802703:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802707:	75 17                	jne    802720 <alloc_block_BF+0x15c>
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	68 c5 3e 80 00       	push   $0x803ec5
  802711:	68 eb 00 00 00       	push   $0xeb
  802716:	68 53 3e 80 00       	push   $0x803e53
  80271b:	e8 d4 dc ff ff       	call   8003f4 <_panic>
  802720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 10                	je     802739 <alloc_block_BF+0x175>
  802729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802731:	8b 52 04             	mov    0x4(%edx),%edx
  802734:	89 50 04             	mov    %edx,0x4(%eax)
  802737:	eb 0b                	jmp    802744 <alloc_block_BF+0x180>
  802739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 0f                	je     80275d <alloc_block_BF+0x199>
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802757:	8b 12                	mov    (%edx),%edx
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	eb 0a                	jmp    802767 <alloc_block_BF+0x1a3>
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	a3 48 41 80 00       	mov    %eax,0x804148
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277a:	a1 54 41 80 00       	mov    0x804154,%eax
  80277f:	48                   	dec    %eax
  802780:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	eb 17                	jmp    8027a1 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802796:	0f 85 19 ff ff ff    	jne    8026b5 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
  8027a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8027a9:	a1 40 40 80 00       	mov    0x804040,%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	75 19                	jne    8027cb <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8027b2:	83 ec 0c             	sub    $0xc,%esp
  8027b5:	ff 75 08             	pushl  0x8(%ebp)
  8027b8:	e8 6f fc ff ff       	call   80242c <alloc_block_FF>
  8027bd:	83 c4 10             	add    $0x10,%esp
  8027c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	e9 e9 01 00 00       	jmp    8029b4 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8027cb:	a1 44 40 80 00       	mov    0x804044,%eax
  8027d0:	8b 40 08             	mov    0x8(%eax),%eax
  8027d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8027d6:	a1 44 40 80 00       	mov    0x804044,%eax
  8027db:	8b 50 0c             	mov    0xc(%eax),%edx
  8027de:	a1 44 40 80 00       	mov    0x804044,%eax
  8027e3:	8b 40 08             	mov    0x8(%eax),%eax
  8027e6:	01 d0                	add    %edx,%eax
  8027e8:	83 ec 08             	sub    $0x8,%esp
  8027eb:	50                   	push   %eax
  8027ec:	68 38 41 80 00       	push   $0x804138
  8027f1:	e8 54 fa ff ff       	call   80224a <find_block>
  8027f6:	83 c4 10             	add    $0x10,%esp
  8027f9:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	3b 45 08             	cmp    0x8(%ebp),%eax
  802805:	0f 85 9b 00 00 00    	jne    8028a6 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 50 0c             	mov    0xc(%eax),%edx
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 08             	mov    0x8(%eax),%eax
  802817:	01 d0                	add    %edx,%eax
  802819:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802820:	75 17                	jne    802839 <alloc_block_NF+0x96>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 c5 3e 80 00       	push   $0x803ec5
  80282a:	68 1a 01 00 00       	push   $0x11a
  80282f:	68 53 3e 80 00       	push   $0x803e53
  802834:	e8 bb db ff ff       	call   8003f4 <_panic>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 10                	je     802852 <alloc_block_NF+0xaf>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	8b 52 04             	mov    0x4(%edx),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	eb 0b                	jmp    80285d <alloc_block_NF+0xba>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0f                	je     802876 <alloc_block_NF+0xd3>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802870:	8b 12                	mov    (%edx),%edx
  802872:	89 10                	mov    %edx,(%eax)
  802874:	eb 0a                	jmp    802880 <alloc_block_NF+0xdd>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	a3 38 41 80 00       	mov    %eax,0x804138
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802893:	a1 44 41 80 00       	mov    0x804144,%eax
  802898:	48                   	dec    %eax
  802899:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	e9 0e 01 00 00       	jmp    8029b4 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028af:	0f 86 cf 00 00 00    	jbe    802984 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8028b5:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8028bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c3:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 50 08             	mov    0x8(%eax),%edx
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 50 08             	mov    0x8(%eax),%edx
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	01 c2                	add    %eax,%edx
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e9:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ec:	89 c2                	mov    %eax,%edx
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 08             	mov    0x8(%eax),%eax
  8028fa:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8028fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802901:	75 17                	jne    80291a <alloc_block_NF+0x177>
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	68 c5 3e 80 00       	push   $0x803ec5
  80290b:	68 28 01 00 00       	push   $0x128
  802910:	68 53 3e 80 00       	push   $0x803e53
  802915:	e8 da da ff ff       	call   8003f4 <_panic>
  80291a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 10                	je     802933 <alloc_block_NF+0x190>
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80292b:	8b 52 04             	mov    0x4(%edx),%edx
  80292e:	89 50 04             	mov    %edx,0x4(%eax)
  802931:	eb 0b                	jmp    80293e <alloc_block_NF+0x19b>
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80293e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	74 0f                	je     802957 <alloc_block_NF+0x1b4>
  802948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802951:	8b 12                	mov    (%edx),%edx
  802953:	89 10                	mov    %edx,(%eax)
  802955:	eb 0a                	jmp    802961 <alloc_block_NF+0x1be>
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	a3 48 41 80 00       	mov    %eax,0x804148
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802974:	a1 54 41 80 00       	mov    0x804154,%eax
  802979:	48                   	dec    %eax
  80297a:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	eb 30                	jmp    8029b4 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802984:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802989:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80298c:	75 0a                	jne    802998 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80298e:	a1 38 41 80 00       	mov    0x804138,%eax
  802993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802996:	eb 08                	jmp    8029a0 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 08             	mov    0x8(%eax),%eax
  8029a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029a9:	0f 85 4d fe ff ff    	jne    8027fc <alloc_block_NF+0x59>

			return NULL;
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8029b4:	c9                   	leave  
  8029b5:	c3                   	ret    

008029b6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029b6:	55                   	push   %ebp
  8029b7:	89 e5                	mov    %esp,%ebp
  8029b9:	53                   	push   %ebx
  8029ba:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8029bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	0f 85 86 00 00 00    	jne    802a50 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8029ca:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8029d1:	00 00 00 
  8029d4:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8029db:	00 00 00 
  8029de:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8029e5:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ec:	75 17                	jne    802a05 <insert_sorted_with_merge_freeList+0x4f>
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	68 30 3e 80 00       	push   $0x803e30
  8029f6:	68 48 01 00 00       	push   $0x148
  8029fb:	68 53 3e 80 00       	push   $0x803e53
  802a00:	e8 ef d9 ff ff       	call   8003f4 <_panic>
  802a05:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	89 10                	mov    %edx,(%eax)
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	85 c0                	test   %eax,%eax
  802a17:	74 0d                	je     802a26 <insert_sorted_with_merge_freeList+0x70>
  802a19:	a1 38 41 80 00       	mov    0x804138,%eax
  802a1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 08                	jmp    802a2e <insert_sorted_with_merge_freeList+0x78>
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	a3 38 41 80 00       	mov    %eax,0x804138
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a40:	a1 44 41 80 00       	mov    0x804144,%eax
  802a45:	40                   	inc    %eax
  802a46:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802a4b:	e9 73 07 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	8b 50 08             	mov    0x8(%eax),%edx
  802a56:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a5b:	8b 40 08             	mov    0x8(%eax),%eax
  802a5e:	39 c2                	cmp    %eax,%edx
  802a60:	0f 86 84 00 00 00    	jbe    802aea <insert_sorted_with_merge_freeList+0x134>
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8b 50 08             	mov    0x8(%eax),%edx
  802a6c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a71:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a74:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a79:	8b 40 08             	mov    0x8(%eax),%eax
  802a7c:	01 c8                	add    %ecx,%eax
  802a7e:	39 c2                	cmp    %eax,%edx
  802a80:	74 68                	je     802aea <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802a82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a86:	75 17                	jne    802a9f <insert_sorted_with_merge_freeList+0xe9>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 6c 3e 80 00       	push   $0x803e6c
  802a90:	68 4c 01 00 00       	push   $0x14c
  802a95:	68 53 3e 80 00       	push   $0x803e53
  802a9a:	e8 55 d9 ff ff       	call   8003f4 <_panic>
  802a9f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	89 50 04             	mov    %edx,0x4(%eax)
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 0c                	je     802ac1 <insert_sorted_with_merge_freeList+0x10b>
  802ab5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aba:	8b 55 08             	mov    0x8(%ebp),%edx
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	eb 08                	jmp    802ac9 <insert_sorted_with_merge_freeList+0x113>
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ada:	a1 44 41 80 00       	mov    0x804144,%eax
  802adf:	40                   	inc    %eax
  802ae0:	a3 44 41 80 00       	mov    %eax,0x804144
  802ae5:	e9 d9 06 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	8b 50 08             	mov    0x8(%eax),%edx
  802af0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af5:	8b 40 08             	mov    0x8(%eax),%eax
  802af8:	39 c2                	cmp    %eax,%edx
  802afa:	0f 86 b5 00 00 00    	jbe    802bb5 <insert_sorted_with_merge_freeList+0x1ff>
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	8b 50 08             	mov    0x8(%eax),%edx
  802b06:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b0b:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b0e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	01 c8                	add    %ecx,%eax
  802b18:	39 c2                	cmp    %eax,%edx
  802b1a:	0f 85 95 00 00 00    	jne    802bb5 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802b20:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b25:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b2b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b31:	8b 52 0c             	mov    0xc(%edx),%edx
  802b34:	01 ca                	add    %ecx,%edx
  802b36:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b51:	75 17                	jne    802b6a <insert_sorted_with_merge_freeList+0x1b4>
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	68 30 3e 80 00       	push   $0x803e30
  802b5b:	68 54 01 00 00       	push   $0x154
  802b60:	68 53 3e 80 00       	push   $0x803e53
  802b65:	e8 8a d8 ff ff       	call   8003f4 <_panic>
  802b6a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	89 10                	mov    %edx,(%eax)
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0d                	je     802b8b <insert_sorted_with_merge_freeList+0x1d5>
  802b7e:	a1 48 41 80 00       	mov    0x804148,%eax
  802b83:	8b 55 08             	mov    0x8(%ebp),%edx
  802b86:	89 50 04             	mov    %edx,0x4(%eax)
  802b89:	eb 08                	jmp    802b93 <insert_sorted_with_merge_freeList+0x1dd>
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	a3 48 41 80 00       	mov    %eax,0x804148
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba5:	a1 54 41 80 00       	mov    0x804154,%eax
  802baa:	40                   	inc    %eax
  802bab:	a3 54 41 80 00       	mov    %eax,0x804154
  802bb0:	e9 0e 06 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 50 08             	mov    0x8(%eax),%edx
  802bbb:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc0:	8b 40 08             	mov    0x8(%eax),%eax
  802bc3:	39 c2                	cmp    %eax,%edx
  802bc5:	0f 83 c1 00 00 00    	jae    802c8c <insert_sorted_with_merge_freeList+0x2d6>
  802bcb:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd0:	8b 50 08             	mov    0x8(%eax),%edx
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	01 c8                	add    %ecx,%eax
  802be1:	39 c2                	cmp    %eax,%edx
  802be3:	0f 85 a3 00 00 00    	jne    802c8c <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802be9:	a1 38 41 80 00       	mov    0x804138,%eax
  802bee:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf1:	8b 52 08             	mov    0x8(%edx),%edx
  802bf4:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802bf7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bfc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c02:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	8b 52 0c             	mov    0xc(%edx),%edx
  802c0b:	01 ca                	add    %ecx,%edx
  802c0d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c28:	75 17                	jne    802c41 <insert_sorted_with_merge_freeList+0x28b>
  802c2a:	83 ec 04             	sub    $0x4,%esp
  802c2d:	68 30 3e 80 00       	push   $0x803e30
  802c32:	68 5d 01 00 00       	push   $0x15d
  802c37:	68 53 3e 80 00       	push   $0x803e53
  802c3c:	e8 b3 d7 ff ff       	call   8003f4 <_panic>
  802c41:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	89 10                	mov    %edx,(%eax)
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0d                	je     802c62 <insert_sorted_with_merge_freeList+0x2ac>
  802c55:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
  802c60:	eb 08                	jmp    802c6a <insert_sorted_with_merge_freeList+0x2b4>
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	a3 48 41 80 00       	mov    %eax,0x804148
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c81:	40                   	inc    %eax
  802c82:	a3 54 41 80 00       	mov    %eax,0x804154
  802c87:	e9 37 05 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 50 08             	mov    0x8(%eax),%edx
  802c92:	a1 38 41 80 00       	mov    0x804138,%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	39 c2                	cmp    %eax,%edx
  802c9c:	0f 83 82 00 00 00    	jae    802d24 <insert_sorted_with_merge_freeList+0x36e>
  802ca2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	01 c8                	add    %ecx,%eax
  802cb8:	39 c2                	cmp    %eax,%edx
  802cba:	74 68                	je     802d24 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc0:	75 17                	jne    802cd9 <insert_sorted_with_merge_freeList+0x323>
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	68 30 3e 80 00       	push   $0x803e30
  802cca:	68 62 01 00 00       	push   $0x162
  802ccf:	68 53 3e 80 00       	push   $0x803e53
  802cd4:	e8 1b d7 ff ff       	call   8003f4 <_panic>
  802cd9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0d                	je     802cfa <insert_sorted_with_merge_freeList+0x344>
  802ced:	a1 38 41 80 00       	mov    0x804138,%eax
  802cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf5:	89 50 04             	mov    %edx,0x4(%eax)
  802cf8:	eb 08                	jmp    802d02 <insert_sorted_with_merge_freeList+0x34c>
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	a3 38 41 80 00       	mov    %eax,0x804138
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d14:	a1 44 41 80 00       	mov    0x804144,%eax
  802d19:	40                   	inc    %eax
  802d1a:	a3 44 41 80 00       	mov    %eax,0x804144
  802d1f:	e9 9f 04 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802d24:	a1 38 41 80 00       	mov    0x804138,%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802d2e:	e9 84 04 00 00       	jmp    8031b7 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 50 08             	mov    0x8(%eax),%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	39 c2                	cmp    %eax,%edx
  802d41:	0f 86 a9 00 00 00    	jbe    802df0 <insert_sorted_with_merge_freeList+0x43a>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 50 08             	mov    0x8(%eax),%edx
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	8b 48 08             	mov    0x8(%eax),%ecx
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	01 c8                	add    %ecx,%eax
  802d5b:	39 c2                	cmp    %eax,%edx
  802d5d:	0f 84 8d 00 00 00    	je     802df0 <insert_sorted_with_merge_freeList+0x43a>
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	8b 48 08             	mov    0x8(%eax),%ecx
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 04             	mov    0x4(%eax),%eax
  802d78:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7b:	01 c8                	add    %ecx,%eax
  802d7d:	39 c2                	cmp    %eax,%edx
  802d7f:	74 6f                	je     802df0 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d85:	74 06                	je     802d8d <insert_sorted_with_merge_freeList+0x3d7>
  802d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8b:	75 17                	jne    802da4 <insert_sorted_with_merge_freeList+0x3ee>
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	68 90 3e 80 00       	push   $0x803e90
  802d95:	68 6b 01 00 00       	push   $0x16b
  802d9a:	68 53 3e 80 00       	push   $0x803e53
  802d9f:	e8 50 d6 ff ff       	call   8003f4 <_panic>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 50 04             	mov    0x4(%eax),%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	89 50 04             	mov    %edx,0x4(%eax)
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 0d                	je     802dcf <insert_sorted_with_merge_freeList+0x419>
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcb:	89 10                	mov    %edx,(%eax)
  802dcd:	eb 08                	jmp    802dd7 <insert_sorted_with_merge_freeList+0x421>
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	a3 38 41 80 00       	mov    %eax,0x804138
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddd:	89 50 04             	mov    %edx,0x4(%eax)
  802de0:	a1 44 41 80 00       	mov    0x804144,%eax
  802de5:	40                   	inc    %eax
  802de6:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802deb:	e9 d3 03 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 50 08             	mov    0x8(%eax),%edx
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	8b 40 08             	mov    0x8(%eax),%eax
  802dfc:	39 c2                	cmp    %eax,%edx
  802dfe:	0f 86 da 00 00 00    	jbe    802ede <insert_sorted_with_merge_freeList+0x528>
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 50 08             	mov    0x8(%eax),%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 48 08             	mov    0x8(%eax),%ecx
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	8b 40 0c             	mov    0xc(%eax),%eax
  802e16:	01 c8                	add    %ecx,%eax
  802e18:	39 c2                	cmp    %eax,%edx
  802e1a:	0f 85 be 00 00 00    	jne    802ede <insert_sorted_with_merge_freeList+0x528>
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 50 08             	mov    0x8(%eax),%edx
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 40 04             	mov    0x4(%eax),%eax
  802e2c:	8b 48 08             	mov    0x8(%eax),%ecx
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 04             	mov    0x4(%eax),%eax
  802e35:	8b 40 0c             	mov    0xc(%eax),%eax
  802e38:	01 c8                	add    %ecx,%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	0f 84 9c 00 00 00    	je     802ede <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	8b 50 0c             	mov    0xc(%eax),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	01 c2                	add    %eax,%edx
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7a:	75 17                	jne    802e93 <insert_sorted_with_merge_freeList+0x4dd>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 30 3e 80 00       	push   $0x803e30
  802e84:	68 74 01 00 00       	push   $0x174
  802e89:	68 53 3e 80 00       	push   $0x803e53
  802e8e:	e8 61 d5 ff ff       	call   8003f4 <_panic>
  802e93:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <insert_sorted_with_merge_freeList+0x4fe>
  802ea7:	a1 48 41 80 00       	mov    0x804148,%eax
  802eac:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x506>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802ed9:	e9 e5 02 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 50 08             	mov    0x8(%eax),%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 40 08             	mov    0x8(%eax),%eax
  802eea:	39 c2                	cmp    %eax,%edx
  802eec:	0f 86 d7 00 00 00    	jbe    802fc9 <insert_sorted_with_merge_freeList+0x613>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 50 08             	mov    0x8(%eax),%edx
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 48 08             	mov    0x8(%eax),%ecx
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	8b 40 0c             	mov    0xc(%eax),%eax
  802f04:	01 c8                	add    %ecx,%eax
  802f06:	39 c2                	cmp    %eax,%edx
  802f08:	0f 84 bb 00 00 00    	je     802fc9 <insert_sorted_with_merge_freeList+0x613>
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	8b 48 08             	mov    0x8(%eax),%ecx
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	8b 40 0c             	mov    0xc(%eax),%eax
  802f26:	01 c8                	add    %ecx,%eax
  802f28:	39 c2                	cmp    %eax,%edx
  802f2a:	0f 85 99 00 00 00    	jne    802fc9 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	8b 40 0c             	mov    0xc(%eax),%eax
  802f45:	01 c2                	add    %eax,%edx
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f65:	75 17                	jne    802f7e <insert_sorted_with_merge_freeList+0x5c8>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 30 3e 80 00       	push   $0x803e30
  802f6f:	68 7d 01 00 00       	push   $0x17d
  802f74:	68 53 3e 80 00       	push   $0x803e53
  802f79:	e8 76 d4 ff ff       	call   8003f4 <_panic>
  802f7e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	89 10                	mov    %edx,(%eax)
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	74 0d                	je     802f9f <insert_sorted_with_merge_freeList+0x5e9>
  802f92:	a1 48 41 80 00       	mov    0x804148,%eax
  802f97:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	eb 08                	jmp    802fa7 <insert_sorted_with_merge_freeList+0x5f1>
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	a3 48 41 80 00       	mov    %eax,0x804148
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fbe:	40                   	inc    %eax
  802fbf:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802fc4:	e9 fa 01 00 00       	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 50 08             	mov    0x8(%eax),%edx
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	8b 40 08             	mov    0x8(%eax),%eax
  802fd5:	39 c2                	cmp    %eax,%edx
  802fd7:	0f 86 d2 01 00 00    	jbe    8031af <insert_sorted_with_merge_freeList+0x7f9>
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 50 08             	mov    0x8(%eax),%edx
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 48 08             	mov    0x8(%eax),%ecx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	01 c8                	add    %ecx,%eax
  802ff1:	39 c2                	cmp    %eax,%edx
  802ff3:	0f 85 b6 01 00 00    	jne    8031af <insert_sorted_with_merge_freeList+0x7f9>
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 50 08             	mov    0x8(%eax),%edx
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	8b 48 08             	mov    0x8(%eax),%ecx
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	8b 40 0c             	mov    0xc(%eax),%eax
  803011:	01 c8                	add    %ecx,%eax
  803013:	39 c2                	cmp    %eax,%edx
  803015:	0f 85 94 01 00 00    	jne    8031af <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803024:	8b 52 04             	mov    0x4(%edx),%edx
  803027:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803033:	8b 52 0c             	mov    0xc(%edx),%edx
  803036:	01 da                	add    %ebx,%edx
  803038:	01 ca                	add    %ecx,%edx
  80303a:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803055:	75 17                	jne    80306e <insert_sorted_with_merge_freeList+0x6b8>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 c5 3e 80 00       	push   $0x803ec5
  80305f:	68 86 01 00 00       	push   $0x186
  803064:	68 53 3e 80 00       	push   $0x803e53
  803069:	e8 86 d3 ff ff       	call   8003f4 <_panic>
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 10                	je     803087 <insert_sorted_with_merge_freeList+0x6d1>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307f:	8b 52 04             	mov    0x4(%edx),%edx
  803082:	89 50 04             	mov    %edx,0x4(%eax)
  803085:	eb 0b                	jmp    803092 <insert_sorted_with_merge_freeList+0x6dc>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 0f                	je     8030ab <insert_sorted_with_merge_freeList+0x6f5>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a5:	8b 12                	mov    (%edx),%edx
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	eb 0a                	jmp    8030b5 <insert_sorted_with_merge_freeList+0x6ff>
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	a3 38 41 80 00       	mov    %eax,0x804138
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c8:	a1 44 41 80 00       	mov    0x804144,%eax
  8030cd:	48                   	dec    %eax
  8030ce:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8030d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d7:	75 17                	jne    8030f0 <insert_sorted_with_merge_freeList+0x73a>
  8030d9:	83 ec 04             	sub    $0x4,%esp
  8030dc:	68 30 3e 80 00       	push   $0x803e30
  8030e1:	68 87 01 00 00       	push   $0x187
  8030e6:	68 53 3e 80 00       	push   $0x803e53
  8030eb:	e8 04 d3 ff ff       	call   8003f4 <_panic>
  8030f0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	89 10                	mov    %edx,(%eax)
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 0d                	je     803111 <insert_sorted_with_merge_freeList+0x75b>
  803104:	a1 48 41 80 00       	mov    0x804148,%eax
  803109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310c:	89 50 04             	mov    %edx,0x4(%eax)
  80310f:	eb 08                	jmp    803119 <insert_sorted_with_merge_freeList+0x763>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	a3 48 41 80 00       	mov    %eax,0x804148
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312b:	a1 54 41 80 00       	mov    0x804154,%eax
  803130:	40                   	inc    %eax
  803131:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80314a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314e:	75 17                	jne    803167 <insert_sorted_with_merge_freeList+0x7b1>
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	68 30 3e 80 00       	push   $0x803e30
  803158:	68 8a 01 00 00       	push   $0x18a
  80315d:	68 53 3e 80 00       	push   $0x803e53
  803162:	e8 8d d2 ff ff       	call   8003f4 <_panic>
  803167:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	89 10                	mov    %edx,(%eax)
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	85 c0                	test   %eax,%eax
  803179:	74 0d                	je     803188 <insert_sorted_with_merge_freeList+0x7d2>
  80317b:	a1 48 41 80 00       	mov    0x804148,%eax
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	eb 08                	jmp    803190 <insert_sorted_with_merge_freeList+0x7da>
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	a3 48 41 80 00       	mov    %eax,0x804148
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a2:	a1 54 41 80 00       	mov    0x804154,%eax
  8031a7:	40                   	inc    %eax
  8031a8:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  8031ad:	eb 14                	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8031b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bb:	0f 85 72 fb ff ff    	jne    802d33 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8031c1:	eb 00                	jmp    8031c3 <insert_sorted_with_merge_freeList+0x80d>
  8031c3:	90                   	nop
  8031c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c7:	c9                   	leave  
  8031c8:	c3                   	ret    
  8031c9:	66 90                	xchg   %ax,%ax
  8031cb:	90                   	nop

008031cc <__udivdi3>:
  8031cc:	55                   	push   %ebp
  8031cd:	57                   	push   %edi
  8031ce:	56                   	push   %esi
  8031cf:	53                   	push   %ebx
  8031d0:	83 ec 1c             	sub    $0x1c,%esp
  8031d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031e3:	89 ca                	mov    %ecx,%edx
  8031e5:	89 f8                	mov    %edi,%eax
  8031e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031eb:	85 f6                	test   %esi,%esi
  8031ed:	75 2d                	jne    80321c <__udivdi3+0x50>
  8031ef:	39 cf                	cmp    %ecx,%edi
  8031f1:	77 65                	ja     803258 <__udivdi3+0x8c>
  8031f3:	89 fd                	mov    %edi,%ebp
  8031f5:	85 ff                	test   %edi,%edi
  8031f7:	75 0b                	jne    803204 <__udivdi3+0x38>
  8031f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031fe:	31 d2                	xor    %edx,%edx
  803200:	f7 f7                	div    %edi
  803202:	89 c5                	mov    %eax,%ebp
  803204:	31 d2                	xor    %edx,%edx
  803206:	89 c8                	mov    %ecx,%eax
  803208:	f7 f5                	div    %ebp
  80320a:	89 c1                	mov    %eax,%ecx
  80320c:	89 d8                	mov    %ebx,%eax
  80320e:	f7 f5                	div    %ebp
  803210:	89 cf                	mov    %ecx,%edi
  803212:	89 fa                	mov    %edi,%edx
  803214:	83 c4 1c             	add    $0x1c,%esp
  803217:	5b                   	pop    %ebx
  803218:	5e                   	pop    %esi
  803219:	5f                   	pop    %edi
  80321a:	5d                   	pop    %ebp
  80321b:	c3                   	ret    
  80321c:	39 ce                	cmp    %ecx,%esi
  80321e:	77 28                	ja     803248 <__udivdi3+0x7c>
  803220:	0f bd fe             	bsr    %esi,%edi
  803223:	83 f7 1f             	xor    $0x1f,%edi
  803226:	75 40                	jne    803268 <__udivdi3+0x9c>
  803228:	39 ce                	cmp    %ecx,%esi
  80322a:	72 0a                	jb     803236 <__udivdi3+0x6a>
  80322c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803230:	0f 87 9e 00 00 00    	ja     8032d4 <__udivdi3+0x108>
  803236:	b8 01 00 00 00       	mov    $0x1,%eax
  80323b:	89 fa                	mov    %edi,%edx
  80323d:	83 c4 1c             	add    $0x1c,%esp
  803240:	5b                   	pop    %ebx
  803241:	5e                   	pop    %esi
  803242:	5f                   	pop    %edi
  803243:	5d                   	pop    %ebp
  803244:	c3                   	ret    
  803245:	8d 76 00             	lea    0x0(%esi),%esi
  803248:	31 ff                	xor    %edi,%edi
  80324a:	31 c0                	xor    %eax,%eax
  80324c:	89 fa                	mov    %edi,%edx
  80324e:	83 c4 1c             	add    $0x1c,%esp
  803251:	5b                   	pop    %ebx
  803252:	5e                   	pop    %esi
  803253:	5f                   	pop    %edi
  803254:	5d                   	pop    %ebp
  803255:	c3                   	ret    
  803256:	66 90                	xchg   %ax,%ax
  803258:	89 d8                	mov    %ebx,%eax
  80325a:	f7 f7                	div    %edi
  80325c:	31 ff                	xor    %edi,%edi
  80325e:	89 fa                	mov    %edi,%edx
  803260:	83 c4 1c             	add    $0x1c,%esp
  803263:	5b                   	pop    %ebx
  803264:	5e                   	pop    %esi
  803265:	5f                   	pop    %edi
  803266:	5d                   	pop    %ebp
  803267:	c3                   	ret    
  803268:	bd 20 00 00 00       	mov    $0x20,%ebp
  80326d:	89 eb                	mov    %ebp,%ebx
  80326f:	29 fb                	sub    %edi,%ebx
  803271:	89 f9                	mov    %edi,%ecx
  803273:	d3 e6                	shl    %cl,%esi
  803275:	89 c5                	mov    %eax,%ebp
  803277:	88 d9                	mov    %bl,%cl
  803279:	d3 ed                	shr    %cl,%ebp
  80327b:	89 e9                	mov    %ebp,%ecx
  80327d:	09 f1                	or     %esi,%ecx
  80327f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803283:	89 f9                	mov    %edi,%ecx
  803285:	d3 e0                	shl    %cl,%eax
  803287:	89 c5                	mov    %eax,%ebp
  803289:	89 d6                	mov    %edx,%esi
  80328b:	88 d9                	mov    %bl,%cl
  80328d:	d3 ee                	shr    %cl,%esi
  80328f:	89 f9                	mov    %edi,%ecx
  803291:	d3 e2                	shl    %cl,%edx
  803293:	8b 44 24 08          	mov    0x8(%esp),%eax
  803297:	88 d9                	mov    %bl,%cl
  803299:	d3 e8                	shr    %cl,%eax
  80329b:	09 c2                	or     %eax,%edx
  80329d:	89 d0                	mov    %edx,%eax
  80329f:	89 f2                	mov    %esi,%edx
  8032a1:	f7 74 24 0c          	divl   0xc(%esp)
  8032a5:	89 d6                	mov    %edx,%esi
  8032a7:	89 c3                	mov    %eax,%ebx
  8032a9:	f7 e5                	mul    %ebp
  8032ab:	39 d6                	cmp    %edx,%esi
  8032ad:	72 19                	jb     8032c8 <__udivdi3+0xfc>
  8032af:	74 0b                	je     8032bc <__udivdi3+0xf0>
  8032b1:	89 d8                	mov    %ebx,%eax
  8032b3:	31 ff                	xor    %edi,%edi
  8032b5:	e9 58 ff ff ff       	jmp    803212 <__udivdi3+0x46>
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032c0:	89 f9                	mov    %edi,%ecx
  8032c2:	d3 e2                	shl    %cl,%edx
  8032c4:	39 c2                	cmp    %eax,%edx
  8032c6:	73 e9                	jae    8032b1 <__udivdi3+0xe5>
  8032c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032cb:	31 ff                	xor    %edi,%edi
  8032cd:	e9 40 ff ff ff       	jmp    803212 <__udivdi3+0x46>
  8032d2:	66 90                	xchg   %ax,%ax
  8032d4:	31 c0                	xor    %eax,%eax
  8032d6:	e9 37 ff ff ff       	jmp    803212 <__udivdi3+0x46>
  8032db:	90                   	nop

008032dc <__umoddi3>:
  8032dc:	55                   	push   %ebp
  8032dd:	57                   	push   %edi
  8032de:	56                   	push   %esi
  8032df:	53                   	push   %ebx
  8032e0:	83 ec 1c             	sub    $0x1c,%esp
  8032e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032fb:	89 f3                	mov    %esi,%ebx
  8032fd:	89 fa                	mov    %edi,%edx
  8032ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803303:	89 34 24             	mov    %esi,(%esp)
  803306:	85 c0                	test   %eax,%eax
  803308:	75 1a                	jne    803324 <__umoddi3+0x48>
  80330a:	39 f7                	cmp    %esi,%edi
  80330c:	0f 86 a2 00 00 00    	jbe    8033b4 <__umoddi3+0xd8>
  803312:	89 c8                	mov    %ecx,%eax
  803314:	89 f2                	mov    %esi,%edx
  803316:	f7 f7                	div    %edi
  803318:	89 d0                	mov    %edx,%eax
  80331a:	31 d2                	xor    %edx,%edx
  80331c:	83 c4 1c             	add    $0x1c,%esp
  80331f:	5b                   	pop    %ebx
  803320:	5e                   	pop    %esi
  803321:	5f                   	pop    %edi
  803322:	5d                   	pop    %ebp
  803323:	c3                   	ret    
  803324:	39 f0                	cmp    %esi,%eax
  803326:	0f 87 ac 00 00 00    	ja     8033d8 <__umoddi3+0xfc>
  80332c:	0f bd e8             	bsr    %eax,%ebp
  80332f:	83 f5 1f             	xor    $0x1f,%ebp
  803332:	0f 84 ac 00 00 00    	je     8033e4 <__umoddi3+0x108>
  803338:	bf 20 00 00 00       	mov    $0x20,%edi
  80333d:	29 ef                	sub    %ebp,%edi
  80333f:	89 fe                	mov    %edi,%esi
  803341:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803345:	89 e9                	mov    %ebp,%ecx
  803347:	d3 e0                	shl    %cl,%eax
  803349:	89 d7                	mov    %edx,%edi
  80334b:	89 f1                	mov    %esi,%ecx
  80334d:	d3 ef                	shr    %cl,%edi
  80334f:	09 c7                	or     %eax,%edi
  803351:	89 e9                	mov    %ebp,%ecx
  803353:	d3 e2                	shl    %cl,%edx
  803355:	89 14 24             	mov    %edx,(%esp)
  803358:	89 d8                	mov    %ebx,%eax
  80335a:	d3 e0                	shl    %cl,%eax
  80335c:	89 c2                	mov    %eax,%edx
  80335e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803362:	d3 e0                	shl    %cl,%eax
  803364:	89 44 24 04          	mov    %eax,0x4(%esp)
  803368:	8b 44 24 08          	mov    0x8(%esp),%eax
  80336c:	89 f1                	mov    %esi,%ecx
  80336e:	d3 e8                	shr    %cl,%eax
  803370:	09 d0                	or     %edx,%eax
  803372:	d3 eb                	shr    %cl,%ebx
  803374:	89 da                	mov    %ebx,%edx
  803376:	f7 f7                	div    %edi
  803378:	89 d3                	mov    %edx,%ebx
  80337a:	f7 24 24             	mull   (%esp)
  80337d:	89 c6                	mov    %eax,%esi
  80337f:	89 d1                	mov    %edx,%ecx
  803381:	39 d3                	cmp    %edx,%ebx
  803383:	0f 82 87 00 00 00    	jb     803410 <__umoddi3+0x134>
  803389:	0f 84 91 00 00 00    	je     803420 <__umoddi3+0x144>
  80338f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803393:	29 f2                	sub    %esi,%edx
  803395:	19 cb                	sbb    %ecx,%ebx
  803397:	89 d8                	mov    %ebx,%eax
  803399:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80339d:	d3 e0                	shl    %cl,%eax
  80339f:	89 e9                	mov    %ebp,%ecx
  8033a1:	d3 ea                	shr    %cl,%edx
  8033a3:	09 d0                	or     %edx,%eax
  8033a5:	89 e9                	mov    %ebp,%ecx
  8033a7:	d3 eb                	shr    %cl,%ebx
  8033a9:	89 da                	mov    %ebx,%edx
  8033ab:	83 c4 1c             	add    $0x1c,%esp
  8033ae:	5b                   	pop    %ebx
  8033af:	5e                   	pop    %esi
  8033b0:	5f                   	pop    %edi
  8033b1:	5d                   	pop    %ebp
  8033b2:	c3                   	ret    
  8033b3:	90                   	nop
  8033b4:	89 fd                	mov    %edi,%ebp
  8033b6:	85 ff                	test   %edi,%edi
  8033b8:	75 0b                	jne    8033c5 <__umoddi3+0xe9>
  8033ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8033bf:	31 d2                	xor    %edx,%edx
  8033c1:	f7 f7                	div    %edi
  8033c3:	89 c5                	mov    %eax,%ebp
  8033c5:	89 f0                	mov    %esi,%eax
  8033c7:	31 d2                	xor    %edx,%edx
  8033c9:	f7 f5                	div    %ebp
  8033cb:	89 c8                	mov    %ecx,%eax
  8033cd:	f7 f5                	div    %ebp
  8033cf:	89 d0                	mov    %edx,%eax
  8033d1:	e9 44 ff ff ff       	jmp    80331a <__umoddi3+0x3e>
  8033d6:	66 90                	xchg   %ax,%ax
  8033d8:	89 c8                	mov    %ecx,%eax
  8033da:	89 f2                	mov    %esi,%edx
  8033dc:	83 c4 1c             	add    $0x1c,%esp
  8033df:	5b                   	pop    %ebx
  8033e0:	5e                   	pop    %esi
  8033e1:	5f                   	pop    %edi
  8033e2:	5d                   	pop    %ebp
  8033e3:	c3                   	ret    
  8033e4:	3b 04 24             	cmp    (%esp),%eax
  8033e7:	72 06                	jb     8033ef <__umoddi3+0x113>
  8033e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033ed:	77 0f                	ja     8033fe <__umoddi3+0x122>
  8033ef:	89 f2                	mov    %esi,%edx
  8033f1:	29 f9                	sub    %edi,%ecx
  8033f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033f7:	89 14 24             	mov    %edx,(%esp)
  8033fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803402:	8b 14 24             	mov    (%esp),%edx
  803405:	83 c4 1c             	add    $0x1c,%esp
  803408:	5b                   	pop    %ebx
  803409:	5e                   	pop    %esi
  80340a:	5f                   	pop    %edi
  80340b:	5d                   	pop    %ebp
  80340c:	c3                   	ret    
  80340d:	8d 76 00             	lea    0x0(%esi),%esi
  803410:	2b 04 24             	sub    (%esp),%eax
  803413:	19 fa                	sbb    %edi,%edx
  803415:	89 d1                	mov    %edx,%ecx
  803417:	89 c6                	mov    %eax,%esi
  803419:	e9 71 ff ff ff       	jmp    80338f <__umoddi3+0xb3>
  80341e:	66 90                	xchg   %ax,%ax
  803420:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803424:	72 ea                	jb     803410 <__umoddi3+0x134>
  803426:	89 d9                	mov    %ebx,%ecx
  803428:	e9 62 ff ff ff       	jmp    80338f <__umoddi3+0xb3>
