
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 b2 21 00 00       	call   8021f8 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3a 80 00       	push   $0x803ae0
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3a 80 00       	push   $0x803ae2
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 00 3b 80 00       	push   $0x803b00
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3a 80 00       	push   $0x803ae2
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3a 80 00       	push   $0x803ae0
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 20 3b 80 00       	push   $0x803b20
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 3f 3b 80 00       	push   $0x803b3f
  8000b6:	e8 4d 1d 00 00       	call   801e08 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 47 3b 80 00       	push   $0x803b47
  8000f4:	e8 0f 1d 00 00       	call   801e08 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 4c 3b 80 00       	push   $0x803b4c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 6e 3b 80 00       	push   $0x803b6e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 7c 3b 80 00       	push   $0x803b7c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 8b 3b 80 00       	push   $0x803b8b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 9b 3b 80 00       	push   $0x803b9b
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 87 20 00 00       	call   802212 <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 a4 3b 80 00       	push   $0x803ba4
  8001fb:	e8 08 1c 00 00       	call   801e08 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 b2 3b 80 00       	push   $0x803bb2
  800237:	e8 41 21 00 00       	call   80237d <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 bb 3b 80 00       	push   $0x803bbb
  80026a:	e8 0e 21 00 00       	call   80237d <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 c4 3b 80 00       	push   $0x803bc4
  80029d:	e8 db 20 00 00       	call   80237d <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 d0 3b 80 00       	push   $0x803bd0
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 e5 3b 80 00       	push   $0x803be5
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 c2 20 00 00       	call   80239b <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 b4 20 00 00       	call   80239b <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 a6 20 00 00       	call   80239b <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 03 3c 80 00       	push   $0x803c03
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 87 1b 00 00       	call   801ecb <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 12 3c 80 00       	push   $0x803c12
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 71 1b 00 00       	call   801ecb <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 21 3c 80 00       	push   $0x803c21
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 5b 1b 00 00       	call   801ecb <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 26 3c 80 00       	push   $0x803c26
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 45 1b 00 00       	call   801ecb <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 2a 3c 80 00       	push   $0x803c2a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 2f 1b 00 00       	call   801ecb <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 2e 3c 80 00       	push   $0x803c2e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 19 1b 00 00       	call   801ecb <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 32 3c 80 00       	push   $0x803c32
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 03 1b 00 00       	call   801ecb <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 38 3c 80 00       	push   $0x803c38
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 e5 3b 80 00       	push   $0x803be5
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 60 3c 80 00       	push   $0x803c60
  80041e:	6a 68                	push   $0x68
  800420:	68 e5 3b 80 00       	push   $0x803be5
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 88 3c 80 00       	push   $0x803c88
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 e5 3b 80 00       	push   $0x803be5
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 b8 3c 80 00       	push   $0x803cb8
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 52 1b 00 00       	call   80222c <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 0d 1b 00 00       	call   8021f8 <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 2e 1b 00 00       	call   80222c <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 0c 1b 00 00       	call   802212 <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 56 19 00 00       	call   802073 <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 c2 1a 00 00       	call   8021f8 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 2f 19 00 00       	call   802073 <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 c0 1a 00 00       	call   802212 <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 7f 1c 00 00       	call   8023eb <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 21 1a 00 00       	call   8021f8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 34 3d 80 00       	push   $0x803d34
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 5c 3d 80 00       	push   $0x803d5c
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 84 3d 80 00       	push   $0x803d84
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 dc 3d 80 00       	push   $0x803ddc
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 34 3d 80 00       	push   $0x803d34
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 a1 19 00 00       	call   802212 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 2e 1b 00 00       	call   8023b7 <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 83 1b 00 00       	call   80241d <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 f0 3d 80 00       	push   $0x803df0
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 f5 3d 80 00       	push   $0x803df5
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 11 3e 80 00       	push   $0x803e11
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 14 3e 80 00       	push   $0x803e14
  80092c:	6a 26                	push   $0x26
  80092e:	68 60 3e 80 00       	push   $0x803e60
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 6c 3e 80 00       	push   $0x803e6c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 60 3e 80 00       	push   $0x803e60
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 c0 3e 80 00       	push   $0x803ec0
  800a6e:	6a 44                	push   $0x44
  800a70:	68 60 3e 80 00       	push   $0x803e60
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 82 15 00 00       	call   80204a <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 0b 15 00 00       	call   80204a <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 6f 16 00 00       	call   8021f8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 69 16 00 00       	call   802212 <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 85 2c 00 00       	call   803878 <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 45 2d 00 00       	call   803988 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 34 41 80 00       	add    $0x804134,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 45 41 80 00       	push   $0x804145
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 4e 41 80 00       	push   $0x80414e
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be 51 41 80 00       	mov    $0x804151,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 b0 42 80 00       	push   $0x8042b0
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 b3 42 80 00       	push   $0x8042b3
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 1c 0f 00 00       	call   8021f8 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 b0 42 80 00       	push   $0x8042b0
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 b3 42 80 00       	push   $0x8042b3
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 da 0e 00 00       	call   802212 <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 42 0e 00 00       	call   802212 <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 c4 42 80 00       	push   $0x8042c4
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801b18:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b1f:	00 00 00 
  801b22:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b29:	00 00 00 
  801b2c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b33:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801b36:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b3d:	00 00 00 
  801b40:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b47:	00 00 00 
  801b4a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b51:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801b54:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b5b:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801b5e:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801b65:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b74:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b79:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801b7e:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b8d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	6a 06                	push   $0x6
  801b97:	ff 75 f4             	pushl  -0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	e8 ee 05 00 00       	call   80218e <sys_allocate_chunk>
  801ba0:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ba3:	a1 20 51 80 00       	mov    0x805120,%eax
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	50                   	push   %eax
  801bac:	e8 63 0c 00 00       	call   802814 <initialize_MemBlocksList>
  801bb1:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801bb4:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801bb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bbf:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd7:	89 c2                	mov    %eax,%edx
  801bd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdc:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801be9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf3:	8b 50 08             	mov    0x8(%eax),%edx
  801bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	48                   	dec    %eax
  801bfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
  801c07:	f7 75 e0             	divl   -0x20(%ebp)
  801c0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c0d:	29 d0                	sub    %edx,%eax
  801c0f:	89 c2                	mov    %eax,%edx
  801c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c14:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801c17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c1b:	75 14                	jne    801c31 <initialize_dyn_block_system+0x11f>
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	68 e9 42 80 00       	push   $0x8042e9
  801c25:	6a 34                	push   $0x34
  801c27:	68 07 43 80 00       	push   $0x804307
  801c2c:	e8 6c ec ff ff       	call   80089d <_panic>
  801c31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c34:	8b 00                	mov    (%eax),%eax
  801c36:	85 c0                	test   %eax,%eax
  801c38:	74 10                	je     801c4a <initialize_dyn_block_system+0x138>
  801c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c3d:	8b 00                	mov    (%eax),%eax
  801c3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c42:	8b 52 04             	mov    0x4(%edx),%edx
  801c45:	89 50 04             	mov    %edx,0x4(%eax)
  801c48:	eb 0b                	jmp    801c55 <initialize_dyn_block_system+0x143>
  801c4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c4d:	8b 40 04             	mov    0x4(%eax),%eax
  801c50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c58:	8b 40 04             	mov    0x4(%eax),%eax
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	74 0f                	je     801c6e <initialize_dyn_block_system+0x15c>
  801c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c62:	8b 40 04             	mov    0x4(%eax),%eax
  801c65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c68:	8b 12                	mov    (%edx),%edx
  801c6a:	89 10                	mov    %edx,(%eax)
  801c6c:	eb 0a                	jmp    801c78 <initialize_dyn_block_system+0x166>
  801c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c71:	8b 00                	mov    (%eax),%eax
  801c73:	a3 48 51 80 00       	mov    %eax,0x805148
  801c78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c8b:	a1 54 51 80 00       	mov    0x805154,%eax
  801c90:	48                   	dec    %eax
  801c91:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	ff 75 e8             	pushl  -0x18(%ebp)
  801c9c:	e8 c4 13 00 00       	call   803065 <insert_sorted_with_merge_freeList>
  801ca1:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cad:	e8 2f fe ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	75 07                	jne    801cbf <malloc+0x18>
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbd:	eb 71                	jmp    801d30 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801cbf:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801cc6:	76 07                	jbe    801ccf <malloc+0x28>
	return NULL;
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccd:	eb 61                	jmp    801d30 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ccf:	e8 88 08 00 00       	call   80255c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	74 53                	je     801d2b <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801cd8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	01 d0                	add    %edx,%eax
  801ce7:	48                   	dec    %eax
  801ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cee:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf3:	f7 75 f4             	divl   -0xc(%ebp)
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf9:	29 d0                	sub    %edx,%eax
  801cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801cfe:	83 ec 0c             	sub    $0xc,%esp
  801d01:	ff 75 ec             	pushl  -0x14(%ebp)
  801d04:	e8 d2 0d 00 00       	call   802adb <alloc_block_FF>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801d0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d13:	74 16                	je     801d2b <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	ff 75 e8             	pushl  -0x18(%ebp)
  801d1b:	e8 0c 0c 00 00       	call   80292c <insert_sorted_allocList>
  801d20:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d26:	8b 40 08             	mov    0x8(%eax),%eax
  801d29:	eb 05                	jmp    801d30 <malloc+0x89>
    }

			}


	return NULL;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801d49:	83 ec 08             	sub    $0x8,%esp
  801d4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4f:	68 40 50 80 00       	push   $0x805040
  801d54:	e8 a0 0b 00 00       	call   8028f9 <find_block>
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d62:	8b 50 0c             	mov    0xc(%eax),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	e8 e4 03 00 00       	call   802156 <sys_free_user_mem>
  801d72:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801d75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d79:	75 17                	jne    801d92 <free+0x60>
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	68 e9 42 80 00       	push   $0x8042e9
  801d83:	68 84 00 00 00       	push   $0x84
  801d88:	68 07 43 80 00       	push   $0x804307
  801d8d:	e8 0b eb ff ff       	call   80089d <_panic>
  801d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	85 c0                	test   %eax,%eax
  801d99:	74 10                	je     801dab <free+0x79>
  801d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9e:	8b 00                	mov    (%eax),%eax
  801da0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801da3:	8b 52 04             	mov    0x4(%edx),%edx
  801da6:	89 50 04             	mov    %edx,0x4(%eax)
  801da9:	eb 0b                	jmp    801db6 <free+0x84>
  801dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dae:	8b 40 04             	mov    0x4(%eax),%eax
  801db1:	a3 44 50 80 00       	mov    %eax,0x805044
  801db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db9:	8b 40 04             	mov    0x4(%eax),%eax
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	74 0f                	je     801dcf <free+0x9d>
  801dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc3:	8b 40 04             	mov    0x4(%eax),%eax
  801dc6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dc9:	8b 12                	mov    (%edx),%edx
  801dcb:	89 10                	mov    %edx,(%eax)
  801dcd:	eb 0a                	jmp    801dd9 <free+0xa7>
  801dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd2:	8b 00                	mov    (%eax),%eax
  801dd4:	a3 40 50 80 00       	mov    %eax,0x805040
  801dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ddc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801df1:	48                   	dec    %eax
  801df2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	ff 75 ec             	pushl  -0x14(%ebp)
  801dfd:	e8 63 12 00 00       	call   803065 <insert_sorted_with_merge_freeList>
  801e02:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801e05:	90                   	nop
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 38             	sub    $0x38,%esp
  801e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e11:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e14:	e8 c8 fc ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e1d:	75 0a                	jne    801e29 <smalloc+0x21>
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	e9 a0 00 00 00       	jmp    801ec9 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801e29:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801e30:	76 0a                	jbe    801e3c <smalloc+0x34>
		return NULL;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	e9 8d 00 00 00       	jmp    801ec9 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e3c:	e8 1b 07 00 00       	call   80255c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e41:	85 c0                	test   %eax,%eax
  801e43:	74 7f                	je     801ec4 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801e45:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	01 d0                	add    %edx,%eax
  801e54:	48                   	dec    %eax
  801e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e60:	f7 75 f4             	divl   -0xc(%ebp)
  801e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e66:	29 d0                	sub    %edx,%eax
  801e68:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	ff 75 ec             	pushl  -0x14(%ebp)
  801e71:	e8 65 0c 00 00       	call   802adb <alloc_block_FF>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801e7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e80:	74 42                	je     801ec4 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	ff 75 e8             	pushl  -0x18(%ebp)
  801e88:	e8 9f 0a 00 00       	call   80292c <insert_sorted_allocList>
  801e8d:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e93:	8b 40 08             	mov    0x8(%eax),%eax
  801e96:	89 c2                	mov    %eax,%edx
  801e98:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e9c:	52                   	push   %edx
  801e9d:	50                   	push   %eax
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	e8 38 04 00 00       	call   8022e1 <sys_createSharedObject>
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eb3:	79 07                	jns    801ebc <smalloc+0xb4>
	    		  return NULL;
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eba:	eb 0d                	jmp    801ec9 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ebf:	8b 40 08             	mov    0x8(%eax),%eax
  801ec2:	eb 05                	jmp    801ec9 <smalloc+0xc1>


				}


		return NULL;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ed1:	e8 0b fc ff ff       	call   801ae1 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ed6:	e8 81 06 00 00       	call   80255c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801edb:	85 c0                	test   %eax,%eax
  801edd:	0f 84 9f 00 00 00    	je     801f82 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ee3:	83 ec 08             	sub    $0x8,%esp
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	e8 1a 04 00 00       	call   80230b <sys_getSizeOfSharedObject>
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efb:	79 0a                	jns    801f07 <sget+0x3c>
		return NULL;
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
  801f02:	e9 80 00 00 00       	jmp    801f87 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801f07:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	48                   	dec    %eax
  801f17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f22:	f7 75 f0             	divl   -0x10(%ebp)
  801f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f28:	29 d0                	sub    %edx,%eax
  801f2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	ff 75 e8             	pushl  -0x18(%ebp)
  801f33:	e8 a3 0b 00 00       	call   802adb <alloc_block_FF>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801f3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f42:	74 3e                	je     801f82 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f4a:	e8 dd 09 00 00       	call   80292c <insert_sorted_allocList>
  801f4f:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f55:	8b 40 08             	mov    0x8(%eax),%eax
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	50                   	push   %eax
  801f5c:	ff 75 0c             	pushl  0xc(%ebp)
  801f5f:	ff 75 08             	pushl  0x8(%ebp)
  801f62:	e8 c1 03 00 00       	call   802328 <sys_getSharedObject>
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801f6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f71:	79 07                	jns    801f7a <sget+0xaf>
	    		  return NULL;
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	eb 0d                	jmp    801f87 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801f7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7d:	8b 40 08             	mov    0x8(%eax),%eax
  801f80:	eb 05                	jmp    801f87 <sget+0xbc>
	      }
	}
	   return NULL;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f8f:	e8 4d fb ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f94:	83 ec 04             	sub    $0x4,%esp
  801f97:	68 14 43 80 00       	push   $0x804314
  801f9c:	68 12 01 00 00       	push   $0x112
  801fa1:	68 07 43 80 00       	push   $0x804307
  801fa6:	e8 f2 e8 ff ff       	call   80089d <_panic>

