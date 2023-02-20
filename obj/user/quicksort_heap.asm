
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
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
  800041:	e8 a6 20 00 00       	call   8020ec <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 39 80 00       	push   $0x8039e0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 39 80 00       	push   $0x8039e2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 39 80 00       	push   $0x8039fb
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 39 80 00       	push   $0x8039e2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 39 80 00       	push   $0x8039e0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 3a 80 00       	push   $0x803a14
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 c6 1a 00 00       	call   801b9b <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 34 3a 80 00       	push   $0x803a34
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 56 3a 80 00       	push   $0x803a56
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 64 3a 80 00       	push   $0x803a64
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 73 3a 80 00       	push   $0x803a73
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 83 3a 80 00       	push   $0x803a83
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 9f 1f 00 00       	call   802106 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
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
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 12 1f 00 00       	call   8020ec <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 3a 80 00       	push   $0x803a8c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 17 1f 00 00       	call   802106 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 c0 3a 80 00       	push   $0x803ac0
  800211:	6a 48                	push   $0x48
  800213:	68 e2 3a 80 00       	push   $0x803ae2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 ca 1e 00 00       	call   8020ec <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 f8 3a 80 00       	push   $0x803af8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 2c 3b 80 00       	push   $0x803b2c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 60 3b 80 00       	push   $0x803b60
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 af 1e 00 00       	call   802106 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 90 1e 00 00       	call   8020ec <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 92 3b 80 00       	push   $0x803b92
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 51 1e 00 00       	call   802106 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 e0 39 80 00       	push   $0x8039e0
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 b0 3b 80 00       	push   $0x803bb0
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 b5 3b 80 00       	push   $0x803bb5
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 52 1b 00 00       	call   802120 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 0d 1b 00 00       	call   8020ec <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 2e 1b 00 00       	call   802120 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 0c 1b 00 00       	call   802106 <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 56 19 00 00       	call   801f67 <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 c2 1a 00 00       	call   8020ec <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 2f 19 00 00       	call   801f67 <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 c0 1a 00 00       	call   802106 <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 7f 1c 00 00       	call   8022df <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 21 1a 00 00       	call   8020ec <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 d4 3b 80 00       	push   $0x803bd4
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 fc 3b 80 00       	push   $0x803bfc
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 24 3c 80 00       	push   $0x803c24
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 7c 3c 80 00       	push   $0x803c7c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 d4 3b 80 00       	push   $0x803bd4
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 a1 19 00 00       	call   802106 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 2e 1b 00 00       	call   8022ab <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 83 1b 00 00       	call   802311 <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 90 3c 80 00       	push   $0x803c90
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 95 3c 80 00       	push   $0x803c95
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 b1 3c 80 00       	push   $0x803cb1
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 b4 3c 80 00       	push   $0x803cb4
  800820:	6a 26                	push   $0x26
  800822:	68 00 3d 80 00       	push   $0x803d00
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 0c 3d 80 00       	push   $0x803d0c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 00 3d 80 00       	push   $0x803d00
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 60 3d 80 00       	push   $0x803d60
  800962:	6a 44                	push   $0x44
  800964:	68 00 3d 80 00       	push   $0x803d00
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 82 15 00 00       	call   801f3e <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 0b 15 00 00       	call   801f3e <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 6f 16 00 00       	call   8020ec <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 69 16 00 00       	call   802106 <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 85 2c 00 00       	call   80376c <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 45 2d 00 00       	call   80387c <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 d4 3f 80 00       	add    $0x803fd4,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 e5 3f 80 00       	push   $0x803fe5
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 ee 3f 80 00       	push   $0x803fee
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be f1 3f 80 00       	mov    $0x803ff1,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 50 41 80 00       	push   $0x804150
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 53 41 80 00       	push   $0x804153
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 1c 0f 00 00       	call   8020ec <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 50 41 80 00       	push   $0x804150
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 53 41 80 00       	push   $0x804153
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 da 0e 00 00       	call   802106 <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 42 0e 00 00       	call   802106 <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 64 41 80 00       	push   $0x804164
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801a0c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a13:	00 00 00 
  801a16:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a1d:	00 00 00 
  801a20:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a27:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801a2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a31:	00 00 00 
  801a34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a3b:	00 00 00 
  801a3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a45:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801a48:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a4f:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801a52:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801a59:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a6d:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801a72:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a81:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	6a 06                	push   $0x6
  801a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	e8 ee 05 00 00       	call   802082 <sys_allocate_chunk>
  801a94:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a97:	a1 20 51 80 00       	mov    0x805120,%eax
  801a9c:	83 ec 0c             	sub    $0xc,%esp
  801a9f:	50                   	push   %eax
  801aa0:	e8 63 0c 00 00       	call   802708 <initialize_MemBlocksList>
  801aa5:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801aa8:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801aad:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801abd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801acb:	89 c2                	mov    %eax,%edx
  801acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad0:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801add:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae7:	8b 50 08             	mov    0x8(%eax),%edx
  801aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aed:	01 d0                	add    %edx,%eax
  801aef:	48                   	dec    %eax
  801af0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af6:	ba 00 00 00 00       	mov    $0x0,%edx
  801afb:	f7 75 e0             	divl   -0x20(%ebp)
  801afe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b01:	29 d0                	sub    %edx,%eax
  801b03:	89 c2                	mov    %eax,%edx
  801b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b08:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801b0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b0f:	75 14                	jne    801b25 <initialize_dyn_block_system+0x11f>
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	68 89 41 80 00       	push   $0x804189
  801b19:	6a 34                	push   $0x34
  801b1b:	68 a7 41 80 00       	push   $0x8041a7
  801b20:	e8 6c ec ff ff       	call   800791 <_panic>
  801b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b28:	8b 00                	mov    (%eax),%eax
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	74 10                	je     801b3e <initialize_dyn_block_system+0x138>
  801b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b31:	8b 00                	mov    (%eax),%eax
  801b33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b36:	8b 52 04             	mov    0x4(%edx),%edx
  801b39:	89 50 04             	mov    %edx,0x4(%eax)
  801b3c:	eb 0b                	jmp    801b49 <initialize_dyn_block_system+0x143>
  801b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b41:	8b 40 04             	mov    0x4(%eax),%eax
  801b44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4c:	8b 40 04             	mov    0x4(%eax),%eax
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	74 0f                	je     801b62 <initialize_dyn_block_system+0x15c>
  801b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b56:	8b 40 04             	mov    0x4(%eax),%eax
  801b59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b5c:	8b 12                	mov    (%edx),%edx
  801b5e:	89 10                	mov    %edx,(%eax)
  801b60:	eb 0a                	jmp    801b6c <initialize_dyn_block_system+0x166>
  801b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b65:	8b 00                	mov    (%eax),%eax
  801b67:	a3 48 51 80 00       	mov    %eax,0x805148
  801b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b7f:	a1 54 51 80 00       	mov    0x805154,%eax
  801b84:	48                   	dec    %eax
  801b85:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801b8a:	83 ec 0c             	sub    $0xc,%esp
  801b8d:	ff 75 e8             	pushl  -0x18(%ebp)
  801b90:	e8 c4 13 00 00       	call   802f59 <insert_sorted_with_merge_freeList>
  801b95:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b98:	90                   	nop
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <malloc>:
//=================================



