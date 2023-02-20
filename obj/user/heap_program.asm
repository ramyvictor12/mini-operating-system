
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
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
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 17 15 00 00       	call   801582 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 06 15 00 00       	call   801582 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 ff 19 00 00       	call   801a86 <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 1c 15 00 00       	call   80160d <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 0e 15 00 00       	call   80160d <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 df 18 00 00       	call   8019e6 <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 6d 14 00 00       	call   801582 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb bc 34 80 00       	mov    $0x8034bc,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 c0 33 80 00       	push   $0x8033c0
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 21 34 80 00       	push   $0x803421
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 e9 17 00 00       	call   8019e6 <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 d8 17 00 00       	call   8019e6 <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 38 34 80 00       	push   $0x803438
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 21 34 80 00       	push   $0x803421
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 7c 34 80 00       	push   $0x80347c
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 79 1a 00 00       	call   801cc6 <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 1b 18 00 00       	call   801ad3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 f0 34 80 00       	push   $0x8034f0
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 18 35 80 00       	push   $0x803518
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 40 35 80 00       	push   $0x803540
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 98 35 80 00       	push   $0x803598
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 f0 34 80 00       	push   $0x8034f0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 9b 17 00 00       	call   801aed <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 28 19 00 00       	call   801c92 <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 7d 19 00 00       	call   801cf8 <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 ac 35 80 00       	push   $0x8035ac
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 b1 35 80 00       	push   $0x8035b1
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 cd 35 80 00       	push   $0x8035cd
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 d0 35 80 00       	push   $0x8035d0
  80040d:	6a 26                	push   $0x26
  80040f:	68 1c 36 80 00       	push   $0x80361c
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 28 36 80 00       	push   $0x803628
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 1c 36 80 00       	push   $0x80361c
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 7c 36 80 00       	push   $0x80367c
  80054f:	6a 44                	push   $0x44
  800551:	68 1c 36 80 00       	push   $0x80361c
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 40 80 00       	mov    0x804024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 7c 13 00 00       	call   801925 <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 05 13 00 00       	call   801925 <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 69 14 00 00       	call   801ad3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 63 14 00 00       	call   801aed <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 80 2a 00 00       	call   803154 <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 40 2b 00 00       	call   803264 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 f4 38 80 00       	add    $0x8038f4,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 05 39 80 00       	push   $0x803905
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 0e 39 80 00       	push   $0x80390e
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 70 3a 80 00       	push   $0x803a70
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8013f3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013fa:	00 00 00 
  8013fd:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801404:	00 00 00 
  801407:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80140e:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801411:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801418:	00 00 00 
  80141b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801422:	00 00 00 
  801425:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80142c:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80142f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801436:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801439:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801440:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80144f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801454:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801459:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801463:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801468:	2d 00 10 00 00       	sub    $0x1000,%eax
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	6a 06                	push   $0x6
  801472:	ff 75 f4             	pushl  -0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	e8 ee 05 00 00       	call   801a69 <sys_allocate_chunk>
  80147b:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80147e:	a1 20 41 80 00       	mov    0x804120,%eax
  801483:	83 ec 0c             	sub    $0xc,%esp
  801486:	50                   	push   %eax
  801487:	e8 63 0c 00 00       	call   8020ef <initialize_MemBlocksList>
  80148c:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80148f:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801494:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8014a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b7:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8014ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014bd:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8014c4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ce:	8b 50 08             	mov    0x8(%eax),%edx
  8014d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d4:	01 d0                	add    %edx,%eax
  8014d6:	48                   	dec    %eax
  8014d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e2:	f7 75 e0             	divl   -0x20(%ebp)
  8014e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e8:	29 d0                	sub    %edx,%eax
  8014ea:	89 c2                	mov    %eax,%edx
  8014ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ef:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8014f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014f6:	75 14                	jne    80150c <initialize_dyn_block_system+0x11f>
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	68 95 3a 80 00       	push   $0x803a95
  801500:	6a 34                	push   $0x34
  801502:	68 b3 3a 80 00       	push   $0x803ab3
  801507:	e8 72 ee ff ff       	call   80037e <_panic>
  80150c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150f:	8b 00                	mov    (%eax),%eax
  801511:	85 c0                	test   %eax,%eax
  801513:	74 10                	je     801525 <initialize_dyn_block_system+0x138>
  801515:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80151d:	8b 52 04             	mov    0x4(%edx),%edx
  801520:	89 50 04             	mov    %edx,0x4(%eax)
  801523:	eb 0b                	jmp    801530 <initialize_dyn_block_system+0x143>
  801525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801528:	8b 40 04             	mov    0x4(%eax),%eax
  80152b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801533:	8b 40 04             	mov    0x4(%eax),%eax
  801536:	85 c0                	test   %eax,%eax
  801538:	74 0f                	je     801549 <initialize_dyn_block_system+0x15c>
  80153a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153d:	8b 40 04             	mov    0x4(%eax),%eax
  801540:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801543:	8b 12                	mov    (%edx),%edx
  801545:	89 10                	mov    %edx,(%eax)
  801547:	eb 0a                	jmp    801553 <initialize_dyn_block_system+0x166>
  801549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	a3 48 41 80 00       	mov    %eax,0x804148
  801553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80155c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80155f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801566:	a1 54 41 80 00       	mov    0x804154,%eax
  80156b:	48                   	dec    %eax
  80156c:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	ff 75 e8             	pushl  -0x18(%ebp)
  801577:	e8 c4 13 00 00       	call   802940 <insert_sorted_with_merge_freeList>
  80157c:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80157f:	90                   	nop
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801588:	e8 2f fe ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  80158d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801591:	75 07                	jne    80159a <malloc+0x18>
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 71                	jmp    80160b <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80159a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015a1:	76 07                	jbe    8015aa <malloc+0x28>
	return NULL;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	eb 61                	jmp    80160b <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015aa:	e8 88 08 00 00       	call   801e37 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	74 53                	je     801606 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8015b3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	48                   	dec    %eax
  8015c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ce:	f7 75 f4             	divl   -0xc(%ebp)
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	29 d0                	sub    %edx,%eax
  8015d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8015df:	e8 d2 0d 00 00       	call   8023b6 <alloc_block_FF>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8015ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015ee:	74 16                	je     801606 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8015f0:	83 ec 0c             	sub    $0xc,%esp
  8015f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f6:	e8 0c 0c 00 00       	call   802207 <insert_sorted_allocList>
  8015fb:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8015fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801601:	8b 40 08             	mov    0x8(%eax),%eax
  801604:	eb 05                	jmp    80160b <malloc+0x89>
    }

			}


	return NULL;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801621:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	ff 75 f0             	pushl  -0x10(%ebp)
  80162a:	68 40 40 80 00       	push   $0x804040
  80162f:	e8 a0 0b 00 00       	call   8021d4 <find_block>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80163a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163d:	8b 50 0c             	mov    0xc(%eax),%edx
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	83 ec 08             	sub    $0x8,%esp
  801646:	52                   	push   %edx
  801647:	50                   	push   %eax
  801648:	e8 e4 03 00 00       	call   801a31 <sys_free_user_mem>
  80164d:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801650:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801654:	75 17                	jne    80166d <free+0x60>
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	68 95 3a 80 00       	push   $0x803a95
  80165e:	68 84 00 00 00       	push   $0x84
  801663:	68 b3 3a 80 00       	push   $0x803ab3
  801668:	e8 11 ed ff ff       	call   80037e <_panic>
  80166d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	85 c0                	test   %eax,%eax
  801674:	74 10                	je     801686 <free+0x79>
  801676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801679:	8b 00                	mov    (%eax),%eax
  80167b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80167e:	8b 52 04             	mov    0x4(%edx),%edx
  801681:	89 50 04             	mov    %edx,0x4(%eax)
  801684:	eb 0b                	jmp    801691 <free+0x84>
  801686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801689:	8b 40 04             	mov    0x4(%eax),%eax
  80168c:	a3 44 40 80 00       	mov    %eax,0x804044
  801691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801694:	8b 40 04             	mov    0x4(%eax),%eax
  801697:	85 c0                	test   %eax,%eax
  801699:	74 0f                	je     8016aa <free+0x9d>
  80169b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169e:	8b 40 04             	mov    0x4(%eax),%eax
  8016a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016a4:	8b 12                	mov    (%edx),%edx
  8016a6:	89 10                	mov    %edx,(%eax)
  8016a8:	eb 0a                	jmp    8016b4 <free+0xa7>
  8016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	a3 40 40 80 00       	mov    %eax,0x804040
  8016b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016cc:	48                   	dec    %eax
  8016cd:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d8:	e8 63 12 00 00       	call   802940 <insert_sorted_with_merge_freeList>
  8016dd:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8016e0:	90                   	nop
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 38             	sub    $0x38,%esp
  8016e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ec:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ef:	e8 c8 fc ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8016f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f8:	75 0a                	jne    801704 <smalloc+0x21>
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	e9 a0 00 00 00       	jmp    8017a4 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801704:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80170b:	76 0a                	jbe    801717 <smalloc+0x34>
		return NULL;
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax
  801712:	e9 8d 00 00 00       	jmp    8017a4 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801717:	e8 1b 07 00 00       	call   801e37 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171c:	85 c0                	test   %eax,%eax
  80171e:	74 7f                	je     80179f <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801720:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	48                   	dec    %eax
  801730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	ba 00 00 00 00       	mov    $0x0,%edx
  80173b:	f7 75 f4             	divl   -0xc(%ebp)
  80173e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801741:	29 d0                	sub    %edx,%eax
  801743:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	ff 75 ec             	pushl  -0x14(%ebp)
  80174c:	e8 65 0c 00 00       	call   8023b6 <alloc_block_FF>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801757:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80175b:	74 42                	je     80179f <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80175d:	83 ec 0c             	sub    $0xc,%esp
  801760:	ff 75 e8             	pushl  -0x18(%ebp)
  801763:	e8 9f 0a 00 00       	call   802207 <insert_sorted_allocList>
  801768:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80176b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80176e:	8b 40 08             	mov    0x8(%eax),%eax
  801771:	89 c2                	mov    %eax,%edx
  801773:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801777:	52                   	push   %edx
  801778:	50                   	push   %eax
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	e8 38 04 00 00       	call   801bbc <sys_createSharedObject>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80178a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80178e:	79 07                	jns    801797 <smalloc+0xb4>
	    		  return NULL;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 0d                	jmp    8017a4 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80179a:	8b 40 08             	mov    0x8(%eax),%eax
  80179d:	eb 05                	jmp    8017a4 <smalloc+0xc1>


				}


		return NULL;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ac:	e8 0b fc ff ff       	call   8013bc <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017b1:	e8 81 06 00 00       	call   801e37 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	0f 84 9f 00 00 00    	je     80185d <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017be:	83 ec 08             	sub    $0x8,%esp
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	e8 1a 04 00 00       	call   801be6 <sys_getSizeOfSharedObject>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8017d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017d6:	79 0a                	jns    8017e2 <sget+0x3c>
		return NULL;
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	e9 80 00 00 00       	jmp    801862 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8017e2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	48                   	dec    %eax
  8017f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fd:	f7 75 f0             	divl   -0x10(%ebp)
  801800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801803:	29 d0                	sub    %edx,%eax
  801805:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801808:	83 ec 0c             	sub    $0xc,%esp
  80180b:	ff 75 e8             	pushl  -0x18(%ebp)
  80180e:	e8 a3 0b 00 00       	call   8023b6 <alloc_block_FF>
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80181d:	74 3e                	je     80185d <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	ff 75 e4             	pushl  -0x1c(%ebp)
  801825:	e8 dd 09 00 00       	call   802207 <insert_sorted_allocList>
  80182a:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80182d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801830:	8b 40 08             	mov    0x8(%eax),%eax
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	50                   	push   %eax
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	e8 c1 03 00 00       	call   801c03 <sys_getSharedObject>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801848:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80184c:	79 07                	jns    801855 <sget+0xaf>
	    		  return NULL;
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	eb 0d                	jmp    801862 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801858:	8b 40 08             	mov    0x8(%eax),%eax
  80185b:	eb 05                	jmp    801862 <sget+0xbc>
	      }
	}
	   return NULL;
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80186a:	e8 4d fb ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	68 c0 3a 80 00       	push   $0x803ac0
  801877:	68 12 01 00 00       	push   $0x112
  80187c:	68 b3 3a 80 00       	push   $0x803ab3
  801881:	e8 f8 ea ff ff       	call   80037e <_panic>

