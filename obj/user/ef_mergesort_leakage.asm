
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 11 20 00 00       	call   802061 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 60 39 80 00       	push   $0x803960
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 62 39 80 00       	push   $0x803962
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 78 39 80 00       	push   $0x803978
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 62 39 80 00       	push   $0x803962
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 60 39 80 00       	push   $0x803960
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 90 39 80 00       	push   $0x803990
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 af 39 80 00       	push   $0x8039af
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 22 1a 00 00       	call   801b10 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 b4 39 80 00       	push   $0x8039b4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 d6 39 80 00       	push   $0x8039d6
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 e4 39 80 00       	push   $0x8039e4
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 f3 39 80 00       	push   $0x8039f3
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 03 3a 80 00       	push   $0x803a03
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 ed 1e 00 00       	call   80207b <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 5e 1e 00 00       	call   802061 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 0c 3a 80 00       	push   $0x803a0c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 63 1e 00 00       	call   80207b <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 40 3a 80 00       	push   $0x803a40
  80023a:	6a 58                	push   $0x58
  80023c:	68 62 3a 80 00       	push   $0x803a62
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 16 1e 00 00       	call   802061 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 80 3a 80 00       	push   $0x803a80
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 b4 3a 80 00       	push   $0x803ab4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 e8 3a 80 00       	push   $0x803ae8
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 fb 1d 00 00       	call   80207b <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 dc 1d 00 00       	call   802061 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 1a 3b 80 00       	push   $0x803b1a
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 8f 1d 00 00       	call   80207b <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 60 39 80 00       	push   $0x803960
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 38 3b 80 00       	push   $0x803b38
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 af 39 80 00       	push   $0x8039af
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 9a 15 00 00       	call   801b10 <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 85 15 00 00       	call   801b10 <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 4c 19 00 00       	call   802095 <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 07 19 00 00       	call   802061 <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 28 19 00 00       	call   802095 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 06 19 00 00       	call   80207b <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 50 17 00 00       	call   801edc <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 bc 18 00 00       	call   802061 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 29 17 00 00       	call   801edc <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 ba 18 00 00       	call   80207b <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 79 1a 00 00       	call   802254 <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 1b 18 00 00       	call   802061 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 58 3b 80 00       	push   $0x803b58
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 80 3b 80 00       	push   $0x803b80
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 a8 3b 80 00       	push   $0x803ba8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 00 3c 80 00       	push   $0x803c00
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 58 3b 80 00       	push   $0x803b58
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 9b 17 00 00       	call   80207b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 28 19 00 00       	call   802220 <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 7d 19 00 00       	call   802286 <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 14 3c 80 00       	push   $0x803c14
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 19 3c 80 00       	push   $0x803c19
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 35 3c 80 00       	push   $0x803c35
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 38 3c 80 00       	push   $0x803c38
  80099b:	6a 26                	push   $0x26
  80099d:	68 84 3c 80 00       	push   $0x803c84
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 90 3c 80 00       	push   $0x803c90
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 84 3c 80 00       	push   $0x803c84
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 e4 3c 80 00       	push   $0x803ce4
  800add:	6a 44                	push   $0x44
  800adf:	68 84 3c 80 00       	push   $0x803c84
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 7c 13 00 00       	call   801eb3 <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 05 13 00 00       	call   801eb3 <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 69 14 00 00       	call   802061 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 63 14 00 00       	call   80207b <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 82 2a 00 00       	call   8036e4 <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 42 2b 00 00       	call   8037f4 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 54 3f 80 00       	add    $0x803f54,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 65 3f 80 00       	push   $0x803f65
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 6e 3f 80 00       	push   $0x803f6e
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 d0 40 80 00       	push   $0x8040d0
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801981:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801988:	00 00 00 
  80198b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801992:	00 00 00 
  801995:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80199c:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80199f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a6:	00 00 00 
  8019a9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b0:	00 00 00 
  8019b3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019ba:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8019bd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019c4:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8019c7:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8019ce:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019dd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019e2:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8019e7:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8019ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	6a 06                	push   $0x6
  801a00:	ff 75 f4             	pushl  -0xc(%ebp)
  801a03:	50                   	push   %eax
  801a04:	e8 ee 05 00 00       	call   801ff7 <sys_allocate_chunk>
  801a09:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a0c:	a1 20 51 80 00       	mov    0x805120,%eax
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	50                   	push   %eax
  801a15:	e8 63 0c 00 00       	call   80267d <initialize_MemBlocksList>
  801a1a:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801a1d:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a22:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a28:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a45:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a4b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801a52:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a5c:	8b 50 08             	mov    0x8(%eax),%edx
  801a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	48                   	dec    %eax
  801a65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	f7 75 e0             	divl   -0x20(%ebp)
  801a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a76:	29 d0                	sub    %edx,%eax
  801a78:	89 c2                	mov    %eax,%edx
  801a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7d:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801a80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a84:	75 14                	jne    801a9a <initialize_dyn_block_system+0x11f>
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	68 f5 40 80 00       	push   $0x8040f5
  801a8e:	6a 34                	push   $0x34
  801a90:	68 13 41 80 00       	push   $0x804113
  801a95:	e8 72 ee ff ff       	call   80090c <_panic>
  801a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	74 10                	je     801ab3 <initialize_dyn_block_system+0x138>
  801aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aa6:	8b 00                	mov    (%eax),%eax
  801aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aab:	8b 52 04             	mov    0x4(%edx),%edx
  801aae:	89 50 04             	mov    %edx,0x4(%eax)
  801ab1:	eb 0b                	jmp    801abe <initialize_dyn_block_system+0x143>
  801ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab6:	8b 40 04             	mov    0x4(%eax),%eax
  801ab9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac1:	8b 40 04             	mov    0x4(%eax),%eax
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	74 0f                	je     801ad7 <initialize_dyn_block_system+0x15c>
  801ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801acb:	8b 40 04             	mov    0x4(%eax),%eax
  801ace:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ad1:	8b 12                	mov    (%edx),%edx
  801ad3:	89 10                	mov    %edx,(%eax)
  801ad5:	eb 0a                	jmp    801ae1 <initialize_dyn_block_system+0x166>
  801ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	a3 48 51 80 00       	mov    %eax,0x805148
  801ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801af4:	a1 54 51 80 00       	mov    0x805154,%eax
  801af9:	48                   	dec    %eax
  801afa:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801aff:	83 ec 0c             	sub    $0xc,%esp
  801b02:	ff 75 e8             	pushl  -0x18(%ebp)
  801b05:	e8 c4 13 00 00       	call   802ece <insert_sorted_with_merge_freeList>
  801b0a:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b0d:	90                   	nop
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b16:	e8 2f fe ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1f:	75 07                	jne    801b28 <malloc+0x18>
  801b21:	b8 00 00 00 00       	mov    $0x0,%eax
  801b26:	eb 71                	jmp    801b99 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801b28:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b2f:	76 07                	jbe    801b38 <malloc+0x28>
	return NULL;
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	eb 61                	jmp    801b99 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b38:	e8 88 08 00 00       	call   8023c5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	74 53                	je     801b94 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b41:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b48:	8b 55 08             	mov    0x8(%ebp),%edx
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	48                   	dec    %eax
  801b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b57:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5c:	f7 75 f4             	divl   -0xc(%ebp)
  801b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b62:	29 d0                	sub    %edx,%eax
  801b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	ff 75 ec             	pushl  -0x14(%ebp)
  801b6d:	e8 d2 0d 00 00       	call   802944 <alloc_block_FF>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801b78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b7c:	74 16                	je     801b94 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	ff 75 e8             	pushl  -0x18(%ebp)
  801b84:	e8 0c 0c 00 00       	call   802795 <insert_sorted_allocList>
  801b89:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801b8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8f:	8b 40 08             	mov    0x8(%eax),%eax
  801b92:	eb 05                	jmp    801b99 <malloc+0x89>
    }

			}


	return NULL;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb8:	68 40 50 80 00       	push   $0x805040
  801bbd:	e8 a0 0b 00 00       	call   802762 <find_block>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bcb:	8b 50 0c             	mov    0xc(%eax),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	52                   	push   %edx
  801bd5:	50                   	push   %eax
  801bd6:	e8 e4 03 00 00       	call   801fbf <sys_free_user_mem>
  801bdb:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801bde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801be2:	75 17                	jne    801bfb <free+0x60>
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	68 f5 40 80 00       	push   $0x8040f5
  801bec:	68 84 00 00 00       	push   $0x84
  801bf1:	68 13 41 80 00       	push   $0x804113
  801bf6:	e8 11 ed ff ff       	call   80090c <_panic>
  801bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfe:	8b 00                	mov    (%eax),%eax
  801c00:	85 c0                	test   %eax,%eax
  801c02:	74 10                	je     801c14 <free+0x79>
  801c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c07:	8b 00                	mov    (%eax),%eax
  801c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c0c:	8b 52 04             	mov    0x4(%edx),%edx
  801c0f:	89 50 04             	mov    %edx,0x4(%eax)
  801c12:	eb 0b                	jmp    801c1f <free+0x84>
  801c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c17:	8b 40 04             	mov    0x4(%eax),%eax
  801c1a:	a3 44 50 80 00       	mov    %eax,0x805044
  801c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c22:	8b 40 04             	mov    0x4(%eax),%eax
  801c25:	85 c0                	test   %eax,%eax
  801c27:	74 0f                	je     801c38 <free+0x9d>
  801c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2c:	8b 40 04             	mov    0x4(%eax),%eax
  801c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c32:	8b 12                	mov    (%edx),%edx
  801c34:	89 10                	mov    %edx,(%eax)
  801c36:	eb 0a                	jmp    801c42 <free+0xa7>
  801c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3b:	8b 00                	mov    (%eax),%eax
  801c3d:	a3 40 50 80 00       	mov    %eax,0x805040
  801c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c55:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c5a:	48                   	dec    %eax
  801c5b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	ff 75 ec             	pushl  -0x14(%ebp)
  801c66:	e8 63 12 00 00       	call   802ece <insert_sorted_with_merge_freeList>
  801c6b:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801c6e:	90                   	nop
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 38             	sub    $0x38,%esp
  801c77:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c7d:	e8 c8 fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c86:	75 0a                	jne    801c92 <smalloc+0x21>
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	e9 a0 00 00 00       	jmp    801d32 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801c92:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801c99:	76 0a                	jbe    801ca5 <smalloc+0x34>
		return NULL;
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca0:	e9 8d 00 00 00       	jmp    801d32 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ca5:	e8 1b 07 00 00       	call   8023c5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801caa:	85 c0                	test   %eax,%eax
  801cac:	74 7f                	je     801d2d <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801cae:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbb:	01 d0                	add    %edx,%eax
  801cbd:	48                   	dec    %eax
  801cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc9:	f7 75 f4             	divl   -0xc(%ebp)
  801ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccf:	29 d0                	sub    %edx,%eax
  801cd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cda:	e8 65 0c 00 00       	call   802944 <alloc_block_FF>
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801ce5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ce9:	74 42                	je     801d2d <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 e8             	pushl  -0x18(%ebp)
  801cf1:	e8 9f 0a 00 00       	call   802795 <insert_sorted_allocList>
  801cf6:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cfc:	8b 40 08             	mov    0x8(%eax),%eax
  801cff:	89 c2                	mov    %eax,%edx
  801d01:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	e8 38 04 00 00       	call   80214a <sys_createSharedObject>
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801d18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d1c:	79 07                	jns    801d25 <smalloc+0xb4>
	    		  return NULL;
  801d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d23:	eb 0d                	jmp    801d32 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d28:	8b 40 08             	mov    0x8(%eax),%eax
  801d2b:	eb 05                	jmp    801d32 <smalloc+0xc1>


				}


		return NULL;
  801d2d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d3a:	e8 0b fc ff ff       	call   80194a <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d3f:	e8 81 06 00 00       	call   8023c5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d44:	85 c0                	test   %eax,%eax
  801d46:	0f 84 9f 00 00 00    	je     801deb <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d4c:	83 ec 08             	sub    $0x8,%esp
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	e8 1a 04 00 00       	call   802174 <sys_getSizeOfSharedObject>
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801d60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d64:	79 0a                	jns    801d70 <sget+0x3c>
		return NULL;
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6b:	e9 80 00 00 00       	jmp    801df0 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d70:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	48                   	dec    %eax
  801d80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d86:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8b:	f7 75 f0             	divl   -0x10(%ebp)
  801d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d91:	29 d0                	sub    %edx,%eax
  801d93:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801d96:	83 ec 0c             	sub    $0xc,%esp
  801d99:	ff 75 e8             	pushl  -0x18(%ebp)
  801d9c:	e8 a3 0b 00 00       	call   802944 <alloc_block_FF>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801da7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dab:	74 3e                	je     801deb <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801db3:	e8 dd 09 00 00       	call   802795 <insert_sorted_allocList>
  801db8:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbe:	8b 40 08             	mov    0x8(%eax),%eax
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	50                   	push   %eax
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	ff 75 08             	pushl  0x8(%ebp)
  801dcb:	e8 c1 03 00 00       	call   802191 <sys_getSharedObject>
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801dd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dda:	79 07                	jns    801de3 <sget+0xaf>
	    		  return NULL;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  801de1:	eb 0d                	jmp    801df0 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de6:	8b 40 08             	mov    0x8(%eax),%eax
  801de9:	eb 05                	jmp    801df0 <sget+0xbc>
	      }
	}
	   return NULL;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801df8:	e8 4d fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	68 20 41 80 00       	push   $0x804120
  801e05:	68 12 01 00 00       	push   $0x112
  801e0a:	68 13 41 80 00       	push   $0x804113
  801e0f:	e8 f8 ea ff ff       	call   80090c <_panic>