00801fab <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	68 3c 43 80 00       	push   $0x80433c
  801fb9:	68 26 01 00 00       	push   $0x126
  801fbe:	68 07 43 80 00       	push   $0x804307
  801fc3:	e8 d5 e8 ff ff       	call   80089d <_panic>

00801fc8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	68 60 43 80 00       	push   $0x804360
  801fd6:	68 31 01 00 00       	push   $0x131
  801fdb:	68 07 43 80 00       	push   $0x804307
  801fe0:	e8 b8 e8 ff ff       	call   80089d <_panic>

00801fe5 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 60 43 80 00       	push   $0x804360
  801ff3:	68 36 01 00 00       	push   $0x136
  801ff8:	68 07 43 80 00       	push   $0x804307
  801ffd:	e8 9b e8 ff ff       	call   80089d <_panic>

00802002 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	68 60 43 80 00       	push   $0x804360
  802010:	68 3b 01 00 00       	push   $0x13b
  802015:	68 07 43 80 00       	push   $0x804307
  80201a:	e8 7e e8 ff ff       	call   80089d <_panic>

0080201f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	57                   	push   %edi
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802031:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802034:	8b 7d 18             	mov    0x18(%ebp),%edi
  802037:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80203a:	cd 30                	int    $0x30
  80203c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80203f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	5b                   	pop    %ebx
  802046:	5e                   	pop    %esi
  802047:	5f                   	pop    %edi
  802048:	5d                   	pop    %ebp
  802049:	c3                   	ret    

0080204a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	8b 45 10             	mov    0x10(%ebp),%eax
  802053:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802056:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	52                   	push   %edx
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	50                   	push   %eax
  802066:	6a 00                	push   $0x0
  802068:	e8 b2 ff ff ff       	call   80201f <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	90                   	nop
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <sys_cgetc>:

int
sys_cgetc(void)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 01                	push   $0x1
  802082:	e8 98 ff ff ff       	call   80201f <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80208f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	52                   	push   %edx
  80209c:	50                   	push   %eax
  80209d:	6a 05                	push   $0x5
  80209f:	e8 7b ff ff ff       	call   80201f <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	56                   	push   %esi
  8020ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8020b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	56                   	push   %esi
  8020be:	53                   	push   %ebx
  8020bf:	51                   	push   %ecx
  8020c0:	52                   	push   %edx
  8020c1:	50                   	push   %eax
  8020c2:	6a 06                	push   $0x6
  8020c4:	e8 56 ff ff ff       	call   80201f <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    

008020d3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	52                   	push   %edx
  8020e3:	50                   	push   %eax
  8020e4:	6a 07                	push   $0x7
  8020e6:	e8 34 ff ff ff       	call   80201f <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	ff 75 0c             	pushl  0xc(%ebp)
  8020fc:	ff 75 08             	pushl  0x8(%ebp)
  8020ff:	6a 08                	push   $0x8
  802101:	e8 19 ff ff ff       	call   80201f <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 09                	push   $0x9
  80211a:	e8 00 ff ff ff       	call   80201f <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 0a                	push   $0xa
  802133:	e8 e7 fe ff ff       	call   80201f <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 0b                	push   $0xb
  80214c:	e8 ce fe ff ff       	call   80201f <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	ff 75 0c             	pushl  0xc(%ebp)
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	6a 0f                	push   $0xf
  802167:	e8 b3 fe ff ff       	call   80201f <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
	return;
  80216f:	90                   	nop
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 0c             	pushl  0xc(%ebp)
  80217e:	ff 75 08             	pushl  0x8(%ebp)
  802181:	6a 10                	push   $0x10
  802183:	e8 97 fe ff ff       	call   80201f <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
	return ;
  80218b:	90                   	nop
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	ff 75 10             	pushl  0x10(%ebp)
  802198:	ff 75 0c             	pushl  0xc(%ebp)
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	6a 11                	push   $0x11
  8021a0:	e8 7a fe ff ff       	call   80201f <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a8:	90                   	nop
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 0c                	push   $0xc
  8021ba:	e8 60 fe ff ff       	call   80201f <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	ff 75 08             	pushl  0x8(%ebp)
  8021d2:	6a 0d                	push   $0xd
  8021d4:	e8 46 fe ff ff       	call   80201f <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 0e                	push   $0xe
  8021ed:	e8 2d fe ff ff       	call   80201f <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 13                	push   $0x13
  802207:	e8 13 fe ff ff       	call   80201f <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 14                	push   $0x14
  802221:	e8 f9 fd ff ff       	call   80201f <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
}
  802229:	90                   	nop
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_cputc>:


void
sys_cputc(const char c)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802238:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	50                   	push   %eax
  802245:	6a 15                	push   $0x15
  802247:	e8 d3 fd ff ff       	call   80201f <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 16                	push   $0x16
  802261:	e8 b9 fd ff ff       	call   80201f <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	90                   	nop
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	ff 75 0c             	pushl  0xc(%ebp)
  80227b:	50                   	push   %eax
  80227c:	6a 17                	push   $0x17
  80227e:	e8 9c fd ff ff       	call   80201f <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	52                   	push   %edx
  802298:	50                   	push   %eax
  802299:	6a 1a                	push   $0x1a
  80229b:	e8 7f fd ff ff       	call   80201f <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	52                   	push   %edx
  8022b5:	50                   	push   %eax
  8022b6:	6a 18                	push   $0x18
  8022b8:	e8 62 fd ff ff       	call   80201f <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	90                   	nop
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	52                   	push   %edx
  8022d3:	50                   	push   %eax
  8022d4:	6a 19                	push   $0x19
  8022d6:	e8 44 fd ff ff       	call   80201f <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	90                   	nop
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022ed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	6a 00                	push   $0x0
  8022f9:	51                   	push   %ecx
  8022fa:	52                   	push   %edx
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	50                   	push   %eax
  8022ff:	6a 1b                	push   $0x1b
  802301:	e8 19 fd ff ff       	call   80201f <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    