00801886 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 e8 3a 80 00       	push   $0x803ae8
  801894:	68 26 01 00 00       	push   $0x126
  801899:	68 b3 3a 80 00       	push   $0x803ab3
  80189e:	e8 db ea ff ff       	call   80037e <_panic>

008018a3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	68 0c 3b 80 00       	push   $0x803b0c
  8018b1:	68 31 01 00 00       	push   $0x131
  8018b6:	68 b3 3a 80 00       	push   $0x803ab3
  8018bb:	e8 be ea ff ff       	call   80037e <_panic>

008018c0 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 0c 3b 80 00       	push   $0x803b0c
  8018ce:	68 36 01 00 00       	push   $0x136
  8018d3:	68 b3 3a 80 00       	push   $0x803ab3
  8018d8:	e8 a1 ea ff ff       	call   80037e <_panic>

008018dd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	68 0c 3b 80 00       	push   $0x803b0c
  8018eb:	68 3b 01 00 00       	push   $0x13b
  8018f0:	68 b3 3a 80 00       	push   $0x803ab3
  8018f5:	e8 84 ea ff ff       	call   80037e <_panic>

008018fa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	57                   	push   %edi
  8018fe:	56                   	push   %esi
  8018ff:	53                   	push   %ebx
  801900:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801912:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801915:	cd 30                	int    $0x30
  801917:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	5b                   	pop    %ebx
  801921:	5e                   	pop    %esi
  801922:	5f                   	pop    %edi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	8b 45 10             	mov    0x10(%ebp),%eax
  80192e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801931:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	ff 75 0c             	pushl  0xc(%ebp)
  801940:	50                   	push   %eax
  801941:	6a 00                	push   $0x0
  801943:	e8 b2 ff ff ff       	call   8018fa <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_cgetc>:

int
sys_cgetc(void)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 01                	push   $0x1
  80195d:	e8 98 ff ff ff       	call   8018fa <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 05                	push   $0x5
  80197a:	e8 7b ff ff ff       	call   8018fa <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801989:	8b 75 18             	mov    0x18(%ebp),%esi
  80198c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	56                   	push   %esi
  801999:	53                   	push   %ebx
  80199a:	51                   	push   %ecx
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 06                	push   $0x6
  80199f:	e8 56 ff ff ff       	call   8018fa <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019aa:	5b                   	pop    %ebx
  8019ab:	5e                   	pop    %esi
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    

008019ae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	52                   	push   %edx
  8019be:	50                   	push   %eax
  8019bf:	6a 07                	push   $0x7
  8019c1:	e8 34 ff ff ff       	call   8018fa <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	ff 75 08             	pushl  0x8(%ebp)
  8019da:	6a 08                	push   $0x8
  8019dc:	e8 19 ff ff ff       	call   8018fa <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 09                	push   $0x9
  8019f5:	e8 00 ff ff ff       	call   8018fa <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 0a                	push   $0xa
  801a0e:	e8 e7 fe ff ff       	call   8018fa <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 0b                	push   $0xb
  801a27:	e8 ce fe ff ff       	call   8018fa <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	6a 0f                	push   $0xf
  801a42:	e8 b3 fe ff ff       	call   8018fa <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
	return;
  801a4a:	90                   	nop
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	6a 10                	push   $0x10
  801a5e:	e8 97 fe ff ff       	call   8018fa <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return ;
  801a66:	90                   	nop
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 10             	pushl  0x10(%ebp)
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	ff 75 08             	pushl  0x8(%ebp)
  801a79:	6a 11                	push   $0x11
  801a7b:	e8 7a fe ff ff       	call   8018fa <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
	return ;
  801a83:	90                   	nop
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 0c                	push   $0xc
  801a95:	e8 60 fe ff ff       	call   8018fa <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	6a 0d                	push   $0xd
  801aaf:	e8 46 fe ff ff       	call   8018fa <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 0e                	push   $0xe
  801ac8:	e8 2d fe ff ff       	call   8018fa <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	90                   	nop
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 13                	push   $0x13
  801ae2:	e8 13 fe ff ff       	call   8018fa <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 14                	push   $0x14
  801afc:	e8 f9 fd ff ff       	call   8018fa <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	90                   	nop
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b13:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	50                   	push   %eax
  801b20:	6a 15                	push   $0x15
  801b22:	e8 d3 fd ff ff       	call   8018fa <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	90                   	nop
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 16                	push   $0x16
  801b3c:	e8 b9 fd ff ff       	call   8018fa <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	90                   	nop
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	50                   	push   %eax
  801b57:	6a 17                	push   $0x17
  801b59:	e8 9c fd ff ff       	call   8018fa <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 1a                	push   $0x1a
  801b76:	e8 7f fd ff ff       	call   8018fa <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 18                	push   $0x18
  801b93:	e8 62 fd ff ff       	call   8018fa <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	90                   	nop
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 19                	push   $0x19
  801bb1:	e8 44 fd ff ff       	call   8018fa <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	90                   	nop
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bc8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bcb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	51                   	push   %ecx
  801bd5:	52                   	push   %edx
  801bd6:	ff 75 0c             	pushl  0xc(%ebp)
  801bd9:	50                   	push   %eax
  801bda:	6a 1b                	push   $0x1b
  801bdc:	e8 19 fd ff ff       	call   8018fa <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 1c                	push   $0x1c
  801bf9:	e8 fc fc ff ff       	call   8018fa <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	51                   	push   %ecx
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 1d                	push   $0x1d
  801c18:	e8 dd fc ff ff       	call   8018fa <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	6a 1e                	push   $0x1e
  801c35:	e8 c0 fc ff ff       	call   8018fa <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 1f                	push   $0x1f
  801c4e:	e8 a7 fc ff ff       	call   8018fa <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	ff 75 14             	pushl  0x14(%ebp)
  801c63:	ff 75 10             	pushl  0x10(%ebp)
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	50                   	push   %eax
  801c6a:	6a 20                	push   $0x20
  801c6c:	e8 89 fc ff ff       	call   8018fa <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	50                   	push   %eax
  801c85:	6a 21                	push   $0x21
  801c87:	e8 6e fc ff ff       	call   8018fa <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	50                   	push   %eax
  801ca1:	6a 22                	push   $0x22
  801ca3:	e8 52 fc ff ff       	call   8018fa <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 02                	push   $0x2
  801cbc:	e8 39 fc ff ff       	call   8018fa <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 03                	push   $0x3
  801cd5:	e8 20 fc ff ff       	call   8018fa <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 04                	push   $0x4
  801cee:	e8 07 fc ff ff       	call   8018fa <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_exit_env>:


void sys_exit_env(void)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 23                	push   $0x23
  801d07:	e8 ee fb ff ff       	call   8018fa <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	90                   	nop
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1b:	8d 50 04             	lea    0x4(%eax),%edx
  801d1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 24                	push   $0x24
  801d2b:	e8 ca fb ff ff       	call   8018fa <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return result;
  801d33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d3c:	89 01                	mov    %eax,(%ecx)
  801d3e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	c9                   	leave  
  801d45:	c2 04 00             	ret    $0x4

