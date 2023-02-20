
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
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
  800045:	68 20 34 80 00       	push   $0x803420
  80004a:	e8 3c 16 00 00       	call   80168b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 22 34 80 00       	push   $0x803422
  80006e:	e8 18 16 00 00       	call   80168b <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 29 34 80 00       	push   $0x803429
  8000ab:	e8 3f 1a 00 00       	call   801aef <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 2b 34 80 00       	push   $0x80342b
  8000bf:	e8 c7 15 00 00       	call   80168b <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 39 34 80 00       	push   $0x803439
  8000f1:	e8 0a 1b 00 00       	call   801c00 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 43 34 80 00       	push   $0x803443
  80011a:	e8 e1 1a 00 00       	call   801c00 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 4d 34 80 00       	push   $0x80344d
  800139:	6a 27                	push   $0x27
  80013b:	68 62 34 80 00       	push   $0x803462
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 ce 1a 00 00       	call   801c1e <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 9b 2f 00 00       	call   8030fb <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 b0 1a 00 00       	call   801c1e <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 7d 34 80 00       	push   $0x80347d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 f0 1a 00 00       	call   801c87 <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 2b 34 80 00       	push   $0x80342b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 97 15 00 00       	call   80174e <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 72 1a 00 00       	call   801c3a <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 64 1a 00 00       	call   801c3a <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 79 1a 00 00       	call   801c6e <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 1b 18 00 00       	call   801a7b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ac 34 80 00       	push   $0x8034ac
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 d4 34 80 00       	push   $0x8034d4
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 fc 34 80 00       	push   $0x8034fc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 54 35 80 00       	push   $0x803554
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 ac 34 80 00       	push   $0x8034ac
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 9b 17 00 00       	call   801a95 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 28 19 00 00       	call   801c3a <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 7d 19 00 00       	call   801ca0 <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 68 35 80 00       	push   $0x803568
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 6d 35 80 00       	push   $0x80356d
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 89 35 80 00       	push   $0x803589
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 8c 35 80 00       	push   $0x80358c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 d8 35 80 00       	push   $0x8035d8
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 e4 35 80 00       	push   $0x8035e4
  800487:	6a 3a                	push   $0x3a
  800489:	68 d8 35 80 00       	push   $0x8035d8
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 38 36 80 00       	push   $0x803638
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 d8 35 80 00       	push   $0x8035d8
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 40 80 00       	mov    0x804024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 7c 13 00 00       	call   8018cd <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 05 13 00 00       	call   8018cd <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 69 14 00 00       	call   801a7b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 63 14 00 00       	call   801a95 <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 34 2b 00 00       	call   8031b0 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 f4 2b 00 00       	call   8032c0 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 b4 38 80 00       	add    $0x8038b4,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 c5 38 80 00       	push   $0x8038c5
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 ce 38 80 00       	push   $0x8038ce
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 30 3a 80 00       	push   $0x803a30
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80139b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013a2:	00 00 00 
  8013a5:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ac:	00 00 00 
  8013af:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013b6:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8013b9:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013c0:	00 00 00 
  8013c3:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ca:	00 00 00 
  8013cd:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013d4:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8013d7:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013de:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8013e1:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013e8:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fc:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801401:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	2d 00 10 00 00       	sub    $0x1000,%eax
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	6a 06                	push   $0x6
  80141a:	ff 75 f4             	pushl  -0xc(%ebp)
  80141d:	50                   	push   %eax
  80141e:	e8 ee 05 00 00       	call   801a11 <sys_allocate_chunk>
  801423:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801426:	a1 20 41 80 00       	mov    0x804120,%eax
  80142b:	83 ec 0c             	sub    $0xc,%esp
  80142e:	50                   	push   %eax
  80142f:	e8 63 0c 00 00       	call   802097 <initialize_MemBlocksList>
  801434:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801437:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80143c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80143f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801442:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144c:	8b 40 0c             	mov    0xc(%eax),%eax
  80144f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801455:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80145a:	89 c2                	mov    %eax,%edx
  80145c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145f:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801465:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80146c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801476:	8b 50 08             	mov    0x8(%eax),%edx
  801479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	48                   	dec    %eax
  80147f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801482:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	f7 75 e0             	divl   -0x20(%ebp)
  80148d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801490:	29 d0                	sub    %edx,%eax
  801492:	89 c2                	mov    %eax,%edx
  801494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801497:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80149a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80149e:	75 14                	jne    8014b4 <initialize_dyn_block_system+0x11f>
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	68 55 3a 80 00       	push   $0x803a55
  8014a8:	6a 34                	push   $0x34
  8014aa:	68 73 3a 80 00       	push   $0x803a73
  8014af:	e8 72 ee ff ff       	call   800326 <_panic>
  8014b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b7:	8b 00                	mov    (%eax),%eax
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	74 10                	je     8014cd <initialize_dyn_block_system+0x138>
  8014bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014c5:	8b 52 04             	mov    0x4(%edx),%edx
  8014c8:	89 50 04             	mov    %edx,0x4(%eax)
  8014cb:	eb 0b                	jmp    8014d8 <initialize_dyn_block_system+0x143>
  8014cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d0:	8b 40 04             	mov    0x4(%eax),%eax
  8014d3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014db:	8b 40 04             	mov    0x4(%eax),%eax
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	74 0f                	je     8014f1 <initialize_dyn_block_system+0x15c>
  8014e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014e5:	8b 40 04             	mov    0x4(%eax),%eax
  8014e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014eb:	8b 12                	mov    (%edx),%edx
  8014ed:	89 10                	mov    %edx,(%eax)
  8014ef:	eb 0a                	jmp    8014fb <initialize_dyn_block_system+0x166>
  8014f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	a3 48 41 80 00       	mov    %eax,0x804148
  8014fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801507:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80150e:	a1 54 41 80 00       	mov    0x804154,%eax
  801513:	48                   	dec    %eax
  801514:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 e8             	pushl  -0x18(%ebp)
  80151f:	e8 c4 13 00 00       	call   8028e8 <insert_sorted_with_merge_freeList>
  801524:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <malloc>:
//=================================



void* malloc(uint32 size)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801530:	e8 2f fe ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801535:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801539:	75 07                	jne    801542 <malloc+0x18>
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	eb 71                	jmp    8015b3 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801542:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801549:	76 07                	jbe    801552 <malloc+0x28>
	return NULL;
  80154b:	b8 00 00 00 00       	mov    $0x0,%eax
  801550:	eb 61                	jmp    8015b3 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801552:	e8 88 08 00 00       	call   801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801557:	85 c0                	test   %eax,%eax
  801559:	74 53                	je     8015ae <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80155b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801562:	8b 55 08             	mov    0x8(%ebp),%edx
  801565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801568:	01 d0                	add    %edx,%eax
  80156a:	48                   	dec    %eax
  80156b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	ba 00 00 00 00       	mov    $0x0,%edx
  801576:	f7 75 f4             	divl   -0xc(%ebp)
  801579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157c:	29 d0                	sub    %edx,%eax
  80157e:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801581:	83 ec 0c             	sub    $0xc,%esp
  801584:	ff 75 ec             	pushl  -0x14(%ebp)
  801587:	e8 d2 0d 00 00       	call   80235e <alloc_block_FF>
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801592:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801596:	74 16                	je     8015ae <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	ff 75 e8             	pushl  -0x18(%ebp)
  80159e:	e8 0c 0c 00 00       	call   8021af <insert_sorted_allocList>
  8015a3:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8015a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a9:	8b 40 08             	mov    0x8(%eax),%eax
  8015ac:	eb 05                	jmp    8015b3 <malloc+0x89>
    }

			}


	return NULL;
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d2:	68 40 40 80 00       	push   $0x804040
  8015d7:	e8 a0 0b 00 00       	call   80217c <find_block>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8015e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	52                   	push   %edx
  8015ef:	50                   	push   %eax
  8015f0:	e8 e4 03 00 00       	call   8019d9 <sys_free_user_mem>
  8015f5:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8015f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015fc:	75 17                	jne    801615 <free+0x60>
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 55 3a 80 00       	push   $0x803a55
  801606:	68 84 00 00 00       	push   $0x84
  80160b:	68 73 3a 80 00       	push   $0x803a73
  801610:	e8 11 ed ff ff       	call   800326 <_panic>
  801615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	85 c0                	test   %eax,%eax
  80161c:	74 10                	je     80162e <free+0x79>
  80161e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801621:	8b 00                	mov    (%eax),%eax
  801623:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801626:	8b 52 04             	mov    0x4(%edx),%edx
  801629:	89 50 04             	mov    %edx,0x4(%eax)
  80162c:	eb 0b                	jmp    801639 <free+0x84>
  80162e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801631:	8b 40 04             	mov    0x4(%eax),%eax
  801634:	a3 44 40 80 00       	mov    %eax,0x804044
  801639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163c:	8b 40 04             	mov    0x4(%eax),%eax
  80163f:	85 c0                	test   %eax,%eax
  801641:	74 0f                	je     801652 <free+0x9d>
  801643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801646:	8b 40 04             	mov    0x4(%eax),%eax
  801649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80164c:	8b 12                	mov    (%edx),%edx
  80164e:	89 10                	mov    %edx,(%eax)
  801650:	eb 0a                	jmp    80165c <free+0xa7>
  801652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	a3 40 40 80 00       	mov    %eax,0x804040
  80165c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80166f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801674:	48                   	dec    %eax
  801675:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	ff 75 ec             	pushl  -0x14(%ebp)
  801680:	e8 63 12 00 00       	call   8028e8 <insert_sorted_with_merge_freeList>
  801685:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 38             	sub    $0x38,%esp
  801691:	8b 45 10             	mov    0x10(%ebp),%eax
  801694:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801697:	e8 c8 fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  80169c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a0:	75 0a                	jne    8016ac <smalloc+0x21>
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a7:	e9 a0 00 00 00       	jmp    80174c <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016ac:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016b3:	76 0a                	jbe    8016bf <smalloc+0x34>
		return NULL;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	e9 8d 00 00 00       	jmp    80174c <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016bf:	e8 1b 07 00 00       	call   801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	74 7f                	je     801747 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016c8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	48                   	dec    %eax
  8016d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	f7 75 f4             	divl   -0xc(%ebp)
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	29 d0                	sub    %edx,%eax
  8016eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8016ee:	83 ec 0c             	sub    $0xc,%esp
  8016f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f4:	e8 65 0c 00 00       	call   80235e <alloc_block_FF>
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8016ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801703:	74 42                	je     801747 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	ff 75 e8             	pushl  -0x18(%ebp)
  80170b:	e8 9f 0a 00 00       	call   8021af <insert_sorted_allocList>
  801710:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801716:	8b 40 08             	mov    0x8(%eax),%eax
  801719:	89 c2                	mov    %eax,%edx
  80171b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80171f:	52                   	push   %edx
  801720:	50                   	push   %eax
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	e8 38 04 00 00       	call   801b64 <sys_createSharedObject>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801736:	79 07                	jns    80173f <smalloc+0xb4>
	    		  return NULL;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
  80173d:	eb 0d                	jmp    80174c <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80173f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801742:	8b 40 08             	mov    0x8(%eax),%eax
  801745:	eb 05                	jmp    80174c <smalloc+0xc1>


				}


		return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801754:	e8 0b fc ff ff       	call   801364 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801759:	e8 81 06 00 00       	call   801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>
  80175e:	85 c0                	test   %eax,%eax
  801760:	0f 84 9f 00 00 00    	je     801805 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	e8 1a 04 00 00       	call   801b8e <sys_getSizeOfSharedObject>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80177a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80177e:	79 0a                	jns    80178a <sget+0x3c>
		return NULL;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
  801785:	e9 80 00 00 00       	jmp    80180a <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80178a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	48                   	dec    %eax
  80179a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80179d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	f7 75 f0             	divl   -0x10(%ebp)
  8017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ab:	29 d0                	sub    %edx,%eax
  8017ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b6:	e8 a3 0b 00 00       	call   80235e <alloc_block_FF>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8017c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017c5:	74 3e                	je     801805 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8017c7:	83 ec 0c             	sub    $0xc,%esp
  8017ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017cd:	e8 dd 09 00 00       	call   8021af <insert_sorted_allocList>
  8017d2:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8017d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d8:	8b 40 08             	mov    0x8(%eax),%eax
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	50                   	push   %eax
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	ff 75 08             	pushl  0x8(%ebp)
  8017e5:	e8 c1 03 00 00       	call   801bab <sys_getSharedObject>
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8017f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017f4:	79 07                	jns    8017fd <sget+0xaf>
	    		  return NULL;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	eb 0d                	jmp    80180a <sget+0xbc>
	  	return(void*) returned_block->sva;
  8017fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801800:	8b 40 08             	mov    0x8(%eax),%eax
  801803:	eb 05                	jmp    80180a <sget+0xbc>
	      }
	}
	   return NULL;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801812:	e8 4d fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	68 80 3a 80 00       	push   $0x803a80
  80181f:	68 12 01 00 00       	push   $0x112
  801824:	68 73 3a 80 00       	push   $0x803a73
  801829:	e8 f8 ea ff ff       	call   800326 <_panic>

