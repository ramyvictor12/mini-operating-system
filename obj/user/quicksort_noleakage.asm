
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 95 20 00 00       	call   8020db <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 39 80 00       	push   $0x8039c0
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 39 80 00       	push   $0x8039c2
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 db 39 80 00       	push   $0x8039db
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 39 80 00       	push   $0x8039c2
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 39 80 00       	push   $0x8039c0
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f4 39 80 00       	push   $0x8039f4
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 b5 1a 00 00       	call   801b8a <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 14 3a 80 00       	push   $0x803a14
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 36 3a 80 00       	push   $0x803a36
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 44 3a 80 00       	push   $0x803a44
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 53 3a 80 00       	push   $0x803a53
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 63 3a 80 00       	push   $0x803a63
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 8e 1f 00 00       	call   8020f5 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 01 1f 00 00       	call   8020db <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 3a 80 00       	push   $0x803a6c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 06 1f 00 00       	call   8020f5 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 a0 3a 80 00       	push   $0x803aa0
  800211:	6a 49                	push   $0x49
  800213:	68 c2 3a 80 00       	push   $0x803ac2
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 b9 1e 00 00       	call   8020db <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 e0 3a 80 00       	push   $0x803ae0
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 14 3b 80 00       	push   $0x803b14
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 48 3b 80 00       	push   $0x803b48
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 9e 1e 00 00       	call   8020f5 <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 b3 19 00 00       	call   801c15 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 71 1e 00 00       	call   8020db <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 7a 3b 80 00       	push   $0x803b7a
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 51 1e 00 00       	call   8020f5 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 c0 39 80 00       	push   $0x8039c0
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 98 3b 80 00       	push   $0x803b98
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 9d 3b 80 00       	push   $0x803b9d
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 52 1b 00 00       	call   80210f <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 0d 1b 00 00       	call   8020db <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 2e 1b 00 00       	call   80210f <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 0c 1b 00 00       	call   8020f5 <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 56 19 00 00       	call   801f56 <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 c2 1a 00 00       	call   8020db <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 2f 19 00 00       	call   801f56 <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 c0 1a 00 00       	call   8020f5 <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 7f 1c 00 00       	call   8022ce <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 21 1a 00 00       	call   8020db <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 bc 3b 80 00       	push   $0x803bbc
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 e4 3b 80 00       	push   $0x803be4
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 0c 3c 80 00       	push   $0x803c0c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 64 3c 80 00       	push   $0x803c64
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 bc 3b 80 00       	push   $0x803bbc
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 a1 19 00 00       	call   8020f5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 2e 1b 00 00       	call   80229a <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 83 1b 00 00       	call   802300 <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 78 3c 80 00       	push   $0x803c78
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 7d 3c 80 00       	push   $0x803c7d
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 99 3c 80 00       	push   $0x803c99
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 9c 3c 80 00       	push   $0x803c9c
  80080f:	6a 26                	push   $0x26
  800811:	68 e8 3c 80 00       	push   $0x803ce8
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 f4 3c 80 00       	push   $0x803cf4
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 e8 3c 80 00       	push   $0x803ce8
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 48 3d 80 00       	push   $0x803d48
  800951:	6a 44                	push   $0x44
  800953:	68 e8 3c 80 00       	push   $0x803ce8
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 82 15 00 00       	call   801f2d <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 0b 15 00 00       	call   801f2d <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 6f 16 00 00       	call   8020db <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 69 16 00 00       	call   8020f5 <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 86 2c 00 00       	call   80375c <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 46 2d 00 00       	call   80386c <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 b4 3f 80 00       	add    $0x803fb4,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 c5 3f 80 00       	push   $0x803fc5
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 ce 3f 80 00       	push   $0x803fce
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be d1 3f 80 00       	mov    $0x803fd1,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 30 41 80 00       	push   $0x804130
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 33 41 80 00       	push   $0x804133
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 1c 0f 00 00       	call   8020db <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 30 41 80 00       	push   $0x804130
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 33 41 80 00       	push   $0x804133
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 da 0e 00 00       	call   8020f5 <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 42 0e 00 00       	call   8020f5 <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 44 41 80 00       	push   $0x804144
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8019fb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a02:	00 00 00 
  801a05:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a0c:	00 00 00 
  801a0f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a16:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801a19:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a20:	00 00 00 
  801a23:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a2a:	00 00 00 
  801a2d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a34:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801a37:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a3e:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801a41:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801a48:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a57:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a5c:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801a61:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801a68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a70:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	6a 06                	push   $0x6
  801a7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	e8 ee 05 00 00       	call   802071 <sys_allocate_chunk>
  801a83:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a86:	a1 20 51 80 00       	mov    0x805120,%eax
  801a8b:	83 ec 0c             	sub    $0xc,%esp
  801a8e:	50                   	push   %eax
  801a8f:	e8 63 0c 00 00       	call   8026f7 <initialize_MemBlocksList>
  801a94:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801a97:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aa2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aac:	8b 40 0c             	mov    0xc(%eax),%eax
  801aaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aba:	89 c2                	mov    %eax,%edx
  801abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801abf:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801acc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad6:	8b 50 08             	mov    0x8(%eax),%edx
  801ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	48                   	dec    %eax
  801adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aea:	f7 75 e0             	divl   -0x20(%ebp)
  801aed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af0:	29 d0                	sub    %edx,%eax
  801af2:	89 c2                	mov    %eax,%edx
  801af4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af7:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801afa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801afe:	75 14                	jne    801b14 <initialize_dyn_block_system+0x11f>
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	68 69 41 80 00       	push   $0x804169
  801b08:	6a 34                	push   $0x34
  801b0a:	68 87 41 80 00       	push   $0x804187
  801b0f:	e8 6c ec ff ff       	call   800780 <_panic>
  801b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	74 10                	je     801b2d <initialize_dyn_block_system+0x138>
  801b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b20:	8b 00                	mov    (%eax),%eax
  801b22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b25:	8b 52 04             	mov    0x4(%edx),%edx
  801b28:	89 50 04             	mov    %edx,0x4(%eax)
  801b2b:	eb 0b                	jmp    801b38 <initialize_dyn_block_system+0x143>
  801b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b30:	8b 40 04             	mov    0x4(%eax),%eax
  801b33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b3b:	8b 40 04             	mov    0x4(%eax),%eax
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	74 0f                	je     801b51 <initialize_dyn_block_system+0x15c>
  801b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b45:	8b 40 04             	mov    0x4(%eax),%eax
  801b48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b4b:	8b 12                	mov    (%edx),%edx
  801b4d:	89 10                	mov    %edx,(%eax)
  801b4f:	eb 0a                	jmp    801b5b <initialize_dyn_block_system+0x166>
  801b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b54:	8b 00                	mov    (%eax),%eax
  801b56:	a3 48 51 80 00       	mov    %eax,0x805148
  801b5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b6e:	a1 54 51 80 00       	mov    0x805154,%eax
  801b73:	48                   	dec    %eax
  801b74:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7f:	e8 c4 13 00 00       	call   802f48 <insert_sorted_with_merge_freeList>
  801b84:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b87:	90                   	nop
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <malloc>:
//=================================