0080230b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80230e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	52                   	push   %edx
  80231b:	50                   	push   %eax
  80231c:	6a 1c                	push   $0x1c
  80231e:	e8 fc fc ff ff       	call   80201f <syscall>
  802323:	83 c4 18             	add    $0x18,%esp
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80232b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	51                   	push   %ecx
  802339:	52                   	push   %edx
  80233a:	50                   	push   %eax
  80233b:	6a 1d                	push   $0x1d
  80233d:	e8 dd fc ff ff       	call   80201f <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80234a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	52                   	push   %edx
  802357:	50                   	push   %eax
  802358:	6a 1e                	push   $0x1e
  80235a:	e8 c0 fc ff ff       	call   80201f <syscall>
  80235f:	83 c4 18             	add    $0x18,%esp
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 1f                	push   $0x1f
  802373:	e8 a7 fc ff ff       	call   80201f <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	6a 00                	push   $0x0
  802385:	ff 75 14             	pushl  0x14(%ebp)
  802388:	ff 75 10             	pushl  0x10(%ebp)
  80238b:	ff 75 0c             	pushl  0xc(%ebp)
  80238e:	50                   	push   %eax
  80238f:	6a 20                	push   $0x20
  802391:	e8 89 fc ff ff       	call   80201f <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	50                   	push   %eax
  8023aa:	6a 21                	push   $0x21
  8023ac:	e8 6e fc ff ff       	call   80201f <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	90                   	nop
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	50                   	push   %eax
  8023c6:	6a 22                	push   $0x22
  8023c8:	e8 52 fc ff ff       	call   80201f <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 02                	push   $0x2
  8023e1:	e8 39 fc ff ff       	call   80201f <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 03                	push   $0x3
  8023fa:	e8 20 fc ff ff       	call   80201f <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 04                	push   $0x4
  802413:	e8 07 fc ff ff       	call   80201f <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_exit_env>:


void sys_exit_env(void)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 23                	push   $0x23
  80242c:	e8 ee fb ff ff       	call   80201f <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	90                   	nop
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80243d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802440:	8d 50 04             	lea    0x4(%eax),%edx
  802443:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	52                   	push   %edx
  80244d:	50                   	push   %eax
  80244e:	6a 24                	push   $0x24
  802450:	e8 ca fb ff ff       	call   80201f <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
	return result;
  802458:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802461:	89 01                	mov    %eax,(%ecx)
  802463:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	c9                   	leave  
  80246a:	c2 04 00             	ret    $0x4

0080246d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	ff 75 10             	pushl  0x10(%ebp)
  802477:	ff 75 0c             	pushl  0xc(%ebp)
  80247a:	ff 75 08             	pushl  0x8(%ebp)
  80247d:	6a 12                	push   $0x12
  80247f:	e8 9b fb ff ff       	call   80201f <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
	return ;
  802487:	90                   	nop
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_rcr2>:
uint32 sys_rcr2()
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 25                	push   $0x25
  802499:	e8 81 fb ff ff       	call   80201f <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024af:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	50                   	push   %eax
  8024bc:	6a 26                	push   $0x26
  8024be:	e8 5c fb ff ff       	call   80201f <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c6:	90                   	nop
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <rsttst>:
void rsttst()
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 28                	push   $0x28
  8024d8:	e8 42 fb ff ff       	call   80201f <syscall>
  8024dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e0:	90                   	nop
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024ef:	8b 55 18             	mov    0x18(%ebp),%edx
  8024f2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024f6:	52                   	push   %edx
  8024f7:	50                   	push   %eax
  8024f8:	ff 75 10             	pushl  0x10(%ebp)
  8024fb:	ff 75 0c             	pushl  0xc(%ebp)
  8024fe:	ff 75 08             	pushl  0x8(%ebp)
  802501:	6a 27                	push   $0x27
  802503:	e8 17 fb ff ff       	call   80201f <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
	return ;
  80250b:	90                   	nop
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <chktst>:
void chktst(uint32 n)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	ff 75 08             	pushl  0x8(%ebp)
  80251c:	6a 29                	push   $0x29
  80251e:	e8 fc fa ff ff       	call   80201f <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
	return ;
  802526:	90                   	nop
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <inctst>:

void inctst()
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 2a                	push   $0x2a
  802538:	e8 e2 fa ff ff       	call   80201f <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
	return ;
  802540:	90                   	nop
}
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <gettst>:
uint32 gettst()
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 2b                	push   $0x2b
  802552:	e8 c8 fa ff ff       	call   80201f <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 2c                	push   $0x2c
  80256e:	e8 ac fa ff ff       	call   80201f <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
  802576:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802579:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80257d:	75 07                	jne    802586 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80257f:	b8 01 00 00 00       	mov    $0x1,%eax
  802584:	eb 05                	jmp    80258b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 2c                	push   $0x2c
  80259f:	e8 7b fa ff ff       	call   80201f <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
  8025a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025aa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025ae:	75 07                	jne    8025b7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b5:	eb 05                	jmp    8025bc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 2c                	push   $0x2c
  8025d0:	e8 4a fa ff ff       	call   80201f <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
  8025d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025db:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025df:	75 07                	jne    8025e8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e6:	eb 05                	jmp    8025ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 2c                	push   $0x2c
  802601:	e8 19 fa ff ff       	call   80201f <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
  802609:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80260c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802610:	75 07                	jne    802619 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802612:	b8 01 00 00 00       	mov    $0x1,%eax
  802617:	eb 05                	jmp    80261e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	ff 75 08             	pushl  0x8(%ebp)
  80262e:	6a 2d                	push   $0x2d
  802630:	e8 ea f9 ff ff       	call   80201f <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
	return ;
  802638:	90                   	nop
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80263f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802642:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802645:	8b 55 0c             	mov    0xc(%ebp),%edx
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	6a 00                	push   $0x0
  80264d:	53                   	push   %ebx
  80264e:	51                   	push   %ecx
  80264f:	52                   	push   %edx
  802650:	50                   	push   %eax
  802651:	6a 2e                	push   $0x2e
  802653:	e8 c7 f9 ff ff       	call   80201f <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802663:	8b 55 0c             	mov    0xc(%ebp),%edx
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	52                   	push   %edx
  802670:	50                   	push   %eax
  802671:	6a 2f                	push   $0x2f
  802673:	e8 a7 f9 ff ff       	call   80201f <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	68 70 43 80 00       	push   $0x804370
  80268b:	e8 c1 e4 ff ff       	call   800b51 <cprintf>
  802690:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802693:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	68 9c 43 80 00       	push   $0x80439c
  8026a2:	e8 aa e4 ff ff       	call   800b51 <cprintf>
  8026a7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026aa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b6:	eb 56                	jmp    80270e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026bc:	74 1c                	je     8026da <print_mem_block_lists+0x5d>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 50 08             	mov    0x8(%eax),%edx
  8026c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c7:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d0:	01 c8                	add    %ecx,%eax
  8026d2:	39 c2                	cmp    %eax,%edx
  8026d4:	73 04                	jae    8026da <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026d6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 50 08             	mov    0x8(%eax),%edx
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e6:	01 c2                	add    %eax,%edx
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 08             	mov    0x8(%eax),%eax
  8026ee:	83 ec 04             	sub    $0x4,%esp
  8026f1:	52                   	push   %edx
  8026f2:	50                   	push   %eax
  8026f3:	68 b1 43 80 00       	push   $0x8043b1
  8026f8:	e8 54 e4 ff ff       	call   800b51 <cprintf>
  8026fd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802706:	a1 40 51 80 00       	mov    0x805140,%eax
  80270b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802712:	74 07                	je     80271b <print_mem_block_lists+0x9e>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	eb 05                	jmp    802720 <print_mem_block_lists+0xa3>
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
  802720:	a3 40 51 80 00       	mov    %eax,0x805140
  802725:	a1 40 51 80 00       	mov    0x805140,%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	75 8a                	jne    8026b8 <print_mem_block_lists+0x3b>
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	75 84                	jne    8026b8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802734:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802738:	75 10                	jne    80274a <print_mem_block_lists+0xcd>
  80273a:	83 ec 0c             	sub    $0xc,%esp
  80273d:	68 c0 43 80 00       	push   $0x8043c0
  802742:	e8 0a e4 ff ff       	call   800b51 <cprintf>
  802747:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80274a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	68 e4 43 80 00       	push   $0x8043e4
  802759:	e8 f3 e3 ff ff       	call   800b51 <cprintf>
  80275e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802761:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802765:	a1 40 50 80 00       	mov    0x805040,%eax
  80276a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276d:	eb 56                	jmp    8027c5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80276f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802773:	74 1c                	je     802791 <print_mem_block_lists+0x114>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 50 08             	mov    0x8(%eax),%edx
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 48 08             	mov    0x8(%eax),%ecx
  802781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	01 c8                	add    %ecx,%eax
  802789:	39 c2                	cmp    %eax,%edx
  80278b:	73 04                	jae    802791 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80278d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 50 08             	mov    0x8(%eax),%edx
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	01 c2                	add    %eax,%edx
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 40 08             	mov    0x8(%eax),%eax
  8027a5:	83 ec 04             	sub    $0x4,%esp
  8027a8:	52                   	push   %edx
  8027a9:	50                   	push   %eax
  8027aa:	68 b1 43 80 00       	push   $0x8043b1
  8027af:	e8 9d e3 ff ff       	call   800b51 <cprintf>
  8027b4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027bd:	a1 48 50 80 00       	mov    0x805048,%eax
  8027c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	74 07                	je     8027d2 <print_mem_block_lists+0x155>
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	eb 05                	jmp    8027d7 <print_mem_block_lists+0x15a>
  8027d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d7:	a3 48 50 80 00       	mov    %eax,0x805048
  8027dc:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	75 8a                	jne    80276f <print_mem_block_lists+0xf2>
  8027e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e9:	75 84                	jne    80276f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027ef:	75 10                	jne    802801 <print_mem_block_lists+0x184>
  8027f1:	83 ec 0c             	sub    $0xc,%esp
  8027f4:	68 fc 43 80 00       	push   $0x8043fc
  8027f9:	e8 53 e3 ff ff       	call   800b51 <cprintf>
  8027fe:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802801:	83 ec 0c             	sub    $0xc,%esp
  802804:	68 70 43 80 00       	push   $0x804370
  802809:	e8 43 e3 ff ff       	call   800b51 <cprintf>
  80280e:	83 c4 10             	add    $0x10,%esp

}
  802811:	90                   	nop
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80281a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802821:	00 00 00 
  802824:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80282b:	00 00 00 
  80282e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802835:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802838:	a1 50 50 80 00       	mov    0x805050,%eax
  80283d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802847:	e9 9e 00 00 00       	jmp    8028ea <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80284c:	a1 50 50 80 00       	mov    0x805050,%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	c1 e2 04             	shl    $0x4,%edx
  802857:	01 d0                	add    %edx,%eax
  802859:	85 c0                	test   %eax,%eax
  80285b:	75 14                	jne    802871 <initialize_MemBlocksList+0x5d>
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	68 24 44 80 00       	push   $0x804424
  802865:	6a 48                	push   $0x48
  802867:	68 47 44 80 00       	push   $0x804447
  80286c:	e8 2c e0 ff ff       	call   80089d <_panic>
  802871:	a1 50 50 80 00       	mov    0x805050,%eax
  802876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802879:	c1 e2 04             	shl    $0x4,%edx
  80287c:	01 d0                	add    %edx,%eax
  80287e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802884:	89 10                	mov    %edx,(%eax)
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 18                	je     8028a4 <initialize_MemBlocksList+0x90>
  80288c:	a1 48 51 80 00       	mov    0x805148,%eax
  802891:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802897:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80289a:	c1 e1 04             	shl    $0x4,%ecx
  80289d:	01 ca                	add    %ecx,%edx
  80289f:	89 50 04             	mov    %edx,0x4(%eax)
  8028a2:	eb 12                	jmp    8028b6 <initialize_MemBlocksList+0xa2>
  8028a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ac:	c1 e2 04             	shl    $0x4,%edx
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028be:	c1 e2 04             	shl    $0x4,%edx
  8028c1:	01 d0                	add    %edx,%eax
  8028c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d0:	c1 e2 04             	shl    $0x4,%edx
  8028d3:	01 d0                	add    %edx,%eax
  8028d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8028e1:	40                   	inc    %eax
  8028e2:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8028e7:	ff 45 f4             	incl   -0xc(%ebp)
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f0:	0f 82 56 ff ff ff    	jb     80284c <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8028f6:	90                   	nop
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802907:	eb 18                	jmp    802921 <find_block+0x28>
		{
			if(tmp->sva==va)
  802909:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290c:	8b 40 08             	mov    0x8(%eax),%eax
  80290f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802912:	75 05                	jne    802919 <find_block+0x20>
			{
				return tmp;
  802914:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802917:	eb 11                	jmp    80292a <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802921:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802925:	75 e2                	jne    802909 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802927:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802932:	a1 40 50 80 00       	mov    0x805040,%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	0f 85 83 00 00 00    	jne    8029c2 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80293f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802946:	00 00 00 
  802949:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802950:	00 00 00 
  802953:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80295a:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80295d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802961:	75 14                	jne    802977 <insert_sorted_allocList+0x4b>
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	68 24 44 80 00       	push   $0x804424
  80296b:	6a 7f                	push   $0x7f
  80296d:	68 47 44 80 00       	push   $0x804447
  802972:	e8 26 df ff ff       	call   80089d <_panic>
  802977:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	89 10                	mov    %edx,(%eax)
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	74 0d                	je     802998 <insert_sorted_allocList+0x6c>
  80298b:	a1 40 50 80 00       	mov    0x805040,%eax
  802990:	8b 55 08             	mov    0x8(%ebp),%edx
  802993:	89 50 04             	mov    %edx,0x4(%eax)
  802996:	eb 08                	jmp    8029a0 <insert_sorted_allocList+0x74>
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	a3 40 50 80 00       	mov    %eax,0x805040
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b7:	40                   	inc    %eax
  8029b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029bd:	e9 16 01 00 00       	jmp    802ad8 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 50 08             	mov    0x8(%eax),%edx
  8029c8:	a1 44 50 80 00       	mov    0x805044,%eax
  8029cd:	8b 40 08             	mov    0x8(%eax),%eax
  8029d0:	39 c2                	cmp    %eax,%edx
  8029d2:	76 68                	jbe    802a3c <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8029d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d8:	75 17                	jne    8029f1 <insert_sorted_allocList+0xc5>
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 60 44 80 00       	push   $0x804460
  8029e2:	68 85 00 00 00       	push   $0x85
  8029e7:	68 47 44 80 00       	push   $0x804447
  8029ec:	e8 ac de ff ff       	call   80089d <_panic>
  8029f1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	89 50 04             	mov    %edx,0x4(%eax)
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0c                	je     802a13 <insert_sorted_allocList+0xe7>
  802a07:	a1 44 50 80 00       	mov    0x805044,%eax
  802a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0f:	89 10                	mov    %edx,(%eax)
  802a11:	eb 08                	jmp    802a1b <insert_sorted_allocList+0xef>
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	a3 40 50 80 00       	mov    %eax,0x805040
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	a3 44 50 80 00       	mov    %eax,0x805044
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a31:	40                   	inc    %eax
  802a32:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a37:	e9 9c 00 00 00       	jmp    802ad8 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802a3c:	a1 40 50 80 00       	mov    0x805040,%eax
  802a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802a44:	e9 85 00 00 00       	jmp    802ace <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	8b 50 08             	mov    0x8(%eax),%edx
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 40 08             	mov    0x8(%eax),%eax
  802a55:	39 c2                	cmp    %eax,%edx
  802a57:	73 6d                	jae    802ac6 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5d:	74 06                	je     802a65 <insert_sorted_allocList+0x139>
  802a5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a63:	75 17                	jne    802a7c <insert_sorted_allocList+0x150>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 84 44 80 00       	push   $0x804484
  802a6d:	68 90 00 00 00       	push   $0x90
  802a72:	68 47 44 80 00       	push   $0x804447
  802a77:	e8 21 de ff ff       	call   80089d <_panic>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 50 04             	mov    0x4(%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	89 50 04             	mov    %edx,0x4(%eax)
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8e:	89 10                	mov    %edx,(%eax)
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 04             	mov    0x4(%eax),%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	74 0d                	je     802aa7 <insert_sorted_allocList+0x17b>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa3:	89 10                	mov    %edx,(%eax)
  802aa5:	eb 08                	jmp    802aaf <insert_sorted_allocList+0x183>
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	a3 40 50 80 00       	mov    %eax,0x805040
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab5:	89 50 04             	mov    %edx,0x4(%eax)
  802ab8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802abd:	40                   	inc    %eax
  802abe:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ac3:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ac4:	eb 12                	jmp    802ad8 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad2:	0f 85 71 ff ff ff    	jne    802a49 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ad8:	90                   	nop
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802ae1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802ae9:	e9 76 01 00 00       	jmp    802c64 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 40 0c             	mov    0xc(%eax),%eax
  802af4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af7:	0f 85 8a 00 00 00    	jne    802b87 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b01:	75 17                	jne    802b1a <alloc_block_FF+0x3f>
  802b03:	83 ec 04             	sub    $0x4,%esp
  802b06:	68 b9 44 80 00       	push   $0x8044b9
  802b0b:	68 a8 00 00 00       	push   $0xa8
  802b10:	68 47 44 80 00       	push   $0x804447
  802b15:	e8 83 dd ff ff       	call   80089d <_panic>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	74 10                	je     802b33 <alloc_block_FF+0x58>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2b:	8b 52 04             	mov    0x4(%edx),%edx
  802b2e:	89 50 04             	mov    %edx,0x4(%eax)
  802b31:	eb 0b                	jmp    802b3e <alloc_block_FF+0x63>
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 0f                	je     802b57 <alloc_block_FF+0x7c>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 40 04             	mov    0x4(%eax),%eax
  802b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b51:	8b 12                	mov    (%edx),%edx
  802b53:	89 10                	mov    %edx,(%eax)
  802b55:	eb 0a                	jmp    802b61 <alloc_block_FF+0x86>
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	a3 38 51 80 00       	mov    %eax,0x805138
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b74:	a1 44 51 80 00       	mov    0x805144,%eax
  802b79:	48                   	dec    %eax
  802b7a:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	e9 ea 00 00 00       	jmp    802c71 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b90:	0f 86 c6 00 00 00    	jbe    802c5c <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802b96:	a1 48 51 80 00       	mov    0x805148,%eax
  802b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 08             	mov    0x8(%eax),%edx
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbc:	89 c2                	mov    %eax,%edx
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 50 08             	mov    0x8(%eax),%edx
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	01 c2                	add    %eax,%edx
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802bd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd9:	75 17                	jne    802bf2 <alloc_block_FF+0x117>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 b9 44 80 00       	push   $0x8044b9
  802be3:	68 b6 00 00 00       	push   $0xb6
  802be8:	68 47 44 80 00       	push   $0x804447
  802bed:	e8 ab dc ff ff       	call   80089d <_panic>
  802bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 10                	je     802c0b <alloc_block_FF+0x130>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c03:	8b 52 04             	mov    0x4(%edx),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 0b                	jmp    802c16 <alloc_block_FF+0x13b>
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0f                	je     802c2f <alloc_block_FF+0x154>
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c29:	8b 12                	mov    (%edx),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	eb 0a                	jmp    802c39 <alloc_block_FF+0x15e>
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	a3 48 51 80 00       	mov    %eax,0x805148
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c51:	48                   	dec    %eax
  802c52:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	eb 15                	jmp    802c71 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c68:	0f 85 80 fe ff ff    	jne    802aee <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
  802c76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802c79:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802c81:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802c88:	e9 c0 00 00 00       	jmp    802d4d <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 0c             	mov    0xc(%eax),%eax
  802c93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c96:	0f 85 8a 00 00 00    	jne    802d26 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca0:	75 17                	jne    802cb9 <alloc_block_BF+0x46>
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 b9 44 80 00       	push   $0x8044b9
  802caa:	68 cf 00 00 00       	push   $0xcf
  802caf:	68 47 44 80 00       	push   $0x804447
  802cb4:	e8 e4 db ff ff       	call   80089d <_panic>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 10                	je     802cd2 <alloc_block_BF+0x5f>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cca:	8b 52 04             	mov    0x4(%edx),%edx
  802ccd:	89 50 04             	mov    %edx,0x4(%eax)
  802cd0:	eb 0b                	jmp    802cdd <alloc_block_BF+0x6a>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0f                	je     802cf6 <alloc_block_BF+0x83>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf0:	8b 12                	mov    (%edx),%edx
  802cf2:	89 10                	mov    %edx,(%eax)
  802cf4:	eb 0a                	jmp    802d00 <alloc_block_BF+0x8d>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	a3 38 51 80 00       	mov    %eax,0x805138
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d13:	a1 44 51 80 00       	mov    0x805144,%eax
  802d18:	48                   	dec    %eax
  802d19:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	e9 2a 01 00 00       	jmp    802e50 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d2f:	73 14                	jae    802d45 <alloc_block_BF+0xd2>
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3a:	76 09                	jbe    802d45 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d42:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802d4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d51:	0f 85 36 ff ff ff    	jne    802c8d <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802d57:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802d5f:	e9 dd 00 00 00       	jmp    802e41 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d6d:	0f 85 c6 00 00 00    	jne    802e39 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802d73:	a1 48 51 80 00       	mov    0x805148,%eax
  802d78:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 50 08             	mov    0x8(%eax),%edx
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8d:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 50 08             	mov    0x8(%eax),%edx
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	01 c2                	add    %eax,%edx
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	2b 45 08             	sub    0x8(%ebp),%eax
  802daa:	89 c2                	mov    %eax,%edx
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802db2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802db6:	75 17                	jne    802dcf <alloc_block_BF+0x15c>
  802db8:	83 ec 04             	sub    $0x4,%esp
  802dbb:	68 b9 44 80 00       	push   $0x8044b9
  802dc0:	68 eb 00 00 00       	push   $0xeb
  802dc5:	68 47 44 80 00       	push   $0x804447
  802dca:	e8 ce da ff ff       	call   80089d <_panic>
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	8b 00                	mov    (%eax),%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	74 10                	je     802de8 <alloc_block_BF+0x175>
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de0:	8b 52 04             	mov    0x4(%edx),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%eax)
  802de6:	eb 0b                	jmp    802df3 <alloc_block_BF+0x180>
  802de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802deb:	8b 40 04             	mov    0x4(%eax),%eax
  802dee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	8b 40 04             	mov    0x4(%eax),%eax
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	74 0f                	je     802e0c <alloc_block_BF+0x199>
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	8b 40 04             	mov    0x4(%eax),%eax
  802e03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e06:	8b 12                	mov    (%edx),%edx
  802e08:	89 10                	mov    %edx,(%eax)
  802e0a:	eb 0a                	jmp    802e16 <alloc_block_BF+0x1a3>
  802e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	a3 48 51 80 00       	mov    %eax,0x805148
  802e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e29:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2e:	48                   	dec    %eax
  802e2f:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	eb 17                	jmp    802e50 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e45:	0f 85 19 ff ff ff    	jne    802d64 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802e4b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
  802e55:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802e58:	a1 40 50 80 00       	mov    0x805040,%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	75 19                	jne    802e7a <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802e61:	83 ec 0c             	sub    $0xc,%esp
  802e64:	ff 75 08             	pushl  0x8(%ebp)
  802e67:	e8 6f fc ff ff       	call   802adb <alloc_block_FF>
  802e6c:	83 c4 10             	add    $0x10,%esp
  802e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	e9 e9 01 00 00       	jmp    803063 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802e7a:	a1 44 50 80 00       	mov    0x805044,%eax
  802e7f:	8b 40 08             	mov    0x8(%eax),%eax
  802e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802e85:	a1 44 50 80 00       	mov    0x805044,%eax
  802e8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8d:	a1 44 50 80 00       	mov    0x805044,%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	01 d0                	add    %edx,%eax
  802e97:	83 ec 08             	sub    $0x8,%esp
  802e9a:	50                   	push   %eax
  802e9b:	68 38 51 80 00       	push   $0x805138
  802ea0:	e8 54 fa ff ff       	call   8028f9 <find_block>
  802ea5:	83 c4 10             	add    $0x10,%esp
  802ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb4:	0f 85 9b 00 00 00    	jne    802f55 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	01 d0                	add    %edx,%eax
  802ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecf:	75 17                	jne    802ee8 <alloc_block_NF+0x96>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 b9 44 80 00       	push   $0x8044b9
  802ed9:	68 1a 01 00 00       	push   $0x11a
  802ede:	68 47 44 80 00       	push   $0x804447
  802ee3:	e8 b5 d9 ff ff       	call   80089d <_panic>
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 10                	je     802f01 <alloc_block_NF+0xaf>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef9:	8b 52 04             	mov    0x4(%edx),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	eb 0b                	jmp    802f0c <alloc_block_NF+0xba>
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0f                	je     802f25 <alloc_block_NF+0xd3>
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1f:	8b 12                	mov    (%edx),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 0a                	jmp    802f2f <alloc_block_NF+0xdd>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 44 51 80 00       	mov    0x805144,%eax
  802f47:	48                   	dec    %eax
  802f48:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	e9 0e 01 00 00       	jmp    803063 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f5e:	0f 86 cf 00 00 00    	jbe    803033 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802f64:	a1 48 51 80 00       	mov    0x805148,%eax
  802f69:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 50 08             	mov    0x8(%eax),%edx
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 50 08             	mov    0x8(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	2b 45 08             	sub    0x8(%ebp),%eax
  802f9b:	89 c2                	mov    %eax,%edx
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 40 08             	mov    0x8(%eax),%eax
  802fa9:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802fac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fb0:	75 17                	jne    802fc9 <alloc_block_NF+0x177>
  802fb2:	83 ec 04             	sub    $0x4,%esp
  802fb5:	68 b9 44 80 00       	push   $0x8044b9
  802fba:	68 28 01 00 00       	push   $0x128
  802fbf:	68 47 44 80 00       	push   $0x804447
  802fc4:	e8 d4 d8 ff ff       	call   80089d <_panic>
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 10                	je     802fe2 <alloc_block_NF+0x190>
  802fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fda:	8b 52 04             	mov    0x4(%edx),%edx
  802fdd:	89 50 04             	mov    %edx,0x4(%eax)
  802fe0:	eb 0b                	jmp    802fed <alloc_block_NF+0x19b>
  802fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe5:	8b 40 04             	mov    0x4(%eax),%eax
  802fe8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0f                	je     803006 <alloc_block_NF+0x1b4>
  802ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803000:	8b 12                	mov    (%edx),%edx
  803002:	89 10                	mov    %edx,(%eax)
  803004:	eb 0a                	jmp    803010 <alloc_block_NF+0x1be>
  803006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	a3 48 51 80 00       	mov    %eax,0x805148
  803010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803023:	a1 54 51 80 00       	mov    0x805154,%eax
  803028:	48                   	dec    %eax
  803029:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  80302e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803031:	eb 30                	jmp    803063 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803033:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803038:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80303b:	75 0a                	jne    803047 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80303d:	a1 38 51 80 00       	mov    0x805138,%eax
  803042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803045:	eb 08                	jmp    80304f <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 40 08             	mov    0x8(%eax),%eax
  803055:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803058:	0f 85 4d fe ff ff    	jne    802eab <alloc_block_NF+0x59>

			return NULL;
  80305e:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803063:	c9                   	leave  
  803064:	c3                   	ret    

00803065 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803065:	55                   	push   %ebp
  803066:	89 e5                	mov    %esp,%ebp
  803068:	53                   	push   %ebx
  803069:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80306c:	a1 38 51 80 00       	mov    0x805138,%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	0f 85 86 00 00 00    	jne    8030ff <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  803079:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803080:	00 00 00 
  803083:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80308a:	00 00 00 
  80308d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803094:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803097:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309b:	75 17                	jne    8030b4 <insert_sorted_with_merge_freeList+0x4f>
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	68 24 44 80 00       	push   $0x804424
  8030a5:	68 48 01 00 00       	push   $0x148
  8030aa:	68 47 44 80 00       	push   $0x804447
  8030af:	e8 e9 d7 ff ff       	call   80089d <_panic>
  8030b4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	89 10                	mov    %edx,(%eax)
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 0d                	je     8030d5 <insert_sorted_with_merge_freeList+0x70>
  8030c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8030cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	eb 08                	jmp    8030dd <insert_sorted_with_merge_freeList+0x78>
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f4:	40                   	inc    %eax
  8030f5:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8030fa:	e9 73 07 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80310a:	8b 40 08             	mov    0x8(%eax),%eax
  80310d:	39 c2                	cmp    %eax,%edx
  80310f:	0f 86 84 00 00 00    	jbe    803199 <insert_sorted_with_merge_freeList+0x134>
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	8b 50 08             	mov    0x8(%eax),%edx
  80311b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803120:	8b 48 0c             	mov    0xc(%eax),%ecx
  803123:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803128:	8b 40 08             	mov    0x8(%eax),%eax
  80312b:	01 c8                	add    %ecx,%eax
  80312d:	39 c2                	cmp    %eax,%edx
  80312f:	74 68                	je     803199 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803135:	75 17                	jne    80314e <insert_sorted_with_merge_freeList+0xe9>
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 60 44 80 00       	push   $0x804460
  80313f:	68 4c 01 00 00       	push   $0x14c
  803144:	68 47 44 80 00       	push   $0x804447
  803149:	e8 4f d7 ff ff       	call   80089d <_panic>
  80314e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	8b 40 04             	mov    0x4(%eax),%eax
  803160:	85 c0                	test   %eax,%eax
  803162:	74 0c                	je     803170 <insert_sorted_with_merge_freeList+0x10b>
  803164:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803169:	8b 55 08             	mov    0x8(%ebp),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	eb 08                	jmp    803178 <insert_sorted_with_merge_freeList+0x113>
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	a3 38 51 80 00       	mov    %eax,0x805138
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803189:	a1 44 51 80 00       	mov    0x805144,%eax
  80318e:	40                   	inc    %eax
  80318f:	a3 44 51 80 00       	mov    %eax,0x805144
  803194:	e9 d9 06 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	8b 50 08             	mov    0x8(%eax),%edx
  80319f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031a4:	8b 40 08             	mov    0x8(%eax),%eax
  8031a7:	39 c2                	cmp    %eax,%edx
  8031a9:	0f 86 b5 00 00 00    	jbe    803264 <insert_sorted_with_merge_freeList+0x1ff>
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 50 08             	mov    0x8(%eax),%edx
  8031b5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031ba:	8b 48 0c             	mov    0xc(%eax),%ecx
  8031bd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031c2:	8b 40 08             	mov    0x8(%eax),%eax
  8031c5:	01 c8                	add    %ecx,%eax
  8031c7:	39 c2                	cmp    %eax,%edx
  8031c9:	0f 85 95 00 00 00    	jne    803264 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8031cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031da:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e0:	8b 52 0c             	mov    0xc(%edx),%edx
  8031e3:	01 ca                	add    %ecx,%edx
  8031e5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803200:	75 17                	jne    803219 <insert_sorted_with_merge_freeList+0x1b4>
  803202:	83 ec 04             	sub    $0x4,%esp
  803205:	68 24 44 80 00       	push   $0x804424
  80320a:	68 54 01 00 00       	push   $0x154
  80320f:	68 47 44 80 00       	push   $0x804447
  803214:	e8 84 d6 ff ff       	call   80089d <_panic>
  803219:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	89 10                	mov    %edx,(%eax)
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	85 c0                	test   %eax,%eax
  80322b:	74 0d                	je     80323a <insert_sorted_with_merge_freeList+0x1d5>
  80322d:	a1 48 51 80 00       	mov    0x805148,%eax
  803232:	8b 55 08             	mov    0x8(%ebp),%edx
  803235:	89 50 04             	mov    %edx,0x4(%eax)
  803238:	eb 08                	jmp    803242 <insert_sorted_with_merge_freeList+0x1dd>
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	a3 48 51 80 00       	mov    %eax,0x805148
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803254:	a1 54 51 80 00       	mov    0x805154,%eax
  803259:	40                   	inc    %eax
  80325a:	a3 54 51 80 00       	mov    %eax,0x805154
  80325f:	e9 0e 06 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 50 08             	mov    0x8(%eax),%edx
  80326a:	a1 38 51 80 00       	mov    0x805138,%eax
  80326f:	8b 40 08             	mov    0x8(%eax),%eax
  803272:	39 c2                	cmp    %eax,%edx
  803274:	0f 83 c1 00 00 00    	jae    80333b <insert_sorted_with_merge_freeList+0x2d6>
  80327a:	a1 38 51 80 00       	mov    0x805138,%eax
  80327f:	8b 50 08             	mov    0x8(%eax),%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	8b 48 08             	mov    0x8(%eax),%ecx
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 40 0c             	mov    0xc(%eax),%eax
  80328e:	01 c8                	add    %ecx,%eax
  803290:	39 c2                	cmp    %eax,%edx
  803292:	0f 85 a3 00 00 00    	jne    80333b <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803298:	a1 38 51 80 00       	mov    0x805138,%eax
  80329d:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a0:	8b 52 08             	mov    0x8(%edx),%edx
  8032a3:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8032a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ab:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032b1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8032b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b7:	8b 52 0c             	mov    0xc(%edx),%edx
  8032ba:	01 ca                	add    %ecx,%edx
  8032bc:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d7:	75 17                	jne    8032f0 <insert_sorted_with_merge_freeList+0x28b>
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	68 24 44 80 00       	push   $0x804424
  8032e1:	68 5d 01 00 00       	push   $0x15d
  8032e6:	68 47 44 80 00       	push   $0x804447
  8032eb:	e8 ad d5 ff ff       	call   80089d <_panic>
  8032f0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 0d                	je     803311 <insert_sorted_with_merge_freeList+0x2ac>
  803304:	a1 48 51 80 00       	mov    0x805148,%eax
  803309:	8b 55 08             	mov    0x8(%ebp),%edx
  80330c:	89 50 04             	mov    %edx,0x4(%eax)
  80330f:	eb 08                	jmp    803319 <insert_sorted_with_merge_freeList+0x2b4>
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	a3 48 51 80 00       	mov    %eax,0x805148
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332b:	a1 54 51 80 00       	mov    0x805154,%eax
  803330:	40                   	inc    %eax
  803331:	a3 54 51 80 00       	mov    %eax,0x805154
  803336:	e9 37 05 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	8b 50 08             	mov    0x8(%eax),%edx
  803341:	a1 38 51 80 00       	mov    0x805138,%eax
  803346:	8b 40 08             	mov    0x8(%eax),%eax
  803349:	39 c2                	cmp    %eax,%edx
  80334b:	0f 83 82 00 00 00    	jae    8033d3 <insert_sorted_with_merge_freeList+0x36e>
  803351:	a1 38 51 80 00       	mov    0x805138,%eax
  803356:	8b 50 08             	mov    0x8(%eax),%edx
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 48 08             	mov    0x8(%eax),%ecx
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 40 0c             	mov    0xc(%eax),%eax
  803365:	01 c8                	add    %ecx,%eax
  803367:	39 c2                	cmp    %eax,%edx
  803369:	74 68                	je     8033d3 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80336b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336f:	75 17                	jne    803388 <insert_sorted_with_merge_freeList+0x323>
  803371:	83 ec 04             	sub    $0x4,%esp
  803374:	68 24 44 80 00       	push   $0x804424
  803379:	68 62 01 00 00       	push   $0x162
  80337e:	68 47 44 80 00       	push   $0x804447
  803383:	e8 15 d5 ff ff       	call   80089d <_panic>
  803388:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	89 10                	mov    %edx,(%eax)
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	85 c0                	test   %eax,%eax
  80339a:	74 0d                	je     8033a9 <insert_sorted_with_merge_freeList+0x344>
  80339c:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a4:	89 50 04             	mov    %edx,0x4(%eax)
  8033a7:	eb 08                	jmp    8033b1 <insert_sorted_with_merge_freeList+0x34c>
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c8:	40                   	inc    %eax
  8033c9:	a3 44 51 80 00       	mov    %eax,0x805144
  8033ce:	e9 9f 04 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8033d3:	a1 38 51 80 00       	mov    0x805138,%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8033dd:	e9 84 04 00 00       	jmp    803866 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	8b 50 08             	mov    0x8(%eax),%edx
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	8b 40 08             	mov    0x8(%eax),%eax
  8033ee:	39 c2                	cmp    %eax,%edx
  8033f0:	0f 86 a9 00 00 00    	jbe    80349f <insert_sorted_with_merge_freeList+0x43a>
  8033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f9:	8b 50 08             	mov    0x8(%eax),%edx
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 48 08             	mov    0x8(%eax),%ecx
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8b 40 0c             	mov    0xc(%eax),%eax
  803408:	01 c8                	add    %ecx,%eax
  80340a:	39 c2                	cmp    %eax,%edx
  80340c:	0f 84 8d 00 00 00    	je     80349f <insert_sorted_with_merge_freeList+0x43a>
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	8b 50 08             	mov    0x8(%eax),%edx
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	8b 40 04             	mov    0x4(%eax),%eax
  80341e:	8b 48 08             	mov    0x8(%eax),%ecx
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 40 04             	mov    0x4(%eax),%eax
  803427:	8b 40 0c             	mov    0xc(%eax),%eax
  80342a:	01 c8                	add    %ecx,%eax
  80342c:	39 c2                	cmp    %eax,%edx
  80342e:	74 6f                	je     80349f <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803434:	74 06                	je     80343c <insert_sorted_with_merge_freeList+0x3d7>
  803436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343a:	75 17                	jne    803453 <insert_sorted_with_merge_freeList+0x3ee>
  80343c:	83 ec 04             	sub    $0x4,%esp
  80343f:	68 84 44 80 00       	push   $0x804484
  803444:	68 6b 01 00 00       	push   $0x16b
  803449:	68 47 44 80 00       	push   $0x804447
  80344e:	e8 4a d4 ff ff       	call   80089d <_panic>
  803453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803456:	8b 50 04             	mov    0x4(%eax),%edx
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	89 50 04             	mov    %edx,0x4(%eax)
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803465:	89 10                	mov    %edx,(%eax)
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 0d                	je     80347e <insert_sorted_with_merge_freeList+0x419>
  803471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	8b 55 08             	mov    0x8(%ebp),%edx
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	eb 08                	jmp    803486 <insert_sorted_with_merge_freeList+0x421>
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	a3 38 51 80 00       	mov    %eax,0x805138
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 55 08             	mov    0x8(%ebp),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	a1 44 51 80 00       	mov    0x805144,%eax
  803494:	40                   	inc    %eax
  803495:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80349a:	e9 d3 03 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 50 08             	mov    0x8(%eax),%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	8b 40 08             	mov    0x8(%eax),%eax
  8034ab:	39 c2                	cmp    %eax,%edx
  8034ad:	0f 86 da 00 00 00    	jbe    80358d <insert_sorted_with_merge_freeList+0x528>
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 50 08             	mov    0x8(%eax),%edx
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	8b 48 08             	mov    0x8(%eax),%ecx
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c5:	01 c8                	add    %ecx,%eax
  8034c7:	39 c2                	cmp    %eax,%edx
  8034c9:	0f 85 be 00 00 00    	jne    80358d <insert_sorted_with_merge_freeList+0x528>
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 50 08             	mov    0x8(%eax),%edx
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	8b 40 04             	mov    0x4(%eax),%eax
  8034db:	8b 48 08             	mov    0x8(%eax),%ecx
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e7:	01 c8                	add    %ecx,%eax
  8034e9:	39 c2                	cmp    %eax,%edx
  8034eb:	0f 84 9c 00 00 00    	je     80358d <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	8b 50 08             	mov    0x8(%eax),%edx
  8034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fa:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	8b 50 0c             	mov    0xc(%eax),%edx
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	8b 40 0c             	mov    0xc(%eax),%eax
  803509:	01 c2                	add    %eax,%edx
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803529:	75 17                	jne    803542 <insert_sorted_with_merge_freeList+0x4dd>
  80352b:	83 ec 04             	sub    $0x4,%esp
  80352e:	68 24 44 80 00       	push   $0x804424
  803533:	68 74 01 00 00       	push   $0x174
  803538:	68 47 44 80 00       	push   $0x804447
  80353d:	e8 5b d3 ff ff       	call   80089d <_panic>
  803542:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	89 10                	mov    %edx,(%eax)
  80354d:	8b 45 08             	mov    0x8(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	85 c0                	test   %eax,%eax
  803554:	74 0d                	je     803563 <insert_sorted_with_merge_freeList+0x4fe>
  803556:	a1 48 51 80 00       	mov    0x805148,%eax
  80355b:	8b 55 08             	mov    0x8(%ebp),%edx
  80355e:	89 50 04             	mov    %edx,0x4(%eax)
  803561:	eb 08                	jmp    80356b <insert_sorted_with_merge_freeList+0x506>
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	a3 48 51 80 00       	mov    %eax,0x805148
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357d:	a1 54 51 80 00       	mov    0x805154,%eax
  803582:	40                   	inc    %eax
  803583:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803588:	e9 e5 02 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803590:	8b 50 08             	mov    0x8(%eax),%edx
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	8b 40 08             	mov    0x8(%eax),%eax
  803599:	39 c2                	cmp    %eax,%edx
  80359b:	0f 86 d7 00 00 00    	jbe    803678 <insert_sorted_with_merge_freeList+0x613>
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 50 08             	mov    0x8(%eax),%edx
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b3:	01 c8                	add    %ecx,%eax
  8035b5:	39 c2                	cmp    %eax,%edx
  8035b7:	0f 84 bb 00 00 00    	je     803678 <insert_sorted_with_merge_freeList+0x613>
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 50 08             	mov    0x8(%eax),%edx
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	8b 48 08             	mov    0x8(%eax),%ecx
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 40 04             	mov    0x4(%eax),%eax
  8035d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d5:	01 c8                	add    %ecx,%eax
  8035d7:	39 c2                	cmp    %eax,%edx
  8035d9:	0f 85 99 00 00 00    	jne    803678 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8035df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e2:	8b 40 04             	mov    0x4(%eax),%eax
  8035e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f4:	01 c2                	add    %eax,%edx
  8035f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f9:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803610:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803614:	75 17                	jne    80362d <insert_sorted_with_merge_freeList+0x5c8>
  803616:	83 ec 04             	sub    $0x4,%esp
  803619:	68 24 44 80 00       	push   $0x804424
  80361e:	68 7d 01 00 00       	push   $0x17d
  803623:	68 47 44 80 00       	push   $0x804447
  803628:	e8 70 d2 ff ff       	call   80089d <_panic>
  80362d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	89 10                	mov    %edx,(%eax)
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	8b 00                	mov    (%eax),%eax
  80363d:	85 c0                	test   %eax,%eax
  80363f:	74 0d                	je     80364e <insert_sorted_with_merge_freeList+0x5e9>
  803641:	a1 48 51 80 00       	mov    0x805148,%eax
  803646:	8b 55 08             	mov    0x8(%ebp),%edx
  803649:	89 50 04             	mov    %edx,0x4(%eax)
  80364c:	eb 08                	jmp    803656 <insert_sorted_with_merge_freeList+0x5f1>
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	a3 48 51 80 00       	mov    %eax,0x805148
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803668:	a1 54 51 80 00       	mov    0x805154,%eax
  80366d:	40                   	inc    %eax
  80366e:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803673:	e9 fa 01 00 00       	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367b:	8b 50 08             	mov    0x8(%eax),%edx
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	8b 40 08             	mov    0x8(%eax),%eax
  803684:	39 c2                	cmp    %eax,%edx
  803686:	0f 86 d2 01 00 00    	jbe    80385e <insert_sorted_with_merge_freeList+0x7f9>
  80368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368f:	8b 50 08             	mov    0x8(%eax),%edx
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	8b 48 08             	mov    0x8(%eax),%ecx
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	8b 40 0c             	mov    0xc(%eax),%eax
  80369e:	01 c8                	add    %ecx,%eax
  8036a0:	39 c2                	cmp    %eax,%edx
  8036a2:	0f 85 b6 01 00 00    	jne    80385e <insert_sorted_with_merge_freeList+0x7f9>
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	8b 50 08             	mov    0x8(%eax),%edx
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	8b 40 04             	mov    0x4(%eax),%eax
  8036b4:	8b 48 08             	mov    0x8(%eax),%ecx
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	8b 40 04             	mov    0x4(%eax),%eax
  8036bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c0:	01 c8                	add    %ecx,%eax
  8036c2:	39 c2                	cmp    %eax,%edx
  8036c4:	0f 85 94 01 00 00    	jne    80385e <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	8b 40 04             	mov    0x4(%eax),%eax
  8036d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d3:	8b 52 04             	mov    0x4(%edx),%edx
  8036d6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8036d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8036dc:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8036df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8036e5:	01 da                	add    %ebx,%edx
  8036e7:	01 ca                	add    %ecx,%edx
  8036e9:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803704:	75 17                	jne    80371d <insert_sorted_with_merge_freeList+0x6b8>
  803706:	83 ec 04             	sub    $0x4,%esp
  803709:	68 b9 44 80 00       	push   $0x8044b9
  80370e:	68 86 01 00 00       	push   $0x186
  803713:	68 47 44 80 00       	push   $0x804447
  803718:	e8 80 d1 ff ff       	call   80089d <_panic>
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	85 c0                	test   %eax,%eax
  803724:	74 10                	je     803736 <insert_sorted_with_merge_freeList+0x6d1>
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 00                	mov    (%eax),%eax
  80372b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80372e:	8b 52 04             	mov    0x4(%edx),%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 0b                	jmp    803741 <insert_sorted_with_merge_freeList+0x6dc>
  803736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803739:	8b 40 04             	mov    0x4(%eax),%eax
  80373c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 0f                	je     80375a <insert_sorted_with_merge_freeList+0x6f5>
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	8b 40 04             	mov    0x4(%eax),%eax
  803751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803754:	8b 12                	mov    (%edx),%edx
  803756:	89 10                	mov    %edx,(%eax)
  803758:	eb 0a                	jmp    803764 <insert_sorted_with_merge_freeList+0x6ff>
  80375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	a3 38 51 80 00       	mov    %eax,0x805138
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803770:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803777:	a1 44 51 80 00       	mov    0x805144,%eax
  80377c:	48                   	dec    %eax
  80377d:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803786:	75 17                	jne    80379f <insert_sorted_with_merge_freeList+0x73a>
  803788:	83 ec 04             	sub    $0x4,%esp
  80378b:	68 24 44 80 00       	push   $0x804424
  803790:	68 87 01 00 00       	push   $0x187
  803795:	68 47 44 80 00       	push   $0x804447
  80379a:	e8 fe d0 ff ff       	call   80089d <_panic>
  80379f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	74 0d                	je     8037c0 <insert_sorted_with_merge_freeList+0x75b>
  8037b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8037b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	eb 08                	jmp    8037c8 <insert_sorted_with_merge_freeList+0x763>
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037da:	a1 54 51 80 00       	mov    0x805154,%eax
  8037df:	40                   	inc    %eax
  8037e0:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8037e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037fd:	75 17                	jne    803816 <insert_sorted_with_merge_freeList+0x7b1>
  8037ff:	83 ec 04             	sub    $0x4,%esp
  803802:	68 24 44 80 00       	push   $0x804424
  803807:	68 8a 01 00 00       	push   $0x18a
  80380c:	68 47 44 80 00       	push   $0x804447
  803811:	e8 87 d0 ff ff       	call   80089d <_panic>
  803816:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	89 10                	mov    %edx,(%eax)
  803821:	8b 45 08             	mov    0x8(%ebp),%eax
  803824:	8b 00                	mov    (%eax),%eax
  803826:	85 c0                	test   %eax,%eax
  803828:	74 0d                	je     803837 <insert_sorted_with_merge_freeList+0x7d2>
  80382a:	a1 48 51 80 00       	mov    0x805148,%eax
  80382f:	8b 55 08             	mov    0x8(%ebp),%edx
  803832:	89 50 04             	mov    %edx,0x4(%eax)
  803835:	eb 08                	jmp    80383f <insert_sorted_with_merge_freeList+0x7da>
  803837:	8b 45 08             	mov    0x8(%ebp),%eax
  80383a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	a3 48 51 80 00       	mov    %eax,0x805148
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803851:	a1 54 51 80 00       	mov    0x805154,%eax
  803856:	40                   	inc    %eax
  803857:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  80385c:	eb 14                	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	8b 00                	mov    (%eax),%eax
  803863:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386a:	0f 85 72 fb ff ff    	jne    8033e2 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803870:	eb 00                	jmp    803872 <insert_sorted_with_merge_freeList+0x80d>
  803872:	90                   	nop
  803873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803876:	c9                   	leave  
  803877:	c3                   	ret    

00803878 <__udivdi3>:
  803878:	55                   	push   %ebp
  803879:	57                   	push   %edi
  80387a:	56                   	push   %esi
  80387b:	53                   	push   %ebx
  80387c:	83 ec 1c             	sub    $0x1c,%esp
  80387f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803883:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803887:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80388b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80388f:	89 ca                	mov    %ecx,%edx
  803891:	89 f8                	mov    %edi,%eax
  803893:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803897:	85 f6                	test   %esi,%esi
  803899:	75 2d                	jne    8038c8 <__udivdi3+0x50>
  80389b:	39 cf                	cmp    %ecx,%edi
  80389d:	77 65                	ja     803904 <__udivdi3+0x8c>
  80389f:	89 fd                	mov    %edi,%ebp
  8038a1:	85 ff                	test   %edi,%edi
  8038a3:	75 0b                	jne    8038b0 <__udivdi3+0x38>
  8038a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8038aa:	31 d2                	xor    %edx,%edx
  8038ac:	f7 f7                	div    %edi
  8038ae:	89 c5                	mov    %eax,%ebp
  8038b0:	31 d2                	xor    %edx,%edx
  8038b2:	89 c8                	mov    %ecx,%eax
  8038b4:	f7 f5                	div    %ebp
  8038b6:	89 c1                	mov    %eax,%ecx
  8038b8:	89 d8                	mov    %ebx,%eax
  8038ba:	f7 f5                	div    %ebp
  8038bc:	89 cf                	mov    %ecx,%edi
  8038be:	89 fa                	mov    %edi,%edx
  8038c0:	83 c4 1c             	add    $0x1c,%esp
  8038c3:	5b                   	pop    %ebx
  8038c4:	5e                   	pop    %esi
  8038c5:	5f                   	pop    %edi
  8038c6:	5d                   	pop    %ebp
  8038c7:	c3                   	ret    
  8038c8:	39 ce                	cmp    %ecx,%esi
  8038ca:	77 28                	ja     8038f4 <__udivdi3+0x7c>
  8038cc:	0f bd fe             	bsr    %esi,%edi
  8038cf:	83 f7 1f             	xor    $0x1f,%edi
  8038d2:	75 40                	jne    803914 <__udivdi3+0x9c>
  8038d4:	39 ce                	cmp    %ecx,%esi
  8038d6:	72 0a                	jb     8038e2 <__udivdi3+0x6a>
  8038d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038dc:	0f 87 9e 00 00 00    	ja     803980 <__udivdi3+0x108>
  8038e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e7:	89 fa                	mov    %edi,%edx
  8038e9:	83 c4 1c             	add    $0x1c,%esp
  8038ec:	5b                   	pop    %ebx
  8038ed:	5e                   	pop    %esi
  8038ee:	5f                   	pop    %edi
  8038ef:	5d                   	pop    %ebp
  8038f0:	c3                   	ret    
  8038f1:	8d 76 00             	lea    0x0(%esi),%esi
  8038f4:	31 ff                	xor    %edi,%edi
  8038f6:	31 c0                	xor    %eax,%eax
  8038f8:	89 fa                	mov    %edi,%edx
  8038fa:	83 c4 1c             	add    $0x1c,%esp
  8038fd:	5b                   	pop    %ebx
  8038fe:	5e                   	pop    %esi
  8038ff:	5f                   	pop    %edi
  803900:	5d                   	pop    %ebp
  803901:	c3                   	ret    
  803902:	66 90                	xchg   %ax,%ax
  803904:	89 d8                	mov    %ebx,%eax
  803906:	f7 f7                	div    %edi
  803908:	31 ff                	xor    %edi,%edi
  80390a:	89 fa                	mov    %edi,%edx
  80390c:	83 c4 1c             	add    $0x1c,%esp
  80390f:	5b                   	pop    %ebx
  803910:	5e                   	pop    %esi
  803911:	5f                   	pop    %edi
  803912:	5d                   	pop    %ebp
  803913:	c3                   	ret    
  803914:	bd 20 00 00 00       	mov    $0x20,%ebp
  803919:	89 eb                	mov    %ebp,%ebx
  80391b:	29 fb                	sub    %edi,%ebx
  80391d:	89 f9                	mov    %edi,%ecx
  80391f:	d3 e6                	shl    %cl,%esi
  803921:	89 c5                	mov    %eax,%ebp
  803923:	88 d9                	mov    %bl,%cl
  803925:	d3 ed                	shr    %cl,%ebp
  803927:	89 e9                	mov    %ebp,%ecx
  803929:	09 f1                	or     %esi,%ecx
  80392b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80392f:	89 f9                	mov    %edi,%ecx
  803931:	d3 e0                	shl    %cl,%eax
  803933:	89 c5                	mov    %eax,%ebp
  803935:	89 d6                	mov    %edx,%esi
  803937:	88 d9                	mov    %bl,%cl
  803939:	d3 ee                	shr    %cl,%esi
  80393b:	89 f9                	mov    %edi,%ecx
  80393d:	d3 e2                	shl    %cl,%edx
  80393f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803943:	88 d9                	mov    %bl,%cl
  803945:	d3 e8                	shr    %cl,%eax
  803947:	09 c2                	or     %eax,%edx
  803949:	89 d0                	mov    %edx,%eax
  80394b:	89 f2                	mov    %esi,%edx
  80394d:	f7 74 24 0c          	divl   0xc(%esp)
  803951:	89 d6                	mov    %edx,%esi
  803953:	89 c3                	mov    %eax,%ebx
  803955:	f7 e5                	mul    %ebp
  803957:	39 d6                	cmp    %edx,%esi
  803959:	72 19                	jb     803974 <__udivdi3+0xfc>
  80395b:	74 0b                	je     803968 <__udivdi3+0xf0>
  80395d:	89 d8                	mov    %ebx,%eax
  80395f:	31 ff                	xor    %edi,%edi
  803961:	e9 58 ff ff ff       	jmp    8038be <__udivdi3+0x46>
  803966:	66 90                	xchg   %ax,%ax
  803968:	8b 54 24 08          	mov    0x8(%esp),%edx
  80396c:	89 f9                	mov    %edi,%ecx
  80396e:	d3 e2                	shl    %cl,%edx
  803970:	39 c2                	cmp    %eax,%edx
  803972:	73 e9                	jae    80395d <__udivdi3+0xe5>
  803974:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803977:	31 ff                	xor    %edi,%edi
  803979:	e9 40 ff ff ff       	jmp    8038be <__udivdi3+0x46>
  80397e:	66 90                	xchg   %ax,%ax
  803980:	31 c0                	xor    %eax,%eax
  803982:	e9 37 ff ff ff       	jmp    8038be <__udivdi3+0x46>
  803987:	90                   	nop

00803988 <__umoddi3>:
  803988:	55                   	push   %ebp
  803989:	57                   	push   %edi
  80398a:	56                   	push   %esi
  80398b:	53                   	push   %ebx
  80398c:	83 ec 1c             	sub    $0x1c,%esp
  80398f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803993:	8b 74 24 34          	mov    0x34(%esp),%esi
  803997:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80399b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80399f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039a7:	89 f3                	mov    %esi,%ebx
  8039a9:	89 fa                	mov    %edi,%edx
  8039ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039af:	89 34 24             	mov    %esi,(%esp)
  8039b2:	85 c0                	test   %eax,%eax
  8039b4:	75 1a                	jne    8039d0 <__umoddi3+0x48>
  8039b6:	39 f7                	cmp    %esi,%edi
  8039b8:	0f 86 a2 00 00 00    	jbe    803a60 <__umoddi3+0xd8>
  8039be:	89 c8                	mov    %ecx,%eax
  8039c0:	89 f2                	mov    %esi,%edx
  8039c2:	f7 f7                	div    %edi
  8039c4:	89 d0                	mov    %edx,%eax
  8039c6:	31 d2                	xor    %edx,%edx
  8039c8:	83 c4 1c             	add    $0x1c,%esp
  8039cb:	5b                   	pop    %ebx
  8039cc:	5e                   	pop    %esi
  8039cd:	5f                   	pop    %edi
  8039ce:	5d                   	pop    %ebp
  8039cf:	c3                   	ret    
  8039d0:	39 f0                	cmp    %esi,%eax
  8039d2:	0f 87 ac 00 00 00    	ja     803a84 <__umoddi3+0xfc>
  8039d8:	0f bd e8             	bsr    %eax,%ebp
  8039db:	83 f5 1f             	xor    $0x1f,%ebp
  8039de:	0f 84 ac 00 00 00    	je     803a90 <__umoddi3+0x108>
  8039e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039e9:	29 ef                	sub    %ebp,%edi
  8039eb:	89 fe                	mov    %edi,%esi
  8039ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039f1:	89 e9                	mov    %ebp,%ecx
  8039f3:	d3 e0                	shl    %cl,%eax
  8039f5:	89 d7                	mov    %edx,%edi
  8039f7:	89 f1                	mov    %esi,%ecx
  8039f9:	d3 ef                	shr    %cl,%edi
  8039fb:	09 c7                	or     %eax,%edi
  8039fd:	89 e9                	mov    %ebp,%ecx
  8039ff:	d3 e2                	shl    %cl,%edx
  803a01:	89 14 24             	mov    %edx,(%esp)
  803a04:	89 d8                	mov    %ebx,%eax
  803a06:	d3 e0                	shl    %cl,%eax
  803a08:	89 c2                	mov    %eax,%edx
  803a0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a0e:	d3 e0                	shl    %cl,%eax
  803a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a14:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a18:	89 f1                	mov    %esi,%ecx
  803a1a:	d3 e8                	shr    %cl,%eax
  803a1c:	09 d0                	or     %edx,%eax
  803a1e:	d3 eb                	shr    %cl,%ebx
  803a20:	89 da                	mov    %ebx,%edx
  803a22:	f7 f7                	div    %edi
  803a24:	89 d3                	mov    %edx,%ebx
  803a26:	f7 24 24             	mull   (%esp)
  803a29:	89 c6                	mov    %eax,%esi
  803a2b:	89 d1                	mov    %edx,%ecx
  803a2d:	39 d3                	cmp    %edx,%ebx
  803a2f:	0f 82 87 00 00 00    	jb     803abc <__umoddi3+0x134>
  803a35:	0f 84 91 00 00 00    	je     803acc <__umoddi3+0x144>
  803a3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a3f:	29 f2                	sub    %esi,%edx
  803a41:	19 cb                	sbb    %ecx,%ebx
  803a43:	89 d8                	mov    %ebx,%eax
  803a45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a49:	d3 e0                	shl    %cl,%eax
  803a4b:	89 e9                	mov    %ebp,%ecx
  803a4d:	d3 ea                	shr    %cl,%edx
  803a4f:	09 d0                	or     %edx,%eax
  803a51:	89 e9                	mov    %ebp,%ecx
  803a53:	d3 eb                	shr    %cl,%ebx
  803a55:	89 da                	mov    %ebx,%edx
  803a57:	83 c4 1c             	add    $0x1c,%esp
  803a5a:	5b                   	pop    %ebx
  803a5b:	5e                   	pop    %esi
  803a5c:	5f                   	pop    %edi
  803a5d:	5d                   	pop    %ebp
  803a5e:	c3                   	ret    
  803a5f:	90                   	nop
  803a60:	89 fd                	mov    %edi,%ebp
  803a62:	85 ff                	test   %edi,%edi
  803a64:	75 0b                	jne    803a71 <__umoddi3+0xe9>
  803a66:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6b:	31 d2                	xor    %edx,%edx
  803a6d:	f7 f7                	div    %edi
  803a6f:	89 c5                	mov    %eax,%ebp
  803a71:	89 f0                	mov    %esi,%eax
  803a73:	31 d2                	xor    %edx,%edx
  803a75:	f7 f5                	div    %ebp
  803a77:	89 c8                	mov    %ecx,%eax
  803a79:	f7 f5                	div    %ebp
  803a7b:	89 d0                	mov    %edx,%eax
  803a7d:	e9 44 ff ff ff       	jmp    8039c6 <__umoddi3+0x3e>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	89 c8                	mov    %ecx,%eax
  803a86:	89 f2                	mov    %esi,%edx
  803a88:	83 c4 1c             	add    $0x1c,%esp
  803a8b:	5b                   	pop    %ebx
  803a8c:	5e                   	pop    %esi
  803a8d:	5f                   	pop    %edi
  803a8e:	5d                   	pop    %ebp
  803a8f:	c3                   	ret    
  803a90:	3b 04 24             	cmp    (%esp),%eax
  803a93:	72 06                	jb     803a9b <__umoddi3+0x113>
  803a95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a99:	77 0f                	ja     803aaa <__umoddi3+0x122>
  803a9b:	89 f2                	mov    %esi,%edx
  803a9d:	29 f9                	sub    %edi,%ecx
  803a9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aa3:	89 14 24             	mov    %edx,(%esp)
  803aa6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aaa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aae:	8b 14 24             	mov    (%esp),%edx
  803ab1:	83 c4 1c             	add    $0x1c,%esp
  803ab4:	5b                   	pop    %ebx
  803ab5:	5e                   	pop    %esi
  803ab6:	5f                   	pop    %edi
  803ab7:	5d                   	pop    %ebp
  803ab8:	c3                   	ret    
  803ab9:	8d 76 00             	lea    0x0(%esi),%esi
  803abc:	2b 04 24             	sub    (%esp),%eax
  803abf:	19 fa                	sbb    %edi,%edx
  803ac1:	89 d1                	mov    %edx,%ecx
  803ac3:	89 c6                	mov    %eax,%esi
  803ac5:	e9 71 ff ff ff       	jmp    803a3b <__umoddi3+0xb3>
  803aca:	66 90                	xchg   %ax,%ax
  803acc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ad0:	72 ea                	jb     803abc <__umoddi3+0x134>
  803ad2:	89 d9                	mov    %ebx,%ecx
  803ad4:	e9 62 ff ff ff       	jmp    803a3b <__umoddi3+0xb3>
