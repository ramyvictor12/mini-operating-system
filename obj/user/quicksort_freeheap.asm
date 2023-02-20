
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 46 1f 00 00       	call   801f94 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 58 1f 00 00       	call   801fad <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 80 39 80 00       	push   $0x803980
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 94 1a 00 00       	call   801b30 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 a0 39 80 00       	push   $0x8039a0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c3 39 80 00       	push   $0x8039c3
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 d1 39 80 00       	push   $0x8039d1
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 e0 39 80 00       	push   $0x8039e0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 f0 39 80 00       	push   $0x8039f0
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 fc 39 80 00       	push   $0x8039fc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 1e 3a 80 00       	push   $0x803a1e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 38 3a 80 00       	push   $0x803a38
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 6c 3a 80 00       	push   $0x803a6c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 a0 3a 80 00       	push   $0x803aa0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d2 3a 80 00       	push   $0x803ad2
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 3a 80 00       	push   $0x803ae8
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 06 3b 80 00       	push   $0x803b06
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 08 3b 80 00       	push   $0x803b08
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 0d 3b 80 00       	push   $0x803b0d
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 52 1b 00 00       	call   8020b5 <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 0d 1b 00 00       	call   802081 <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 2e 1b 00 00       	call   8020b5 <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 0c 1b 00 00       	call   80209b <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 56 19 00 00       	call   801efc <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 c2 1a 00 00       	call   802081 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 2f 19 00 00       	call   801efc <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 c0 1a 00 00       	call   80209b <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 7f 1c 00 00       	call   802274 <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 21 1a 00 00       	call   802081 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 2c 3b 80 00       	push   $0x803b2c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 54 3b 80 00       	push   $0x803b54
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 7c 3b 80 00       	push   $0x803b7c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 d4 3b 80 00       	push   $0x803bd4
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 2c 3b 80 00       	push   $0x803b2c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 a1 19 00 00       	call   80209b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 2e 1b 00 00       	call   802240 <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 83 1b 00 00       	call   8022a6 <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 e8 3b 80 00       	push   $0x803be8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 ed 3b 80 00       	push   $0x803bed
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 09 3c 80 00       	push   $0x803c09
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 0c 3c 80 00       	push   $0x803c0c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 58 3c 80 00       	push   $0x803c58
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 64 3c 80 00       	push   $0x803c64
  800887:	6a 3a                	push   $0x3a
  800889:	68 58 3c 80 00       	push   $0x803c58
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 b8 3c 80 00       	push   $0x803cb8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 58 3c 80 00       	push   $0x803c58
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 50 80 00       	mov    0x805028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 82 15 00 00       	call   801ed3 <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 0b 15 00 00       	call   801ed3 <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 6f 16 00 00       	call   802081 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 69 16 00 00       	call   80209b <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 88 2c 00 00       	call   803704 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 48 2d 00 00       	call   803814 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 34 3f 80 00       	add    $0x803f34,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 45 3f 80 00       	push   $0x803f45
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 4e 3f 80 00       	push   $0x803f4e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 b0 40 80 00       	push   $0x8040b0
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 b3 40 80 00       	push   $0x8040b3
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 1c 0f 00 00       	call   802081 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 b0 40 80 00       	push   $0x8040b0
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 b3 40 80 00       	push   $0x8040b3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 da 0e 00 00       	call   80209b <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 42 0e 00 00       	call   80209b <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 c4 40 80 00       	push   $0x8040c4
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8019a1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a8:	00 00 00 
  8019ab:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b2:	00 00 00 
  8019b5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019bc:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8019bf:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019c6:	00 00 00 
  8019c9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019d0:	00 00 00 
  8019d3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019da:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8019dd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019e4:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8019e7:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8019ee:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019fd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a02:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801a07:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a16:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	6a 06                	push   $0x6
  801a20:	ff 75 f4             	pushl  -0xc(%ebp)
  801a23:	50                   	push   %eax
  801a24:	e8 ee 05 00 00       	call   802017 <sys_allocate_chunk>
  801a29:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a2c:	a1 20 51 80 00       	mov    0x805120,%eax
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	50                   	push   %eax
  801a35:	e8 63 0c 00 00       	call   80269d <initialize_MemBlocksList>
  801a3a:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801a3d:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a42:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a48:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a52:	8b 40 0c             	mov    0xc(%eax),%eax
  801a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a60:	89 c2                	mov    %eax,%edx
  801a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a65:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801a68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801a72:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7c:	8b 50 08             	mov    0x8(%eax),%edx
  801a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a82:	01 d0                	add    %edx,%eax
  801a84:	48                   	dec    %eax
  801a85:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	f7 75 e0             	divl   -0x20(%ebp)
  801a93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a96:	29 d0                	sub    %edx,%eax
  801a98:	89 c2                	mov    %eax,%edx
  801a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9d:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801aa0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801aa4:	75 14                	jne    801aba <initialize_dyn_block_system+0x11f>
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 e9 40 80 00       	push   $0x8040e9
  801aae:	6a 34                	push   $0x34
  801ab0:	68 07 41 80 00       	push   $0x804107
  801ab5:	e8 6c ec ff ff       	call   800726 <_panic>
  801aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	74 10                	je     801ad3 <initialize_dyn_block_system+0x138>
  801ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801acb:	8b 52 04             	mov    0x4(%edx),%edx
  801ace:	89 50 04             	mov    %edx,0x4(%eax)
  801ad1:	eb 0b                	jmp    801ade <initialize_dyn_block_system+0x143>
  801ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad6:	8b 40 04             	mov    0x4(%eax),%eax
  801ad9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae1:	8b 40 04             	mov    0x4(%eax),%eax
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	74 0f                	je     801af7 <initialize_dyn_block_system+0x15c>
  801ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aeb:	8b 40 04             	mov    0x4(%eax),%eax
  801aee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801af1:	8b 12                	mov    (%edx),%edx
  801af3:	89 10                	mov    %edx,(%eax)
  801af5:	eb 0a                	jmp    801b01 <initialize_dyn_block_system+0x166>
  801af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801afa:	8b 00                	mov    (%eax),%eax
  801afc:	a3 48 51 80 00       	mov    %eax,0x805148
  801b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b14:	a1 54 51 80 00       	mov    0x805154,%eax
  801b19:	48                   	dec    %eax
  801b1a:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	ff 75 e8             	pushl  -0x18(%ebp)
  801b25:	e8 c4 13 00 00       	call   802eee <insert_sorted_with_merge_freeList>
  801b2a:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b36:	e8 2f fe ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3f:	75 07                	jne    801b48 <malloc+0x18>
  801b41:	b8 00 00 00 00       	mov    $0x0,%eax
  801b46:	eb 71                	jmp    801bb9 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801b48:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b4f:	76 07                	jbe    801b58 <malloc+0x28>
	return NULL;
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
  801b56:	eb 61                	jmp    801bb9 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b58:	e8 88 08 00 00       	call   8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	74 53                	je     801bb4 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b61:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b68:	8b 55 08             	mov    0x8(%ebp),%edx
  801b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6e:	01 d0                	add    %edx,%eax
  801b70:	48                   	dec    %eax
  801b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b77:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7c:	f7 75 f4             	divl   -0xc(%ebp)
  801b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b82:	29 d0                	sub    %edx,%eax
  801b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801b87:	83 ec 0c             	sub    $0xc,%esp
  801b8a:	ff 75 ec             	pushl  -0x14(%ebp)
  801b8d:	e8 d2 0d 00 00       	call   802964 <alloc_block_FF>
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801b98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b9c:	74 16                	je     801bb4 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	ff 75 e8             	pushl  -0x18(%ebp)
  801ba4:	e8 0c 0c 00 00       	call   8027b5 <insert_sorted_allocList>
  801ba9:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801baf:	8b 40 08             	mov    0x8(%eax),%eax
  801bb2:	eb 05                	jmp    801bb9 <malloc+0x89>
    }

			}


	return NULL;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd8:	68 40 50 80 00       	push   $0x805040
  801bdd:	e8 a0 0b 00 00       	call   802782 <find_block>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801beb:	8b 50 0c             	mov    0xc(%eax),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	83 ec 08             	sub    $0x8,%esp
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	e8 e4 03 00 00       	call   801fdf <sys_free_user_mem>
  801bfb:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801bfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c02:	75 17                	jne    801c1b <free+0x60>
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	68 e9 40 80 00       	push   $0x8040e9
  801c0c:	68 84 00 00 00       	push   $0x84
  801c11:	68 07 41 80 00       	push   $0x804107
  801c16:	e8 0b eb ff ff       	call   800726 <_panic>
  801c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1e:	8b 00                	mov    (%eax),%eax
  801c20:	85 c0                	test   %eax,%eax
  801c22:	74 10                	je     801c34 <free+0x79>
  801c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c27:	8b 00                	mov    (%eax),%eax
  801c29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c2c:	8b 52 04             	mov    0x4(%edx),%edx
  801c2f:	89 50 04             	mov    %edx,0x4(%eax)
  801c32:	eb 0b                	jmp    801c3f <free+0x84>
  801c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c37:	8b 40 04             	mov    0x4(%eax),%eax
  801c3a:	a3 44 50 80 00       	mov    %eax,0x805044
  801c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c42:	8b 40 04             	mov    0x4(%eax),%eax
  801c45:	85 c0                	test   %eax,%eax
  801c47:	74 0f                	je     801c58 <free+0x9d>
  801c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4c:	8b 40 04             	mov    0x4(%eax),%eax
  801c4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c52:	8b 12                	mov    (%edx),%edx
  801c54:	89 10                	mov    %edx,(%eax)
  801c56:	eb 0a                	jmp    801c62 <free+0xa7>
  801c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5b:	8b 00                	mov    (%eax),%eax
  801c5d:	a3 40 50 80 00       	mov    %eax,0x805040
  801c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c75:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c7a:	48                   	dec    %eax
  801c7b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	ff 75 ec             	pushl  -0x14(%ebp)
  801c86:	e8 63 12 00 00       	call   802eee <insert_sorted_with_merge_freeList>
  801c8b:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801c8e:	90                   	nop
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 38             	sub    $0x38,%esp
  801c97:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c9d:	e8 c8 fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ca2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ca6:	75 0a                	jne    801cb2 <smalloc+0x21>
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cad:	e9 a0 00 00 00       	jmp    801d52 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801cb2:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801cb9:	76 0a                	jbe    801cc5 <smalloc+0x34>
		return NULL;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	e9 8d 00 00 00       	jmp    801d52 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cc5:	e8 1b 07 00 00       	call   8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	74 7f                	je     801d4d <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801cce:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdb:	01 d0                	add    %edx,%eax
  801cdd:	48                   	dec    %eax
  801cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce9:	f7 75 f4             	divl   -0xc(%ebp)
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	29 d0                	sub    %edx,%eax
  801cf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cfa:	e8 65 0c 00 00       	call   802964 <alloc_block_FF>
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801d05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d09:	74 42                	je     801d4d <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	ff 75 e8             	pushl  -0x18(%ebp)
  801d11:	e8 9f 0a 00 00       	call   8027b5 <insert_sorted_allocList>
  801d16:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d1c:	8b 40 08             	mov    0x8(%eax),%eax
  801d1f:	89 c2                	mov    %eax,%edx
  801d21:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	ff 75 0c             	pushl  0xc(%ebp)
  801d2a:	ff 75 08             	pushl  0x8(%ebp)
  801d2d:	e8 38 04 00 00       	call   80216a <sys_createSharedObject>
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801d38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d3c:	79 07                	jns    801d45 <smalloc+0xb4>
	    		  return NULL;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d43:	eb 0d                	jmp    801d52 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801d45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d48:	8b 40 08             	mov    0x8(%eax),%eax
  801d4b:	eb 05                	jmp    801d52 <smalloc+0xc1>


				}


		return NULL;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d5a:	e8 0b fc ff ff       	call   80196a <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d5f:	e8 81 06 00 00       	call   8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d64:	85 c0                	test   %eax,%eax
  801d66:	0f 84 9f 00 00 00    	je     801e0b <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	e8 1a 04 00 00       	call   802194 <sys_getSizeOfSharedObject>
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d84:	79 0a                	jns    801d90 <sget+0x3c>
		return NULL;
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8b:	e9 80 00 00 00       	jmp    801e10 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d90:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9d:	01 d0                	add    %edx,%eax
  801d9f:	48                   	dec    %eax
  801da0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da6:	ba 00 00 00 00       	mov    $0x0,%edx
  801dab:	f7 75 f0             	divl   -0x10(%ebp)
  801dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db1:	29 d0                	sub    %edx,%eax
  801db3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801db6:	83 ec 0c             	sub    $0xc,%esp
  801db9:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbc:	e8 a3 0b 00 00       	call   802964 <alloc_block_FF>
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801dc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dcb:	74 3e                	je     801e0b <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dd3:	e8 dd 09 00 00       	call   8027b5 <insert_sorted_allocList>
  801dd8:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dde:	8b 40 08             	mov    0x8(%eax),%eax
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	50                   	push   %eax
  801de5:	ff 75 0c             	pushl  0xc(%ebp)
  801de8:	ff 75 08             	pushl  0x8(%ebp)
  801deb:	e8 c1 03 00 00       	call   8021b1 <sys_getSharedObject>
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801df6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dfa:	79 07                	jns    801e03 <sget+0xaf>
	    		  return NULL;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	eb 0d                	jmp    801e10 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e06:	8b 40 08             	mov    0x8(%eax),%eax
  801e09:	eb 05                	jmp    801e10 <sget+0xbc>
	      }
	}
	   return NULL;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e18:	e8 4d fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	68 14 41 80 00       	push   $0x804114
  801e25:	68 12 01 00 00       	push   $0x112
  801e2a:	68 07 41 80 00       	push   $0x804107
  801e2f:	e8 f2 e8 ff ff       	call   800726 <_panic>