00801d48 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	ff 75 10             	pushl  0x10(%ebp)
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	ff 75 08             	pushl  0x8(%ebp)
  801d58:	6a 12                	push   $0x12
  801d5a:	e8 9b fb ff ff       	call   8018fa <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d62:	90                   	nop
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 25                	push   $0x25
  801d74:	e8 81 fb ff ff       	call   8018fa <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d8a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	50                   	push   %eax
  801d97:	6a 26                	push   $0x26
  801d99:	e8 5c fb ff ff       	call   8018fa <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <rsttst>:
void rsttst()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 28                	push   $0x28
  801db3:	e8 42 fb ff ff       	call   8018fa <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbb:	90                   	nop
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dca:	8b 55 18             	mov    0x18(%ebp),%edx
  801dcd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd1:	52                   	push   %edx
  801dd2:	50                   	push   %eax
  801dd3:	ff 75 10             	pushl  0x10(%ebp)
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	ff 75 08             	pushl  0x8(%ebp)
  801ddc:	6a 27                	push   $0x27
  801dde:	e8 17 fb ff ff       	call   8018fa <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
	return ;
  801de6:	90                   	nop
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <chktst>:
void chktst(uint32 n)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	6a 29                	push   $0x29
  801df9:	e8 fc fa ff ff       	call   8018fa <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <inctst>:

void inctst()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 2a                	push   $0x2a
  801e13:	e8 e2 fa ff ff       	call   8018fa <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1b:	90                   	nop
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <gettst>:
uint32 gettst()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 2b                	push   $0x2b
  801e2d:	e8 c8 fa ff ff       	call   8018fa <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 2c                	push   $0x2c
  801e49:	e8 ac fa ff ff       	call   8018fa <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
  801e51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e54:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e58:	75 07                	jne    801e61 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5f:	eb 05                	jmp    801e66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 2c                	push   $0x2c
  801e7a:	e8 7b fa ff ff       	call   8018fa <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
  801e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e85:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e89:	75 07                	jne    801e92 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e90:	eb 05                	jmp    801e97 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 2c                	push   $0x2c
  801eab:	e8 4a fa ff ff       	call   8018fa <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
  801eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eba:	75 07                	jne    801ec3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec1:	eb 05                	jmp    801ec8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 2c                	push   $0x2c
  801edc:	e8 19 fa ff ff       	call   8018fa <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eeb:	75 07                	jne    801ef4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	eb 05                	jmp    801ef9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	6a 2d                	push   $0x2d
  801f0b:	e8 ea f9 ff ff       	call   8018fa <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
	return ;
  801f13:	90                   	nop
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	53                   	push   %ebx
  801f29:	51                   	push   %ecx
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	6a 2e                	push   $0x2e
  801f2e:	e8 c7 f9 ff ff       	call   8018fa <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
}
  801f36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	6a 2f                	push   $0x2f
  801f4e:	e8 a7 f9 ff ff       	call   8018fa <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	68 1c 3b 80 00       	push   $0x803b1c
  801f66:	e8 c7 e6 ff ff       	call   800632 <cprintf>
  801f6b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	68 48 3b 80 00       	push   $0x803b48
  801f7d:	e8 b0 e6 ff ff       	call   800632 <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f85:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f89:	a1 38 41 80 00       	mov    0x804138,%eax
  801f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f91:	eb 56                	jmp    801fe9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f97:	74 1c                	je     801fb5 <print_mem_block_lists+0x5d>
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 50 08             	mov    0x8(%eax),%edx
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fab:	01 c8                	add    %ecx,%eax
  801fad:	39 c2                	cmp    %eax,%edx
  801faf:	73 04                	jae    801fb5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fb1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 50 08             	mov    0x8(%eax),%edx
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc1:	01 c2                	add    %eax,%edx
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 40 08             	mov    0x8(%eax),%eax
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	52                   	push   %edx
  801fcd:	50                   	push   %eax
  801fce:	68 5d 3b 80 00       	push   $0x803b5d
  801fd3:	e8 5a e6 ff ff       	call   800632 <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe1:	a1 40 41 80 00       	mov    0x804140,%eax
  801fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fed:	74 07                	je     801ff6 <print_mem_block_lists+0x9e>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	eb 05                	jmp    801ffb <print_mem_block_lists+0xa3>
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	a3 40 41 80 00       	mov    %eax,0x804140
  802000:	a1 40 41 80 00       	mov    0x804140,%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	75 8a                	jne    801f93 <print_mem_block_lists+0x3b>
  802009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200d:	75 84                	jne    801f93 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80200f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802013:	75 10                	jne    802025 <print_mem_block_lists+0xcd>
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	68 6c 3b 80 00       	push   $0x803b6c
  80201d:	e8 10 e6 ff ff       	call   800632 <cprintf>
  802022:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	68 90 3b 80 00       	push   $0x803b90
  802034:	e8 f9 e5 ff ff       	call   800632 <cprintf>
  802039:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80203c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802040:	a1 40 40 80 00       	mov    0x804040,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	eb 56                	jmp    8020a0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80204a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204e:	74 1c                	je     80206c <print_mem_block_lists+0x114>
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 50 08             	mov    0x8(%eax),%edx
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	8b 48 08             	mov    0x8(%eax),%ecx
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	8b 40 0c             	mov    0xc(%eax),%eax
  802062:	01 c8                	add    %ecx,%eax
  802064:	39 c2                	cmp    %eax,%edx
  802066:	73 04                	jae    80206c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802068:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 50 08             	mov    0x8(%eax),%edx
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	8b 40 0c             	mov    0xc(%eax),%eax
  802078:	01 c2                	add    %eax,%edx
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 40 08             	mov    0x8(%eax),%eax
  802080:	83 ec 04             	sub    $0x4,%esp
  802083:	52                   	push   %edx
  802084:	50                   	push   %eax
  802085:	68 5d 3b 80 00       	push   $0x803b5d
  80208a:	e8 a3 e5 ff ff       	call   800632 <cprintf>
  80208f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802098:	a1 48 40 80 00       	mov    0x804048,%eax
  80209d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a4:	74 07                	je     8020ad <print_mem_block_lists+0x155>
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	8b 00                	mov    (%eax),%eax
  8020ab:	eb 05                	jmp    8020b2 <print_mem_block_lists+0x15a>
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	a3 48 40 80 00       	mov    %eax,0x804048
  8020b7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	75 8a                	jne    80204a <print_mem_block_lists+0xf2>
  8020c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c4:	75 84                	jne    80204a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020c6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ca:	75 10                	jne    8020dc <print_mem_block_lists+0x184>
  8020cc:	83 ec 0c             	sub    $0xc,%esp
  8020cf:	68 a8 3b 80 00       	push   $0x803ba8
  8020d4:	e8 59 e5 ff ff       	call   800632 <cprintf>
  8020d9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	68 1c 3b 80 00       	push   $0x803b1c
  8020e4:	e8 49 e5 ff ff       	call   800632 <cprintf>
  8020e9:	83 c4 10             	add    $0x10,%esp

}
  8020ec:	90                   	nop
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8020f5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020fc:	00 00 00 
  8020ff:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802106:	00 00 00 
  802109:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802110:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802113:	a1 50 40 80 00       	mov    0x804050,%eax
  802118:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80211b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802122:	e9 9e 00 00 00       	jmp    8021c5 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802127:	a1 50 40 80 00       	mov    0x804050,%eax
  80212c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212f:	c1 e2 04             	shl    $0x4,%edx
  802132:	01 d0                	add    %edx,%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	75 14                	jne    80214c <initialize_MemBlocksList+0x5d>
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 d0 3b 80 00       	push   $0x803bd0
  802140:	6a 48                	push   $0x48
  802142:	68 f3 3b 80 00       	push   $0x803bf3
  802147:	e8 32 e2 ff ff       	call   80037e <_panic>
  80214c:	a1 50 40 80 00       	mov    0x804050,%eax
  802151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802154:	c1 e2 04             	shl    $0x4,%edx
  802157:	01 d0                	add    %edx,%eax
  802159:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80215f:	89 10                	mov    %edx,(%eax)
  802161:	8b 00                	mov    (%eax),%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	74 18                	je     80217f <initialize_MemBlocksList+0x90>
  802167:	a1 48 41 80 00       	mov    0x804148,%eax
  80216c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802172:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802175:	c1 e1 04             	shl    $0x4,%ecx
  802178:	01 ca                	add    %ecx,%edx
  80217a:	89 50 04             	mov    %edx,0x4(%eax)
  80217d:	eb 12                	jmp    802191 <initialize_MemBlocksList+0xa2>
  80217f:	a1 50 40 80 00       	mov    0x804050,%eax
  802184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802187:	c1 e2 04             	shl    $0x4,%edx
  80218a:	01 d0                	add    %edx,%eax
  80218c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802191:	a1 50 40 80 00       	mov    0x804050,%eax
  802196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802199:	c1 e2 04             	shl    $0x4,%edx
  80219c:	01 d0                	add    %edx,%eax
  80219e:	a3 48 41 80 00       	mov    %eax,0x804148
  8021a3:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ab:	c1 e2 04             	shl    $0x4,%edx
  8021ae:	01 d0                	add    %edx,%eax
  8021b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8021bc:	40                   	inc    %eax
  8021bd:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8021c2:	ff 45 f4             	incl   -0xc(%ebp)
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021cb:	0f 82 56 ff ff ff    	jb     802127 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8021d1:	90                   	nop
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	8b 00                	mov    (%eax),%eax
  8021df:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8021e2:	eb 18                	jmp    8021fc <find_block+0x28>
		{
			if(tmp->sva==va)
  8021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021ed:	75 05                	jne    8021f4 <find_block+0x20>
			{
				return tmp;
  8021ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f2:	eb 11                	jmp    802205 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8021f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8021fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802200:	75 e2                	jne    8021e4 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802202:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80220d:	a1 40 40 80 00       	mov    0x804040,%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	0f 85 83 00 00 00    	jne    80229d <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80221a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802221:	00 00 00 
  802224:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80222b:	00 00 00 
  80222e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802235:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802238:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223c:	75 14                	jne    802252 <insert_sorted_allocList+0x4b>
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	68 d0 3b 80 00       	push   $0x803bd0
  802246:	6a 7f                	push   $0x7f
  802248:	68 f3 3b 80 00       	push   $0x803bf3
  80224d:	e8 2c e1 ff ff       	call   80037e <_panic>
  802252:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	89 10                	mov    %edx,(%eax)
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 0d                	je     802273 <insert_sorted_allocList+0x6c>
  802266:	a1 40 40 80 00       	mov    0x804040,%eax
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	89 50 04             	mov    %edx,0x4(%eax)
  802271:	eb 08                	jmp    80227b <insert_sorted_allocList+0x74>
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 44 40 80 00       	mov    %eax,0x804044
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	a3 40 40 80 00       	mov    %eax,0x804040
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802292:	40                   	inc    %eax
  802293:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802298:	e9 16 01 00 00       	jmp    8023b3 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8b 50 08             	mov    0x8(%eax),%edx
  8022a3:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a8:	8b 40 08             	mov    0x8(%eax),%eax
  8022ab:	39 c2                	cmp    %eax,%edx
  8022ad:	76 68                	jbe    802317 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8022af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b3:	75 17                	jne    8022cc <insert_sorted_allocList+0xc5>
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	68 0c 3c 80 00       	push   $0x803c0c
  8022bd:	68 85 00 00 00       	push   $0x85
  8022c2:	68 f3 3b 80 00       	push   $0x803bf3
  8022c7:	e8 b2 e0 ff ff       	call   80037e <_panic>
  8022cc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 0c                	je     8022ee <insert_sorted_allocList+0xe7>
  8022e2:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ea:	89 10                	mov    %edx,(%eax)
  8022ec:	eb 08                	jmp    8022f6 <insert_sorted_allocList+0xef>
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	a3 44 40 80 00       	mov    %eax,0x804044
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802307:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80230c:	40                   	inc    %eax
  80230d:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802312:	e9 9c 00 00 00       	jmp    8023b3 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802317:	a1 40 40 80 00       	mov    0x804040,%eax
  80231c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80231f:	e9 85 00 00 00       	jmp    8023a9 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8b 50 08             	mov    0x8(%eax),%edx
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 40 08             	mov    0x8(%eax),%eax
  802330:	39 c2                	cmp    %eax,%edx
  802332:	73 6d                	jae    8023a1 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802338:	74 06                	je     802340 <insert_sorted_allocList+0x139>
  80233a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233e:	75 17                	jne    802357 <insert_sorted_allocList+0x150>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 30 3c 80 00       	push   $0x803c30
  802348:	68 90 00 00 00       	push   $0x90
  80234d:	68 f3 3b 80 00       	push   $0x803bf3
  802352:	e8 27 e0 ff ff       	call   80037e <_panic>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 50 04             	mov    0x4(%eax),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 40 04             	mov    0x4(%eax),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	74 0d                	je     802382 <insert_sorted_allocList+0x17b>
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 40 04             	mov    0x4(%eax),%eax
  80237b:	8b 55 08             	mov    0x8(%ebp),%edx
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	eb 08                	jmp    80238a <insert_sorted_allocList+0x183>
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 40 40 80 00       	mov    %eax,0x804040
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 55 08             	mov    0x8(%ebp),%edx
  802390:	89 50 04             	mov    %edx,0x4(%eax)
  802393:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802398:	40                   	inc    %eax
  802399:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80239e:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80239f:	eb 12                	jmp    8023b3 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8023a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ad:	0f 85 71 ff ff ff    	jne    802324 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023b3:	90                   	nop
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8023bc:	a1 38 41 80 00       	mov    0x804138,%eax
  8023c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8023c4:	e9 76 01 00 00       	jmp    80253f <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d2:	0f 85 8a 00 00 00    	jne    802462 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8023d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dc:	75 17                	jne    8023f5 <alloc_block_FF+0x3f>
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	68 65 3c 80 00       	push   $0x803c65
  8023e6:	68 a8 00 00 00       	push   $0xa8
  8023eb:	68 f3 3b 80 00       	push   $0x803bf3
  8023f0:	e8 89 df ff ff       	call   80037e <_panic>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 10                	je     80240e <alloc_block_FF+0x58>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802406:	8b 52 04             	mov    0x4(%edx),%edx
  802409:	89 50 04             	mov    %edx,0x4(%eax)
  80240c:	eb 0b                	jmp    802419 <alloc_block_FF+0x63>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 40 04             	mov    0x4(%eax),%eax
  802414:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 0f                	je     802432 <alloc_block_FF+0x7c>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 04             	mov    0x4(%eax),%eax
  802429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242c:	8b 12                	mov    (%edx),%edx
  80242e:	89 10                	mov    %edx,(%eax)
  802430:	eb 0a                	jmp    80243c <alloc_block_FF+0x86>
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	a3 38 41 80 00       	mov    %eax,0x804138
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244f:	a1 44 41 80 00       	mov    0x804144,%eax
  802454:	48                   	dec    %eax
  802455:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	e9 ea 00 00 00       	jmp    80254c <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 0c             	mov    0xc(%eax),%eax
  802468:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246b:	0f 86 c6 00 00 00    	jbe    802537 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802471:	a1 48 41 80 00       	mov    0x804148,%eax
  802476:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 55 08             	mov    0x8(%ebp),%edx
  80247f:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 50 08             	mov    0x8(%eax),%edx
  802488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248b:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 40 0c             	mov    0xc(%eax),%eax
  802494:	2b 45 08             	sub    0x8(%ebp),%eax
  802497:	89 c2                	mov    %eax,%edx
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 50 08             	mov    0x8(%eax),%edx
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	01 c2                	add    %eax,%edx
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8024b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b4:	75 17                	jne    8024cd <alloc_block_FF+0x117>
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	68 65 3c 80 00       	push   $0x803c65
  8024be:	68 b6 00 00 00       	push   $0xb6
  8024c3:	68 f3 3b 80 00       	push   $0x803bf3
  8024c8:	e8 b1 de ff ff       	call   80037e <_panic>
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 10                	je     8024e6 <alloc_block_FF+0x130>
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024de:	8b 52 04             	mov    0x4(%edx),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%eax)
  8024e4:	eb 0b                	jmp    8024f1 <alloc_block_FF+0x13b>
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 0f                	je     80250a <alloc_block_FF+0x154>
  8024fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802504:	8b 12                	mov    (%edx),%edx
  802506:	89 10                	mov    %edx,(%eax)
  802508:	eb 0a                	jmp    802514 <alloc_block_FF+0x15e>
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	a3 48 41 80 00       	mov    %eax,0x804148
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802527:	a1 54 41 80 00       	mov    0x804154,%eax
  80252c:	48                   	dec    %eax
  80252d:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802535:	eb 15                	jmp    80254c <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80253f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802543:	0f 85 80 fe ff ff    	jne    8023c9 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802554:	a1 38 41 80 00       	mov    0x804138,%eax
  802559:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80255c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802563:	e9 c0 00 00 00       	jmp    802628 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 40 0c             	mov    0xc(%eax),%eax
  80256e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802571:	0f 85 8a 00 00 00    	jne    802601 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257b:	75 17                	jne    802594 <alloc_block_BF+0x46>
  80257d:	83 ec 04             	sub    $0x4,%esp
  802580:	68 65 3c 80 00       	push   $0x803c65
  802585:	68 cf 00 00 00       	push   $0xcf
  80258a:	68 f3 3b 80 00       	push   $0x803bf3
  80258f:	e8 ea dd ff ff       	call   80037e <_panic>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	74 10                	je     8025ad <alloc_block_BF+0x5f>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	8b 52 04             	mov    0x4(%edx),%edx
  8025a8:	89 50 04             	mov    %edx,0x4(%eax)
  8025ab:	eb 0b                	jmp    8025b8 <alloc_block_BF+0x6a>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 04             	mov    0x4(%eax),%eax
  8025b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	74 0f                	je     8025d1 <alloc_block_BF+0x83>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cb:	8b 12                	mov    (%edx),%edx
  8025cd:	89 10                	mov    %edx,(%eax)
  8025cf:	eb 0a                	jmp    8025db <alloc_block_BF+0x8d>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f3:	48                   	dec    %eax
  8025f4:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	e9 2a 01 00 00       	jmp    80272b <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 40 0c             	mov    0xc(%eax),%eax
  802607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80260a:	73 14                	jae    802620 <alloc_block_BF+0xd2>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 0c             	mov    0xc(%eax),%eax
  802612:	3b 45 08             	cmp    0x8(%ebp),%eax
  802615:	76 09                	jbe    802620 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 40 0c             	mov    0xc(%eax),%eax
  80261d:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262c:	0f 85 36 ff ff ff    	jne    802568 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802632:	a1 38 41 80 00       	mov    0x804138,%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80263a:	e9 dd 00 00 00       	jmp    80271c <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802648:	0f 85 c6 00 00 00    	jne    802714 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80264e:	a1 48 41 80 00       	mov    0x804148,%eax
  802653:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 50 08             	mov    0x8(%eax),%edx
  80265c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265f:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802665:	8b 55 08             	mov    0x8(%ebp),%edx
  802668:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 50 08             	mov    0x8(%eax),%edx
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	01 c2                	add    %eax,%edx
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 0c             	mov    0xc(%eax),%eax
  802682:	2b 45 08             	sub    0x8(%ebp),%eax
  802685:	89 c2                	mov    %eax,%edx
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80268d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802691:	75 17                	jne    8026aa <alloc_block_BF+0x15c>
  802693:	83 ec 04             	sub    $0x4,%esp
  802696:	68 65 3c 80 00       	push   $0x803c65
  80269b:	68 eb 00 00 00       	push   $0xeb
  8026a0:	68 f3 3b 80 00       	push   $0x803bf3
  8026a5:	e8 d4 dc ff ff       	call   80037e <_panic>
  8026aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 10                	je     8026c3 <alloc_block_BF+0x175>
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026bb:	8b 52 04             	mov    0x4(%edx),%edx
  8026be:	89 50 04             	mov    %edx,0x4(%eax)
  8026c1:	eb 0b                	jmp    8026ce <alloc_block_BF+0x180>
  8026c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 0f                	je     8026e7 <alloc_block_BF+0x199>
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e1:	8b 12                	mov    (%edx),%edx
  8026e3:	89 10                	mov    %edx,(%eax)
  8026e5:	eb 0a                	jmp    8026f1 <alloc_block_BF+0x1a3>
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	a3 48 41 80 00       	mov    %eax,0x804148
  8026f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802704:	a1 54 41 80 00       	mov    0x804154,%eax
  802709:	48                   	dec    %eax
  80270a:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	eb 17                	jmp    80272b <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80271c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802720:	0f 85 19 ff ff ff    	jne    80263f <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802726:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802733:	a1 40 40 80 00       	mov    0x804040,%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	75 19                	jne    802755 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80273c:	83 ec 0c             	sub    $0xc,%esp
  80273f:	ff 75 08             	pushl  0x8(%ebp)
  802742:	e8 6f fc ff ff       	call   8023b6 <alloc_block_FF>
  802747:	83 c4 10             	add    $0x10,%esp
  80274a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	e9 e9 01 00 00       	jmp    80293e <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802755:	a1 44 40 80 00       	mov    0x804044,%eax
  80275a:	8b 40 08             	mov    0x8(%eax),%eax
  80275d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802760:	a1 44 40 80 00       	mov    0x804044,%eax
  802765:	8b 50 0c             	mov    0xc(%eax),%edx
  802768:	a1 44 40 80 00       	mov    0x804044,%eax
  80276d:	8b 40 08             	mov    0x8(%eax),%eax
  802770:	01 d0                	add    %edx,%eax
  802772:	83 ec 08             	sub    $0x8,%esp
  802775:	50                   	push   %eax
  802776:	68 38 41 80 00       	push   $0x804138
  80277b:	e8 54 fa ff ff       	call   8021d4 <find_block>
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 0c             	mov    0xc(%eax),%eax
  80278c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278f:	0f 85 9b 00 00 00    	jne    802830 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 50 0c             	mov    0xc(%eax),%edx
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 08             	mov    0x8(%eax),%eax
  8027a1:	01 d0                	add    %edx,%eax
  8027a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8027a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027aa:	75 17                	jne    8027c3 <alloc_block_NF+0x96>
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	68 65 3c 80 00       	push   $0x803c65
  8027b4:	68 1a 01 00 00       	push   $0x11a
  8027b9:	68 f3 3b 80 00       	push   $0x803bf3
  8027be:	e8 bb db ff ff       	call   80037e <_panic>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 10                	je     8027dc <alloc_block_NF+0xaf>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d4:	8b 52 04             	mov    0x4(%edx),%edx
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	eb 0b                	jmp    8027e7 <alloc_block_NF+0xba>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 0f                	je     802800 <alloc_block_NF+0xd3>
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fa:	8b 12                	mov    (%edx),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	eb 0a                	jmp    80280a <alloc_block_NF+0xdd>
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	a3 38 41 80 00       	mov    %eax,0x804138
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281d:	a1 44 41 80 00       	mov    0x804144,%eax
  802822:	48                   	dec    %eax
  802823:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	e9 0e 01 00 00       	jmp    80293e <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 40 0c             	mov    0xc(%eax),%eax
  802836:	3b 45 08             	cmp    0x8(%ebp),%eax
  802839:	0f 86 cf 00 00 00    	jbe    80290e <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80283f:	a1 48 41 80 00       	mov    0x804148,%eax
  802844:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284a:	8b 55 08             	mov    0x8(%ebp),%edx
  80284d:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 50 08             	mov    0x8(%eax),%edx
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 50 08             	mov    0x8(%eax),%edx
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	01 c2                	add    %eax,%edx
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 0c             	mov    0xc(%eax),%eax
  802873:	2b 45 08             	sub    0x8(%ebp),%eax
  802876:	89 c2                	mov    %eax,%edx
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 40 08             	mov    0x8(%eax),%eax
  802884:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802887:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80288b:	75 17                	jne    8028a4 <alloc_block_NF+0x177>
  80288d:	83 ec 04             	sub    $0x4,%esp
  802890:	68 65 3c 80 00       	push   $0x803c65
  802895:	68 28 01 00 00       	push   $0x128
  80289a:	68 f3 3b 80 00       	push   $0x803bf3
  80289f:	e8 da da ff ff       	call   80037e <_panic>
  8028a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	74 10                	je     8028bd <alloc_block_NF+0x190>
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 00                	mov    (%eax),%eax
  8028b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b5:	8b 52 04             	mov    0x4(%edx),%edx
  8028b8:	89 50 04             	mov    %edx,0x4(%eax)
  8028bb:	eb 0b                	jmp    8028c8 <alloc_block_NF+0x19b>
  8028bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c0:	8b 40 04             	mov    0x4(%eax),%eax
  8028c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	74 0f                	je     8028e1 <alloc_block_NF+0x1b4>
  8028d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028db:	8b 12                	mov    (%edx),%edx
  8028dd:	89 10                	mov    %edx,(%eax)
  8028df:	eb 0a                	jmp    8028eb <alloc_block_NF+0x1be>
  8028e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	a3 48 41 80 00       	mov    %eax,0x804148
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fe:	a1 54 41 80 00       	mov    0x804154,%eax
  802903:	48                   	dec    %eax
  802904:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290c:	eb 30                	jmp    80293e <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80290e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802913:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802916:	75 0a                	jne    802922 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802918:	a1 38 41 80 00       	mov    0x804138,%eax
  80291d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802920:	eb 08                	jmp    80292a <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802933:	0f 85 4d fe ff ff    	jne    802786 <alloc_block_NF+0x59>

			return NULL;
  802939:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	53                   	push   %ebx
  802944:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802947:	a1 38 41 80 00       	mov    0x804138,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 86 00 00 00    	jne    8029da <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802954:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80295b:	00 00 00 
  80295e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802965:	00 00 00 
  802968:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80296f:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802976:	75 17                	jne    80298f <insert_sorted_with_merge_freeList+0x4f>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 d0 3b 80 00       	push   $0x803bd0
  802980:	68 48 01 00 00       	push   $0x148
  802985:	68 f3 3b 80 00       	push   $0x803bf3
  80298a:	e8 ef d9 ff ff       	call   80037e <_panic>
  80298f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 0d                	je     8029b0 <insert_sorted_with_merge_freeList+0x70>
  8029a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ab:	89 50 04             	mov    %edx,0x4(%eax)
  8029ae:	eb 08                	jmp    8029b8 <insert_sorted_with_merge_freeList+0x78>
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8029cf:	40                   	inc    %eax
  8029d0:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8029d5:	e9 73 07 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	0f 86 84 00 00 00    	jbe    802a74 <insert_sorted_with_merge_freeList+0x134>
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	8b 50 08             	mov    0x8(%eax),%edx
  8029f6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029fb:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029fe:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a03:	8b 40 08             	mov    0x8(%eax),%eax
  802a06:	01 c8                	add    %ecx,%eax
  802a08:	39 c2                	cmp    %eax,%edx
  802a0a:	74 68                	je     802a74 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802a0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a10:	75 17                	jne    802a29 <insert_sorted_with_merge_freeList+0xe9>
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	68 0c 3c 80 00       	push   $0x803c0c
  802a1a:	68 4c 01 00 00       	push   $0x14c
  802a1f:	68 f3 3b 80 00       	push   $0x803bf3
  802a24:	e8 55 d9 ff ff       	call   80037e <_panic>
  802a29:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	89 50 04             	mov    %edx,0x4(%eax)
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	74 0c                	je     802a4b <insert_sorted_with_merge_freeList+0x10b>
  802a3f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a44:	8b 55 08             	mov    0x8(%ebp),%edx
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	eb 08                	jmp    802a53 <insert_sorted_with_merge_freeList+0x113>
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a64:	a1 44 41 80 00       	mov    0x804144,%eax
  802a69:	40                   	inc    %eax
  802a6a:	a3 44 41 80 00       	mov    %eax,0x804144
  802a6f:	e9 d9 06 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 50 08             	mov    0x8(%eax),%edx
  802a7a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	39 c2                	cmp    %eax,%edx
  802a84:	0f 86 b5 00 00 00    	jbe    802b3f <insert_sorted_with_merge_freeList+0x1ff>
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	8b 50 08             	mov    0x8(%eax),%edx
  802a90:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a95:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a98:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	01 c8                	add    %ecx,%eax
  802aa2:	39 c2                	cmp    %eax,%edx
  802aa4:	0f 85 95 00 00 00    	jne    802b3f <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802aaa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aaf:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ab5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ab8:	8b 55 08             	mov    0x8(%ebp),%edx
  802abb:	8b 52 0c             	mov    0xc(%edx),%edx
  802abe:	01 ca                	add    %ecx,%edx
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ad7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802adb:	75 17                	jne    802af4 <insert_sorted_with_merge_freeList+0x1b4>
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	68 d0 3b 80 00       	push   $0x803bd0
  802ae5:	68 54 01 00 00       	push   $0x154
  802aea:	68 f3 3b 80 00       	push   $0x803bf3
  802aef:	e8 8a d8 ff ff       	call   80037e <_panic>
  802af4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	89 10                	mov    %edx,(%eax)
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	74 0d                	je     802b15 <insert_sorted_with_merge_freeList+0x1d5>
  802b08:	a1 48 41 80 00       	mov    0x804148,%eax
  802b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%eax)
  802b13:	eb 08                	jmp    802b1d <insert_sorted_with_merge_freeList+0x1dd>
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	a3 48 41 80 00       	mov    %eax,0x804148
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b34:	40                   	inc    %eax
  802b35:	a3 54 41 80 00       	mov    %eax,0x804154
  802b3a:	e9 0e 06 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	8b 50 08             	mov    0x8(%eax),%edx
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	8b 40 08             	mov    0x8(%eax),%eax
  802b4d:	39 c2                	cmp    %eax,%edx
  802b4f:	0f 83 c1 00 00 00    	jae    802c16 <insert_sorted_with_merge_freeList+0x2d6>
  802b55:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	8b 48 08             	mov    0x8(%eax),%ecx
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 40 0c             	mov    0xc(%eax),%eax
  802b69:	01 c8                	add    %ecx,%eax
  802b6b:	39 c2                	cmp    %eax,%edx
  802b6d:	0f 85 a3 00 00 00    	jne    802c16 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b73:	a1 38 41 80 00       	mov    0x804138,%eax
  802b78:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7b:	8b 52 08             	mov    0x8(%edx),%edx
  802b7e:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b81:	a1 38 41 80 00       	mov    0x804138,%eax
  802b86:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b8c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b92:	8b 52 0c             	mov    0xc(%edx),%edx
  802b95:	01 ca                	add    %ecx,%edx
  802b97:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb2:	75 17                	jne    802bcb <insert_sorted_with_merge_freeList+0x28b>
  802bb4:	83 ec 04             	sub    $0x4,%esp
  802bb7:	68 d0 3b 80 00       	push   $0x803bd0
  802bbc:	68 5d 01 00 00       	push   $0x15d
  802bc1:	68 f3 3b 80 00       	push   $0x803bf3
  802bc6:	e8 b3 d7 ff ff       	call   80037e <_panic>
  802bcb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0d                	je     802bec <insert_sorted_with_merge_freeList+0x2ac>
  802bdf:	a1 48 41 80 00       	mov    0x804148,%eax
  802be4:	8b 55 08             	mov    0x8(%ebp),%edx
  802be7:	89 50 04             	mov    %edx,0x4(%eax)
  802bea:	eb 08                	jmp    802bf4 <insert_sorted_with_merge_freeList+0x2b4>
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	a3 48 41 80 00       	mov    %eax,0x804148
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c06:	a1 54 41 80 00       	mov    0x804154,%eax
  802c0b:	40                   	inc    %eax
  802c0c:	a3 54 41 80 00       	mov    %eax,0x804154
  802c11:	e9 37 05 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 50 08             	mov    0x8(%eax),%edx
  802c1c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	39 c2                	cmp    %eax,%edx
  802c26:	0f 83 82 00 00 00    	jae    802cae <insert_sorted_with_merge_freeList+0x36e>
  802c2c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c31:	8b 50 08             	mov    0x8(%eax),%edx
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	8b 48 08             	mov    0x8(%eax),%ecx
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c40:	01 c8                	add    %ecx,%eax
  802c42:	39 c2                	cmp    %eax,%edx
  802c44:	74 68                	je     802cae <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4a:	75 17                	jne    802c63 <insert_sorted_with_merge_freeList+0x323>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 d0 3b 80 00       	push   $0x803bd0
  802c54:	68 62 01 00 00       	push   $0x162
  802c59:	68 f3 3b 80 00       	push   $0x803bf3
  802c5e:	e8 1b d7 ff ff       	call   80037e <_panic>
  802c63:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0d                	je     802c84 <insert_sorted_with_merge_freeList+0x344>
  802c77:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 08                	jmp    802c8c <insert_sorted_with_merge_freeList+0x34c>
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 44 41 80 00       	mov    %eax,0x804144
  802ca9:	e9 9f 04 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802cae:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802cb8:	e9 84 04 00 00       	jmp    803141 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 50 08             	mov    0x8(%eax),%edx
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	39 c2                	cmp    %eax,%edx
  802ccb:	0f 86 a9 00 00 00    	jbe    802d7a <insert_sorted_with_merge_freeList+0x43a>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 50 08             	mov    0x8(%eax),%edx
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 48 08             	mov    0x8(%eax),%ecx
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce3:	01 c8                	add    %ecx,%eax
  802ce5:	39 c2                	cmp    %eax,%edx
  802ce7:	0f 84 8d 00 00 00    	je     802d7a <insert_sorted_with_merge_freeList+0x43a>
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 50 08             	mov    0x8(%eax),%edx
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 04             	mov    0x4(%eax),%eax
  802cf9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	01 c8                	add    %ecx,%eax
  802d07:	39 c2                	cmp    %eax,%edx
  802d09:	74 6f                	je     802d7a <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0f:	74 06                	je     802d17 <insert_sorted_with_merge_freeList+0x3d7>
  802d11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d15:	75 17                	jne    802d2e <insert_sorted_with_merge_freeList+0x3ee>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 30 3c 80 00       	push   $0x803c30
  802d1f:	68 6b 01 00 00       	push   $0x16b
  802d24:	68 f3 3b 80 00       	push   $0x803bf3
  802d29:	e8 50 d6 ff ff       	call   80037e <_panic>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 50 04             	mov    0x4(%eax),%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	89 50 04             	mov    %edx,0x4(%eax)
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d40:	89 10                	mov    %edx,(%eax)
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	85 c0                	test   %eax,%eax
  802d4a:	74 0d                	je     802d59 <insert_sorted_with_merge_freeList+0x419>
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	8b 55 08             	mov    0x8(%ebp),%edx
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	eb 08                	jmp    802d61 <insert_sorted_with_merge_freeList+0x421>
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	a3 38 41 80 00       	mov    %eax,0x804138
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 55 08             	mov    0x8(%ebp),%edx
  802d67:	89 50 04             	mov    %edx,0x4(%eax)
  802d6a:	a1 44 41 80 00       	mov    0x804144,%eax
  802d6f:	40                   	inc    %eax
  802d70:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d75:	e9 d3 03 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	39 c2                	cmp    %eax,%edx
  802d88:	0f 86 da 00 00 00    	jbe    802e68 <insert_sorted_with_merge_freeList+0x528>
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 50 08             	mov    0x8(%eax),%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 48 08             	mov    0x8(%eax),%ecx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	01 c8                	add    %ecx,%eax
  802da2:	39 c2                	cmp    %eax,%edx
  802da4:	0f 85 be 00 00 00    	jne    802e68 <insert_sorted_with_merge_freeList+0x528>
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	8b 50 08             	mov    0x8(%eax),%edx
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	8b 48 08             	mov    0x8(%eax),%ecx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c8                	add    %ecx,%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 84 9c 00 00 00    	je     802e68 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	8b 40 0c             	mov    0xc(%eax),%eax
  802de4:	01 c2                	add    %eax,%edx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e04:	75 17                	jne    802e1d <insert_sorted_with_merge_freeList+0x4dd>
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	68 d0 3b 80 00       	push   $0x803bd0
  802e0e:	68 74 01 00 00       	push   $0x174
  802e13:	68 f3 3b 80 00       	push   $0x803bf3
  802e18:	e8 61 d5 ff ff       	call   80037e <_panic>
  802e1d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	89 10                	mov    %edx,(%eax)
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 0d                	je     802e3e <insert_sorted_with_merge_freeList+0x4fe>
  802e31:	a1 48 41 80 00       	mov    0x804148,%eax
  802e36:	8b 55 08             	mov    0x8(%ebp),%edx
  802e39:	89 50 04             	mov    %edx,0x4(%eax)
  802e3c:	eb 08                	jmp    802e46 <insert_sorted_with_merge_freeList+0x506>
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	a3 48 41 80 00       	mov    %eax,0x804148
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e58:	a1 54 41 80 00       	mov    0x804154,%eax
  802e5d:	40                   	inc    %eax
  802e5e:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e63:	e9 e5 02 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 40 08             	mov    0x8(%eax),%eax
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	0f 86 d7 00 00 00    	jbe    802f53 <insert_sorted_with_merge_freeList+0x613>
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 50 08             	mov    0x8(%eax),%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	8b 48 08             	mov    0x8(%eax),%ecx
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	01 c8                	add    %ecx,%eax
  802e90:	39 c2                	cmp    %eax,%edx
  802e92:	0f 84 bb 00 00 00    	je     802f53 <insert_sorted_with_merge_freeList+0x613>
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 50 08             	mov    0x8(%eax),%edx
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb0:	01 c8                	add    %ecx,%eax
  802eb2:	39 c2                	cmp    %eax,%edx
  802eb4:	0f 85 99 00 00 00    	jne    802f53 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 04             	mov    0x4(%eax),%eax
  802ec0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecf:	01 c2                	add    %eax,%edx
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802eeb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eef:	75 17                	jne    802f08 <insert_sorted_with_merge_freeList+0x5c8>
  802ef1:	83 ec 04             	sub    $0x4,%esp
  802ef4:	68 d0 3b 80 00       	push   $0x803bd0
  802ef9:	68 7d 01 00 00       	push   $0x17d
  802efe:	68 f3 3b 80 00       	push   $0x803bf3
  802f03:	e8 76 d4 ff ff       	call   80037e <_panic>
  802f08:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	89 10                	mov    %edx,(%eax)
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 0d                	je     802f29 <insert_sorted_with_merge_freeList+0x5e9>
  802f1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802f21:	8b 55 08             	mov    0x8(%ebp),%edx
  802f24:	89 50 04             	mov    %edx,0x4(%eax)
  802f27:	eb 08                	jmp    802f31 <insert_sorted_with_merge_freeList+0x5f1>
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	a3 48 41 80 00       	mov    %eax,0x804148
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f43:	a1 54 41 80 00       	mov    0x804154,%eax
  802f48:	40                   	inc    %eax
  802f49:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f4e:	e9 fa 01 00 00       	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 50 08             	mov    0x8(%eax),%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	39 c2                	cmp    %eax,%edx
  802f61:	0f 86 d2 01 00 00    	jbe    803139 <insert_sorted_with_merge_freeList+0x7f9>
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 50 08             	mov    0x8(%eax),%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 48 08             	mov    0x8(%eax),%ecx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 40 0c             	mov    0xc(%eax),%eax
  802f79:	01 c8                	add    %ecx,%eax
  802f7b:	39 c2                	cmp    %eax,%edx
  802f7d:	0f 85 b6 01 00 00    	jne    803139 <insert_sorted_with_merge_freeList+0x7f9>
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	8b 50 08             	mov    0x8(%eax),%edx
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	8b 48 08             	mov    0x8(%eax),%ecx
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9b:	01 c8                	add    %ecx,%eax
  802f9d:	39 c2                	cmp    %eax,%edx
  802f9f:	0f 85 94 01 00 00    	jne    803139 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fae:	8b 52 04             	mov    0x4(%edx),%edx
  802fb1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb7:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbd:	8b 52 0c             	mov    0xc(%edx),%edx
  802fc0:	01 da                	add    %ebx,%edx
  802fc2:	01 ca                	add    %ecx,%edx
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdf:	75 17                	jne    802ff8 <insert_sorted_with_merge_freeList+0x6b8>
  802fe1:	83 ec 04             	sub    $0x4,%esp
  802fe4:	68 65 3c 80 00       	push   $0x803c65
  802fe9:	68 86 01 00 00       	push   $0x186
  802fee:	68 f3 3b 80 00       	push   $0x803bf3
  802ff3:	e8 86 d3 ff ff       	call   80037e <_panic>
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 10                	je     803011 <insert_sorted_with_merge_freeList+0x6d1>
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803009:	8b 52 04             	mov    0x4(%edx),%edx
  80300c:	89 50 04             	mov    %edx,0x4(%eax)
  80300f:	eb 0b                	jmp    80301c <insert_sorted_with_merge_freeList+0x6dc>
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 0f                	je     803035 <insert_sorted_with_merge_freeList+0x6f5>
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302f:	8b 12                	mov    (%edx),%edx
  803031:	89 10                	mov    %edx,(%eax)
  803033:	eb 0a                	jmp    80303f <insert_sorted_with_merge_freeList+0x6ff>
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	a3 38 41 80 00       	mov    %eax,0x804138
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803052:	a1 44 41 80 00       	mov    0x804144,%eax
  803057:	48                   	dec    %eax
  803058:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80305d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803061:	75 17                	jne    80307a <insert_sorted_with_merge_freeList+0x73a>
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	68 d0 3b 80 00       	push   $0x803bd0
  80306b:	68 87 01 00 00       	push   $0x187
  803070:	68 f3 3b 80 00       	push   $0x803bf3
  803075:	e8 04 d3 ff ff       	call   80037e <_panic>
  80307a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	89 10                	mov    %edx,(%eax)
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 0d                	je     80309b <insert_sorted_with_merge_freeList+0x75b>
  80308e:	a1 48 41 80 00       	mov    0x804148,%eax
  803093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	eb 08                	jmp    8030a3 <insert_sorted_with_merge_freeList+0x763>
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b5:	a1 54 41 80 00       	mov    0x804154,%eax
  8030ba:	40                   	inc    %eax
  8030bb:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d8:	75 17                	jne    8030f1 <insert_sorted_with_merge_freeList+0x7b1>
  8030da:	83 ec 04             	sub    $0x4,%esp
  8030dd:	68 d0 3b 80 00       	push   $0x803bd0
  8030e2:	68 8a 01 00 00       	push   $0x18a
  8030e7:	68 f3 3b 80 00       	push   $0x803bf3
  8030ec:	e8 8d d2 ff ff       	call   80037e <_panic>
  8030f1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 0d                	je     803112 <insert_sorted_with_merge_freeList+0x7d2>
  803105:	a1 48 41 80 00       	mov    0x804148,%eax
  80310a:	8b 55 08             	mov    0x8(%ebp),%edx
  80310d:	89 50 04             	mov    %edx,0x4(%eax)
  803110:	eb 08                	jmp    80311a <insert_sorted_with_merge_freeList+0x7da>
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	a3 48 41 80 00       	mov    %eax,0x804148
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312c:	a1 54 41 80 00       	mov    0x804154,%eax
  803131:	40                   	inc    %eax
  803132:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803137:	eb 14                	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803145:	0f 85 72 fb ff ff    	jne    802cbd <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80314b:	eb 00                	jmp    80314d <insert_sorted_with_merge_freeList+0x80d>
  80314d:	90                   	nop
  80314e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803151:	c9                   	leave  
  803152:	c3                   	ret    
  803153:	90                   	nop