void* malloc(uint32 size)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ba1:	e8 2f fe ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801baa:	75 07                	jne    801bb3 <malloc+0x18>
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	eb 71                	jmp    801c24 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801bb3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bba:	76 07                	jbe    801bc3 <malloc+0x28>
	return NULL;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc1:	eb 61                	jmp    801c24 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bc3:	e8 88 08 00 00       	call   802450 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	74 53                	je     801c1f <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801bcc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd9:	01 d0                	add    %edx,%eax
  801bdb:	48                   	dec    %eax
  801bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be2:	ba 00 00 00 00       	mov    $0x0,%edx
  801be7:	f7 75 f4             	divl   -0xc(%ebp)
  801bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bed:	29 d0                	sub    %edx,%eax
  801bef:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801bf2:	83 ec 0c             	sub    $0xc,%esp
  801bf5:	ff 75 ec             	pushl  -0x14(%ebp)
  801bf8:	e8 d2 0d 00 00       	call   8029cf <alloc_block_FF>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801c03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c07:	74 16                	je     801c1f <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff 75 e8             	pushl  -0x18(%ebp)
  801c0f:	e8 0c 0c 00 00       	call   802820 <insert_sorted_allocList>
  801c14:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c1a:	8b 40 08             	mov    0x8(%eax),%eax
  801c1d:	eb 05                	jmp    801c24 <malloc+0x89>
    }

			}


	return NULL;
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	ff 75 f0             	pushl  -0x10(%ebp)
  801c43:	68 40 50 80 00       	push   $0x805040
  801c48:	e8 a0 0b 00 00       	call   8027ed <find_block>
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c56:	8b 50 0c             	mov    0xc(%eax),%edx
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	e8 e4 03 00 00       	call   80204a <sys_free_user_mem>
  801c66:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801c69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c6d:	75 17                	jne    801c86 <free+0x60>
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	68 89 41 80 00       	push   $0x804189
  801c77:	68 84 00 00 00       	push   $0x84
  801c7c:	68 a7 41 80 00       	push   $0x8041a7
  801c81:	e8 0b eb ff ff       	call   800791 <_panic>
  801c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c89:	8b 00                	mov    (%eax),%eax
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	74 10                	je     801c9f <free+0x79>
  801c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c92:	8b 00                	mov    (%eax),%eax
  801c94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c97:	8b 52 04             	mov    0x4(%edx),%edx
  801c9a:	89 50 04             	mov    %edx,0x4(%eax)
  801c9d:	eb 0b                	jmp    801caa <free+0x84>
  801c9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca2:	8b 40 04             	mov    0x4(%eax),%eax
  801ca5:	a3 44 50 80 00       	mov    %eax,0x805044
  801caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cad:	8b 40 04             	mov    0x4(%eax),%eax
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	74 0f                	je     801cc3 <free+0x9d>
  801cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb7:	8b 40 04             	mov    0x4(%eax),%eax
  801cba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cbd:	8b 12                	mov    (%edx),%edx
  801cbf:	89 10                	mov    %edx,(%eax)
  801cc1:	eb 0a                	jmp    801ccd <free+0xa7>
  801cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc6:	8b 00                	mov    (%eax),%eax
  801cc8:	a3 40 50 80 00       	mov    %eax,0x805040
  801ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ce0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ce5:	48                   	dec    %eax
  801ce6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 ec             	pushl  -0x14(%ebp)
  801cf1:	e8 63 12 00 00       	call   802f59 <insert_sorted_with_merge_freeList>
  801cf6:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 38             	sub    $0x38,%esp
  801d02:	8b 45 10             	mov    0x10(%ebp),%eax
  801d05:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d08:	e8 c8 fc ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d11:	75 0a                	jne    801d1d <smalloc+0x21>
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	e9 a0 00 00 00       	jmp    801dbd <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801d1d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801d24:	76 0a                	jbe    801d30 <smalloc+0x34>
		return NULL;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2b:	e9 8d 00 00 00       	jmp    801dbd <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d30:	e8 1b 07 00 00       	call   802450 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d35:	85 c0                	test   %eax,%eax
  801d37:	74 7f                	je     801db8 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d39:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d46:	01 d0                	add    %edx,%eax
  801d48:	48                   	dec    %eax
  801d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d54:	f7 75 f4             	divl   -0xc(%ebp)
  801d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5a:	29 d0                	sub    %edx,%eax
  801d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	ff 75 ec             	pushl  -0x14(%ebp)
  801d65:	e8 65 0c 00 00       	call   8029cf <alloc_block_FF>
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801d70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d74:	74 42                	je     801db8 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	ff 75 e8             	pushl  -0x18(%ebp)
  801d7c:	e8 9f 0a 00 00       	call   802820 <insert_sorted_allocList>
  801d81:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d87:	8b 40 08             	mov    0x8(%eax),%eax
  801d8a:	89 c2                	mov    %eax,%edx
  801d8c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d90:	52                   	push   %edx
  801d91:	50                   	push   %eax
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	e8 38 04 00 00       	call   8021d5 <sys_createSharedObject>
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801da3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801da7:	79 07                	jns    801db0 <smalloc+0xb4>
	    		  return NULL;
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dae:	eb 0d                	jmp    801dbd <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801db0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db3:	8b 40 08             	mov    0x8(%eax),%eax
  801db6:	eb 05                	jmp    801dbd <smalloc+0xc1>


				}


		return NULL;
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dc5:	e8 0b fc ff ff       	call   8019d5 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801dca:	e8 81 06 00 00       	call   802450 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	0f 84 9f 00 00 00    	je     801e76 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 1a 04 00 00       	call   8021ff <sys_getSizeOfSharedObject>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801def:	79 0a                	jns    801dfb <sget+0x3c>
		return NULL;
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	e9 80 00 00 00       	jmp    801e7b <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801dfb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e08:	01 d0                	add    %edx,%eax
  801e0a:	48                   	dec    %eax
  801e0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e11:	ba 00 00 00 00       	mov    $0x0,%edx
  801e16:	f7 75 f0             	divl   -0x10(%ebp)
  801e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1c:	29 d0                	sub    %edx,%eax
  801e1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	ff 75 e8             	pushl  -0x18(%ebp)
  801e27:	e8 a3 0b 00 00       	call   8029cf <alloc_block_FF>
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e36:	74 3e                	je     801e76 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e3e:	e8 dd 09 00 00       	call   802820 <insert_sorted_allocList>
  801e43:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e49:	8b 40 08             	mov    0x8(%eax),%eax
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	50                   	push   %eax
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	e8 c1 03 00 00       	call   80221c <sys_getSharedObject>
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801e61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e65:	79 07                	jns    801e6e <sget+0xaf>
	    		  return NULL;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	eb 0d                	jmp    801e7b <sget+0xbc>
	  	return(void*) returned_block->sva;
  801e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e71:	8b 40 08             	mov    0x8(%eax),%eax
  801e74:	eb 05                	jmp    801e7b <sget+0xbc>
	      }
	}
	   return NULL;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e83:	e8 4d fb ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	68 b4 41 80 00       	push   $0x8041b4
  801e90:	68 12 01 00 00       	push   $0x112
  801e95:	68 a7 41 80 00       	push   $0x8041a7
  801e9a:	e8 f2 e8 ff ff       	call   800791 <_panic>

00801e9f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 dc 41 80 00       	push   $0x8041dc
  801ead:	68 26 01 00 00       	push   $0x126
  801eb2:	68 a7 41 80 00       	push   $0x8041a7
  801eb7:	e8 d5 e8 ff ff       	call   800791 <_panic>

00801ebc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	68 00 42 80 00       	push   $0x804200
  801eca:	68 31 01 00 00       	push   $0x131
  801ecf:	68 a7 41 80 00       	push   $0x8041a7
  801ed4:	e8 b8 e8 ff ff       	call   800791 <_panic>

00801ed9 <shrink>:

}
void shrink(uint32 newSize)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 00 42 80 00       	push   $0x804200
  801ee7:	68 36 01 00 00       	push   $0x136
  801eec:	68 a7 41 80 00       	push   $0x8041a7
  801ef1:	e8 9b e8 ff ff       	call   800791 <_panic>

00801ef6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	68 00 42 80 00       	push   $0x804200
  801f04:	68 3b 01 00 00       	push   $0x13b
  801f09:	68 a7 41 80 00       	push   $0x8041a7
  801f0e:	e8 7e e8 ff ff       	call   800791 <_panic>

00801f13 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	57                   	push   %edi
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f28:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f2b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f2e:	cd 30                	int    $0x30
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5f                   	pop    %edi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    

00801f3e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	8b 45 10             	mov    0x10(%ebp),%eax
  801f47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f4a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	52                   	push   %edx
  801f56:	ff 75 0c             	pushl  0xc(%ebp)
  801f59:	50                   	push   %eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	e8 b2 ff ff ff       	call   801f13 <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
}
  801f64:	90                   	nop
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 01                	push   $0x1
  801f76:	e8 98 ff ff ff       	call   801f13 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	52                   	push   %edx
  801f90:	50                   	push   %eax
  801f91:	6a 05                	push   $0x5
  801f93:	e8 7b ff ff ff       	call   801f13 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	56                   	push   %esi
  801fa1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa2:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	56                   	push   %esi
  801fb2:	53                   	push   %ebx
  801fb3:	51                   	push   %ecx
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 06                	push   $0x6
  801fb8:	e8 56 ff ff ff       	call   801f13 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc3:	5b                   	pop    %ebx
  801fc4:	5e                   	pop    %esi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 07                	push   $0x7
  801fda:	e8 34 ff ff ff       	call   801f13 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	ff 75 0c             	pushl  0xc(%ebp)
  801ff0:	ff 75 08             	pushl  0x8(%ebp)
  801ff3:	6a 08                	push   $0x8
  801ff5:	e8 19 ff ff ff       	call   801f13 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 09                	push   $0x9
  80200e:	e8 00 ff ff ff       	call   801f13 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 0a                	push   $0xa
  802027:	e8 e7 fe ff ff       	call   801f13 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 0b                	push   $0xb
  802040:	e8 ce fe ff ff       	call   801f13 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	6a 0f                	push   $0xf
  80205b:	e8 b3 fe ff ff       	call   801f13 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
	return;
  802063:	90                   	nop
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	6a 10                	push   $0x10
  802077:	e8 97 fe ff ff       	call   801f13 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
	return ;
  80207f:	90                   	nop
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	ff 75 10             	pushl  0x10(%ebp)
  80208c:	ff 75 0c             	pushl  0xc(%ebp)
  80208f:	ff 75 08             	pushl  0x8(%ebp)
  802092:	6a 11                	push   $0x11
  802094:	e8 7a fe ff ff       	call   801f13 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
	return ;
  80209c:	90                   	nop
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 0c                	push   $0xc
  8020ae:	e8 60 fe ff ff       	call   801f13 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	ff 75 08             	pushl  0x8(%ebp)
  8020c6:	6a 0d                	push   $0xd
  8020c8:	e8 46 fe ff ff       	call   801f13 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 0e                	push   $0xe
  8020e1:	e8 2d fe ff ff       	call   801f13 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	90                   	nop
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 13                	push   $0x13
  8020fb:	e8 13 fe ff ff       	call   801f13 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	90                   	nop
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 14                	push   $0x14
  802115:	e8 f9 fd ff ff       	call   801f13 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	90                   	nop
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_cputc>:


void
sys_cputc(const char c)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80212c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	50                   	push   %eax
  802139:	6a 15                	push   $0x15
  80213b:	e8 d3 fd ff ff       	call   801f13 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	90                   	nop
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 16                	push   $0x16
  802155:	e8 b9 fd ff ff       	call   801f13 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	90                   	nop
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	50                   	push   %eax
  802170:	6a 17                	push   $0x17
  802172:	e8 9c fd ff ff       	call   801f13 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80217f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	6a 1a                	push   $0x1a
  80218f:	e8 7f fd ff ff       	call   801f13 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	52                   	push   %edx
  8021a9:	50                   	push   %eax
  8021aa:	6a 18                	push   $0x18
  8021ac:	e8 62 fd ff ff       	call   801f13 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	52                   	push   %edx
  8021c7:	50                   	push   %eax
  8021c8:	6a 19                	push   $0x19
  8021ca:	e8 44 fd ff ff       	call   801f13 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	90                   	nop
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	8b 45 10             	mov    0x10(%ebp),%eax
  8021de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	6a 00                	push   $0x0
  8021ed:	51                   	push   %ecx
  8021ee:	52                   	push   %edx
  8021ef:	ff 75 0c             	pushl  0xc(%ebp)
  8021f2:	50                   	push   %eax
  8021f3:	6a 1b                	push   $0x1b
  8021f5:	e8 19 fd ff ff       	call   801f13 <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802202:	8b 55 0c             	mov    0xc(%ebp),%edx
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	52                   	push   %edx
  80220f:	50                   	push   %eax
  802210:	6a 1c                	push   $0x1c
  802212:	e8 fc fc ff ff       	call   801f13 <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80221f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802222:	8b 55 0c             	mov    0xc(%ebp),%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	51                   	push   %ecx
  80222d:	52                   	push   %edx
  80222e:	50                   	push   %eax
  80222f:	6a 1d                	push   $0x1d
  802231:	e8 dd fc ff ff       	call   801f13 <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80223e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	52                   	push   %edx
  80224b:	50                   	push   %eax
  80224c:	6a 1e                	push   $0x1e
  80224e:	e8 c0 fc ff ff       	call   801f13 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 1f                	push   $0x1f
  802267:	e8 a7 fc ff ff       	call   801f13 <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	6a 00                	push   $0x0
  802279:	ff 75 14             	pushl  0x14(%ebp)
  80227c:	ff 75 10             	pushl  0x10(%ebp)
  80227f:	ff 75 0c             	pushl  0xc(%ebp)
  802282:	50                   	push   %eax
  802283:	6a 20                	push   $0x20
  802285:	e8 89 fc ff ff       	call   801f13 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	50                   	push   %eax
  80229e:	6a 21                	push   $0x21
  8022a0:	e8 6e fc ff ff       	call   801f13 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	90                   	nop
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	50                   	push   %eax
  8022ba:	6a 22                	push   $0x22
  8022bc:	e8 52 fc ff ff       	call   801f13 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 02                	push   $0x2
  8022d5:	e8 39 fc ff ff       	call   801f13 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 03                	push   $0x3
  8022ee:	e8 20 fc ff ff       	call   801f13 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 04                	push   $0x4
  802307:	e8 07 fc ff ff       	call   801f13 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_exit_env>:


void sys_exit_env(void)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 23                	push   $0x23
  802320:	e8 ee fb ff ff       	call   801f13 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	90                   	nop
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802331:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802334:	8d 50 04             	lea    0x4(%eax),%edx
  802337:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 24                	push   $0x24
  802344:	e8 ca fb ff ff       	call   801f13 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
	return result;
  80234c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80234f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802352:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802355:	89 01                	mov    %eax,(%ecx)
  802357:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	c9                   	leave  
  80235e:	c2 04 00             	ret    $0x4

00802361 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	ff 75 10             	pushl  0x10(%ebp)
  80236b:	ff 75 0c             	pushl  0xc(%ebp)
  80236e:	ff 75 08             	pushl  0x8(%ebp)
  802371:	6a 12                	push   $0x12
  802373:	e8 9b fb ff ff       	call   801f13 <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
	return ;
  80237b:	90                   	nop
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <sys_rcr2>:
uint32 sys_rcr2()
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 25                	push   $0x25
  80238d:	e8 81 fb ff ff       	call   801f13 <syscall>
  802392:	83 c4 18             	add    $0x18,%esp
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	83 ec 04             	sub    $0x4,%esp
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	50                   	push   %eax
  8023b0:	6a 26                	push   $0x26
  8023b2:	e8 5c fb ff ff       	call   801f13 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ba:	90                   	nop
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <rsttst>:
void rsttst()
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 28                	push   $0x28
  8023cc:	e8 42 fb ff ff       	call   801f13 <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d4:	90                   	nop
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8023e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023ea:	52                   	push   %edx
  8023eb:	50                   	push   %eax
  8023ec:	ff 75 10             	pushl  0x10(%ebp)
  8023ef:	ff 75 0c             	pushl  0xc(%ebp)
  8023f2:	ff 75 08             	pushl  0x8(%ebp)
  8023f5:	6a 27                	push   $0x27
  8023f7:	e8 17 fb ff ff       	call   801f13 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ff:	90                   	nop
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <chktst>:
void chktst(uint32 n)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	ff 75 08             	pushl  0x8(%ebp)
  802410:	6a 29                	push   $0x29
  802412:	e8 fc fa ff ff       	call   801f13 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
	return ;
  80241a:	90                   	nop
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <inctst>:

void inctst()
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 2a                	push   $0x2a
  80242c:	e8 e2 fa ff ff       	call   801f13 <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
	return ;
  802434:	90                   	nop
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <gettst>:
uint32 gettst()
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 2b                	push   $0x2b
  802446:	e8 c8 fa ff ff       	call   801f13 <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 2c                	push   $0x2c
  802462:	e8 ac fa ff ff       	call   801f13 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
  80246a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80246d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802471:	75 07                	jne    80247a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802473:	b8 01 00 00 00       	mov    $0x1,%eax
  802478:	eb 05                	jmp    80247f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 2c                	push   $0x2c
  802493:	e8 7b fa ff ff       	call   801f13 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
  80249b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80249e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024a2:	75 07                	jne    8024ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a9:	eb 05                	jmp    8024b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 2c                	push   $0x2c
  8024c4:	e8 4a fa ff ff       	call   801f13 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
  8024cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024d3:	75 07                	jne    8024dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024da:	eb 05                	jmp    8024e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 2c                	push   $0x2c
  8024f5:	e8 19 fa ff ff       	call   801f13 <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
  8024fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802500:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802504:	75 07                	jne    80250d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802506:	b8 01 00 00 00       	mov    $0x1,%eax
  80250b:	eb 05                	jmp    802512 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	ff 75 08             	pushl  0x8(%ebp)
  802522:	6a 2d                	push   $0x2d
  802524:	e8 ea f9 ff ff       	call   801f13 <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
	return ;
  80252c:	90                   	nop
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802533:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802536:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	53                   	push   %ebx
  802542:	51                   	push   %ecx
  802543:	52                   	push   %edx
  802544:	50                   	push   %eax
  802545:	6a 2e                	push   $0x2e
  802547:	e8 c7 f9 ff ff       	call   801f13 <syscall>
  80254c:	83 c4 18             	add    $0x18,%esp
}
  80254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	52                   	push   %edx
  802564:	50                   	push   %eax
  802565:	6a 2f                	push   $0x2f
  802567:	e8 a7 f9 ff ff       	call   801f13 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802577:	83 ec 0c             	sub    $0xc,%esp
  80257a:	68 10 42 80 00       	push   $0x804210
  80257f:	e8 c1 e4 ff ff       	call   800a45 <cprintf>
  802584:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802587:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80258e:	83 ec 0c             	sub    $0xc,%esp
  802591:	68 3c 42 80 00       	push   $0x80423c
  802596:	e8 aa e4 ff ff       	call   800a45 <cprintf>
  80259b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80259e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025aa:	eb 56                	jmp    802602 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b0:	74 1c                	je     8025ce <print_mem_block_lists+0x5d>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 50 08             	mov    0x8(%eax),%edx
  8025b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bb:	8b 48 08             	mov    0x8(%eax),%ecx
  8025be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c4:	01 c8                	add    %ecx,%eax
  8025c6:	39 c2                	cmp    %eax,%edx
  8025c8:	73 04                	jae    8025ce <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025ca:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 50 08             	mov    0x8(%eax),%edx
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025da:	01 c2                	add    %eax,%edx
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 08             	mov    0x8(%eax),%eax
  8025e2:	83 ec 04             	sub    $0x4,%esp
  8025e5:	52                   	push   %edx
  8025e6:	50                   	push   %eax
  8025e7:	68 51 42 80 00       	push   $0x804251
  8025ec:	e8 54 e4 ff ff       	call   800a45 <cprintf>
  8025f1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	74 07                	je     80260f <print_mem_block_lists+0x9e>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	eb 05                	jmp    802614 <print_mem_block_lists+0xa3>
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	a3 40 51 80 00       	mov    %eax,0x805140
  802619:	a1 40 51 80 00       	mov    0x805140,%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	75 8a                	jne    8025ac <print_mem_block_lists+0x3b>
  802622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802626:	75 84                	jne    8025ac <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802628:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80262c:	75 10                	jne    80263e <print_mem_block_lists+0xcd>
  80262e:	83 ec 0c             	sub    $0xc,%esp
  802631:	68 60 42 80 00       	push   $0x804260
  802636:	e8 0a e4 ff ff       	call   800a45 <cprintf>
  80263b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80263e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802645:	83 ec 0c             	sub    $0xc,%esp
  802648:	68 84 42 80 00       	push   $0x804284
  80264d:	e8 f3 e3 ff ff       	call   800a45 <cprintf>
  802652:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802655:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802659:	a1 40 50 80 00       	mov    0x805040,%eax
  80265e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802661:	eb 56                	jmp    8026b9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802663:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802667:	74 1c                	je     802685 <print_mem_block_lists+0x114>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 50 08             	mov    0x8(%eax),%edx
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	8b 48 08             	mov    0x8(%eax),%ecx
  802675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802678:	8b 40 0c             	mov    0xc(%eax),%eax
  80267b:	01 c8                	add    %ecx,%eax
  80267d:	39 c2                	cmp    %eax,%edx
  80267f:	73 04                	jae    802685 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802681:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 50 08             	mov    0x8(%eax),%edx
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 0c             	mov    0xc(%eax),%eax
  802691:	01 c2                	add    %eax,%edx
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 08             	mov    0x8(%eax),%eax
  802699:	83 ec 04             	sub    $0x4,%esp
  80269c:	52                   	push   %edx
  80269d:	50                   	push   %eax
  80269e:	68 51 42 80 00       	push   $0x804251
  8026a3:	e8 9d e3 ff ff       	call   800a45 <cprintf>
  8026a8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	74 07                	je     8026c6 <print_mem_block_lists+0x155>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	eb 05                	jmp    8026cb <print_mem_block_lists+0x15a>
  8026c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cb:	a3 48 50 80 00       	mov    %eax,0x805048
  8026d0:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	75 8a                	jne    802663 <print_mem_block_lists+0xf2>
  8026d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dd:	75 84                	jne    802663 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026df:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026e3:	75 10                	jne    8026f5 <print_mem_block_lists+0x184>
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	68 9c 42 80 00       	push   $0x80429c
  8026ed:	e8 53 e3 ff ff       	call   800a45 <cprintf>
  8026f2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026f5:	83 ec 0c             	sub    $0xc,%esp
  8026f8:	68 10 42 80 00       	push   $0x804210
  8026fd:	e8 43 e3 ff ff       	call   800a45 <cprintf>
  802702:	83 c4 10             	add    $0x10,%esp

}
  802705:	90                   	nop
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80270e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802715:	00 00 00 
  802718:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80271f:	00 00 00 
  802722:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802729:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80272c:	a1 50 50 80 00       	mov    0x805050,%eax
  802731:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802734:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80273b:	e9 9e 00 00 00       	jmp    8027de <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802740:	a1 50 50 80 00       	mov    0x805050,%eax
  802745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802748:	c1 e2 04             	shl    $0x4,%edx
  80274b:	01 d0                	add    %edx,%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	75 14                	jne    802765 <initialize_MemBlocksList+0x5d>
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	68 c4 42 80 00       	push   $0x8042c4
  802759:	6a 48                	push   $0x48
  80275b:	68 e7 42 80 00       	push   $0x8042e7
  802760:	e8 2c e0 ff ff       	call   800791 <_panic>
  802765:	a1 50 50 80 00       	mov    0x805050,%eax
  80276a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276d:	c1 e2 04             	shl    $0x4,%edx
  802770:	01 d0                	add    %edx,%eax
  802772:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802778:	89 10                	mov    %edx,(%eax)
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	74 18                	je     802798 <initialize_MemBlocksList+0x90>
  802780:	a1 48 51 80 00       	mov    0x805148,%eax
  802785:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80278b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80278e:	c1 e1 04             	shl    $0x4,%ecx
  802791:	01 ca                	add    %ecx,%edx
  802793:	89 50 04             	mov    %edx,0x4(%eax)
  802796:	eb 12                	jmp    8027aa <initialize_MemBlocksList+0xa2>
  802798:	a1 50 50 80 00       	mov    0x805050,%eax
  80279d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a0:	c1 e2 04             	shl    $0x4,%edx
  8027a3:	01 d0                	add    %edx,%eax
  8027a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8027af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b2:	c1 e2 04             	shl    $0x4,%edx
  8027b5:	01 d0                	add    %edx,%eax
  8027b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8027bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	c1 e2 04             	shl    $0x4,%edx
  8027c7:	01 d0                	add    %edx,%eax
  8027c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8027d5:	40                   	inc    %eax
  8027d6:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8027db:	ff 45 f4             	incl   -0xc(%ebp)
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e4:	0f 82 56 ff ff ff    	jb     802740 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8027ea:	90                   	nop
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8027fb:	eb 18                	jmp    802815 <find_block+0x28>
		{
			if(tmp->sva==va)
  8027fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802800:	8b 40 08             	mov    0x8(%eax),%eax
  802803:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802806:	75 05                	jne    80280d <find_block+0x20>
			{
				return tmp;
  802808:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80280b:	eb 11                	jmp    80281e <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80280d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802815:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802819:	75 e2                	jne    8027fd <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80281b:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802826:	a1 40 50 80 00       	mov    0x805040,%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	0f 85 83 00 00 00    	jne    8028b6 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802833:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80283a:	00 00 00 
  80283d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802844:	00 00 00 
  802847:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80284e:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802855:	75 14                	jne    80286b <insert_sorted_allocList+0x4b>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 c4 42 80 00       	push   $0x8042c4
  80285f:	6a 7f                	push   $0x7f
  802861:	68 e7 42 80 00       	push   $0x8042e7
  802866:	e8 26 df ff ff       	call   800791 <_panic>
  80286b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	89 10                	mov    %edx,(%eax)
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 0d                	je     80288c <insert_sorted_allocList+0x6c>
  80287f:	a1 40 50 80 00       	mov    0x805040,%eax
  802884:	8b 55 08             	mov    0x8(%ebp),%edx
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	eb 08                	jmp    802894 <insert_sorted_allocList+0x74>
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	a3 44 50 80 00       	mov    %eax,0x805044
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	a3 40 50 80 00       	mov    %eax,0x805040
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ab:	40                   	inc    %eax
  8028ac:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8028b1:	e9 16 01 00 00       	jmp    8029cc <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	8b 50 08             	mov    0x8(%eax),%edx
  8028bc:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c1:	8b 40 08             	mov    0x8(%eax),%eax
  8028c4:	39 c2                	cmp    %eax,%edx
  8028c6:	76 68                	jbe    802930 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8028c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cc:	75 17                	jne    8028e5 <insert_sorted_allocList+0xc5>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 00 43 80 00       	push   $0x804300
  8028d6:	68 85 00 00 00       	push   $0x85
  8028db:	68 e7 42 80 00       	push   $0x8042e7
  8028e0:	e8 ac de ff ff       	call   800791 <_panic>
  8028e5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 40 04             	mov    0x4(%eax),%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	74 0c                	je     802907 <insert_sorted_allocList+0xe7>
  8028fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802900:	8b 55 08             	mov    0x8(%ebp),%edx
  802903:	89 10                	mov    %edx,(%eax)
  802905:	eb 08                	jmp    80290f <insert_sorted_allocList+0xef>
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	a3 40 50 80 00       	mov    %eax,0x805040
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	a3 44 50 80 00       	mov    %eax,0x805044
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802920:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802925:	40                   	inc    %eax
  802926:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80292b:	e9 9c 00 00 00       	jmp    8029cc <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802930:	a1 40 50 80 00       	mov    0x805040,%eax
  802935:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802938:	e9 85 00 00 00       	jmp    8029c2 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 08             	mov    0x8(%eax),%eax
  802949:	39 c2                	cmp    %eax,%edx
  80294b:	73 6d                	jae    8029ba <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80294d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802951:	74 06                	je     802959 <insert_sorted_allocList+0x139>
  802953:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802957:	75 17                	jne    802970 <insert_sorted_allocList+0x150>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 24 43 80 00       	push   $0x804324
  802961:	68 90 00 00 00       	push   $0x90
  802966:	68 e7 42 80 00       	push   $0x8042e7
  80296b:	e8 21 de ff ff       	call   800791 <_panic>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 50 04             	mov    0x4(%eax),%edx
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	89 50 04             	mov    %edx,0x4(%eax)
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 0d                	je     80299b <insert_sorted_allocList+0x17b>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 04             	mov    0x4(%eax),%eax
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 10                	mov    %edx,(%eax)
  802999:	eb 08                	jmp    8029a3 <insert_sorted_allocList+0x183>
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	a3 40 50 80 00       	mov    %eax,0x805040
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b1:	40                   	inc    %eax
  8029b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029b7:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029b8:	eb 12                	jmp    8029cc <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8029c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c6:	0f 85 71 ff ff ff    	jne    80293d <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029cc:	90                   	nop
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
  8029d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8029d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8029da:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8029dd:	e9 76 01 00 00       	jmp    802b58 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029eb:	0f 85 8a 00 00 00    	jne    802a7b <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8029f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f5:	75 17                	jne    802a0e <alloc_block_FF+0x3f>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 59 43 80 00       	push   $0x804359
  8029ff:	68 a8 00 00 00       	push   $0xa8
  802a04:	68 e7 42 80 00       	push   $0x8042e7
  802a09:	e8 83 dd ff ff       	call   800791 <_panic>
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 10                	je     802a27 <alloc_block_FF+0x58>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1f:	8b 52 04             	mov    0x4(%edx),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	eb 0b                	jmp    802a32 <alloc_block_FF+0x63>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 0f                	je     802a4b <alloc_block_FF+0x7c>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a45:	8b 12                	mov    (%edx),%edx
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	eb 0a                	jmp    802a55 <alloc_block_FF+0x86>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	a3 38 51 80 00       	mov    %eax,0x805138
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a68:	a1 44 51 80 00       	mov    0x805144,%eax
  802a6d:	48                   	dec    %eax
  802a6e:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	e9 ea 00 00 00       	jmp    802b65 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a84:	0f 86 c6 00 00 00    	jbe    802b50 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a8a:	a1 48 51 80 00       	mov    0x805148,%eax
  802a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 50 08             	mov    0x8(%eax),%edx
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab0:	89 c2                	mov    %eax,%edx
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 50 08             	mov    0x8(%eax),%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	01 c2                	add    %eax,%edx
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ac9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802acd:	75 17                	jne    802ae6 <alloc_block_FF+0x117>
  802acf:	83 ec 04             	sub    $0x4,%esp
  802ad2:	68 59 43 80 00       	push   $0x804359
  802ad7:	68 b6 00 00 00       	push   $0xb6
  802adc:	68 e7 42 80 00       	push   $0x8042e7
  802ae1:	e8 ab dc ff ff       	call   800791 <_panic>
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 10                	je     802aff <alloc_block_FF+0x130>
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af7:	8b 52 04             	mov    0x4(%edx),%edx
  802afa:	89 50 04             	mov    %edx,0x4(%eax)
  802afd:	eb 0b                	jmp    802b0a <alloc_block_FF+0x13b>
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0f                	je     802b23 <alloc_block_FF+0x154>
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1d:	8b 12                	mov    (%edx),%edx
  802b1f:	89 10                	mov    %edx,(%eax)
  802b21:	eb 0a                	jmp    802b2d <alloc_block_FF+0x15e>
  802b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	a3 48 51 80 00       	mov    %eax,0x805148
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b40:	a1 54 51 80 00       	mov    0x805154,%eax
  802b45:	48                   	dec    %eax
  802b46:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	eb 15                	jmp    802b65 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802b58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5c:	0f 85 80 fe ff ff    	jne    8029e2 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802b65:	c9                   	leave  
  802b66:	c3                   	ret    

00802b67 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b67:	55                   	push   %ebp
  802b68:	89 e5                	mov    %esp,%ebp
  802b6a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802b6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802b75:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802b7c:	e9 c0 00 00 00       	jmp    802c41 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 0c             	mov    0xc(%eax),%eax
  802b87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8a:	0f 85 8a 00 00 00    	jne    802c1a <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b94:	75 17                	jne    802bad <alloc_block_BF+0x46>
  802b96:	83 ec 04             	sub    $0x4,%esp
  802b99:	68 59 43 80 00       	push   $0x804359
  802b9e:	68 cf 00 00 00       	push   $0xcf
  802ba3:	68 e7 42 80 00       	push   $0x8042e7
  802ba8:	e8 e4 db ff ff       	call   800791 <_panic>
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	74 10                	je     802bc6 <alloc_block_BF+0x5f>
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 00                	mov    (%eax),%eax
  802bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbe:	8b 52 04             	mov    0x4(%edx),%edx
  802bc1:	89 50 04             	mov    %edx,0x4(%eax)
  802bc4:	eb 0b                	jmp    802bd1 <alloc_block_BF+0x6a>
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 40 04             	mov    0x4(%eax),%eax
  802bcc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 40 04             	mov    0x4(%eax),%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	74 0f                	je     802bea <alloc_block_BF+0x83>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 04             	mov    0x4(%eax),%eax
  802be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be4:	8b 12                	mov    (%edx),%edx
  802be6:	89 10                	mov    %edx,(%eax)
  802be8:	eb 0a                	jmp    802bf4 <alloc_block_BF+0x8d>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 00                	mov    (%eax),%eax
  802bef:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c07:	a1 44 51 80 00       	mov    0x805144,%eax
  802c0c:	48                   	dec    %eax
  802c0d:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	e9 2a 01 00 00       	jmp    802d44 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c23:	73 14                	jae    802c39 <alloc_block_BF+0xd2>
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2e:	76 09                	jbe    802c39 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 0c             	mov    0xc(%eax),%eax
  802c36:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c45:	0f 85 36 ff ff ff    	jne    802b81 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802c4b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802c53:	e9 dd 00 00 00       	jmp    802d35 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c61:	0f 85 c6 00 00 00    	jne    802d2d <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802c67:	a1 48 51 80 00       	mov    0x805148,%eax
  802c6c:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c81:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 50 08             	mov    0x8(%eax),%edx
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	01 c2                	add    %eax,%edx
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c9e:	89 c2                	mov    %eax,%edx
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ca6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802caa:	75 17                	jne    802cc3 <alloc_block_BF+0x15c>
  802cac:	83 ec 04             	sub    $0x4,%esp
  802caf:	68 59 43 80 00       	push   $0x804359
  802cb4:	68 eb 00 00 00       	push   $0xeb
  802cb9:	68 e7 42 80 00       	push   $0x8042e7
  802cbe:	e8 ce da ff ff       	call   800791 <_panic>
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 10                	je     802cdc <alloc_block_BF+0x175>
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd4:	8b 52 04             	mov    0x4(%edx),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%eax)
  802cda:	eb 0b                	jmp    802ce7 <alloc_block_BF+0x180>
  802cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 0f                	je     802d00 <alloc_block_BF+0x199>
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cfa:	8b 12                	mov    (%edx),%edx
  802cfc:	89 10                	mov    %edx,(%eax)
  802cfe:	eb 0a                	jmp    802d0a <alloc_block_BF+0x1a3>
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	a3 48 51 80 00       	mov    %eax,0x805148
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d22:	48                   	dec    %eax
  802d23:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	eb 17                	jmp    802d44 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d39:	0f 85 19 ff ff ff    	jne    802c58 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802d44:	c9                   	leave  
  802d45:	c3                   	ret    

00802d46 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802d46:	55                   	push   %ebp
  802d47:	89 e5                	mov    %esp,%ebp
  802d49:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802d4c:	a1 40 50 80 00       	mov    0x805040,%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	75 19                	jne    802d6e <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802d55:	83 ec 0c             	sub    $0xc,%esp
  802d58:	ff 75 08             	pushl  0x8(%ebp)
  802d5b:	e8 6f fc ff ff       	call   8029cf <alloc_block_FF>
  802d60:	83 c4 10             	add    $0x10,%esp
  802d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	e9 e9 01 00 00       	jmp    802f57 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802d6e:	a1 44 50 80 00       	mov    0x805044,%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802d79:	a1 44 50 80 00       	mov    0x805044,%eax
  802d7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d81:	a1 44 50 80 00       	mov    0x805044,%eax
  802d86:	8b 40 08             	mov    0x8(%eax),%eax
  802d89:	01 d0                	add    %edx,%eax
  802d8b:	83 ec 08             	sub    $0x8,%esp
  802d8e:	50                   	push   %eax
  802d8f:	68 38 51 80 00       	push   $0x805138
  802d94:	e8 54 fa ff ff       	call   8027ed <find_block>
  802d99:	83 c4 10             	add    $0x10,%esp
  802d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 0c             	mov    0xc(%eax),%eax
  802da5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da8:	0f 85 9b 00 00 00    	jne    802e49 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 50 0c             	mov    0xc(%eax),%edx
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 08             	mov    0x8(%eax),%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	75 17                	jne    802ddc <alloc_block_NF+0x96>
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	68 59 43 80 00       	push   $0x804359
  802dcd:	68 1a 01 00 00       	push   $0x11a
  802dd2:	68 e7 42 80 00       	push   $0x8042e7
  802dd7:	e8 b5 d9 ff ff       	call   800791 <_panic>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 10                	je     802df5 <alloc_block_NF+0xaf>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ded:	8b 52 04             	mov    0x4(%edx),%edx
  802df0:	89 50 04             	mov    %edx,0x4(%eax)
  802df3:	eb 0b                	jmp    802e00 <alloc_block_NF+0xba>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0f                	je     802e19 <alloc_block_NF+0xd3>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e13:	8b 12                	mov    (%edx),%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	eb 0a                	jmp    802e23 <alloc_block_NF+0xdd>
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e36:	a1 44 51 80 00       	mov    0x805144,%eax
  802e3b:	48                   	dec    %eax
  802e3c:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	e9 0e 01 00 00       	jmp    802f57 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e52:	0f 86 cf 00 00 00    	jbe    802f27 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802e58:	a1 48 51 80 00       	mov    0x805148,%eax
  802e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e63:	8b 55 08             	mov    0x8(%ebp),%edx
  802e66:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 50 08             	mov    0x8(%eax),%edx
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 50 08             	mov    0x8(%eax),%edx
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e8f:	89 c2                	mov    %eax,%edx
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 08             	mov    0x8(%eax),%eax
  802e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ea0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea4:	75 17                	jne    802ebd <alloc_block_NF+0x177>
  802ea6:	83 ec 04             	sub    $0x4,%esp
  802ea9:	68 59 43 80 00       	push   $0x804359
  802eae:	68 28 01 00 00       	push   $0x128
  802eb3:	68 e7 42 80 00       	push   $0x8042e7
  802eb8:	e8 d4 d8 ff ff       	call   800791 <_panic>
  802ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 10                	je     802ed6 <alloc_block_NF+0x190>
  802ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ece:	8b 52 04             	mov    0x4(%edx),%edx
  802ed1:	89 50 04             	mov    %edx,0x4(%eax)
  802ed4:	eb 0b                	jmp    802ee1 <alloc_block_NF+0x19b>
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	8b 40 04             	mov    0x4(%eax),%eax
  802edc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee4:	8b 40 04             	mov    0x4(%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 0f                	je     802efa <alloc_block_NF+0x1b4>
  802eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eee:	8b 40 04             	mov    0x4(%eax),%eax
  802ef1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef4:	8b 12                	mov    (%edx),%edx
  802ef6:	89 10                	mov    %edx,(%eax)
  802ef8:	eb 0a                	jmp    802f04 <alloc_block_NF+0x1be>
  802efa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	a3 48 51 80 00       	mov    %eax,0x805148
  802f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f17:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1c:	48                   	dec    %eax
  802f1d:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	eb 30                	jmp    802f57 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802f27:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f2f:	75 0a                	jne    802f3b <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802f31:	a1 38 51 80 00       	mov    0x805138,%eax
  802f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f39:	eb 08                	jmp    802f43 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 08             	mov    0x8(%eax),%eax
  802f49:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f4c:	0f 85 4d fe ff ff    	jne    802d9f <alloc_block_NF+0x59>

			return NULL;
  802f52:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802f57:	c9                   	leave  
  802f58:	c3                   	ret    

00802f59 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f59:	55                   	push   %ebp
  802f5a:	89 e5                	mov    %esp,%ebp
  802f5c:	53                   	push   %ebx
  802f5d:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802f60:	a1 38 51 80 00       	mov    0x805138,%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	0f 85 86 00 00 00    	jne    802ff3 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802f6d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802f74:	00 00 00 
  802f77:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802f7e:	00 00 00 
  802f81:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802f88:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8f:	75 17                	jne    802fa8 <insert_sorted_with_merge_freeList+0x4f>
  802f91:	83 ec 04             	sub    $0x4,%esp
  802f94:	68 c4 42 80 00       	push   $0x8042c4
  802f99:	68 48 01 00 00       	push   $0x148
  802f9e:	68 e7 42 80 00       	push   $0x8042e7
  802fa3:	e8 e9 d7 ff ff       	call   800791 <_panic>
  802fa8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	89 10                	mov    %edx,(%eax)
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 0d                	je     802fc9 <insert_sorted_with_merge_freeList+0x70>
  802fbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc4:	89 50 04             	mov    %edx,0x4(%eax)
  802fc7:	eb 08                	jmp    802fd1 <insert_sorted_with_merge_freeList+0x78>
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe3:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe8:	40                   	inc    %eax
  802fe9:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802fee:	e9 73 07 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	8b 50 08             	mov    0x8(%eax),%edx
  802ff9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ffe:	8b 40 08             	mov    0x8(%eax),%eax
  803001:	39 c2                	cmp    %eax,%edx
  803003:	0f 86 84 00 00 00    	jbe    80308d <insert_sorted_with_merge_freeList+0x134>
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	8b 50 08             	mov    0x8(%eax),%edx
  80300f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803014:	8b 48 0c             	mov    0xc(%eax),%ecx
  803017:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301c:	8b 40 08             	mov    0x8(%eax),%eax
  80301f:	01 c8                	add    %ecx,%eax
  803021:	39 c2                	cmp    %eax,%edx
  803023:	74 68                	je     80308d <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803029:	75 17                	jne    803042 <insert_sorted_with_merge_freeList+0xe9>
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	68 00 43 80 00       	push   $0x804300
  803033:	68 4c 01 00 00       	push   $0x14c
  803038:	68 e7 42 80 00       	push   $0x8042e7
  80303d:	e8 4f d7 ff ff       	call   800791 <_panic>
  803042:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	89 50 04             	mov    %edx,0x4(%eax)
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 40 04             	mov    0x4(%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0c                	je     803064 <insert_sorted_with_merge_freeList+0x10b>
  803058:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 10                	mov    %edx,(%eax)
  803062:	eb 08                	jmp    80306c <insert_sorted_with_merge_freeList+0x113>
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	a3 38 51 80 00       	mov    %eax,0x805138
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307d:	a1 44 51 80 00       	mov    0x805144,%eax
  803082:	40                   	inc    %eax
  803083:	a3 44 51 80 00       	mov    %eax,0x805144
  803088:	e9 d9 06 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 50 08             	mov    0x8(%eax),%edx
  803093:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803098:	8b 40 08             	mov    0x8(%eax),%eax
  80309b:	39 c2                	cmp    %eax,%edx
  80309d:	0f 86 b5 00 00 00    	jbe    803158 <insert_sorted_with_merge_freeList+0x1ff>
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 50 08             	mov    0x8(%eax),%edx
  8030a9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ae:	8b 48 0c             	mov    0xc(%eax),%ecx
  8030b1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	01 c8                	add    %ecx,%eax
  8030bb:	39 c2                	cmp    %eax,%edx
  8030bd:	0f 85 95 00 00 00    	jne    803158 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8030c3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030c8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030ce:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8030d7:	01 ca                	add    %ecx,%edx
  8030d9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f4:	75 17                	jne    80310d <insert_sorted_with_merge_freeList+0x1b4>
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	68 c4 42 80 00       	push   $0x8042c4
  8030fe:	68 54 01 00 00       	push   $0x154
  803103:	68 e7 42 80 00       	push   $0x8042e7
  803108:	e8 84 d6 ff ff       	call   800791 <_panic>
  80310d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	89 10                	mov    %edx,(%eax)
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 0d                	je     80312e <insert_sorted_with_merge_freeList+0x1d5>
  803121:	a1 48 51 80 00       	mov    0x805148,%eax
  803126:	8b 55 08             	mov    0x8(%ebp),%edx
  803129:	89 50 04             	mov    %edx,0x4(%eax)
  80312c:	eb 08                	jmp    803136 <insert_sorted_with_merge_freeList+0x1dd>
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	a3 48 51 80 00       	mov    %eax,0x805148
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803148:	a1 54 51 80 00       	mov    0x805154,%eax
  80314d:	40                   	inc    %eax
  80314e:	a3 54 51 80 00       	mov    %eax,0x805154
  803153:	e9 0e 06 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	a1 38 51 80 00       	mov    0x805138,%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	39 c2                	cmp    %eax,%edx
  803168:	0f 83 c1 00 00 00    	jae    80322f <insert_sorted_with_merge_freeList+0x2d6>
  80316e:	a1 38 51 80 00       	mov    0x805138,%eax
  803173:	8b 50 08             	mov    0x8(%eax),%edx
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 48 08             	mov    0x8(%eax),%ecx
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 40 0c             	mov    0xc(%eax),%eax
  803182:	01 c8                	add    %ecx,%eax
  803184:	39 c2                	cmp    %eax,%edx
  803186:	0f 85 a3 00 00 00    	jne    80322f <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80318c:	a1 38 51 80 00       	mov    0x805138,%eax
  803191:	8b 55 08             	mov    0x8(%ebp),%edx
  803194:	8b 52 08             	mov    0x8(%edx),%edx
  803197:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80319a:	a1 38 51 80 00       	mov    0x805138,%eax
  80319f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031a5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8031ae:	01 ca                	add    %ecx,%edx
  8031b0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cb:	75 17                	jne    8031e4 <insert_sorted_with_merge_freeList+0x28b>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 c4 42 80 00       	push   $0x8042c4
  8031d5:	68 5d 01 00 00       	push   $0x15d
  8031da:	68 e7 42 80 00       	push   $0x8042e7
  8031df:	e8 ad d5 ff ff       	call   800791 <_panic>
  8031e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0d                	je     803205 <insert_sorted_with_merge_freeList+0x2ac>
  8031f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 08                	jmp    80320d <insert_sorted_with_merge_freeList+0x2b4>
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	a3 48 51 80 00       	mov    %eax,0x805148
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321f:	a1 54 51 80 00       	mov    0x805154,%eax
  803224:	40                   	inc    %eax
  803225:	a3 54 51 80 00       	mov    %eax,0x805154
  80322a:	e9 37 05 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	8b 50 08             	mov    0x8(%eax),%edx
  803235:	a1 38 51 80 00       	mov    0x805138,%eax
  80323a:	8b 40 08             	mov    0x8(%eax),%eax
  80323d:	39 c2                	cmp    %eax,%edx
  80323f:	0f 83 82 00 00 00    	jae    8032c7 <insert_sorted_with_merge_freeList+0x36e>
  803245:	a1 38 51 80 00       	mov    0x805138,%eax
  80324a:	8b 50 08             	mov    0x8(%eax),%edx
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	8b 48 08             	mov    0x8(%eax),%ecx
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	8b 40 0c             	mov    0xc(%eax),%eax
  803259:	01 c8                	add    %ecx,%eax
  80325b:	39 c2                	cmp    %eax,%edx
  80325d:	74 68                	je     8032c7 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80325f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803263:	75 17                	jne    80327c <insert_sorted_with_merge_freeList+0x323>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 c4 42 80 00       	push   $0x8042c4
  80326d:	68 62 01 00 00       	push   $0x162
  803272:	68 e7 42 80 00       	push   $0x8042e7
  803277:	e8 15 d5 ff ff       	call   800791 <_panic>
  80327c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	89 10                	mov    %edx,(%eax)
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0d                	je     80329d <insert_sorted_with_merge_freeList+0x344>
  803290:	a1 38 51 80 00       	mov    0x805138,%eax
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	89 50 04             	mov    %edx,0x4(%eax)
  80329b:	eb 08                	jmp    8032a5 <insert_sorted_with_merge_freeList+0x34c>
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032bc:	40                   	inc    %eax
  8032bd:	a3 44 51 80 00       	mov    %eax,0x805144
  8032c2:	e9 9f 04 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8032c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8032d1:	e9 84 04 00 00       	jmp    80375a <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	8b 50 08             	mov    0x8(%eax),%edx
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	8b 40 08             	mov    0x8(%eax),%eax
  8032e2:	39 c2                	cmp    %eax,%edx
  8032e4:	0f 86 a9 00 00 00    	jbe    803393 <insert_sorted_with_merge_freeList+0x43a>
  8032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ed:	8b 50 08             	mov    0x8(%eax),%edx
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 48 08             	mov    0x8(%eax),%ecx
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fc:	01 c8                	add    %ecx,%eax
  8032fe:	39 c2                	cmp    %eax,%edx
  803300:	0f 84 8d 00 00 00    	je     803393 <insert_sorted_with_merge_freeList+0x43a>
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 50 08             	mov    0x8(%eax),%edx
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 04             	mov    0x4(%eax),%eax
  803312:	8b 48 08             	mov    0x8(%eax),%ecx
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 04             	mov    0x4(%eax),%eax
  80331b:	8b 40 0c             	mov    0xc(%eax),%eax
  80331e:	01 c8                	add    %ecx,%eax
  803320:	39 c2                	cmp    %eax,%edx
  803322:	74 6f                	je     803393 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803328:	74 06                	je     803330 <insert_sorted_with_merge_freeList+0x3d7>
  80332a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332e:	75 17                	jne    803347 <insert_sorted_with_merge_freeList+0x3ee>
  803330:	83 ec 04             	sub    $0x4,%esp
  803333:	68 24 43 80 00       	push   $0x804324
  803338:	68 6b 01 00 00       	push   $0x16b
  80333d:	68 e7 42 80 00       	push   $0x8042e7
  803342:	e8 4a d4 ff ff       	call   800791 <_panic>
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	8b 50 04             	mov    0x4(%eax),%edx
  80334d:	8b 45 08             	mov    0x8(%ebp),%eax
  803350:	89 50 04             	mov    %edx,0x4(%eax)
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803359:	89 10                	mov    %edx,(%eax)
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0d                	je     803372 <insert_sorted_with_merge_freeList+0x419>
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	8b 55 08             	mov    0x8(%ebp),%edx
  80336e:	89 10                	mov    %edx,(%eax)
  803370:	eb 08                	jmp    80337a <insert_sorted_with_merge_freeList+0x421>
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	a3 38 51 80 00       	mov    %eax,0x805138
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 55 08             	mov    0x8(%ebp),%edx
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	a1 44 51 80 00       	mov    0x805144,%eax
  803388:	40                   	inc    %eax
  803389:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80338e:	e9 d3 03 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803396:	8b 50 08             	mov    0x8(%eax),%edx
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 40 08             	mov    0x8(%eax),%eax
  80339f:	39 c2                	cmp    %eax,%edx
  8033a1:	0f 86 da 00 00 00    	jbe    803481 <insert_sorted_with_merge_freeList+0x528>
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 50 08             	mov    0x8(%eax),%edx
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 48 08             	mov    0x8(%eax),%ecx
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b9:	01 c8                	add    %ecx,%eax
  8033bb:	39 c2                	cmp    %eax,%edx
  8033bd:	0f 85 be 00 00 00    	jne    803481 <insert_sorted_with_merge_freeList+0x528>
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	8b 50 08             	mov    0x8(%eax),%edx
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 40 04             	mov    0x4(%eax),%eax
  8033cf:	8b 48 08             	mov    0x8(%eax),%ecx
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 40 04             	mov    0x4(%eax),%eax
  8033d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033db:	01 c8                	add    %ecx,%eax
  8033dd:	39 c2                	cmp    %eax,%edx
  8033df:	0f 84 9c 00 00 00    	je     803481 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	8b 50 08             	mov    0x8(%eax),%edx
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fd:	01 c2                	add    %eax,%edx
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341d:	75 17                	jne    803436 <insert_sorted_with_merge_freeList+0x4dd>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 c4 42 80 00       	push   $0x8042c4
  803427:	68 74 01 00 00       	push   $0x174
  80342c:	68 e7 42 80 00       	push   $0x8042e7
  803431:	e8 5b d3 ff ff       	call   800791 <_panic>
  803436:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	89 10                	mov    %edx,(%eax)
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0d                	je     803457 <insert_sorted_with_merge_freeList+0x4fe>
  80344a:	a1 48 51 80 00       	mov    0x805148,%eax
  80344f:	8b 55 08             	mov    0x8(%ebp),%edx
  803452:	89 50 04             	mov    %edx,0x4(%eax)
  803455:	eb 08                	jmp    80345f <insert_sorted_with_merge_freeList+0x506>
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	a3 48 51 80 00       	mov    %eax,0x805148
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803471:	a1 54 51 80 00       	mov    0x805154,%eax
  803476:	40                   	inc    %eax
  803477:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80347c:	e9 e5 02 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	8b 50 08             	mov    0x8(%eax),%edx
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	8b 40 08             	mov    0x8(%eax),%eax
  80348d:	39 c2                	cmp    %eax,%edx
  80348f:	0f 86 d7 00 00 00    	jbe    80356c <insert_sorted_with_merge_freeList+0x613>
  803495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803498:	8b 50 08             	mov    0x8(%eax),%edx
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	8b 48 08             	mov    0x8(%eax),%ecx
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a7:	01 c8                	add    %ecx,%eax
  8034a9:	39 c2                	cmp    %eax,%edx
  8034ab:	0f 84 bb 00 00 00    	je     80356c <insert_sorted_with_merge_freeList+0x613>
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	8b 50 08             	mov    0x8(%eax),%edx
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 40 04             	mov    0x4(%eax),%eax
  8034bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	8b 40 04             	mov    0x4(%eax),%eax
  8034c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c9:	01 c8                	add    %ecx,%eax
  8034cb:	39 c2                	cmp    %eax,%edx
  8034cd:	0f 85 99 00 00 00    	jne    80356c <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8034dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034df:	8b 50 0c             	mov    0xc(%eax),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e8:	01 c2                	add    %eax,%edx
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803508:	75 17                	jne    803521 <insert_sorted_with_merge_freeList+0x5c8>
  80350a:	83 ec 04             	sub    $0x4,%esp
  80350d:	68 c4 42 80 00       	push   $0x8042c4
  803512:	68 7d 01 00 00       	push   $0x17d
  803517:	68 e7 42 80 00       	push   $0x8042e7
  80351c:	e8 70 d2 ff ff       	call   800791 <_panic>
  803521:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	89 10                	mov    %edx,(%eax)
  80352c:	8b 45 08             	mov    0x8(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	85 c0                	test   %eax,%eax
  803533:	74 0d                	je     803542 <insert_sorted_with_merge_freeList+0x5e9>
  803535:	a1 48 51 80 00       	mov    0x805148,%eax
  80353a:	8b 55 08             	mov    0x8(%ebp),%edx
  80353d:	89 50 04             	mov    %edx,0x4(%eax)
  803540:	eb 08                	jmp    80354a <insert_sorted_with_merge_freeList+0x5f1>
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	a3 48 51 80 00       	mov    %eax,0x805148
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355c:	a1 54 51 80 00       	mov    0x805154,%eax
  803561:	40                   	inc    %eax
  803562:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803567:	e9 fa 01 00 00       	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 50 08             	mov    0x8(%eax),%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	8b 40 08             	mov    0x8(%eax),%eax
  803578:	39 c2                	cmp    %eax,%edx
  80357a:	0f 86 d2 01 00 00    	jbe    803752 <insert_sorted_with_merge_freeList+0x7f9>
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 50 08             	mov    0x8(%eax),%edx
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	8b 48 08             	mov    0x8(%eax),%ecx
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	8b 40 0c             	mov    0xc(%eax),%eax
  803592:	01 c8                	add    %ecx,%eax
  803594:	39 c2                	cmp    %eax,%edx
  803596:	0f 85 b6 01 00 00    	jne    803752 <insert_sorted_with_merge_freeList+0x7f9>
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	8b 50 08             	mov    0x8(%eax),%edx
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 40 04             	mov    0x4(%eax),%eax
  8035a8:	8b 48 08             	mov    0x8(%eax),%ecx
  8035ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ae:	8b 40 04             	mov    0x4(%eax),%eax
  8035b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b4:	01 c8                	add    %ecx,%eax
  8035b6:	39 c2                	cmp    %eax,%edx
  8035b8:	0f 85 94 01 00 00    	jne    803752 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 40 04             	mov    0x4(%eax),%eax
  8035c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035c7:	8b 52 04             	mov    0x4(%edx),%edx
  8035ca:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8035cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d0:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8035d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d6:	8b 52 0c             	mov    0xc(%edx),%edx
  8035d9:	01 da                	add    %ebx,%edx
  8035db:	01 ca                	add    %ecx,%edx
  8035dd:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8035e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8035f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f8:	75 17                	jne    803611 <insert_sorted_with_merge_freeList+0x6b8>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 59 43 80 00       	push   $0x804359
  803602:	68 86 01 00 00       	push   $0x186
  803607:	68 e7 42 80 00       	push   $0x8042e7
  80360c:	e8 80 d1 ff ff       	call   800791 <_panic>
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	8b 00                	mov    (%eax),%eax
  803616:	85 c0                	test   %eax,%eax
  803618:	74 10                	je     80362a <insert_sorted_with_merge_freeList+0x6d1>
  80361a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361d:	8b 00                	mov    (%eax),%eax
  80361f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803622:	8b 52 04             	mov    0x4(%edx),%edx
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	eb 0b                	jmp    803635 <insert_sorted_with_merge_freeList+0x6dc>
  80362a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362d:	8b 40 04             	mov    0x4(%eax),%eax
  803630:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	85 c0                	test   %eax,%eax
  80363d:	74 0f                	je     80364e <insert_sorted_with_merge_freeList+0x6f5>
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	8b 40 04             	mov    0x4(%eax),%eax
  803645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803648:	8b 12                	mov    (%edx),%edx
  80364a:	89 10                	mov    %edx,(%eax)
  80364c:	eb 0a                	jmp    803658 <insert_sorted_with_merge_freeList+0x6ff>
  80364e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803651:	8b 00                	mov    (%eax),%eax
  803653:	a3 38 51 80 00       	mov    %eax,0x805138
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366b:	a1 44 51 80 00       	mov    0x805144,%eax
  803670:	48                   	dec    %eax
  803671:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367a:	75 17                	jne    803693 <insert_sorted_with_merge_freeList+0x73a>
  80367c:	83 ec 04             	sub    $0x4,%esp
  80367f:	68 c4 42 80 00       	push   $0x8042c4
  803684:	68 87 01 00 00       	push   $0x187
  803689:	68 e7 42 80 00       	push   $0x8042e7
  80368e:	e8 fe d0 ff ff       	call   800791 <_panic>
  803693:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369c:	89 10                	mov    %edx,(%eax)
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	8b 00                	mov    (%eax),%eax
  8036a3:	85 c0                	test   %eax,%eax
  8036a5:	74 0d                	je     8036b4 <insert_sorted_with_merge_freeList+0x75b>
  8036a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036af:	89 50 04             	mov    %edx,0x4(%eax)
  8036b2:	eb 08                	jmp    8036bc <insert_sorted_with_merge_freeList+0x763>
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8036d3:	40                   	inc    %eax
  8036d4:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f1:	75 17                	jne    80370a <insert_sorted_with_merge_freeList+0x7b1>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 c4 42 80 00       	push   $0x8042c4
  8036fb:	68 8a 01 00 00       	push   $0x18a
  803700:	68 e7 42 80 00       	push   $0x8042e7
  803705:	e8 87 d0 ff ff       	call   800791 <_panic>
  80370a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	89 10                	mov    %edx,(%eax)
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 0d                	je     80372b <insert_sorted_with_merge_freeList+0x7d2>
  80371e:	a1 48 51 80 00       	mov    0x805148,%eax
  803723:	8b 55 08             	mov    0x8(%ebp),%edx
  803726:	89 50 04             	mov    %edx,0x4(%eax)
  803729:	eb 08                	jmp    803733 <insert_sorted_with_merge_freeList+0x7da>
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	a3 48 51 80 00       	mov    %eax,0x805148
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803745:	a1 54 51 80 00       	mov    0x805154,%eax
  80374a:	40                   	inc    %eax
  80374b:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803750:	eb 14                	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80375a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80375e:	0f 85 72 fb ff ff    	jne    8032d6 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803764:	eb 00                	jmp    803766 <insert_sorted_with_merge_freeList+0x80d>
  803766:	90                   	nop
  803767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80376a:	c9                   	leave  
  80376b:	c3                   	ret    

0080376c <__udivdi3>:
  80376c:	55                   	push   %ebp
  80376d:	57                   	push   %edi
  80376e:	56                   	push   %esi
  80376f:	53                   	push   %ebx
  803770:	83 ec 1c             	sub    $0x1c,%esp
  803773:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803777:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80377b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80377f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803783:	89 ca                	mov    %ecx,%edx
  803785:	89 f8                	mov    %edi,%eax
  803787:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80378b:	85 f6                	test   %esi,%esi
  80378d:	75 2d                	jne    8037bc <__udivdi3+0x50>
  80378f:	39 cf                	cmp    %ecx,%edi
  803791:	77 65                	ja     8037f8 <__udivdi3+0x8c>
  803793:	89 fd                	mov    %edi,%ebp
  803795:	85 ff                	test   %edi,%edi
  803797:	75 0b                	jne    8037a4 <__udivdi3+0x38>
  803799:	b8 01 00 00 00       	mov    $0x1,%eax
  80379e:	31 d2                	xor    %edx,%edx
  8037a0:	f7 f7                	div    %edi
  8037a2:	89 c5                	mov    %eax,%ebp
  8037a4:	31 d2                	xor    %edx,%edx
  8037a6:	89 c8                	mov    %ecx,%eax
  8037a8:	f7 f5                	div    %ebp
  8037aa:	89 c1                	mov    %eax,%ecx
  8037ac:	89 d8                	mov    %ebx,%eax
  8037ae:	f7 f5                	div    %ebp
  8037b0:	89 cf                	mov    %ecx,%edi
  8037b2:	89 fa                	mov    %edi,%edx
  8037b4:	83 c4 1c             	add    $0x1c,%esp
  8037b7:	5b                   	pop    %ebx
  8037b8:	5e                   	pop    %esi
  8037b9:	5f                   	pop    %edi
  8037ba:	5d                   	pop    %ebp
  8037bb:	c3                   	ret    
  8037bc:	39 ce                	cmp    %ecx,%esi
  8037be:	77 28                	ja     8037e8 <__udivdi3+0x7c>
  8037c0:	0f bd fe             	bsr    %esi,%edi
  8037c3:	83 f7 1f             	xor    $0x1f,%edi
  8037c6:	75 40                	jne    803808 <__udivdi3+0x9c>
  8037c8:	39 ce                	cmp    %ecx,%esi
  8037ca:	72 0a                	jb     8037d6 <__udivdi3+0x6a>
  8037cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037d0:	0f 87 9e 00 00 00    	ja     803874 <__udivdi3+0x108>
  8037d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037db:	89 fa                	mov    %edi,%edx
  8037dd:	83 c4 1c             	add    $0x1c,%esp
  8037e0:	5b                   	pop    %ebx
  8037e1:	5e                   	pop    %esi
  8037e2:	5f                   	pop    %edi
  8037e3:	5d                   	pop    %ebp
  8037e4:	c3                   	ret    
  8037e5:	8d 76 00             	lea    0x0(%esi),%esi
  8037e8:	31 ff                	xor    %edi,%edi
  8037ea:	31 c0                	xor    %eax,%eax
  8037ec:	89 fa                	mov    %edi,%edx
  8037ee:	83 c4 1c             	add    $0x1c,%esp
  8037f1:	5b                   	pop    %ebx
  8037f2:	5e                   	pop    %esi
  8037f3:	5f                   	pop    %edi
  8037f4:	5d                   	pop    %ebp
  8037f5:	c3                   	ret    
  8037f6:	66 90                	xchg   %ax,%ax
  8037f8:	89 d8                	mov    %ebx,%eax
  8037fa:	f7 f7                	div    %edi
  8037fc:	31 ff                	xor    %edi,%edi
  8037fe:	89 fa                	mov    %edi,%edx
  803800:	83 c4 1c             	add    $0x1c,%esp
  803803:	5b                   	pop    %ebx
  803804:	5e                   	pop    %esi
  803805:	5f                   	pop    %edi
  803806:	5d                   	pop    %ebp
  803807:	c3                   	ret    
  803808:	bd 20 00 00 00       	mov    $0x20,%ebp
  80380d:	89 eb                	mov    %ebp,%ebx
  80380f:	29 fb                	sub    %edi,%ebx
  803811:	89 f9                	mov    %edi,%ecx
  803813:	d3 e6                	shl    %cl,%esi
  803815:	89 c5                	mov    %eax,%ebp
  803817:	88 d9                	mov    %bl,%cl
  803819:	d3 ed                	shr    %cl,%ebp
  80381b:	89 e9                	mov    %ebp,%ecx
  80381d:	09 f1                	or     %esi,%ecx
  80381f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803823:	89 f9                	mov    %edi,%ecx
  803825:	d3 e0                	shl    %cl,%eax
  803827:	89 c5                	mov    %eax,%ebp
  803829:	89 d6                	mov    %edx,%esi
  80382b:	88 d9                	mov    %bl,%cl
  80382d:	d3 ee                	shr    %cl,%esi
  80382f:	89 f9                	mov    %edi,%ecx
  803831:	d3 e2                	shl    %cl,%edx
  803833:	8b 44 24 08          	mov    0x8(%esp),%eax
  803837:	88 d9                	mov    %bl,%cl
  803839:	d3 e8                	shr    %cl,%eax
  80383b:	09 c2                	or     %eax,%edx
  80383d:	89 d0                	mov    %edx,%eax
  80383f:	89 f2                	mov    %esi,%edx
  803841:	f7 74 24 0c          	divl   0xc(%esp)
  803845:	89 d6                	mov    %edx,%esi
  803847:	89 c3                	mov    %eax,%ebx
  803849:	f7 e5                	mul    %ebp
  80384b:	39 d6                	cmp    %edx,%esi
  80384d:	72 19                	jb     803868 <__udivdi3+0xfc>
  80384f:	74 0b                	je     80385c <__udivdi3+0xf0>
  803851:	89 d8                	mov    %ebx,%eax
  803853:	31 ff                	xor    %edi,%edi
  803855:	e9 58 ff ff ff       	jmp    8037b2 <__udivdi3+0x46>
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803860:	89 f9                	mov    %edi,%ecx
  803862:	d3 e2                	shl    %cl,%edx
  803864:	39 c2                	cmp    %eax,%edx
  803866:	73 e9                	jae    803851 <__udivdi3+0xe5>
  803868:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80386b:	31 ff                	xor    %edi,%edi
  80386d:	e9 40 ff ff ff       	jmp    8037b2 <__udivdi3+0x46>
  803872:	66 90                	xchg   %ax,%ax
  803874:	31 c0                	xor    %eax,%eax
  803876:	e9 37 ff ff ff       	jmp    8037b2 <__udivdi3+0x46>
  80387b:	90                   	nop

0080387c <__umoddi3>:
  80387c:	55                   	push   %ebp
  80387d:	57                   	push   %edi
  80387e:	56                   	push   %esi
  80387f:	53                   	push   %ebx
  803880:	83 ec 1c             	sub    $0x1c,%esp
  803883:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803887:	8b 74 24 34          	mov    0x34(%esp),%esi
  80388b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80388f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803897:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80389b:	89 f3                	mov    %esi,%ebx
  80389d:	89 fa                	mov    %edi,%edx
  80389f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038a3:	89 34 24             	mov    %esi,(%esp)
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	75 1a                	jne    8038c4 <__umoddi3+0x48>
  8038aa:	39 f7                	cmp    %esi,%edi
  8038ac:	0f 86 a2 00 00 00    	jbe    803954 <__umoddi3+0xd8>
  8038b2:	89 c8                	mov    %ecx,%eax
  8038b4:	89 f2                	mov    %esi,%edx
  8038b6:	f7 f7                	div    %edi
  8038b8:	89 d0                	mov    %edx,%eax
  8038ba:	31 d2                	xor    %edx,%edx
  8038bc:	83 c4 1c             	add    $0x1c,%esp
  8038bf:	5b                   	pop    %ebx
  8038c0:	5e                   	pop    %esi
  8038c1:	5f                   	pop    %edi
  8038c2:	5d                   	pop    %ebp
  8038c3:	c3                   	ret    
  8038c4:	39 f0                	cmp    %esi,%eax
  8038c6:	0f 87 ac 00 00 00    	ja     803978 <__umoddi3+0xfc>
  8038cc:	0f bd e8             	bsr    %eax,%ebp
  8038cf:	83 f5 1f             	xor    $0x1f,%ebp
  8038d2:	0f 84 ac 00 00 00    	je     803984 <__umoddi3+0x108>
  8038d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038dd:	29 ef                	sub    %ebp,%edi
  8038df:	89 fe                	mov    %edi,%esi
  8038e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038e5:	89 e9                	mov    %ebp,%ecx
  8038e7:	d3 e0                	shl    %cl,%eax
  8038e9:	89 d7                	mov    %edx,%edi
  8038eb:	89 f1                	mov    %esi,%ecx
  8038ed:	d3 ef                	shr    %cl,%edi
  8038ef:	09 c7                	or     %eax,%edi
  8038f1:	89 e9                	mov    %ebp,%ecx
  8038f3:	d3 e2                	shl    %cl,%edx
  8038f5:	89 14 24             	mov    %edx,(%esp)
  8038f8:	89 d8                	mov    %ebx,%eax
  8038fa:	d3 e0                	shl    %cl,%eax
  8038fc:	89 c2                	mov    %eax,%edx
  8038fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803902:	d3 e0                	shl    %cl,%eax
  803904:	89 44 24 04          	mov    %eax,0x4(%esp)
  803908:	8b 44 24 08          	mov    0x8(%esp),%eax
  80390c:	89 f1                	mov    %esi,%ecx
  80390e:	d3 e8                	shr    %cl,%eax
  803910:	09 d0                	or     %edx,%eax
  803912:	d3 eb                	shr    %cl,%ebx
  803914:	89 da                	mov    %ebx,%edx
  803916:	f7 f7                	div    %edi
  803918:	89 d3                	mov    %edx,%ebx
  80391a:	f7 24 24             	mull   (%esp)
  80391d:	89 c6                	mov    %eax,%esi
  80391f:	89 d1                	mov    %edx,%ecx
  803921:	39 d3                	cmp    %edx,%ebx
  803923:	0f 82 87 00 00 00    	jb     8039b0 <__umoddi3+0x134>
  803929:	0f 84 91 00 00 00    	je     8039c0 <__umoddi3+0x144>
  80392f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803933:	29 f2                	sub    %esi,%edx
  803935:	19 cb                	sbb    %ecx,%ebx
  803937:	89 d8                	mov    %ebx,%eax
  803939:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80393d:	d3 e0                	shl    %cl,%eax
  80393f:	89 e9                	mov    %ebp,%ecx
  803941:	d3 ea                	shr    %cl,%edx
  803943:	09 d0                	or     %edx,%eax
  803945:	89 e9                	mov    %ebp,%ecx
  803947:	d3 eb                	shr    %cl,%ebx
  803949:	89 da                	mov    %ebx,%edx
  80394b:	83 c4 1c             	add    $0x1c,%esp
  80394e:	5b                   	pop    %ebx
  80394f:	5e                   	pop    %esi
  803950:	5f                   	pop    %edi
  803951:	5d                   	pop    %ebp
  803952:	c3                   	ret    
  803953:	90                   	nop
  803954:	89 fd                	mov    %edi,%ebp
  803956:	85 ff                	test   %edi,%edi
  803958:	75 0b                	jne    803965 <__umoddi3+0xe9>
  80395a:	b8 01 00 00 00       	mov    $0x1,%eax
  80395f:	31 d2                	xor    %edx,%edx
  803961:	f7 f7                	div    %edi
  803963:	89 c5                	mov    %eax,%ebp
  803965:	89 f0                	mov    %esi,%eax
  803967:	31 d2                	xor    %edx,%edx
  803969:	f7 f5                	div    %ebp
  80396b:	89 c8                	mov    %ecx,%eax
  80396d:	f7 f5                	div    %ebp
  80396f:	89 d0                	mov    %edx,%eax
  803971:	e9 44 ff ff ff       	jmp    8038ba <__umoddi3+0x3e>
  803976:	66 90                	xchg   %ax,%ax
  803978:	89 c8                	mov    %ecx,%eax
  80397a:	89 f2                	mov    %esi,%edx
  80397c:	83 c4 1c             	add    $0x1c,%esp
  80397f:	5b                   	pop    %ebx
  803980:	5e                   	pop    %esi
  803981:	5f                   	pop    %edi
  803982:	5d                   	pop    %ebp
  803983:	c3                   	ret    
  803984:	3b 04 24             	cmp    (%esp),%eax
  803987:	72 06                	jb     80398f <__umoddi3+0x113>
  803989:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80398d:	77 0f                	ja     80399e <__umoddi3+0x122>
  80398f:	89 f2                	mov    %esi,%edx
  803991:	29 f9                	sub    %edi,%ecx
  803993:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803997:	89 14 24             	mov    %edx,(%esp)
  80399a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80399e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039a2:	8b 14 24             	mov    (%esp),%edx
  8039a5:	83 c4 1c             	add    $0x1c,%esp
  8039a8:	5b                   	pop    %ebx
  8039a9:	5e                   	pop    %esi
  8039aa:	5f                   	pop    %edi
  8039ab:	5d                   	pop    %ebp
  8039ac:	c3                   	ret    
  8039ad:	8d 76 00             	lea    0x0(%esi),%esi
  8039b0:	2b 04 24             	sub    (%esp),%eax
  8039b3:	19 fa                	sbb    %edi,%edx
  8039b5:	89 d1                	mov    %edx,%ecx
  8039b7:	89 c6                	mov    %eax,%esi
  8039b9:	e9 71 ff ff ff       	jmp    80392f <__umoddi3+0xb3>
  8039be:	66 90                	xchg   %ax,%ax
  8039c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039c4:	72 ea                	jb     8039b0 <__umoddi3+0x134>
  8039c6:	89 d9                	mov    %ebx,%ecx
  8039c8:	e9 62 ff ff ff       	jmp    80392f <__umoddi3+0xb3>