0080182e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 a8 3a 80 00       	push   $0x803aa8
  80183c:	68 26 01 00 00       	push   $0x126
  801841:	68 73 3a 80 00       	push   $0x803a73
  801846:	e8 db ea ff ff       	call   800326 <_panic>

0080184b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	68 cc 3a 80 00       	push   $0x803acc
  801859:	68 31 01 00 00       	push   $0x131
  80185e:	68 73 3a 80 00       	push   $0x803a73
  801863:	e8 be ea ff ff       	call   800326 <_panic>

00801868 <shrink>:

}
void shrink(uint32 newSize)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	68 cc 3a 80 00       	push   $0x803acc
  801876:	68 36 01 00 00       	push   $0x136
  80187b:	68 73 3a 80 00       	push   $0x803a73
  801880:	e8 a1 ea ff ff       	call   800326 <_panic>

00801885 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	68 cc 3a 80 00       	push   $0x803acc
  801893:	68 3b 01 00 00       	push   $0x13b
  801898:	68 73 3a 80 00       	push   $0x803a73
  80189d:	e8 84 ea ff ff       	call   800326 <_panic>

008018a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018bd:	cd 30                	int    $0x30
  8018bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	5b                   	pop    %ebx
  8018c9:	5e                   	pop    %esi
  8018ca:	5f                   	pop    %edi
  8018cb:	5d                   	pop    %ebp
  8018cc:	c3                   	ret    

008018cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	50                   	push   %eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	e8 b2 ff ff ff       	call   8018a2 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	90                   	nop
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 01                	push   $0x1
  801905:	e8 98 ff ff ff       	call   8018a2 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801912:	8b 55 0c             	mov    0xc(%ebp),%edx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 05                	push   $0x5
  801922:	e8 7b ff ff ff       	call   8018a2 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801931:	8b 75 18             	mov    0x18(%ebp),%esi
  801934:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801937:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	51                   	push   %ecx
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 06                	push   $0x6
  801947:	e8 56 ff ff ff       	call   8018a2 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 07                	push   $0x7
  801969:	e8 34 ff ff ff       	call   8018a2 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 08                	push   $0x8
  801984:	e8 19 ff ff ff       	call   8018a2 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 09                	push   $0x9
  80199d:	e8 00 ff ff ff       	call   8018a2 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 0a                	push   $0xa
  8019b6:	e8 e7 fe ff ff       	call   8018a2 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 0b                	push   $0xb
  8019cf:	e8 ce fe ff ff       	call   8018a2 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 0f                	push   $0xf
  8019ea:	e8 b3 fe ff ff       	call   8018a2 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
	return;
  8019f2:	90                   	nop
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	ff 75 08             	pushl  0x8(%ebp)
  801a04:	6a 10                	push   $0x10
  801a06:	e8 97 fe ff ff       	call   8018a2 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0e:	90                   	nop
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	ff 75 10             	pushl  0x10(%ebp)
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	6a 11                	push   $0x11
  801a23:	e8 7a fe ff ff       	call   8018a2 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2b:	90                   	nop
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 0c                	push   $0xc
  801a3d:	e8 60 fe ff ff       	call   8018a2 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	6a 0d                	push   $0xd
  801a57:	e8 46 fe ff ff       	call   8018a2 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 0e                	push   $0xe
  801a70:	e8 2d fe ff ff       	call   8018a2 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 13                	push   $0x13
  801a8a:	e8 13 fe ff ff       	call   8018a2 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 14                	push   $0x14
  801aa4:	e8 f9 fd ff ff       	call   8018a2 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_cputc>:


void
sys_cputc(const char c)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801abb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	50                   	push   %eax
  801ac8:	6a 15                	push   $0x15
  801aca:	e8 d3 fd ff ff       	call   8018a2 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	90                   	nop
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 16                	push   $0x16
  801ae4:	e8 b9 fd ff ff       	call   8018a2 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	6a 17                	push   $0x17
  801b01:	e8 9c fd ff ff       	call   8018a2 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 1a                	push   $0x1a
  801b1e:	e8 7f fd ff ff       	call   8018a2 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	6a 18                	push   $0x18
  801b3b:	e8 62 fd ff ff       	call   8018a2 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	90                   	nop
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 19                	push   $0x19
  801b59:	e8 44 fd ff ff       	call   8018a2 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	51                   	push   %ecx
  801b7d:	52                   	push   %edx
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	6a 1b                	push   $0x1b
  801b84:	e8 19 fd ff ff       	call   8018a2 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	52                   	push   %edx
  801b9e:	50                   	push   %eax
  801b9f:	6a 1c                	push   $0x1c
  801ba1:	e8 fc fc ff ff       	call   8018a2 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	51                   	push   %ecx
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 1d                	push   $0x1d
  801bc0:	e8 dd fc ff ff       	call   8018a2 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 1e                	push   $0x1e
  801bdd:	e8 c0 fc ff ff       	call   8018a2 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 1f                	push   $0x1f
  801bf6:	e8 a7 fc ff ff       	call   8018a2 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 14             	pushl  0x14(%ebp)
  801c0b:	ff 75 10             	pushl  0x10(%ebp)
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	50                   	push   %eax
  801c12:	6a 20                	push   $0x20
  801c14:	e8 89 fc ff ff       	call   8018a2 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	50                   	push   %eax
  801c2d:	6a 21                	push   $0x21
  801c2f:	e8 6e fc ff ff       	call   8018a2 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	90                   	nop
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	50                   	push   %eax
  801c49:	6a 22                	push   $0x22
  801c4b:	e8 52 fc ff ff       	call   8018a2 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 02                	push   $0x2
  801c64:	e8 39 fc ff ff       	call   8018a2 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 03                	push   $0x3
  801c7d:	e8 20 fc ff ff       	call   8018a2 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 04                	push   $0x4
  801c96:	e8 07 fc ff ff       	call   8018a2 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 23                	push   $0x23
  801caf:	e8 ee fb ff ff       	call   8018a2 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc3:	8d 50 04             	lea    0x4(%eax),%edx
  801cc6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 24                	push   $0x24
  801cd3:	e8 ca fb ff ff       	call   8018a2 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return result;
  801cdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ce4:	89 01                	mov    %eax,(%ecx)
  801ce6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	c9                   	leave  
  801ced:	c2 04 00             	ret    $0x4

00801cf0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	ff 75 10             	pushl  0x10(%ebp)
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	ff 75 08             	pushl  0x8(%ebp)
  801d00:	6a 12                	push   $0x12
  801d02:	e8 9b fb ff ff       	call   8018a2 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0a:	90                   	nop
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 25                	push   $0x25
  801d1c:	e8 81 fb ff ff       	call   8018a2 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d32:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	50                   	push   %eax
  801d3f:	6a 26                	push   $0x26
  801d41:	e8 5c fb ff ff       	call   8018a2 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return ;
  801d49:	90                   	nop
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <rsttst>:
void rsttst()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 28                	push   $0x28
  801d5b:	e8 42 fb ff ff       	call   8018a2 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
	return ;
  801d63:	90                   	nop
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 04             	sub    $0x4,%esp
  801d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d72:	8b 55 18             	mov    0x18(%ebp),%edx
  801d75:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d79:	52                   	push   %edx
  801d7a:	50                   	push   %eax
  801d7b:	ff 75 10             	pushl  0x10(%ebp)
  801d7e:	ff 75 0c             	pushl  0xc(%ebp)
  801d81:	ff 75 08             	pushl  0x8(%ebp)
  801d84:	6a 27                	push   $0x27
  801d86:	e8 17 fb ff ff       	call   8018a2 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <chktst>:
void chktst(uint32 n)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	6a 29                	push   $0x29
  801da1:	e8 fc fa ff ff       	call   8018a2 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
	return ;
  801da9:	90                   	nop
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <inctst>:

void inctst()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 2a                	push   $0x2a
  801dbb:	e8 e2 fa ff ff       	call   8018a2 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <gettst>:
uint32 gettst()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 2b                	push   $0x2b
  801dd5:	e8 c8 fa ff ff       	call   8018a2 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 2c                	push   $0x2c
  801df1:	e8 ac fa ff ff       	call   8018a2 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
  801df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dfc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e00:	75 07                	jne    801e09 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	eb 05                	jmp    801e0e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 2c                	push   $0x2c
  801e22:	e8 7b fa ff ff       	call   8018a2 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e2d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 2c                	push   $0x2c
  801e53:	e8 4a fa ff ff       	call   8018a2 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e5e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e62:	75 07                	jne    801e6b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e64:	b8 01 00 00 00       	mov    $0x1,%eax
  801e69:	eb 05                	jmp    801e70 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 2c                	push   $0x2c
  801e84:	e8 19 fa ff ff       	call   8018a2 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
  801e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e8f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e93:	75 07                	jne    801e9c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	eb 05                	jmp    801ea1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	6a 2d                	push   $0x2d
  801eb3:	e8 ea f9 ff ff       	call   8018a2 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	53                   	push   %ebx
  801ed1:	51                   	push   %ecx
  801ed2:	52                   	push   %edx
  801ed3:	50                   	push   %eax
  801ed4:	6a 2e                	push   $0x2e
  801ed6:	e8 c7 f9 ff ff       	call   8018a2 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	6a 2f                	push   $0x2f
  801ef6:	e8 a7 f9 ff ff       	call   8018a2 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	68 dc 3a 80 00       	push   $0x803adc
  801f0e:	e8 c7 e6 ff ff       	call   8005da <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	68 08 3b 80 00       	push   $0x803b08
  801f25:	e8 b0 e6 ff ff       	call   8005da <cprintf>
  801f2a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f2d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f31:	a1 38 41 80 00       	mov    0x804138,%eax
  801f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f39:	eb 56                	jmp    801f91 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3f:	74 1c                	je     801f5d <print_mem_block_lists+0x5d>
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	8b 50 08             	mov    0x8(%eax),%edx
  801f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	01 c8                	add    %ecx,%eax
  801f55:	39 c2                	cmp    %eax,%edx
  801f57:	73 04                	jae    801f5d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f59:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 50 08             	mov    0x8(%eax),%edx
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 40 0c             	mov    0xc(%eax),%eax
  801f69:	01 c2                	add    %eax,%edx
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 40 08             	mov    0x8(%eax),%eax
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	52                   	push   %edx
  801f75:	50                   	push   %eax
  801f76:	68 1d 3b 80 00       	push   $0x803b1d
  801f7b:	e8 5a e6 ff ff       	call   8005da <cprintf>
  801f80:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f89:	a1 40 41 80 00       	mov    0x804140,%eax
  801f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f95:	74 07                	je     801f9e <print_mem_block_lists+0x9e>
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	eb 05                	jmp    801fa3 <print_mem_block_lists+0xa3>
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	a3 40 41 80 00       	mov    %eax,0x804140
  801fa8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fad:	85 c0                	test   %eax,%eax
  801faf:	75 8a                	jne    801f3b <print_mem_block_lists+0x3b>
  801fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb5:	75 84                	jne    801f3b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fb7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbb:	75 10                	jne    801fcd <print_mem_block_lists+0xcd>
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 2c 3b 80 00       	push   $0x803b2c
  801fc5:	e8 10 e6 ff ff       	call   8005da <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	68 50 3b 80 00       	push   $0x803b50
  801fdc:	e8 f9 e5 ff ff       	call   8005da <cprintf>
  801fe1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fe4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe8:	a1 40 40 80 00       	mov    0x804040,%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff0:	eb 56                	jmp    802048 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff6:	74 1c                	je     802014 <print_mem_block_lists+0x114>
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	8b 50 08             	mov    0x8(%eax),%edx
  801ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802001:	8b 48 08             	mov    0x8(%eax),%ecx
  802004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802007:	8b 40 0c             	mov    0xc(%eax),%eax
  80200a:	01 c8                	add    %ecx,%eax
  80200c:	39 c2                	cmp    %eax,%edx
  80200e:	73 04                	jae    802014 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802010:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 50 08             	mov    0x8(%eax),%edx
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 40 0c             	mov    0xc(%eax),%eax
  802020:	01 c2                	add    %eax,%edx
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 40 08             	mov    0x8(%eax),%eax
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	52                   	push   %edx
  80202c:	50                   	push   %eax
  80202d:	68 1d 3b 80 00       	push   $0x803b1d
  802032:	e8 a3 e5 ff ff       	call   8005da <cprintf>
  802037:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802040:	a1 48 40 80 00       	mov    0x804048,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204c:	74 07                	je     802055 <print_mem_block_lists+0x155>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	eb 05                	jmp    80205a <print_mem_block_lists+0x15a>
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	a3 48 40 80 00       	mov    %eax,0x804048
  80205f:	a1 48 40 80 00       	mov    0x804048,%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	75 8a                	jne    801ff2 <print_mem_block_lists+0xf2>
  802068:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206c:	75 84                	jne    801ff2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80206e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802072:	75 10                	jne    802084 <print_mem_block_lists+0x184>
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	68 68 3b 80 00       	push   $0x803b68
  80207c:	e8 59 e5 ff ff       	call   8005da <cprintf>
  802081:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	68 dc 3a 80 00       	push   $0x803adc
  80208c:	e8 49 e5 ff ff       	call   8005da <cprintf>
  802091:	83 c4 10             	add    $0x10,%esp

}
  802094:	90                   	nop
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80209d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020a4:	00 00 00 
  8020a7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020ae:	00 00 00 
  8020b1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020b8:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8020bb:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8020c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ca:	e9 9e 00 00 00       	jmp    80216d <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020cf:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d7:	c1 e2 04             	shl    $0x4,%edx
  8020da:	01 d0                	add    %edx,%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	75 14                	jne    8020f4 <initialize_MemBlocksList+0x5d>
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	68 90 3b 80 00       	push   $0x803b90
  8020e8:	6a 48                	push   $0x48
  8020ea:	68 b3 3b 80 00       	push   $0x803bb3
  8020ef:	e8 32 e2 ff ff       	call   800326 <_panic>
  8020f4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fc:	c1 e2 04             	shl    $0x4,%edx
  8020ff:	01 d0                	add    %edx,%eax
  802101:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802107:	89 10                	mov    %edx,(%eax)
  802109:	8b 00                	mov    (%eax),%eax
  80210b:	85 c0                	test   %eax,%eax
  80210d:	74 18                	je     802127 <initialize_MemBlocksList+0x90>
  80210f:	a1 48 41 80 00       	mov    0x804148,%eax
  802114:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80211a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80211d:	c1 e1 04             	shl    $0x4,%ecx
  802120:	01 ca                	add    %ecx,%edx
  802122:	89 50 04             	mov    %edx,0x4(%eax)
  802125:	eb 12                	jmp    802139 <initialize_MemBlocksList+0xa2>
  802127:	a1 50 40 80 00       	mov    0x804050,%eax
  80212c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212f:	c1 e2 04             	shl    $0x4,%edx
  802132:	01 d0                	add    %edx,%eax
  802134:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802139:	a1 50 40 80 00       	mov    0x804050,%eax
  80213e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802141:	c1 e2 04             	shl    $0x4,%edx
  802144:	01 d0                	add    %edx,%eax
  802146:	a3 48 41 80 00       	mov    %eax,0x804148
  80214b:	a1 50 40 80 00       	mov    0x804050,%eax
  802150:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802153:	c1 e2 04             	shl    $0x4,%edx
  802156:	01 d0                	add    %edx,%eax
  802158:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215f:	a1 54 41 80 00       	mov    0x804154,%eax
  802164:	40                   	inc    %eax
  802165:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80216a:	ff 45 f4             	incl   -0xc(%ebp)
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	3b 45 08             	cmp    0x8(%ebp),%eax
  802173:	0f 82 56 ff ff ff    	jb     8020cf <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80218a:	eb 18                	jmp    8021a4 <find_block+0x28>
		{
			if(tmp->sva==va)
  80218c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218f:	8b 40 08             	mov    0x8(%eax),%eax
  802192:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802195:	75 05                	jne    80219c <find_block+0x20>
			{
				return tmp;
  802197:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219a:	eb 11                	jmp    8021ad <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80219c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219f:	8b 00                	mov    (%eax),%eax
  8021a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8021a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a8:	75 e2                	jne    80218c <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8021aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8021b5:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	0f 85 83 00 00 00    	jne    802245 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8021c2:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8021c9:	00 00 00 
  8021cc:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8021d3:	00 00 00 
  8021d6:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8021dd:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e4:	75 14                	jne    8021fa <insert_sorted_allocList+0x4b>
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 90 3b 80 00       	push   $0x803b90
  8021ee:	6a 7f                	push   $0x7f
  8021f0:	68 b3 3b 80 00       	push   $0x803bb3
  8021f5:	e8 2c e1 ff ff       	call   800326 <_panic>
  8021fa:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	89 10                	mov    %edx,(%eax)
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	8b 00                	mov    (%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 0d                	je     80221b <insert_sorted_allocList+0x6c>
  80220e:	a1 40 40 80 00       	mov    0x804040,%eax
  802213:	8b 55 08             	mov    0x8(%ebp),%edx
  802216:	89 50 04             	mov    %edx,0x4(%eax)
  802219:	eb 08                	jmp    802223 <insert_sorted_allocList+0x74>
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	a3 44 40 80 00       	mov    %eax,0x804044
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	a3 40 40 80 00       	mov    %eax,0x804040
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802235:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223a:	40                   	inc    %eax
  80223b:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802240:	e9 16 01 00 00       	jmp    80235b <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 50 08             	mov    0x8(%eax),%edx
  80224b:	a1 44 40 80 00       	mov    0x804044,%eax
  802250:	8b 40 08             	mov    0x8(%eax),%eax
  802253:	39 c2                	cmp    %eax,%edx
  802255:	76 68                	jbe    8022bf <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225b:	75 17                	jne    802274 <insert_sorted_allocList+0xc5>
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 cc 3b 80 00       	push   $0x803bcc
  802265:	68 85 00 00 00       	push   $0x85
  80226a:	68 b3 3b 80 00       	push   $0x803bb3
  80226f:	e8 b2 e0 ff ff       	call   800326 <_panic>
  802274:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 0c                	je     802296 <insert_sorted_allocList+0xe7>
  80228a:	a1 44 40 80 00       	mov    0x804044,%eax
  80228f:	8b 55 08             	mov    0x8(%ebp),%edx
  802292:	89 10                	mov    %edx,(%eax)
  802294:	eb 08                	jmp    80229e <insert_sorted_allocList+0xef>
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	a3 40 40 80 00       	mov    %eax,0x804040
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022af:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b4:	40                   	inc    %eax
  8022b5:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022ba:	e9 9c 00 00 00       	jmp    80235b <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8022bf:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8022c7:	e9 85 00 00 00       	jmp    802351 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	8b 50 08             	mov    0x8(%eax),%edx
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 40 08             	mov    0x8(%eax),%eax
  8022d8:	39 c2                	cmp    %eax,%edx
  8022da:	73 6d                	jae    802349 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8022dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e0:	74 06                	je     8022e8 <insert_sorted_allocList+0x139>
  8022e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e6:	75 17                	jne    8022ff <insert_sorted_allocList+0x150>
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	68 f0 3b 80 00       	push   $0x803bf0
  8022f0:	68 90 00 00 00       	push   $0x90
  8022f5:	68 b3 3b 80 00       	push   $0x803bb3
  8022fa:	e8 27 e0 ff ff       	call   800326 <_panic>
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 50 04             	mov    0x4(%eax),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 50 04             	mov    %edx,0x4(%eax)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802311:	89 10                	mov    %edx,(%eax)
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 04             	mov    0x4(%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0d                	je     80232a <insert_sorted_allocList+0x17b>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	8b 55 08             	mov    0x8(%ebp),%edx
  802326:	89 10                	mov    %edx,(%eax)
  802328:	eb 08                	jmp    802332 <insert_sorted_allocList+0x183>
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	a3 40 40 80 00       	mov    %eax,0x804040
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802340:	40                   	inc    %eax
  802341:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802346:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802347:	eb 12                	jmp    80235b <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	8b 00                	mov    (%eax),%eax
  80234e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802355:	0f 85 71 ff ff ff    	jne    8022cc <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80235b:	90                   	nop
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802364:	a1 38 41 80 00       	mov    0x804138,%eax
  802369:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80236c:	e9 76 01 00 00       	jmp    8024e7 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 40 0c             	mov    0xc(%eax),%eax
  802377:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237a:	0f 85 8a 00 00 00    	jne    80240a <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802384:	75 17                	jne    80239d <alloc_block_FF+0x3f>
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	68 25 3c 80 00       	push   $0x803c25
  80238e:	68 a8 00 00 00       	push   $0xa8
  802393:	68 b3 3b 80 00       	push   $0x803bb3
  802398:	e8 89 df ff ff       	call   800326 <_panic>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 10                	je     8023b6 <alloc_block_FF+0x58>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ae:	8b 52 04             	mov    0x4(%edx),%edx
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	eb 0b                	jmp    8023c1 <alloc_block_FF+0x63>
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 40 04             	mov    0x4(%eax),%eax
  8023bc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 0f                	je     8023da <alloc_block_FF+0x7c>
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 40 04             	mov    0x4(%eax),%eax
  8023d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d4:	8b 12                	mov    (%edx),%edx
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	eb 0a                	jmp    8023e4 <alloc_block_FF+0x86>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	a3 38 41 80 00       	mov    %eax,0x804138
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8023fc:	48                   	dec    %eax
  8023fd:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	e9 ea 00 00 00       	jmp    8024f4 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 40 0c             	mov    0xc(%eax),%eax
  802410:	3b 45 08             	cmp    0x8(%ebp),%eax
  802413:	0f 86 c6 00 00 00    	jbe    8024df <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802419:	a1 48 41 80 00       	mov    0x804148,%eax
  80241e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	8b 55 08             	mov    0x8(%ebp),%edx
  802427:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 50 08             	mov    0x8(%eax),%edx
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 40 0c             	mov    0xc(%eax),%eax
  80243c:	2b 45 08             	sub    0x8(%ebp),%eax
  80243f:	89 c2                	mov    %eax,%edx
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 50 08             	mov    0x8(%eax),%edx
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	01 c2                	add    %eax,%edx
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80245c:	75 17                	jne    802475 <alloc_block_FF+0x117>
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 25 3c 80 00       	push   $0x803c25
  802466:	68 b6 00 00 00       	push   $0xb6
  80246b:	68 b3 3b 80 00       	push   $0x803bb3
  802470:	e8 b1 de ff ff       	call   800326 <_panic>
  802475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 10                	je     80248e <alloc_block_FF+0x130>
  80247e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802486:	8b 52 04             	mov    0x4(%edx),%edx
  802489:	89 50 04             	mov    %edx,0x4(%eax)
  80248c:	eb 0b                	jmp    802499 <alloc_block_FF+0x13b>
  80248e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 0f                	je     8024b2 <alloc_block_FF+0x154>
  8024a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a6:	8b 40 04             	mov    0x4(%eax),%eax
  8024a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ac:	8b 12                	mov    (%edx),%edx
  8024ae:	89 10                	mov    %edx,(%eax)
  8024b0:	eb 0a                	jmp    8024bc <alloc_block_FF+0x15e>
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	a3 48 41 80 00       	mov    %eax,0x804148
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cf:	a1 54 41 80 00       	mov    0x804154,%eax
  8024d4:	48                   	dec    %eax
  8024d5:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  8024da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dd:	eb 15                	jmp    8024f4 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8024e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024eb:	0f 85 80 fe ff ff    	jne    802371 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024fc:	a1 38 41 80 00       	mov    0x804138,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802504:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80250b:	e9 c0 00 00 00       	jmp    8025d0 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 0c             	mov    0xc(%eax),%eax
  802516:	3b 45 08             	cmp    0x8(%ebp),%eax
  802519:	0f 85 8a 00 00 00    	jne    8025a9 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80251f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802523:	75 17                	jne    80253c <alloc_block_BF+0x46>
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	68 25 3c 80 00       	push   $0x803c25
  80252d:	68 cf 00 00 00       	push   $0xcf
  802532:	68 b3 3b 80 00       	push   $0x803bb3
  802537:	e8 ea dd ff ff       	call   800326 <_panic>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	74 10                	je     802555 <alloc_block_BF+0x5f>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254d:	8b 52 04             	mov    0x4(%edx),%edx
  802550:	89 50 04             	mov    %edx,0x4(%eax)
  802553:	eb 0b                	jmp    802560 <alloc_block_BF+0x6a>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 40 04             	mov    0x4(%eax),%eax
  80255b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	74 0f                	je     802579 <alloc_block_BF+0x83>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802573:	8b 12                	mov    (%edx),%edx
  802575:	89 10                	mov    %edx,(%eax)
  802577:	eb 0a                	jmp    802583 <alloc_block_BF+0x8d>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	a3 38 41 80 00       	mov    %eax,0x804138
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802596:	a1 44 41 80 00       	mov    0x804144,%eax
  80259b:	48                   	dec    %eax
  80259c:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	e9 2a 01 00 00       	jmp    8026d3 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8025af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025b2:	73 14                	jae    8025c8 <alloc_block_BF+0xd2>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bd:	76 09                	jbe    8025c8 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c5:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8025d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d4:	0f 85 36 ff ff ff    	jne    802510 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8025da:	a1 38 41 80 00       	mov    0x804138,%eax
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8025e2:	e9 dd 00 00 00       	jmp    8026c4 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025f0:	0f 85 c6 00 00 00    	jne    8026bc <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025f6:	a1 48 41 80 00       	mov    0x804148,%eax
  8025fb:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 50 08             	mov    0x8(%eax),%edx
  802604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802607:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80260a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260d:	8b 55 08             	mov    0x8(%ebp),%edx
  802610:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 50 08             	mov    0x8(%eax),%edx
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	01 c2                	add    %eax,%edx
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 0c             	mov    0xc(%eax),%eax
  80262a:	2b 45 08             	sub    0x8(%ebp),%eax
  80262d:	89 c2                	mov    %eax,%edx
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802635:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802639:	75 17                	jne    802652 <alloc_block_BF+0x15c>
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	68 25 3c 80 00       	push   $0x803c25
  802643:	68 eb 00 00 00       	push   $0xeb
  802648:	68 b3 3b 80 00       	push   $0x803bb3
  80264d:	e8 d4 dc ff ff       	call   800326 <_panic>
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 10                	je     80266b <alloc_block_BF+0x175>
  80265b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802663:	8b 52 04             	mov    0x4(%edx),%edx
  802666:	89 50 04             	mov    %edx,0x4(%eax)
  802669:	eb 0b                	jmp    802676 <alloc_block_BF+0x180>
  80266b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266e:	8b 40 04             	mov    0x4(%eax),%eax
  802671:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	85 c0                	test   %eax,%eax
  80267e:	74 0f                	je     80268f <alloc_block_BF+0x199>
  802680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802683:	8b 40 04             	mov    0x4(%eax),%eax
  802686:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802689:	8b 12                	mov    (%edx),%edx
  80268b:	89 10                	mov    %edx,(%eax)
  80268d:	eb 0a                	jmp    802699 <alloc_block_BF+0x1a3>
  80268f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	a3 48 41 80 00       	mov    %eax,0x804148
  802699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ac:	a1 54 41 80 00       	mov    0x804154,%eax
  8026b1:	48                   	dec    %eax
  8026b2:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  8026b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ba:	eb 17                	jmp    8026d3 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	0f 85 19 ff ff ff    	jne    8025e7 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8026db:	a1 40 40 80 00       	mov    0x804040,%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	75 19                	jne    8026fd <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	e8 6f fc ff ff       	call   80235e <alloc_block_FF>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	e9 e9 01 00 00       	jmp    8028e6 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8026fd:	a1 44 40 80 00       	mov    0x804044,%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802708:	a1 44 40 80 00       	mov    0x804044,%eax
  80270d:	8b 50 0c             	mov    0xc(%eax),%edx
  802710:	a1 44 40 80 00       	mov    0x804044,%eax
  802715:	8b 40 08             	mov    0x8(%eax),%eax
  802718:	01 d0                	add    %edx,%eax
  80271a:	83 ec 08             	sub    $0x8,%esp
  80271d:	50                   	push   %eax
  80271e:	68 38 41 80 00       	push   $0x804138
  802723:	e8 54 fa ff ff       	call   80217c <find_block>
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 40 0c             	mov    0xc(%eax),%eax
  802734:	3b 45 08             	cmp    0x8(%ebp),%eax
  802737:	0f 85 9b 00 00 00    	jne    8027d8 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 50 0c             	mov    0xc(%eax),%edx
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 08             	mov    0x8(%eax),%eax
  802749:	01 d0                	add    %edx,%eax
  80274b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80274e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802752:	75 17                	jne    80276b <alloc_block_NF+0x96>
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	68 25 3c 80 00       	push   $0x803c25
  80275c:	68 1a 01 00 00       	push   $0x11a
  802761:	68 b3 3b 80 00       	push   $0x803bb3
  802766:	e8 bb db ff ff       	call   800326 <_panic>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 10                	je     802784 <alloc_block_NF+0xaf>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277c:	8b 52 04             	mov    0x4(%edx),%edx
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	eb 0b                	jmp    80278f <alloc_block_NF+0xba>
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 40 04             	mov    0x4(%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 0f                	je     8027a8 <alloc_block_NF+0xd3>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a2:	8b 12                	mov    (%edx),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	eb 0a                	jmp    8027b2 <alloc_block_NF+0xdd>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	a3 38 41 80 00       	mov    %eax,0x804138
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ca:	48                   	dec    %eax
  8027cb:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	e9 0e 01 00 00       	jmp    8028e6 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e1:	0f 86 cf 00 00 00    	jbe    8028b6 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027e7:	a1 48 41 80 00       	mov    0x804148,%eax
  8027ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f5:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 50 08             	mov    0x8(%eax),%edx
  8027fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802801:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 50 08             	mov    0x8(%eax),%edx
  80280a:	8b 45 08             	mov    0x8(%ebp),%eax
  80280d:	01 c2                	add    %eax,%edx
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 40 0c             	mov    0xc(%eax),%eax
  80281b:	2b 45 08             	sub    0x8(%ebp),%eax
  80281e:	89 c2                	mov    %eax,%edx
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 08             	mov    0x8(%eax),%eax
  80282c:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80282f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802833:	75 17                	jne    80284c <alloc_block_NF+0x177>
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	68 25 3c 80 00       	push   $0x803c25
  80283d:	68 28 01 00 00       	push   $0x128
  802842:	68 b3 3b 80 00       	push   $0x803bb3
  802847:	e8 da da ff ff       	call   800326 <_panic>
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	74 10                	je     802865 <alloc_block_NF+0x190>
  802855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80285d:	8b 52 04             	mov    0x4(%edx),%edx
  802860:	89 50 04             	mov    %edx,0x4(%eax)
  802863:	eb 0b                	jmp    802870 <alloc_block_NF+0x19b>
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802870:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802873:	8b 40 04             	mov    0x4(%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 0f                	je     802889 <alloc_block_NF+0x1b4>
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802883:	8b 12                	mov    (%edx),%edx
  802885:	89 10                	mov    %edx,(%eax)
  802887:	eb 0a                	jmp    802893 <alloc_block_NF+0x1be>
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	a3 48 41 80 00       	mov    %eax,0x804148
  802893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802896:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ab:	48                   	dec    %eax
  8028ac:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	eb 30                	jmp    8028e6 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8028b6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028be:	75 0a                	jne    8028ca <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8028c0:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c8:	eb 08                	jmp    8028d2 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 08             	mov    0x8(%eax),%eax
  8028d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028db:	0f 85 4d fe ff ff    	jne    80272e <alloc_block_NF+0x59>

			return NULL;
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8028e6:	c9                   	leave  
  8028e7:	c3                   	ret    

008028e8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028e8:	55                   	push   %ebp
  8028e9:	89 e5                	mov    %esp,%ebp
  8028eb:	53                   	push   %ebx
  8028ec:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8028ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	0f 85 86 00 00 00    	jne    802982 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8028fc:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802903:	00 00 00 
  802906:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80290d:	00 00 00 
  802910:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802917:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80291a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291e:	75 17                	jne    802937 <insert_sorted_with_merge_freeList+0x4f>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 90 3b 80 00       	push   $0x803b90
  802928:	68 48 01 00 00       	push   $0x148
  80292d:	68 b3 3b 80 00       	push   $0x803bb3
  802932:	e8 ef d9 ff ff       	call   800326 <_panic>
  802937:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	89 10                	mov    %edx,(%eax)
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	85 c0                	test   %eax,%eax
  802949:	74 0d                	je     802958 <insert_sorted_with_merge_freeList+0x70>
  80294b:	a1 38 41 80 00       	mov    0x804138,%eax
  802950:	8b 55 08             	mov    0x8(%ebp),%edx
  802953:	89 50 04             	mov    %edx,0x4(%eax)
  802956:	eb 08                	jmp    802960 <insert_sorted_with_merge_freeList+0x78>
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	a3 38 41 80 00       	mov    %eax,0x804138
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802972:	a1 44 41 80 00       	mov    0x804144,%eax
  802977:	40                   	inc    %eax
  802978:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80297d:	e9 73 07 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80298d:	8b 40 08             	mov    0x8(%eax),%eax
  802990:	39 c2                	cmp    %eax,%edx
  802992:	0f 86 84 00 00 00    	jbe    802a1c <insert_sorted_with_merge_freeList+0x134>
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 50 08             	mov    0x8(%eax),%edx
  80299e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029a3:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029a6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ab:	8b 40 08             	mov    0x8(%eax),%eax
  8029ae:	01 c8                	add    %ecx,%eax
  8029b0:	39 c2                	cmp    %eax,%edx
  8029b2:	74 68                	je     802a1c <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8029b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b8:	75 17                	jne    8029d1 <insert_sorted_with_merge_freeList+0xe9>
  8029ba:	83 ec 04             	sub    $0x4,%esp
  8029bd:	68 cc 3b 80 00       	push   $0x803bcc
  8029c2:	68 4c 01 00 00       	push   $0x14c
  8029c7:	68 b3 3b 80 00       	push   $0x803bb3
  8029cc:	e8 55 d9 ff ff       	call   800326 <_panic>
  8029d1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 0c                	je     8029f3 <insert_sorted_with_merge_freeList+0x10b>
  8029e7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ef:	89 10                	mov    %edx,(%eax)
  8029f1:	eb 08                	jmp    8029fb <insert_sorted_with_merge_freeList+0x113>
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	a3 38 41 80 00       	mov    %eax,0x804138
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0c:	a1 44 41 80 00       	mov    0x804144,%eax
  802a11:	40                   	inc    %eax
  802a12:	a3 44 41 80 00       	mov    %eax,0x804144
  802a17:	e9 d9 06 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 50 08             	mov    0x8(%eax),%edx
  802a22:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	39 c2                	cmp    %eax,%edx
  802a2c:	0f 86 b5 00 00 00    	jbe    802ae7 <insert_sorted_with_merge_freeList+0x1ff>
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a3d:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a40:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a45:	8b 40 08             	mov    0x8(%eax),%eax
  802a48:	01 c8                	add    %ecx,%eax
  802a4a:	39 c2                	cmp    %eax,%edx
  802a4c:	0f 85 95 00 00 00    	jne    802ae7 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802a52:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a57:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a5d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a60:	8b 55 08             	mov    0x8(%ebp),%edx
  802a63:	8b 52 0c             	mov    0xc(%edx),%edx
  802a66:	01 ca                	add    %ecx,%edx
  802a68:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a83:	75 17                	jne    802a9c <insert_sorted_with_merge_freeList+0x1b4>
  802a85:	83 ec 04             	sub    $0x4,%esp
  802a88:	68 90 3b 80 00       	push   $0x803b90
  802a8d:	68 54 01 00 00       	push   $0x154
  802a92:	68 b3 3b 80 00       	push   $0x803bb3
  802a97:	e8 8a d8 ff ff       	call   800326 <_panic>
  802a9c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	89 10                	mov    %edx,(%eax)
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0d                	je     802abd <insert_sorted_with_merge_freeList+0x1d5>
  802ab0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab8:	89 50 04             	mov    %edx,0x4(%eax)
  802abb:	eb 08                	jmp    802ac5 <insert_sorted_with_merge_freeList+0x1dd>
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 48 41 80 00       	mov    %eax,0x804148
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad7:	a1 54 41 80 00       	mov    0x804154,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 54 41 80 00       	mov    %eax,0x804154
  802ae2:	e9 0e 06 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8b 50 08             	mov    0x8(%eax),%edx
  802aed:	a1 38 41 80 00       	mov    0x804138,%eax
  802af2:	8b 40 08             	mov    0x8(%eax),%eax
  802af5:	39 c2                	cmp    %eax,%edx
  802af7:	0f 83 c1 00 00 00    	jae    802bbe <insert_sorted_with_merge_freeList+0x2d6>
  802afd:	a1 38 41 80 00       	mov    0x804138,%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	8b 48 08             	mov    0x8(%eax),%ecx
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	01 c8                	add    %ecx,%eax
  802b13:	39 c2                	cmp    %eax,%edx
  802b15:	0f 85 a3 00 00 00    	jne    802bbe <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b1b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	8b 52 08             	mov    0x8(%edx),%edx
  802b26:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b29:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b34:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b37:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3a:	8b 52 0c             	mov    0xc(%edx),%edx
  802b3d:	01 ca                	add    %ecx,%edx
  802b3f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5a:	75 17                	jne    802b73 <insert_sorted_with_merge_freeList+0x28b>
  802b5c:	83 ec 04             	sub    $0x4,%esp
  802b5f:	68 90 3b 80 00       	push   $0x803b90
  802b64:	68 5d 01 00 00       	push   $0x15d
  802b69:	68 b3 3b 80 00       	push   $0x803bb3
  802b6e:	e8 b3 d7 ff ff       	call   800326 <_panic>
  802b73:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	89 10                	mov    %edx,(%eax)
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 0d                	je     802b94 <insert_sorted_with_merge_freeList+0x2ac>
  802b87:	a1 48 41 80 00       	mov    0x804148,%eax
  802b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8f:	89 50 04             	mov    %edx,0x4(%eax)
  802b92:	eb 08                	jmp    802b9c <insert_sorted_with_merge_freeList+0x2b4>
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	a3 48 41 80 00       	mov    %eax,0x804148
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bae:	a1 54 41 80 00       	mov    0x804154,%eax
  802bb3:	40                   	inc    %eax
  802bb4:	a3 54 41 80 00       	mov    %eax,0x804154
  802bb9:	e9 37 05 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 50 08             	mov    0x8(%eax),%edx
  802bc4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc9:	8b 40 08             	mov    0x8(%eax),%eax
  802bcc:	39 c2                	cmp    %eax,%edx
  802bce:	0f 83 82 00 00 00    	jae    802c56 <insert_sorted_with_merge_freeList+0x36e>
  802bd4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd9:	8b 50 08             	mov    0x8(%eax),%edx
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	8b 48 08             	mov    0x8(%eax),%ecx
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 40 0c             	mov    0xc(%eax),%eax
  802be8:	01 c8                	add    %ecx,%eax
  802bea:	39 c2                	cmp    %eax,%edx
  802bec:	74 68                	je     802c56 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf2:	75 17                	jne    802c0b <insert_sorted_with_merge_freeList+0x323>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 90 3b 80 00       	push   $0x803b90
  802bfc:	68 62 01 00 00       	push   $0x162
  802c01:	68 b3 3b 80 00       	push   $0x803bb3
  802c06:	e8 1b d7 ff ff       	call   800326 <_panic>
  802c0b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 0d                	je     802c2c <insert_sorted_with_merge_freeList+0x344>
  802c1f:	a1 38 41 80 00       	mov    0x804138,%eax
  802c24:	8b 55 08             	mov    0x8(%ebp),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	eb 08                	jmp    802c34 <insert_sorted_with_merge_freeList+0x34c>
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c46:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4b:	40                   	inc    %eax
  802c4c:	a3 44 41 80 00       	mov    %eax,0x804144
  802c51:	e9 9f 04 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c56:	a1 38 41 80 00       	mov    0x804138,%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c60:	e9 84 04 00 00       	jmp    8030e9 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 08             	mov    0x8(%eax),%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
  802c71:	39 c2                	cmp    %eax,%edx
  802c73:	0f 86 a9 00 00 00    	jbe    802d22 <insert_sorted_with_merge_freeList+0x43a>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 50 08             	mov    0x8(%eax),%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	8b 48 08             	mov    0x8(%eax),%ecx
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8b:	01 c8                	add    %ecx,%eax
  802c8d:	39 c2                	cmp    %eax,%edx
  802c8f:	0f 84 8d 00 00 00    	je     802d22 <insert_sorted_with_merge_freeList+0x43a>
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 50 08             	mov    0x8(%eax),%edx
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	8b 48 08             	mov    0x8(%eax),%ecx
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cad:	01 c8                	add    %ecx,%eax
  802caf:	39 c2                	cmp    %eax,%edx
  802cb1:	74 6f                	je     802d22 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb7:	74 06                	je     802cbf <insert_sorted_with_merge_freeList+0x3d7>
  802cb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbd:	75 17                	jne    802cd6 <insert_sorted_with_merge_freeList+0x3ee>
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	68 f0 3b 80 00       	push   $0x803bf0
  802cc7:	68 6b 01 00 00       	push   $0x16b
  802ccc:	68 b3 3b 80 00       	push   $0x803bb3
  802cd1:	e8 50 d6 ff ff       	call   800326 <_panic>
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 50 04             	mov    0x4(%eax),%edx
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 0d                	je     802d01 <insert_sorted_with_merge_freeList+0x419>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfd:	89 10                	mov    %edx,(%eax)
  802cff:	eb 08                	jmp    802d09 <insert_sorted_with_merge_freeList+0x421>
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	a3 38 41 80 00       	mov    %eax,0x804138
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0f:	89 50 04             	mov    %edx,0x4(%eax)
  802d12:	a1 44 41 80 00       	mov    0x804144,%eax
  802d17:	40                   	inc    %eax
  802d18:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d1d:	e9 d3 03 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 50 08             	mov    0x8(%eax),%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 40 08             	mov    0x8(%eax),%eax
  802d2e:	39 c2                	cmp    %eax,%edx
  802d30:	0f 86 da 00 00 00    	jbe    802e10 <insert_sorted_with_merge_freeList+0x528>
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	8b 50 08             	mov    0x8(%eax),%edx
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 48 08             	mov    0x8(%eax),%ecx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	01 c8                	add    %ecx,%eax
  802d4a:	39 c2                	cmp    %eax,%edx
  802d4c:	0f 85 be 00 00 00    	jne    802e10 <insert_sorted_with_merge_freeList+0x528>
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	8b 50 08             	mov    0x8(%eax),%edx
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	8b 48 08             	mov    0x8(%eax),%ecx
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	01 c8                	add    %ecx,%eax
  802d6c:	39 c2                	cmp    %eax,%edx
  802d6e:	0f 84 9c 00 00 00    	je     802e10 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 50 08             	mov    0x8(%eax),%edx
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 50 0c             	mov    0xc(%eax),%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8c:	01 c2                	add    %eax,%edx
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802da8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dac:	75 17                	jne    802dc5 <insert_sorted_with_merge_freeList+0x4dd>
  802dae:	83 ec 04             	sub    $0x4,%esp
  802db1:	68 90 3b 80 00       	push   $0x803b90
  802db6:	68 74 01 00 00       	push   $0x174
  802dbb:	68 b3 3b 80 00       	push   $0x803bb3
  802dc0:	e8 61 d5 ff ff       	call   800326 <_panic>
  802dc5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	89 10                	mov    %edx,(%eax)
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 0d                	je     802de6 <insert_sorted_with_merge_freeList+0x4fe>
  802dd9:	a1 48 41 80 00       	mov    0x804148,%eax
  802dde:	8b 55 08             	mov    0x8(%ebp),%edx
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	eb 08                	jmp    802dee <insert_sorted_with_merge_freeList+0x506>
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	a3 48 41 80 00       	mov    %eax,0x804148
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e00:	a1 54 41 80 00       	mov    0x804154,%eax
  802e05:	40                   	inc    %eax
  802e06:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e0b:	e9 e5 02 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 50 08             	mov    0x8(%eax),%edx
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 40 08             	mov    0x8(%eax),%eax
  802e1c:	39 c2                	cmp    %eax,%edx
  802e1e:	0f 86 d7 00 00 00    	jbe    802efb <insert_sorted_with_merge_freeList+0x613>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 50 08             	mov    0x8(%eax),%edx
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 48 08             	mov    0x8(%eax),%ecx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 40 0c             	mov    0xc(%eax),%eax
  802e36:	01 c8                	add    %ecx,%eax
  802e38:	39 c2                	cmp    %eax,%edx
  802e3a:	0f 84 bb 00 00 00    	je     802efb <insert_sorted_with_merge_freeList+0x613>
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	8b 50 08             	mov    0x8(%eax),%edx
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	8b 48 08             	mov    0x8(%eax),%ecx
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	01 c8                	add    %ecx,%eax
  802e5a:	39 c2                	cmp    %eax,%edx
  802e5c:	0f 85 99 00 00 00    	jne    802efb <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 40 0c             	mov    0xc(%eax),%eax
  802e77:	01 c2                	add    %eax,%edx
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e97:	75 17                	jne    802eb0 <insert_sorted_with_merge_freeList+0x5c8>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 90 3b 80 00       	push   $0x803b90
  802ea1:	68 7d 01 00 00       	push   $0x17d
  802ea6:	68 b3 3b 80 00       	push   $0x803bb3
  802eab:	e8 76 d4 ff ff       	call   800326 <_panic>
  802eb0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 00                	mov    (%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0d                	je     802ed1 <insert_sorted_with_merge_freeList+0x5e9>
  802ec4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	89 50 04             	mov    %edx,0x4(%eax)
  802ecf:	eb 08                	jmp    802ed9 <insert_sorted_with_merge_freeList+0x5f1>
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eeb:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef0:	40                   	inc    %eax
  802ef1:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802ef6:	e9 fa 01 00 00       	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 50 08             	mov    0x8(%eax),%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	8b 40 08             	mov    0x8(%eax),%eax
  802f07:	39 c2                	cmp    %eax,%edx
  802f09:	0f 86 d2 01 00 00    	jbe    8030e1 <insert_sorted_with_merge_freeList+0x7f9>
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 50 08             	mov    0x8(%eax),%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	8b 48 08             	mov    0x8(%eax),%ecx
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	01 c8                	add    %ecx,%eax
  802f23:	39 c2                	cmp    %eax,%edx
  802f25:	0f 85 b6 01 00 00    	jne    8030e1 <insert_sorted_with_merge_freeList+0x7f9>
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 50 08             	mov    0x8(%eax),%edx
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 04             	mov    0x4(%eax),%eax
  802f37:	8b 48 08             	mov    0x8(%eax),%ecx
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	8b 40 0c             	mov    0xc(%eax),%eax
  802f43:	01 c8                	add    %ecx,%eax
  802f45:	39 c2                	cmp    %eax,%edx
  802f47:	0f 85 94 01 00 00    	jne    8030e1 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 40 04             	mov    0x4(%eax),%eax
  802f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f56:	8b 52 04             	mov    0x4(%edx),%edx
  802f59:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5f:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f65:	8b 52 0c             	mov    0xc(%edx),%edx
  802f68:	01 da                	add    %ebx,%edx
  802f6a:	01 ca                	add    %ecx,%edx
  802f6c:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f87:	75 17                	jne    802fa0 <insert_sorted_with_merge_freeList+0x6b8>
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	68 25 3c 80 00       	push   $0x803c25
  802f91:	68 86 01 00 00       	push   $0x186
  802f96:	68 b3 3b 80 00       	push   $0x803bb3
  802f9b:	e8 86 d3 ff ff       	call   800326 <_panic>
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 10                	je     802fb9 <insert_sorted_with_merge_freeList+0x6d1>
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb1:	8b 52 04             	mov    0x4(%edx),%edx
  802fb4:	89 50 04             	mov    %edx,0x4(%eax)
  802fb7:	eb 0b                	jmp    802fc4 <insert_sorted_with_merge_freeList+0x6dc>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	74 0f                	je     802fdd <insert_sorted_with_merge_freeList+0x6f5>
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd7:	8b 12                	mov    (%edx),%edx
  802fd9:	89 10                	mov    %edx,(%eax)
  802fdb:	eb 0a                	jmp    802fe7 <insert_sorted_with_merge_freeList+0x6ff>
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 00                	mov    (%eax),%eax
  802fe2:	a3 38 41 80 00       	mov    %eax,0x804138
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffa:	a1 44 41 80 00       	mov    0x804144,%eax
  802fff:	48                   	dec    %eax
  803000:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803009:	75 17                	jne    803022 <insert_sorted_with_merge_freeList+0x73a>
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	68 90 3b 80 00       	push   $0x803b90
  803013:	68 87 01 00 00       	push   $0x187
  803018:	68 b3 3b 80 00       	push   $0x803bb3
  80301d:	e8 04 d3 ff ff       	call   800326 <_panic>
  803022:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	89 10                	mov    %edx,(%eax)
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 0d                	je     803043 <insert_sorted_with_merge_freeList+0x75b>
  803036:	a1 48 41 80 00       	mov    0x804148,%eax
  80303b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	eb 08                	jmp    80304b <insert_sorted_with_merge_freeList+0x763>
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	a3 48 41 80 00       	mov    %eax,0x804148
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305d:	a1 54 41 80 00       	mov    0x804154,%eax
  803062:	40                   	inc    %eax
  803063:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80307c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803080:	75 17                	jne    803099 <insert_sorted_with_merge_freeList+0x7b1>
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	68 90 3b 80 00       	push   $0x803b90
  80308a:	68 8a 01 00 00       	push   $0x18a
  80308f:	68 b3 3b 80 00       	push   $0x803bb3
  803094:	e8 8d d2 ff ff       	call   800326 <_panic>
  803099:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	89 10                	mov    %edx,(%eax)
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	74 0d                	je     8030ba <insert_sorted_with_merge_freeList+0x7d2>
  8030ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	eb 08                	jmp    8030c2 <insert_sorted_with_merge_freeList+0x7da>
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d4:	a1 54 41 80 00       	mov    0x804154,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  8030df:	eb 14                	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8030e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ed:	0f 85 72 fb ff ff    	jne    802c65 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8030f3:	eb 00                	jmp    8030f5 <insert_sorted_with_merge_freeList+0x80d>
  8030f5:	90                   	nop
  8030f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030f9:	c9                   	leave  
  8030fa:	c3                   	ret    

008030fb <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
  8030fe:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803101:	8b 55 08             	mov    0x8(%ebp),%edx
  803104:	89 d0                	mov    %edx,%eax
  803106:	c1 e0 02             	shl    $0x2,%eax
  803109:	01 d0                	add    %edx,%eax
  80310b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803112:	01 d0                	add    %edx,%eax
  803114:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80311b:	01 d0                	add    %edx,%eax
  80311d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803124:	01 d0                	add    %edx,%eax
  803126:	c1 e0 04             	shl    $0x4,%eax
  803129:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80312c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803133:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803136:	83 ec 0c             	sub    $0xc,%esp
  803139:	50                   	push   %eax
  80313a:	e8 7b eb ff ff       	call   801cba <sys_get_virtual_time>
  80313f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803142:	eb 41                	jmp    803185 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803144:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803147:	83 ec 0c             	sub    $0xc,%esp
  80314a:	50                   	push   %eax
  80314b:	e8 6a eb ff ff       	call   801cba <sys_get_virtual_time>
  803150:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803153:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	29 c2                	sub    %eax,%edx
  80315b:	89 d0                	mov    %edx,%eax
  80315d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803163:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803166:	89 d1                	mov    %edx,%ecx
  803168:	29 c1                	sub    %eax,%ecx
  80316a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80316d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803170:	39 c2                	cmp    %eax,%edx
  803172:	0f 97 c0             	seta   %al
  803175:	0f b6 c0             	movzbl %al,%eax
  803178:	29 c1                	sub    %eax,%ecx
  80317a:	89 c8                	mov    %ecx,%eax
  80317c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80317f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803182:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80318b:	72 b7                	jb     803144 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80318d:	90                   	nop
  80318e:	c9                   	leave  
  80318f:	c3                   	ret    

00803190 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803190:	55                   	push   %ebp
  803191:	89 e5                	mov    %esp,%ebp
  803193:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80319d:	eb 03                	jmp    8031a2 <busy_wait+0x12>
  80319f:	ff 45 fc             	incl   -0x4(%ebp)
  8031a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a8:	72 f5                	jb     80319f <busy_wait+0xf>
	return i;
  8031aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    
  8031af:	90                   	nop

008031b0 <__udivdi3>:
  8031b0:	55                   	push   %ebp
  8031b1:	57                   	push   %edi
  8031b2:	56                   	push   %esi
  8031b3:	53                   	push   %ebx
  8031b4:	83 ec 1c             	sub    $0x1c,%esp
  8031b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031c7:	89 ca                	mov    %ecx,%edx
  8031c9:	89 f8                	mov    %edi,%eax
  8031cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031cf:	85 f6                	test   %esi,%esi
  8031d1:	75 2d                	jne    803200 <__udivdi3+0x50>
  8031d3:	39 cf                	cmp    %ecx,%edi
  8031d5:	77 65                	ja     80323c <__udivdi3+0x8c>
  8031d7:	89 fd                	mov    %edi,%ebp
  8031d9:	85 ff                	test   %edi,%edi
  8031db:	75 0b                	jne    8031e8 <__udivdi3+0x38>
  8031dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e2:	31 d2                	xor    %edx,%edx
  8031e4:	f7 f7                	div    %edi
  8031e6:	89 c5                	mov    %eax,%ebp
  8031e8:	31 d2                	xor    %edx,%edx
  8031ea:	89 c8                	mov    %ecx,%eax
  8031ec:	f7 f5                	div    %ebp
  8031ee:	89 c1                	mov    %eax,%ecx
  8031f0:	89 d8                	mov    %ebx,%eax
  8031f2:	f7 f5                	div    %ebp
  8031f4:	89 cf                	mov    %ecx,%edi
  8031f6:	89 fa                	mov    %edi,%edx
  8031f8:	83 c4 1c             	add    $0x1c,%esp
  8031fb:	5b                   	pop    %ebx
  8031fc:	5e                   	pop    %esi
  8031fd:	5f                   	pop    %edi
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    
  803200:	39 ce                	cmp    %ecx,%esi
  803202:	77 28                	ja     80322c <__udivdi3+0x7c>
  803204:	0f bd fe             	bsr    %esi,%edi
  803207:	83 f7 1f             	xor    $0x1f,%edi
  80320a:	75 40                	jne    80324c <__udivdi3+0x9c>
  80320c:	39 ce                	cmp    %ecx,%esi
  80320e:	72 0a                	jb     80321a <__udivdi3+0x6a>
  803210:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803214:	0f 87 9e 00 00 00    	ja     8032b8 <__udivdi3+0x108>
  80321a:	b8 01 00 00 00       	mov    $0x1,%eax
  80321f:	89 fa                	mov    %edi,%edx
  803221:	83 c4 1c             	add    $0x1c,%esp
  803224:	5b                   	pop    %ebx
  803225:	5e                   	pop    %esi
  803226:	5f                   	pop    %edi
  803227:	5d                   	pop    %ebp
  803228:	c3                   	ret    
  803229:	8d 76 00             	lea    0x0(%esi),%esi
  80322c:	31 ff                	xor    %edi,%edi
  80322e:	31 c0                	xor    %eax,%eax
  803230:	89 fa                	mov    %edi,%edx
  803232:	83 c4 1c             	add    $0x1c,%esp
  803235:	5b                   	pop    %ebx
  803236:	5e                   	pop    %esi
  803237:	5f                   	pop    %edi
  803238:	5d                   	pop    %ebp
  803239:	c3                   	ret    
  80323a:	66 90                	xchg   %ax,%ax
  80323c:	89 d8                	mov    %ebx,%eax
  80323e:	f7 f7                	div    %edi
  803240:	31 ff                	xor    %edi,%edi
  803242:	89 fa                	mov    %edi,%edx
  803244:	83 c4 1c             	add    $0x1c,%esp
  803247:	5b                   	pop    %ebx
  803248:	5e                   	pop    %esi
  803249:	5f                   	pop    %edi
  80324a:	5d                   	pop    %ebp
  80324b:	c3                   	ret    
  80324c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803251:	89 eb                	mov    %ebp,%ebx
  803253:	29 fb                	sub    %edi,%ebx
  803255:	89 f9                	mov    %edi,%ecx
  803257:	d3 e6                	shl    %cl,%esi
  803259:	89 c5                	mov    %eax,%ebp
  80325b:	88 d9                	mov    %bl,%cl
  80325d:	d3 ed                	shr    %cl,%ebp
  80325f:	89 e9                	mov    %ebp,%ecx
  803261:	09 f1                	or     %esi,%ecx
  803263:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803267:	89 f9                	mov    %edi,%ecx
  803269:	d3 e0                	shl    %cl,%eax
  80326b:	89 c5                	mov    %eax,%ebp
  80326d:	89 d6                	mov    %edx,%esi
  80326f:	88 d9                	mov    %bl,%cl
  803271:	d3 ee                	shr    %cl,%esi
  803273:	89 f9                	mov    %edi,%ecx
  803275:	d3 e2                	shl    %cl,%edx
  803277:	8b 44 24 08          	mov    0x8(%esp),%eax
  80327b:	88 d9                	mov    %bl,%cl
  80327d:	d3 e8                	shr    %cl,%eax
  80327f:	09 c2                	or     %eax,%edx
  803281:	89 d0                	mov    %edx,%eax
  803283:	89 f2                	mov    %esi,%edx
  803285:	f7 74 24 0c          	divl   0xc(%esp)
  803289:	89 d6                	mov    %edx,%esi
  80328b:	89 c3                	mov    %eax,%ebx
  80328d:	f7 e5                	mul    %ebp
  80328f:	39 d6                	cmp    %edx,%esi
  803291:	72 19                	jb     8032ac <__udivdi3+0xfc>
  803293:	74 0b                	je     8032a0 <__udivdi3+0xf0>
  803295:	89 d8                	mov    %ebx,%eax
  803297:	31 ff                	xor    %edi,%edi
  803299:	e9 58 ff ff ff       	jmp    8031f6 <__udivdi3+0x46>
  80329e:	66 90                	xchg   %ax,%ax
  8032a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032a4:	89 f9                	mov    %edi,%ecx
  8032a6:	d3 e2                	shl    %cl,%edx
  8032a8:	39 c2                	cmp    %eax,%edx
  8032aa:	73 e9                	jae    803295 <__udivdi3+0xe5>
  8032ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032af:	31 ff                	xor    %edi,%edi
  8032b1:	e9 40 ff ff ff       	jmp    8031f6 <__udivdi3+0x46>
  8032b6:	66 90                	xchg   %ax,%ax
  8032b8:	31 c0                	xor    %eax,%eax
  8032ba:	e9 37 ff ff ff       	jmp    8031f6 <__udivdi3+0x46>
  8032bf:	90                   	nop

008032c0 <__umoddi3>:
  8032c0:	55                   	push   %ebp
  8032c1:	57                   	push   %edi
  8032c2:	56                   	push   %esi
  8032c3:	53                   	push   %ebx
  8032c4:	83 ec 1c             	sub    $0x1c,%esp
  8032c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032df:	89 f3                	mov    %esi,%ebx
  8032e1:	89 fa                	mov    %edi,%edx
  8032e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032e7:	89 34 24             	mov    %esi,(%esp)
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	75 1a                	jne    803308 <__umoddi3+0x48>
  8032ee:	39 f7                	cmp    %esi,%edi
  8032f0:	0f 86 a2 00 00 00    	jbe    803398 <__umoddi3+0xd8>
  8032f6:	89 c8                	mov    %ecx,%eax
  8032f8:	89 f2                	mov    %esi,%edx
  8032fa:	f7 f7                	div    %edi
  8032fc:	89 d0                	mov    %edx,%eax
  8032fe:	31 d2                	xor    %edx,%edx
  803300:	83 c4 1c             	add    $0x1c,%esp
  803303:	5b                   	pop    %ebx
  803304:	5e                   	pop    %esi
  803305:	5f                   	pop    %edi
  803306:	5d                   	pop    %ebp
  803307:	c3                   	ret    
  803308:	39 f0                	cmp    %esi,%eax
  80330a:	0f 87 ac 00 00 00    	ja     8033bc <__umoddi3+0xfc>
  803310:	0f bd e8             	bsr    %eax,%ebp
  803313:	83 f5 1f             	xor    $0x1f,%ebp
  803316:	0f 84 ac 00 00 00    	je     8033c8 <__umoddi3+0x108>
  80331c:	bf 20 00 00 00       	mov    $0x20,%edi
  803321:	29 ef                	sub    %ebp,%edi
  803323:	89 fe                	mov    %edi,%esi
  803325:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803329:	89 e9                	mov    %ebp,%ecx
  80332b:	d3 e0                	shl    %cl,%eax
  80332d:	89 d7                	mov    %edx,%edi
  80332f:	89 f1                	mov    %esi,%ecx
  803331:	d3 ef                	shr    %cl,%edi
  803333:	09 c7                	or     %eax,%edi
  803335:	89 e9                	mov    %ebp,%ecx
  803337:	d3 e2                	shl    %cl,%edx
  803339:	89 14 24             	mov    %edx,(%esp)
  80333c:	89 d8                	mov    %ebx,%eax
  80333e:	d3 e0                	shl    %cl,%eax
  803340:	89 c2                	mov    %eax,%edx
  803342:	8b 44 24 08          	mov    0x8(%esp),%eax
  803346:	d3 e0                	shl    %cl,%eax
  803348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80334c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803350:	89 f1                	mov    %esi,%ecx
  803352:	d3 e8                	shr    %cl,%eax
  803354:	09 d0                	or     %edx,%eax
  803356:	d3 eb                	shr    %cl,%ebx
  803358:	89 da                	mov    %ebx,%edx
  80335a:	f7 f7                	div    %edi
  80335c:	89 d3                	mov    %edx,%ebx
  80335e:	f7 24 24             	mull   (%esp)
  803361:	89 c6                	mov    %eax,%esi
  803363:	89 d1                	mov    %edx,%ecx
  803365:	39 d3                	cmp    %edx,%ebx
  803367:	0f 82 87 00 00 00    	jb     8033f4 <__umoddi3+0x134>
  80336d:	0f 84 91 00 00 00    	je     803404 <__umoddi3+0x144>
  803373:	8b 54 24 04          	mov    0x4(%esp),%edx
  803377:	29 f2                	sub    %esi,%edx
  803379:	19 cb                	sbb    %ecx,%ebx
  80337b:	89 d8                	mov    %ebx,%eax
  80337d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803381:	d3 e0                	shl    %cl,%eax
  803383:	89 e9                	mov    %ebp,%ecx
  803385:	d3 ea                	shr    %cl,%edx
  803387:	09 d0                	or     %edx,%eax
  803389:	89 e9                	mov    %ebp,%ecx
  80338b:	d3 eb                	shr    %cl,%ebx
  80338d:	89 da                	mov    %ebx,%edx
  80338f:	83 c4 1c             	add    $0x1c,%esp
  803392:	5b                   	pop    %ebx
  803393:	5e                   	pop    %esi
  803394:	5f                   	pop    %edi
  803395:	5d                   	pop    %ebp
  803396:	c3                   	ret    
  803397:	90                   	nop
  803398:	89 fd                	mov    %edi,%ebp
  80339a:	85 ff                	test   %edi,%edi
  80339c:	75 0b                	jne    8033a9 <__umoddi3+0xe9>
  80339e:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a3:	31 d2                	xor    %edx,%edx
  8033a5:	f7 f7                	div    %edi
  8033a7:	89 c5                	mov    %eax,%ebp
  8033a9:	89 f0                	mov    %esi,%eax
  8033ab:	31 d2                	xor    %edx,%edx
  8033ad:	f7 f5                	div    %ebp
  8033af:	89 c8                	mov    %ecx,%eax
  8033b1:	f7 f5                	div    %ebp
  8033b3:	89 d0                	mov    %edx,%eax
  8033b5:	e9 44 ff ff ff       	jmp    8032fe <__umoddi3+0x3e>
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	89 c8                	mov    %ecx,%eax
  8033be:	89 f2                	mov    %esi,%edx
  8033c0:	83 c4 1c             	add    $0x1c,%esp
  8033c3:	5b                   	pop    %ebx
  8033c4:	5e                   	pop    %esi
  8033c5:	5f                   	pop    %edi
  8033c6:	5d                   	pop    %ebp
  8033c7:	c3                   	ret    
  8033c8:	3b 04 24             	cmp    (%esp),%eax
  8033cb:	72 06                	jb     8033d3 <__umoddi3+0x113>
  8033cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033d1:	77 0f                	ja     8033e2 <__umoddi3+0x122>
  8033d3:	89 f2                	mov    %esi,%edx
  8033d5:	29 f9                	sub    %edi,%ecx
  8033d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033db:	89 14 24             	mov    %edx,(%esp)
  8033de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033e6:	8b 14 24             	mov    (%esp),%edx
  8033e9:	83 c4 1c             	add    $0x1c,%esp
  8033ec:	5b                   	pop    %ebx
  8033ed:	5e                   	pop    %esi
  8033ee:	5f                   	pop    %edi
  8033ef:	5d                   	pop    %ebp
  8033f0:	c3                   	ret    
  8033f1:	8d 76 00             	lea    0x0(%esi),%esi
  8033f4:	2b 04 24             	sub    (%esp),%eax
  8033f7:	19 fa                	sbb    %edi,%edx
  8033f9:	89 d1                	mov    %edx,%ecx
  8033fb:	89 c6                	mov    %eax,%esi
  8033fd:	e9 71 ff ff ff       	jmp    803373 <__umoddi3+0xb3>
  803402:	66 90                	xchg   %ax,%ax
  803404:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803408:	72 ea                	jb     8033f4 <__umoddi3+0x134>
  80340a:	89 d9                	mov    %ebx,%ecx
  80340c:	e9 62 ff ff ff       	jmp    803373 <__umoddi3+0xb3>