00803154 <__udivdi3>:
  803154:	55                   	push   %ebp
  803155:	57                   	push   %edi
  803156:	56                   	push   %esi
  803157:	53                   	push   %ebx
  803158:	83 ec 1c             	sub    $0x1c,%esp
  80315b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80315f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803167:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80316b:	89 ca                	mov    %ecx,%edx
  80316d:	89 f8                	mov    %edi,%eax
  80316f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803173:	85 f6                	test   %esi,%esi
  803175:	75 2d                	jne    8031a4 <__udivdi3+0x50>
  803177:	39 cf                	cmp    %ecx,%edi
  803179:	77 65                	ja     8031e0 <__udivdi3+0x8c>
  80317b:	89 fd                	mov    %edi,%ebp
  80317d:	85 ff                	test   %edi,%edi
  80317f:	75 0b                	jne    80318c <__udivdi3+0x38>
  803181:	b8 01 00 00 00       	mov    $0x1,%eax
  803186:	31 d2                	xor    %edx,%edx
  803188:	f7 f7                	div    %edi
  80318a:	89 c5                	mov    %eax,%ebp
  80318c:	31 d2                	xor    %edx,%edx
  80318e:	89 c8                	mov    %ecx,%eax
  803190:	f7 f5                	div    %ebp
  803192:	89 c1                	mov    %eax,%ecx
  803194:	89 d8                	mov    %ebx,%eax
  803196:	f7 f5                	div    %ebp
  803198:	89 cf                	mov    %ecx,%edi
  80319a:	89 fa                	mov    %edi,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	39 ce                	cmp    %ecx,%esi
  8031a6:	77 28                	ja     8031d0 <__udivdi3+0x7c>
  8031a8:	0f bd fe             	bsr    %esi,%edi
  8031ab:	83 f7 1f             	xor    $0x1f,%edi
  8031ae:	75 40                	jne    8031f0 <__udivdi3+0x9c>
  8031b0:	39 ce                	cmp    %ecx,%esi
  8031b2:	72 0a                	jb     8031be <__udivdi3+0x6a>
  8031b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031b8:	0f 87 9e 00 00 00    	ja     80325c <__udivdi3+0x108>
  8031be:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c3:	89 fa                	mov    %edi,%edx
  8031c5:	83 c4 1c             	add    $0x1c,%esp
  8031c8:	5b                   	pop    %ebx
  8031c9:	5e                   	pop    %esi
  8031ca:	5f                   	pop    %edi
  8031cb:	5d                   	pop    %ebp
  8031cc:	c3                   	ret    
  8031cd:	8d 76 00             	lea    0x0(%esi),%esi
  8031d0:	31 ff                	xor    %edi,%edi
  8031d2:	31 c0                	xor    %eax,%eax
  8031d4:	89 fa                	mov    %edi,%edx
  8031d6:	83 c4 1c             	add    $0x1c,%esp
  8031d9:	5b                   	pop    %ebx
  8031da:	5e                   	pop    %esi
  8031db:	5f                   	pop    %edi
  8031dc:	5d                   	pop    %ebp
  8031dd:	c3                   	ret    
  8031de:	66 90                	xchg   %ax,%ax
  8031e0:	89 d8                	mov    %ebx,%eax
  8031e2:	f7 f7                	div    %edi
  8031e4:	31 ff                	xor    %edi,%edi
  8031e6:	89 fa                	mov    %edi,%edx
  8031e8:	83 c4 1c             	add    $0x1c,%esp
  8031eb:	5b                   	pop    %ebx
  8031ec:	5e                   	pop    %esi
  8031ed:	5f                   	pop    %edi
  8031ee:	5d                   	pop    %ebp
  8031ef:	c3                   	ret    
  8031f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031f5:	89 eb                	mov    %ebp,%ebx
  8031f7:	29 fb                	sub    %edi,%ebx
  8031f9:	89 f9                	mov    %edi,%ecx
  8031fb:	d3 e6                	shl    %cl,%esi
  8031fd:	89 c5                	mov    %eax,%ebp
  8031ff:	88 d9                	mov    %bl,%cl
  803201:	d3 ed                	shr    %cl,%ebp
  803203:	89 e9                	mov    %ebp,%ecx
  803205:	09 f1                	or     %esi,%ecx
  803207:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80320b:	89 f9                	mov    %edi,%ecx
  80320d:	d3 e0                	shl    %cl,%eax
  80320f:	89 c5                	mov    %eax,%ebp
  803211:	89 d6                	mov    %edx,%esi
  803213:	88 d9                	mov    %bl,%cl
  803215:	d3 ee                	shr    %cl,%esi
  803217:	89 f9                	mov    %edi,%ecx
  803219:	d3 e2                	shl    %cl,%edx
  80321b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80321f:	88 d9                	mov    %bl,%cl
  803221:	d3 e8                	shr    %cl,%eax
  803223:	09 c2                	or     %eax,%edx
  803225:	89 d0                	mov    %edx,%eax
  803227:	89 f2                	mov    %esi,%edx
  803229:	f7 74 24 0c          	divl   0xc(%esp)
  80322d:	89 d6                	mov    %edx,%esi
  80322f:	89 c3                	mov    %eax,%ebx
  803231:	f7 e5                	mul    %ebp
  803233:	39 d6                	cmp    %edx,%esi
  803235:	72 19                	jb     803250 <__udivdi3+0xfc>
  803237:	74 0b                	je     803244 <__udivdi3+0xf0>
  803239:	89 d8                	mov    %ebx,%eax
  80323b:	31 ff                	xor    %edi,%edi
  80323d:	e9 58 ff ff ff       	jmp    80319a <__udivdi3+0x46>
  803242:	66 90                	xchg   %ax,%ax
  803244:	8b 54 24 08          	mov    0x8(%esp),%edx
  803248:	89 f9                	mov    %edi,%ecx
  80324a:	d3 e2                	shl    %cl,%edx
  80324c:	39 c2                	cmp    %eax,%edx
  80324e:	73 e9                	jae    803239 <__udivdi3+0xe5>
  803250:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803253:	31 ff                	xor    %edi,%edi
  803255:	e9 40 ff ff ff       	jmp    80319a <__udivdi3+0x46>
  80325a:	66 90                	xchg   %ax,%ax
  80325c:	31 c0                	xor    %eax,%eax
  80325e:	e9 37 ff ff ff       	jmp    80319a <__udivdi3+0x46>
  803263:	90                   	nop

