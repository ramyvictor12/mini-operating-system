
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 33 80 00       	push   $0x8033c0
  80004a:	e8 bc 14 00 00       	call   80150b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 c4 33 80 00       	push   $0x8033c4
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 e9 33 80 00       	push   $0x8033e9
  80009f:	e8 67 14 00 00       	call   80150b <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 f0 33 80 00       	push   $0x8033f0
  8000dc:	e8 8e 18 00 00       	call   80196f <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 f2 33 80 00       	push   $0x8033f2
  8000f0:	e8 16 14 00 00       	call   80150b <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 00 34 80 00       	push   $0x803400
  80012c:	e8 4f 19 00 00       	call   801a80 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 0a 34 80 00       	push   $0x80340a
  80015f:	e8 1c 19 00 00       	call   801a80 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 29 19 00 00       	call   801a9e <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 1b 19 00 00       	call   801a9e <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 14 34 80 00       	push   $0x803414
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 6c 17 00 00       	call   80192f <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 27 17 00 00       	call   8018fb <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 48 17 00 00       	call   80192f <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 26 17 00 00       	call   801915 <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 70 15 00 00       	call   801776 <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 dc 16 00 00       	call   8018fb <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 49 15 00 00       	call   801776 <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 da 16 00 00       	call   801915 <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 99 18 00 00       	call   801aee <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 3b 16 00 00       	call   8018fb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 44 34 80 00       	push   $0x803444
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 6c 34 80 00       	push   $0x80346c
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 94 34 80 00       	push   $0x803494
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 ec 34 80 00       	push   $0x8034ec
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 44 34 80 00       	push   $0x803444
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 bb 15 00 00       	call   801915 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 48 17 00 00       	call   801aba <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 9d 17 00 00       	call   801b20 <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 7c 13 00 00       	call   80174d <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 05 13 00 00       	call   80174d <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 69 14 00 00       	call   8018fb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 63 14 00 00       	call   801915 <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 60 2c 00 00       	call   80315c <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 20 2d 00 00       	call   80326c <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 14 37 80 00       	add    $0x803714,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 38 37 80 00 	mov    0x803738(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d 80 35 80 00 	mov    0x803580(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 25 37 80 00       	push   $0x803725
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 2e 37 80 00       	push   $0x80372e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 31 37 80 00       	mov    $0x803731,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 90 38 80 00       	push   $0x803890
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80121b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801222:	00 00 00 
  801225:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80122c:	00 00 00 
  80122f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801236:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801239:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801240:	00 00 00 
  801243:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80124a:	00 00 00 
  80124d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801254:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801257:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80125e:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801261:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801268:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80126f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801272:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801277:	2d 00 10 00 00       	sub    $0x1000,%eax
  80127c:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801281:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80128b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801290:	2d 00 10 00 00       	sub    $0x1000,%eax
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	6a 06                	push   $0x6
  80129a:	ff 75 f4             	pushl  -0xc(%ebp)
  80129d:	50                   	push   %eax
  80129e:	e8 ee 05 00 00       	call   801891 <sys_allocate_chunk>
  8012a3:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012a6:	a1 20 41 80 00       	mov    0x804120,%eax
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	50                   	push   %eax
  8012af:	e8 63 0c 00 00       	call   801f17 <initialize_MemBlocksList>
  8012b4:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8012b7:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8012bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8012bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012c2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8012c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8012cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012da:	89 c2                	mov    %eax,%edx
  8012dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012df:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8012e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012e5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8012ec:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8012f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012f6:	8b 50 08             	mov    0x8(%eax),%edx
  8012f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	48                   	dec    %eax
  8012ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801302:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801305:	ba 00 00 00 00       	mov    $0x0,%edx
  80130a:	f7 75 e0             	divl   -0x20(%ebp)
  80130d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801310:	29 d0                	sub    %edx,%eax
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801317:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80131a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80131e:	75 14                	jne    801334 <initialize_dyn_block_system+0x11f>
  801320:	83 ec 04             	sub    $0x4,%esp
  801323:	68 b5 38 80 00       	push   $0x8038b5
  801328:	6a 34                	push   $0x34
  80132a:	68 d3 38 80 00       	push   $0x8038d3
  80132f:	e8 47 1c 00 00       	call   802f7b <_panic>
  801334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801337:	8b 00                	mov    (%eax),%eax
  801339:	85 c0                	test   %eax,%eax
  80133b:	74 10                	je     80134d <initialize_dyn_block_system+0x138>
  80133d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801345:	8b 52 04             	mov    0x4(%edx),%edx
  801348:	89 50 04             	mov    %edx,0x4(%eax)
  80134b:	eb 0b                	jmp    801358 <initialize_dyn_block_system+0x143>
  80134d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801350:	8b 40 04             	mov    0x4(%eax),%eax
  801353:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80135b:	8b 40 04             	mov    0x4(%eax),%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 0f                	je     801371 <initialize_dyn_block_system+0x15c>
  801362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801365:	8b 40 04             	mov    0x4(%eax),%eax
  801368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80136b:	8b 12                	mov    (%edx),%edx
  80136d:	89 10                	mov    %edx,(%eax)
  80136f:	eb 0a                	jmp    80137b <initialize_dyn_block_system+0x166>
  801371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801374:	8b 00                	mov    (%eax),%eax
  801376:	a3 48 41 80 00       	mov    %eax,0x804148
  80137b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80137e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801387:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80138e:	a1 54 41 80 00       	mov    0x804154,%eax
  801393:	48                   	dec    %eax
  801394:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	ff 75 e8             	pushl  -0x18(%ebp)
  80139f:	e8 c4 13 00 00       	call   802768 <insert_sorted_with_merge_freeList>
  8013a4:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <malloc>:
//=================================



void* malloc(uint32 size)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013b0:	e8 2f fe ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b9:	75 07                	jne    8013c2 <malloc+0x18>
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	eb 71                	jmp    801433 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8013c2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8013c9:	76 07                	jbe    8013d2 <malloc+0x28>
	return NULL;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 61                	jmp    801433 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8013d2:	e8 88 08 00 00       	call   801c5f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	74 53                	je     80142e <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8013db:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8013e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e8:	01 d0                	add    %edx,%eax
  8013ea:	48                   	dec    %eax
  8013eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f6:	f7 75 f4             	divl   -0xc(%ebp)
  8013f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fc:	29 d0                	sub    %edx,%eax
  8013fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	ff 75 ec             	pushl  -0x14(%ebp)
  801407:	e8 d2 0d 00 00       	call   8021de <alloc_block_FF>
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801412:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801416:	74 16                	je     80142e <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801418:	83 ec 0c             	sub    $0xc,%esp
  80141b:	ff 75 e8             	pushl  -0x18(%ebp)
  80141e:	e8 0c 0c 00 00       	call   80202f <insert_sorted_allocList>
  801423:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801429:	8b 40 08             	mov    0x8(%eax),%eax
  80142c:	eb 05                	jmp    801433 <malloc+0x89>
    }

			}


	return NULL;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801449:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 f0             	pushl  -0x10(%ebp)
  801452:	68 40 40 80 00       	push   $0x804040
  801457:	e8 a0 0b 00 00       	call   801ffc <find_block>
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801465:	8b 50 0c             	mov    0xc(%eax),%edx
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	52                   	push   %edx
  80146f:	50                   	push   %eax
  801470:	e8 e4 03 00 00       	call   801859 <sys_free_user_mem>
  801475:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801478:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80147c:	75 17                	jne    801495 <free+0x60>
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	68 b5 38 80 00       	push   $0x8038b5
  801486:	68 84 00 00 00       	push   $0x84
  80148b:	68 d3 38 80 00       	push   $0x8038d3
  801490:	e8 e6 1a 00 00       	call   802f7b <_panic>
  801495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801498:	8b 00                	mov    (%eax),%eax
  80149a:	85 c0                	test   %eax,%eax
  80149c:	74 10                	je     8014ae <free+0x79>
  80149e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a1:	8b 00                	mov    (%eax),%eax
  8014a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014a6:	8b 52 04             	mov    0x4(%edx),%edx
  8014a9:	89 50 04             	mov    %edx,0x4(%eax)
  8014ac:	eb 0b                	jmp    8014b9 <free+0x84>
  8014ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b1:	8b 40 04             	mov    0x4(%eax),%eax
  8014b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8014b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014bc:	8b 40 04             	mov    0x4(%eax),%eax
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	74 0f                	je     8014d2 <free+0x9d>
  8014c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c6:	8b 40 04             	mov    0x4(%eax),%eax
  8014c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014cc:	8b 12                	mov    (%edx),%edx
  8014ce:	89 10                	mov    %edx,(%eax)
  8014d0:	eb 0a                	jmp    8014dc <free+0xa7>
  8014d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d5:	8b 00                	mov    (%eax),%eax
  8014d7:	a3 40 40 80 00       	mov    %eax,0x804040
  8014dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ef:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8014f4:	48                   	dec    %eax
  8014f5:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 ec             	pushl  -0x14(%ebp)
  801500:	e8 63 12 00 00       	call   802768 <insert_sorted_with_merge_freeList>
  801505:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801508:	90                   	nop
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	83 ec 38             	sub    $0x38,%esp
  801511:	8b 45 10             	mov    0x10(%ebp),%eax
  801514:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801517:	e8 c8 fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80151c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801520:	75 0a                	jne    80152c <smalloc+0x21>
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
  801527:	e9 a0 00 00 00       	jmp    8015cc <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80152c:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801533:	76 0a                	jbe    80153f <smalloc+0x34>
		return NULL;
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	e9 8d 00 00 00       	jmp    8015cc <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80153f:	e8 1b 07 00 00       	call   801c5f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801544:	85 c0                	test   %eax,%eax
  801546:	74 7f                	je     8015c7 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801548:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801555:	01 d0                	add    %edx,%eax
  801557:	48                   	dec    %eax
  801558:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80155b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155e:	ba 00 00 00 00       	mov    $0x0,%edx
  801563:	f7 75 f4             	divl   -0xc(%ebp)
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	29 d0                	sub    %edx,%eax
  80156b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	ff 75 ec             	pushl  -0x14(%ebp)
  801574:	e8 65 0c 00 00       	call   8021de <alloc_block_FF>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80157f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801583:	74 42                	je     8015c7 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801585:	83 ec 0c             	sub    $0xc,%esp
  801588:	ff 75 e8             	pushl  -0x18(%ebp)
  80158b:	e8 9f 0a 00 00       	call   80202f <insert_sorted_allocList>
  801590:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801596:	8b 40 08             	mov    0x8(%eax),%eax
  801599:	89 c2                	mov    %eax,%edx
  80159b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80159f:	52                   	push   %edx
  8015a0:	50                   	push   %eax
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	ff 75 08             	pushl  0x8(%ebp)
  8015a7:	e8 38 04 00 00       	call   8019e4 <sys_createSharedObject>
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8015b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015b6:	79 07                	jns    8015bf <smalloc+0xb4>
	    		  return NULL;
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	eb 0d                	jmp    8015cc <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	8b 40 08             	mov    0x8(%eax),%eax
  8015c5:	eb 05                	jmp    8015cc <smalloc+0xc1>


				}


		return NULL;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d4:	e8 0b fc ff ff       	call   8011e4 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015d9:	e8 81 06 00 00       	call   801c5f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	0f 84 9f 00 00 00    	je     801685 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	ff 75 08             	pushl  0x8(%ebp)
  8015ef:	e8 1a 04 00 00       	call   801a0e <sys_getSizeOfSharedObject>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8015fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015fe:	79 0a                	jns    80160a <sget+0x3c>
		return NULL;
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	e9 80 00 00 00       	jmp    80168a <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80160a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	01 d0                	add    %edx,%eax
  801619:	48                   	dec    %eax
  80161a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80161d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	f7 75 f0             	divl   -0x10(%ebp)
  801628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162b:	29 d0                	sub    %edx,%eax
  80162d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801630:	83 ec 0c             	sub    $0xc,%esp
  801633:	ff 75 e8             	pushl  -0x18(%ebp)
  801636:	e8 a3 0b 00 00       	call   8021de <alloc_block_FF>
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	74 3e                	je     801685 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80164d:	e8 dd 09 00 00       	call   80202f <insert_sorted_allocList>
  801652:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801658:	8b 40 08             	mov    0x8(%eax),%eax
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	50                   	push   %eax
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	e8 c1 03 00 00       	call   801a2b <sys_getSharedObject>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801670:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801674:	79 07                	jns    80167d <sget+0xaf>
	    		  return NULL;
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	eb 0d                	jmp    80168a <sget+0xbc>
	  	return(void*) returned_block->sva;
  80167d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801680:	8b 40 08             	mov    0x8(%eax),%eax
  801683:	eb 05                	jmp    80168a <sget+0xbc>
	      }
	}
	   return NULL;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801692:	e8 4d fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	68 e0 38 80 00       	push   $0x8038e0
  80169f:	68 12 01 00 00       	push   $0x112
  8016a4:	68 d3 38 80 00       	push   $0x8038d3
  8016a9:	e8 cd 18 00 00       	call   802f7b <_panic>

