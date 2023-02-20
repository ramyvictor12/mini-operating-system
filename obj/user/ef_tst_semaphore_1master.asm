
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 56 1c 00 00       	call   801c99 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 c0 33 80 00       	push   $0x8033c0
  800050:	e8 de 1a 00 00       	call   801b33 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 c4 33 80 00       	push   $0x8033c4
  800062:	e8 cc 1a 00 00       	call   801b33 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 cc 33 80 00       	push   $0x8033cc
  800088:	e8 b7 1b 00 00       	call   801c44 <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 cc 33 80 00       	push   $0x8033cc
  8000b1:	e8 8e 1b 00 00       	call   801c44 <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 cc 33 80 00       	push   $0x8033cc
  8000da:	e8 65 1b 00 00       	call   801c44 <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 d9 33 80 00       	push   $0x8033d9
  8000ff:	6a 13                	push   $0x13
  800101:	68 f0 33 80 00       	push   $0x8033f0
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 4c 1b 00 00       	call   801c62 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 3e 1b 00 00       	call   801c62 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 30 1b 00 00       	call   801c62 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 c4 33 80 00       	push   $0x8033c4
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 27 1a 00 00       	call   801b6c <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 c4 33 80 00       	push   $0x8033c4
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 14 1a 00 00       	call   801b6c <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 c4 33 80 00       	push   $0x8033c4
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 01 1a 00 00       	call   801b6c <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 c0 33 80 00       	push   $0x8033c0
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 d1 19 00 00       	call   801b4f <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 c4 33 80 00       	push   $0x8033c4
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 bb 19 00 00       	call   801b4f <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 10 34 80 00       	push   $0x803410
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 58 34 80 00       	push   $0x803458
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 fe 1a 00 00       	call   801ccb <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 a3 34 80 00       	push   $0x8034a3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 a5 15 00 00       	call   801792 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 80 1a 00 00       	call   801c7e <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 72 1a 00 00       	call   801c7e <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 64 1a 00 00       	call   801c7e <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 79 1a 00 00       	call   801cb2 <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 1b 18 00 00       	call   801abf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 cc 34 80 00       	push   $0x8034cc
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 f4 34 80 00       	push   $0x8034f4
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 1c 35 80 00       	push   $0x80351c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 74 35 80 00       	push   $0x803574
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 cc 34 80 00       	push   $0x8034cc
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 9b 17 00 00       	call   801ad9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 28 19 00 00       	call   801c7e <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 7d 19 00 00       	call   801ce4 <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 88 35 80 00       	push   $0x803588
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 8d 35 80 00       	push   $0x80358d
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 a9 35 80 00       	push   $0x8035a9
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 ac 35 80 00       	push   $0x8035ac
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 f8 35 80 00       	push   $0x8035f8
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 04 36 80 00       	push   $0x803604
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 f8 35 80 00       	push   $0x8035f8
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 58 36 80 00       	push   $0x803658
  80053b:	6a 44                	push   $0x44
  80053d:	68 f8 35 80 00       	push   $0x8035f8
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 40 80 00       	mov    0x804024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 7c 13 00 00       	call   801911 <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 05 13 00 00       	call   801911 <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 69 14 00 00       	call   801abf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 63 14 00 00       	call   801ad9 <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 80 2a 00 00       	call   803140 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 40 2b 00 00       	call   803250 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 d4 38 80 00       	add    $0x8038d4,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 f8 38 80 00 	mov    0x8038f8(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 40 37 80 00 	mov    0x803740(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 e5 38 80 00       	push   $0x8038e5
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 ee 38 80 00       	push   $0x8038ee
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be f1 38 80 00       	mov    $0x8038f1,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 50 3a 80 00       	push   $0x803a50
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8013df:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013e6:	00 00 00 
  8013e9:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f0:	00 00 00 
  8013f3:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fa:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8013fd:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801404:	00 00 00 
  801407:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80140e:	00 00 00 
  801411:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801418:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80141b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801422:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801425:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80142c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801440:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801445:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80144c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801454:	2d 00 10 00 00       	sub    $0x1000,%eax
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	6a 06                	push   $0x6
  80145e:	ff 75 f4             	pushl  -0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	e8 ee 05 00 00       	call   801a55 <sys_allocate_chunk>
  801467:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80146a:	a1 20 41 80 00       	mov    0x804120,%eax
  80146f:	83 ec 0c             	sub    $0xc,%esp
  801472:	50                   	push   %eax
  801473:	e8 63 0c 00 00       	call   8020db <initialize_MemBlocksList>
  801478:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80147b:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801480:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801486:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80148d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801490:	8b 40 0c             	mov    0xc(%eax),%eax
  801493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801499:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a3:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8014a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8014b0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ba:	8b 50 08             	mov    0x8(%eax),%edx
  8014bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c0:	01 d0                	add    %edx,%eax
  8014c2:	48                   	dec    %eax
  8014c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ce:	f7 75 e0             	divl   -0x20(%ebp)
  8014d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d4:	29 d0                	sub    %edx,%eax
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014db:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8014de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014e2:	75 14                	jne    8014f8 <initialize_dyn_block_system+0x11f>
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	68 75 3a 80 00       	push   $0x803a75
  8014ec:	6a 34                	push   $0x34
  8014ee:	68 93 3a 80 00       	push   $0x803a93
  8014f3:	e8 72 ee ff ff       	call   80036a <_panic>
  8014f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014fb:	8b 00                	mov    (%eax),%eax
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	74 10                	je     801511 <initialize_dyn_block_system+0x138>
  801501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801509:	8b 52 04             	mov    0x4(%edx),%edx
  80150c:	89 50 04             	mov    %edx,0x4(%eax)
  80150f:	eb 0b                	jmp    80151c <initialize_dyn_block_system+0x143>
  801511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801514:	8b 40 04             	mov    0x4(%eax),%eax
  801517:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80151c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	85 c0                	test   %eax,%eax
  801524:	74 0f                	je     801535 <initialize_dyn_block_system+0x15c>
  801526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801529:	8b 40 04             	mov    0x4(%eax),%eax
  80152c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80152f:	8b 12                	mov    (%edx),%edx
  801531:	89 10                	mov    %edx,(%eax)
  801533:	eb 0a                	jmp    80153f <initialize_dyn_block_system+0x166>
  801535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801538:	8b 00                	mov    (%eax),%eax
  80153a:	a3 48 41 80 00       	mov    %eax,0x804148
  80153f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801542:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801552:	a1 54 41 80 00       	mov    0x804154,%eax
  801557:	48                   	dec    %eax
  801558:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	ff 75 e8             	pushl  -0x18(%ebp)
  801563:	e8 c4 13 00 00       	call   80292c <insert_sorted_with_merge_freeList>
  801568:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80156b:	90                   	nop
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <malloc>:
//=================================



void* malloc(uint32 size)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801574:	e8 2f fe ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801579:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157d:	75 07                	jne    801586 <malloc+0x18>
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	eb 71                	jmp    8015f7 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801586:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80158d:	76 07                	jbe    801596 <malloc+0x28>
	return NULL;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
  801594:	eb 61                	jmp    8015f7 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801596:	e8 88 08 00 00       	call   801e23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159b:	85 c0                	test   %eax,%eax
  80159d:	74 53                	je     8015f2 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80159f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ac:	01 d0                	add    %edx,%eax
  8015ae:	48                   	dec    %eax
  8015af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ba:	f7 75 f4             	divl   -0xc(%ebp)
  8015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c0:	29 d0                	sub    %edx,%eax
  8015c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8015cb:	e8 d2 0d 00 00       	call   8023a2 <alloc_block_FF>
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8015d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015da:	74 16                	je     8015f2 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e2:	e8 0c 0c 00 00       	call   8021f3 <insert_sorted_allocList>
  8015e7:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8015ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ed:	8b 40 08             	mov    0x8(%eax),%eax
  8015f0:	eb 05                	jmp    8015f7 <malloc+0x89>
    }

			}


	return NULL;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	ff 75 f0             	pushl  -0x10(%ebp)
  801616:	68 40 40 80 00       	push   $0x804040
  80161b:	e8 a0 0b 00 00       	call   8021c0 <find_block>
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801629:	8b 50 0c             	mov    0xc(%eax),%edx
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	52                   	push   %edx
  801633:	50                   	push   %eax
  801634:	e8 e4 03 00 00       	call   801a1d <sys_free_user_mem>
  801639:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80163c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801640:	75 17                	jne    801659 <free+0x60>
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 75 3a 80 00       	push   $0x803a75
  80164a:	68 84 00 00 00       	push   $0x84
  80164f:	68 93 3a 80 00       	push   $0x803a93
  801654:	e8 11 ed ff ff       	call   80036a <_panic>
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	8b 00                	mov    (%eax),%eax
  80165e:	85 c0                	test   %eax,%eax
  801660:	74 10                	je     801672 <free+0x79>
  801662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801665:	8b 00                	mov    (%eax),%eax
  801667:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166a:	8b 52 04             	mov    0x4(%edx),%edx
  80166d:	89 50 04             	mov    %edx,0x4(%eax)
  801670:	eb 0b                	jmp    80167d <free+0x84>
  801672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801675:	8b 40 04             	mov    0x4(%eax),%eax
  801678:	a3 44 40 80 00       	mov    %eax,0x804044
  80167d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801680:	8b 40 04             	mov    0x4(%eax),%eax
  801683:	85 c0                	test   %eax,%eax
  801685:	74 0f                	je     801696 <free+0x9d>
  801687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168a:	8b 40 04             	mov    0x4(%eax),%eax
  80168d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801690:	8b 12                	mov    (%edx),%edx
  801692:	89 10                	mov    %edx,(%eax)
  801694:	eb 0a                	jmp    8016a0 <free+0xa7>
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	a3 40 40 80 00       	mov    %eax,0x804040
  8016a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016b8:	48                   	dec    %eax
  8016b9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8016be:	83 ec 0c             	sub    $0xc,%esp
  8016c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c4:	e8 63 12 00 00       	call   80292c <insert_sorted_with_merge_freeList>
  8016c9:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8016cc:	90                   	nop
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 38             	sub    $0x38,%esp
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 c8 fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e4:	75 0a                	jne    8016f0 <smalloc+0x21>
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	e9 a0 00 00 00       	jmp    801790 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016f0:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016f7:	76 0a                	jbe    801703 <smalloc+0x34>
		return NULL;
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fe:	e9 8d 00 00 00       	jmp    801790 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801703:	e8 1b 07 00 00       	call   801e23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801708:	85 c0                	test   %eax,%eax
  80170a:	74 7f                	je     80178b <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80170c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801719:	01 d0                	add    %edx,%eax
  80171b:	48                   	dec    %eax
  80171c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80171f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	f7 75 f4             	divl   -0xc(%ebp)
  80172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172d:	29 d0                	sub    %edx,%eax
  80172f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	ff 75 ec             	pushl  -0x14(%ebp)
  801738:	e8 65 0c 00 00       	call   8023a2 <alloc_block_FF>
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801743:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801747:	74 42                	je     80178b <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801749:	83 ec 0c             	sub    $0xc,%esp
  80174c:	ff 75 e8             	pushl  -0x18(%ebp)
  80174f:	e8 9f 0a 00 00       	call   8021f3 <insert_sorted_allocList>
  801754:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801757:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175a:	8b 40 08             	mov    0x8(%eax),%eax
  80175d:	89 c2                	mov    %eax,%edx
  80175f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801763:	52                   	push   %edx
  801764:	50                   	push   %eax
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	ff 75 08             	pushl  0x8(%ebp)
  80176b:	e8 38 04 00 00       	call   801ba8 <sys_createSharedObject>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80177a:	79 07                	jns    801783 <smalloc+0xb4>
	    		  return NULL;
  80177c:	b8 00 00 00 00       	mov    $0x0,%eax
  801781:	eb 0d                	jmp    801790 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801786:	8b 40 08             	mov    0x8(%eax),%eax
  801789:	eb 05                	jmp    801790 <smalloc+0xc1>


				}


		return NULL;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801798:	e8 0b fc ff ff       	call   8013a8 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80179d:	e8 81 06 00 00       	call   801e23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	0f 84 9f 00 00 00    	je     801849 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	e8 1a 04 00 00       	call   801bd2 <sys_getSizeOfSharedObject>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8017be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c2:	79 0a                	jns    8017ce <sget+0x3c>
		return NULL;
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	e9 80 00 00 00       	jmp    80184e <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8017ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017db:	01 d0                	add    %edx,%eax
  8017dd:	48                   	dec    %eax
  8017de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	f7 75 f0             	divl   -0x10(%ebp)
  8017ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ef:	29 d0                	sub    %edx,%eax
  8017f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8017f4:	83 ec 0c             	sub    $0xc,%esp
  8017f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8017fa:	e8 a3 0b 00 00       	call   8023a2 <alloc_block_FF>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801805:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801809:	74 3e                	je     801849 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801811:	e8 dd 09 00 00       	call   8021f3 <insert_sorted_allocList>
  801816:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181c:	8b 40 08             	mov    0x8(%eax),%eax
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	50                   	push   %eax
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	ff 75 08             	pushl  0x8(%ebp)
  801829:	e8 c1 03 00 00       	call   801bef <sys_getSharedObject>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801834:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801838:	79 07                	jns    801841 <sget+0xaf>
	    		  return NULL;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
  80183f:	eb 0d                	jmp    80184e <sget+0xbc>
	  	return(void*) returned_block->sva;
  801841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801844:	8b 40 08             	mov    0x8(%eax),%eax
  801847:	eb 05                	jmp    80184e <sget+0xbc>
	      }
	}
	   return NULL;
  801849:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801856:	e8 4d fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	68 a0 3a 80 00       	push   $0x803aa0
  801863:	68 12 01 00 00       	push   $0x112
  801868:	68 93 3a 80 00       	push   $0x803a93
  80186d:	e8 f8 ea ff ff       	call   80036a <_panic>