void* malloc(uint32 size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b90:	e8 2f fe ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b99:	75 07                	jne    801ba2 <malloc+0x18>
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba0:	eb 71                	jmp    801c13 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801ba2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ba9:	76 07                	jbe    801bb2 <malloc+0x28>
	return NULL;
  801bab:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb0:	eb 61                	jmp    801c13 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bb2:	e8 88 08 00 00       	call   80243f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	74 53                	je     801c0e <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801bbb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	01 d0                	add    %edx,%eax
  801bca:	48                   	dec    %eax
  801bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd6:	f7 75 f4             	divl   -0xc(%ebp)
  801bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdc:	29 d0                	sub    %edx,%eax
  801bde:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	ff 75 ec             	pushl  -0x14(%ebp)
  801be7:	e8 d2 0d 00 00       	call   8029be <alloc_block_FF>
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801bf2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801bf6:	74 16                	je     801c0e <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	ff 75 e8             	pushl  -0x18(%ebp)
  801bfe:	e8 0c 0c 00 00       	call   80280f <insert_sorted_allocList>
  801c03:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c09:	8b 40 08             	mov    0x8(%eax),%eax
  801c0c:	eb 05                	jmp    801c13 <malloc+0x89>
    }

			}


	return NULL;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c32:	68 40 50 80 00       	push   $0x805040
  801c37:	e8 a0 0b 00 00       	call   8027dc <find_block>
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c45:	8b 50 0c             	mov    0xc(%eax),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	e8 e4 03 00 00       	call   802039 <sys_free_user_mem>
  801c55:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801c58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c5c:	75 17                	jne    801c75 <free+0x60>
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	68 69 41 80 00       	push   $0x804169
  801c66:	68 84 00 00 00       	push   $0x84
  801c6b:	68 87 41 80 00       	push   $0x804187
  801c70:	e8 0b eb ff ff       	call   800780 <_panic>
  801c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c78:	8b 00                	mov    (%eax),%eax
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	74 10                	je     801c8e <free+0x79>
  801c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c81:	8b 00                	mov    (%eax),%eax
  801c83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c86:	8b 52 04             	mov    0x4(%edx),%edx
  801c89:	89 50 04             	mov    %edx,0x4(%eax)
  801c8c:	eb 0b                	jmp    801c99 <free+0x84>
  801c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c91:	8b 40 04             	mov    0x4(%eax),%eax
  801c94:	a3 44 50 80 00       	mov    %eax,0x805044
  801c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9c:	8b 40 04             	mov    0x4(%eax),%eax
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	74 0f                	je     801cb2 <free+0x9d>
  801ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca6:	8b 40 04             	mov    0x4(%eax),%eax
  801ca9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cac:	8b 12                	mov    (%edx),%edx
  801cae:	89 10                	mov    %edx,(%eax)
  801cb0:	eb 0a                	jmp    801cbc <free+0xa7>
  801cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb5:	8b 00                	mov    (%eax),%eax
  801cb7:	a3 40 50 80 00       	mov    %eax,0x805040
  801cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ccf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801cd4:	48                   	dec    %eax
  801cd5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	ff 75 ec             	pushl  -0x14(%ebp)
  801ce0:	e8 63 12 00 00       	call   802f48 <insert_sorted_with_merge_freeList>
  801ce5:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 38             	sub    $0x38,%esp
  801cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cf7:	e8 c8 fc ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d00:	75 0a                	jne    801d0c <smalloc+0x21>
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	e9 a0 00 00 00       	jmp    801dac <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801d0c:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801d13:	76 0a                	jbe    801d1f <smalloc+0x34>
		return NULL;
  801d15:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1a:	e9 8d 00 00 00       	jmp    801dac <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d1f:	e8 1b 07 00 00       	call   80243f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d24:	85 c0                	test   %eax,%eax
  801d26:	74 7f                	je     801da7 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d28:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	01 d0                	add    %edx,%eax
  801d37:	48                   	dec    %eax
  801d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d43:	f7 75 f4             	divl   -0xc(%ebp)
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	29 d0                	sub    %edx,%eax
  801d4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	ff 75 ec             	pushl  -0x14(%ebp)
  801d54:	e8 65 0c 00 00       	call   8029be <alloc_block_FF>
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801d5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d63:	74 42                	je     801da7 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	ff 75 e8             	pushl  -0x18(%ebp)
  801d6b:	e8 9f 0a 00 00       	call   80280f <insert_sorted_allocList>
  801d70:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d76:	8b 40 08             	mov    0x8(%eax),%eax
  801d79:	89 c2                	mov    %eax,%edx
  801d7b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d7f:	52                   	push   %edx
  801d80:	50                   	push   %eax
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	e8 38 04 00 00       	call   8021c4 <sys_createSharedObject>
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801d92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d96:	79 07                	jns    801d9f <smalloc+0xb4>
	    		  return NULL;
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9d:	eb 0d                	jmp    801dac <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da2:	8b 40 08             	mov    0x8(%eax),%eax
  801da5:	eb 05                	jmp    801dac <smalloc+0xc1>


				}


		return NULL;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801db4:	e8 0b fc ff ff       	call   8019c4 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801db9:	e8 81 06 00 00       	call   80243f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	0f 84 9f 00 00 00    	je     801e65 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	ff 75 08             	pushl  0x8(%ebp)
  801dcf:	e8 1a 04 00 00       	call   8021ee <sys_getSizeOfSharedObject>
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dde:	79 0a                	jns    801dea <sget+0x3c>
		return NULL;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
  801de5:	e9 80 00 00 00       	jmp    801e6a <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801dea:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df7:	01 d0                	add    %edx,%eax
  801df9:	48                   	dec    %eax
  801dfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e00:	ba 00 00 00 00       	mov    $0x0,%edx
  801e05:	f7 75 f0             	divl   -0x10(%ebp)
  801e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0b:	29 d0                	sub    %edx,%eax
  801e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	ff 75 e8             	pushl  -0x18(%ebp)
  801e16:	e8 a3 0b 00 00       	call   8029be <alloc_block_FF>
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801e21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e25:	74 3e                	je     801e65 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e2d:	e8 dd 09 00 00       	call   80280f <insert_sorted_allocList>
  801e32:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e38:	8b 40 08             	mov    0x8(%eax),%eax
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	50                   	push   %eax
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 c1 03 00 00       	call   80220b <sys_getSharedObject>
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e54:	79 07                	jns    801e5d <sget+0xaf>
	    		  return NULL;
  801e56:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5b:	eb 0d                	jmp    801e6a <sget+0xbc>
	  	return(void*) returned_block->sva;
  801e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e60:	8b 40 08             	mov    0x8(%eax),%eax
  801e63:	eb 05                	jmp    801e6a <sget+0xbc>
	      }
	}
	   return NULL;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e72:	e8 4d fb ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 94 41 80 00       	push   $0x804194
  801e7f:	68 12 01 00 00       	push   $0x112
  801e84:	68 87 41 80 00       	push   $0x804187
  801e89:	e8 f2 e8 ff ff       	call   800780 <_panic>

00801e8e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	68 bc 41 80 00       	push   $0x8041bc
  801e9c:	68 26 01 00 00       	push   $0x126
  801ea1:	68 87 41 80 00       	push   $0x804187
  801ea6:	e8 d5 e8 ff ff       	call   800780 <_panic>

00801eab <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	68 e0 41 80 00       	push   $0x8041e0
  801eb9:	68 31 01 00 00       	push   $0x131
  801ebe:	68 87 41 80 00       	push   $0x804187
  801ec3:	e8 b8 e8 ff ff       	call   800780 <_panic>

00801ec8 <shrink>:

}
void shrink(uint32 newSize)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	68 e0 41 80 00       	push   $0x8041e0
  801ed6:	68 36 01 00 00       	push   $0x136
  801edb:	68 87 41 80 00       	push   $0x804187
  801ee0:	e8 9b e8 ff ff       	call   800780 <_panic>

00801ee5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	68 e0 41 80 00       	push   $0x8041e0
  801ef3:	68 3b 01 00 00       	push   $0x13b
  801ef8:	68 87 41 80 00       	push   $0x804187
  801efd:	e8 7e e8 ff ff       	call   800780 <_panic>

00801f02 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f17:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f1a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f1d:	cd 30                	int    $0x30
  801f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5e                   	pop    %esi
  801f2a:	5f                   	pop    %edi
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    

00801f2d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	8b 45 10             	mov    0x10(%ebp),%eax
  801f36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f39:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	52                   	push   %edx
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	50                   	push   %eax
  801f49:	6a 00                	push   $0x0
  801f4b:	e8 b2 ff ff ff       	call   801f02 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 01                	push   $0x1
  801f65:	e8 98 ff ff ff       	call   801f02 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 05                	push   $0x5
  801f82:	e8 7b ff ff ff       	call   801f02 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	56                   	push   %esi
  801f90:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f91:	8b 75 18             	mov    0x18(%ebp),%esi
  801f94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	56                   	push   %esi
  801fa1:	53                   	push   %ebx
  801fa2:	51                   	push   %ecx
  801fa3:	52                   	push   %edx
  801fa4:	50                   	push   %eax
  801fa5:	6a 06                	push   $0x6
  801fa7:	e8 56 ff ff ff       	call   801f02 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb2:	5b                   	pop    %ebx
  801fb3:	5e                   	pop    %esi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	6a 07                	push   $0x7
  801fc9:	e8 34 ff ff ff       	call   801f02 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	ff 75 0c             	pushl  0xc(%ebp)
  801fdf:	ff 75 08             	pushl  0x8(%ebp)
  801fe2:	6a 08                	push   $0x8
  801fe4:	e8 19 ff ff ff       	call   801f02 <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 09                	push   $0x9
  801ffd:	e8 00 ff ff ff       	call   801f02 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 0a                	push   $0xa
  802016:	e8 e7 fe ff ff       	call   801f02 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 0b                	push   $0xb
  80202f:	e8 ce fe ff ff       	call   801f02 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	ff 75 08             	pushl  0x8(%ebp)
  802048:	6a 0f                	push   $0xf
  80204a:	e8 b3 fe ff ff       	call   801f02 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return;
  802052:	90                   	nop
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	ff 75 08             	pushl  0x8(%ebp)
  802064:	6a 10                	push   $0x10
  802066:	e8 97 fe ff ff       	call   801f02 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
	return ;
  80206e:	90                   	nop
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	ff 75 10             	pushl  0x10(%ebp)
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	6a 11                	push   $0x11
  802083:	e8 7a fe ff ff       	call   801f02 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
	return ;
  80208b:	90                   	nop
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 0c                	push   $0xc
  80209d:	e8 60 fe ff ff       	call   801f02 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	6a 0d                	push   $0xd
  8020b7:	e8 46 fe ff ff       	call   801f02 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 0e                	push   $0xe
  8020d0:	e8 2d fe ff ff       	call   801f02 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 13                	push   $0x13
  8020ea:	e8 13 fe ff ff       	call   801f02 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	90                   	nop
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 14                	push   $0x14
  802104:	e8 f9 fd ff ff       	call   801f02 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_cputc>:


void
sys_cputc(const char c)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80211b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	50                   	push   %eax
  802128:	6a 15                	push   $0x15
  80212a:	e8 d3 fd ff ff       	call   801f02 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	90                   	nop
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 16                	push   $0x16
  802144:	e8 b9 fd ff ff       	call   801f02 <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	90                   	nop
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	ff 75 0c             	pushl  0xc(%ebp)
  80215e:	50                   	push   %eax
  80215f:	6a 17                	push   $0x17
  802161:	e8 9c fd ff ff       	call   801f02 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80216e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	52                   	push   %edx
  80217b:	50                   	push   %eax
  80217c:	6a 1a                	push   $0x1a
  80217e:	e8 7f fd ff ff       	call   801f02 <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80218b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	52                   	push   %edx
  802198:	50                   	push   %eax
  802199:	6a 18                	push   $0x18
  80219b:	e8 62 fd ff ff       	call   801f02 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	90                   	nop
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	52                   	push   %edx
  8021b6:	50                   	push   %eax
  8021b7:	6a 19                	push   $0x19
  8021b9:	e8 44 fd ff ff       	call   801f02 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
}
  8021c1:	90                   	nop
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	6a 00                	push   $0x0
  8021dc:	51                   	push   %ecx
  8021dd:	52                   	push   %edx
  8021de:	ff 75 0c             	pushl  0xc(%ebp)
  8021e1:	50                   	push   %eax
  8021e2:	6a 1b                	push   $0x1b
  8021e4:	e8 19 fd ff ff       	call   801f02 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	52                   	push   %edx
  8021fe:	50                   	push   %eax
  8021ff:	6a 1c                	push   $0x1c
  802201:	e8 fc fc ff ff       	call   801f02 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80220e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802211:	8b 55 0c             	mov    0xc(%ebp),%edx
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	51                   	push   %ecx
  80221c:	52                   	push   %edx
  80221d:	50                   	push   %eax
  80221e:	6a 1d                	push   $0x1d
  802220:	e8 dd fc ff ff       	call   801f02 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80222d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	52                   	push   %edx
  80223a:	50                   	push   %eax
  80223b:	6a 1e                	push   $0x1e
  80223d:	e8 c0 fc ff ff       	call   801f02 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 1f                	push   $0x1f
  802256:	e8 a7 fc ff ff       	call   801f02 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	ff 75 14             	pushl  0x14(%ebp)
  80226b:	ff 75 10             	pushl  0x10(%ebp)
  80226e:	ff 75 0c             	pushl  0xc(%ebp)
  802271:	50                   	push   %eax
  802272:	6a 20                	push   $0x20
  802274:	e8 89 fc ff ff       	call   801f02 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	50                   	push   %eax
  80228d:	6a 21                	push   $0x21
  80228f:	e8 6e fc ff ff       	call   801f02 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	50                   	push   %eax
  8022a9:	6a 22                	push   $0x22
  8022ab:	e8 52 fc ff ff       	call   801f02 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 02                	push   $0x2
  8022c4:	e8 39 fc ff ff       	call   801f02 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 03                	push   $0x3
  8022dd:	e8 20 fc ff ff       	call   801f02 <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 04                	push   $0x4
  8022f6:	e8 07 fc ff ff       	call   801f02 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_exit_env>:


void sys_exit_env(void)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 23                	push   $0x23
  80230f:	e8 ee fb ff ff       	call   801f02 <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
}
  802317:	90                   	nop
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802320:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802323:	8d 50 04             	lea    0x4(%eax),%edx
  802326:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	52                   	push   %edx
  802330:	50                   	push   %eax
  802331:	6a 24                	push   $0x24
  802333:	e8 ca fb ff ff       	call   801f02 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
	return result;
  80233b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80233e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802341:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802344:	89 01                	mov    %eax,(%ecx)
  802346:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	c9                   	leave  
  80234d:	c2 04 00             	ret    $0x4

00802350 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	ff 75 10             	pushl  0x10(%ebp)
  80235a:	ff 75 0c             	pushl  0xc(%ebp)
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	6a 12                	push   $0x12
  802362:	e8 9b fb ff ff       	call   801f02 <syscall>
  802367:	83 c4 18             	add    $0x18,%esp
	return ;
  80236a:	90                   	nop
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_rcr2>:
uint32 sys_rcr2()
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 25                	push   $0x25
  80237c:	e8 81 fb ff ff       	call   801f02 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802392:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	50                   	push   %eax
  80239f:	6a 26                	push   $0x26
  8023a1:	e8 5c fb ff ff       	call   801f02 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <rsttst>:
void rsttst()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 28                	push   $0x28
  8023bb:	e8 42 fb ff ff       	call   801f02 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c3:	90                   	nop
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8023cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023d2:	8b 55 18             	mov    0x18(%ebp),%edx
  8023d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d9:	52                   	push   %edx
  8023da:	50                   	push   %eax
  8023db:	ff 75 10             	pushl  0x10(%ebp)
  8023de:	ff 75 0c             	pushl  0xc(%ebp)
  8023e1:	ff 75 08             	pushl  0x8(%ebp)
  8023e4:	6a 27                	push   $0x27
  8023e6:	e8 17 fb ff ff       	call   801f02 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ee:	90                   	nop
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <chktst>:
void chktst(uint32 n)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	ff 75 08             	pushl  0x8(%ebp)
  8023ff:	6a 29                	push   $0x29
  802401:	e8 fc fa ff ff       	call   801f02 <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
	return ;
  802409:	90                   	nop
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <inctst>:

void inctst()
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 2a                	push   $0x2a
  80241b:	e8 e2 fa ff ff       	call   801f02 <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
	return ;
  802423:	90                   	nop
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <gettst>:
uint32 gettst()
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 2b                	push   $0x2b
  802435:	e8 c8 fa ff ff       	call   801f02 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 2c                	push   $0x2c
  802451:	e8 ac fa ff ff       	call   801f02 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
  802459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80245c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802460:	75 07                	jne    802469 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802462:	b8 01 00 00 00       	mov    $0x1,%eax
  802467:	eb 05                	jmp    80246e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 2c                	push   $0x2c
  802482:	e8 7b fa ff ff       	call   801f02 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
  80248a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80248d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802491:	75 07                	jne    80249a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802493:	b8 01 00 00 00       	mov    $0x1,%eax
  802498:	eb 05                	jmp    80249f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80249a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 2c                	push   $0x2c
  8024b3:	e8 4a fa ff ff       	call   801f02 <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
  8024bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024be:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024c2:	75 07                	jne    8024cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c9:	eb 05                	jmp    8024d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 2c                	push   $0x2c
  8024e4:	e8 19 fa ff ff       	call   801f02 <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
  8024ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024ef:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024f3:	75 07                	jne    8024fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fa:	eb 05                	jmp    802501 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 08             	pushl  0x8(%ebp)
  802511:	6a 2d                	push   $0x2d
  802513:	e8 ea f9 ff ff       	call   801f02 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
	return ;
  80251b:	90                   	nop
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802522:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802525:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	6a 00                	push   $0x0
  802530:	53                   	push   %ebx
  802531:	51                   	push   %ecx
  802532:	52                   	push   %edx
  802533:	50                   	push   %eax
  802534:	6a 2e                	push   $0x2e
  802536:	e8 c7 f9 ff ff       	call   801f02 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
}
  80253e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802546:	8b 55 0c             	mov    0xc(%ebp),%edx
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	52                   	push   %edx
  802553:	50                   	push   %eax
  802554:	6a 2f                	push   $0x2f
  802556:	e8 a7 f9 ff ff       	call   801f02 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	68 f0 41 80 00       	push   $0x8041f0
  80256e:	e8 c1 e4 ff ff       	call   800a34 <cprintf>
  802573:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802576:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	68 1c 42 80 00       	push   $0x80421c
  802585:	e8 aa e4 ff ff       	call   800a34 <cprintf>
  80258a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80258d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802591:	a1 38 51 80 00       	mov    0x805138,%eax
  802596:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802599:	eb 56                	jmp    8025f1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80259f:	74 1c                	je     8025bd <print_mem_block_lists+0x5d>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 50 08             	mov    0x8(%eax),%edx
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	01 c8                	add    %ecx,%eax
  8025b5:	39 c2                	cmp    %eax,%edx
  8025b7:	73 04                	jae    8025bd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025b9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 50 08             	mov    0x8(%eax),%edx
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	01 c2                	add    %eax,%edx
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 40 08             	mov    0x8(%eax),%eax
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	52                   	push   %edx
  8025d5:	50                   	push   %eax
  8025d6:	68 31 42 80 00       	push   $0x804231
  8025db:	e8 54 e4 ff ff       	call   800a34 <cprintf>
  8025e0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <print_mem_block_lists+0x9e>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <print_mem_block_lists+0xa3>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	a3 40 51 80 00       	mov    %eax,0x805140
  802608:	a1 40 51 80 00       	mov    0x805140,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	75 8a                	jne    80259b <print_mem_block_lists+0x3b>
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	75 84                	jne    80259b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802617:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261b:	75 10                	jne    80262d <print_mem_block_lists+0xcd>
  80261d:	83 ec 0c             	sub    $0xc,%esp
  802620:	68 40 42 80 00       	push   $0x804240
  802625:	e8 0a e4 ff ff       	call   800a34 <cprintf>
  80262a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80262d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802634:	83 ec 0c             	sub    $0xc,%esp
  802637:	68 64 42 80 00       	push   $0x804264
  80263c:	e8 f3 e3 ff ff       	call   800a34 <cprintf>
  802641:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802644:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802648:	a1 40 50 80 00       	mov    0x805040,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	eb 56                	jmp    8026a8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802656:	74 1c                	je     802674 <print_mem_block_lists+0x114>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 50 08             	mov    0x8(%eax),%edx
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	8b 48 08             	mov    0x8(%eax),%ecx
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	01 c8                	add    %ecx,%eax
  80266c:	39 c2                	cmp    %eax,%edx
  80266e:	73 04                	jae    802674 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802670:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 50 08             	mov    0x8(%eax),%edx
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 0c             	mov    0xc(%eax),%eax
  802680:	01 c2                	add    %eax,%edx
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	52                   	push   %edx
  80268c:	50                   	push   %eax
  80268d:	68 31 42 80 00       	push   $0x804231
  802692:	e8 9d e3 ff ff       	call   800a34 <cprintf>
  802697:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ac:	74 07                	je     8026b5 <print_mem_block_lists+0x155>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	eb 05                	jmp    8026ba <print_mem_block_lists+0x15a>
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	a3 48 50 80 00       	mov    %eax,0x805048
  8026bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	75 8a                	jne    802652 <print_mem_block_lists+0xf2>
  8026c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cc:	75 84                	jne    802652 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026d2:	75 10                	jne    8026e4 <print_mem_block_lists+0x184>
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	68 7c 42 80 00       	push   $0x80427c
  8026dc:	e8 53 e3 ff ff       	call   800a34 <cprintf>
  8026e1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	68 f0 41 80 00       	push   $0x8041f0
  8026ec:	e8 43 e3 ff ff       	call   800a34 <cprintf>
  8026f1:	83 c4 10             	add    $0x10,%esp

}
  8026f4:	90                   	nop
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8026fd:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802704:	00 00 00 
  802707:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80270e:	00 00 00 
  802711:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802718:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80271b:	a1 50 50 80 00       	mov    0x805050,%eax
  802720:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802723:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80272a:	e9 9e 00 00 00       	jmp    8027cd <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80272f:	a1 50 50 80 00       	mov    0x805050,%eax
  802734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802737:	c1 e2 04             	shl    $0x4,%edx
  80273a:	01 d0                	add    %edx,%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	75 14                	jne    802754 <initialize_MemBlocksList+0x5d>
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	68 a4 42 80 00       	push   $0x8042a4
  802748:	6a 48                	push   $0x48
  80274a:	68 c7 42 80 00       	push   $0x8042c7
  80274f:	e8 2c e0 ff ff       	call   800780 <_panic>
  802754:	a1 50 50 80 00       	mov    0x805050,%eax
  802759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275c:	c1 e2 04             	shl    $0x4,%edx
  80275f:	01 d0                	add    %edx,%eax
  802761:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802767:	89 10                	mov    %edx,(%eax)
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 18                	je     802787 <initialize_MemBlocksList+0x90>
  80276f:	a1 48 51 80 00       	mov    0x805148,%eax
  802774:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80277a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80277d:	c1 e1 04             	shl    $0x4,%ecx
  802780:	01 ca                	add    %ecx,%edx
  802782:	89 50 04             	mov    %edx,0x4(%eax)
  802785:	eb 12                	jmp    802799 <initialize_MemBlocksList+0xa2>
  802787:	a1 50 50 80 00       	mov    0x805050,%eax
  80278c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278f:	c1 e2 04             	shl    $0x4,%edx
  802792:	01 d0                	add    %edx,%eax
  802794:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802799:	a1 50 50 80 00       	mov    0x805050,%eax
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	c1 e2 04             	shl    $0x4,%edx
  8027a4:	01 d0                	add    %edx,%eax
  8027a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8027b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b3:	c1 e2 04             	shl    $0x4,%edx
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8027c4:	40                   	inc    %eax
  8027c5:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8027ca:	ff 45 f4             	incl   -0xc(%ebp)
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d3:	0f 82 56 ff ff ff    	jb     80272f <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8027d9:	90                   	nop
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8027ea:	eb 18                	jmp    802804 <find_block+0x28>
		{
			if(tmp->sva==va)
  8027ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ef:	8b 40 08             	mov    0x8(%eax),%eax
  8027f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027f5:	75 05                	jne    8027fc <find_block+0x20>
			{
				return tmp;
  8027f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027fa:	eb 11                	jmp    80280d <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8027fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802804:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802808:	75 e2                	jne    8027ec <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80280a:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
  802812:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802815:	a1 40 50 80 00       	mov    0x805040,%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	0f 85 83 00 00 00    	jne    8028a5 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802822:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802829:	00 00 00 
  80282c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802833:	00 00 00 
  802836:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80283d:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802840:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802844:	75 14                	jne    80285a <insert_sorted_allocList+0x4b>
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	68 a4 42 80 00       	push   $0x8042a4
  80284e:	6a 7f                	push   $0x7f
  802850:	68 c7 42 80 00       	push   $0x8042c7
  802855:	e8 26 df ff ff       	call   800780 <_panic>
  80285a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	89 10                	mov    %edx,(%eax)
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	74 0d                	je     80287b <insert_sorted_allocList+0x6c>
  80286e:	a1 40 50 80 00       	mov    0x805040,%eax
  802873:	8b 55 08             	mov    0x8(%ebp),%edx
  802876:	89 50 04             	mov    %edx,0x4(%eax)
  802879:	eb 08                	jmp    802883 <insert_sorted_allocList+0x74>
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	a3 44 50 80 00       	mov    %eax,0x805044
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	a3 40 50 80 00       	mov    %eax,0x805040
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802895:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80289a:	40                   	inc    %eax
  80289b:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8028a0:	e9 16 01 00 00       	jmp    8029bb <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	8b 50 08             	mov    0x8(%eax),%edx
  8028ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8028b0:	8b 40 08             	mov    0x8(%eax),%eax
  8028b3:	39 c2                	cmp    %eax,%edx
  8028b5:	76 68                	jbe    80291f <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8028b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028bb:	75 17                	jne    8028d4 <insert_sorted_allocList+0xc5>
  8028bd:	83 ec 04             	sub    $0x4,%esp
  8028c0:	68 e0 42 80 00       	push   $0x8042e0
  8028c5:	68 85 00 00 00       	push   $0x85
  8028ca:	68 c7 42 80 00       	push   $0x8042c7
  8028cf:	e8 ac de ff ff       	call   800780 <_panic>
  8028d4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 0c                	je     8028f6 <insert_sorted_allocList+0xe7>
  8028ea:	a1 44 50 80 00       	mov    0x805044,%eax
  8028ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f2:	89 10                	mov    %edx,(%eax)
  8028f4:	eb 08                	jmp    8028fe <insert_sorted_allocList+0xef>
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	a3 40 50 80 00       	mov    %eax,0x805040
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	a3 44 50 80 00       	mov    %eax,0x805044
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802914:	40                   	inc    %eax
  802915:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80291a:	e9 9c 00 00 00       	jmp    8029bb <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80291f:	a1 40 50 80 00       	mov    0x805040,%eax
  802924:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802927:	e9 85 00 00 00       	jmp    8029b1 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8b 50 08             	mov    0x8(%eax),%edx
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 08             	mov    0x8(%eax),%eax
  802938:	39 c2                	cmp    %eax,%edx
  80293a:	73 6d                	jae    8029a9 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80293c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802940:	74 06                	je     802948 <insert_sorted_allocList+0x139>
  802942:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802946:	75 17                	jne    80295f <insert_sorted_allocList+0x150>
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	68 04 43 80 00       	push   $0x804304
  802950:	68 90 00 00 00       	push   $0x90
  802955:	68 c7 42 80 00       	push   $0x8042c7
  80295a:	e8 21 de ff ff       	call   800780 <_panic>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 04             	mov    0x4(%eax),%edx
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	89 50 04             	mov    %edx,0x4(%eax)
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 0d                	je     80298a <insert_sorted_allocList+0x17b>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	8b 55 08             	mov    0x8(%ebp),%edx
  802986:	89 10                	mov    %edx,(%eax)
  802988:	eb 08                	jmp    802992 <insert_sorted_allocList+0x183>
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	a3 40 50 80 00       	mov    %eax,0x805040
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 55 08             	mov    0x8(%ebp),%edx
  802998:	89 50 04             	mov    %edx,0x4(%eax)
  80299b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a0:	40                   	inc    %eax
  8029a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029a6:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029a7:	eb 12                	jmp    8029bb <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8029b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b5:	0f 85 71 ff ff ff    	jne    80292c <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029bb:	90                   	nop
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
  8029c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8029c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8029cc:	e9 76 01 00 00       	jmp    802b47 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029da:	0f 85 8a 00 00 00    	jne    802a6a <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8029e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e4:	75 17                	jne    8029fd <alloc_block_FF+0x3f>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 39 43 80 00       	push   $0x804339
  8029ee:	68 a8 00 00 00       	push   $0xa8
  8029f3:	68 c7 42 80 00       	push   $0x8042c7
  8029f8:	e8 83 dd ff ff       	call   800780 <_panic>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 10                	je     802a16 <alloc_block_FF+0x58>
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0e:	8b 52 04             	mov    0x4(%edx),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 0b                	jmp    802a21 <alloc_block_FF+0x63>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0f                	je     802a3a <alloc_block_FF+0x7c>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 40 04             	mov    0x4(%eax),%eax
  802a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a34:	8b 12                	mov    (%edx),%edx
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	eb 0a                	jmp    802a44 <alloc_block_FF+0x86>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a57:	a1 44 51 80 00       	mov    0x805144,%eax
  802a5c:	48                   	dec    %eax
  802a5d:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	e9 ea 00 00 00       	jmp    802b54 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a73:	0f 86 c6 00 00 00    	jbe    802b3f <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a79:	a1 48 51 80 00       	mov    0x805148,%eax
  802a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	8b 55 08             	mov    0x8(%ebp),%edx
  802a87:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 50 08             	mov    0x8(%eax),%edx
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9f:	89 c2                	mov    %eax,%edx
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 50 08             	mov    0x8(%eax),%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	01 c2                	add    %eax,%edx
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ab8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802abc:	75 17                	jne    802ad5 <alloc_block_FF+0x117>
  802abe:	83 ec 04             	sub    $0x4,%esp
  802ac1:	68 39 43 80 00       	push   $0x804339
  802ac6:	68 b6 00 00 00       	push   $0xb6
  802acb:	68 c7 42 80 00       	push   $0x8042c7
  802ad0:	e8 ab dc ff ff       	call   800780 <_panic>
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 10                	je     802aee <alloc_block_FF+0x130>
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae6:	8b 52 04             	mov    0x4(%edx),%edx
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	eb 0b                	jmp    802af9 <alloc_block_FF+0x13b>
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	8b 40 04             	mov    0x4(%eax),%eax
  802af4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	74 0f                	je     802b12 <alloc_block_FF+0x154>
  802b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0c:	8b 12                	mov    (%edx),%edx
  802b0e:	89 10                	mov    %edx,(%eax)
  802b10:	eb 0a                	jmp    802b1c <alloc_block_FF+0x15e>
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	a3 48 51 80 00       	mov    %eax,0x805148
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b34:	48                   	dec    %eax
  802b35:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	eb 15                	jmp    802b54 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4b:	0f 85 80 fe ff ff    	jne    8029d1 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
  802b59:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802b5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802b64:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802b6b:	e9 c0 00 00 00       	jmp    802c30 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b79:	0f 85 8a 00 00 00    	jne    802c09 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b83:	75 17                	jne    802b9c <alloc_block_BF+0x46>
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	68 39 43 80 00       	push   $0x804339
  802b8d:	68 cf 00 00 00       	push   $0xcf
  802b92:	68 c7 42 80 00       	push   $0x8042c7
  802b97:	e8 e4 db ff ff       	call   800780 <_panic>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 10                	je     802bb5 <alloc_block_BF+0x5f>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bad:	8b 52 04             	mov    0x4(%edx),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 0b                	jmp    802bc0 <alloc_block_BF+0x6a>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 04             	mov    0x4(%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 0f                	je     802bd9 <alloc_block_BF+0x83>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd3:	8b 12                	mov    (%edx),%edx
  802bd5:	89 10                	mov    %edx,(%eax)
  802bd7:	eb 0a                	jmp    802be3 <alloc_block_BF+0x8d>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	a3 38 51 80 00       	mov    %eax,0x805138
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf6:	a1 44 51 80 00       	mov    0x805144,%eax
  802bfb:	48                   	dec    %eax
  802bfc:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	e9 2a 01 00 00       	jmp    802d33 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c12:	73 14                	jae    802c28 <alloc_block_BF+0xd2>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1d:	76 09                	jbe    802c28 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802c30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c34:	0f 85 36 ff ff ff    	jne    802b70 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802c3a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802c42:	e9 dd 00 00 00       	jmp    802d24 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c50:	0f 85 c6 00 00 00    	jne    802d1c <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802c56:	a1 48 51 80 00       	mov    0x805148,%eax
  802c5b:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 50 08             	mov    0x8(%eax),%edx
  802c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c67:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c70:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 08             	mov    0x8(%eax),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	01 c2                	add    %eax,%edx
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8d:	89 c2                	mov    %eax,%edx
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c99:	75 17                	jne    802cb2 <alloc_block_BF+0x15c>
  802c9b:	83 ec 04             	sub    $0x4,%esp
  802c9e:	68 39 43 80 00       	push   $0x804339
  802ca3:	68 eb 00 00 00       	push   $0xeb
  802ca8:	68 c7 42 80 00       	push   $0x8042c7
  802cad:	e8 ce da ff ff       	call   800780 <_panic>
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 10                	je     802ccb <alloc_block_BF+0x175>
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc3:	8b 52 04             	mov    0x4(%edx),%edx
  802cc6:	89 50 04             	mov    %edx,0x4(%eax)
  802cc9:	eb 0b                	jmp    802cd6 <alloc_block_BF+0x180>
  802ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 0f                	je     802cef <alloc_block_BF+0x199>
  802ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce3:	8b 40 04             	mov    0x4(%eax),%eax
  802ce6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce9:	8b 12                	mov    (%edx),%edx
  802ceb:	89 10                	mov    %edx,(%eax)
  802ced:	eb 0a                	jmp    802cf9 <alloc_block_BF+0x1a3>
  802cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d11:	48                   	dec    %eax
  802d12:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1a:	eb 17                	jmp    802d33 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d28:	0f 85 19 ff ff ff    	jne    802c47 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802d2e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802d33:	c9                   	leave  
  802d34:	c3                   	ret    

00802d35 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802d35:	55                   	push   %ebp
  802d36:	89 e5                	mov    %esp,%ebp
  802d38:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802d3b:	a1 40 50 80 00       	mov    0x805040,%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	75 19                	jne    802d5d <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 08             	pushl  0x8(%ebp)
  802d4a:	e8 6f fc ff ff       	call   8029be <alloc_block_FF>
  802d4f:	83 c4 10             	add    $0x10,%esp
  802d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	e9 e9 01 00 00       	jmp    802f46 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802d5d:	a1 44 50 80 00       	mov    0x805044,%eax
  802d62:	8b 40 08             	mov    0x8(%eax),%eax
  802d65:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802d68:	a1 44 50 80 00       	mov    0x805044,%eax
  802d6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d70:	a1 44 50 80 00       	mov    0x805044,%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	83 ec 08             	sub    $0x8,%esp
  802d7d:	50                   	push   %eax
  802d7e:	68 38 51 80 00       	push   $0x805138
  802d83:	e8 54 fa ff ff       	call   8027dc <find_block>
  802d88:	83 c4 10             	add    $0x10,%esp
  802d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 0c             	mov    0xc(%eax),%eax
  802d94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d97:	0f 85 9b 00 00 00    	jne    802e38 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 50 0c             	mov    0xc(%eax),%edx
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 40 08             	mov    0x8(%eax),%eax
  802da9:	01 d0                	add    %edx,%eax
  802dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db2:	75 17                	jne    802dcb <alloc_block_NF+0x96>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 39 43 80 00       	push   $0x804339
  802dbc:	68 1a 01 00 00       	push   $0x11a
  802dc1:	68 c7 42 80 00       	push   $0x8042c7
  802dc6:	e8 b5 d9 ff ff       	call   800780 <_panic>
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	85 c0                	test   %eax,%eax
  802dd2:	74 10                	je     802de4 <alloc_block_NF+0xaf>
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddc:	8b 52 04             	mov    0x4(%edx),%edx
  802ddf:	89 50 04             	mov    %edx,0x4(%eax)
  802de2:	eb 0b                	jmp    802def <alloc_block_NF+0xba>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 40 04             	mov    0x4(%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 0f                	je     802e08 <alloc_block_NF+0xd3>
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 40 04             	mov    0x4(%eax),%eax
  802dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e02:	8b 12                	mov    (%edx),%edx
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	eb 0a                	jmp    802e12 <alloc_block_NF+0xdd>
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e25:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2a:	48                   	dec    %eax
  802e2b:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	e9 0e 01 00 00       	jmp    802f46 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e41:	0f 86 cf 00 00 00    	jbe    802f16 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802e47:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e52:	8b 55 08             	mov    0x8(%ebp),%edx
  802e55:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 50 08             	mov    0x8(%eax),%edx
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 50 08             	mov    0x8(%eax),%edx
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	01 c2                	add    %eax,%edx
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e7e:	89 c2                	mov    %eax,%edx
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 08             	mov    0x8(%eax),%eax
  802e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e93:	75 17                	jne    802eac <alloc_block_NF+0x177>
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 39 43 80 00       	push   $0x804339
  802e9d:	68 28 01 00 00       	push   $0x128
  802ea2:	68 c7 42 80 00       	push   $0x8042c7
  802ea7:	e8 d4 d8 ff ff       	call   800780 <_panic>
  802eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 10                	je     802ec5 <alloc_block_NF+0x190>
  802eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ebd:	8b 52 04             	mov    0x4(%edx),%edx
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	eb 0b                	jmp    802ed0 <alloc_block_NF+0x19b>
  802ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 0f                	je     802ee9 <alloc_block_NF+0x1b4>
  802eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee3:	8b 12                	mov    (%edx),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 0a                	jmp    802ef3 <alloc_block_NF+0x1be>
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f06:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0b:	48                   	dec    %eax
  802f0c:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f14:	eb 30                	jmp    802f46 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802f16:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f1b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f1e:	75 0a                	jne    802f2a <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802f20:	a1 38 51 80 00       	mov    0x805138,%eax
  802f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f28:	eb 08                	jmp    802f32 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 40 08             	mov    0x8(%eax),%eax
  802f38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f3b:	0f 85 4d fe ff ff    	jne    802d8e <alloc_block_NF+0x59>

			return NULL;
  802f41:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
  802f4b:	53                   	push   %ebx
  802f4c:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802f4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	0f 85 86 00 00 00    	jne    802fe2 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802f5c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802f63:	00 00 00 
  802f66:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802f6d:	00 00 00 
  802f70:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802f77:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7e:	75 17                	jne    802f97 <insert_sorted_with_merge_freeList+0x4f>
  802f80:	83 ec 04             	sub    $0x4,%esp
  802f83:	68 a4 42 80 00       	push   $0x8042a4
  802f88:	68 48 01 00 00       	push   $0x148
  802f8d:	68 c7 42 80 00       	push   $0x8042c7
  802f92:	e8 e9 d7 ff ff       	call   800780 <_panic>
  802f97:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	89 10                	mov    %edx,(%eax)
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0d                	je     802fb8 <insert_sorted_with_merge_freeList+0x70>
  802fab:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb3:	89 50 04             	mov    %edx,0x4(%eax)
  802fb6:	eb 08                	jmp    802fc0 <insert_sorted_with_merge_freeList+0x78>
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	a3 38 51 80 00       	mov    %eax,0x805138
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd7:	40                   	inc    %eax
  802fd8:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802fdd:	e9 73 07 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 50 08             	mov    0x8(%eax),%edx
  802fe8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fed:	8b 40 08             	mov    0x8(%eax),%eax
  802ff0:	39 c2                	cmp    %eax,%edx
  802ff2:	0f 86 84 00 00 00    	jbe    80307c <insert_sorted_with_merge_freeList+0x134>
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	8b 50 08             	mov    0x8(%eax),%edx
  802ffe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803003:	8b 48 0c             	mov    0xc(%eax),%ecx
  803006:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80300b:	8b 40 08             	mov    0x8(%eax),%eax
  80300e:	01 c8                	add    %ecx,%eax
  803010:	39 c2                	cmp    %eax,%edx
  803012:	74 68                	je     80307c <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803014:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803018:	75 17                	jne    803031 <insert_sorted_with_merge_freeList+0xe9>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 e0 42 80 00       	push   $0x8042e0
  803022:	68 4c 01 00 00       	push   $0x14c
  803027:	68 c7 42 80 00       	push   $0x8042c7
  80302c:	e8 4f d7 ff ff       	call   800780 <_panic>
  803031:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	8b 40 04             	mov    0x4(%eax),%eax
  803043:	85 c0                	test   %eax,%eax
  803045:	74 0c                	je     803053 <insert_sorted_with_merge_freeList+0x10b>
  803047:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304c:	8b 55 08             	mov    0x8(%ebp),%edx
  80304f:	89 10                	mov    %edx,(%eax)
  803051:	eb 08                	jmp    80305b <insert_sorted_with_merge_freeList+0x113>
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	a3 38 51 80 00       	mov    %eax,0x805138
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306c:	a1 44 51 80 00       	mov    0x805144,%eax
  803071:	40                   	inc    %eax
  803072:	a3 44 51 80 00       	mov    %eax,0x805144
  803077:	e9 d9 06 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 50 08             	mov    0x8(%eax),%edx
  803082:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	39 c2                	cmp    %eax,%edx
  80308c:	0f 86 b5 00 00 00    	jbe    803147 <insert_sorted_with_merge_freeList+0x1ff>
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 50 08             	mov    0x8(%eax),%edx
  803098:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80309d:	8b 48 0c             	mov    0xc(%eax),%ecx
  8030a0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a5:	8b 40 08             	mov    0x8(%eax),%eax
  8030a8:	01 c8                	add    %ecx,%eax
  8030aa:	39 c2                	cmp    %eax,%edx
  8030ac:	0f 85 95 00 00 00    	jne    803147 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8030b2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030b7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030bd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c3:	8b 52 0c             	mov    0xc(%edx),%edx
  8030c6:	01 ca                	add    %ecx,%edx
  8030c8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e3:	75 17                	jne    8030fc <insert_sorted_with_merge_freeList+0x1b4>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 a4 42 80 00       	push   $0x8042a4
  8030ed:	68 54 01 00 00       	push   $0x154
  8030f2:	68 c7 42 80 00       	push   $0x8042c7
  8030f7:	e8 84 d6 ff ff       	call   800780 <_panic>
  8030fc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	89 10                	mov    %edx,(%eax)
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 0d                	je     80311d <insert_sorted_with_merge_freeList+0x1d5>
  803110:	a1 48 51 80 00       	mov    0x805148,%eax
  803115:	8b 55 08             	mov    0x8(%ebp),%edx
  803118:	89 50 04             	mov    %edx,0x4(%eax)
  80311b:	eb 08                	jmp    803125 <insert_sorted_with_merge_freeList+0x1dd>
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	a3 48 51 80 00       	mov    %eax,0x805148
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803137:	a1 54 51 80 00       	mov    0x805154,%eax
  80313c:	40                   	inc    %eax
  80313d:	a3 54 51 80 00       	mov    %eax,0x805154
  803142:	e9 0e 06 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 50 08             	mov    0x8(%eax),%edx
  80314d:	a1 38 51 80 00       	mov    0x805138,%eax
  803152:	8b 40 08             	mov    0x8(%eax),%eax
  803155:	39 c2                	cmp    %eax,%edx
  803157:	0f 83 c1 00 00 00    	jae    80321e <insert_sorted_with_merge_freeList+0x2d6>
  80315d:	a1 38 51 80 00       	mov    0x805138,%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 48 08             	mov    0x8(%eax),%ecx
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	8b 40 0c             	mov    0xc(%eax),%eax
  803171:	01 c8                	add    %ecx,%eax
  803173:	39 c2                	cmp    %eax,%edx
  803175:	0f 85 a3 00 00 00    	jne    80321e <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80317b:	a1 38 51 80 00       	mov    0x805138,%eax
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	8b 52 08             	mov    0x8(%edx),%edx
  803186:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  803189:	a1 38 51 80 00       	mov    0x805138,%eax
  80318e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803194:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803197:	8b 55 08             	mov    0x8(%ebp),%edx
  80319a:	8b 52 0c             	mov    0xc(%edx),%edx
  80319d:	01 ca                	add    %ecx,%edx
  80319f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ba:	75 17                	jne    8031d3 <insert_sorted_with_merge_freeList+0x28b>
  8031bc:	83 ec 04             	sub    $0x4,%esp
  8031bf:	68 a4 42 80 00       	push   $0x8042a4
  8031c4:	68 5d 01 00 00       	push   $0x15d
  8031c9:	68 c7 42 80 00       	push   $0x8042c7
  8031ce:	e8 ad d5 ff ff       	call   800780 <_panic>
  8031d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	89 10                	mov    %edx,(%eax)
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 0d                	je     8031f4 <insert_sorted_with_merge_freeList+0x2ac>
  8031e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ef:	89 50 04             	mov    %edx,0x4(%eax)
  8031f2:	eb 08                	jmp    8031fc <insert_sorted_with_merge_freeList+0x2b4>
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320e:	a1 54 51 80 00       	mov    0x805154,%eax
  803213:	40                   	inc    %eax
  803214:	a3 54 51 80 00       	mov    %eax,0x805154
  803219:	e9 37 05 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 50 08             	mov    0x8(%eax),%edx
  803224:	a1 38 51 80 00       	mov    0x805138,%eax
  803229:	8b 40 08             	mov    0x8(%eax),%eax
  80322c:	39 c2                	cmp    %eax,%edx
  80322e:	0f 83 82 00 00 00    	jae    8032b6 <insert_sorted_with_merge_freeList+0x36e>
  803234:	a1 38 51 80 00       	mov    0x805138,%eax
  803239:	8b 50 08             	mov    0x8(%eax),%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	8b 48 08             	mov    0x8(%eax),%ecx
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 40 0c             	mov    0xc(%eax),%eax
  803248:	01 c8                	add    %ecx,%eax
  80324a:	39 c2                	cmp    %eax,%edx
  80324c:	74 68                	je     8032b6 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80324e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803252:	75 17                	jne    80326b <insert_sorted_with_merge_freeList+0x323>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 a4 42 80 00       	push   $0x8042a4
  80325c:	68 62 01 00 00       	push   $0x162
  803261:	68 c7 42 80 00       	push   $0x8042c7
  803266:	e8 15 d5 ff ff       	call   800780 <_panic>
  80326b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	89 10                	mov    %edx,(%eax)
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 0d                	je     80328c <insert_sorted_with_merge_freeList+0x344>
  80327f:	a1 38 51 80 00       	mov    0x805138,%eax
  803284:	8b 55 08             	mov    0x8(%ebp),%edx
  803287:	89 50 04             	mov    %edx,0x4(%eax)
  80328a:	eb 08                	jmp    803294 <insert_sorted_with_merge_freeList+0x34c>
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	a3 38 51 80 00       	mov    %eax,0x805138
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ab:	40                   	inc    %eax
  8032ac:	a3 44 51 80 00       	mov    %eax,0x805144
  8032b1:	e9 9f 04 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8032b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8032c0:	e9 84 04 00 00       	jmp    803749 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 50 08             	mov    0x8(%eax),%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 40 08             	mov    0x8(%eax),%eax
  8032d1:	39 c2                	cmp    %eax,%edx
  8032d3:	0f 86 a9 00 00 00    	jbe    803382 <insert_sorted_with_merge_freeList+0x43a>
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 50 08             	mov    0x8(%eax),%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 48 08             	mov    0x8(%eax),%ecx
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032eb:	01 c8                	add    %ecx,%eax
  8032ed:	39 c2                	cmp    %eax,%edx
  8032ef:	0f 84 8d 00 00 00    	je     803382 <insert_sorted_with_merge_freeList+0x43a>
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	8b 50 08             	mov    0x8(%eax),%edx
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	8b 48 08             	mov    0x8(%eax),%ecx
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	8b 40 04             	mov    0x4(%eax),%eax
  80330a:	8b 40 0c             	mov    0xc(%eax),%eax
  80330d:	01 c8                	add    %ecx,%eax
  80330f:	39 c2                	cmp    %eax,%edx
  803311:	74 6f                	je     803382 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803317:	74 06                	je     80331f <insert_sorted_with_merge_freeList+0x3d7>
  803319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331d:	75 17                	jne    803336 <insert_sorted_with_merge_freeList+0x3ee>
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	68 04 43 80 00       	push   $0x804304
  803327:	68 6b 01 00 00       	push   $0x16b
  80332c:	68 c7 42 80 00       	push   $0x8042c7
  803331:	e8 4a d4 ff ff       	call   800780 <_panic>
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 50 04             	mov    0x4(%eax),%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	89 50 04             	mov    %edx,0x4(%eax)
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803348:	89 10                	mov    %edx,(%eax)
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0d                	je     803361 <insert_sorted_with_merge_freeList+0x419>
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	8b 55 08             	mov    0x8(%ebp),%edx
  80335d:	89 10                	mov    %edx,(%eax)
  80335f:	eb 08                	jmp    803369 <insert_sorted_with_merge_freeList+0x421>
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	a3 38 51 80 00       	mov    %eax,0x805138
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 55 08             	mov    0x8(%ebp),%edx
  80336f:	89 50 04             	mov    %edx,0x4(%eax)
  803372:	a1 44 51 80 00       	mov    0x805144,%eax
  803377:	40                   	inc    %eax
  803378:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80337d:	e9 d3 03 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 50 08             	mov    0x8(%eax),%edx
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	8b 40 08             	mov    0x8(%eax),%eax
  80338e:	39 c2                	cmp    %eax,%edx
  803390:	0f 86 da 00 00 00    	jbe    803470 <insert_sorted_with_merge_freeList+0x528>
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	8b 50 08             	mov    0x8(%eax),%edx
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 48 08             	mov    0x8(%eax),%ecx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a8:	01 c8                	add    %ecx,%eax
  8033aa:	39 c2                	cmp    %eax,%edx
  8033ac:	0f 85 be 00 00 00    	jne    803470 <insert_sorted_with_merge_freeList+0x528>
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 50 08             	mov    0x8(%eax),%edx
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	8b 48 08             	mov    0x8(%eax),%ecx
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 40 04             	mov    0x4(%eax),%eax
  8033c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ca:	01 c8                	add    %ecx,%eax
  8033cc:	39 c2                	cmp    %eax,%edx
  8033ce:	0f 84 9c 00 00 00    	je     803470 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	8b 50 08             	mov    0x8(%eax),%edx
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8033e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ec:	01 c2                	add    %eax,%edx
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340c:	75 17                	jne    803425 <insert_sorted_with_merge_freeList+0x4dd>
  80340e:	83 ec 04             	sub    $0x4,%esp
  803411:	68 a4 42 80 00       	push   $0x8042a4
  803416:	68 74 01 00 00       	push   $0x174
  80341b:	68 c7 42 80 00       	push   $0x8042c7
  803420:	e8 5b d3 ff ff       	call   800780 <_panic>
  803425:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	89 10                	mov    %edx,(%eax)
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	85 c0                	test   %eax,%eax
  803437:	74 0d                	je     803446 <insert_sorted_with_merge_freeList+0x4fe>
  803439:	a1 48 51 80 00       	mov    0x805148,%eax
  80343e:	8b 55 08             	mov    0x8(%ebp),%edx
  803441:	89 50 04             	mov    %edx,0x4(%eax)
  803444:	eb 08                	jmp    80344e <insert_sorted_with_merge_freeList+0x506>
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	a3 48 51 80 00       	mov    %eax,0x805148
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803460:	a1 54 51 80 00       	mov    0x805154,%eax
  803465:	40                   	inc    %eax
  803466:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80346b:	e9 e5 02 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	8b 50 08             	mov    0x8(%eax),%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 40 08             	mov    0x8(%eax),%eax
  80347c:	39 c2                	cmp    %eax,%edx
  80347e:	0f 86 d7 00 00 00    	jbe    80355b <insert_sorted_with_merge_freeList+0x613>
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	8b 50 08             	mov    0x8(%eax),%edx
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	8b 48 08             	mov    0x8(%eax),%ecx
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	8b 40 0c             	mov    0xc(%eax),%eax
  803496:	01 c8                	add    %ecx,%eax
  803498:	39 c2                	cmp    %eax,%edx
  80349a:	0f 84 bb 00 00 00    	je     80355b <insert_sorted_with_merge_freeList+0x613>
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	8b 50 08             	mov    0x8(%eax),%edx
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ac:	8b 48 08             	mov    0x8(%eax),%ecx
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b8:	01 c8                	add    %ecx,%eax
  8034ba:	39 c2                	cmp    %eax,%edx
  8034bc:	0f 85 99 00 00 00    	jne    80355b <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	8b 40 04             	mov    0x4(%eax),%eax
  8034c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d7:	01 c2                	add    %eax,%edx
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f7:	75 17                	jne    803510 <insert_sorted_with_merge_freeList+0x5c8>
  8034f9:	83 ec 04             	sub    $0x4,%esp
  8034fc:	68 a4 42 80 00       	push   $0x8042a4
  803501:	68 7d 01 00 00       	push   $0x17d
  803506:	68 c7 42 80 00       	push   $0x8042c7
  80350b:	e8 70 d2 ff ff       	call   800780 <_panic>
  803510:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803516:	8b 45 08             	mov    0x8(%ebp),%eax
  803519:	89 10                	mov    %edx,(%eax)
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	85 c0                	test   %eax,%eax
  803522:	74 0d                	je     803531 <insert_sorted_with_merge_freeList+0x5e9>
  803524:	a1 48 51 80 00       	mov    0x805148,%eax
  803529:	8b 55 08             	mov    0x8(%ebp),%edx
  80352c:	89 50 04             	mov    %edx,0x4(%eax)
  80352f:	eb 08                	jmp    803539 <insert_sorted_with_merge_freeList+0x5f1>
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	a3 48 51 80 00       	mov    %eax,0x805148
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354b:	a1 54 51 80 00       	mov    0x805154,%eax
  803550:	40                   	inc    %eax
  803551:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803556:	e9 fa 01 00 00       	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	8b 50 08             	mov    0x8(%eax),%edx
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	8b 40 08             	mov    0x8(%eax),%eax
  803567:	39 c2                	cmp    %eax,%edx
  803569:	0f 86 d2 01 00 00    	jbe    803741 <insert_sorted_with_merge_freeList+0x7f9>
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 50 08             	mov    0x8(%eax),%edx
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	8b 48 08             	mov    0x8(%eax),%ecx
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	8b 40 0c             	mov    0xc(%eax),%eax
  803581:	01 c8                	add    %ecx,%eax
  803583:	39 c2                	cmp    %eax,%edx
  803585:	0f 85 b6 01 00 00    	jne    803741 <insert_sorted_with_merge_freeList+0x7f9>
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 50 08             	mov    0x8(%eax),%edx
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	8b 40 04             	mov    0x4(%eax),%eax
  803597:	8b 48 08             	mov    0x8(%eax),%ecx
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 40 04             	mov    0x4(%eax),%eax
  8035a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a3:	01 c8                	add    %ecx,%eax
  8035a5:	39 c2                	cmp    %eax,%edx
  8035a7:	0f 85 94 01 00 00    	jne    803741 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8035ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b0:	8b 40 04             	mov    0x4(%eax),%eax
  8035b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b6:	8b 52 04             	mov    0x4(%edx),%edx
  8035b9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8035bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8035bf:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8035c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8035c8:	01 da                	add    %ebx,%edx
  8035ca:	01 ca                	add    %ecx,%edx
  8035cc:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8035d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8035e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e7:	75 17                	jne    803600 <insert_sorted_with_merge_freeList+0x6b8>
  8035e9:	83 ec 04             	sub    $0x4,%esp
  8035ec:	68 39 43 80 00       	push   $0x804339
  8035f1:	68 86 01 00 00       	push   $0x186
  8035f6:	68 c7 42 80 00       	push   $0x8042c7
  8035fb:	e8 80 d1 ff ff       	call   800780 <_panic>
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	74 10                	je     803619 <insert_sorted_with_merge_freeList+0x6d1>
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803611:	8b 52 04             	mov    0x4(%edx),%edx
  803614:	89 50 04             	mov    %edx,0x4(%eax)
  803617:	eb 0b                	jmp    803624 <insert_sorted_with_merge_freeList+0x6dc>
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	8b 40 04             	mov    0x4(%eax),%eax
  80361f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 40 04             	mov    0x4(%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	74 0f                	je     80363d <insert_sorted_with_merge_freeList+0x6f5>
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	8b 40 04             	mov    0x4(%eax),%eax
  803634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803637:	8b 12                	mov    (%edx),%edx
  803639:	89 10                	mov    %edx,(%eax)
  80363b:	eb 0a                	jmp    803647 <insert_sorted_with_merge_freeList+0x6ff>
  80363d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	a3 38 51 80 00       	mov    %eax,0x805138
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365a:	a1 44 51 80 00       	mov    0x805144,%eax
  80365f:	48                   	dec    %eax
  803660:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803669:	75 17                	jne    803682 <insert_sorted_with_merge_freeList+0x73a>
  80366b:	83 ec 04             	sub    $0x4,%esp
  80366e:	68 a4 42 80 00       	push   $0x8042a4
  803673:	68 87 01 00 00       	push   $0x187
  803678:	68 c7 42 80 00       	push   $0x8042c7
  80367d:	e8 fe d0 ff ff       	call   800780 <_panic>
  803682:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368b:	89 10                	mov    %edx,(%eax)
  80368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	74 0d                	je     8036a3 <insert_sorted_with_merge_freeList+0x75b>
  803696:	a1 48 51 80 00       	mov    0x805148,%eax
  80369b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80369e:	89 50 04             	mov    %edx,0x4(%eax)
  8036a1:	eb 08                	jmp    8036ab <insert_sorted_with_merge_freeList+0x763>
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c2:	40                   	inc    %eax
  8036c3:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e0:	75 17                	jne    8036f9 <insert_sorted_with_merge_freeList+0x7b1>
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	68 a4 42 80 00       	push   $0x8042a4
  8036ea:	68 8a 01 00 00       	push   $0x18a
  8036ef:	68 c7 42 80 00       	push   $0x8042c7
  8036f4:	e8 87 d0 ff ff       	call   800780 <_panic>
  8036f9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	89 10                	mov    %edx,(%eax)
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	8b 00                	mov    (%eax),%eax
  803709:	85 c0                	test   %eax,%eax
  80370b:	74 0d                	je     80371a <insert_sorted_with_merge_freeList+0x7d2>
  80370d:	a1 48 51 80 00       	mov    0x805148,%eax
  803712:	8b 55 08             	mov    0x8(%ebp),%edx
  803715:	89 50 04             	mov    %edx,0x4(%eax)
  803718:	eb 08                	jmp    803722 <insert_sorted_with_merge_freeList+0x7da>
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	a3 48 51 80 00       	mov    %eax,0x805148
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803734:	a1 54 51 80 00       	mov    0x805154,%eax
  803739:	40                   	inc    %eax
  80373a:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  80373f:	eb 14                	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374d:	0f 85 72 fb ff ff    	jne    8032c5 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803753:	eb 00                	jmp    803755 <insert_sorted_with_merge_freeList+0x80d>
  803755:	90                   	nop
  803756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803759:	c9                   	leave  
  80375a:	c3                   	ret    
  80375b:	90                   	nop

0080375c <__udivdi3>:
  80375c:	55                   	push   %ebp
  80375d:	57                   	push   %edi
  80375e:	56                   	push   %esi
  80375f:	53                   	push   %ebx
  803760:	83 ec 1c             	sub    $0x1c,%esp
  803763:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803767:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80376b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80376f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803773:	89 ca                	mov    %ecx,%edx
  803775:	89 f8                	mov    %edi,%eax
  803777:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80377b:	85 f6                	test   %esi,%esi
  80377d:	75 2d                	jne    8037ac <__udivdi3+0x50>
  80377f:	39 cf                	cmp    %ecx,%edi
  803781:	77 65                	ja     8037e8 <__udivdi3+0x8c>
  803783:	89 fd                	mov    %edi,%ebp
  803785:	85 ff                	test   %edi,%edi
  803787:	75 0b                	jne    803794 <__udivdi3+0x38>
  803789:	b8 01 00 00 00       	mov    $0x1,%eax
  80378e:	31 d2                	xor    %edx,%edx
  803790:	f7 f7                	div    %edi
  803792:	89 c5                	mov    %eax,%ebp
  803794:	31 d2                	xor    %edx,%edx
  803796:	89 c8                	mov    %ecx,%eax
  803798:	f7 f5                	div    %ebp
  80379a:	89 c1                	mov    %eax,%ecx
  80379c:	89 d8                	mov    %ebx,%eax
  80379e:	f7 f5                	div    %ebp
  8037a0:	89 cf                	mov    %ecx,%edi
  8037a2:	89 fa                	mov    %edi,%edx
  8037a4:	83 c4 1c             	add    $0x1c,%esp
  8037a7:	5b                   	pop    %ebx
  8037a8:	5e                   	pop    %esi
  8037a9:	5f                   	pop    %edi
  8037aa:	5d                   	pop    %ebp
  8037ab:	c3                   	ret    
  8037ac:	39 ce                	cmp    %ecx,%esi
  8037ae:	77 28                	ja     8037d8 <__udivdi3+0x7c>
  8037b0:	0f bd fe             	bsr    %esi,%edi
  8037b3:	83 f7 1f             	xor    $0x1f,%edi
  8037b6:	75 40                	jne    8037f8 <__udivdi3+0x9c>
  8037b8:	39 ce                	cmp    %ecx,%esi
  8037ba:	72 0a                	jb     8037c6 <__udivdi3+0x6a>
  8037bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037c0:	0f 87 9e 00 00 00    	ja     803864 <__udivdi3+0x108>
  8037c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037cb:	89 fa                	mov    %edi,%edx
  8037cd:	83 c4 1c             	add    $0x1c,%esp
  8037d0:	5b                   	pop    %ebx
  8037d1:	5e                   	pop    %esi
  8037d2:	5f                   	pop    %edi
  8037d3:	5d                   	pop    %ebp
  8037d4:	c3                   	ret    
  8037d5:	8d 76 00             	lea    0x0(%esi),%esi
  8037d8:	31 ff                	xor    %edi,%edi
  8037da:	31 c0                	xor    %eax,%eax
  8037dc:	89 fa                	mov    %edi,%edx
  8037de:	83 c4 1c             	add    $0x1c,%esp
  8037e1:	5b                   	pop    %ebx
  8037e2:	5e                   	pop    %esi
  8037e3:	5f                   	pop    %edi
  8037e4:	5d                   	pop    %ebp
  8037e5:	c3                   	ret    
  8037e6:	66 90                	xchg   %ax,%ax
  8037e8:	89 d8                	mov    %ebx,%eax
  8037ea:	f7 f7                	div    %edi
  8037ec:	31 ff                	xor    %edi,%edi
  8037ee:	89 fa                	mov    %edi,%edx
  8037f0:	83 c4 1c             	add    $0x1c,%esp
  8037f3:	5b                   	pop    %ebx
  8037f4:	5e                   	pop    %esi
  8037f5:	5f                   	pop    %edi
  8037f6:	5d                   	pop    %ebp
  8037f7:	c3                   	ret    
  8037f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037fd:	89 eb                	mov    %ebp,%ebx
  8037ff:	29 fb                	sub    %edi,%ebx
  803801:	89 f9                	mov    %edi,%ecx
  803803:	d3 e6                	shl    %cl,%esi
  803805:	89 c5                	mov    %eax,%ebp
  803807:	88 d9                	mov    %bl,%cl
  803809:	d3 ed                	shr    %cl,%ebp
  80380b:	89 e9                	mov    %ebp,%ecx
  80380d:	09 f1                	or     %esi,%ecx
  80380f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803813:	89 f9                	mov    %edi,%ecx
  803815:	d3 e0                	shl    %cl,%eax
  803817:	89 c5                	mov    %eax,%ebp
  803819:	89 d6                	mov    %edx,%esi
  80381b:	88 d9                	mov    %bl,%cl
  80381d:	d3 ee                	shr    %cl,%esi
  80381f:	89 f9                	mov    %edi,%ecx
  803821:	d3 e2                	shl    %cl,%edx
  803823:	8b 44 24 08          	mov    0x8(%esp),%eax
  803827:	88 d9                	mov    %bl,%cl
  803829:	d3 e8                	shr    %cl,%eax
  80382b:	09 c2                	or     %eax,%edx
  80382d:	89 d0                	mov    %edx,%eax
  80382f:	89 f2                	mov    %esi,%edx
  803831:	f7 74 24 0c          	divl   0xc(%esp)
  803835:	89 d6                	mov    %edx,%esi
  803837:	89 c3                	mov    %eax,%ebx
  803839:	f7 e5                	mul    %ebp
  80383b:	39 d6                	cmp    %edx,%esi
  80383d:	72 19                	jb     803858 <__udivdi3+0xfc>
  80383f:	74 0b                	je     80384c <__udivdi3+0xf0>
  803841:	89 d8                	mov    %ebx,%eax
  803843:	31 ff                	xor    %edi,%edi
  803845:	e9 58 ff ff ff       	jmp    8037a2 <__udivdi3+0x46>
  80384a:	66 90                	xchg   %ax,%ax
  80384c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803850:	89 f9                	mov    %edi,%ecx
  803852:	d3 e2                	shl    %cl,%edx
  803854:	39 c2                	cmp    %eax,%edx
  803856:	73 e9                	jae    803841 <__udivdi3+0xe5>
  803858:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80385b:	31 ff                	xor    %edi,%edi
  80385d:	e9 40 ff ff ff       	jmp    8037a2 <__udivdi3+0x46>
  803862:	66 90                	xchg   %ax,%ax
  803864:	31 c0                	xor    %eax,%eax
  803866:	e9 37 ff ff ff       	jmp    8037a2 <__udivdi3+0x46>
  80386b:	90                   	nop

0080386c <__umoddi3>:
  80386c:	55                   	push   %ebp
  80386d:	57                   	push   %edi
  80386e:	56                   	push   %esi
  80386f:	53                   	push   %ebx
  803870:	83 ec 1c             	sub    $0x1c,%esp
  803873:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803877:	8b 74 24 34          	mov    0x34(%esp),%esi
  80387b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80387f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803887:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80388b:	89 f3                	mov    %esi,%ebx
  80388d:	89 fa                	mov    %edi,%edx
  80388f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803893:	89 34 24             	mov    %esi,(%esp)
  803896:	85 c0                	test   %eax,%eax
  803898:	75 1a                	jne    8038b4 <__umoddi3+0x48>
  80389a:	39 f7                	cmp    %esi,%edi
  80389c:	0f 86 a2 00 00 00    	jbe    803944 <__umoddi3+0xd8>
  8038a2:	89 c8                	mov    %ecx,%eax
  8038a4:	89 f2                	mov    %esi,%edx
  8038a6:	f7 f7                	div    %edi
  8038a8:	89 d0                	mov    %edx,%eax
  8038aa:	31 d2                	xor    %edx,%edx
  8038ac:	83 c4 1c             	add    $0x1c,%esp
  8038af:	5b                   	pop    %ebx
  8038b0:	5e                   	pop    %esi
  8038b1:	5f                   	pop    %edi
  8038b2:	5d                   	pop    %ebp
  8038b3:	c3                   	ret    
  8038b4:	39 f0                	cmp    %esi,%eax
  8038b6:	0f 87 ac 00 00 00    	ja     803968 <__umoddi3+0xfc>
  8038bc:	0f bd e8             	bsr    %eax,%ebp
  8038bf:	83 f5 1f             	xor    $0x1f,%ebp
  8038c2:	0f 84 ac 00 00 00    	je     803974 <__umoddi3+0x108>
  8038c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038cd:	29 ef                	sub    %ebp,%edi
  8038cf:	89 fe                	mov    %edi,%esi
  8038d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038d5:	89 e9                	mov    %ebp,%ecx
  8038d7:	d3 e0                	shl    %cl,%eax
  8038d9:	89 d7                	mov    %edx,%edi
  8038db:	89 f1                	mov    %esi,%ecx
  8038dd:	d3 ef                	shr    %cl,%edi
  8038df:	09 c7                	or     %eax,%edi
  8038e1:	89 e9                	mov    %ebp,%ecx
  8038e3:	d3 e2                	shl    %cl,%edx
  8038e5:	89 14 24             	mov    %edx,(%esp)
  8038e8:	89 d8                	mov    %ebx,%eax
  8038ea:	d3 e0                	shl    %cl,%eax
  8038ec:	89 c2                	mov    %eax,%edx
  8038ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f2:	d3 e0                	shl    %cl,%eax
  8038f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038fc:	89 f1                	mov    %esi,%ecx
  8038fe:	d3 e8                	shr    %cl,%eax
  803900:	09 d0                	or     %edx,%eax
  803902:	d3 eb                	shr    %cl,%ebx
  803904:	89 da                	mov    %ebx,%edx
  803906:	f7 f7                	div    %edi
  803908:	89 d3                	mov    %edx,%ebx
  80390a:	f7 24 24             	mull   (%esp)
  80390d:	89 c6                	mov    %eax,%esi
  80390f:	89 d1                	mov    %edx,%ecx
  803911:	39 d3                	cmp    %edx,%ebx
  803913:	0f 82 87 00 00 00    	jb     8039a0 <__umoddi3+0x134>
  803919:	0f 84 91 00 00 00    	je     8039b0 <__umoddi3+0x144>
  80391f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803923:	29 f2                	sub    %esi,%edx
  803925:	19 cb                	sbb    %ecx,%ebx
  803927:	89 d8                	mov    %ebx,%eax
  803929:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80392d:	d3 e0                	shl    %cl,%eax
  80392f:	89 e9                	mov    %ebp,%ecx
  803931:	d3 ea                	shr    %cl,%edx
  803933:	09 d0                	or     %edx,%eax
  803935:	89 e9                	mov    %ebp,%ecx
  803937:	d3 eb                	shr    %cl,%ebx
  803939:	89 da                	mov    %ebx,%edx
  80393b:	83 c4 1c             	add    $0x1c,%esp
  80393e:	5b                   	pop    %ebx
  80393f:	5e                   	pop    %esi
  803940:	5f                   	pop    %edi
  803941:	5d                   	pop    %ebp
  803942:	c3                   	ret    
  803943:	90                   	nop
  803944:	89 fd                	mov    %edi,%ebp
  803946:	85 ff                	test   %edi,%edi
  803948:	75 0b                	jne    803955 <__umoddi3+0xe9>
  80394a:	b8 01 00 00 00       	mov    $0x1,%eax
  80394f:	31 d2                	xor    %edx,%edx
  803951:	f7 f7                	div    %edi
  803953:	89 c5                	mov    %eax,%ebp
  803955:	89 f0                	mov    %esi,%eax
  803957:	31 d2                	xor    %edx,%edx
  803959:	f7 f5                	div    %ebp
  80395b:	89 c8                	mov    %ecx,%eax
  80395d:	f7 f5                	div    %ebp
  80395f:	89 d0                	mov    %edx,%eax
  803961:	e9 44 ff ff ff       	jmp    8038aa <__umoddi3+0x3e>
  803966:	66 90                	xchg   %ax,%ax
  803968:	89 c8                	mov    %ecx,%eax
  80396a:	89 f2                	mov    %esi,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	3b 04 24             	cmp    (%esp),%eax
  803977:	72 06                	jb     80397f <__umoddi3+0x113>
  803979:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80397d:	77 0f                	ja     80398e <__umoddi3+0x122>
  80397f:	89 f2                	mov    %esi,%edx
  803981:	29 f9                	sub    %edi,%ecx
  803983:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803987:	89 14 24             	mov    %edx,(%esp)
  80398a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80398e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803992:	8b 14 24             	mov    (%esp),%edx
  803995:	83 c4 1c             	add    $0x1c,%esp
  803998:	5b                   	pop    %ebx
  803999:	5e                   	pop    %esi
  80399a:	5f                   	pop    %edi
  80399b:	5d                   	pop    %ebp
  80399c:	c3                   	ret    
  80399d:	8d 76 00             	lea    0x0(%esi),%esi
  8039a0:	2b 04 24             	sub    (%esp),%eax
  8039a3:	19 fa                	sbb    %edi,%edx
  8039a5:	89 d1                	mov    %edx,%ecx
  8039a7:	89 c6                	mov    %eax,%esi
  8039a9:	e9 71 ff ff ff       	jmp    80391f <__umoddi3+0xb3>
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039b4:	72 ea                	jb     8039a0 <__umoddi3+0x134>
  8039b6:	89 d9                	mov    %ebx,%ecx
  8039b8:	e9 62 ff ff ff       	jmp    80391f <__umoddi3+0xb3>