00801e34 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	68 3c 41 80 00       	push   $0x80413c
  801e42:	68 26 01 00 00       	push   $0x126
  801e47:	68 07 41 80 00       	push   $0x804107
  801e4c:	e8 d5 e8 ff ff       	call   800726 <_panic>

00801e51 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 60 41 80 00       	push   $0x804160
  801e5f:	68 31 01 00 00       	push   $0x131
  801e64:	68 07 41 80 00       	push   $0x804107
  801e69:	e8 b8 e8 ff ff       	call   800726 <_panic>

00801e6e <shrink>:

}
void shrink(uint32 newSize)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 60 41 80 00       	push   $0x804160
  801e7c:	68 36 01 00 00       	push   $0x136
  801e81:	68 07 41 80 00       	push   $0x804107
  801e86:	e8 9b e8 ff ff       	call   800726 <_panic>

00801e8b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e91:	83 ec 04             	sub    $0x4,%esp
  801e94:	68 60 41 80 00       	push   $0x804160
  801e99:	68 3b 01 00 00       	push   $0x13b
  801e9e:	68 07 41 80 00       	push   $0x804107
  801ea3:	e8 7e e8 ff ff       	call   800726 <_panic>

00801ea8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	57                   	push   %edi
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
  801eae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ebd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ec0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ec3:	cd 30                	int    $0x30
  801ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5e                   	pop    %esi
  801ed0:	5f                   	pop    %edi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    

00801ed3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 04             	sub    $0x4,%esp
  801ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  801edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801edf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	52                   	push   %edx
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	50                   	push   %eax
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 b2 ff ff ff       	call   801ea8 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	90                   	nop
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_cgetc>:

int
sys_cgetc(void)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 01                	push   $0x1
  801f0b:	e8 98 ff ff ff       	call   801ea8 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 05                	push   $0x5
  801f28:	e8 7b ff ff ff       	call   801ea8 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f37:	8b 75 18             	mov    0x18(%ebp),%esi
  801f3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	51                   	push   %ecx
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 06                	push   $0x6
  801f4d:	e8 56 ff ff ff       	call   801ea8 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	52                   	push   %edx
  801f6c:	50                   	push   %eax
  801f6d:	6a 07                	push   $0x7
  801f6f:	e8 34 ff ff ff       	call   801ea8 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	6a 08                	push   $0x8
  801f8a:	e8 19 ff ff ff       	call   801ea8 <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 09                	push   $0x9
  801fa3:	e8 00 ff ff ff       	call   801ea8 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 0a                	push   $0xa
  801fbc:	e8 e7 fe ff ff       	call   801ea8 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 0b                	push   $0xb
  801fd5:	e8 ce fe ff ff       	call   801ea8 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	6a 0f                	push   $0xf
  801ff0:	e8 b3 fe ff ff       	call   801ea8 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
	return;
  801ff8:	90                   	nop
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	6a 10                	push   $0x10
  80200c:	e8 97 fe ff ff       	call   801ea8 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
	return ;
  802014:	90                   	nop
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	ff 75 10             	pushl  0x10(%ebp)
  802021:	ff 75 0c             	pushl  0xc(%ebp)
  802024:	ff 75 08             	pushl  0x8(%ebp)
  802027:	6a 11                	push   $0x11
  802029:	e8 7a fe ff ff       	call   801ea8 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
	return ;
  802031:	90                   	nop
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 0c                	push   $0xc
  802043:	e8 60 fe ff ff       	call   801ea8 <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	6a 0d                	push   $0xd
  80205d:	e8 46 fe ff ff       	call   801ea8 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 0e                	push   $0xe
  802076:	e8 2d fe ff ff       	call   801ea8 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 13                	push   $0x13
  802090:	e8 13 fe ff ff       	call   801ea8 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	90                   	nop
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 14                	push   $0x14
  8020aa:	e8 f9 fd ff ff       	call   801ea8 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	90                   	nop
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	50                   	push   %eax
  8020ce:	6a 15                	push   $0x15
  8020d0:	e8 d3 fd ff ff       	call   801ea8 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 16                	push   $0x16
  8020ea:	e8 b9 fd ff ff       	call   801ea8 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	90                   	nop
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	50                   	push   %eax
  802105:	6a 17                	push   $0x17
  802107:	e8 9c fd ff ff       	call   801ea8 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	52                   	push   %edx
  802121:	50                   	push   %eax
  802122:	6a 1a                	push   $0x1a
  802124:	e8 7f fd ff ff       	call   801ea8 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	52                   	push   %edx
  80213e:	50                   	push   %eax
  80213f:	6a 18                	push   $0x18
  802141:	e8 62 fd ff ff       	call   801ea8 <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	90                   	nop
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 19                	push   $0x19
  80215f:	e8 44 fd ff ff       	call   801ea8 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	90                   	nop
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	8b 45 10             	mov    0x10(%ebp),%eax
  802173:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802176:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802179:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	6a 00                	push   $0x0
  802182:	51                   	push   %ecx
  802183:	52                   	push   %edx
  802184:	ff 75 0c             	pushl  0xc(%ebp)
  802187:	50                   	push   %eax
  802188:	6a 1b                	push   $0x1b
  80218a:	e8 19 fd ff ff       	call   801ea8 <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	52                   	push   %edx
  8021a4:	50                   	push   %eax
  8021a5:	6a 1c                	push   $0x1c
  8021a7:	e8 fc fc ff ff       	call   801ea8 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	51                   	push   %ecx
  8021c2:	52                   	push   %edx
  8021c3:	50                   	push   %eax
  8021c4:	6a 1d                	push   $0x1d
  8021c6:	e8 dd fc ff ff       	call   801ea8 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	6a 1e                	push   $0x1e
  8021e3:	e8 c0 fc ff ff       	call   801ea8 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 1f                	push   $0x1f
  8021fc:	e8 a7 fc ff ff       	call   801ea8 <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	6a 00                	push   $0x0
  80220e:	ff 75 14             	pushl  0x14(%ebp)
  802211:	ff 75 10             	pushl  0x10(%ebp)
  802214:	ff 75 0c             	pushl  0xc(%ebp)
  802217:	50                   	push   %eax
  802218:	6a 20                	push   $0x20
  80221a:	e8 89 fc ff ff       	call   801ea8 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	50                   	push   %eax
  802233:	6a 21                	push   $0x21
  802235:	e8 6e fc ff ff       	call   801ea8 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	90                   	nop
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	50                   	push   %eax
  80224f:	6a 22                	push   $0x22
  802251:	e8 52 fc ff ff       	call   801ea8 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 02                	push   $0x2
  80226a:	e8 39 fc ff ff       	call   801ea8 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 03                	push   $0x3
  802283:	e8 20 fc ff ff       	call   801ea8 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 04                	push   $0x4
  80229c:	e8 07 fc ff ff       	call   801ea8 <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 23                	push   $0x23
  8022b5:	e8 ee fb ff ff       	call   801ea8 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022c9:	8d 50 04             	lea    0x4(%eax),%edx
  8022cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	6a 24                	push   $0x24
  8022d9:	e8 ca fb ff ff       	call   801ea8 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
	return result;
  8022e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ea:	89 01                	mov    %eax,(%ecx)
  8022ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	c9                   	leave  
  8022f3:	c2 04 00             	ret    $0x4