00801e14 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 48 41 80 00       	push   $0x804148
  801e22:	68 26 01 00 00       	push   $0x126
  801e27:	68 13 41 80 00       	push   $0x804113
  801e2c:	e8 db ea ff ff       	call   80090c <_panic>

00801e31 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 6c 41 80 00       	push   $0x80416c
  801e3f:	68 31 01 00 00       	push   $0x131
  801e44:	68 13 41 80 00       	push   $0x804113
  801e49:	e8 be ea ff ff       	call   80090c <_panic>

00801e4e <shrink>:

}
void shrink(uint32 newSize)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	68 6c 41 80 00       	push   $0x80416c
  801e5c:	68 36 01 00 00       	push   $0x136
  801e61:	68 13 41 80 00       	push   $0x804113
  801e66:	e8 a1 ea ff ff       	call   80090c <_panic>

00801e6b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 6c 41 80 00       	push   $0x80416c
  801e79:	68 3b 01 00 00       	push   $0x13b
  801e7e:	68 13 41 80 00       	push   $0x804113
  801e83:	e8 84 ea ff ff       	call   80090c <_panic>

00801e88 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	57                   	push   %edi
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e9d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ea0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ea3:	cd 30                	int    $0x30
  801ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	5b                   	pop    %ebx
  801eaf:	5e                   	pop    %esi
  801eb0:	5f                   	pop    %edi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ebf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	50                   	push   %eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	e8 b2 ff ff ff       	call   801e88 <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
}
  801ed9:	90                   	nop
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_cgetc>:

int
sys_cgetc(void)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 01                	push   $0x1
  801eeb:	e8 98 ff ff ff       	call   801e88 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	6a 05                	push   $0x5
  801f08:	e8 7b ff ff ff       	call   801e88 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f17:	8b 75 18             	mov    0x18(%ebp),%esi
  801f1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	56                   	push   %esi
  801f27:	53                   	push   %ebx
  801f28:	51                   	push   %ecx
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	6a 06                	push   $0x6
  801f2d:	e8 56 ff ff ff       	call   801e88 <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
}
  801f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    

00801f3c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	6a 07                	push   $0x7
  801f4f:	e8 34 ff ff ff       	call   801e88 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	6a 08                	push   $0x8
  801f6a:	e8 19 ff ff ff       	call   801e88 <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 09                	push   $0x9
  801f83:	e8 00 ff ff ff       	call   801e88 <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 0a                	push   $0xa
  801f9c:	e8 e7 fe ff ff       	call   801e88 <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 0b                	push   $0xb
  801fb5:	e8 ce fe ff ff       	call   801e88 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	ff 75 08             	pushl  0x8(%ebp)
  801fce:	6a 0f                	push   $0xf
  801fd0:	e8 b3 fe ff ff       	call   801e88 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
	return;
  801fd8:	90                   	nop
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	6a 10                	push   $0x10
  801fec:	e8 97 fe ff ff       	call   801e88 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff4:	90                   	nop
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	ff 75 0c             	pushl  0xc(%ebp)
  802004:	ff 75 08             	pushl  0x8(%ebp)
  802007:	6a 11                	push   $0x11
  802009:	e8 7a fe ff ff       	call   801e88 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
	return ;
  802011:	90                   	nop
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 0c                	push   $0xc
  802023:	e8 60 fe ff ff       	call   801e88 <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	ff 75 08             	pushl  0x8(%ebp)
  80203b:	6a 0d                	push   $0xd
  80203d:	e8 46 fe ff ff       	call   801e88 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 0e                	push   $0xe
  802056:	e8 2d fe ff ff       	call   801e88 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	90                   	nop
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 13                	push   $0x13
  802070:	e8 13 fe ff ff       	call   801e88 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	90                   	nop
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 14                	push   $0x14
  80208a:	e8 f9 fd ff ff       	call   801e88 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_cputc>:


void
sys_cputc(const char c)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	50                   	push   %eax
  8020ae:	6a 15                	push   $0x15
  8020b0:	e8 d3 fd ff ff       	call   801e88 <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	90                   	nop
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 16                	push   $0x16
  8020ca:	e8 b9 fd ff ff       	call   801e88 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	50                   	push   %eax
  8020e5:	6a 17                	push   $0x17
  8020e7:	e8 9c fd ff ff       	call   801e88 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 1a                	push   $0x1a
  802104:	e8 7f fd ff ff       	call   801e88 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802111:	8b 55 0c             	mov    0xc(%ebp),%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	52                   	push   %edx
  80211e:	50                   	push   %eax
  80211f:	6a 18                	push   $0x18
  802121:	e8 62 fd ff ff       	call   801e88 <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	90                   	nop
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80212f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	52                   	push   %edx
  80213c:	50                   	push   %eax
  80213d:	6a 19                	push   $0x19
  80213f:	e8 44 fd ff ff       	call   801e88 <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	90                   	nop
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	8b 45 10             	mov    0x10(%ebp),%eax
  802153:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802156:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802159:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	6a 00                	push   $0x0
  802162:	51                   	push   %ecx
  802163:	52                   	push   %edx
  802164:	ff 75 0c             	pushl  0xc(%ebp)
  802167:	50                   	push   %eax
  802168:	6a 1b                	push   $0x1b
  80216a:	e8 19 fd ff ff       	call   801e88 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	52                   	push   %edx
  802184:	50                   	push   %eax
  802185:	6a 1c                	push   $0x1c
  802187:	e8 fc fc ff ff       	call   801e88 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802194:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	51                   	push   %ecx
  8021a2:	52                   	push   %edx
  8021a3:	50                   	push   %eax
  8021a4:	6a 1d                	push   $0x1d
  8021a6:	e8 dd fc ff ff       	call   801e88 <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	6a 1e                	push   $0x1e
  8021c3:	e8 c0 fc ff ff       	call   801e88 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 1f                	push   $0x1f
  8021dc:	e8 a7 fc ff ff       	call   801e88 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	ff 75 14             	pushl  0x14(%ebp)
  8021f1:	ff 75 10             	pushl  0x10(%ebp)
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	50                   	push   %eax
  8021f8:	6a 20                	push   $0x20
  8021fa:	e8 89 fc ff ff       	call   801e88 <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	50                   	push   %eax
  802213:	6a 21                	push   $0x21
  802215:	e8 6e fc ff ff       	call   801e88 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	90                   	nop
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	50                   	push   %eax
  80222f:	6a 22                	push   $0x22
  802231:	e8 52 fc ff ff       	call   801e88 <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 02                	push   $0x2
  80224a:	e8 39 fc ff ff       	call   801e88 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 03                	push   $0x3
  802263:	e8 20 fc ff ff       	call   801e88 <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 04                	push   $0x4
  80227c:	e8 07 fc ff ff       	call   801e88 <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <sys_exit_env>:


void sys_exit_env(void)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 23                	push   $0x23
  802295:	e8 ee fb ff ff       	call   801e88 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	90                   	nop
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a9:	8d 50 04             	lea    0x4(%eax),%edx
  8022ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	52                   	push   %edx
  8022b6:	50                   	push   %eax
  8022b7:	6a 24                	push   $0x24
  8022b9:	e8 ca fb ff ff       	call   801e88 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ca:	89 01                	mov    %eax,(%ecx)
  8022cc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	c9                   	leave  
  8022d3:	c2 04 00             	ret    $0x4

008022d6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	ff 75 10             	pushl  0x10(%ebp)
  8022e0:	ff 75 0c             	pushl  0xc(%ebp)
  8022e3:	ff 75 08             	pushl  0x8(%ebp)
  8022e6:	6a 12                	push   $0x12
  8022e8:	e8 9b fb ff ff       	call   801e88 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f0:	90                   	nop
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 25                	push   $0x25
  802302:	e8 81 fb ff ff       	call   801e88 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802318:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	50                   	push   %eax
  802325:	6a 26                	push   $0x26
  802327:	e8 5c fb ff ff       	call   801e88 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
	return ;
  80232f:	90                   	nop
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <rsttst>:
void rsttst()
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 28                	push   $0x28
  802341:	e8 42 fb ff ff       	call   801e88 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
	return ;
  802349:	90                   	nop
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	8b 45 14             	mov    0x14(%ebp),%eax
  802355:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802358:	8b 55 18             	mov    0x18(%ebp),%edx
  80235b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	ff 75 10             	pushl  0x10(%ebp)
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	ff 75 08             	pushl  0x8(%ebp)
  80236a:	6a 27                	push   $0x27
  80236c:	e8 17 fb ff ff       	call   801e88 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
	return ;
  802374:	90                   	nop
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <chktst>:
void chktst(uint32 n)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	6a 29                	push   $0x29
  802387:	e8 fc fa ff ff       	call   801e88 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
	return ;
  80238f:	90                   	nop
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <inctst>:

void inctst()
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 2a                	push   $0x2a
  8023a1:	e8 e2 fa ff ff       	call   801e88 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <gettst>:
uint32 gettst()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 2b                	push   $0x2b
  8023bb:	e8 c8 fa ff ff       	call   801e88 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 2c                	push   $0x2c
  8023d7:	e8 ac fa ff ff       	call   801e88 <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
  8023df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023e2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023e6:	75 07                	jne    8023ef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ed:	eb 05                	jmp    8023f4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 2c                	push   $0x2c
  802408:	e8 7b fa ff ff       	call   801e88 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
  802410:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802413:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802417:	75 07                	jne    802420 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
  80241e:	eb 05                	jmp    802425 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 2c                	push   $0x2c
  802439:	e8 4a fa ff ff       	call   801e88 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
  802441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802444:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802448:	75 07                	jne    802451 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	eb 05                	jmp    802456 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 2c                	push   $0x2c
  80246a:	e8 19 fa ff ff       	call   801e88 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
  802472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802475:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802479:	75 07                	jne    802482 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80247b:	b8 01 00 00 00       	mov    $0x1,%eax
  802480:	eb 05                	jmp    802487 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	ff 75 08             	pushl  0x8(%ebp)
  802497:	6a 2d                	push   $0x2d
  802499:	e8 ea f9 ff ff       	call   801e88 <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a1:	90                   	nop
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	6a 00                	push   $0x0
  8024b6:	53                   	push   %ebx
  8024b7:	51                   	push   %ecx
  8024b8:	52                   	push   %edx
  8024b9:	50                   	push   %eax
  8024ba:	6a 2e                	push   $0x2e
  8024bc:	e8 c7 f9 ff ff       	call   801e88 <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
}
  8024c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	52                   	push   %edx
  8024d9:	50                   	push   %eax
  8024da:	6a 2f                	push   $0x2f
  8024dc:	e8 a7 f9 ff ff       	call   801e88 <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	68 7c 41 80 00       	push   $0x80417c
  8024f4:	e8 c7 e6 ff ff       	call   800bc0 <cprintf>
  8024f9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802503:	83 ec 0c             	sub    $0xc,%esp
  802506:	68 a8 41 80 00       	push   $0x8041a8
  80250b:	e8 b0 e6 ff ff       	call   800bc0 <cprintf>
  802510:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802513:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802517:	a1 38 51 80 00       	mov    0x805138,%eax
  80251c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251f:	eb 56                	jmp    802577 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802525:	74 1c                	je     802543 <print_mem_block_lists+0x5d>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 50 08             	mov    0x8(%eax),%edx
  80252d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802530:	8b 48 08             	mov    0x8(%eax),%ecx
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	01 c8                	add    %ecx,%eax
  80253b:	39 c2                	cmp    %eax,%edx
  80253d:	73 04                	jae    802543 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80253f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 50 08             	mov    0x8(%eax),%edx
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 0c             	mov    0xc(%eax),%eax
  80254f:	01 c2                	add    %eax,%edx
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 08             	mov    0x8(%eax),%eax
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	52                   	push   %edx
  80255b:	50                   	push   %eax
  80255c:	68 bd 41 80 00       	push   $0x8041bd
  802561:	e8 5a e6 ff ff       	call   800bc0 <cprintf>
  802566:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80256f:	a1 40 51 80 00       	mov    0x805140,%eax
  802574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257b:	74 07                	je     802584 <print_mem_block_lists+0x9e>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	eb 05                	jmp    802589 <print_mem_block_lists+0xa3>
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	a3 40 51 80 00       	mov    %eax,0x805140
  80258e:	a1 40 51 80 00       	mov    0x805140,%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	75 8a                	jne    802521 <print_mem_block_lists+0x3b>
  802597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259b:	75 84                	jne    802521 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80259d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025a1:	75 10                	jne    8025b3 <print_mem_block_lists+0xcd>
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	68 cc 41 80 00       	push   $0x8041cc
  8025ab:	e8 10 e6 ff ff       	call   800bc0 <cprintf>
  8025b0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025ba:	83 ec 0c             	sub    $0xc,%esp
  8025bd:	68 f0 41 80 00       	push   $0x8041f0
  8025c2:	e8 f9 e5 ff ff       	call   800bc0 <cprintf>
  8025c7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025ca:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ce:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d6:	eb 56                	jmp    80262e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025dc:	74 1c                	je     8025fa <print_mem_block_lists+0x114>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 50 08             	mov    0x8(%eax),%edx
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	8b 48 08             	mov    0x8(%eax),%ecx
  8025ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f0:	01 c8                	add    %ecx,%eax
  8025f2:	39 c2                	cmp    %eax,%edx
  8025f4:	73 04                	jae    8025fa <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025f6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 50 08             	mov    0x8(%eax),%edx
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 40 0c             	mov    0xc(%eax),%eax
  802606:	01 c2                	add    %eax,%edx
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 08             	mov    0x8(%eax),%eax
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	52                   	push   %edx
  802612:	50                   	push   %eax
  802613:	68 bd 41 80 00       	push   $0x8041bd
  802618:	e8 a3 e5 ff ff       	call   800bc0 <cprintf>
  80261d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802626:	a1 48 50 80 00       	mov    0x805048,%eax
  80262b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802632:	74 07                	je     80263b <print_mem_block_lists+0x155>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	eb 05                	jmp    802640 <print_mem_block_lists+0x15a>
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
  802640:	a3 48 50 80 00       	mov    %eax,0x805048
  802645:	a1 48 50 80 00       	mov    0x805048,%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	75 8a                	jne    8025d8 <print_mem_block_lists+0xf2>
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	75 84                	jne    8025d8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802654:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802658:	75 10                	jne    80266a <print_mem_block_lists+0x184>
  80265a:	83 ec 0c             	sub    $0xc,%esp
  80265d:	68 08 42 80 00       	push   $0x804208
  802662:	e8 59 e5 ff ff       	call   800bc0 <cprintf>
  802667:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80266a:	83 ec 0c             	sub    $0xc,%esp
  80266d:	68 7c 41 80 00       	push   $0x80417c
  802672:	e8 49 e5 ff ff       	call   800bc0 <cprintf>
  802677:	83 c4 10             	add    $0x10,%esp

}
  80267a:	90                   	nop
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802683:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80268a:	00 00 00 
  80268d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802694:	00 00 00 
  802697:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80269e:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8026a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8026a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026b0:	e9 9e 00 00 00       	jmp    802753 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8026b5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bd:	c1 e2 04             	shl    $0x4,%edx
  8026c0:	01 d0                	add    %edx,%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 14                	jne    8026da <initialize_MemBlocksList+0x5d>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 30 42 80 00       	push   $0x804230
  8026ce:	6a 48                	push   $0x48
  8026d0:	68 53 42 80 00       	push   $0x804253
  8026d5:	e8 32 e2 ff ff       	call   80090c <_panic>
  8026da:	a1 50 50 80 00       	mov    0x805050,%eax
  8026df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e2:	c1 e2 04             	shl    $0x4,%edx
  8026e5:	01 d0                	add    %edx,%eax
  8026e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 18                	je     80270d <initialize_MemBlocksList+0x90>
  8026f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8026fa:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802700:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802703:	c1 e1 04             	shl    $0x4,%ecx
  802706:	01 ca                	add    %ecx,%edx
  802708:	89 50 04             	mov    %edx,0x4(%eax)
  80270b:	eb 12                	jmp    80271f <initialize_MemBlocksList+0xa2>
  80270d:	a1 50 50 80 00       	mov    0x805050,%eax
  802712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802715:	c1 e2 04             	shl    $0x4,%edx
  802718:	01 d0                	add    %edx,%eax
  80271a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80271f:	a1 50 50 80 00       	mov    0x805050,%eax
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	c1 e2 04             	shl    $0x4,%edx
  80272a:	01 d0                	add    %edx,%eax
  80272c:	a3 48 51 80 00       	mov    %eax,0x805148
  802731:	a1 50 50 80 00       	mov    0x805050,%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	c1 e2 04             	shl    $0x4,%edx
  80273c:	01 d0                	add    %edx,%eax
  80273e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802745:	a1 54 51 80 00       	mov    0x805154,%eax
  80274a:	40                   	inc    %eax
  80274b:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802750:	ff 45 f4             	incl   -0xc(%ebp)
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	3b 45 08             	cmp    0x8(%ebp),%eax
  802759:	0f 82 56 ff ff ff    	jb     8026b5 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80275f:	90                   	nop
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802770:	eb 18                	jmp    80278a <find_block+0x28>
		{
			if(tmp->sva==va)
  802772:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802775:	8b 40 08             	mov    0x8(%eax),%eax
  802778:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80277b:	75 05                	jne    802782 <find_block+0x20>
			{
				return tmp;
  80277d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802780:	eb 11                	jmp    802793 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802782:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80278a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80278e:	75 e2                	jne    802772 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802790:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80279b:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	0f 85 83 00 00 00    	jne    80282b <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8027a8:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8027af:	00 00 00 
  8027b2:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8027b9:	00 00 00 
  8027bc:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8027c3:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ca:	75 14                	jne    8027e0 <insert_sorted_allocList+0x4b>
  8027cc:	83 ec 04             	sub    $0x4,%esp
  8027cf:	68 30 42 80 00       	push   $0x804230
  8027d4:	6a 7f                	push   $0x7f
  8027d6:	68 53 42 80 00       	push   $0x804253
  8027db:	e8 2c e1 ff ff       	call   80090c <_panic>
  8027e0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e9:	89 10                	mov    %edx,(%eax)
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 0d                	je     802801 <insert_sorted_allocList+0x6c>
  8027f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fc:	89 50 04             	mov    %edx,0x4(%eax)
  8027ff:	eb 08                	jmp    802809 <insert_sorted_allocList+0x74>
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	a3 44 50 80 00       	mov    %eax,0x805044
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	a3 40 50 80 00       	mov    %eax,0x805040
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802820:	40                   	inc    %eax
  802821:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802826:	e9 16 01 00 00       	jmp    802941 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	8b 50 08             	mov    0x8(%eax),%edx
  802831:	a1 44 50 80 00       	mov    0x805044,%eax
  802836:	8b 40 08             	mov    0x8(%eax),%eax
  802839:	39 c2                	cmp    %eax,%edx
  80283b:	76 68                	jbe    8028a5 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80283d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802841:	75 17                	jne    80285a <insert_sorted_allocList+0xc5>
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 6c 42 80 00       	push   $0x80426c
  80284b:	68 85 00 00 00       	push   $0x85
  802850:	68 53 42 80 00       	push   $0x804253
  802855:	e8 b2 e0 ff ff       	call   80090c <_panic>
  80285a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	89 50 04             	mov    %edx,0x4(%eax)
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	8b 40 04             	mov    0x4(%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	74 0c                	je     80287c <insert_sorted_allocList+0xe7>
  802870:	a1 44 50 80 00       	mov    0x805044,%eax
  802875:	8b 55 08             	mov    0x8(%ebp),%edx
  802878:	89 10                	mov    %edx,(%eax)
  80287a:	eb 08                	jmp    802884 <insert_sorted_allocList+0xef>
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	a3 40 50 80 00       	mov    %eax,0x805040
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	a3 44 50 80 00       	mov    %eax,0x805044
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802895:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80289a:	40                   	inc    %eax
  80289b:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8028a0:	e9 9c 00 00 00       	jmp    802941 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8028a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8028aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8028ad:	e9 85 00 00 00       	jmp    802937 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 50 08             	mov    0x8(%eax),%edx
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 08             	mov    0x8(%eax),%eax
  8028be:	39 c2                	cmp    %eax,%edx
  8028c0:	73 6d                	jae    80292f <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	74 06                	je     8028ce <insert_sorted_allocList+0x139>
  8028c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cc:	75 17                	jne    8028e5 <insert_sorted_allocList+0x150>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 90 42 80 00       	push   $0x804290
  8028d6:	68 90 00 00 00       	push   $0x90
  8028db:	68 53 42 80 00       	push   $0x804253
  8028e0:	e8 27 e0 ff ff       	call   80090c <_panic>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 50 04             	mov    0x4(%eax),%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f7:	89 10                	mov    %edx,(%eax)
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 0d                	je     802910 <insert_sorted_allocList+0x17b>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	8b 55 08             	mov    0x8(%ebp),%edx
  80290c:	89 10                	mov    %edx,(%eax)
  80290e:	eb 08                	jmp    802918 <insert_sorted_allocList+0x183>
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	a3 40 50 80 00       	mov    %eax,0x805040
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 55 08             	mov    0x8(%ebp),%edx
  80291e:	89 50 04             	mov    %edx,0x4(%eax)
  802921:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802926:	40                   	inc    %eax
  802927:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80292c:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80292d:	eb 12                	jmp    802941 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293b:	0f 85 71 ff ff ff    	jne    8028b2 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802941:	90                   	nop
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80294a:	a1 38 51 80 00       	mov    0x805138,%eax
  80294f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802952:	e9 76 01 00 00       	jmp    802acd <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802960:	0f 85 8a 00 00 00    	jne    8029f0 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	75 17                	jne    802983 <alloc_block_FF+0x3f>
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	68 c5 42 80 00       	push   $0x8042c5
  802974:	68 a8 00 00 00       	push   $0xa8
  802979:	68 53 42 80 00       	push   $0x804253
  80297e:	e8 89 df ff ff       	call   80090c <_panic>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 10                	je     80299c <alloc_block_FF+0x58>
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 00                	mov    (%eax),%eax
  802991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802994:	8b 52 04             	mov    0x4(%edx),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	eb 0b                	jmp    8029a7 <alloc_block_FF+0x63>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 40 04             	mov    0x4(%eax),%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	74 0f                	je     8029c0 <alloc_block_FF+0x7c>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ba:	8b 12                	mov    (%edx),%edx
  8029bc:	89 10                	mov    %edx,(%eax)
  8029be:	eb 0a                	jmp    8029ca <alloc_block_FF+0x86>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8029e2:	48                   	dec    %eax
  8029e3:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	e9 ea 00 00 00       	jmp    802ada <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f9:	0f 86 c6 00 00 00    	jbe    802ac5 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8029ff:	a1 48 51 80 00       	mov    0x805148,%eax
  802a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0d:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 50 08             	mov    0x8(%eax),%edx
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	2b 45 08             	sub    0x8(%ebp),%eax
  802a25:	89 c2                	mov    %eax,%edx
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 50 08             	mov    0x8(%eax),%edx
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	01 c2                	add    %eax,%edx
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802a3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a42:	75 17                	jne    802a5b <alloc_block_FF+0x117>
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	68 c5 42 80 00       	push   $0x8042c5
  802a4c:	68 b6 00 00 00       	push   $0xb6
  802a51:	68 53 42 80 00       	push   $0x804253
  802a56:	e8 b1 de ff ff       	call   80090c <_panic>
  802a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	74 10                	je     802a74 <alloc_block_FF+0x130>
  802a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6c:	8b 52 04             	mov    0x4(%edx),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	eb 0b                	jmp    802a7f <alloc_block_FF+0x13b>
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	8b 40 04             	mov    0x4(%eax),%eax
  802a7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	8b 40 04             	mov    0x4(%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 0f                	je     802a98 <alloc_block_FF+0x154>
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a92:	8b 12                	mov    (%edx),%edx
  802a94:	89 10                	mov    %edx,(%eax)
  802a96:	eb 0a                	jmp    802aa2 <alloc_block_FF+0x15e>
  802a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab5:	a1 54 51 80 00       	mov    0x805154,%eax
  802aba:	48                   	dec    %eax
  802abb:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	eb 15                	jmp    802ada <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad1:	0f 85 80 fe ff ff    	jne    802957 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ada:	c9                   	leave  
  802adb:	c3                   	ret    

00802adc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
  802adf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802ae2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802aea:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802af1:	e9 c0 00 00 00       	jmp    802bb6 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aff:	0f 85 8a 00 00 00    	jne    802b8f <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b09:	75 17                	jne    802b22 <alloc_block_BF+0x46>
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	68 c5 42 80 00       	push   $0x8042c5
  802b13:	68 cf 00 00 00       	push   $0xcf
  802b18:	68 53 42 80 00       	push   $0x804253
  802b1d:	e8 ea dd ff ff       	call   80090c <_panic>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	74 10                	je     802b3b <alloc_block_BF+0x5f>
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b33:	8b 52 04             	mov    0x4(%edx),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	eb 0b                	jmp    802b46 <alloc_block_BF+0x6a>
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0f                	je     802b5f <alloc_block_BF+0x83>
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b59:	8b 12                	mov    (%edx),%edx
  802b5b:	89 10                	mov    %edx,(%eax)
  802b5d:	eb 0a                	jmp    802b69 <alloc_block_BF+0x8d>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	a3 38 51 80 00       	mov    %eax,0x805138
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7c:	a1 44 51 80 00       	mov    0x805144,%eax
  802b81:	48                   	dec    %eax
  802b82:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	e9 2a 01 00 00       	jmp    802cb9 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b98:	73 14                	jae    802bae <alloc_block_BF+0xd2>
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba3:	76 09                	jbe    802bae <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bba:	0f 85 36 ff ff ff    	jne    802af6 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802bc0:	a1 38 51 80 00       	mov    0x805138,%eax
  802bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802bc8:	e9 dd 00 00 00       	jmp    802caa <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bd6:	0f 85 c6 00 00 00    	jne    802ca2 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802bdc:	a1 48 51 80 00       	mov    0x805148,%eax
  802be1:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 50 08             	mov    0x8(%eax),%edx
  802bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bed:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf6:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 50 08             	mov    0x8(%eax),%edx
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	01 c2                	add    %eax,%edx
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c10:	2b 45 08             	sub    0x8(%ebp),%eax
  802c13:	89 c2                	mov    %eax,%edx
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c1f:	75 17                	jne    802c38 <alloc_block_BF+0x15c>
  802c21:	83 ec 04             	sub    $0x4,%esp
  802c24:	68 c5 42 80 00       	push   $0x8042c5
  802c29:	68 eb 00 00 00       	push   $0xeb
  802c2e:	68 53 42 80 00       	push   $0x804253
  802c33:	e8 d4 dc ff ff       	call   80090c <_panic>
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 10                	je     802c51 <alloc_block_BF+0x175>
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c49:	8b 52 04             	mov    0x4(%edx),%edx
  802c4c:	89 50 04             	mov    %edx,0x4(%eax)
  802c4f:	eb 0b                	jmp    802c5c <alloc_block_BF+0x180>
  802c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 0f                	je     802c75 <alloc_block_BF+0x199>
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6f:	8b 12                	mov    (%edx),%edx
  802c71:	89 10                	mov    %edx,(%eax)
  802c73:	eb 0a                	jmp    802c7f <alloc_block_BF+0x1a3>
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c92:	a1 54 51 80 00       	mov    0x805154,%eax
  802c97:	48                   	dec    %eax
  802c98:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca0:	eb 17                	jmp    802cb9 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cae:	0f 85 19 ff ff ff    	jne    802bcd <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802cb4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802cb9:	c9                   	leave  
  802cba:	c3                   	ret    

00802cbb <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
  802cbe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802cc1:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	75 19                	jne    802ce3 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802cca:	83 ec 0c             	sub    $0xc,%esp
  802ccd:	ff 75 08             	pushl  0x8(%ebp)
  802cd0:	e8 6f fc ff ff       	call   802944 <alloc_block_FF>
  802cd5:	83 c4 10             	add    $0x10,%esp
  802cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	e9 e9 01 00 00       	jmp    802ecc <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802ce3:	a1 44 50 80 00       	mov    0x805044,%eax
  802ce8:	8b 40 08             	mov    0x8(%eax),%eax
  802ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802cee:	a1 44 50 80 00       	mov    0x805044,%eax
  802cf3:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf6:	a1 44 50 80 00       	mov    0x805044,%eax
  802cfb:	8b 40 08             	mov    0x8(%eax),%eax
  802cfe:	01 d0                	add    %edx,%eax
  802d00:	83 ec 08             	sub    $0x8,%esp
  802d03:	50                   	push   %eax
  802d04:	68 38 51 80 00       	push   $0x805138
  802d09:	e8 54 fa ff ff       	call   802762 <find_block>
  802d0e:	83 c4 10             	add    $0x10,%esp
  802d11:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d1d:	0f 85 9b 00 00 00    	jne    802dbe <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 50 0c             	mov    0xc(%eax),%edx
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 40 08             	mov    0x8(%eax),%eax
  802d2f:	01 d0                	add    %edx,%eax
  802d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d38:	75 17                	jne    802d51 <alloc_block_NF+0x96>
  802d3a:	83 ec 04             	sub    $0x4,%esp
  802d3d:	68 c5 42 80 00       	push   $0x8042c5
  802d42:	68 1a 01 00 00       	push   $0x11a
  802d47:	68 53 42 80 00       	push   $0x804253
  802d4c:	e8 bb db ff ff       	call   80090c <_panic>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	74 10                	je     802d6a <alloc_block_NF+0xaf>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d62:	8b 52 04             	mov    0x4(%edx),%edx
  802d65:	89 50 04             	mov    %edx,0x4(%eax)
  802d68:	eb 0b                	jmp    802d75 <alloc_block_NF+0xba>
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 40 04             	mov    0x4(%eax),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 0f                	je     802d8e <alloc_block_NF+0xd3>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d88:	8b 12                	mov    (%edx),%edx
  802d8a:	89 10                	mov    %edx,(%eax)
  802d8c:	eb 0a                	jmp    802d98 <alloc_block_NF+0xdd>
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	a3 38 51 80 00       	mov    %eax,0x805138
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dab:	a1 44 51 80 00       	mov    0x805144,%eax
  802db0:	48                   	dec    %eax
  802db1:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	e9 0e 01 00 00       	jmp    802ecc <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc7:	0f 86 cf 00 00 00    	jbe    802e9c <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802dcd:	a1 48 51 80 00       	mov    0x805148,%eax
  802dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddb:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 50 08             	mov    0x8(%eax),%edx
  802de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de7:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	01 c2                	add    %eax,%edx
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	2b 45 08             	sub    0x8(%ebp),%eax
  802e04:	89 c2                	mov    %eax,%edx
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
  802e12:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802e15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e19:	75 17                	jne    802e32 <alloc_block_NF+0x177>
  802e1b:	83 ec 04             	sub    $0x4,%esp
  802e1e:	68 c5 42 80 00       	push   $0x8042c5
  802e23:	68 28 01 00 00       	push   $0x128
  802e28:	68 53 42 80 00       	push   $0x804253
  802e2d:	e8 da da ff ff       	call   80090c <_panic>
  802e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 10                	je     802e4b <alloc_block_NF+0x190>
  802e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e43:	8b 52 04             	mov    0x4(%edx),%edx
  802e46:	89 50 04             	mov    %edx,0x4(%eax)
  802e49:	eb 0b                	jmp    802e56 <alloc_block_NF+0x19b>
  802e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	74 0f                	je     802e6f <alloc_block_NF+0x1b4>
  802e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e63:	8b 40 04             	mov    0x4(%eax),%eax
  802e66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e69:	8b 12                	mov    (%edx),%edx
  802e6b:	89 10                	mov    %edx,(%eax)
  802e6d:	eb 0a                	jmp    802e79 <alloc_block_NF+0x1be>
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	a3 48 51 80 00       	mov    %eax,0x805148
  802e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e91:	48                   	dec    %eax
  802e92:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9a:	eb 30                	jmp    802ecc <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802e9c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ea1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ea4:	75 0a                	jne    802eb0 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802ea6:	a1 38 51 80 00       	mov    0x805138,%eax
  802eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eae:	eb 08                	jmp    802eb8 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 08             	mov    0x8(%eax),%eax
  802ebe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ec1:	0f 85 4d fe ff ff    	jne    802d14 <alloc_block_NF+0x59>

			return NULL;
  802ec7:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802ecc:	c9                   	leave  
  802ecd:	c3                   	ret    

00802ece <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ece:	55                   	push   %ebp
  802ecf:	89 e5                	mov    %esp,%ebp
  802ed1:	53                   	push   %ebx
  802ed2:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802ed5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	0f 85 86 00 00 00    	jne    802f68 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802ee2:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802ee9:	00 00 00 
  802eec:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802ef3:	00 00 00 
  802ef6:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802efd:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f04:	75 17                	jne    802f1d <insert_sorted_with_merge_freeList+0x4f>
  802f06:	83 ec 04             	sub    $0x4,%esp
  802f09:	68 30 42 80 00       	push   $0x804230
  802f0e:	68 48 01 00 00       	push   $0x148
  802f13:	68 53 42 80 00       	push   $0x804253
  802f18:	e8 ef d9 ff ff       	call   80090c <_panic>
  802f1d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	74 0d                	je     802f3e <insert_sorted_with_merge_freeList+0x70>
  802f31:	a1 38 51 80 00       	mov    0x805138,%eax
  802f36:	8b 55 08             	mov    0x8(%ebp),%edx
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	eb 08                	jmp    802f46 <insert_sorted_with_merge_freeList+0x78>
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	a3 38 51 80 00       	mov    %eax,0x805138
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5d:	40                   	inc    %eax
  802f5e:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802f63:	e9 73 07 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	8b 50 08             	mov    0x8(%eax),%edx
  802f6e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f73:	8b 40 08             	mov    0x8(%eax),%eax
  802f76:	39 c2                	cmp    %eax,%edx
  802f78:	0f 86 84 00 00 00    	jbe    803002 <insert_sorted_with_merge_freeList+0x134>
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	8b 50 08             	mov    0x8(%eax),%edx
  802f84:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f89:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f8c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f91:	8b 40 08             	mov    0x8(%eax),%eax
  802f94:	01 c8                	add    %ecx,%eax
  802f96:	39 c2                	cmp    %eax,%edx
  802f98:	74 68                	je     803002 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802f9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9e:	75 17                	jne    802fb7 <insert_sorted_with_merge_freeList+0xe9>
  802fa0:	83 ec 04             	sub    $0x4,%esp
  802fa3:	68 6c 42 80 00       	push   $0x80426c
  802fa8:	68 4c 01 00 00       	push   $0x14c
  802fad:	68 53 42 80 00       	push   $0x804253
  802fb2:	e8 55 d9 ff ff       	call   80090c <_panic>
  802fb7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	89 50 04             	mov    %edx,0x4(%eax)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 40 04             	mov    0x4(%eax),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	74 0c                	je     802fd9 <insert_sorted_with_merge_freeList+0x10b>
  802fcd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd5:	89 10                	mov    %edx,(%eax)
  802fd7:	eb 08                	jmp    802fe1 <insert_sorted_with_merge_freeList+0x113>
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff7:	40                   	inc    %eax
  802ff8:	a3 44 51 80 00       	mov    %eax,0x805144
  802ffd:	e9 d9 06 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	8b 50 08             	mov    0x8(%eax),%edx
  803008:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80300d:	8b 40 08             	mov    0x8(%eax),%eax
  803010:	39 c2                	cmp    %eax,%edx
  803012:	0f 86 b5 00 00 00    	jbe    8030cd <insert_sorted_with_merge_freeList+0x1ff>
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	8b 50 08             	mov    0x8(%eax),%edx
  80301e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803023:	8b 48 0c             	mov    0xc(%eax),%ecx
  803026:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80302b:	8b 40 08             	mov    0x8(%eax),%eax
  80302e:	01 c8                	add    %ecx,%eax
  803030:	39 c2                	cmp    %eax,%edx
  803032:	0f 85 95 00 00 00    	jne    8030cd <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803038:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80303d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803043:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803046:	8b 55 08             	mov    0x8(%ebp),%edx
  803049:	8b 52 0c             	mov    0xc(%edx),%edx
  80304c:	01 ca                	add    %ecx,%edx
  80304e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803069:	75 17                	jne    803082 <insert_sorted_with_merge_freeList+0x1b4>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 30 42 80 00       	push   $0x804230
  803073:	68 54 01 00 00       	push   $0x154
  803078:	68 53 42 80 00       	push   $0x804253
  80307d:	e8 8a d8 ff ff       	call   80090c <_panic>
  803082:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 0d                	je     8030a3 <insert_sorted_with_merge_freeList+0x1d5>
  803096:	a1 48 51 80 00       	mov    0x805148,%eax
  80309b:	8b 55 08             	mov    0x8(%ebp),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	eb 08                	jmp    8030ab <insert_sorted_with_merge_freeList+0x1dd>
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c2:	40                   	inc    %eax
  8030c3:	a3 54 51 80 00       	mov    %eax,0x805154
  8030c8:	e9 0e 06 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	8b 50 08             	mov    0x8(%eax),%edx
  8030d3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d8:	8b 40 08             	mov    0x8(%eax),%eax
  8030db:	39 c2                	cmp    %eax,%edx
  8030dd:	0f 83 c1 00 00 00    	jae    8031a4 <insert_sorted_with_merge_freeList+0x2d6>
  8030e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e8:	8b 50 08             	mov    0x8(%eax),%edx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 48 08             	mov    0x8(%eax),%ecx
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	01 c8                	add    %ecx,%eax
  8030f9:	39 c2                	cmp    %eax,%edx
  8030fb:	0f 85 a3 00 00 00    	jne    8031a4 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803101:	a1 38 51 80 00       	mov    0x805138,%eax
  803106:	8b 55 08             	mov    0x8(%ebp),%edx
  803109:	8b 52 08             	mov    0x8(%edx),%edx
  80310c:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80310f:	a1 38 51 80 00       	mov    0x805138,%eax
  803114:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80311a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80311d:	8b 55 08             	mov    0x8(%ebp),%edx
  803120:	8b 52 0c             	mov    0xc(%edx),%edx
  803123:	01 ca                	add    %ecx,%edx
  803125:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80313c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803140:	75 17                	jne    803159 <insert_sorted_with_merge_freeList+0x28b>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 30 42 80 00       	push   $0x804230
  80314a:	68 5d 01 00 00       	push   $0x15d
  80314f:	68 53 42 80 00       	push   $0x804253
  803154:	e8 b3 d7 ff ff       	call   80090c <_panic>
  803159:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	89 10                	mov    %edx,(%eax)
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0d                	je     80317a <insert_sorted_with_merge_freeList+0x2ac>
  80316d:	a1 48 51 80 00       	mov    0x805148,%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 08                	jmp    803182 <insert_sorted_with_merge_freeList+0x2b4>
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 48 51 80 00       	mov    %eax,0x805148
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803194:	a1 54 51 80 00       	mov    0x805154,%eax
  803199:	40                   	inc    %eax
  80319a:	a3 54 51 80 00       	mov    %eax,0x805154
  80319f:	e9 37 05 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 50 08             	mov    0x8(%eax),%edx
  8031aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8031af:	8b 40 08             	mov    0x8(%eax),%eax
  8031b2:	39 c2                	cmp    %eax,%edx
  8031b4:	0f 83 82 00 00 00    	jae    80323c <insert_sorted_with_merge_freeList+0x36e>
  8031ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8031bf:	8b 50 08             	mov    0x8(%eax),%edx
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	8b 48 08             	mov    0x8(%eax),%ecx
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ce:	01 c8                	add    %ecx,%eax
  8031d0:	39 c2                	cmp    %eax,%edx
  8031d2:	74 68                	je     80323c <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8031d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d8:	75 17                	jne    8031f1 <insert_sorted_with_merge_freeList+0x323>
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	68 30 42 80 00       	push   $0x804230
  8031e2:	68 62 01 00 00       	push   $0x162
  8031e7:	68 53 42 80 00       	push   $0x804253
  8031ec:	e8 1b d7 ff ff       	call   80090c <_panic>
  8031f1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	89 10                	mov    %edx,(%eax)
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 0d                	je     803212 <insert_sorted_with_merge_freeList+0x344>
  803205:	a1 38 51 80 00       	mov    0x805138,%eax
  80320a:	8b 55 08             	mov    0x8(%ebp),%edx
  80320d:	89 50 04             	mov    %edx,0x4(%eax)
  803210:	eb 08                	jmp    80321a <insert_sorted_with_merge_freeList+0x34c>
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	a3 38 51 80 00       	mov    %eax,0x805138
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322c:	a1 44 51 80 00       	mov    0x805144,%eax
  803231:	40                   	inc    %eax
  803232:	a3 44 51 80 00       	mov    %eax,0x805144
  803237:	e9 9f 04 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  80323c:	a1 38 51 80 00       	mov    0x805138,%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803246:	e9 84 04 00 00       	jmp    8036cf <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 50 08             	mov    0x8(%eax),%edx
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	8b 40 08             	mov    0x8(%eax),%eax
  803257:	39 c2                	cmp    %eax,%edx
  803259:	0f 86 a9 00 00 00    	jbe    803308 <insert_sorted_with_merge_freeList+0x43a>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 50 08             	mov    0x8(%eax),%edx
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 48 08             	mov    0x8(%eax),%ecx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c8                	add    %ecx,%eax
  803273:	39 c2                	cmp    %eax,%edx
  803275:	0f 84 8d 00 00 00    	je     803308 <insert_sorted_with_merge_freeList+0x43a>
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	8b 50 08             	mov    0x8(%eax),%edx
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 40 04             	mov    0x4(%eax),%eax
  803287:	8b 48 08             	mov    0x8(%eax),%ecx
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	8b 40 04             	mov    0x4(%eax),%eax
  803290:	8b 40 0c             	mov    0xc(%eax),%eax
  803293:	01 c8                	add    %ecx,%eax
  803295:	39 c2                	cmp    %eax,%edx
  803297:	74 6f                	je     803308 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803299:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329d:	74 06                	je     8032a5 <insert_sorted_with_merge_freeList+0x3d7>
  80329f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a3:	75 17                	jne    8032bc <insert_sorted_with_merge_freeList+0x3ee>
  8032a5:	83 ec 04             	sub    $0x4,%esp
  8032a8:	68 90 42 80 00       	push   $0x804290
  8032ad:	68 6b 01 00 00       	push   $0x16b
  8032b2:	68 53 42 80 00       	push   $0x804253
  8032b7:	e8 50 d6 ff ff       	call   80090c <_panic>
  8032bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bf:	8b 50 04             	mov    0x4(%eax),%edx
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	89 50 04             	mov    %edx,0x4(%eax)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 40 04             	mov    0x4(%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0d                	je     8032e7 <insert_sorted_with_merge_freeList+0x419>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e3:	89 10                	mov    %edx,(%eax)
  8032e5:	eb 08                	jmp    8032ef <insert_sorted_with_merge_freeList+0x421>
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fd:	40                   	inc    %eax
  8032fe:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  803303:	e9 d3 03 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 50 08             	mov    0x8(%eax),%edx
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	8b 40 08             	mov    0x8(%eax),%eax
  803314:	39 c2                	cmp    %eax,%edx
  803316:	0f 86 da 00 00 00    	jbe    8033f6 <insert_sorted_with_merge_freeList+0x528>
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	8b 50 08             	mov    0x8(%eax),%edx
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 48 08             	mov    0x8(%eax),%ecx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	8b 40 0c             	mov    0xc(%eax),%eax
  80332e:	01 c8                	add    %ecx,%eax
  803330:	39 c2                	cmp    %eax,%edx
  803332:	0f 85 be 00 00 00    	jne    8033f6 <insert_sorted_with_merge_freeList+0x528>
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 50 08             	mov    0x8(%eax),%edx
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	8b 48 08             	mov    0x8(%eax),%ecx
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	8b 40 04             	mov    0x4(%eax),%eax
  80334d:	8b 40 0c             	mov    0xc(%eax),%eax
  803350:	01 c8                	add    %ecx,%eax
  803352:	39 c2                	cmp    %eax,%edx
  803354:	0f 84 9c 00 00 00    	je     8033f6 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 50 08             	mov    0x8(%eax),%edx
  803360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803363:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 50 0c             	mov    0xc(%eax),%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	8b 40 0c             	mov    0xc(%eax),%eax
  803372:	01 c2                	add    %eax,%edx
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80338e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803392:	75 17                	jne    8033ab <insert_sorted_with_merge_freeList+0x4dd>
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	68 30 42 80 00       	push   $0x804230
  80339c:	68 74 01 00 00       	push   $0x174
  8033a1:	68 53 42 80 00       	push   $0x804253
  8033a6:	e8 61 d5 ff ff       	call   80090c <_panic>
  8033ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	89 10                	mov    %edx,(%eax)
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <insert_sorted_with_merge_freeList+0x4fe>
  8033bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ca:	eb 08                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x506>
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033eb:	40                   	inc    %eax
  8033ec:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8033f1:	e9 e5 02 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f9:	8b 50 08             	mov    0x8(%eax),%edx
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 40 08             	mov    0x8(%eax),%eax
  803402:	39 c2                	cmp    %eax,%edx
  803404:	0f 86 d7 00 00 00    	jbe    8034e1 <insert_sorted_with_merge_freeList+0x613>
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	8b 50 08             	mov    0x8(%eax),%edx
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	8b 48 08             	mov    0x8(%eax),%ecx
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 40 0c             	mov    0xc(%eax),%eax
  80341c:	01 c8                	add    %ecx,%eax
  80341e:	39 c2                	cmp    %eax,%edx
  803420:	0f 84 bb 00 00 00    	je     8034e1 <insert_sorted_with_merge_freeList+0x613>
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 40 04             	mov    0x4(%eax),%eax
  803432:	8b 48 08             	mov    0x8(%eax),%ecx
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	8b 40 0c             	mov    0xc(%eax),%eax
  80343e:	01 c8                	add    %ecx,%eax
  803440:	39 c2                	cmp    %eax,%edx
  803442:	0f 85 99 00 00 00    	jne    8034e1 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 40 04             	mov    0x4(%eax),%eax
  80344e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803454:	8b 50 0c             	mov    0xc(%eax),%edx
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	8b 40 0c             	mov    0xc(%eax),%eax
  80345d:	01 c2                	add    %eax,%edx
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803479:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347d:	75 17                	jne    803496 <insert_sorted_with_merge_freeList+0x5c8>
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	68 30 42 80 00       	push   $0x804230
  803487:	68 7d 01 00 00       	push   $0x17d
  80348c:	68 53 42 80 00       	push   $0x804253
  803491:	e8 76 d4 ff ff       	call   80090c <_panic>
  803496:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	89 10                	mov    %edx,(%eax)
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	74 0d                	je     8034b7 <insert_sorted_with_merge_freeList+0x5e9>
  8034aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8034af:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b2:	89 50 04             	mov    %edx,0x4(%eax)
  8034b5:	eb 08                	jmp    8034bf <insert_sorted_with_merge_freeList+0x5f1>
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d6:	40                   	inc    %eax
  8034d7:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8034dc:	e9 fa 01 00 00       	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	8b 50 08             	mov    0x8(%eax),%edx
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 40 08             	mov    0x8(%eax),%eax
  8034ed:	39 c2                	cmp    %eax,%edx
  8034ef:	0f 86 d2 01 00 00    	jbe    8036c7 <insert_sorted_with_merge_freeList+0x7f9>
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	8b 50 08             	mov    0x8(%eax),%edx
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 48 08             	mov    0x8(%eax),%ecx
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	8b 40 0c             	mov    0xc(%eax),%eax
  803507:	01 c8                	add    %ecx,%eax
  803509:	39 c2                	cmp    %eax,%edx
  80350b:	0f 85 b6 01 00 00    	jne    8036c7 <insert_sorted_with_merge_freeList+0x7f9>
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 50 08             	mov    0x8(%eax),%edx
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	8b 40 04             	mov    0x4(%eax),%eax
  80351d:	8b 48 08             	mov    0x8(%eax),%ecx
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	8b 40 0c             	mov    0xc(%eax),%eax
  803529:	01 c8                	add    %ecx,%eax
  80352b:	39 c2                	cmp    %eax,%edx
  80352d:	0f 85 94 01 00 00    	jne    8036c7 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80353c:	8b 52 04             	mov    0x4(%edx),%edx
  80353f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803542:	8b 55 08             	mov    0x8(%ebp),%edx
  803545:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80354b:	8b 52 0c             	mov    0xc(%edx),%edx
  80354e:	01 da                	add    %ebx,%edx
  803550:	01 ca                	add    %ecx,%edx
  803552:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80355f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356d:	75 17                	jne    803586 <insert_sorted_with_merge_freeList+0x6b8>
  80356f:	83 ec 04             	sub    $0x4,%esp
  803572:	68 c5 42 80 00       	push   $0x8042c5
  803577:	68 86 01 00 00       	push   $0x186
  80357c:	68 53 42 80 00       	push   $0x804253
  803581:	e8 86 d3 ff ff       	call   80090c <_panic>
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	85 c0                	test   %eax,%eax
  80358d:	74 10                	je     80359f <insert_sorted_with_merge_freeList+0x6d1>
  80358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803592:	8b 00                	mov    (%eax),%eax
  803594:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803597:	8b 52 04             	mov    0x4(%edx),%edx
  80359a:	89 50 04             	mov    %edx,0x4(%eax)
  80359d:	eb 0b                	jmp    8035aa <insert_sorted_with_merge_freeList+0x6dc>
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 40 04             	mov    0x4(%eax),%eax
  8035a5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 40 04             	mov    0x4(%eax),%eax
  8035b0:	85 c0                	test   %eax,%eax
  8035b2:	74 0f                	je     8035c3 <insert_sorted_with_merge_freeList+0x6f5>
  8035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035bd:	8b 12                	mov    (%edx),%edx
  8035bf:	89 10                	mov    %edx,(%eax)
  8035c1:	eb 0a                	jmp    8035cd <insert_sorted_with_merge_freeList+0x6ff>
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e5:	48                   	dec    %eax
  8035e6:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8035eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ef:	75 17                	jne    803608 <insert_sorted_with_merge_freeList+0x73a>
  8035f1:	83 ec 04             	sub    $0x4,%esp
  8035f4:	68 30 42 80 00       	push   $0x804230
  8035f9:	68 87 01 00 00       	push   $0x187
  8035fe:	68 53 42 80 00       	push   $0x804253
  803603:	e8 04 d3 ff ff       	call   80090c <_panic>
  803608:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	89 10                	mov    %edx,(%eax)
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	74 0d                	je     803629 <insert_sorted_with_merge_freeList+0x75b>
  80361c:	a1 48 51 80 00       	mov    0x805148,%eax
  803621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803624:	89 50 04             	mov    %edx,0x4(%eax)
  803627:	eb 08                	jmp    803631 <insert_sorted_with_merge_freeList+0x763>
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803634:	a3 48 51 80 00       	mov    %eax,0x805148
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803643:	a1 54 51 80 00       	mov    0x805154,%eax
  803648:	40                   	inc    %eax
  803649:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803662:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803666:	75 17                	jne    80367f <insert_sorted_with_merge_freeList+0x7b1>
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 30 42 80 00       	push   $0x804230
  803670:	68 8a 01 00 00       	push   $0x18a
  803675:	68 53 42 80 00       	push   $0x804253
  80367a:	e8 8d d2 ff ff       	call   80090c <_panic>
  80367f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	74 0d                	je     8036a0 <insert_sorted_with_merge_freeList+0x7d2>
  803693:	a1 48 51 80 00       	mov    0x805148,%eax
  803698:	8b 55 08             	mov    0x8(%ebp),%edx
  80369b:	89 50 04             	mov    %edx,0x4(%eax)
  80369e:	eb 08                	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7da>
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8036bf:	40                   	inc    %eax
  8036c0:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8036c5:	eb 14                	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8036cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d3:	0f 85 72 fb ff ff    	jne    80324b <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8036d9:	eb 00                	jmp    8036db <insert_sorted_with_merge_freeList+0x80d>
  8036db:	90                   	nop
  8036dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036df:	c9                   	leave  
  8036e0:	c3                   	ret    
  8036e1:	66 90                	xchg   %ax,%ax
  8036e3:	90                   	nop

008036e4 <__udivdi3>:
  8036e4:	55                   	push   %ebp
  8036e5:	57                   	push   %edi
  8036e6:	56                   	push   %esi
  8036e7:	53                   	push   %ebx
  8036e8:	83 ec 1c             	sub    $0x1c,%esp
  8036eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036fb:	89 ca                	mov    %ecx,%edx
  8036fd:	89 f8                	mov    %edi,%eax
  8036ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803703:	85 f6                	test   %esi,%esi
  803705:	75 2d                	jne    803734 <__udivdi3+0x50>
  803707:	39 cf                	cmp    %ecx,%edi
  803709:	77 65                	ja     803770 <__udivdi3+0x8c>
  80370b:	89 fd                	mov    %edi,%ebp
  80370d:	85 ff                	test   %edi,%edi
  80370f:	75 0b                	jne    80371c <__udivdi3+0x38>
  803711:	b8 01 00 00 00       	mov    $0x1,%eax
  803716:	31 d2                	xor    %edx,%edx
  803718:	f7 f7                	div    %edi
  80371a:	89 c5                	mov    %eax,%ebp
  80371c:	31 d2                	xor    %edx,%edx
  80371e:	89 c8                	mov    %ecx,%eax
  803720:	f7 f5                	div    %ebp
  803722:	89 c1                	mov    %eax,%ecx
  803724:	89 d8                	mov    %ebx,%eax
  803726:	f7 f5                	div    %ebp
  803728:	89 cf                	mov    %ecx,%edi
  80372a:	89 fa                	mov    %edi,%edx
  80372c:	83 c4 1c             	add    $0x1c,%esp
  80372f:	5b                   	pop    %ebx
  803730:	5e                   	pop    %esi
  803731:	5f                   	pop    %edi
  803732:	5d                   	pop    %ebp
  803733:	c3                   	ret    
  803734:	39 ce                	cmp    %ecx,%esi
  803736:	77 28                	ja     803760 <__udivdi3+0x7c>
  803738:	0f bd fe             	bsr    %esi,%edi
  80373b:	83 f7 1f             	xor    $0x1f,%edi
  80373e:	75 40                	jne    803780 <__udivdi3+0x9c>
  803740:	39 ce                	cmp    %ecx,%esi
  803742:	72 0a                	jb     80374e <__udivdi3+0x6a>
  803744:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803748:	0f 87 9e 00 00 00    	ja     8037ec <__udivdi3+0x108>
  80374e:	b8 01 00 00 00       	mov    $0x1,%eax
  803753:	89 fa                	mov    %edi,%edx
  803755:	83 c4 1c             	add    $0x1c,%esp
  803758:	5b                   	pop    %ebx
  803759:	5e                   	pop    %esi
  80375a:	5f                   	pop    %edi
  80375b:	5d                   	pop    %ebp
  80375c:	c3                   	ret    
  80375d:	8d 76 00             	lea    0x0(%esi),%esi
  803760:	31 ff                	xor    %edi,%edi
  803762:	31 c0                	xor    %eax,%eax
  803764:	89 fa                	mov    %edi,%edx
  803766:	83 c4 1c             	add    $0x1c,%esp
  803769:	5b                   	pop    %ebx
  80376a:	5e                   	pop    %esi
  80376b:	5f                   	pop    %edi
  80376c:	5d                   	pop    %ebp
  80376d:	c3                   	ret    
  80376e:	66 90                	xchg   %ax,%ax
  803770:	89 d8                	mov    %ebx,%eax
  803772:	f7 f7                	div    %edi
  803774:	31 ff                	xor    %edi,%edi
  803776:	89 fa                	mov    %edi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	bd 20 00 00 00       	mov    $0x20,%ebp
  803785:	89 eb                	mov    %ebp,%ebx
  803787:	29 fb                	sub    %edi,%ebx
  803789:	89 f9                	mov    %edi,%ecx
  80378b:	d3 e6                	shl    %cl,%esi
  80378d:	89 c5                	mov    %eax,%ebp
  80378f:	88 d9                	mov    %bl,%cl
  803791:	d3 ed                	shr    %cl,%ebp
  803793:	89 e9                	mov    %ebp,%ecx
  803795:	09 f1                	or     %esi,%ecx
  803797:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80379b:	89 f9                	mov    %edi,%ecx
  80379d:	d3 e0                	shl    %cl,%eax
  80379f:	89 c5                	mov    %eax,%ebp
  8037a1:	89 d6                	mov    %edx,%esi
  8037a3:	88 d9                	mov    %bl,%cl
  8037a5:	d3 ee                	shr    %cl,%esi
  8037a7:	89 f9                	mov    %edi,%ecx
  8037a9:	d3 e2                	shl    %cl,%edx
  8037ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037af:	88 d9                	mov    %bl,%cl
  8037b1:	d3 e8                	shr    %cl,%eax
  8037b3:	09 c2                	or     %eax,%edx
  8037b5:	89 d0                	mov    %edx,%eax
  8037b7:	89 f2                	mov    %esi,%edx
  8037b9:	f7 74 24 0c          	divl   0xc(%esp)
  8037bd:	89 d6                	mov    %edx,%esi
  8037bf:	89 c3                	mov    %eax,%ebx
  8037c1:	f7 e5                	mul    %ebp
  8037c3:	39 d6                	cmp    %edx,%esi
  8037c5:	72 19                	jb     8037e0 <__udivdi3+0xfc>
  8037c7:	74 0b                	je     8037d4 <__udivdi3+0xf0>
  8037c9:	89 d8                	mov    %ebx,%eax
  8037cb:	31 ff                	xor    %edi,%edi
  8037cd:	e9 58 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037d2:	66 90                	xchg   %ax,%ax
  8037d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037d8:	89 f9                	mov    %edi,%ecx
  8037da:	d3 e2                	shl    %cl,%edx
  8037dc:	39 c2                	cmp    %eax,%edx
  8037de:	73 e9                	jae    8037c9 <__udivdi3+0xe5>
  8037e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037e3:	31 ff                	xor    %edi,%edi
  8037e5:	e9 40 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037ea:	66 90                	xchg   %ax,%ax
  8037ec:	31 c0                	xor    %eax,%eax
  8037ee:	e9 37 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037f3:	90                   	nop

008037f4 <__umoddi3>:
  8037f4:	55                   	push   %ebp
  8037f5:	57                   	push   %edi
  8037f6:	56                   	push   %esi
  8037f7:	53                   	push   %ebx
  8037f8:	83 ec 1c             	sub    $0x1c,%esp
  8037fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803803:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803807:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80380b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80380f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803813:	89 f3                	mov    %esi,%ebx
  803815:	89 fa                	mov    %edi,%edx
  803817:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80381b:	89 34 24             	mov    %esi,(%esp)
  80381e:	85 c0                	test   %eax,%eax
  803820:	75 1a                	jne    80383c <__umoddi3+0x48>
  803822:	39 f7                	cmp    %esi,%edi
  803824:	0f 86 a2 00 00 00    	jbe    8038cc <__umoddi3+0xd8>
  80382a:	89 c8                	mov    %ecx,%eax
  80382c:	89 f2                	mov    %esi,%edx
  80382e:	f7 f7                	div    %edi
  803830:	89 d0                	mov    %edx,%eax
  803832:	31 d2                	xor    %edx,%edx
  803834:	83 c4 1c             	add    $0x1c,%esp
  803837:	5b                   	pop    %ebx
  803838:	5e                   	pop    %esi
  803839:	5f                   	pop    %edi
  80383a:	5d                   	pop    %ebp
  80383b:	c3                   	ret    
  80383c:	39 f0                	cmp    %esi,%eax
  80383e:	0f 87 ac 00 00 00    	ja     8038f0 <__umoddi3+0xfc>
  803844:	0f bd e8             	bsr    %eax,%ebp
  803847:	83 f5 1f             	xor    $0x1f,%ebp
  80384a:	0f 84 ac 00 00 00    	je     8038fc <__umoddi3+0x108>
  803850:	bf 20 00 00 00       	mov    $0x20,%edi
  803855:	29 ef                	sub    %ebp,%edi
  803857:	89 fe                	mov    %edi,%esi
  803859:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80385d:	89 e9                	mov    %ebp,%ecx
  80385f:	d3 e0                	shl    %cl,%eax
  803861:	89 d7                	mov    %edx,%edi
  803863:	89 f1                	mov    %esi,%ecx
  803865:	d3 ef                	shr    %cl,%edi
  803867:	09 c7                	or     %eax,%edi
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 e2                	shl    %cl,%edx
  80386d:	89 14 24             	mov    %edx,(%esp)
  803870:	89 d8                	mov    %ebx,%eax
  803872:	d3 e0                	shl    %cl,%eax
  803874:	89 c2                	mov    %eax,%edx
  803876:	8b 44 24 08          	mov    0x8(%esp),%eax
  80387a:	d3 e0                	shl    %cl,%eax
  80387c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803880:	8b 44 24 08          	mov    0x8(%esp),%eax
  803884:	89 f1                	mov    %esi,%ecx
  803886:	d3 e8                	shr    %cl,%eax
  803888:	09 d0                	or     %edx,%eax
  80388a:	d3 eb                	shr    %cl,%ebx
  80388c:	89 da                	mov    %ebx,%edx
  80388e:	f7 f7                	div    %edi
  803890:	89 d3                	mov    %edx,%ebx
  803892:	f7 24 24             	mull   (%esp)
  803895:	89 c6                	mov    %eax,%esi
  803897:	89 d1                	mov    %edx,%ecx
  803899:	39 d3                	cmp    %edx,%ebx
  80389b:	0f 82 87 00 00 00    	jb     803928 <__umoddi3+0x134>
  8038a1:	0f 84 91 00 00 00    	je     803938 <__umoddi3+0x144>
  8038a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038ab:	29 f2                	sub    %esi,%edx
  8038ad:	19 cb                	sbb    %ecx,%ebx
  8038af:	89 d8                	mov    %ebx,%eax
  8038b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038b5:	d3 e0                	shl    %cl,%eax
  8038b7:	89 e9                	mov    %ebp,%ecx
  8038b9:	d3 ea                	shr    %cl,%edx
  8038bb:	09 d0                	or     %edx,%eax
  8038bd:	89 e9                	mov    %ebp,%ecx
  8038bf:	d3 eb                	shr    %cl,%ebx
  8038c1:	89 da                	mov    %ebx,%edx
  8038c3:	83 c4 1c             	add    $0x1c,%esp
  8038c6:	5b                   	pop    %ebx
  8038c7:	5e                   	pop    %esi
  8038c8:	5f                   	pop    %edi
  8038c9:	5d                   	pop    %ebp
  8038ca:	c3                   	ret    
  8038cb:	90                   	nop
  8038cc:	89 fd                	mov    %edi,%ebp
  8038ce:	85 ff                	test   %edi,%edi
  8038d0:	75 0b                	jne    8038dd <__umoddi3+0xe9>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	31 d2                	xor    %edx,%edx
  8038d9:	f7 f7                	div    %edi
  8038db:	89 c5                	mov    %eax,%ebp
  8038dd:	89 f0                	mov    %esi,%eax
  8038df:	31 d2                	xor    %edx,%edx
  8038e1:	f7 f5                	div    %ebp
  8038e3:	89 c8                	mov    %ecx,%eax
  8038e5:	f7 f5                	div    %ebp
  8038e7:	89 d0                	mov    %edx,%eax
  8038e9:	e9 44 ff ff ff       	jmp    803832 <__umoddi3+0x3e>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	89 c8                	mov    %ecx,%eax
  8038f2:	89 f2                	mov    %esi,%edx
  8038f4:	83 c4 1c             	add    $0x1c,%esp
  8038f7:	5b                   	pop    %ebx
  8038f8:	5e                   	pop    %esi
  8038f9:	5f                   	pop    %edi
  8038fa:	5d                   	pop    %ebp
  8038fb:	c3                   	ret    
  8038fc:	3b 04 24             	cmp    (%esp),%eax
  8038ff:	72 06                	jb     803907 <__umoddi3+0x113>
  803901:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803905:	77 0f                	ja     803916 <__umoddi3+0x122>
  803907:	89 f2                	mov    %esi,%edx
  803909:	29 f9                	sub    %edi,%ecx
  80390b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80390f:	89 14 24             	mov    %edx,(%esp)
  803912:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803916:	8b 44 24 04          	mov    0x4(%esp),%eax
  80391a:	8b 14 24             	mov    (%esp),%edx
  80391d:	83 c4 1c             	add    $0x1c,%esp
  803920:	5b                   	pop    %ebx
  803921:	5e                   	pop    %esi
  803922:	5f                   	pop    %edi
  803923:	5d                   	pop    %ebp
  803924:	c3                   	ret    
  803925:	8d 76 00             	lea    0x0(%esi),%esi
  803928:	2b 04 24             	sub    (%esp),%eax
  80392b:	19 fa                	sbb    %edi,%edx
  80392d:	89 d1                	mov    %edx,%ecx
  80392f:	89 c6                	mov    %eax,%esi
  803931:	e9 71 ff ff ff       	jmp    8038a7 <__umoddi3+0xb3>
  803936:	66 90                	xchg   %ax,%ax
  803938:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80393c:	72 ea                	jb     803928 <__umoddi3+0x134>
  80393e:	89 d9                	mov    %ebx,%ecx
  803940:	e9 62 ff ff ff       	jmp    8038a7 <__umoddi3+0xb3>