00801872 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	68 c8 3a 80 00       	push   $0x803ac8
  801880:	68 26 01 00 00       	push   $0x126
  801885:	68 93 3a 80 00       	push   $0x803a93
  80188a:	e8 db ea ff ff       	call   80036a <_panic>

0080188f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	68 ec 3a 80 00       	push   $0x803aec
  80189d:	68 31 01 00 00       	push   $0x131
  8018a2:	68 93 3a 80 00       	push   $0x803a93
  8018a7:	e8 be ea ff ff       	call   80036a <_panic>

008018ac <shrink>:

}
void shrink(uint32 newSize)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	68 ec 3a 80 00       	push   $0x803aec
  8018ba:	68 36 01 00 00       	push   $0x136
  8018bf:	68 93 3a 80 00       	push   $0x803a93
  8018c4:	e8 a1 ea ff ff       	call   80036a <_panic>

008018c9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	68 ec 3a 80 00       	push   $0x803aec
  8018d7:	68 3b 01 00 00       	push   $0x13b
  8018dc:	68 93 3a 80 00       	push   $0x803a93
  8018e1:	e8 84 ea ff ff       	call   80036a <_panic>

008018e6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	57                   	push   %edi
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018fe:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801901:	cd 30                	int    $0x30
  801903:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801906:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5f                   	pop    %edi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	8b 45 10             	mov    0x10(%ebp),%eax
  80191a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80191d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	50                   	push   %eax
  80192d:	6a 00                	push   $0x0
  80192f:	e8 b2 ff ff ff       	call   8018e6 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_cgetc>:

int
sys_cgetc(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 01                	push   $0x1
  801949:	e8 98 ff ff ff       	call   8018e6 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 05                	push   $0x5
  801966:	e8 7b ff ff ff       	call   8018e6 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801975:	8b 75 18             	mov    0x18(%ebp),%esi
  801978:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	51                   	push   %ecx
  801987:	52                   	push   %edx
  801988:	50                   	push   %eax
  801989:	6a 06                	push   $0x6
  80198b:	e8 56 ff ff ff       	call   8018e6 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80199d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	6a 07                	push   $0x7
  8019ad:	e8 34 ff ff ff       	call   8018e6 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	6a 08                	push   $0x8
  8019c8:	e8 19 ff ff ff       	call   8018e6 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 09                	push   $0x9
  8019e1:	e8 00 ff ff ff       	call   8018e6 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 0a                	push   $0xa
  8019fa:	e8 e7 fe ff ff       	call   8018e6 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 0b                	push   $0xb
  801a13:	e8 ce fe ff ff       	call   8018e6 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	6a 0f                	push   $0xf
  801a2e:	e8 b3 fe ff ff       	call   8018e6 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
	return;
  801a36:	90                   	nop
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 10                	push   $0x10
  801a4a:	e8 97 fe ff ff       	call   8018e6 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a52:	90                   	nop
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	ff 75 10             	pushl  0x10(%ebp)
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 11                	push   $0x11
  801a67:	e8 7a fe ff ff       	call   8018e6 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 0c                	push   $0xc
  801a81:	e8 60 fe ff ff       	call   8018e6 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 08             	pushl  0x8(%ebp)
  801a99:	6a 0d                	push   $0xd
  801a9b:	e8 46 fe ff ff       	call   8018e6 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 0e                	push   $0xe
  801ab4:	e8 2d fe ff ff       	call   8018e6 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 13                	push   $0x13
  801ace:	e8 13 fe ff ff       	call   8018e6 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 14                	push   $0x14
  801ae8:	e8 f9 fd ff ff       	call   8018e6 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	90                   	nop
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	50                   	push   %eax
  801b0c:	6a 15                	push   $0x15
  801b0e:	e8 d3 fd ff ff       	call   8018e6 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 16                	push   $0x16
  801b28:	e8 b9 fd ff ff       	call   8018e6 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	90                   	nop
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	6a 17                	push   $0x17
  801b45:	e8 9c fd ff ff       	call   8018e6 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	52                   	push   %edx
  801b5f:	50                   	push   %eax
  801b60:	6a 1a                	push   $0x1a
  801b62:	e8 7f fd ff ff       	call   8018e6 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	6a 18                	push   $0x18
  801b7f:	e8 62 fd ff ff       	call   8018e6 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	90                   	nop
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 19                	push   $0x19
  801b9d:	e8 44 fd ff ff       	call   8018e6 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	6a 00                	push   $0x0
  801bc0:	51                   	push   %ecx
  801bc1:	52                   	push   %edx
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	50                   	push   %eax
  801bc6:	6a 1b                	push   $0x1b
  801bc8:	e8 19 fd ff ff       	call   8018e6 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	52                   	push   %edx
  801be2:	50                   	push   %eax
  801be3:	6a 1c                	push   $0x1c
  801be5:	e8 fc fc ff ff       	call   8018e6 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	51                   	push   %ecx
  801c00:	52                   	push   %edx
  801c01:	50                   	push   %eax
  801c02:	6a 1d                	push   $0x1d
  801c04:	e8 dd fc ff ff       	call   8018e6 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	6a 1e                	push   $0x1e
  801c21:	e8 c0 fc ff ff       	call   8018e6 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 1f                	push   $0x1f
  801c3a:	e8 a7 fc ff ff       	call   8018e6 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	ff 75 14             	pushl  0x14(%ebp)
  801c4f:	ff 75 10             	pushl  0x10(%ebp)
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	50                   	push   %eax
  801c56:	6a 20                	push   $0x20
  801c58:	e8 89 fc ff ff       	call   8018e6 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	50                   	push   %eax
  801c71:	6a 21                	push   $0x21
  801c73:	e8 6e fc ff ff       	call   8018e6 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	90                   	nop
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	50                   	push   %eax
  801c8d:	6a 22                	push   $0x22
  801c8f:	e8 52 fc ff ff       	call   8018e6 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 02                	push   $0x2
  801ca8:	e8 39 fc ff ff       	call   8018e6 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 03                	push   $0x3
  801cc1:	e8 20 fc ff ff       	call   8018e6 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 04                	push   $0x4
  801cda:	e8 07 fc ff ff       	call   8018e6 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 23                	push   $0x23
  801cf3:	e8 ee fb ff ff       	call   8018e6 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	90                   	nop
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d07:	8d 50 04             	lea    0x4(%eax),%edx
  801d0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 24                	push   $0x24
  801d17:	e8 ca fb ff ff       	call   8018e6 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d28:	89 01                	mov    %eax,(%ecx)
  801d2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	c9                   	leave  
  801d31:	c2 04 00             	ret    $0x4

00801d34 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	ff 75 10             	pushl  0x10(%ebp)
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 12                	push   $0x12
  801d46:	e8 9b fb ff ff       	call   8018e6 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 25                	push   $0x25
  801d60:	e8 81 fb ff ff       	call   8018e6 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	50                   	push   %eax
  801d83:	6a 26                	push   $0x26
  801d85:	e8 5c fb ff ff       	call   8018e6 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8d:	90                   	nop
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <rsttst>:
void rsttst()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 28                	push   $0x28
  801d9f:	e8 42 fb ff ff       	call   8018e6 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	8b 45 14             	mov    0x14(%ebp),%eax
  801db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db6:	8b 55 18             	mov    0x18(%ebp),%edx
  801db9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dbd:	52                   	push   %edx
  801dbe:	50                   	push   %eax
  801dbf:	ff 75 10             	pushl  0x10(%ebp)
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	6a 27                	push   $0x27
  801dca:	e8 17 fb ff ff       	call   8018e6 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <chktst>:
void chktst(uint32 n)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 29                	push   $0x29
  801de5:	e8 fc fa ff ff       	call   8018e6 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <inctst>:

void inctst()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 2a                	push   $0x2a
  801dff:	e8 e2 fa ff ff       	call   8018e6 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
	return ;
  801e07:	90                   	nop
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <gettst>:
uint32 gettst()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 2b                	push   $0x2b
  801e19:	e8 c8 fa ff ff       	call   8018e6 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 2c                	push   $0x2c
  801e35:	e8 ac fa ff ff       	call   8018e6 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
  801e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e40:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e44:	75 07                	jne    801e4d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	eb 05                	jmp    801e52 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 2c                	push   $0x2c
  801e66:	e8 7b fa ff ff       	call   8018e6 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
  801e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e71:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e75:	75 07                	jne    801e7e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e77:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7c:	eb 05                	jmp    801e83 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 2c                	push   $0x2c
  801e97:	e8 4a fa ff ff       	call   8018e6 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
  801e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ea2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ea6:	75 07                	jne    801eaf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ea8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ead:	eb 05                	jmp    801eb4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 2c                	push   $0x2c
  801ec8:	e8 19 fa ff ff       	call   8018e6 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
  801ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ed3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ed7:	75 07                	jne    801ee0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ed9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ede:	eb 05                	jmp    801ee5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	6a 2d                	push   $0x2d
  801ef7:	e8 ea f9 ff ff       	call   8018e6 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return ;
  801eff:	90                   	nop
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	6a 00                	push   $0x0
  801f14:	53                   	push   %ebx
  801f15:	51                   	push   %ecx
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 2e                	push   $0x2e
  801f1a:	e8 c7 f9 ff ff       	call   8018e6 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	6a 2f                	push   $0x2f
  801f3a:	e8 a7 f9 ff ff       	call   8018e6 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	68 fc 3a 80 00       	push   $0x803afc
  801f52:	e8 c7 e6 ff ff       	call   80061e <cprintf>
  801f57:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	68 28 3b 80 00       	push   $0x803b28
  801f69:	e8 b0 e6 ff ff       	call   80061e <cprintf>
  801f6e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f71:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f75:	a1 38 41 80 00       	mov    0x804138,%eax
  801f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7d:	eb 56                	jmp    801fd5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f83:	74 1c                	je     801fa1 <print_mem_block_lists+0x5d>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 50 08             	mov    0x8(%eax),%edx
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	8b 40 0c             	mov    0xc(%eax),%eax
  801f97:	01 c8                	add    %ecx,%eax
  801f99:	39 c2                	cmp    %eax,%edx
  801f9b:	73 04                	jae    801fa1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f9d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	8b 50 08             	mov    0x8(%eax),%edx
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 40 0c             	mov    0xc(%eax),%eax
  801fad:	01 c2                	add    %eax,%edx
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 08             	mov    0x8(%eax),%eax
  801fb5:	83 ec 04             	sub    $0x4,%esp
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	68 3d 3b 80 00       	push   $0x803b3d
  801fbf:	e8 5a e6 ff ff       	call   80061e <cprintf>
  801fc4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fcd:	a1 40 41 80 00       	mov    0x804140,%eax
  801fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd9:	74 07                	je     801fe2 <print_mem_block_lists+0x9e>
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 00                	mov    (%eax),%eax
  801fe0:	eb 05                	jmp    801fe7 <print_mem_block_lists+0xa3>
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	a3 40 41 80 00       	mov    %eax,0x804140
  801fec:	a1 40 41 80 00       	mov    0x804140,%eax
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	75 8a                	jne    801f7f <print_mem_block_lists+0x3b>
  801ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff9:	75 84                	jne    801f7f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ffb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fff:	75 10                	jne    802011 <print_mem_block_lists+0xcd>
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	68 4c 3b 80 00       	push   $0x803b4c
  802009:	e8 10 e6 ff ff       	call   80061e <cprintf>
  80200e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802011:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	68 70 3b 80 00       	push   $0x803b70
  802020:	e8 f9 e5 ff ff       	call   80061e <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802028:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80202c:	a1 40 40 80 00       	mov    0x804040,%eax
  802031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802034:	eb 56                	jmp    80208c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802036:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203a:	74 1c                	je     802058 <print_mem_block_lists+0x114>
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	8b 50 08             	mov    0x8(%eax),%edx
  802042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802045:	8b 48 08             	mov    0x8(%eax),%ecx
  802048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204b:	8b 40 0c             	mov    0xc(%eax),%eax
  80204e:	01 c8                	add    %ecx,%eax
  802050:	39 c2                	cmp    %eax,%edx
  802052:	73 04                	jae    802058 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802054:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	8b 50 08             	mov    0x8(%eax),%edx
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 40 0c             	mov    0xc(%eax),%eax
  802064:	01 c2                	add    %eax,%edx
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 40 08             	mov    0x8(%eax),%eax
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	68 3d 3b 80 00       	push   $0x803b3d
  802076:	e8 a3 e5 ff ff       	call   80061e <cprintf>
  80207b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802084:	a1 48 40 80 00       	mov    0x804048,%eax
  802089:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802090:	74 07                	je     802099 <print_mem_block_lists+0x155>
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 00                	mov    (%eax),%eax
  802097:	eb 05                	jmp    80209e <print_mem_block_lists+0x15a>
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	a3 48 40 80 00       	mov    %eax,0x804048
  8020a3:	a1 48 40 80 00       	mov    0x804048,%eax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	75 8a                	jne    802036 <print_mem_block_lists+0xf2>
  8020ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b0:	75 84                	jne    802036 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020b2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020b6:	75 10                	jne    8020c8 <print_mem_block_lists+0x184>
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	68 88 3b 80 00       	push   $0x803b88
  8020c0:	e8 59 e5 ff ff       	call   80061e <cprintf>
  8020c5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	68 fc 3a 80 00       	push   $0x803afc
  8020d0:	e8 49 e5 ff ff       	call   80061e <cprintf>
  8020d5:	83 c4 10             	add    $0x10,%esp

}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8020e1:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020e8:	00 00 00 
  8020eb:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020f2:	00 00 00 
  8020f5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020fc:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8020ff:	a1 50 40 80 00       	mov    0x804050,%eax
  802104:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80210e:	e9 9e 00 00 00       	jmp    8021b1 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802113:	a1 50 40 80 00       	mov    0x804050,%eax
  802118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211b:	c1 e2 04             	shl    $0x4,%edx
  80211e:	01 d0                	add    %edx,%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	75 14                	jne    802138 <initialize_MemBlocksList+0x5d>
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 b0 3b 80 00       	push   $0x803bb0
  80212c:	6a 48                	push   $0x48
  80212e:	68 d3 3b 80 00       	push   $0x803bd3
  802133:	e8 32 e2 ff ff       	call   80036a <_panic>
  802138:	a1 50 40 80 00       	mov    0x804050,%eax
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	c1 e2 04             	shl    $0x4,%edx
  802143:	01 d0                	add    %edx,%eax
  802145:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80214b:	89 10                	mov    %edx,(%eax)
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	74 18                	je     80216b <initialize_MemBlocksList+0x90>
  802153:	a1 48 41 80 00       	mov    0x804148,%eax
  802158:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80215e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802161:	c1 e1 04             	shl    $0x4,%ecx
  802164:	01 ca                	add    %ecx,%edx
  802166:	89 50 04             	mov    %edx,0x4(%eax)
  802169:	eb 12                	jmp    80217d <initialize_MemBlocksList+0xa2>
  80216b:	a1 50 40 80 00       	mov    0x804050,%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	c1 e2 04             	shl    $0x4,%edx
  802176:	01 d0                	add    %edx,%eax
  802178:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80217d:	a1 50 40 80 00       	mov    0x804050,%eax
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	c1 e2 04             	shl    $0x4,%edx
  802188:	01 d0                	add    %edx,%eax
  80218a:	a3 48 41 80 00       	mov    %eax,0x804148
  80218f:	a1 50 40 80 00       	mov    0x804050,%eax
  802194:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802197:	c1 e2 04             	shl    $0x4,%edx
  80219a:	01 d0                	add    %edx,%eax
  80219c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8021a8:	40                   	inc    %eax
  8021a9:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8021ae:	ff 45 f4             	incl   -0xc(%ebp)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b7:	0f 82 56 ff ff ff    	jb     802113 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8021bd:	90                   	nop
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8021ce:	eb 18                	jmp    8021e8 <find_block+0x28>
		{
			if(tmp->sva==va)
  8021d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d3:	8b 40 08             	mov    0x8(%eax),%eax
  8021d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021d9:	75 05                	jne    8021e0 <find_block+0x20>
			{
				return tmp;
  8021db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021de:	eb 11                	jmp    8021f1 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8021e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8021e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ec:	75 e2                	jne    8021d0 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8021f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	0f 85 83 00 00 00    	jne    802289 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802206:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80220d:	00 00 00 
  802210:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802217:	00 00 00 
  80221a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802221:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802224:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802228:	75 14                	jne    80223e <insert_sorted_allocList+0x4b>
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	68 b0 3b 80 00       	push   $0x803bb0
  802232:	6a 7f                	push   $0x7f
  802234:	68 d3 3b 80 00       	push   $0x803bd3
  802239:	e8 2c e1 ff ff       	call   80036a <_panic>
  80223e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	89 10                	mov    %edx,(%eax)
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 0d                	je     80225f <insert_sorted_allocList+0x6c>
  802252:	a1 40 40 80 00       	mov    0x804040,%eax
  802257:	8b 55 08             	mov    0x8(%ebp),%edx
  80225a:	89 50 04             	mov    %edx,0x4(%eax)
  80225d:	eb 08                	jmp    802267 <insert_sorted_allocList+0x74>
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 44 40 80 00       	mov    %eax,0x804044
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	a3 40 40 80 00       	mov    %eax,0x804040
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802279:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227e:	40                   	inc    %eax
  80227f:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802284:	e9 16 01 00 00       	jmp    80239f <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	8b 50 08             	mov    0x8(%eax),%edx
  80228f:	a1 44 40 80 00       	mov    0x804044,%eax
  802294:	8b 40 08             	mov    0x8(%eax),%eax
  802297:	39 c2                	cmp    %eax,%edx
  802299:	76 68                	jbe    802303 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80229b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229f:	75 17                	jne    8022b8 <insert_sorted_allocList+0xc5>
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	68 ec 3b 80 00       	push   $0x803bec
  8022a9:	68 85 00 00 00       	push   $0x85
  8022ae:	68 d3 3b 80 00       	push   $0x803bd3
  8022b3:	e8 b2 e0 ff ff       	call   80036a <_panic>
  8022b8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	89 50 04             	mov    %edx,0x4(%eax)
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	74 0c                	je     8022da <insert_sorted_allocList+0xe7>
  8022ce:	a1 44 40 80 00       	mov    0x804044,%eax
  8022d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d6:	89 10                	mov    %edx,(%eax)
  8022d8:	eb 08                	jmp    8022e2 <insert_sorted_allocList+0xef>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f8:	40                   	inc    %eax
  8022f9:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022fe:	e9 9c 00 00 00       	jmp    80239f <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802303:	a1 40 40 80 00       	mov    0x804040,%eax
  802308:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80230b:	e9 85 00 00 00       	jmp    802395 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8b 50 08             	mov    0x8(%eax),%edx
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 08             	mov    0x8(%eax),%eax
  80231c:	39 c2                	cmp    %eax,%edx
  80231e:	73 6d                	jae    80238d <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802324:	74 06                	je     80232c <insert_sorted_allocList+0x139>
  802326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232a:	75 17                	jne    802343 <insert_sorted_allocList+0x150>
  80232c:	83 ec 04             	sub    $0x4,%esp
  80232f:	68 10 3c 80 00       	push   $0x803c10
  802334:	68 90 00 00 00       	push   $0x90
  802339:	68 d3 3b 80 00       	push   $0x803bd3
  80233e:	e8 27 e0 ff ff       	call   80036a <_panic>
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 50 04             	mov    0x4(%eax),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	89 50 04             	mov    %edx,0x4(%eax)
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 0d                	je     80236e <insert_sorted_allocList+0x17b>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
  80236a:	89 10                	mov    %edx,(%eax)
  80236c:	eb 08                	jmp    802376 <insert_sorted_allocList+0x183>
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	a3 40 40 80 00       	mov    %eax,0x804040
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802384:	40                   	inc    %eax
  802385:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80238a:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80238b:	eb 12                	jmp    80239f <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802399:	0f 85 71 ff ff ff    	jne    802310 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80239f:	90                   	nop
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8023a8:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8023b0:	e9 76 01 00 00       	jmp    80252b <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023be:	0f 85 8a 00 00 00    	jne    80244e <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8023c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c8:	75 17                	jne    8023e1 <alloc_block_FF+0x3f>
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	68 45 3c 80 00       	push   $0x803c45
  8023d2:	68 a8 00 00 00       	push   $0xa8
  8023d7:	68 d3 3b 80 00       	push   $0x803bd3
  8023dc:	e8 89 df ff ff       	call   80036a <_panic>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	74 10                	je     8023fa <alloc_block_FF+0x58>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f2:	8b 52 04             	mov    0x4(%edx),%edx
  8023f5:	89 50 04             	mov    %edx,0x4(%eax)
  8023f8:	eb 0b                	jmp    802405 <alloc_block_FF+0x63>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 04             	mov    0x4(%eax),%eax
  802400:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 04             	mov    0x4(%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 0f                	je     80241e <alloc_block_FF+0x7c>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 04             	mov    0x4(%eax),%eax
  802415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802418:	8b 12                	mov    (%edx),%edx
  80241a:	89 10                	mov    %edx,(%eax)
  80241c:	eb 0a                	jmp    802428 <alloc_block_FF+0x86>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	a3 38 41 80 00       	mov    %eax,0x804138
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243b:	a1 44 41 80 00       	mov    0x804144,%eax
  802440:	48                   	dec    %eax
  802441:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	e9 ea 00 00 00       	jmp    802538 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 40 0c             	mov    0xc(%eax),%eax
  802454:	3b 45 08             	cmp    0x8(%ebp),%eax
  802457:	0f 86 c6 00 00 00    	jbe    802523 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80245d:	a1 48 41 80 00       	mov    0x804148,%eax
  802462:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	8b 55 08             	mov    0x8(%ebp),%edx
  80246b:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 50 08             	mov    0x8(%eax),%edx
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	2b 45 08             	sub    0x8(%ebp),%eax
  802483:	89 c2                	mov    %eax,%edx
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 50 08             	mov    0x8(%eax),%edx
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	01 c2                	add    %eax,%edx
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80249c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a0:	75 17                	jne    8024b9 <alloc_block_FF+0x117>
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	68 45 3c 80 00       	push   $0x803c45
  8024aa:	68 b6 00 00 00       	push   $0xb6
  8024af:	68 d3 3b 80 00       	push   $0x803bd3
  8024b4:	e8 b1 de ff ff       	call   80036a <_panic>
  8024b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	74 10                	je     8024d2 <alloc_block_FF+0x130>
  8024c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c5:	8b 00                	mov    (%eax),%eax
  8024c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ca:	8b 52 04             	mov    0x4(%edx),%edx
  8024cd:	89 50 04             	mov    %edx,0x4(%eax)
  8024d0:	eb 0b                	jmp    8024dd <alloc_block_FF+0x13b>
  8024d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d5:	8b 40 04             	mov    0x4(%eax),%eax
  8024d8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 0f                	je     8024f6 <alloc_block_FF+0x154>
  8024e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ea:	8b 40 04             	mov    0x4(%eax),%eax
  8024ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f0:	8b 12                	mov    (%edx),%edx
  8024f2:	89 10                	mov    %edx,(%eax)
  8024f4:	eb 0a                	jmp    802500 <alloc_block_FF+0x15e>
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	a3 48 41 80 00       	mov    %eax,0x804148
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802513:	a1 54 41 80 00       	mov    0x804154,%eax
  802518:	48                   	dec    %eax
  802519:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	eb 15                	jmp    802538 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252f:	0f 85 80 fe ff ff    	jne    8023b5 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802540:	a1 38 41 80 00       	mov    0x804138,%eax
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802548:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80254f:	e9 c0 00 00 00       	jmp    802614 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255d:	0f 85 8a 00 00 00    	jne    8025ed <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802567:	75 17                	jne    802580 <alloc_block_BF+0x46>
  802569:	83 ec 04             	sub    $0x4,%esp
  80256c:	68 45 3c 80 00       	push   $0x803c45
  802571:	68 cf 00 00 00       	push   $0xcf
  802576:	68 d3 3b 80 00       	push   $0x803bd3
  80257b:	e8 ea dd ff ff       	call   80036a <_panic>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	85 c0                	test   %eax,%eax
  802587:	74 10                	je     802599 <alloc_block_BF+0x5f>
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	8b 52 04             	mov    0x4(%edx),%edx
  802594:	89 50 04             	mov    %edx,0x4(%eax)
  802597:	eb 0b                	jmp    8025a4 <alloc_block_BF+0x6a>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	74 0f                	je     8025bd <alloc_block_BF+0x83>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b7:	8b 12                	mov    (%edx),%edx
  8025b9:	89 10                	mov    %edx,(%eax)
  8025bb:	eb 0a                	jmp    8025c7 <alloc_block_BF+0x8d>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	a3 38 41 80 00       	mov    %eax,0x804138
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025da:	a1 44 41 80 00       	mov    0x804144,%eax
  8025df:	48                   	dec    %eax
  8025e0:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	e9 2a 01 00 00       	jmp    802717 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025f6:	73 14                	jae    80260c <alloc_block_BF+0xd2>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802601:	76 09                	jbe    80260c <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 0c             	mov    0xc(%eax),%eax
  802609:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	0f 85 36 ff ff ff    	jne    802554 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80261e:	a1 38 41 80 00       	mov    0x804138,%eax
  802623:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802626:	e9 dd 00 00 00       	jmp    802708 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 0c             	mov    0xc(%eax),%eax
  802631:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802634:	0f 85 c6 00 00 00    	jne    802700 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80263a:	a1 48 41 80 00       	mov    0x804148,%eax
  80263f:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 50 08             	mov    0x8(%eax),%edx
  802648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264b:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	8b 55 08             	mov    0x8(%ebp),%edx
  802654:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 50 08             	mov    0x8(%eax),%edx
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	01 c2                	add    %eax,%edx
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	2b 45 08             	sub    0x8(%ebp),%eax
  802671:	89 c2                	mov    %eax,%edx
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802679:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80267d:	75 17                	jne    802696 <alloc_block_BF+0x15c>
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	68 45 3c 80 00       	push   $0x803c45
  802687:	68 eb 00 00 00       	push   $0xeb
  80268c:	68 d3 3b 80 00       	push   $0x803bd3
  802691:	e8 d4 dc ff ff       	call   80036a <_panic>
  802696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	85 c0                	test   %eax,%eax
  80269d:	74 10                	je     8026af <alloc_block_BF+0x175>
  80269f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a7:	8b 52 04             	mov    0x4(%edx),%edx
  8026aa:	89 50 04             	mov    %edx,0x4(%eax)
  8026ad:	eb 0b                	jmp    8026ba <alloc_block_BF+0x180>
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 0f                	je     8026d3 <alloc_block_BF+0x199>
  8026c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026cd:	8b 12                	mov    (%edx),%edx
  8026cf:	89 10                	mov    %edx,(%eax)
  8026d1:	eb 0a                	jmp    8026dd <alloc_block_BF+0x1a3>
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	a3 48 41 80 00       	mov    %eax,0x804148
  8026dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8026f5:	48                   	dec    %eax
  8026f6:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	eb 17                	jmp    802717 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270c:	0f 85 19 ff ff ff    	jne    80262b <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80271f:	a1 40 40 80 00       	mov    0x804040,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	75 19                	jne    802741 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802728:	83 ec 0c             	sub    $0xc,%esp
  80272b:	ff 75 08             	pushl  0x8(%ebp)
  80272e:	e8 6f fc ff ff       	call   8023a2 <alloc_block_FF>
  802733:	83 c4 10             	add    $0x10,%esp
  802736:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	e9 e9 01 00 00       	jmp    80292a <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802741:	a1 44 40 80 00       	mov    0x804044,%eax
  802746:	8b 40 08             	mov    0x8(%eax),%eax
  802749:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80274c:	a1 44 40 80 00       	mov    0x804044,%eax
  802751:	8b 50 0c             	mov    0xc(%eax),%edx
  802754:	a1 44 40 80 00       	mov    0x804044,%eax
  802759:	8b 40 08             	mov    0x8(%eax),%eax
  80275c:	01 d0                	add    %edx,%eax
  80275e:	83 ec 08             	sub    $0x8,%esp
  802761:	50                   	push   %eax
  802762:	68 38 41 80 00       	push   $0x804138
  802767:	e8 54 fa ff ff       	call   8021c0 <find_block>
  80276c:	83 c4 10             	add    $0x10,%esp
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 0c             	mov    0xc(%eax),%eax
  802778:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277b:	0f 85 9b 00 00 00    	jne    80281c <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 50 0c             	mov    0xc(%eax),%edx
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802796:	75 17                	jne    8027af <alloc_block_NF+0x96>
  802798:	83 ec 04             	sub    $0x4,%esp
  80279b:	68 45 3c 80 00       	push   $0x803c45
  8027a0:	68 1a 01 00 00       	push   $0x11a
  8027a5:	68 d3 3b 80 00       	push   $0x803bd3
  8027aa:	e8 bb db ff ff       	call   80036a <_panic>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 10                	je     8027c8 <alloc_block_NF+0xaf>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c0:	8b 52 04             	mov    0x4(%edx),%edx
  8027c3:	89 50 04             	mov    %edx,0x4(%eax)
  8027c6:	eb 0b                	jmp    8027d3 <alloc_block_NF+0xba>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 0f                	je     8027ec <alloc_block_NF+0xd3>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 04             	mov    0x4(%eax),%eax
  8027e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e6:	8b 12                	mov    (%edx),%edx
  8027e8:	89 10                	mov    %edx,(%eax)
  8027ea:	eb 0a                	jmp    8027f6 <alloc_block_NF+0xdd>
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802809:	a1 44 41 80 00       	mov    0x804144,%eax
  80280e:	48                   	dec    %eax
  80280f:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	e9 0e 01 00 00       	jmp    80292a <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 0c             	mov    0xc(%eax),%eax
  802822:	3b 45 08             	cmp    0x8(%ebp),%eax
  802825:	0f 86 cf 00 00 00    	jbe    8028fa <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80282b:	a1 48 41 80 00       	mov    0x804148,%eax
  802830:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	8b 55 08             	mov    0x8(%ebp),%edx
  802839:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 50 08             	mov    0x8(%eax),%edx
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 50 08             	mov    0x8(%eax),%edx
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	01 c2                	add    %eax,%edx
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	2b 45 08             	sub    0x8(%ebp),%eax
  802862:	89 c2                	mov    %eax,%edx
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 08             	mov    0x8(%eax),%eax
  802870:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802873:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802877:	75 17                	jne    802890 <alloc_block_NF+0x177>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 45 3c 80 00       	push   $0x803c45
  802881:	68 28 01 00 00       	push   $0x128
  802886:	68 d3 3b 80 00       	push   $0x803bd3
  80288b:	e8 da da ff ff       	call   80036a <_panic>
  802890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 10                	je     8028a9 <alloc_block_NF+0x190>
  802899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a1:	8b 52 04             	mov    0x4(%edx),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 0b                	jmp    8028b4 <alloc_block_NF+0x19b>
  8028a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0f                	je     8028cd <alloc_block_NF+0x1b4>
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c7:	8b 12                	mov    (%edx),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 0a                	jmp    8028d7 <alloc_block_NF+0x1be>
  8028cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ef:	48                   	dec    %eax
  8028f0:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	eb 30                	jmp    80292a <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8028fa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802902:	75 0a                	jne    80290e <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802904:	a1 38 41 80 00       	mov    0x804138,%eax
  802909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290c:	eb 08                	jmp    802916 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 08             	mov    0x8(%eax),%eax
  80291c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80291f:	0f 85 4d fe ff ff    	jne    802772 <alloc_block_NF+0x59>

			return NULL;
  802925:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	53                   	push   %ebx
  802930:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802933:	a1 38 41 80 00       	mov    0x804138,%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	0f 85 86 00 00 00    	jne    8029c6 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802940:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802947:	00 00 00 
  80294a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802951:	00 00 00 
  802954:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80295b:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80295e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802962:	75 17                	jne    80297b <insert_sorted_with_merge_freeList+0x4f>
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 b0 3b 80 00       	push   $0x803bb0
  80296c:	68 48 01 00 00       	push   $0x148
  802971:	68 d3 3b 80 00       	push   $0x803bd3
  802976:	e8 ef d9 ff ff       	call   80036a <_panic>
  80297b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	89 10                	mov    %edx,(%eax)
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 0d                	je     80299c <insert_sorted_with_merge_freeList+0x70>
  80298f:	a1 38 41 80 00       	mov    0x804138,%eax
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	eb 08                	jmp    8029a4 <insert_sorted_with_merge_freeList+0x78>
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029bb:	40                   	inc    %eax
  8029bc:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8029c1:	e9 73 07 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	8b 50 08             	mov    0x8(%eax),%edx
  8029cc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	39 c2                	cmp    %eax,%edx
  8029d6:	0f 86 84 00 00 00    	jbe    802a60 <insert_sorted_with_merge_freeList+0x134>
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	8b 50 08             	mov    0x8(%eax),%edx
  8029e2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029ea:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ef:	8b 40 08             	mov    0x8(%eax),%eax
  8029f2:	01 c8                	add    %ecx,%eax
  8029f4:	39 c2                	cmp    %eax,%edx
  8029f6:	74 68                	je     802a60 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8029f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fc:	75 17                	jne    802a15 <insert_sorted_with_merge_freeList+0xe9>
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	68 ec 3b 80 00       	push   $0x803bec
  802a06:	68 4c 01 00 00       	push   $0x14c
  802a0b:	68 d3 3b 80 00       	push   $0x803bd3
  802a10:	e8 55 d9 ff ff       	call   80036a <_panic>
  802a15:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	89 50 04             	mov    %edx,0x4(%eax)
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0c                	je     802a37 <insert_sorted_with_merge_freeList+0x10b>
  802a2b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a30:	8b 55 08             	mov    0x8(%ebp),%edx
  802a33:	89 10                	mov    %edx,(%eax)
  802a35:	eb 08                	jmp    802a3f <insert_sorted_with_merge_freeList+0x113>
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a50:	a1 44 41 80 00       	mov    0x804144,%eax
  802a55:	40                   	inc    %eax
  802a56:	a3 44 41 80 00       	mov    %eax,0x804144
  802a5b:	e9 d9 06 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	8b 50 08             	mov    0x8(%eax),%edx
  802a66:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a6b:	8b 40 08             	mov    0x8(%eax),%eax
  802a6e:	39 c2                	cmp    %eax,%edx
  802a70:	0f 86 b5 00 00 00    	jbe    802b2b <insert_sorted_with_merge_freeList+0x1ff>
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 50 08             	mov    0x8(%eax),%edx
  802a7c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a81:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a84:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a89:	8b 40 08             	mov    0x8(%eax),%eax
  802a8c:	01 c8                	add    %ecx,%eax
  802a8e:	39 c2                	cmp    %eax,%edx
  802a90:	0f 85 95 00 00 00    	jne    802b2b <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802a96:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a9b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802aa1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa7:	8b 52 0c             	mov    0xc(%edx),%edx
  802aaa:	01 ca                	add    %ecx,%edx
  802aac:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ac3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac7:	75 17                	jne    802ae0 <insert_sorted_with_merge_freeList+0x1b4>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 b0 3b 80 00       	push   $0x803bb0
  802ad1:	68 54 01 00 00       	push   $0x154
  802ad6:	68 d3 3b 80 00       	push   $0x803bd3
  802adb:	e8 8a d8 ff ff       	call   80036a <_panic>
  802ae0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 0d                	je     802b01 <insert_sorted_with_merge_freeList+0x1d5>
  802af4:	a1 48 41 80 00       	mov    0x804148,%eax
  802af9:	8b 55 08             	mov    0x8(%ebp),%edx
  802afc:	89 50 04             	mov    %edx,0x4(%eax)
  802aff:	eb 08                	jmp    802b09 <insert_sorted_with_merge_freeList+0x1dd>
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b20:	40                   	inc    %eax
  802b21:	a3 54 41 80 00       	mov    %eax,0x804154
  802b26:	e9 0e 06 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	8b 50 08             	mov    0x8(%eax),%edx
  802b31:	a1 38 41 80 00       	mov    0x804138,%eax
  802b36:	8b 40 08             	mov    0x8(%eax),%eax
  802b39:	39 c2                	cmp    %eax,%edx
  802b3b:	0f 83 c1 00 00 00    	jae    802c02 <insert_sorted_with_merge_freeList+0x2d6>
  802b41:	a1 38 41 80 00       	mov    0x804138,%eax
  802b46:	8b 50 08             	mov    0x8(%eax),%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	8b 48 08             	mov    0x8(%eax),%ecx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	01 c8                	add    %ecx,%eax
  802b57:	39 c2                	cmp    %eax,%edx
  802b59:	0f 85 a3 00 00 00    	jne    802c02 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b5f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b64:	8b 55 08             	mov    0x8(%ebp),%edx
  802b67:	8b 52 08             	mov    0x8(%edx),%edx
  802b6a:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b6d:	a1 38 41 80 00       	mov    0x804138,%eax
  802b72:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b78:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	8b 52 0c             	mov    0xc(%edx),%edx
  802b81:	01 ca                	add    %ecx,%edx
  802b83:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9e:	75 17                	jne    802bb7 <insert_sorted_with_merge_freeList+0x28b>
  802ba0:	83 ec 04             	sub    $0x4,%esp
  802ba3:	68 b0 3b 80 00       	push   $0x803bb0
  802ba8:	68 5d 01 00 00       	push   $0x15d
  802bad:	68 d3 3b 80 00       	push   $0x803bd3
  802bb2:	e8 b3 d7 ff ff       	call   80036a <_panic>
  802bb7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	89 10                	mov    %edx,(%eax)
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 0d                	je     802bd8 <insert_sorted_with_merge_freeList+0x2ac>
  802bcb:	a1 48 41 80 00       	mov    0x804148,%eax
  802bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd3:	89 50 04             	mov    %edx,0x4(%eax)
  802bd6:	eb 08                	jmp    802be0 <insert_sorted_with_merge_freeList+0x2b4>
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	a3 48 41 80 00       	mov    %eax,0x804148
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf2:	a1 54 41 80 00       	mov    0x804154,%eax
  802bf7:	40                   	inc    %eax
  802bf8:	a3 54 41 80 00       	mov    %eax,0x804154
  802bfd:	e9 37 05 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 50 08             	mov    0x8(%eax),%edx
  802c08:	a1 38 41 80 00       	mov    0x804138,%eax
  802c0d:	8b 40 08             	mov    0x8(%eax),%eax
  802c10:	39 c2                	cmp    %eax,%edx
  802c12:	0f 83 82 00 00 00    	jae    802c9a <insert_sorted_with_merge_freeList+0x36e>
  802c18:	a1 38 41 80 00       	mov    0x804138,%eax
  802c1d:	8b 50 08             	mov    0x8(%eax),%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	8b 48 08             	mov    0x8(%eax),%ecx
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	01 c8                	add    %ecx,%eax
  802c2e:	39 c2                	cmp    %eax,%edx
  802c30:	74 68                	je     802c9a <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c36:	75 17                	jne    802c4f <insert_sorted_with_merge_freeList+0x323>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 b0 3b 80 00       	push   $0x803bb0
  802c40:	68 62 01 00 00       	push   $0x162
  802c45:	68 d3 3b 80 00       	push   $0x803bd3
  802c4a:	e8 1b d7 ff ff       	call   80036a <_panic>
  802c4f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	89 10                	mov    %edx,(%eax)
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 0d                	je     802c70 <insert_sorted_with_merge_freeList+0x344>
  802c63:	a1 38 41 80 00       	mov    0x804138,%eax
  802c68:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6b:	89 50 04             	mov    %edx,0x4(%eax)
  802c6e:	eb 08                	jmp    802c78 <insert_sorted_with_merge_freeList+0x34c>
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c8f:	40                   	inc    %eax
  802c90:	a3 44 41 80 00       	mov    %eax,0x804144
  802c95:	e9 9f 04 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c9a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802ca4:	e9 84 04 00 00       	jmp    80312d <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 50 08             	mov    0x8(%eax),%edx
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 40 08             	mov    0x8(%eax),%eax
  802cb5:	39 c2                	cmp    %eax,%edx
  802cb7:	0f 86 a9 00 00 00    	jbe    802d66 <insert_sorted_with_merge_freeList+0x43a>
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 50 08             	mov    0x8(%eax),%edx
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 48 08             	mov    0x8(%eax),%ecx
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	01 c8                	add    %ecx,%eax
  802cd1:	39 c2                	cmp    %eax,%edx
  802cd3:	0f 84 8d 00 00 00    	je     802d66 <insert_sorted_with_merge_freeList+0x43a>
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 50 08             	mov    0x8(%eax),%edx
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	8b 48 08             	mov    0x8(%eax),%ecx
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 40 04             	mov    0x4(%eax),%eax
  802cee:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf1:	01 c8                	add    %ecx,%eax
  802cf3:	39 c2                	cmp    %eax,%edx
  802cf5:	74 6f                	je     802d66 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfb:	74 06                	je     802d03 <insert_sorted_with_merge_freeList+0x3d7>
  802cfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d01:	75 17                	jne    802d1a <insert_sorted_with_merge_freeList+0x3ee>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 10 3c 80 00       	push   $0x803c10
  802d0b:	68 6b 01 00 00       	push   $0x16b
  802d10:	68 d3 3b 80 00       	push   $0x803bd3
  802d15:	e8 50 d6 ff ff       	call   80036a <_panic>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 50 04             	mov    0x4(%eax),%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	89 50 04             	mov    %edx,0x4(%eax)
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 0d                	je     802d45 <insert_sorted_with_merge_freeList+0x419>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d41:	89 10                	mov    %edx,(%eax)
  802d43:	eb 08                	jmp    802d4d <insert_sorted_with_merge_freeList+0x421>
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 38 41 80 00       	mov    %eax,0x804138
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 55 08             	mov    0x8(%ebp),%edx
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	a1 44 41 80 00       	mov    0x804144,%eax
  802d5b:	40                   	inc    %eax
  802d5c:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d61:	e9 d3 03 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	8b 40 08             	mov    0x8(%eax),%eax
  802d72:	39 c2                	cmp    %eax,%edx
  802d74:	0f 86 da 00 00 00    	jbe    802e54 <insert_sorted_with_merge_freeList+0x528>
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 48 08             	mov    0x8(%eax),%ecx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8c:	01 c8                	add    %ecx,%eax
  802d8e:	39 c2                	cmp    %eax,%edx
  802d90:	0f 85 be 00 00 00    	jne    802e54 <insert_sorted_with_merge_freeList+0x528>
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	8b 50 08             	mov    0x8(%eax),%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	8b 48 08             	mov    0x8(%eax),%ecx
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	8b 40 0c             	mov    0xc(%eax),%eax
  802dae:	01 c8                	add    %ecx,%eax
  802db0:	39 c2                	cmp    %eax,%edx
  802db2:	0f 84 9c 00 00 00    	je     802e54 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 50 0c             	mov    0xc(%eax),%edx
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df0:	75 17                	jne    802e09 <insert_sorted_with_merge_freeList+0x4dd>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 b0 3b 80 00       	push   $0x803bb0
  802dfa:	68 74 01 00 00       	push   $0x174
  802dff:	68 d3 3b 80 00       	push   $0x803bd3
  802e04:	e8 61 d5 ff ff       	call   80036a <_panic>
  802e09:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0d                	je     802e2a <insert_sorted_with_merge_freeList+0x4fe>
  802e1d:	a1 48 41 80 00       	mov    0x804148,%eax
  802e22:	8b 55 08             	mov    0x8(%ebp),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 08                	jmp    802e32 <insert_sorted_with_merge_freeList+0x506>
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 54 41 80 00       	mov    0x804154,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e4f:	e9 e5 02 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	39 c2                	cmp    %eax,%edx
  802e62:	0f 86 d7 00 00 00    	jbe    802f3f <insert_sorted_with_merge_freeList+0x613>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 48 08             	mov    0x8(%eax),%ecx
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7a:	01 c8                	add    %ecx,%eax
  802e7c:	39 c2                	cmp    %eax,%edx
  802e7e:	0f 84 bb 00 00 00    	je     802f3f <insert_sorted_with_merge_freeList+0x613>
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 50 08             	mov    0x8(%eax),%edx
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	8b 48 08             	mov    0x8(%eax),%ecx
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 04             	mov    0x4(%eax),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	01 c8                	add    %ecx,%eax
  802e9e:	39 c2                	cmp    %eax,%edx
  802ea0:	0f 85 99 00 00 00    	jne    802f3f <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 40 04             	mov    0x4(%eax),%eax
  802eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebb:	01 c2                	add    %eax,%edx
  802ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec0:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ed7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802edb:	75 17                	jne    802ef4 <insert_sorted_with_merge_freeList+0x5c8>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 b0 3b 80 00       	push   $0x803bb0
  802ee5:	68 7d 01 00 00       	push   $0x17d
  802eea:	68 d3 3b 80 00       	push   $0x803bd3
  802eef:	e8 76 d4 ff ff       	call   80036a <_panic>
  802ef4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	89 10                	mov    %edx,(%eax)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 0d                	je     802f15 <insert_sorted_with_merge_freeList+0x5e9>
  802f08:	a1 48 41 80 00       	mov    0x804148,%eax
  802f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f10:	89 50 04             	mov    %edx,0x4(%eax)
  802f13:	eb 08                	jmp    802f1d <insert_sorted_with_merge_freeList+0x5f1>
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 48 41 80 00       	mov    %eax,0x804148
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f34:	40                   	inc    %eax
  802f35:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f3a:	e9 fa 01 00 00       	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 50 08             	mov    0x8(%eax),%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	8b 40 08             	mov    0x8(%eax),%eax
  802f4b:	39 c2                	cmp    %eax,%edx
  802f4d:	0f 86 d2 01 00 00    	jbe    803125 <insert_sorted_with_merge_freeList+0x7f9>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 50 08             	mov    0x8(%eax),%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 48 08             	mov    0x8(%eax),%ecx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c8                	add    %ecx,%eax
  802f67:	39 c2                	cmp    %eax,%edx
  802f69:	0f 85 b6 01 00 00    	jne    803125 <insert_sorted_with_merge_freeList+0x7f9>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	8b 48 08             	mov    0x8(%eax),%ecx
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	8b 40 0c             	mov    0xc(%eax),%eax
  802f87:	01 c8                	add    %ecx,%eax
  802f89:	39 c2                	cmp    %eax,%edx
  802f8b:	0f 85 94 01 00 00    	jne    803125 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9a:	8b 52 04             	mov    0x4(%edx),%edx
  802f9d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa3:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa9:	8b 52 0c             	mov    0xc(%edx),%edx
  802fac:	01 da                	add    %ebx,%edx
  802fae:	01 ca                	add    %ecx,%edx
  802fb0:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcb:	75 17                	jne    802fe4 <insert_sorted_with_merge_freeList+0x6b8>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 45 3c 80 00       	push   $0x803c45
  802fd5:	68 86 01 00 00       	push   $0x186
  802fda:	68 d3 3b 80 00       	push   $0x803bd3
  802fdf:	e8 86 d3 ff ff       	call   80036a <_panic>
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 10                	je     802ffd <insert_sorted_with_merge_freeList+0x6d1>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff5:	8b 52 04             	mov    0x4(%edx),%edx
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	eb 0b                	jmp    803008 <insert_sorted_with_merge_freeList+0x6dc>
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 0f                	je     803021 <insert_sorted_with_merge_freeList+0x6f5>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301b:	8b 12                	mov    (%edx),%edx
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	eb 0a                	jmp    80302b <insert_sorted_with_merge_freeList+0x6ff>
  803021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	a3 38 41 80 00       	mov    %eax,0x804138
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 44 41 80 00       	mov    0x804144,%eax
  803043:	48                   	dec    %eax
  803044:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304d:	75 17                	jne    803066 <insert_sorted_with_merge_freeList+0x73a>
  80304f:	83 ec 04             	sub    $0x4,%esp
  803052:	68 b0 3b 80 00       	push   $0x803bb0
  803057:	68 87 01 00 00       	push   $0x187
  80305c:	68 d3 3b 80 00       	push   $0x803bd3
  803061:	e8 04 d3 ff ff       	call   80036a <_panic>
  803066:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	89 10                	mov    %edx,(%eax)
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	85 c0                	test   %eax,%eax
  803078:	74 0d                	je     803087 <insert_sorted_with_merge_freeList+0x75b>
  80307a:	a1 48 41 80 00       	mov    0x804148,%eax
  80307f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803082:	89 50 04             	mov    %edx,0x4(%eax)
  803085:	eb 08                	jmp    80308f <insert_sorted_with_merge_freeList+0x763>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	a3 48 41 80 00       	mov    %eax,0x804148
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a1:	a1 54 41 80 00       	mov    0x804154,%eax
  8030a6:	40                   	inc    %eax
  8030a7:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c4:	75 17                	jne    8030dd <insert_sorted_with_merge_freeList+0x7b1>
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	68 b0 3b 80 00       	push   $0x803bb0
  8030ce:	68 8a 01 00 00       	push   $0x18a
  8030d3:	68 d3 3b 80 00       	push   $0x803bd3
  8030d8:	e8 8d d2 ff ff       	call   80036a <_panic>
  8030dd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	89 10                	mov    %edx,(%eax)
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	74 0d                	je     8030fe <insert_sorted_with_merge_freeList+0x7d2>
  8030f1:	a1 48 41 80 00       	mov    0x804148,%eax
  8030f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f9:	89 50 04             	mov    %edx,0x4(%eax)
  8030fc:	eb 08                	jmp    803106 <insert_sorted_with_merge_freeList+0x7da>
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	a3 48 41 80 00       	mov    %eax,0x804148
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803118:	a1 54 41 80 00       	mov    0x804154,%eax
  80311d:	40                   	inc    %eax
  80311e:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803123:	eb 14                	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80312d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803131:	0f 85 72 fb ff ff    	jne    802ca9 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803137:	eb 00                	jmp    803139 <insert_sorted_with_merge_freeList+0x80d>
  803139:	90                   	nop
  80313a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    
  80313f:	90                   	nop

00803140 <__udivdi3>:
  803140:	55                   	push   %ebp
  803141:	57                   	push   %edi
  803142:	56                   	push   %esi
  803143:	53                   	push   %ebx
  803144:	83 ec 1c             	sub    $0x1c,%esp
  803147:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80314b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80314f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803153:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803157:	89 ca                	mov    %ecx,%edx
  803159:	89 f8                	mov    %edi,%eax
  80315b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80315f:	85 f6                	test   %esi,%esi
  803161:	75 2d                	jne    803190 <__udivdi3+0x50>
  803163:	39 cf                	cmp    %ecx,%edi
  803165:	77 65                	ja     8031cc <__udivdi3+0x8c>
  803167:	89 fd                	mov    %edi,%ebp
  803169:	85 ff                	test   %edi,%edi
  80316b:	75 0b                	jne    803178 <__udivdi3+0x38>
  80316d:	b8 01 00 00 00       	mov    $0x1,%eax
  803172:	31 d2                	xor    %edx,%edx
  803174:	f7 f7                	div    %edi
  803176:	89 c5                	mov    %eax,%ebp
  803178:	31 d2                	xor    %edx,%edx
  80317a:	89 c8                	mov    %ecx,%eax
  80317c:	f7 f5                	div    %ebp
  80317e:	89 c1                	mov    %eax,%ecx
  803180:	89 d8                	mov    %ebx,%eax
  803182:	f7 f5                	div    %ebp
  803184:	89 cf                	mov    %ecx,%edi
  803186:	89 fa                	mov    %edi,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	39 ce                	cmp    %ecx,%esi
  803192:	77 28                	ja     8031bc <__udivdi3+0x7c>
  803194:	0f bd fe             	bsr    %esi,%edi
  803197:	83 f7 1f             	xor    $0x1f,%edi
  80319a:	75 40                	jne    8031dc <__udivdi3+0x9c>
  80319c:	39 ce                	cmp    %ecx,%esi
  80319e:	72 0a                	jb     8031aa <__udivdi3+0x6a>
  8031a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031a4:	0f 87 9e 00 00 00    	ja     803248 <__udivdi3+0x108>
  8031aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031af:	89 fa                	mov    %edi,%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d 76 00             	lea    0x0(%esi),%esi
  8031bc:	31 ff                	xor    %edi,%edi
  8031be:	31 c0                	xor    %eax,%eax
  8031c0:	89 fa                	mov    %edi,%edx
  8031c2:	83 c4 1c             	add    $0x1c,%esp
  8031c5:	5b                   	pop    %ebx
  8031c6:	5e                   	pop    %esi
  8031c7:	5f                   	pop    %edi
  8031c8:	5d                   	pop    %ebp
  8031c9:	c3                   	ret    
  8031ca:	66 90                	xchg   %ax,%ax
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	f7 f7                	div    %edi
  8031d0:	31 ff                	xor    %edi,%edi
  8031d2:	89 fa                	mov    %edi,%edx
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    
  8031dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031e1:	89 eb                	mov    %ebp,%ebx
  8031e3:	29 fb                	sub    %edi,%ebx
  8031e5:	89 f9                	mov    %edi,%ecx
  8031e7:	d3 e6                	shl    %cl,%esi
  8031e9:	89 c5                	mov    %eax,%ebp
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 ed                	shr    %cl,%ebp
  8031ef:	89 e9                	mov    %ebp,%ecx
  8031f1:	09 f1                	or     %esi,%ecx
  8031f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031f7:	89 f9                	mov    %edi,%ecx
  8031f9:	d3 e0                	shl    %cl,%eax
  8031fb:	89 c5                	mov    %eax,%ebp
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	88 d9                	mov    %bl,%cl
  803201:	d3 ee                	shr    %cl,%esi
  803203:	89 f9                	mov    %edi,%ecx
  803205:	d3 e2                	shl    %cl,%edx
  803207:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320b:	88 d9                	mov    %bl,%cl
  80320d:	d3 e8                	shr    %cl,%eax
  80320f:	09 c2                	or     %eax,%edx
  803211:	89 d0                	mov    %edx,%eax
  803213:	89 f2                	mov    %esi,%edx
  803215:	f7 74 24 0c          	divl   0xc(%esp)
  803219:	89 d6                	mov    %edx,%esi
  80321b:	89 c3                	mov    %eax,%ebx
  80321d:	f7 e5                	mul    %ebp
  80321f:	39 d6                	cmp    %edx,%esi
  803221:	72 19                	jb     80323c <__udivdi3+0xfc>
  803223:	74 0b                	je     803230 <__udivdi3+0xf0>
  803225:	89 d8                	mov    %ebx,%eax
  803227:	31 ff                	xor    %edi,%edi
  803229:	e9 58 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80322e:	66 90                	xchg   %ax,%ax
  803230:	8b 54 24 08          	mov    0x8(%esp),%edx
  803234:	89 f9                	mov    %edi,%ecx
  803236:	d3 e2                	shl    %cl,%edx
  803238:	39 c2                	cmp    %eax,%edx
  80323a:	73 e9                	jae    803225 <__udivdi3+0xe5>
  80323c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80323f:	31 ff                	xor    %edi,%edi
  803241:	e9 40 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  803246:	66 90                	xchg   %ax,%ax
  803248:	31 c0                	xor    %eax,%eax
  80324a:	e9 37 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80324f:	90                   	nop

00803250 <__umoddi3>:
  803250:	55                   	push   %ebp
  803251:	57                   	push   %edi
  803252:	56                   	push   %esi
  803253:	53                   	push   %ebx
  803254:	83 ec 1c             	sub    $0x1c,%esp
  803257:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80325b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80325f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803263:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803267:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80326b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80326f:	89 f3                	mov    %esi,%ebx
  803271:	89 fa                	mov    %edi,%edx
  803273:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803277:	89 34 24             	mov    %esi,(%esp)
  80327a:	85 c0                	test   %eax,%eax
  80327c:	75 1a                	jne    803298 <__umoddi3+0x48>
  80327e:	39 f7                	cmp    %esi,%edi
  803280:	0f 86 a2 00 00 00    	jbe    803328 <__umoddi3+0xd8>
  803286:	89 c8                	mov    %ecx,%eax
  803288:	89 f2                	mov    %esi,%edx
  80328a:	f7 f7                	div    %edi
  80328c:	89 d0                	mov    %edx,%eax
  80328e:	31 d2                	xor    %edx,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	39 f0                	cmp    %esi,%eax
  80329a:	0f 87 ac 00 00 00    	ja     80334c <__umoddi3+0xfc>
  8032a0:	0f bd e8             	bsr    %eax,%ebp
  8032a3:	83 f5 1f             	xor    $0x1f,%ebp
  8032a6:	0f 84 ac 00 00 00    	je     803358 <__umoddi3+0x108>
  8032ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8032b1:	29 ef                	sub    %ebp,%edi
  8032b3:	89 fe                	mov    %edi,%esi
  8032b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b9:	89 e9                	mov    %ebp,%ecx
  8032bb:	d3 e0                	shl    %cl,%eax
  8032bd:	89 d7                	mov    %edx,%edi
  8032bf:	89 f1                	mov    %esi,%ecx
  8032c1:	d3 ef                	shr    %cl,%edi
  8032c3:	09 c7                	or     %eax,%edi
  8032c5:	89 e9                	mov    %ebp,%ecx
  8032c7:	d3 e2                	shl    %cl,%edx
  8032c9:	89 14 24             	mov    %edx,(%esp)
  8032cc:	89 d8                	mov    %ebx,%eax
  8032ce:	d3 e0                	shl    %cl,%eax
  8032d0:	89 c2                	mov    %eax,%edx
  8032d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d6:	d3 e0                	shl    %cl,%eax
  8032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e0:	89 f1                	mov    %esi,%ecx
  8032e2:	d3 e8                	shr    %cl,%eax
  8032e4:	09 d0                	or     %edx,%eax
  8032e6:	d3 eb                	shr    %cl,%ebx
  8032e8:	89 da                	mov    %ebx,%edx
  8032ea:	f7 f7                	div    %edi
  8032ec:	89 d3                	mov    %edx,%ebx
  8032ee:	f7 24 24             	mull   (%esp)
  8032f1:	89 c6                	mov    %eax,%esi
  8032f3:	89 d1                	mov    %edx,%ecx
  8032f5:	39 d3                	cmp    %edx,%ebx
  8032f7:	0f 82 87 00 00 00    	jb     803384 <__umoddi3+0x134>
  8032fd:	0f 84 91 00 00 00    	je     803394 <__umoddi3+0x144>
  803303:	8b 54 24 04          	mov    0x4(%esp),%edx
  803307:	29 f2                	sub    %esi,%edx
  803309:	19 cb                	sbb    %ecx,%ebx
  80330b:	89 d8                	mov    %ebx,%eax
  80330d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803311:	d3 e0                	shl    %cl,%eax
  803313:	89 e9                	mov    %ebp,%ecx
  803315:	d3 ea                	shr    %cl,%edx
  803317:	09 d0                	or     %edx,%eax
  803319:	89 e9                	mov    %ebp,%ecx
  80331b:	d3 eb                	shr    %cl,%ebx
  80331d:	89 da                	mov    %ebx,%edx
  80331f:	83 c4 1c             	add    $0x1c,%esp
  803322:	5b                   	pop    %ebx
  803323:	5e                   	pop    %esi
  803324:	5f                   	pop    %edi
  803325:	5d                   	pop    %ebp
  803326:	c3                   	ret    
  803327:	90                   	nop
  803328:	89 fd                	mov    %edi,%ebp
  80332a:	85 ff                	test   %edi,%edi
  80332c:	75 0b                	jne    803339 <__umoddi3+0xe9>
  80332e:	b8 01 00 00 00       	mov    $0x1,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f7                	div    %edi
  803337:	89 c5                	mov    %eax,%ebp
  803339:	89 f0                	mov    %esi,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f5                	div    %ebp
  80333f:	89 c8                	mov    %ecx,%eax
  803341:	f7 f5                	div    %ebp
  803343:	89 d0                	mov    %edx,%eax
  803345:	e9 44 ff ff ff       	jmp    80328e <__umoddi3+0x3e>
  80334a:	66 90                	xchg   %ax,%ax
  80334c:	89 c8                	mov    %ecx,%eax
  80334e:	89 f2                	mov    %esi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	3b 04 24             	cmp    (%esp),%eax
  80335b:	72 06                	jb     803363 <__umoddi3+0x113>
  80335d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803361:	77 0f                	ja     803372 <__umoddi3+0x122>
  803363:	89 f2                	mov    %esi,%edx
  803365:	29 f9                	sub    %edi,%ecx
  803367:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80336b:	89 14 24             	mov    %edx,(%esp)
  80336e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803372:	8b 44 24 04          	mov    0x4(%esp),%eax
  803376:	8b 14 24             	mov    (%esp),%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	2b 04 24             	sub    (%esp),%eax
  803387:	19 fa                	sbb    %edi,%edx
  803389:	89 d1                	mov    %edx,%ecx
  80338b:	89 c6                	mov    %eax,%esi
  80338d:	e9 71 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
  803392:	66 90                	xchg   %ax,%ax
  803394:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803398:	72 ea                	jb     803384 <__umoddi3+0x134>
  80339a:	89 d9                	mov    %ebx,%ecx
  80339c:	e9 62 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