008022f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	ff 75 10             	pushl  0x10(%ebp)
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	6a 12                	push   $0x12
  802308:	e8 9b fb ff ff       	call   801ea8 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
	return ;
  802310:	90                   	nop
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_rcr2>:
uint32 sys_rcr2()
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 25                	push   $0x25
  802322:	e8 81 fb ff ff       	call   801ea8 <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802338:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	50                   	push   %eax
  802345:	6a 26                	push   $0x26
  802347:	e8 5c fb ff ff       	call   801ea8 <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
	return ;
  80234f:	90                   	nop
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <rsttst>:
void rsttst()
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 28                	push   $0x28
  802361:	e8 42 fb ff ff       	call   801ea8 <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
	return ;
  802369:	90                   	nop
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	8b 45 14             	mov    0x14(%ebp),%eax
  802375:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802378:	8b 55 18             	mov    0x18(%ebp),%edx
  80237b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80237f:	52                   	push   %edx
  802380:	50                   	push   %eax
  802381:	ff 75 10             	pushl  0x10(%ebp)
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	6a 27                	push   $0x27
  80238c:	e8 17 fb ff ff       	call   801ea8 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
	return ;
  802394:	90                   	nop
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <chktst>:
void chktst(uint32 n)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	6a 29                	push   $0x29
  8023a7:	e8 fc fa ff ff       	call   801ea8 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8023af:	90                   	nop
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <inctst>:

void inctst()
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 2a                	push   $0x2a
  8023c1:	e8 e2 fa ff ff       	call   801ea8 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c9:	90                   	nop
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <gettst>:
uint32 gettst()
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 2b                	push   $0x2b
  8023db:	e8 c8 fa ff ff       	call   801ea8 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 2c                	push   $0x2c
  8023f7:	e8 ac fa ff ff       	call   801ea8 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
  8023ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802402:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802406:	75 07                	jne    80240f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802408:	b8 01 00 00 00       	mov    $0x1,%eax
  80240d:	eb 05                	jmp    802414 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 2c                	push   $0x2c
  802428:	e8 7b fa ff ff       	call   801ea8 <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
  802430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802433:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802437:	75 07                	jne    802440 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802439:	b8 01 00 00 00       	mov    $0x1,%eax
  80243e:	eb 05                	jmp    802445 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 2c                	push   $0x2c
  802459:	e8 4a fa ff ff       	call   801ea8 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
  802461:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802464:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802468:	75 07                	jne    802471 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80246a:	b8 01 00 00 00       	mov    $0x1,%eax
  80246f:	eb 05                	jmp    802476 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 2c                	push   $0x2c
  80248a:	e8 19 fa ff ff       	call   801ea8 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
  802492:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802495:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802499:	75 07                	jne    8024a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80249b:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a0:	eb 05                	jmp    8024a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	ff 75 08             	pushl  0x8(%ebp)
  8024b7:	6a 2d                	push   $0x2d
  8024b9:	e8 ea f9 ff ff       	call   801ea8 <syscall>
  8024be:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c1:	90                   	nop
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	53                   	push   %ebx
  8024d7:	51                   	push   %ecx
  8024d8:	52                   	push   %edx
  8024d9:	50                   	push   %eax
  8024da:	6a 2e                	push   $0x2e
  8024dc:	e8 c7 f9 ff ff       	call   801ea8 <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	6a 2f                	push   $0x2f
  8024fc:	e8 a7 f9 ff ff       	call   801ea8 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	68 70 41 80 00       	push   $0x804170
  802514:	e8 c1 e4 ff ff       	call   8009da <cprintf>
  802519:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80251c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	68 9c 41 80 00       	push   $0x80419c
  80252b:	e8 aa e4 ff ff       	call   8009da <cprintf>
  802530:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802533:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802537:	a1 38 51 80 00       	mov    0x805138,%eax
  80253c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253f:	eb 56                	jmp    802597 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802545:	74 1c                	je     802563 <print_mem_block_lists+0x5d>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	8b 48 08             	mov    0x8(%eax),%ecx
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	8b 40 0c             	mov    0xc(%eax),%eax
  802559:	01 c8                	add    %ecx,%eax
  80255b:	39 c2                	cmp    %eax,%edx
  80255d:	73 04                	jae    802563 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80255f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 50 08             	mov    0x8(%eax),%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 0c             	mov    0xc(%eax),%eax
  80256f:	01 c2                	add    %eax,%edx
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 40 08             	mov    0x8(%eax),%eax
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	52                   	push   %edx
  80257b:	50                   	push   %eax
  80257c:	68 b1 41 80 00       	push   $0x8041b1
  802581:	e8 54 e4 ff ff       	call   8009da <cprintf>
  802586:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80258f:	a1 40 51 80 00       	mov    0x805140,%eax
  802594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259b:	74 07                	je     8025a4 <print_mem_block_lists+0x9e>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	eb 05                	jmp    8025a9 <print_mem_block_lists+0xa3>
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	75 8a                	jne    802541 <print_mem_block_lists+0x3b>
  8025b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bb:	75 84                	jne    802541 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025c1:	75 10                	jne    8025d3 <print_mem_block_lists+0xcd>
  8025c3:	83 ec 0c             	sub    $0xc,%esp
  8025c6:	68 c0 41 80 00       	push   $0x8041c0
  8025cb:	e8 0a e4 ff ff       	call   8009da <cprintf>
  8025d0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025da:	83 ec 0c             	sub    $0xc,%esp
  8025dd:	68 e4 41 80 00       	push   $0x8041e4
  8025e2:	e8 f3 e3 ff ff       	call   8009da <cprintf>
  8025e7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f6:	eb 56                	jmp    80264e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fc:	74 1c                	je     80261a <print_mem_block_lists+0x114>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 50 08             	mov    0x8(%eax),%edx
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 48 08             	mov    0x8(%eax),%ecx
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	8b 40 0c             	mov    0xc(%eax),%eax
  802610:	01 c8                	add    %ecx,%eax
  802612:	39 c2                	cmp    %eax,%edx
  802614:	73 04                	jae    80261a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802616:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 50 08             	mov    0x8(%eax),%edx
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	01 c2                	add    %eax,%edx
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 08             	mov    0x8(%eax),%eax
  80262e:	83 ec 04             	sub    $0x4,%esp
  802631:	52                   	push   %edx
  802632:	50                   	push   %eax
  802633:	68 b1 41 80 00       	push   $0x8041b1
  802638:	e8 9d e3 ff ff       	call   8009da <cprintf>
  80263d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802646:	a1 48 50 80 00       	mov    0x805048,%eax
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	74 07                	je     80265b <print_mem_block_lists+0x155>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	eb 05                	jmp    802660 <print_mem_block_lists+0x15a>
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
  802660:	a3 48 50 80 00       	mov    %eax,0x805048
  802665:	a1 48 50 80 00       	mov    0x805048,%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	75 8a                	jne    8025f8 <print_mem_block_lists+0xf2>
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	75 84                	jne    8025f8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802674:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802678:	75 10                	jne    80268a <print_mem_block_lists+0x184>
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	68 fc 41 80 00       	push   $0x8041fc
  802682:	e8 53 e3 ff ff       	call   8009da <cprintf>
  802687:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	68 70 41 80 00       	push   $0x804170
  802692:	e8 43 e3 ff ff       	call   8009da <cprintf>
  802697:	83 c4 10             	add    $0x10,%esp

}
  80269a:	90                   	nop
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8026a3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026aa:	00 00 00 
  8026ad:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026b4:	00 00 00 
  8026b7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026be:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8026c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8026c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026d0:	e9 9e 00 00 00       	jmp    802773 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8026d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dd:	c1 e2 04             	shl    $0x4,%edx
  8026e0:	01 d0                	add    %edx,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	75 14                	jne    8026fa <initialize_MemBlocksList+0x5d>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 24 42 80 00       	push   $0x804224
  8026ee:	6a 48                	push   $0x48
  8026f0:	68 47 42 80 00       	push   $0x804247
  8026f5:	e8 2c e0 ff ff       	call   800726 <_panic>
  8026fa:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802702:	c1 e2 04             	shl    $0x4,%edx
  802705:	01 d0                	add    %edx,%eax
  802707:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80270d:	89 10                	mov    %edx,(%eax)
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 18                	je     80272d <initialize_MemBlocksList+0x90>
  802715:	a1 48 51 80 00       	mov    0x805148,%eax
  80271a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802720:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802723:	c1 e1 04             	shl    $0x4,%ecx
  802726:	01 ca                	add    %ecx,%edx
  802728:	89 50 04             	mov    %edx,0x4(%eax)
  80272b:	eb 12                	jmp    80273f <initialize_MemBlocksList+0xa2>
  80272d:	a1 50 50 80 00       	mov    0x805050,%eax
  802732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802735:	c1 e2 04             	shl    $0x4,%edx
  802738:	01 d0                	add    %edx,%eax
  80273a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80273f:	a1 50 50 80 00       	mov    0x805050,%eax
  802744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802747:	c1 e2 04             	shl    $0x4,%edx
  80274a:	01 d0                	add    %edx,%eax
  80274c:	a3 48 51 80 00       	mov    %eax,0x805148
  802751:	a1 50 50 80 00       	mov    0x805050,%eax
  802756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802759:	c1 e2 04             	shl    $0x4,%edx
  80275c:	01 d0                	add    %edx,%eax
  80275e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802765:	a1 54 51 80 00       	mov    0x805154,%eax
  80276a:	40                   	inc    %eax
  80276b:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802770:	ff 45 f4             	incl   -0xc(%ebp)
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	3b 45 08             	cmp    0x8(%ebp),%eax
  802779:	0f 82 56 ff ff ff    	jb     8026d5 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80277f:	90                   	nop
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802790:	eb 18                	jmp    8027aa <find_block+0x28>
		{
			if(tmp->sva==va)
  802792:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802795:	8b 40 08             	mov    0x8(%eax),%eax
  802798:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80279b:	75 05                	jne    8027a2 <find_block+0x20>
			{
				return tmp;
  80279d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a0:	eb 11                	jmp    8027b3 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8027a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8027aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ae:	75 e2                	jne    802792 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8027b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8027bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	0f 85 83 00 00 00    	jne    80284b <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8027c8:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8027cf:	00 00 00 
  8027d2:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8027d9:	00 00 00 
  8027dc:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8027e3:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ea:	75 14                	jne    802800 <insert_sorted_allocList+0x4b>
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	68 24 42 80 00       	push   $0x804224
  8027f4:	6a 7f                	push   $0x7f
  8027f6:	68 47 42 80 00       	push   $0x804247
  8027fb:	e8 26 df ff ff       	call   800726 <_panic>
  802800:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	89 10                	mov    %edx,(%eax)
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 0d                	je     802821 <insert_sorted_allocList+0x6c>
  802814:	a1 40 50 80 00       	mov    0x805040,%eax
  802819:	8b 55 08             	mov    0x8(%ebp),%edx
  80281c:	89 50 04             	mov    %edx,0x4(%eax)
  80281f:	eb 08                	jmp    802829 <insert_sorted_allocList+0x74>
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	a3 44 50 80 00       	mov    %eax,0x805044
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	a3 40 50 80 00       	mov    %eax,0x805040
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802840:	40                   	inc    %eax
  802841:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802846:	e9 16 01 00 00       	jmp    802961 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	8b 50 08             	mov    0x8(%eax),%edx
  802851:	a1 44 50 80 00       	mov    0x805044,%eax
  802856:	8b 40 08             	mov    0x8(%eax),%eax
  802859:	39 c2                	cmp    %eax,%edx
  80285b:	76 68                	jbe    8028c5 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80285d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802861:	75 17                	jne    80287a <insert_sorted_allocList+0xc5>
  802863:	83 ec 04             	sub    $0x4,%esp
  802866:	68 60 42 80 00       	push   $0x804260
  80286b:	68 85 00 00 00       	push   $0x85
  802870:	68 47 42 80 00       	push   $0x804247
  802875:	e8 ac de ff ff       	call   800726 <_panic>
  80287a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 0c                	je     80289c <insert_sorted_allocList+0xe7>
  802890:	a1 44 50 80 00       	mov    0x805044,%eax
  802895:	8b 55 08             	mov    0x8(%ebp),%edx
  802898:	89 10                	mov    %edx,(%eax)
  80289a:	eb 08                	jmp    8028a4 <insert_sorted_allocList+0xef>
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	a3 40 50 80 00       	mov    %eax,0x805040
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ba:	40                   	inc    %eax
  8028bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8028c0:	e9 9c 00 00 00       	jmp    802961 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8028c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8028cd:	e9 85 00 00 00       	jmp    802957 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	8b 50 08             	mov    0x8(%eax),%edx
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 08             	mov    0x8(%eax),%eax
  8028de:	39 c2                	cmp    %eax,%edx
  8028e0:	73 6d                	jae    80294f <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8028e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e6:	74 06                	je     8028ee <insert_sorted_allocList+0x139>
  8028e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ec:	75 17                	jne    802905 <insert_sorted_allocList+0x150>
  8028ee:	83 ec 04             	sub    $0x4,%esp
  8028f1:	68 84 42 80 00       	push   $0x804284
  8028f6:	68 90 00 00 00       	push   $0x90
  8028fb:	68 47 42 80 00       	push   $0x804247
  802900:	e8 21 de ff ff       	call   800726 <_panic>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 50 04             	mov    0x4(%eax),%edx
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802917:	89 10                	mov    %edx,(%eax)
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0d                	je     802930 <insert_sorted_allocList+0x17b>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	8b 55 08             	mov    0x8(%ebp),%edx
  80292c:	89 10                	mov    %edx,(%eax)
  80292e:	eb 08                	jmp    802938 <insert_sorted_allocList+0x183>
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	a3 40 50 80 00       	mov    %eax,0x805040
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 55 08             	mov    0x8(%ebp),%edx
  80293e:	89 50 04             	mov    %edx,0x4(%eax)
  802941:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802946:	40                   	inc    %eax
  802947:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80294c:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80294d:	eb 12                	jmp    802961 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295b:	0f 85 71 ff ff ff    	jne    8028d2 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802961:	90                   	nop
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80296a:	a1 38 51 80 00       	mov    0x805138,%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802972:	e9 76 01 00 00       	jmp    802aed <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802980:	0f 85 8a 00 00 00    	jne    802a10 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	75 17                	jne    8029a3 <alloc_block_FF+0x3f>
  80298c:	83 ec 04             	sub    $0x4,%esp
  80298f:	68 b9 42 80 00       	push   $0x8042b9
  802994:	68 a8 00 00 00       	push   $0xa8
  802999:	68 47 42 80 00       	push   $0x804247
  80299e:	e8 83 dd ff ff       	call   800726 <_panic>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 10                	je     8029bc <alloc_block_FF+0x58>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	8b 52 04             	mov    0x4(%edx),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	eb 0b                	jmp    8029c7 <alloc_block_FF+0x63>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 0f                	je     8029e0 <alloc_block_FF+0x7c>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	8b 12                	mov    (%edx),%edx
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	eb 0a                	jmp    8029ea <alloc_block_FF+0x86>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 44 51 80 00       	mov    0x805144,%eax
  802a02:	48                   	dec    %eax
  802a03:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	e9 ea 00 00 00       	jmp    802afa <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a19:	0f 86 c6 00 00 00    	jbe    802ae5 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a1f:	a1 48 51 80 00       	mov    0x805148,%eax
  802a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2d:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 50 08             	mov    0x8(%eax),%edx
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a42:	2b 45 08             	sub    0x8(%ebp),%eax
  802a45:	89 c2                	mov    %eax,%edx
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	01 c2                	add    %eax,%edx
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a62:	75 17                	jne    802a7b <alloc_block_FF+0x117>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 b9 42 80 00       	push   $0x8042b9
  802a6c:	68 b6 00 00 00       	push   $0xb6
  802a71:	68 47 42 80 00       	push   $0x804247
  802a76:	e8 ab dc ff ff       	call   800726 <_panic>
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 10                	je     802a94 <alloc_block_FF+0x130>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8c:	8b 52 04             	mov    0x4(%edx),%edx
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	eb 0b                	jmp    802a9f <alloc_block_FF+0x13b>
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 40 04             	mov    0x4(%eax),%eax
  802a9a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0f                	je     802ab8 <alloc_block_FF+0x154>
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab2:	8b 12                	mov    (%edx),%edx
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	eb 0a                	jmp    802ac2 <alloc_block_FF+0x15e>
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	a3 48 51 80 00       	mov    %eax,0x805148
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad5:	a1 54 51 80 00       	mov    0x805154,%eax
  802ada:	48                   	dec    %eax
  802adb:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	eb 15                	jmp    802afa <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af1:	0f 85 80 fe ff ff    	jne    802977 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802b02:	a1 38 51 80 00       	mov    0x805138,%eax
  802b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802b0a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802b11:	e9 c0 00 00 00       	jmp    802bd6 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1f:	0f 85 8a 00 00 00    	jne    802baf <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b29:	75 17                	jne    802b42 <alloc_block_BF+0x46>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 b9 42 80 00       	push   $0x8042b9
  802b33:	68 cf 00 00 00       	push   $0xcf
  802b38:	68 47 42 80 00       	push   $0x804247
  802b3d:	e8 e4 db ff ff       	call   800726 <_panic>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 10                	je     802b5b <alloc_block_BF+0x5f>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	8b 52 04             	mov    0x4(%edx),%edx
  802b56:	89 50 04             	mov    %edx,0x4(%eax)
  802b59:	eb 0b                	jmp    802b66 <alloc_block_BF+0x6a>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 0f                	je     802b7f <alloc_block_BF+0x83>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	8b 12                	mov    (%edx),%edx
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	eb 0a                	jmp    802b89 <alloc_block_BF+0x8d>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	a3 38 51 80 00       	mov    %eax,0x805138
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba1:	48                   	dec    %eax
  802ba2:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	e9 2a 01 00 00       	jmp    802cd9 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bb8:	73 14                	jae    802bce <alloc_block_BF+0xd2>
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc3:	76 09                	jbe    802bce <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	0f 85 36 ff ff ff    	jne    802b16 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802be0:	a1 38 51 80 00       	mov    0x805138,%eax
  802be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802be8:	e9 dd 00 00 00       	jmp    802cca <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bf6:	0f 85 c6 00 00 00    	jne    802cc2 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802bfc:	a1 48 51 80 00       	mov    0x805148,%eax
  802c01:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 50 08             	mov    0x8(%eax),%edx
  802c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0d:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	8b 55 08             	mov    0x8(%ebp),%edx
  802c16:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 50 08             	mov    0x8(%eax),%edx
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	01 c2                	add    %eax,%edx
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c30:	2b 45 08             	sub    0x8(%ebp),%eax
  802c33:	89 c2                	mov    %eax,%edx
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c3f:	75 17                	jne    802c58 <alloc_block_BF+0x15c>
  802c41:	83 ec 04             	sub    $0x4,%esp
  802c44:	68 b9 42 80 00       	push   $0x8042b9
  802c49:	68 eb 00 00 00       	push   $0xeb
  802c4e:	68 47 42 80 00       	push   $0x804247
  802c53:	e8 ce da ff ff       	call   800726 <_panic>
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	85 c0                	test   %eax,%eax
  802c5f:	74 10                	je     802c71 <alloc_block_BF+0x175>
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c69:	8b 52 04             	mov    0x4(%edx),%edx
  802c6c:	89 50 04             	mov    %edx,0x4(%eax)
  802c6f:	eb 0b                	jmp    802c7c <alloc_block_BF+0x180>
  802c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c74:	8b 40 04             	mov    0x4(%eax),%eax
  802c77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7f:	8b 40 04             	mov    0x4(%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 0f                	je     802c95 <alloc_block_BF+0x199>
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c8f:	8b 12                	mov    (%edx),%edx
  802c91:	89 10                	mov    %edx,(%eax)
  802c93:	eb 0a                	jmp    802c9f <alloc_block_BF+0x1a3>
  802c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	a3 48 51 80 00       	mov    %eax,0x805148
  802c9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb2:	a1 54 51 80 00       	mov    0x805154,%eax
  802cb7:	48                   	dec    %eax
  802cb8:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc0:	eb 17                	jmp    802cd9 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802cca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cce:	0f 85 19 ff ff ff    	jne    802bed <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802ce1:	a1 40 50 80 00       	mov    0x805040,%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	75 19                	jne    802d03 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802cea:	83 ec 0c             	sub    $0xc,%esp
  802ced:	ff 75 08             	pushl  0x8(%ebp)
  802cf0:	e8 6f fc ff ff       	call   802964 <alloc_block_FF>
  802cf5:	83 c4 10             	add    $0x10,%esp
  802cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	e9 e9 01 00 00       	jmp    802eec <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802d03:	a1 44 50 80 00       	mov    0x805044,%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802d0e:	a1 44 50 80 00       	mov    0x805044,%eax
  802d13:	8b 50 0c             	mov    0xc(%eax),%edx
  802d16:	a1 44 50 80 00       	mov    0x805044,%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	01 d0                	add    %edx,%eax
  802d20:	83 ec 08             	sub    $0x8,%esp
  802d23:	50                   	push   %eax
  802d24:	68 38 51 80 00       	push   $0x805138
  802d29:	e8 54 fa ff ff       	call   802782 <find_block>
  802d2e:	83 c4 10             	add    $0x10,%esp
  802d31:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3d:	0f 85 9b 00 00 00    	jne    802dde <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 50 0c             	mov    0xc(%eax),%edx
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	01 d0                	add    %edx,%eax
  802d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802d54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d58:	75 17                	jne    802d71 <alloc_block_NF+0x96>
  802d5a:	83 ec 04             	sub    $0x4,%esp
  802d5d:	68 b9 42 80 00       	push   $0x8042b9
  802d62:	68 1a 01 00 00       	push   $0x11a
  802d67:	68 47 42 80 00       	push   $0x804247
  802d6c:	e8 b5 d9 ff ff       	call   800726 <_panic>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 10                	je     802d8a <alloc_block_NF+0xaf>
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d82:	8b 52 04             	mov    0x4(%edx),%edx
  802d85:	89 50 04             	mov    %edx,0x4(%eax)
  802d88:	eb 0b                	jmp    802d95 <alloc_block_NF+0xba>
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	74 0f                	je     802dae <alloc_block_NF+0xd3>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da8:	8b 12                	mov    (%edx),%edx
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	eb 0a                	jmp    802db8 <alloc_block_NF+0xdd>
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	a3 38 51 80 00       	mov    %eax,0x805138
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcb:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd0:	48                   	dec    %eax
  802dd1:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	e9 0e 01 00 00       	jmp    802eec <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 40 0c             	mov    0xc(%eax),%eax
  802de4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de7:	0f 86 cf 00 00 00    	jbe    802ebc <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802ded:	a1 48 51 80 00       	mov    0x805148,%eax
  802df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfb:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 50 08             	mov    0x8(%eax),%edx
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 50 08             	mov    0x8(%eax),%edx
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	01 c2                	add    %eax,%edx
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e21:	2b 45 08             	sub    0x8(%ebp),%eax
  802e24:	89 c2                	mov    %eax,%edx
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 40 08             	mov    0x8(%eax),%eax
  802e32:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802e35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e39:	75 17                	jne    802e52 <alloc_block_NF+0x177>
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	68 b9 42 80 00       	push   $0x8042b9
  802e43:	68 28 01 00 00       	push   $0x128
  802e48:	68 47 42 80 00       	push   $0x804247
  802e4d:	e8 d4 d8 ff ff       	call   800726 <_panic>
  802e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 10                	je     802e6b <alloc_block_NF+0x190>
  802e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e63:	8b 52 04             	mov    0x4(%edx),%edx
  802e66:	89 50 04             	mov    %edx,0x4(%eax)
  802e69:	eb 0b                	jmp    802e76 <alloc_block_NF+0x19b>
  802e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 0f                	je     802e8f <alloc_block_NF+0x1b4>
  802e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e89:	8b 12                	mov    (%edx),%edx
  802e8b:	89 10                	mov    %edx,(%eax)
  802e8d:	eb 0a                	jmp    802e99 <alloc_block_NF+0x1be>
  802e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	a3 48 51 80 00       	mov    %eax,0x805148
  802e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eac:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb1:	48                   	dec    %eax
  802eb2:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eba:	eb 30                	jmp    802eec <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802ebc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ec1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ec4:	75 0a                	jne    802ed0 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802ec6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ece:	eb 08                	jmp    802ed8 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 40 08             	mov    0x8(%eax),%eax
  802ede:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ee1:	0f 85 4d fe ff ff    	jne    802d34 <alloc_block_NF+0x59>

			return NULL;
  802ee7:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802eec:	c9                   	leave  
  802eed:	c3                   	ret    

00802eee <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eee:	55                   	push   %ebp
  802eef:	89 e5                	mov    %esp,%ebp
  802ef1:	53                   	push   %ebx
  802ef2:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802ef5:	a1 38 51 80 00       	mov    0x805138,%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	0f 85 86 00 00 00    	jne    802f88 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802f02:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802f09:	00 00 00 
  802f0c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802f13:	00 00 00 
  802f16:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802f1d:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f24:	75 17                	jne    802f3d <insert_sorted_with_merge_freeList+0x4f>
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	68 24 42 80 00       	push   $0x804224
  802f2e:	68 48 01 00 00       	push   $0x148
  802f33:	68 47 42 80 00       	push   $0x804247
  802f38:	e8 e9 d7 ff ff       	call   800726 <_panic>
  802f3d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	89 10                	mov    %edx,(%eax)
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0d                	je     802f5e <insert_sorted_with_merge_freeList+0x70>
  802f51:	a1 38 51 80 00       	mov    0x805138,%eax
  802f56:	8b 55 08             	mov    0x8(%ebp),%edx
  802f59:	89 50 04             	mov    %edx,0x4(%eax)
  802f5c:	eb 08                	jmp    802f66 <insert_sorted_with_merge_freeList+0x78>
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f78:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7d:	40                   	inc    %eax
  802f7e:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802f83:	e9 73 07 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	8b 50 08             	mov    0x8(%eax),%edx
  802f8e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f93:	8b 40 08             	mov    0x8(%eax),%eax
  802f96:	39 c2                	cmp    %eax,%edx
  802f98:	0f 86 84 00 00 00    	jbe    803022 <insert_sorted_with_merge_freeList+0x134>
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	8b 50 08             	mov    0x8(%eax),%edx
  802fa4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fa9:	8b 48 0c             	mov    0xc(%eax),%ecx
  802fac:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb1:	8b 40 08             	mov    0x8(%eax),%eax
  802fb4:	01 c8                	add    %ecx,%eax
  802fb6:	39 c2                	cmp    %eax,%edx
  802fb8:	74 68                	je     803022 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802fba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbe:	75 17                	jne    802fd7 <insert_sorted_with_merge_freeList+0xe9>
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	68 60 42 80 00       	push   $0x804260
  802fc8:	68 4c 01 00 00       	push   $0x14c
  802fcd:	68 47 42 80 00       	push   $0x804247
  802fd2:	e8 4f d7 ff ff       	call   800726 <_panic>
  802fd7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	89 50 04             	mov    %edx,0x4(%eax)
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 0c                	je     802ff9 <insert_sorted_with_merge_freeList+0x10b>
  802fed:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	eb 08                	jmp    803001 <insert_sorted_with_merge_freeList+0x113>
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	a3 38 51 80 00       	mov    %eax,0x805138
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803012:	a1 44 51 80 00       	mov    0x805144,%eax
  803017:	40                   	inc    %eax
  803018:	a3 44 51 80 00       	mov    %eax,0x805144
  80301d:	e9 d9 06 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 50 08             	mov    0x8(%eax),%edx
  803028:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80302d:	8b 40 08             	mov    0x8(%eax),%eax
  803030:	39 c2                	cmp    %eax,%edx
  803032:	0f 86 b5 00 00 00    	jbe    8030ed <insert_sorted_with_merge_freeList+0x1ff>
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 50 08             	mov    0x8(%eax),%edx
  80303e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803043:	8b 48 0c             	mov    0xc(%eax),%ecx
  803046:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304b:	8b 40 08             	mov    0x8(%eax),%eax
  80304e:	01 c8                	add    %ecx,%eax
  803050:	39 c2                	cmp    %eax,%edx
  803052:	0f 85 95 00 00 00    	jne    8030ed <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803058:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80305d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803063:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803066:	8b 55 08             	mov    0x8(%ebp),%edx
  803069:	8b 52 0c             	mov    0xc(%edx),%edx
  80306c:	01 ca                	add    %ecx,%edx
  80306e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803089:	75 17                	jne    8030a2 <insert_sorted_with_merge_freeList+0x1b4>
  80308b:	83 ec 04             	sub    $0x4,%esp
  80308e:	68 24 42 80 00       	push   $0x804224
  803093:	68 54 01 00 00       	push   $0x154
  803098:	68 47 42 80 00       	push   $0x804247
  80309d:	e8 84 d6 ff ff       	call   800726 <_panic>
  8030a2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	89 10                	mov    %edx,(%eax)
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0d                	je     8030c3 <insert_sorted_with_merge_freeList+0x1d5>
  8030b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030be:	89 50 04             	mov    %edx,0x4(%eax)
  8030c1:	eb 08                	jmp    8030cb <insert_sorted_with_merge_freeList+0x1dd>
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e2:	40                   	inc    %eax
  8030e3:	a3 54 51 80 00       	mov    %eax,0x805154
  8030e8:	e9 0e 06 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	8b 50 08             	mov    0x8(%eax),%edx
  8030f3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f8:	8b 40 08             	mov    0x8(%eax),%eax
  8030fb:	39 c2                	cmp    %eax,%edx
  8030fd:	0f 83 c1 00 00 00    	jae    8031c4 <insert_sorted_with_merge_freeList+0x2d6>
  803103:	a1 38 51 80 00       	mov    0x805138,%eax
  803108:	8b 50 08             	mov    0x8(%eax),%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	8b 48 08             	mov    0x8(%eax),%ecx
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 40 0c             	mov    0xc(%eax),%eax
  803117:	01 c8                	add    %ecx,%eax
  803119:	39 c2                	cmp    %eax,%edx
  80311b:	0f 85 a3 00 00 00    	jne    8031c4 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803121:	a1 38 51 80 00       	mov    0x805138,%eax
  803126:	8b 55 08             	mov    0x8(%ebp),%edx
  803129:	8b 52 08             	mov    0x8(%edx),%edx
  80312c:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80312f:	a1 38 51 80 00       	mov    0x805138,%eax
  803134:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80313a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80313d:	8b 55 08             	mov    0x8(%ebp),%edx
  803140:	8b 52 0c             	mov    0xc(%edx),%edx
  803143:	01 ca                	add    %ecx,%edx
  803145:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80315c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803160:	75 17                	jne    803179 <insert_sorted_with_merge_freeList+0x28b>
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	68 24 42 80 00       	push   $0x804224
  80316a:	68 5d 01 00 00       	push   $0x15d
  80316f:	68 47 42 80 00       	push   $0x804247
  803174:	e8 ad d5 ff ff       	call   800726 <_panic>
  803179:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	89 10                	mov    %edx,(%eax)
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 0d                	je     80319a <insert_sorted_with_merge_freeList+0x2ac>
  80318d:	a1 48 51 80 00       	mov    0x805148,%eax
  803192:	8b 55 08             	mov    0x8(%ebp),%edx
  803195:	89 50 04             	mov    %edx,0x4(%eax)
  803198:	eb 08                	jmp    8031a2 <insert_sorted_with_merge_freeList+0x2b4>
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b9:	40                   	inc    %eax
  8031ba:	a3 54 51 80 00       	mov    %eax,0x805154
  8031bf:	e9 37 05 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cf:	8b 40 08             	mov    0x8(%eax),%eax
  8031d2:	39 c2                	cmp    %eax,%edx
  8031d4:	0f 83 82 00 00 00    	jae    80325c <insert_sorted_with_merge_freeList+0x36e>
  8031da:	a1 38 51 80 00       	mov    0x805138,%eax
  8031df:	8b 50 08             	mov    0x8(%eax),%edx
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8b 48 08             	mov    0x8(%eax),%ecx
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ee:	01 c8                	add    %ecx,%eax
  8031f0:	39 c2                	cmp    %eax,%edx
  8031f2:	74 68                	je     80325c <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8031f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f8:	75 17                	jne    803211 <insert_sorted_with_merge_freeList+0x323>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 24 42 80 00       	push   $0x804224
  803202:	68 62 01 00 00       	push   $0x162
  803207:	68 47 42 80 00       	push   $0x804247
  80320c:	e8 15 d5 ff ff       	call   800726 <_panic>
  803211:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0d                	je     803232 <insert_sorted_with_merge_freeList+0x344>
  803225:	a1 38 51 80 00       	mov    0x805138,%eax
  80322a:	8b 55 08             	mov    0x8(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 08                	jmp    80323a <insert_sorted_with_merge_freeList+0x34c>
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	a3 38 51 80 00       	mov    %eax,0x805138
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324c:	a1 44 51 80 00       	mov    0x805144,%eax
  803251:	40                   	inc    %eax
  803252:	a3 44 51 80 00       	mov    %eax,0x805144
  803257:	e9 9f 04 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  80325c:	a1 38 51 80 00       	mov    0x805138,%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803266:	e9 84 04 00 00       	jmp    8036ef <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 50 08             	mov    0x8(%eax),%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	8b 40 08             	mov    0x8(%eax),%eax
  803277:	39 c2                	cmp    %eax,%edx
  803279:	0f 86 a9 00 00 00    	jbe    803328 <insert_sorted_with_merge_freeList+0x43a>
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 50 08             	mov    0x8(%eax),%edx
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	8b 48 08             	mov    0x8(%eax),%ecx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 40 0c             	mov    0xc(%eax),%eax
  803291:	01 c8                	add    %ecx,%eax
  803293:	39 c2                	cmp    %eax,%edx
  803295:	0f 84 8d 00 00 00    	je     803328 <insert_sorted_with_merge_freeList+0x43a>
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	8b 50 08             	mov    0x8(%eax),%edx
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	8b 40 04             	mov    0x4(%eax),%eax
  8032a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 40 04             	mov    0x4(%eax),%eax
  8032b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b3:	01 c8                	add    %ecx,%eax
  8032b5:	39 c2                	cmp    %eax,%edx
  8032b7:	74 6f                	je     803328 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8032b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bd:	74 06                	je     8032c5 <insert_sorted_with_merge_freeList+0x3d7>
  8032bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c3:	75 17                	jne    8032dc <insert_sorted_with_merge_freeList+0x3ee>
  8032c5:	83 ec 04             	sub    $0x4,%esp
  8032c8:	68 84 42 80 00       	push   $0x804284
  8032cd:	68 6b 01 00 00       	push   $0x16b
  8032d2:	68 47 42 80 00       	push   $0x804247
  8032d7:	e8 4a d4 ff ff       	call   800726 <_panic>
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	8b 50 04             	mov    0x4(%eax),%edx
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ee:	89 10                	mov    %edx,(%eax)
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	8b 40 04             	mov    0x4(%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	74 0d                	je     803307 <insert_sorted_with_merge_freeList+0x419>
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 40 04             	mov    0x4(%eax),%eax
  803300:	8b 55 08             	mov    0x8(%ebp),%edx
  803303:	89 10                	mov    %edx,(%eax)
  803305:	eb 08                	jmp    80330f <insert_sorted_with_merge_freeList+0x421>
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	a3 38 51 80 00       	mov    %eax,0x805138
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 55 08             	mov    0x8(%ebp),%edx
  803315:	89 50 04             	mov    %edx,0x4(%eax)
  803318:	a1 44 51 80 00       	mov    0x805144,%eax
  80331d:	40                   	inc    %eax
  80331e:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  803323:	e9 d3 03 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	8b 50 08             	mov    0x8(%eax),%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 40 08             	mov    0x8(%eax),%eax
  803334:	39 c2                	cmp    %eax,%edx
  803336:	0f 86 da 00 00 00    	jbe    803416 <insert_sorted_with_merge_freeList+0x528>
  80333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333f:	8b 50 08             	mov    0x8(%eax),%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	8b 48 08             	mov    0x8(%eax),%ecx
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 40 0c             	mov    0xc(%eax),%eax
  80334e:	01 c8                	add    %ecx,%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	0f 85 be 00 00 00    	jne    803416 <insert_sorted_with_merge_freeList+0x528>
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	8b 50 08             	mov    0x8(%eax),%edx
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 40 04             	mov    0x4(%eax),%eax
  803364:	8b 48 08             	mov    0x8(%eax),%ecx
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 04             	mov    0x4(%eax),%eax
  80336d:	8b 40 0c             	mov    0xc(%eax),%eax
  803370:	01 c8                	add    %ecx,%eax
  803372:	39 c2                	cmp    %eax,%edx
  803374:	0f 84 9c 00 00 00    	je     803416 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 50 08             	mov    0x8(%eax),%edx
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 50 0c             	mov    0xc(%eax),%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	8b 40 0c             	mov    0xc(%eax),%eax
  803392:	01 c2                	add    %eax,%edx
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b2:	75 17                	jne    8033cb <insert_sorted_with_merge_freeList+0x4dd>
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 24 42 80 00       	push   $0x804224
  8033bc:	68 74 01 00 00       	push   $0x174
  8033c1:	68 47 42 80 00       	push   $0x804247
  8033c6:	e8 5b d3 ff ff       	call   800726 <_panic>
  8033cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	89 10                	mov    %edx,(%eax)
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 0d                	je     8033ec <insert_sorted_with_merge_freeList+0x4fe>
  8033df:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	eb 08                	jmp    8033f4 <insert_sorted_with_merge_freeList+0x506>
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803406:	a1 54 51 80 00       	mov    0x805154,%eax
  80340b:	40                   	inc    %eax
  80340c:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803411:	e9 e5 02 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 50 08             	mov    0x8(%eax),%edx
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	8b 40 08             	mov    0x8(%eax),%eax
  803422:	39 c2                	cmp    %eax,%edx
  803424:	0f 86 d7 00 00 00    	jbe    803501 <insert_sorted_with_merge_freeList+0x613>
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	8b 50 08             	mov    0x8(%eax),%edx
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	8b 48 08             	mov    0x8(%eax),%ecx
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	8b 40 0c             	mov    0xc(%eax),%eax
  80343c:	01 c8                	add    %ecx,%eax
  80343e:	39 c2                	cmp    %eax,%edx
  803440:	0f 84 bb 00 00 00    	je     803501 <insert_sorted_with_merge_freeList+0x613>
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	8b 50 08             	mov    0x8(%eax),%edx
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	8b 40 04             	mov    0x4(%eax),%eax
  803452:	8b 48 08             	mov    0x8(%eax),%ecx
  803455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803458:	8b 40 04             	mov    0x4(%eax),%eax
  80345b:	8b 40 0c             	mov    0xc(%eax),%eax
  80345e:	01 c8                	add    %ecx,%eax
  803460:	39 c2                	cmp    %eax,%edx
  803462:	0f 85 99 00 00 00    	jne    803501 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 40 04             	mov    0x4(%eax),%eax
  80346e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803474:	8b 50 0c             	mov    0xc(%eax),%edx
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	8b 40 0c             	mov    0xc(%eax),%eax
  80347d:	01 c2                	add    %eax,%edx
  80347f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803482:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349d:	75 17                	jne    8034b6 <insert_sorted_with_merge_freeList+0x5c8>
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	68 24 42 80 00       	push   $0x804224
  8034a7:	68 7d 01 00 00       	push   $0x17d
  8034ac:	68 47 42 80 00       	push   $0x804247
  8034b1:	e8 70 d2 ff ff       	call   800726 <_panic>
  8034b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	89 10                	mov    %edx,(%eax)
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 0d                	je     8034d7 <insert_sorted_with_merge_freeList+0x5e9>
  8034ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8034cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d2:	89 50 04             	mov    %edx,0x4(%eax)
  8034d5:	eb 08                	jmp    8034df <insert_sorted_with_merge_freeList+0x5f1>
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f6:	40                   	inc    %eax
  8034f7:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8034fc:	e9 fa 01 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803504:	8b 50 08             	mov    0x8(%eax),%edx
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	8b 40 08             	mov    0x8(%eax),%eax
  80350d:	39 c2                	cmp    %eax,%edx
  80350f:	0f 86 d2 01 00 00    	jbe    8036e7 <insert_sorted_with_merge_freeList+0x7f9>
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 50 08             	mov    0x8(%eax),%edx
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	8b 48 08             	mov    0x8(%eax),%ecx
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	8b 40 0c             	mov    0xc(%eax),%eax
  803527:	01 c8                	add    %ecx,%eax
  803529:	39 c2                	cmp    %eax,%edx
  80352b:	0f 85 b6 01 00 00    	jne    8036e7 <insert_sorted_with_merge_freeList+0x7f9>
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	8b 50 08             	mov    0x8(%eax),%edx
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	8b 40 04             	mov    0x4(%eax),%eax
  80353d:	8b 48 08             	mov    0x8(%eax),%ecx
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	8b 40 04             	mov    0x4(%eax),%eax
  803546:	8b 40 0c             	mov    0xc(%eax),%eax
  803549:	01 c8                	add    %ecx,%eax
  80354b:	39 c2                	cmp    %eax,%edx
  80354d:	0f 85 94 01 00 00    	jne    8036e7 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	8b 40 04             	mov    0x4(%eax),%eax
  803559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80355c:	8b 52 04             	mov    0x4(%edx),%edx
  80355f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803562:	8b 55 08             	mov    0x8(%ebp),%edx
  803565:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80356b:	8b 52 0c             	mov    0xc(%edx),%edx
  80356e:	01 da                	add    %ebx,%edx
  803570:	01 ca                	add    %ecx,%edx
  803572:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80358d:	75 17                	jne    8035a6 <insert_sorted_with_merge_freeList+0x6b8>
  80358f:	83 ec 04             	sub    $0x4,%esp
  803592:	68 b9 42 80 00       	push   $0x8042b9
  803597:	68 86 01 00 00       	push   $0x186
  80359c:	68 47 42 80 00       	push   $0x804247
  8035a1:	e8 80 d1 ff ff       	call   800726 <_panic>
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	74 10                	je     8035bf <insert_sorted_with_merge_freeList+0x6d1>
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b7:	8b 52 04             	mov    0x4(%edx),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	eb 0b                	jmp    8035ca <insert_sorted_with_merge_freeList+0x6dc>
  8035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c2:	8b 40 04             	mov    0x4(%eax),%eax
  8035c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	8b 40 04             	mov    0x4(%eax),%eax
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	74 0f                	je     8035e3 <insert_sorted_with_merge_freeList+0x6f5>
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 40 04             	mov    0x4(%eax),%eax
  8035da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035dd:	8b 12                	mov    (%edx),%edx
  8035df:	89 10                	mov    %edx,(%eax)
  8035e1:	eb 0a                	jmp    8035ed <insert_sorted_with_merge_freeList+0x6ff>
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803600:	a1 44 51 80 00       	mov    0x805144,%eax
  803605:	48                   	dec    %eax
  803606:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80360b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360f:	75 17                	jne    803628 <insert_sorted_with_merge_freeList+0x73a>
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	68 24 42 80 00       	push   $0x804224
  803619:	68 87 01 00 00       	push   $0x187
  80361e:	68 47 42 80 00       	push   $0x804247
  803623:	e8 fe d0 ff ff       	call   800726 <_panic>
  803628:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	89 10                	mov    %edx,(%eax)
  803633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	74 0d                	je     803649 <insert_sorted_with_merge_freeList+0x75b>
  80363c:	a1 48 51 80 00       	mov    0x805148,%eax
  803641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803644:	89 50 04             	mov    %edx,0x4(%eax)
  803647:	eb 08                	jmp    803651 <insert_sorted_with_merge_freeList+0x763>
  803649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	a3 48 51 80 00       	mov    %eax,0x805148
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803663:	a1 54 51 80 00       	mov    0x805154,%eax
  803668:	40                   	inc    %eax
  803669:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803682:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803686:	75 17                	jne    80369f <insert_sorted_with_merge_freeList+0x7b1>
  803688:	83 ec 04             	sub    $0x4,%esp
  80368b:	68 24 42 80 00       	push   $0x804224
  803690:	68 8a 01 00 00       	push   $0x18a
  803695:	68 47 42 80 00       	push   $0x804247
  80369a:	e8 87 d0 ff ff       	call   800726 <_panic>
  80369f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	74 0d                	je     8036c0 <insert_sorted_with_merge_freeList+0x7d2>
  8036b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	eb 08                	jmp    8036c8 <insert_sorted_with_merge_freeList+0x7da>
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036da:	a1 54 51 80 00       	mov    0x805154,%eax
  8036df:	40                   	inc    %eax
  8036e0:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8036e5:	eb 14                	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8036ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f3:	0f 85 72 fb ff ff    	jne    80326b <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8036f9:	eb 00                	jmp    8036fb <insert_sorted_with_merge_freeList+0x80d>
  8036fb:	90                   	nop
  8036fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036ff:	c9                   	leave  
  803700:	c3                   	ret    
  803701:	66 90                	xchg   %ax,%ax
  803703:	90                   	nop

00803704 <__udivdi3>:
  803704:	55                   	push   %ebp
  803705:	57                   	push   %edi
  803706:	56                   	push   %esi
  803707:	53                   	push   %ebx
  803708:	83 ec 1c             	sub    $0x1c,%esp
  80370b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80370f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80371b:	89 ca                	mov    %ecx,%edx
  80371d:	89 f8                	mov    %edi,%eax
  80371f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803723:	85 f6                	test   %esi,%esi
  803725:	75 2d                	jne    803754 <__udivdi3+0x50>
  803727:	39 cf                	cmp    %ecx,%edi
  803729:	77 65                	ja     803790 <__udivdi3+0x8c>
  80372b:	89 fd                	mov    %edi,%ebp
  80372d:	85 ff                	test   %edi,%edi
  80372f:	75 0b                	jne    80373c <__udivdi3+0x38>
  803731:	b8 01 00 00 00       	mov    $0x1,%eax
  803736:	31 d2                	xor    %edx,%edx
  803738:	f7 f7                	div    %edi
  80373a:	89 c5                	mov    %eax,%ebp
  80373c:	31 d2                	xor    %edx,%edx
  80373e:	89 c8                	mov    %ecx,%eax
  803740:	f7 f5                	div    %ebp
  803742:	89 c1                	mov    %eax,%ecx
  803744:	89 d8                	mov    %ebx,%eax
  803746:	f7 f5                	div    %ebp
  803748:	89 cf                	mov    %ecx,%edi
  80374a:	89 fa                	mov    %edi,%edx
  80374c:	83 c4 1c             	add    $0x1c,%esp
  80374f:	5b                   	pop    %ebx
  803750:	5e                   	pop    %esi
  803751:	5f                   	pop    %edi
  803752:	5d                   	pop    %ebp
  803753:	c3                   	ret    
  803754:	39 ce                	cmp    %ecx,%esi
  803756:	77 28                	ja     803780 <__udivdi3+0x7c>
  803758:	0f bd fe             	bsr    %esi,%edi
  80375b:	83 f7 1f             	xor    $0x1f,%edi
  80375e:	75 40                	jne    8037a0 <__udivdi3+0x9c>
  803760:	39 ce                	cmp    %ecx,%esi
  803762:	72 0a                	jb     80376e <__udivdi3+0x6a>
  803764:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803768:	0f 87 9e 00 00 00    	ja     80380c <__udivdi3+0x108>
  80376e:	b8 01 00 00 00       	mov    $0x1,%eax
  803773:	89 fa                	mov    %edi,%edx
  803775:	83 c4 1c             	add    $0x1c,%esp
  803778:	5b                   	pop    %ebx
  803779:	5e                   	pop    %esi
  80377a:	5f                   	pop    %edi
  80377b:	5d                   	pop    %ebp
  80377c:	c3                   	ret    
  80377d:	8d 76 00             	lea    0x0(%esi),%esi
  803780:	31 ff                	xor    %edi,%edi
  803782:	31 c0                	xor    %eax,%eax
  803784:	89 fa                	mov    %edi,%edx
  803786:	83 c4 1c             	add    $0x1c,%esp
  803789:	5b                   	pop    %ebx
  80378a:	5e                   	pop    %esi
  80378b:	5f                   	pop    %edi
  80378c:	5d                   	pop    %ebp
  80378d:	c3                   	ret    
  80378e:	66 90                	xchg   %ax,%ax
  803790:	89 d8                	mov    %ebx,%eax
  803792:	f7 f7                	div    %edi
  803794:	31 ff                	xor    %edi,%edi
  803796:	89 fa                	mov    %edi,%edx
  803798:	83 c4 1c             	add    $0x1c,%esp
  80379b:	5b                   	pop    %ebx
  80379c:	5e                   	pop    %esi
  80379d:	5f                   	pop    %edi
  80379e:	5d                   	pop    %ebp
  80379f:	c3                   	ret    
  8037a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037a5:	89 eb                	mov    %ebp,%ebx
  8037a7:	29 fb                	sub    %edi,%ebx
  8037a9:	89 f9                	mov    %edi,%ecx
  8037ab:	d3 e6                	shl    %cl,%esi
  8037ad:	89 c5                	mov    %eax,%ebp
  8037af:	88 d9                	mov    %bl,%cl
  8037b1:	d3 ed                	shr    %cl,%ebp
  8037b3:	89 e9                	mov    %ebp,%ecx
  8037b5:	09 f1                	or     %esi,%ecx
  8037b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037bb:	89 f9                	mov    %edi,%ecx
  8037bd:	d3 e0                	shl    %cl,%eax
  8037bf:	89 c5                	mov    %eax,%ebp
  8037c1:	89 d6                	mov    %edx,%esi
  8037c3:	88 d9                	mov    %bl,%cl
  8037c5:	d3 ee                	shr    %cl,%esi
  8037c7:	89 f9                	mov    %edi,%ecx
  8037c9:	d3 e2                	shl    %cl,%edx
  8037cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037cf:	88 d9                	mov    %bl,%cl
  8037d1:	d3 e8                	shr    %cl,%eax
  8037d3:	09 c2                	or     %eax,%edx
  8037d5:	89 d0                	mov    %edx,%eax
  8037d7:	89 f2                	mov    %esi,%edx
  8037d9:	f7 74 24 0c          	divl   0xc(%esp)
  8037dd:	89 d6                	mov    %edx,%esi
  8037df:	89 c3                	mov    %eax,%ebx
  8037e1:	f7 e5                	mul    %ebp
  8037e3:	39 d6                	cmp    %edx,%esi
  8037e5:	72 19                	jb     803800 <__udivdi3+0xfc>
  8037e7:	74 0b                	je     8037f4 <__udivdi3+0xf0>
  8037e9:	89 d8                	mov    %ebx,%eax
  8037eb:	31 ff                	xor    %edi,%edi
  8037ed:	e9 58 ff ff ff       	jmp    80374a <__udivdi3+0x46>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037f8:	89 f9                	mov    %edi,%ecx
  8037fa:	d3 e2                	shl    %cl,%edx
  8037fc:	39 c2                	cmp    %eax,%edx
  8037fe:	73 e9                	jae    8037e9 <__udivdi3+0xe5>
  803800:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803803:	31 ff                	xor    %edi,%edi
  803805:	e9 40 ff ff ff       	jmp    80374a <__udivdi3+0x46>
  80380a:	66 90                	xchg   %ax,%ax
  80380c:	31 c0                	xor    %eax,%eax
  80380e:	e9 37 ff ff ff       	jmp    80374a <__udivdi3+0x46>
  803813:	90                   	nop

00803814 <__umoddi3>:
  803814:	55                   	push   %ebp
  803815:	57                   	push   %edi
  803816:	56                   	push   %esi
  803817:	53                   	push   %ebx
  803818:	83 ec 1c             	sub    $0x1c,%esp
  80381b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80381f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803827:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80382b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80382f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803833:	89 f3                	mov    %esi,%ebx
  803835:	89 fa                	mov    %edi,%edx
  803837:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80383b:	89 34 24             	mov    %esi,(%esp)
  80383e:	85 c0                	test   %eax,%eax
  803840:	75 1a                	jne    80385c <__umoddi3+0x48>
  803842:	39 f7                	cmp    %esi,%edi
  803844:	0f 86 a2 00 00 00    	jbe    8038ec <__umoddi3+0xd8>
  80384a:	89 c8                	mov    %ecx,%eax
  80384c:	89 f2                	mov    %esi,%edx
  80384e:	f7 f7                	div    %edi
  803850:	89 d0                	mov    %edx,%eax
  803852:	31 d2                	xor    %edx,%edx
  803854:	83 c4 1c             	add    $0x1c,%esp
  803857:	5b                   	pop    %ebx
  803858:	5e                   	pop    %esi
  803859:	5f                   	pop    %edi
  80385a:	5d                   	pop    %ebp
  80385b:	c3                   	ret    
  80385c:	39 f0                	cmp    %esi,%eax
  80385e:	0f 87 ac 00 00 00    	ja     803910 <__umoddi3+0xfc>
  803864:	0f bd e8             	bsr    %eax,%ebp
  803867:	83 f5 1f             	xor    $0x1f,%ebp
  80386a:	0f 84 ac 00 00 00    	je     80391c <__umoddi3+0x108>
  803870:	bf 20 00 00 00       	mov    $0x20,%edi
  803875:	29 ef                	sub    %ebp,%edi
  803877:	89 fe                	mov    %edi,%esi
  803879:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80387d:	89 e9                	mov    %ebp,%ecx
  80387f:	d3 e0                	shl    %cl,%eax
  803881:	89 d7                	mov    %edx,%edi
  803883:	89 f1                	mov    %esi,%ecx
  803885:	d3 ef                	shr    %cl,%edi
  803887:	09 c7                	or     %eax,%edi
  803889:	89 e9                	mov    %ebp,%ecx
  80388b:	d3 e2                	shl    %cl,%edx
  80388d:	89 14 24             	mov    %edx,(%esp)
  803890:	89 d8                	mov    %ebx,%eax
  803892:	d3 e0                	shl    %cl,%eax
  803894:	89 c2                	mov    %eax,%edx
  803896:	8b 44 24 08          	mov    0x8(%esp),%eax
  80389a:	d3 e0                	shl    %cl,%eax
  80389c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a4:	89 f1                	mov    %esi,%ecx
  8038a6:	d3 e8                	shr    %cl,%eax
  8038a8:	09 d0                	or     %edx,%eax
  8038aa:	d3 eb                	shr    %cl,%ebx
  8038ac:	89 da                	mov    %ebx,%edx
  8038ae:	f7 f7                	div    %edi
  8038b0:	89 d3                	mov    %edx,%ebx
  8038b2:	f7 24 24             	mull   (%esp)
  8038b5:	89 c6                	mov    %eax,%esi
  8038b7:	89 d1                	mov    %edx,%ecx
  8038b9:	39 d3                	cmp    %edx,%ebx
  8038bb:	0f 82 87 00 00 00    	jb     803948 <__umoddi3+0x134>
  8038c1:	0f 84 91 00 00 00    	je     803958 <__umoddi3+0x144>
  8038c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038cb:	29 f2                	sub    %esi,%edx
  8038cd:	19 cb                	sbb    %ecx,%ebx
  8038cf:	89 d8                	mov    %ebx,%eax
  8038d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038d5:	d3 e0                	shl    %cl,%eax
  8038d7:	89 e9                	mov    %ebp,%ecx
  8038d9:	d3 ea                	shr    %cl,%edx
  8038db:	09 d0                	or     %edx,%eax
  8038dd:	89 e9                	mov    %ebp,%ecx
  8038df:	d3 eb                	shr    %cl,%ebx
  8038e1:	89 da                	mov    %ebx,%edx
  8038e3:	83 c4 1c             	add    $0x1c,%esp
  8038e6:	5b                   	pop    %ebx
  8038e7:	5e                   	pop    %esi
  8038e8:	5f                   	pop    %edi
  8038e9:	5d                   	pop    %ebp
  8038ea:	c3                   	ret    
  8038eb:	90                   	nop
  8038ec:	89 fd                	mov    %edi,%ebp
  8038ee:	85 ff                	test   %edi,%edi
  8038f0:	75 0b                	jne    8038fd <__umoddi3+0xe9>
  8038f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f7:	31 d2                	xor    %edx,%edx
  8038f9:	f7 f7                	div    %edi
  8038fb:	89 c5                	mov    %eax,%ebp
  8038fd:	89 f0                	mov    %esi,%eax
  8038ff:	31 d2                	xor    %edx,%edx
  803901:	f7 f5                	div    %ebp
  803903:	89 c8                	mov    %ecx,%eax
  803905:	f7 f5                	div    %ebp
  803907:	89 d0                	mov    %edx,%eax
  803909:	e9 44 ff ff ff       	jmp    803852 <__umoddi3+0x3e>
  80390e:	66 90                	xchg   %ax,%ax
  803910:	89 c8                	mov    %ecx,%eax
  803912:	89 f2                	mov    %esi,%edx
  803914:	83 c4 1c             	add    $0x1c,%esp
  803917:	5b                   	pop    %ebx
  803918:	5e                   	pop    %esi
  803919:	5f                   	pop    %edi
  80391a:	5d                   	pop    %ebp
  80391b:	c3                   	ret    
  80391c:	3b 04 24             	cmp    (%esp),%eax
  80391f:	72 06                	jb     803927 <__umoddi3+0x113>
  803921:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803925:	77 0f                	ja     803936 <__umoddi3+0x122>
  803927:	89 f2                	mov    %esi,%edx
  803929:	29 f9                	sub    %edi,%ecx
  80392b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80392f:	89 14 24             	mov    %edx,(%esp)
  803932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803936:	8b 44 24 04          	mov    0x4(%esp),%eax
  80393a:	8b 14 24             	mov    (%esp),%edx
  80393d:	83 c4 1c             	add    $0x1c,%esp
  803940:	5b                   	pop    %ebx
  803941:	5e                   	pop    %esi
  803942:	5f                   	pop    %edi
  803943:	5d                   	pop    %ebp
  803944:	c3                   	ret    
  803945:	8d 76 00             	lea    0x0(%esi),%esi
  803948:	2b 04 24             	sub    (%esp),%eax
  80394b:	19 fa                	sbb    %edi,%edx
  80394d:	89 d1                	mov    %edx,%ecx
  80394f:	89 c6                	mov    %eax,%esi
  803951:	e9 71 ff ff ff       	jmp    8038c7 <__umoddi3+0xb3>
  803956:	66 90                	xchg   %ax,%ax
  803958:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80395c:	72 ea                	jb     803948 <__umoddi3+0x134>
  80395e:	89 d9                	mov    %ebx,%ecx
  803960:	e9 62 ff ff ff       	jmp    8038c7 <__umoddi3+0xb3>