00803264 <__umoddi3>:
  803264:	55                   	push   %ebp
  803265:	57                   	push   %edi
  803266:	56                   	push   %esi
  803267:	53                   	push   %ebx
  803268:	83 ec 1c             	sub    $0x1c,%esp
  80326b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80326f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803273:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803277:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80327b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80327f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803283:	89 f3                	mov    %esi,%ebx
  803285:	89 fa                	mov    %edi,%edx
  803287:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80328b:	89 34 24             	mov    %esi,(%esp)
  80328e:	85 c0                	test   %eax,%eax
  803290:	75 1a                	jne    8032ac <__umoddi3+0x48>
  803292:	39 f7                	cmp    %esi,%edi
  803294:	0f 86 a2 00 00 00    	jbe    80333c <__umoddi3+0xd8>
  80329a:	89 c8                	mov    %ecx,%eax
  80329c:	89 f2                	mov    %esi,%edx
  80329e:	f7 f7                	div    %edi
  8032a0:	89 d0                	mov    %edx,%eax
  8032a2:	31 d2                	xor    %edx,%edx
  8032a4:	83 c4 1c             	add    $0x1c,%esp
  8032a7:	5b                   	pop    %ebx
  8032a8:	5e                   	pop    %esi
  8032a9:	5f                   	pop    %edi
  8032aa:	5d                   	pop    %ebp
  8032ab:	c3                   	ret    
  8032ac:	39 f0                	cmp    %esi,%eax
  8032ae:	0f 87 ac 00 00 00    	ja     803360 <__umoddi3+0xfc>
  8032b4:	0f bd e8             	bsr    %eax,%ebp
  8032b7:	83 f5 1f             	xor    $0x1f,%ebp
  8032ba:	0f 84 ac 00 00 00    	je     80336c <__umoddi3+0x108>
  8032c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8032c5:	29 ef                	sub    %ebp,%edi
  8032c7:	89 fe                	mov    %edi,%esi
  8032c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032cd:	89 e9                	mov    %ebp,%ecx
  8032cf:	d3 e0                	shl    %cl,%eax
  8032d1:	89 d7                	mov    %edx,%edi
  8032d3:	89 f1                	mov    %esi,%ecx
  8032d5:	d3 ef                	shr    %cl,%edi
  8032d7:	09 c7                	or     %eax,%edi
  8032d9:	89 e9                	mov    %ebp,%ecx
  8032db:	d3 e2                	shl    %cl,%edx
  8032dd:	89 14 24             	mov    %edx,(%esp)
  8032e0:	89 d8                	mov    %ebx,%eax
  8032e2:	d3 e0                	shl    %cl,%eax
  8032e4:	89 c2                	mov    %eax,%edx
  8032e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ea:	d3 e0                	shl    %cl,%eax
  8032ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032f4:	89 f1                	mov    %esi,%ecx
  8032f6:	d3 e8                	shr    %cl,%eax
  8032f8:	09 d0                	or     %edx,%eax
  8032fa:	d3 eb                	shr    %cl,%ebx
  8032fc:	89 da                	mov    %ebx,%edx
  8032fe:	f7 f7                	div    %edi
  803300:	89 d3                	mov    %edx,%ebx
  803302:	f7 24 24             	mull   (%esp)
  803305:	89 c6                	mov    %eax,%esi
  803307:	89 d1                	mov    %edx,%ecx
  803309:	39 d3                	cmp    %edx,%ebx
  80330b:	0f 82 87 00 00 00    	jb     803398 <__umoddi3+0x134>
  803311:	0f 84 91 00 00 00    	je     8033a8 <__umoddi3+0x144>
  803317:	8b 54 24 04          	mov    0x4(%esp),%edx
  80331b:	29 f2                	sub    %esi,%edx
  80331d:	19 cb                	sbb    %ecx,%ebx
  80331f:	89 d8                	mov    %ebx,%eax
  803321:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803325:	d3 e0                	shl    %cl,%eax
  803327:	89 e9                	mov    %ebp,%ecx
  803329:	d3 ea                	shr    %cl,%edx
  80332b:	09 d0                	or     %edx,%eax
  80332d:	89 e9                	mov    %ebp,%ecx
  80332f:	d3 eb                	shr    %cl,%ebx
  803331:	89 da                	mov    %ebx,%edx
  803333:	83 c4 1c             	add    $0x1c,%esp
  803336:	5b                   	pop    %ebx
  803337:	5e                   	pop    %esi
  803338:	5f                   	pop    %edi
  803339:	5d                   	pop    %ebp
  80333a:	c3                   	ret    
  80333b:	90                   	nop
  80333c:	89 fd                	mov    %edi,%ebp
  80333e:	85 ff                	test   %edi,%edi
  803340:	75 0b                	jne    80334d <__umoddi3+0xe9>
  803342:	b8 01 00 00 00       	mov    $0x1,%eax
  803347:	31 d2                	xor    %edx,%edx
  803349:	f7 f7                	div    %edi
  80334b:	89 c5                	mov    %eax,%ebp
  80334d:	89 f0                	mov    %esi,%eax
  80334f:	31 d2                	xor    %edx,%edx
  803351:	f7 f5                	div    %ebp
  803353:	89 c8                	mov    %ecx,%eax
  803355:	f7 f5                	div    %ebp
  803357:	89 d0                	mov    %edx,%eax
  803359:	e9 44 ff ff ff       	jmp    8032a2 <__umoddi3+0x3e>
  80335e:	66 90                	xchg   %ax,%ax
  803360:	89 c8                	mov    %ecx,%eax
  803362:	89 f2                	mov    %esi,%edx
  803364:	83 c4 1c             	add    $0x1c,%esp
  803367:	5b                   	pop    %ebx
  803368:	5e                   	pop    %esi
  803369:	5f                   	pop    %edi
  80336a:	5d                   	pop    %ebp
  80336b:	c3                   	ret    
  80336c:	3b 04 24             	cmp    (%esp),%eax
  80336f:	72 06                	jb     803377 <__umoddi3+0x113>
  803371:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803375:	77 0f                	ja     803386 <__umoddi3+0x122>
  803377:	89 f2                	mov    %esi,%edx
  803379:	29 f9                	sub    %edi,%ecx
  80337b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80337f:	89 14 24             	mov    %edx,(%esp)
  803382:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803386:	8b 44 24 04          	mov    0x4(%esp),%eax
  80338a:	8b 14 24             	mov    (%esp),%edx
  80338d:	83 c4 1c             	add    $0x1c,%esp
  803390:	5b                   	pop    %ebx
  803391:	5e                   	pop    %esi
  803392:	5f                   	pop    %edi
  803393:	5d                   	pop    %ebp
  803394:	c3                   	ret    
  803395:	8d 76 00             	lea    0x0(%esi),%esi
  803398:	2b 04 24             	sub    (%esp),%eax
  80339b:	19 fa                	sbb    %edi,%edx
  80339d:	89 d1                	mov    %edx,%ecx
  80339f:	89 c6                	mov    %eax,%esi
  8033a1:	e9 71 ff ff ff       	jmp    803317 <__umoddi3+0xb3>
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033ac:	72 ea                	jb     803398 <__umoddi3+0x134>
  8033ae:	89 d9                	mov    %ebx,%ecx
  8033b0:	e9 62 ff ff ff       	jmp    803317 <__umoddi3+0xb3>