008016ae <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 08 39 80 00       	push   $0x803908
  8016bc:	68 26 01 00 00       	push   $0x126
  8016c1:	68 d3 38 80 00       	push   $0x8038d3
  8016c6:	e8 b0 18 00 00       	call   802f7b <_panic>

008016cb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 2c 39 80 00       	push   $0x80392c
  8016d9:	68 31 01 00 00       	push   $0x131
  8016de:	68 d3 38 80 00       	push   $0x8038d3
  8016e3:	e8 93 18 00 00       	call   802f7b <_panic>

008016e8 <shrink>:

}
void shrink(uint32 newSize)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	68 2c 39 80 00       	push   $0x80392c
  8016f6:	68 36 01 00 00       	push   $0x136
  8016fb:	68 d3 38 80 00       	push   $0x8038d3
  801700:	e8 76 18 00 00       	call   802f7b <_panic>

00801705 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	68 2c 39 80 00       	push   $0x80392c
  801713:	68 3b 01 00 00       	push   $0x13b
  801718:	68 d3 38 80 00       	push   $0x8038d3
  80171d:	e8 59 18 00 00       	call   802f7b <_panic>

00801722 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	57                   	push   %edi
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801731:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801734:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801737:	8b 7d 18             	mov    0x18(%ebp),%edi
  80173a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80173d:	cd 30                	int    $0x30
  80173f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5f                   	pop    %edi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	8b 45 10             	mov    0x10(%ebp),%eax
  801756:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801759:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	52                   	push   %edx
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	50                   	push   %eax
  801769:	6a 00                	push   $0x0
  80176b:	e8 b2 ff ff ff       	call   801722 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	90                   	nop
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_cgetc>:

int
sys_cgetc(void)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 01                	push   $0x1
  801785:	e8 98 ff ff ff       	call   801722 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	6a 05                	push   $0x5
  8017a2:	e8 7b ff ff ff       	call   801722 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	56                   	push   %esi
  8017b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8017b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	51                   	push   %ecx
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 06                	push   $0x6
  8017c7:	e8 56 ff ff ff       	call   801722 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d2:	5b                   	pop    %ebx
  8017d3:	5e                   	pop    %esi
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    

008017d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	6a 07                	push   $0x7
  8017e9:	e8 34 ff ff ff       	call   801722 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	6a 08                	push   $0x8
  801804:	e8 19 ff ff ff       	call   801722 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 09                	push   $0x9
  80181d:	e8 00 ff ff ff       	call   801722 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 0a                	push   $0xa
  801836:	e8 e7 fe ff ff       	call   801722 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 0b                	push   $0xb
  80184f:	e8 ce fe ff ff       	call   801722 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 0f                	push   $0xf
  80186a:	e8 b3 fe ff ff       	call   801722 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
	return;
  801872:	90                   	nop
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	ff 75 08             	pushl  0x8(%ebp)
  801884:	6a 10                	push   $0x10
  801886:	e8 97 fe ff ff       	call   801722 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
	return ;
  80188e:	90                   	nop
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	ff 75 10             	pushl  0x10(%ebp)
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 11                	push   $0x11
  8018a3:	e8 7a fe ff ff       	call   801722 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 0c                	push   $0xc
  8018bd:	e8 60 fe ff ff       	call   801722 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 0d                	push   $0xd
  8018d7:	e8 46 fe ff ff       	call   801722 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 0e                	push   $0xe
  8018f0:	e8 2d fe ff ff       	call   801722 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 13                	push   $0x13
  80190a:	e8 13 fe ff ff       	call   801722 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	90                   	nop
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 14                	push   $0x14
  801924:	e8 f9 fd ff ff       	call   801722 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	90                   	nop
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_cputc>:


void
sys_cputc(const char c)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80193b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	50                   	push   %eax
  801948:	6a 15                	push   $0x15
  80194a:	e8 d3 fd ff ff       	call   801722 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	90                   	nop
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 16                	push   $0x16
  801964:	e8 b9 fd ff ff       	call   801722 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	90                   	nop
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	50                   	push   %eax
  80197f:	6a 17                	push   $0x17
  801981:	e8 9c fd ff ff       	call   801722 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 1a                	push   $0x1a
  80199e:	e8 7f fd ff ff       	call   801722 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 18                	push   $0x18
  8019bb:	e8 62 fd ff ff       	call   801722 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	90                   	nop
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	52                   	push   %edx
  8019d6:	50                   	push   %eax
  8019d7:	6a 19                	push   $0x19
  8019d9:	e8 44 fd ff ff       	call   801722 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	51                   	push   %ecx
  8019fd:	52                   	push   %edx
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	50                   	push   %eax
  801a02:	6a 1b                	push   $0x1b
  801a04:	e8 19 fd ff ff       	call   801722 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 1c                	push   $0x1c
  801a21:	e8 fc fc ff ff       	call   801722 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	51                   	push   %ecx
  801a3c:	52                   	push   %edx
  801a3d:	50                   	push   %eax
  801a3e:	6a 1d                	push   $0x1d
  801a40:	e8 dd fc ff ff       	call   801722 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 1e                	push   $0x1e
  801a5d:	e8 c0 fc ff ff       	call   801722 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 1f                	push   $0x1f
  801a76:	e8 a7 fc ff ff       	call   801722 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	ff 75 14             	pushl  0x14(%ebp)
  801a8b:	ff 75 10             	pushl  0x10(%ebp)
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	6a 20                	push   $0x20
  801a94:	e8 89 fc ff ff       	call   801722 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	50                   	push   %eax
  801aad:	6a 21                	push   $0x21
  801aaf:	e8 6e fc ff ff       	call   801722 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	50                   	push   %eax
  801ac9:	6a 22                	push   $0x22
  801acb:	e8 52 fc ff ff       	call   801722 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 02                	push   $0x2
  801ae4:	e8 39 fc ff ff       	call   801722 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 03                	push   $0x3
  801afd:	e8 20 fc ff ff       	call   801722 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 04                	push   $0x4
  801b16:	e8 07 fc ff ff       	call   801722 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_exit_env>:


void sys_exit_env(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 23                	push   $0x23
  801b2f:	e8 ee fb ff ff       	call   801722 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	90                   	nop
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b43:	8d 50 04             	lea    0x4(%eax),%edx
  801b46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 24                	push   $0x24
  801b53:	e8 ca fb ff ff       	call   801722 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b64:	89 01                	mov    %eax,(%ecx)
  801b66:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	c9                   	leave  
  801b6d:	c2 04 00             	ret    $0x4

00801b70 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 10             	pushl  0x10(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	6a 12                	push   $0x12
  801b82:	e8 9b fb ff ff       	call   801722 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8a:	90                   	nop
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 25                	push   $0x25
  801b9c:	e8 81 fb ff ff       	call   801722 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	50                   	push   %eax
  801bbf:	6a 26                	push   $0x26
  801bc1:	e8 5c fb ff ff       	call   801722 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc9:	90                   	nop
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <rsttst>:
void rsttst()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 28                	push   $0x28
  801bdb:	e8 42 fb ff ff       	call   801722 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return ;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	8b 45 14             	mov    0x14(%ebp),%eax
  801bef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf2:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 10             	pushl  0x10(%ebp)
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	6a 27                	push   $0x27
  801c06:	e8 17 fb ff ff       	call   801722 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0e:	90                   	nop
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <chktst>:
void chktst(uint32 n)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 29                	push   $0x29
  801c21:	e8 fc fa ff ff       	call   801722 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <inctst>:

void inctst()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 2a                	push   $0x2a
  801c3b:	e8 e2 fa ff ff       	call   801722 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return ;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <gettst>:
uint32 gettst()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 2b                	push   $0x2b
  801c55:	e8 c8 fa ff ff       	call   801722 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 2c                	push   $0x2c
  801c71:	e8 ac fa ff ff       	call   801722 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
  801c79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c7c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c80:	75 07                	jne    801c89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c82:	b8 01 00 00 00       	mov    $0x1,%eax
  801c87:	eb 05                	jmp    801c8e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 2c                	push   $0x2c
  801ca2:	e8 7b fa ff ff       	call   801722 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
  801caa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cb1:	75 07                	jne    801cba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb8:	eb 05                	jmp    801cbf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 2c                	push   $0x2c
  801cd3:	e8 4a fa ff ff       	call   801722 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
  801cdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cde:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ce2:	75 07                	jne    801ceb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ce4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce9:	eb 05                	jmp    801cf0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 2c                	push   $0x2c
  801d04:	e8 19 fa ff ff       	call   801722 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
  801d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d0f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d13:	75 07                	jne    801d1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d15:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1a:	eb 05                	jmp    801d21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 2d                	push   $0x2d
  801d33:	e8 ea f9 ff ff       	call   801722 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	6a 00                	push   $0x0
  801d50:	53                   	push   %ebx
  801d51:	51                   	push   %ecx
  801d52:	52                   	push   %edx
  801d53:	50                   	push   %eax
  801d54:	6a 2e                	push   $0x2e
  801d56:	e8 c7 f9 ff ff       	call   801722 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 2f                	push   $0x2f
  801d76:	e8 a7 f9 ff ff       	call   801722 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d86:	83 ec 0c             	sub    $0xc,%esp
  801d89:	68 3c 39 80 00       	push   $0x80393c
  801d8e:	e8 c7 e6 ff ff       	call   80045a <cprintf>
  801d93:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	68 68 39 80 00       	push   $0x803968
  801da5:	e8 b0 e6 ff ff       	call   80045a <cprintf>
  801daa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dad:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db1:	a1 38 41 80 00       	mov    0x804138,%eax
  801db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db9:	eb 56                	jmp    801e11 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dbf:	74 1c                	je     801ddd <print_mem_block_lists+0x5d>
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 50 08             	mov    0x8(%eax),%edx
  801dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dca:	8b 48 08             	mov    0x8(%eax),%ecx
  801dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd3:	01 c8                	add    %ecx,%eax
  801dd5:	39 c2                	cmp    %eax,%edx
  801dd7:	73 04                	jae    801ddd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dd9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de0:	8b 50 08             	mov    0x8(%eax),%edx
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	8b 40 0c             	mov    0xc(%eax),%eax
  801de9:	01 c2                	add    %eax,%edx
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 40 08             	mov    0x8(%eax),%eax
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	68 7d 39 80 00       	push   $0x80397d
  801dfb:	e8 5a e6 ff ff       	call   80045a <cprintf>
  801e00:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e09:	a1 40 41 80 00       	mov    0x804140,%eax
  801e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e15:	74 07                	je     801e1e <print_mem_block_lists+0x9e>
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 00                	mov    (%eax),%eax
  801e1c:	eb 05                	jmp    801e23 <print_mem_block_lists+0xa3>
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e23:	a3 40 41 80 00       	mov    %eax,0x804140
  801e28:	a1 40 41 80 00       	mov    0x804140,%eax
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	75 8a                	jne    801dbb <print_mem_block_lists+0x3b>
  801e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e35:	75 84                	jne    801dbb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e37:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e3b:	75 10                	jne    801e4d <print_mem_block_lists+0xcd>
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	68 8c 39 80 00       	push   $0x80398c
  801e45:	e8 10 e6 ff ff       	call   80045a <cprintf>
  801e4a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e54:	83 ec 0c             	sub    $0xc,%esp
  801e57:	68 b0 39 80 00       	push   $0x8039b0
  801e5c:	e8 f9 e5 ff ff       	call   80045a <cprintf>
  801e61:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e64:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e68:	a1 40 40 80 00       	mov    0x804040,%eax
  801e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e70:	eb 56                	jmp    801ec8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e76:	74 1c                	je     801e94 <print_mem_block_lists+0x114>
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	8b 50 08             	mov    0x8(%eax),%edx
  801e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e81:	8b 48 08             	mov    0x8(%eax),%ecx
  801e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e87:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8a:	01 c8                	add    %ecx,%eax
  801e8c:	39 c2                	cmp    %eax,%edx
  801e8e:	73 04                	jae    801e94 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e90:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	8b 50 08             	mov    0x8(%eax),%edx
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea0:	01 c2                	add    %eax,%edx
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea5:	8b 40 08             	mov    0x8(%eax),%eax
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	68 7d 39 80 00       	push   $0x80397d
  801eb2:	e8 a3 e5 ff ff       	call   80045a <cprintf>
  801eb7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ec0:	a1 48 40 80 00       	mov    0x804048,%eax
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecc:	74 07                	je     801ed5 <print_mem_block_lists+0x155>
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 00                	mov    (%eax),%eax
  801ed3:	eb 05                	jmp    801eda <print_mem_block_lists+0x15a>
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	a3 48 40 80 00       	mov    %eax,0x804048
  801edf:	a1 48 40 80 00       	mov    0x804048,%eax
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	75 8a                	jne    801e72 <print_mem_block_lists+0xf2>
  801ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eec:	75 84                	jne    801e72 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eee:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef2:	75 10                	jne    801f04 <print_mem_block_lists+0x184>
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	68 c8 39 80 00       	push   $0x8039c8
  801efc:	e8 59 e5 ff ff       	call   80045a <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	68 3c 39 80 00       	push   $0x80393c
  801f0c:	e8 49 e5 ff ff       	call   80045a <cprintf>
  801f11:	83 c4 10             	add    $0x10,%esp

}
  801f14:	90                   	nop
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801f1d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f24:	00 00 00 
  801f27:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f2e:	00 00 00 
  801f31:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f38:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  801f3b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  801f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f4a:	e9 9e 00 00 00       	jmp    801fed <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801f4f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f57:	c1 e2 04             	shl    $0x4,%edx
  801f5a:	01 d0                	add    %edx,%eax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	75 14                	jne    801f74 <initialize_MemBlocksList+0x5d>
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	68 f0 39 80 00       	push   $0x8039f0
  801f68:	6a 48                	push   $0x48
  801f6a:	68 13 3a 80 00       	push   $0x803a13
  801f6f:	e8 07 10 00 00       	call   802f7b <_panic>
  801f74:	a1 50 40 80 00       	mov    0x804050,%eax
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	c1 e2 04             	shl    $0x4,%edx
  801f7f:	01 d0                	add    %edx,%eax
  801f81:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f87:	89 10                	mov    %edx,(%eax)
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	74 18                	je     801fa7 <initialize_MemBlocksList+0x90>
  801f8f:	a1 48 41 80 00       	mov    0x804148,%eax
  801f94:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f9a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f9d:	c1 e1 04             	shl    $0x4,%ecx
  801fa0:	01 ca                	add    %ecx,%edx
  801fa2:	89 50 04             	mov    %edx,0x4(%eax)
  801fa5:	eb 12                	jmp    801fb9 <initialize_MemBlocksList+0xa2>
  801fa7:	a1 50 40 80 00       	mov    0x804050,%eax
  801fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801faf:	c1 e2 04             	shl    $0x4,%edx
  801fb2:	01 d0                	add    %edx,%eax
  801fb4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fb9:	a1 50 40 80 00       	mov    0x804050,%eax
  801fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc1:	c1 e2 04             	shl    $0x4,%edx
  801fc4:	01 d0                	add    %edx,%eax
  801fc6:	a3 48 41 80 00       	mov    %eax,0x804148
  801fcb:	a1 50 40 80 00       	mov    0x804050,%eax
  801fd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd3:	c1 e2 04             	shl    $0x4,%edx
  801fd6:	01 d0                	add    %edx,%eax
  801fd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fdf:	a1 54 41 80 00       	mov    0x804154,%eax
  801fe4:	40                   	inc    %eax
  801fe5:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  801fea:	ff 45 f4             	incl   -0xc(%ebp)
  801fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ff3:	0f 82 56 ff ff ff    	jb     801f4f <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  801ff9:	90                   	nop
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8b 00                	mov    (%eax),%eax
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80200a:	eb 18                	jmp    802024 <find_block+0x28>
		{
			if(tmp->sva==va)
  80200c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200f:	8b 40 08             	mov    0x8(%eax),%eax
  802012:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802015:	75 05                	jne    80201c <find_block+0x20>
			{
				return tmp;
  802017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201a:	eb 11                	jmp    80202d <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80201c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201f:	8b 00                	mov    (%eax),%eax
  802021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802024:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802028:	75 e2                	jne    80200c <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80202a:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802035:	a1 40 40 80 00       	mov    0x804040,%eax
  80203a:	85 c0                	test   %eax,%eax
  80203c:	0f 85 83 00 00 00    	jne    8020c5 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802042:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802049:	00 00 00 
  80204c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802053:	00 00 00 
  802056:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80205d:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802064:	75 14                	jne    80207a <insert_sorted_allocList+0x4b>
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	68 f0 39 80 00       	push   $0x8039f0
  80206e:	6a 7f                	push   $0x7f
  802070:	68 13 3a 80 00       	push   $0x803a13
  802075:	e8 01 0f 00 00       	call   802f7b <_panic>
  80207a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	89 10                	mov    %edx,(%eax)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	8b 00                	mov    (%eax),%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	74 0d                	je     80209b <insert_sorted_allocList+0x6c>
  80208e:	a1 40 40 80 00       	mov    0x804040,%eax
  802093:	8b 55 08             	mov    0x8(%ebp),%edx
  802096:	89 50 04             	mov    %edx,0x4(%eax)
  802099:	eb 08                	jmp    8020a3 <insert_sorted_allocList+0x74>
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	a3 44 40 80 00       	mov    %eax,0x804044
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020ba:	40                   	inc    %eax
  8020bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020c0:	e9 16 01 00 00       	jmp    8021db <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8b 50 08             	mov    0x8(%eax),%edx
  8020cb:	a1 44 40 80 00       	mov    0x804044,%eax
  8020d0:	8b 40 08             	mov    0x8(%eax),%eax
  8020d3:	39 c2                	cmp    %eax,%edx
  8020d5:	76 68                	jbe    80213f <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8020d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020db:	75 17                	jne    8020f4 <insert_sorted_allocList+0xc5>
  8020dd:	83 ec 04             	sub    $0x4,%esp
  8020e0:	68 2c 3a 80 00       	push   $0x803a2c
  8020e5:	68 85 00 00 00       	push   $0x85
  8020ea:	68 13 3a 80 00       	push   $0x803a13
  8020ef:	e8 87 0e 00 00       	call   802f7b <_panic>
  8020f4:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	89 50 04             	mov    %edx,0x4(%eax)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	8b 40 04             	mov    0x4(%eax),%eax
  802106:	85 c0                	test   %eax,%eax
  802108:	74 0c                	je     802116 <insert_sorted_allocList+0xe7>
  80210a:	a1 44 40 80 00       	mov    0x804044,%eax
  80210f:	8b 55 08             	mov    0x8(%ebp),%edx
  802112:	89 10                	mov    %edx,(%eax)
  802114:	eb 08                	jmp    80211e <insert_sorted_allocList+0xef>
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 40 40 80 00       	mov    %eax,0x804040
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	a3 44 40 80 00       	mov    %eax,0x804044
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80212f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802134:	40                   	inc    %eax
  802135:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80213a:	e9 9c 00 00 00       	jmp    8021db <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80213f:	a1 40 40 80 00       	mov    0x804040,%eax
  802144:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802147:	e9 85 00 00 00       	jmp    8021d1 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 50 08             	mov    0x8(%eax),%edx
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 40 08             	mov    0x8(%eax),%eax
  802158:	39 c2                	cmp    %eax,%edx
  80215a:	73 6d                	jae    8021c9 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80215c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802160:	74 06                	je     802168 <insert_sorted_allocList+0x139>
  802162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802166:	75 17                	jne    80217f <insert_sorted_allocList+0x150>
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 50 3a 80 00       	push   $0x803a50
  802170:	68 90 00 00 00       	push   $0x90
  802175:	68 13 3a 80 00       	push   $0x803a13
  80217a:	e8 fc 0d 00 00       	call   802f7b <_panic>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 50 04             	mov    0x4(%eax),%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802191:	89 10                	mov    %edx,(%eax)
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 40 04             	mov    0x4(%eax),%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 0d                	je     8021aa <insert_sorted_allocList+0x17b>
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 40 04             	mov    0x4(%eax),%eax
  8021a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a6:	89 10                	mov    %edx,(%eax)
  8021a8:	eb 08                	jmp    8021b2 <insert_sorted_allocList+0x183>
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	a3 40 40 80 00       	mov    %eax,0x804040
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b8:	89 50 04             	mov    %edx,0x4(%eax)
  8021bb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c0:	40                   	inc    %eax
  8021c1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021c6:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021c7:	eb 12                	jmp    8021db <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8021d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d5:	0f 85 71 ff ff ff    	jne    80214c <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021db:	90                   	nop
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8021e4:	a1 38 41 80 00       	mov    0x804138,%eax
  8021e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8021ec:	e9 76 01 00 00       	jmp    802367 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021fa:	0f 85 8a 00 00 00    	jne    80228a <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802204:	75 17                	jne    80221d <alloc_block_FF+0x3f>
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 85 3a 80 00       	push   $0x803a85
  80220e:	68 a8 00 00 00       	push   $0xa8
  802213:	68 13 3a 80 00       	push   $0x803a13
  802218:	e8 5e 0d 00 00       	call   802f7b <_panic>
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	85 c0                	test   %eax,%eax
  802224:	74 10                	je     802236 <alloc_block_FF+0x58>
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 00                	mov    (%eax),%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	8b 52 04             	mov    0x4(%edx),%edx
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	eb 0b                	jmp    802241 <alloc_block_FF+0x63>
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	8b 40 04             	mov    0x4(%eax),%eax
  80223c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 40 04             	mov    0x4(%eax),%eax
  802247:	85 c0                	test   %eax,%eax
  802249:	74 0f                	je     80225a <alloc_block_FF+0x7c>
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 40 04             	mov    0x4(%eax),%eax
  802251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802254:	8b 12                	mov    (%edx),%edx
  802256:	89 10                	mov    %edx,(%eax)
  802258:	eb 0a                	jmp    802264 <alloc_block_FF+0x86>
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	a3 38 41 80 00       	mov    %eax,0x804138
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802277:	a1 44 41 80 00       	mov    0x804144,%eax
  80227c:	48                   	dec    %eax
  80227d:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	e9 ea 00 00 00       	jmp    802374 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 40 0c             	mov    0xc(%eax),%eax
  802290:	3b 45 08             	cmp    0x8(%ebp),%eax
  802293:	0f 86 c6 00 00 00    	jbe    80235f <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802299:	a1 48 41 80 00       	mov    0x804148,%eax
  80229e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a7:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 50 08             	mov    0x8(%eax),%edx
  8022b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b3:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8022bf:	89 c2                	mov    %eax,%edx
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 50 08             	mov    0x8(%eax),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	01 c2                	add    %eax,%edx
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8022d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022dc:	75 17                	jne    8022f5 <alloc_block_FF+0x117>
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	68 85 3a 80 00       	push   $0x803a85
  8022e6:	68 b6 00 00 00       	push   $0xb6
  8022eb:	68 13 3a 80 00       	push   $0x803a13
  8022f0:	e8 86 0c 00 00       	call   802f7b <_panic>
  8022f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f8:	8b 00                	mov    (%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 10                	je     80230e <alloc_block_FF+0x130>
  8022fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802306:	8b 52 04             	mov    0x4(%edx),%edx
  802309:	89 50 04             	mov    %edx,0x4(%eax)
  80230c:	eb 0b                	jmp    802319 <alloc_block_FF+0x13b>
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	8b 40 04             	mov    0x4(%eax),%eax
  802314:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231c:	8b 40 04             	mov    0x4(%eax),%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	74 0f                	je     802332 <alloc_block_FF+0x154>
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	8b 40 04             	mov    0x4(%eax),%eax
  802329:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232c:	8b 12                	mov    (%edx),%edx
  80232e:	89 10                	mov    %edx,(%eax)
  802330:	eb 0a                	jmp    80233c <alloc_block_FF+0x15e>
  802332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	a3 48 41 80 00       	mov    %eax,0x804148
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802348:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234f:	a1 54 41 80 00       	mov    0x804154,%eax
  802354:	48                   	dec    %eax
  802355:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	eb 15                	jmp    802374 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 00                	mov    (%eax),%eax
  802364:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236b:	0f 85 80 fe ff ff    	jne    8021f1 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80237c:	a1 38 41 80 00       	mov    0x804138,%eax
  802381:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802384:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80238b:	e9 c0 00 00 00       	jmp    802450 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 40 0c             	mov    0xc(%eax),%eax
  802396:	3b 45 08             	cmp    0x8(%ebp),%eax
  802399:	0f 85 8a 00 00 00    	jne    802429 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80239f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a3:	75 17                	jne    8023bc <alloc_block_BF+0x46>
  8023a5:	83 ec 04             	sub    $0x4,%esp
  8023a8:	68 85 3a 80 00       	push   $0x803a85
  8023ad:	68 cf 00 00 00       	push   $0xcf
  8023b2:	68 13 3a 80 00       	push   $0x803a13
  8023b7:	e8 bf 0b 00 00       	call   802f7b <_panic>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	74 10                	je     8023d5 <alloc_block_BF+0x5f>
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 00                	mov    (%eax),%eax
  8023ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cd:	8b 52 04             	mov    0x4(%edx),%edx
  8023d0:	89 50 04             	mov    %edx,0x4(%eax)
  8023d3:	eb 0b                	jmp    8023e0 <alloc_block_BF+0x6a>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 04             	mov    0x4(%eax),%eax
  8023db:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 04             	mov    0x4(%eax),%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	74 0f                	je     8023f9 <alloc_block_BF+0x83>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 04             	mov    0x4(%eax),%eax
  8023f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f3:	8b 12                	mov    (%edx),%edx
  8023f5:	89 10                	mov    %edx,(%eax)
  8023f7:	eb 0a                	jmp    802403 <alloc_block_BF+0x8d>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	a3 38 41 80 00       	mov    %eax,0x804138
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802416:	a1 44 41 80 00       	mov    0x804144,%eax
  80241b:	48                   	dec    %eax
  80241c:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	e9 2a 01 00 00       	jmp    802553 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 40 0c             	mov    0xc(%eax),%eax
  80242f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802432:	73 14                	jae    802448 <alloc_block_BF+0xd2>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 0c             	mov    0xc(%eax),%eax
  80243a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243d:	76 09                	jbe    802448 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 0c             	mov    0xc(%eax),%eax
  802445:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802450:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802454:	0f 85 36 ff ff ff    	jne    802390 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80245a:	a1 38 41 80 00       	mov    0x804138,%eax
  80245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802462:	e9 dd 00 00 00       	jmp    802544 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 40 0c             	mov    0xc(%eax),%eax
  80246d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802470:	0f 85 c6 00 00 00    	jne    80253c <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802476:	a1 48 41 80 00       	mov    0x804148,%eax
  80247b:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 50 08             	mov    0x8(%eax),%edx
  802484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802487:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80248a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248d:	8b 55 08             	mov    0x8(%ebp),%edx
  802490:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 50 08             	mov    0x8(%eax),%edx
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	01 c2                	add    %eax,%edx
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ad:	89 c2                	mov    %eax,%edx
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8024b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024b9:	75 17                	jne    8024d2 <alloc_block_BF+0x15c>
  8024bb:	83 ec 04             	sub    $0x4,%esp
  8024be:	68 85 3a 80 00       	push   $0x803a85
  8024c3:	68 eb 00 00 00       	push   $0xeb
  8024c8:	68 13 3a 80 00       	push   $0x803a13
  8024cd:	e8 a9 0a 00 00       	call   802f7b <_panic>
  8024d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	74 10                	je     8024eb <alloc_block_BF+0x175>
  8024db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e3:	8b 52 04             	mov    0x4(%edx),%edx
  8024e6:	89 50 04             	mov    %edx,0x4(%eax)
  8024e9:	eb 0b                	jmp    8024f6 <alloc_block_BF+0x180>
  8024eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	8b 40 04             	mov    0x4(%eax),%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 0f                	je     80250f <alloc_block_BF+0x199>
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802509:	8b 12                	mov    (%edx),%edx
  80250b:	89 10                	mov    %edx,(%eax)
  80250d:	eb 0a                	jmp    802519 <alloc_block_BF+0x1a3>
  80250f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	a3 48 41 80 00       	mov    %eax,0x804148
  802519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252c:	a1 54 41 80 00       	mov    0x804154,%eax
  802531:	48                   	dec    %eax
  802532:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	eb 17                	jmp    802553 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802548:	0f 85 19 ff ff ff    	jne    802467 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80255b:	a1 40 40 80 00       	mov    0x804040,%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	75 19                	jne    80257d <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802564:	83 ec 0c             	sub    $0xc,%esp
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	e8 6f fc ff ff       	call   8021de <alloc_block_FF>
  80256f:	83 c4 10             	add    $0x10,%esp
  802572:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	e9 e9 01 00 00       	jmp    802766 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80257d:	a1 44 40 80 00       	mov    0x804044,%eax
  802582:	8b 40 08             	mov    0x8(%eax),%eax
  802585:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802588:	a1 44 40 80 00       	mov    0x804044,%eax
  80258d:	8b 50 0c             	mov    0xc(%eax),%edx
  802590:	a1 44 40 80 00       	mov    0x804044,%eax
  802595:	8b 40 08             	mov    0x8(%eax),%eax
  802598:	01 d0                	add    %edx,%eax
  80259a:	83 ec 08             	sub    $0x8,%esp
  80259d:	50                   	push   %eax
  80259e:	68 38 41 80 00       	push   $0x804138
  8025a3:	e8 54 fa ff ff       	call   801ffc <find_block>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b7:	0f 85 9b 00 00 00    	jne    802658 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 50 0c             	mov    0xc(%eax),%edx
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 08             	mov    0x8(%eax),%eax
  8025c9:	01 d0                	add    %edx,%eax
  8025cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	75 17                	jne    8025eb <alloc_block_NF+0x96>
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	68 85 3a 80 00       	push   $0x803a85
  8025dc:	68 1a 01 00 00       	push   $0x11a
  8025e1:	68 13 3a 80 00       	push   $0x803a13
  8025e6:	e8 90 09 00 00       	call   802f7b <_panic>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	74 10                	je     802604 <alloc_block_NF+0xaf>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fc:	8b 52 04             	mov    0x4(%edx),%edx
  8025ff:	89 50 04             	mov    %edx,0x4(%eax)
  802602:	eb 0b                	jmp    80260f <alloc_block_NF+0xba>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 04             	mov    0x4(%eax),%eax
  80260a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	74 0f                	je     802628 <alloc_block_NF+0xd3>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 04             	mov    0x4(%eax),%eax
  80261f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802622:	8b 12                	mov    (%edx),%edx
  802624:	89 10                	mov    %edx,(%eax)
  802626:	eb 0a                	jmp    802632 <alloc_block_NF+0xdd>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	a3 38 41 80 00       	mov    %eax,0x804138
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802645:	a1 44 41 80 00       	mov    0x804144,%eax
  80264a:	48                   	dec    %eax
  80264b:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	e9 0e 01 00 00       	jmp    802766 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 0c             	mov    0xc(%eax),%eax
  80265e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802661:	0f 86 cf 00 00 00    	jbe    802736 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802667:	a1 48 41 80 00       	mov    0x804148,%eax
  80266c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80266f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802672:	8b 55 08             	mov    0x8(%ebp),%edx
  802675:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 50 08             	mov    0x8(%eax),%edx
  80267e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802681:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 50 08             	mov    0x8(%eax),%edx
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	01 c2                	add    %eax,%edx
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 0c             	mov    0xc(%eax),%eax
  80269b:	2b 45 08             	sub    0x8(%ebp),%eax
  80269e:	89 c2                	mov    %eax,%edx
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 08             	mov    0x8(%eax),%eax
  8026ac:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8026af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026b3:	75 17                	jne    8026cc <alloc_block_NF+0x177>
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	68 85 3a 80 00       	push   $0x803a85
  8026bd:	68 28 01 00 00       	push   $0x128
  8026c2:	68 13 3a 80 00       	push   $0x803a13
  8026c7:	e8 af 08 00 00       	call   802f7b <_panic>
  8026cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	85 c0                	test   %eax,%eax
  8026d3:	74 10                	je     8026e5 <alloc_block_NF+0x190>
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026dd:	8b 52 04             	mov    0x4(%edx),%edx
  8026e0:	89 50 04             	mov    %edx,0x4(%eax)
  8026e3:	eb 0b                	jmp    8026f0 <alloc_block_NF+0x19b>
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	8b 40 04             	mov    0x4(%eax),%eax
  8026eb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	74 0f                	je     802709 <alloc_block_NF+0x1b4>
  8026fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802703:	8b 12                	mov    (%edx),%edx
  802705:	89 10                	mov    %edx,(%eax)
  802707:	eb 0a                	jmp    802713 <alloc_block_NF+0x1be>
  802709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	a3 48 41 80 00       	mov    %eax,0x804148
  802713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802716:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802726:	a1 54 41 80 00       	mov    0x804154,%eax
  80272b:	48                   	dec    %eax
  80272c:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	eb 30                	jmp    802766 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802736:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80273b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80273e:	75 0a                	jne    80274a <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802740:	a1 38 41 80 00       	mov    0x804138,%eax
  802745:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802748:	eb 08                	jmp    802752 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 08             	mov    0x8(%eax),%eax
  802758:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80275b:	0f 85 4d fe ff ff    	jne    8025ae <alloc_block_NF+0x59>

			return NULL;
  802761:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	53                   	push   %ebx
  80276c:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80276f:	a1 38 41 80 00       	mov    0x804138,%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	0f 85 86 00 00 00    	jne    802802 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80277c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802783:	00 00 00 
  802786:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80278d:	00 00 00 
  802790:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802797:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80279a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279e:	75 17                	jne    8027b7 <insert_sorted_with_merge_freeList+0x4f>
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	68 f0 39 80 00       	push   $0x8039f0
  8027a8:	68 48 01 00 00       	push   $0x148
  8027ad:	68 13 3a 80 00       	push   $0x803a13
  8027b2:	e8 c4 07 00 00       	call   802f7b <_panic>
  8027b7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	89 10                	mov    %edx,(%eax)
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0d                	je     8027d8 <insert_sorted_with_merge_freeList+0x70>
  8027cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8027d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d3:	89 50 04             	mov    %edx,0x4(%eax)
  8027d6:	eb 08                	jmp    8027e0 <insert_sorted_with_merge_freeList+0x78>
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8027f7:	40                   	inc    %eax
  8027f8:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8027fd:	e9 73 07 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	8b 50 08             	mov    0x8(%eax),%edx
  802808:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80280d:	8b 40 08             	mov    0x8(%eax),%eax
  802810:	39 c2                	cmp    %eax,%edx
  802812:	0f 86 84 00 00 00    	jbe    80289c <insert_sorted_with_merge_freeList+0x134>
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	8b 50 08             	mov    0x8(%eax),%edx
  80281e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802823:	8b 48 0c             	mov    0xc(%eax),%ecx
  802826:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	01 c8                	add    %ecx,%eax
  802830:	39 c2                	cmp    %eax,%edx
  802832:	74 68                	je     80289c <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802834:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802838:	75 17                	jne    802851 <insert_sorted_with_merge_freeList+0xe9>
  80283a:	83 ec 04             	sub    $0x4,%esp
  80283d:	68 2c 3a 80 00       	push   $0x803a2c
  802842:	68 4c 01 00 00       	push   $0x14c
  802847:	68 13 3a 80 00       	push   $0x803a13
  80284c:	e8 2a 07 00 00       	call   802f7b <_panic>
  802851:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	89 50 04             	mov    %edx,0x4(%eax)
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0c                	je     802873 <insert_sorted_with_merge_freeList+0x10b>
  802867:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80286c:	8b 55 08             	mov    0x8(%ebp),%edx
  80286f:	89 10                	mov    %edx,(%eax)
  802871:	eb 08                	jmp    80287b <insert_sorted_with_merge_freeList+0x113>
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	a3 38 41 80 00       	mov    %eax,0x804138
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288c:	a1 44 41 80 00       	mov    0x804144,%eax
  802891:	40                   	inc    %eax
  802892:	a3 44 41 80 00       	mov    %eax,0x804144
  802897:	e9 d9 06 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	8b 50 08             	mov    0x8(%eax),%edx
  8028a2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028a7:	8b 40 08             	mov    0x8(%eax),%eax
  8028aa:	39 c2                	cmp    %eax,%edx
  8028ac:	0f 86 b5 00 00 00    	jbe    802967 <insert_sorted_with_merge_freeList+0x1ff>
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 50 08             	mov    0x8(%eax),%edx
  8028b8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028bd:	8b 48 0c             	mov    0xc(%eax),%ecx
  8028c0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028c5:	8b 40 08             	mov    0x8(%eax),%eax
  8028c8:	01 c8                	add    %ecx,%eax
  8028ca:	39 c2                	cmp    %eax,%edx
  8028cc:	0f 85 95 00 00 00    	jne    802967 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8028d2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028d7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8028dd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8028e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e3:	8b 52 0c             	mov    0xc(%edx),%edx
  8028e6:	01 ca                	add    %ecx,%edx
  8028e8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8028ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802903:	75 17                	jne    80291c <insert_sorted_with_merge_freeList+0x1b4>
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 f0 39 80 00       	push   $0x8039f0
  80290d:	68 54 01 00 00       	push   $0x154
  802912:	68 13 3a 80 00       	push   $0x803a13
  802917:	e8 5f 06 00 00       	call   802f7b <_panic>
  80291c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	89 10                	mov    %edx,(%eax)
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	74 0d                	je     80293d <insert_sorted_with_merge_freeList+0x1d5>
  802930:	a1 48 41 80 00       	mov    0x804148,%eax
  802935:	8b 55 08             	mov    0x8(%ebp),%edx
  802938:	89 50 04             	mov    %edx,0x4(%eax)
  80293b:	eb 08                	jmp    802945 <insert_sorted_with_merge_freeList+0x1dd>
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	a3 48 41 80 00       	mov    %eax,0x804148
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802957:	a1 54 41 80 00       	mov    0x804154,%eax
  80295c:	40                   	inc    %eax
  80295d:	a3 54 41 80 00       	mov    %eax,0x804154
  802962:	e9 0e 06 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	a1 38 41 80 00       	mov    0x804138,%eax
  802972:	8b 40 08             	mov    0x8(%eax),%eax
  802975:	39 c2                	cmp    %eax,%edx
  802977:	0f 83 c1 00 00 00    	jae    802a3e <insert_sorted_with_merge_freeList+0x2d6>
  80297d:	a1 38 41 80 00       	mov    0x804138,%eax
  802982:	8b 50 08             	mov    0x8(%eax),%edx
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	8b 48 08             	mov    0x8(%eax),%ecx
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	01 c8                	add    %ecx,%eax
  802993:	39 c2                	cmp    %eax,%edx
  802995:	0f 85 a3 00 00 00    	jne    802a3e <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80299b:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a3:	8b 52 08             	mov    0x8(%edx),%edx
  8029a6:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8029a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ae:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8029bd:	01 ca                	add    %ecx,%edx
  8029bf:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029da:	75 17                	jne    8029f3 <insert_sorted_with_merge_freeList+0x28b>
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	68 f0 39 80 00       	push   $0x8039f0
  8029e4:	68 5d 01 00 00       	push   $0x15d
  8029e9:	68 13 3a 80 00       	push   $0x803a13
  8029ee:	e8 88 05 00 00       	call   802f7b <_panic>
  8029f3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	89 10                	mov    %edx,(%eax)
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0d                	je     802a14 <insert_sorted_with_merge_freeList+0x2ac>
  802a07:	a1 48 41 80 00       	mov    0x804148,%eax
  802a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%eax)
  802a12:	eb 08                	jmp    802a1c <insert_sorted_with_merge_freeList+0x2b4>
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a33:	40                   	inc    %eax
  802a34:	a3 54 41 80 00       	mov    %eax,0x804154
  802a39:	e9 37 05 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	8b 50 08             	mov    0x8(%eax),%edx
  802a44:	a1 38 41 80 00       	mov    0x804138,%eax
  802a49:	8b 40 08             	mov    0x8(%eax),%eax
  802a4c:	39 c2                	cmp    %eax,%edx
  802a4e:	0f 83 82 00 00 00    	jae    802ad6 <insert_sorted_with_merge_freeList+0x36e>
  802a54:	a1 38 41 80 00       	mov    0x804138,%eax
  802a59:	8b 50 08             	mov    0x8(%eax),%edx
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 48 08             	mov    0x8(%eax),%ecx
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	8b 40 0c             	mov    0xc(%eax),%eax
  802a68:	01 c8                	add    %ecx,%eax
  802a6a:	39 c2                	cmp    %eax,%edx
  802a6c:	74 68                	je     802ad6 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a72:	75 17                	jne    802a8b <insert_sorted_with_merge_freeList+0x323>
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	68 f0 39 80 00       	push   $0x8039f0
  802a7c:	68 62 01 00 00       	push   $0x162
  802a81:	68 13 3a 80 00       	push   $0x803a13
  802a86:	e8 f0 04 00 00       	call   802f7b <_panic>
  802a8b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	89 10                	mov    %edx,(%eax)
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	74 0d                	je     802aac <insert_sorted_with_merge_freeList+0x344>
  802a9f:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa7:	89 50 04             	mov    %edx,0x4(%eax)
  802aaa:	eb 08                	jmp    802ab4 <insert_sorted_with_merge_freeList+0x34c>
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 38 41 80 00       	mov    %eax,0x804138
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac6:	a1 44 41 80 00       	mov    0x804144,%eax
  802acb:	40                   	inc    %eax
  802acc:	a3 44 41 80 00       	mov    %eax,0x804144
  802ad1:	e9 9f 04 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802ad6:	a1 38 41 80 00       	mov    0x804138,%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802ae0:	e9 84 04 00 00       	jmp    802f69 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 50 08             	mov    0x8(%eax),%edx
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	8b 40 08             	mov    0x8(%eax),%eax
  802af1:	39 c2                	cmp    %eax,%edx
  802af3:	0f 86 a9 00 00 00    	jbe    802ba2 <insert_sorted_with_merge_freeList+0x43a>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 50 08             	mov    0x8(%eax),%edx
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 48 08             	mov    0x8(%eax),%ecx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	01 c8                	add    %ecx,%eax
  802b0d:	39 c2                	cmp    %eax,%edx
  802b0f:	0f 84 8d 00 00 00    	je     802ba2 <insert_sorted_with_merge_freeList+0x43a>
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 50 08             	mov    0x8(%eax),%edx
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	8b 48 08             	mov    0x8(%eax),%ecx
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2d:	01 c8                	add    %ecx,%eax
  802b2f:	39 c2                	cmp    %eax,%edx
  802b31:	74 6f                	je     802ba2 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b37:	74 06                	je     802b3f <insert_sorted_with_merge_freeList+0x3d7>
  802b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3d:	75 17                	jne    802b56 <insert_sorted_with_merge_freeList+0x3ee>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 50 3a 80 00       	push   $0x803a50
  802b47:	68 6b 01 00 00       	push   $0x16b
  802b4c:	68 13 3a 80 00       	push   $0x803a13
  802b51:	e8 25 04 00 00       	call   802f7b <_panic>
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 50 04             	mov    0x4(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	89 50 04             	mov    %edx,0x4(%eax)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b68:	89 10                	mov    %edx,(%eax)
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 0d                	je     802b81 <insert_sorted_with_merge_freeList+0x419>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7d:	89 10                	mov    %edx,(%eax)
  802b7f:	eb 08                	jmp    802b89 <insert_sorted_with_merge_freeList+0x421>
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	a3 38 41 80 00       	mov    %eax,0x804138
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8f:	89 50 04             	mov    %edx,0x4(%eax)
  802b92:	a1 44 41 80 00       	mov    0x804144,%eax
  802b97:	40                   	inc    %eax
  802b98:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802b9d:	e9 d3 03 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	39 c2                	cmp    %eax,%edx
  802bb0:	0f 86 da 00 00 00    	jbe    802c90 <insert_sorted_with_merge_freeList+0x528>
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 48 08             	mov    0x8(%eax),%ecx
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	01 c8                	add    %ecx,%eax
  802bca:	39 c2                	cmp    %eax,%edx
  802bcc:	0f 85 be 00 00 00    	jne    802c90 <insert_sorted_with_merge_freeList+0x528>
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 40 04             	mov    0x4(%eax),%eax
  802bde:	8b 48 08             	mov    0x8(%eax),%ecx
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	01 c8                	add    %ecx,%eax
  802bec:	39 c2                	cmp    %eax,%edx
  802bee:	0f 84 9c 00 00 00    	je     802c90 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	8b 50 08             	mov    0x8(%eax),%edx
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 50 0c             	mov    0xc(%eax),%edx
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0c:	01 c2                	add    %eax,%edx
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2c:	75 17                	jne    802c45 <insert_sorted_with_merge_freeList+0x4dd>
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 f0 39 80 00       	push   $0x8039f0
  802c36:	68 74 01 00 00       	push   $0x174
  802c3b:	68 13 3a 80 00       	push   $0x803a13
  802c40:	e8 36 03 00 00       	call   802f7b <_panic>
  802c45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 0d                	je     802c66 <insert_sorted_with_merge_freeList+0x4fe>
  802c59:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c61:	89 50 04             	mov    %edx,0x4(%eax)
  802c64:	eb 08                	jmp    802c6e <insert_sorted_with_merge_freeList+0x506>
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 48 41 80 00       	mov    %eax,0x804148
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c80:	a1 54 41 80 00       	mov    0x804154,%eax
  802c85:	40                   	inc    %eax
  802c86:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802c8b:	e9 e5 02 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 50 08             	mov    0x8(%eax),%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	8b 40 08             	mov    0x8(%eax),%eax
  802c9c:	39 c2                	cmp    %eax,%edx
  802c9e:	0f 86 d7 00 00 00    	jbe    802d7b <insert_sorted_with_merge_freeList+0x613>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	01 c8                	add    %ecx,%eax
  802cb8:	39 c2                	cmp    %eax,%edx
  802cba:	0f 84 bb 00 00 00    	je     802d7b <insert_sorted_with_merge_freeList+0x613>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 50 08             	mov    0x8(%eax),%edx
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 48 08             	mov    0x8(%eax),%ecx
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	01 c8                	add    %ecx,%eax
  802cda:	39 c2                	cmp    %eax,%edx
  802cdc:	0f 85 99 00 00 00    	jne    802d7b <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf7:	01 c2                	add    %eax,%edx
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d17:	75 17                	jne    802d30 <insert_sorted_with_merge_freeList+0x5c8>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 f0 39 80 00       	push   $0x8039f0
  802d21:	68 7d 01 00 00       	push   $0x17d
  802d26:	68 13 3a 80 00       	push   $0x803a13
  802d2b:	e8 4b 02 00 00       	call   802f7b <_panic>
  802d30:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	74 0d                	je     802d51 <insert_sorted_with_merge_freeList+0x5e9>
  802d44:	a1 48 41 80 00       	mov    0x804148,%eax
  802d49:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	eb 08                	jmp    802d59 <insert_sorted_with_merge_freeList+0x5f1>
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d70:	40                   	inc    %eax
  802d71:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d76:	e9 fa 01 00 00       	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 50 08             	mov    0x8(%eax),%edx
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	8b 40 08             	mov    0x8(%eax),%eax
  802d87:	39 c2                	cmp    %eax,%edx
  802d89:	0f 86 d2 01 00 00    	jbe    802f61 <insert_sorted_with_merge_freeList+0x7f9>
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 50 08             	mov    0x8(%eax),%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 48 08             	mov    0x8(%eax),%ecx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	01 c8                	add    %ecx,%eax
  802da3:	39 c2                	cmp    %eax,%edx
  802da5:	0f 85 b6 01 00 00    	jne    802f61 <insert_sorted_with_merge_freeList+0x7f9>
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	8b 48 08             	mov    0x8(%eax),%ecx
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	01 c8                	add    %ecx,%eax
  802dc5:	39 c2                	cmp    %eax,%edx
  802dc7:	0f 85 94 01 00 00    	jne    802f61 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd6:	8b 52 04             	mov    0x4(%edx),%edx
  802dd9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddf:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de5:	8b 52 0c             	mov    0xc(%edx),%edx
  802de8:	01 da                	add    %ebx,%edx
  802dea:	01 ca                	add    %ecx,%edx
  802dec:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802e03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e07:	75 17                	jne    802e20 <insert_sorted_with_merge_freeList+0x6b8>
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 85 3a 80 00       	push   $0x803a85
  802e11:	68 86 01 00 00       	push   $0x186
  802e16:	68 13 3a 80 00       	push   $0x803a13
  802e1b:	e8 5b 01 00 00       	call   802f7b <_panic>
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 10                	je     802e39 <insert_sorted_with_merge_freeList+0x6d1>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e31:	8b 52 04             	mov    0x4(%edx),%edx
  802e34:	89 50 04             	mov    %edx,0x4(%eax)
  802e37:	eb 0b                	jmp    802e44 <insert_sorted_with_merge_freeList+0x6dc>
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 40 04             	mov    0x4(%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 0f                	je     802e5d <insert_sorted_with_merge_freeList+0x6f5>
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e57:	8b 12                	mov    (%edx),%edx
  802e59:	89 10                	mov    %edx,(%eax)
  802e5b:	eb 0a                	jmp    802e67 <insert_sorted_with_merge_freeList+0x6ff>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	a3 38 41 80 00       	mov    %eax,0x804138
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7a:	a1 44 41 80 00       	mov    0x804144,%eax
  802e7f:	48                   	dec    %eax
  802e80:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e89:	75 17                	jne    802ea2 <insert_sorted_with_merge_freeList+0x73a>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 f0 39 80 00       	push   $0x8039f0
  802e93:	68 87 01 00 00       	push   $0x187
  802e98:	68 13 3a 80 00       	push   $0x803a13
  802e9d:	e8 d9 00 00 00       	call   802f7b <_panic>
  802ea2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	89 10                	mov    %edx,(%eax)
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 0d                	je     802ec3 <insert_sorted_with_merge_freeList+0x75b>
  802eb6:	a1 48 41 80 00       	mov    0x804148,%eax
  802ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebe:	89 50 04             	mov    %edx,0x4(%eax)
  802ec1:	eb 08                	jmp    802ecb <insert_sorted_with_merge_freeList+0x763>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edd:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee2:	40                   	inc    %eax
  802ee3:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802efc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f00:	75 17                	jne    802f19 <insert_sorted_with_merge_freeList+0x7b1>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 f0 39 80 00       	push   $0x8039f0
  802f0a:	68 8a 01 00 00       	push   $0x18a
  802f0f:	68 13 3a 80 00       	push   $0x803a13
  802f14:	e8 62 00 00 00       	call   802f7b <_panic>
  802f19:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0d                	je     802f3a <insert_sorted_with_merge_freeList+0x7d2>
  802f2d:	a1 48 41 80 00       	mov    0x804148,%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 08                	jmp    802f42 <insert_sorted_with_merge_freeList+0x7da>
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 48 41 80 00       	mov    %eax,0x804148
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f54:	a1 54 41 80 00       	mov    0x804154,%eax
  802f59:	40                   	inc    %eax
  802f5a:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  802f5f:	eb 14                	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  802f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6d:	0f 85 72 fb ff ff    	jne    802ae5 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802f73:	eb 00                	jmp    802f75 <insert_sorted_with_merge_freeList+0x80d>
  802f75:	90                   	nop
  802f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
  802f7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f81:	8d 45 10             	lea    0x10(%ebp),%eax
  802f84:	83 c0 04             	add    $0x4,%eax
  802f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f8a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 16                	je     802fa9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f93:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f98:	83 ec 08             	sub    $0x8,%esp
  802f9b:	50                   	push   %eax
  802f9c:	68 a4 3a 80 00       	push   $0x803aa4
  802fa1:	e8 b4 d4 ff ff       	call   80045a <cprintf>
  802fa6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802fa9:	a1 00 40 80 00       	mov    0x804000,%eax
  802fae:	ff 75 0c             	pushl  0xc(%ebp)
  802fb1:	ff 75 08             	pushl  0x8(%ebp)
  802fb4:	50                   	push   %eax
  802fb5:	68 a9 3a 80 00       	push   $0x803aa9
  802fba:	e8 9b d4 ff ff       	call   80045a <cprintf>
  802fbf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  802fc5:	83 ec 08             	sub    $0x8,%esp
  802fc8:	ff 75 f4             	pushl  -0xc(%ebp)
  802fcb:	50                   	push   %eax
  802fcc:	e8 1e d4 ff ff       	call   8003ef <vcprintf>
  802fd1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802fd4:	83 ec 08             	sub    $0x8,%esp
  802fd7:	6a 00                	push   $0x0
  802fd9:	68 c5 3a 80 00       	push   $0x803ac5
  802fde:	e8 0c d4 ff ff       	call   8003ef <vcprintf>
  802fe3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802fe6:	e8 8d d3 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  802feb:	eb fe                	jmp    802feb <_panic+0x70>

00802fed <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
  802ff0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802ff3:	a1 20 40 80 00       	mov    0x804020,%eax
  802ff8:	8b 50 74             	mov    0x74(%eax),%edx
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	39 c2                	cmp    %eax,%edx
  803000:	74 14                	je     803016 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	68 c8 3a 80 00       	push   $0x803ac8
  80300a:	6a 26                	push   $0x26
  80300c:	68 14 3b 80 00       	push   $0x803b14
  803011:	e8 65 ff ff ff       	call   802f7b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80301d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803024:	e9 c2 00 00 00       	jmp    8030eb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	01 d0                	add    %edx,%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	75 08                	jne    803046 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80303e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803041:	e9 a2 00 00 00       	jmp    8030e8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80304d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803054:	eb 69                	jmp    8030bf <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803056:	a1 20 40 80 00       	mov    0x804020,%eax
  80305b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803061:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803064:	89 d0                	mov    %edx,%eax
  803066:	01 c0                	add    %eax,%eax
  803068:	01 d0                	add    %edx,%eax
  80306a:	c1 e0 03             	shl    $0x3,%eax
  80306d:	01 c8                	add    %ecx,%eax
  80306f:	8a 40 04             	mov    0x4(%eax),%al
  803072:	84 c0                	test   %al,%al
  803074:	75 46                	jne    8030bc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803076:	a1 20 40 80 00       	mov    0x804020,%eax
  80307b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803081:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803084:	89 d0                	mov    %edx,%eax
  803086:	01 c0                	add    %eax,%eax
  803088:	01 d0                	add    %edx,%eax
  80308a:	c1 e0 03             	shl    $0x3,%eax
  80308d:	01 c8                	add    %ecx,%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803097:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80309c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80309e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	01 c8                	add    %ecx,%eax
  8030ad:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030af:	39 c2                	cmp    %eax,%edx
  8030b1:	75 09                	jne    8030bc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8030b3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8030ba:	eb 12                	jmp    8030ce <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030bc:	ff 45 e8             	incl   -0x18(%ebp)
  8030bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8030c4:	8b 50 74             	mov    0x74(%eax),%edx
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	77 88                	ja     803056 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8030ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030d2:	75 14                	jne    8030e8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 20 3b 80 00       	push   $0x803b20
  8030dc:	6a 3a                	push   $0x3a
  8030de:	68 14 3b 80 00       	push   $0x803b14
  8030e3:	e8 93 fe ff ff       	call   802f7b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030e8:	ff 45 f0             	incl   -0x10(%ebp)
  8030eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030f1:	0f 8c 32 ff ff ff    	jl     803029 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803105:	eb 26                	jmp    80312d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803107:	a1 20 40 80 00       	mov    0x804020,%eax
  80310c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803112:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803115:	89 d0                	mov    %edx,%eax
  803117:	01 c0                	add    %eax,%eax
  803119:	01 d0                	add    %edx,%eax
  80311b:	c1 e0 03             	shl    $0x3,%eax
  80311e:	01 c8                	add    %ecx,%eax
  803120:	8a 40 04             	mov    0x4(%eax),%al
  803123:	3c 01                	cmp    $0x1,%al
  803125:	75 03                	jne    80312a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803127:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80312a:	ff 45 e0             	incl   -0x20(%ebp)
  80312d:	a1 20 40 80 00       	mov    0x804020,%eax
  803132:	8b 50 74             	mov    0x74(%eax),%edx
  803135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	77 cb                	ja     803107 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803142:	74 14                	je     803158 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803144:	83 ec 04             	sub    $0x4,%esp
  803147:	68 74 3b 80 00       	push   $0x803b74
  80314c:	6a 44                	push   $0x44
  80314e:	68 14 3b 80 00       	push   $0x803b14
  803153:	e8 23 fe ff ff       	call   802f7b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803158:	90                   	nop
  803159:	c9                   	leave  
  80315a:	c3                   	ret    
  80315b:	90                   	nop

0080315c <__udivdi3>:
  80315c:	55                   	push   %ebp
  80315d:	57                   	push   %edi
  80315e:	56                   	push   %esi
  80315f:	53                   	push   %ebx
  803160:	83 ec 1c             	sub    $0x1c,%esp
  803163:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803167:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80316b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803173:	89 ca                	mov    %ecx,%edx
  803175:	89 f8                	mov    %edi,%eax
  803177:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80317b:	85 f6                	test   %esi,%esi
  80317d:	75 2d                	jne    8031ac <__udivdi3+0x50>
  80317f:	39 cf                	cmp    %ecx,%edi
  803181:	77 65                	ja     8031e8 <__udivdi3+0x8c>
  803183:	89 fd                	mov    %edi,%ebp
  803185:	85 ff                	test   %edi,%edi
  803187:	75 0b                	jne    803194 <__udivdi3+0x38>
  803189:	b8 01 00 00 00       	mov    $0x1,%eax
  80318e:	31 d2                	xor    %edx,%edx
  803190:	f7 f7                	div    %edi
  803192:	89 c5                	mov    %eax,%ebp
  803194:	31 d2                	xor    %edx,%edx
  803196:	89 c8                	mov    %ecx,%eax
  803198:	f7 f5                	div    %ebp
  80319a:	89 c1                	mov    %eax,%ecx
  80319c:	89 d8                	mov    %ebx,%eax
  80319e:	f7 f5                	div    %ebp
  8031a0:	89 cf                	mov    %ecx,%edi
  8031a2:	89 fa                	mov    %edi,%edx
  8031a4:	83 c4 1c             	add    $0x1c,%esp
  8031a7:	5b                   	pop    %ebx
  8031a8:	5e                   	pop    %esi
  8031a9:	5f                   	pop    %edi
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	39 ce                	cmp    %ecx,%esi
  8031ae:	77 28                	ja     8031d8 <__udivdi3+0x7c>
  8031b0:	0f bd fe             	bsr    %esi,%edi
  8031b3:	83 f7 1f             	xor    $0x1f,%edi
  8031b6:	75 40                	jne    8031f8 <__udivdi3+0x9c>
  8031b8:	39 ce                	cmp    %ecx,%esi
  8031ba:	72 0a                	jb     8031c6 <__udivdi3+0x6a>
  8031bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031c0:	0f 87 9e 00 00 00    	ja     803264 <__udivdi3+0x108>
  8031c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031cb:	89 fa                	mov    %edi,%edx
  8031cd:	83 c4 1c             	add    $0x1c,%esp
  8031d0:	5b                   	pop    %ebx
  8031d1:	5e                   	pop    %esi
  8031d2:	5f                   	pop    %edi
  8031d3:	5d                   	pop    %ebp
  8031d4:	c3                   	ret    
  8031d5:	8d 76 00             	lea    0x0(%esi),%esi
  8031d8:	31 ff                	xor    %edi,%edi
  8031da:	31 c0                	xor    %eax,%eax
  8031dc:	89 fa                	mov    %edi,%edx
  8031de:	83 c4 1c             	add    $0x1c,%esp
  8031e1:	5b                   	pop    %ebx
  8031e2:	5e                   	pop    %esi
  8031e3:	5f                   	pop    %edi
  8031e4:	5d                   	pop    %ebp
  8031e5:	c3                   	ret    
  8031e6:	66 90                	xchg   %ax,%ax
  8031e8:	89 d8                	mov    %ebx,%eax
  8031ea:	f7 f7                	div    %edi
  8031ec:	31 ff                	xor    %edi,%edi
  8031ee:	89 fa                	mov    %edi,%edx
  8031f0:	83 c4 1c             	add    $0x1c,%esp
  8031f3:	5b                   	pop    %ebx
  8031f4:	5e                   	pop    %esi
  8031f5:	5f                   	pop    %edi
  8031f6:	5d                   	pop    %ebp
  8031f7:	c3                   	ret    
  8031f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031fd:	89 eb                	mov    %ebp,%ebx
  8031ff:	29 fb                	sub    %edi,%ebx
  803201:	89 f9                	mov    %edi,%ecx
  803203:	d3 e6                	shl    %cl,%esi
  803205:	89 c5                	mov    %eax,%ebp
  803207:	88 d9                	mov    %bl,%cl
  803209:	d3 ed                	shr    %cl,%ebp
  80320b:	89 e9                	mov    %ebp,%ecx
  80320d:	09 f1                	or     %esi,%ecx
  80320f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803213:	89 f9                	mov    %edi,%ecx
  803215:	d3 e0                	shl    %cl,%eax
  803217:	89 c5                	mov    %eax,%ebp
  803219:	89 d6                	mov    %edx,%esi
  80321b:	88 d9                	mov    %bl,%cl
  80321d:	d3 ee                	shr    %cl,%esi
  80321f:	89 f9                	mov    %edi,%ecx
  803221:	d3 e2                	shl    %cl,%edx
  803223:	8b 44 24 08          	mov    0x8(%esp),%eax
  803227:	88 d9                	mov    %bl,%cl
  803229:	d3 e8                	shr    %cl,%eax
  80322b:	09 c2                	or     %eax,%edx
  80322d:	89 d0                	mov    %edx,%eax
  80322f:	89 f2                	mov    %esi,%edx
  803231:	f7 74 24 0c          	divl   0xc(%esp)
  803235:	89 d6                	mov    %edx,%esi
  803237:	89 c3                	mov    %eax,%ebx
  803239:	f7 e5                	mul    %ebp
  80323b:	39 d6                	cmp    %edx,%esi
  80323d:	72 19                	jb     803258 <__udivdi3+0xfc>
  80323f:	74 0b                	je     80324c <__udivdi3+0xf0>
  803241:	89 d8                	mov    %ebx,%eax
  803243:	31 ff                	xor    %edi,%edi
  803245:	e9 58 ff ff ff       	jmp    8031a2 <__udivdi3+0x46>
  80324a:	66 90                	xchg   %ax,%ax
  80324c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803250:	89 f9                	mov    %edi,%ecx
  803252:	d3 e2                	shl    %cl,%edx
  803254:	39 c2                	cmp    %eax,%edx
  803256:	73 e9                	jae    803241 <__udivdi3+0xe5>
  803258:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80325b:	31 ff                	xor    %edi,%edi
  80325d:	e9 40 ff ff ff       	jmp    8031a2 <__udivdi3+0x46>
  803262:	66 90                	xchg   %ax,%ax
  803264:	31 c0                	xor    %eax,%eax
  803266:	e9 37 ff ff ff       	jmp    8031a2 <__udivdi3+0x46>
  80326b:	90                   	nop

0080326c <__umoddi3>:
  80326c:	55                   	push   %ebp
  80326d:	57                   	push   %edi
  80326e:	56                   	push   %esi
  80326f:	53                   	push   %ebx
  803270:	83 ec 1c             	sub    $0x1c,%esp
  803273:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803277:	8b 74 24 34          	mov    0x34(%esp),%esi
  80327b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80327f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803283:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803287:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80328b:	89 f3                	mov    %esi,%ebx
  80328d:	89 fa                	mov    %edi,%edx
  80328f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803293:	89 34 24             	mov    %esi,(%esp)
  803296:	85 c0                	test   %eax,%eax
  803298:	75 1a                	jne    8032b4 <__umoddi3+0x48>
  80329a:	39 f7                	cmp    %esi,%edi
  80329c:	0f 86 a2 00 00 00    	jbe    803344 <__umoddi3+0xd8>
  8032a2:	89 c8                	mov    %ecx,%eax
  8032a4:	89 f2                	mov    %esi,%edx
  8032a6:	f7 f7                	div    %edi
  8032a8:	89 d0                	mov    %edx,%eax
  8032aa:	31 d2                	xor    %edx,%edx
  8032ac:	83 c4 1c             	add    $0x1c,%esp
  8032af:	5b                   	pop    %ebx
  8032b0:	5e                   	pop    %esi
  8032b1:	5f                   	pop    %edi
  8032b2:	5d                   	pop    %ebp
  8032b3:	c3                   	ret    
  8032b4:	39 f0                	cmp    %esi,%eax
  8032b6:	0f 87 ac 00 00 00    	ja     803368 <__umoddi3+0xfc>
  8032bc:	0f bd e8             	bsr    %eax,%ebp
  8032bf:	83 f5 1f             	xor    $0x1f,%ebp
  8032c2:	0f 84 ac 00 00 00    	je     803374 <__umoddi3+0x108>
  8032c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8032cd:	29 ef                	sub    %ebp,%edi
  8032cf:	89 fe                	mov    %edi,%esi
  8032d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032d5:	89 e9                	mov    %ebp,%ecx
  8032d7:	d3 e0                	shl    %cl,%eax
  8032d9:	89 d7                	mov    %edx,%edi
  8032db:	89 f1                	mov    %esi,%ecx
  8032dd:	d3 ef                	shr    %cl,%edi
  8032df:	09 c7                	or     %eax,%edi
  8032e1:	89 e9                	mov    %ebp,%ecx
  8032e3:	d3 e2                	shl    %cl,%edx
  8032e5:	89 14 24             	mov    %edx,(%esp)
  8032e8:	89 d8                	mov    %ebx,%eax
  8032ea:	d3 e0                	shl    %cl,%eax
  8032ec:	89 c2                	mov    %eax,%edx
  8032ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032f2:	d3 e0                	shl    %cl,%eax
  8032f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032fc:	89 f1                	mov    %esi,%ecx
  8032fe:	d3 e8                	shr    %cl,%eax
  803300:	09 d0                	or     %edx,%eax
  803302:	d3 eb                	shr    %cl,%ebx
  803304:	89 da                	mov    %ebx,%edx
  803306:	f7 f7                	div    %edi
  803308:	89 d3                	mov    %edx,%ebx
  80330a:	f7 24 24             	mull   (%esp)
  80330d:	89 c6                	mov    %eax,%esi
  80330f:	89 d1                	mov    %edx,%ecx
  803311:	39 d3                	cmp    %edx,%ebx
  803313:	0f 82 87 00 00 00    	jb     8033a0 <__umoddi3+0x134>
  803319:	0f 84 91 00 00 00    	je     8033b0 <__umoddi3+0x144>
  80331f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803323:	29 f2                	sub    %esi,%edx
  803325:	19 cb                	sbb    %ecx,%ebx
  803327:	89 d8                	mov    %ebx,%eax
  803329:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80332d:	d3 e0                	shl    %cl,%eax
  80332f:	89 e9                	mov    %ebp,%ecx
  803331:	d3 ea                	shr    %cl,%edx
  803333:	09 d0                	or     %edx,%eax
  803335:	89 e9                	mov    %ebp,%ecx
  803337:	d3 eb                	shr    %cl,%ebx
  803339:	89 da                	mov    %ebx,%edx
  80333b:	83 c4 1c             	add    $0x1c,%esp
  80333e:	5b                   	pop    %ebx
  80333f:	5e                   	pop    %esi
  803340:	5f                   	pop    %edi
  803341:	5d                   	pop    %ebp
  803342:	c3                   	ret    
  803343:	90                   	nop
  803344:	89 fd                	mov    %edi,%ebp
  803346:	85 ff                	test   %edi,%edi
  803348:	75 0b                	jne    803355 <__umoddi3+0xe9>
  80334a:	b8 01 00 00 00       	mov    $0x1,%eax
  80334f:	31 d2                	xor    %edx,%edx
  803351:	f7 f7                	div    %edi
  803353:	89 c5                	mov    %eax,%ebp
  803355:	89 f0                	mov    %esi,%eax
  803357:	31 d2                	xor    %edx,%edx
  803359:	f7 f5                	div    %ebp
  80335b:	89 c8                	mov    %ecx,%eax
  80335d:	f7 f5                	div    %ebp
  80335f:	89 d0                	mov    %edx,%eax
  803361:	e9 44 ff ff ff       	jmp    8032aa <__umoddi3+0x3e>
  803366:	66 90                	xchg   %ax,%ax
  803368:	89 c8                	mov    %ecx,%eax
  80336a:	89 f2                	mov    %esi,%edx
  80336c:	83 c4 1c             	add    $0x1c,%esp
  80336f:	5b                   	pop    %ebx
  803370:	5e                   	pop    %esi
  803371:	5f                   	pop    %edi
  803372:	5d                   	pop    %ebp
  803373:	c3                   	ret    
  803374:	3b 04 24             	cmp    (%esp),%eax
  803377:	72 06                	jb     80337f <__umoddi3+0x113>
  803379:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80337d:	77 0f                	ja     80338e <__umoddi3+0x122>
  80337f:	89 f2                	mov    %esi,%edx
  803381:	29 f9                	sub    %edi,%ecx
  803383:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803387:	89 14 24             	mov    %edx,(%esp)
  80338a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80338e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803392:	8b 14 24             	mov    (%esp),%edx
  803395:	83 c4 1c             	add    $0x1c,%esp
  803398:	5b                   	pop    %ebx
  803399:	5e                   	pop    %esi
  80339a:	5f                   	pop    %edi
  80339b:	5d                   	pop    %ebp
  80339c:	c3                   	ret    
  80339d:	8d 76 00             	lea    0x0(%esi),%esi
  8033a0:	2b 04 24             	sub    (%esp),%eax
  8033a3:	19 fa                	sbb    %edi,%edx
  8033a5:	89 d1                	mov    %edx,%ecx
  8033a7:	89 c6                	mov    %eax,%esi
  8033a9:	e9 71 ff ff ff       	jmp    80331f <__umoddi3+0xb3>
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033b4:	72 ea                	jb     8033a0 <__umoddi3+0x134>
  8033b6:	89 d9                	mov    %ebx,%ecx
  8033b8:	e9 62 ff ff ff       	jmp    80331f <__umoddi3+0xb3>
