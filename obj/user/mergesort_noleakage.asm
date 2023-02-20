
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 16 22 00 00       	call   80225c <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 3b 80 00       	push   $0x803b40
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 3b 80 00       	push   $0x803b42
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 3b 80 00       	push   $0x803b58
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 3b 80 00       	push   $0x803b42
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 3b 80 00       	push   $0x803b40
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 3b 80 00       	push   $0x803b70
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 36 1c 00 00       	call   801d0b <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 3b 80 00       	push   $0x803b90
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 3b 80 00       	push   $0x803bb2
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 3b 80 00       	push   $0x803bc0
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 3b 80 00       	push   $0x803bcf
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 3b 80 00       	push   $0x803bdf
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
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
  800162:	e8 0f 21 00 00       	call   802276 <sys_enable_interrupt>

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
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 80 20 00 00       	call   80225c <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 3b 80 00       	push   $0x803be8
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 85 20 00 00       	call   802276 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 1c 3c 80 00       	push   $0x803c1c
  800213:	6a 4a                	push   $0x4a
  800215:	68 3e 3c 80 00       	push   $0x803c3e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 38 20 00 00       	call   80225c <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 5c 3c 80 00       	push   $0x803c5c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 90 3c 80 00       	push   $0x803c90
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c4 3c 80 00       	push   $0x803cc4
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 1d 20 00 00       	call   802276 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 32 1b 00 00       	call   801d96 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 f0 1f 00 00       	call   80225c <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 f6 3c 80 00       	push   $0x803cf6
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 b1 1f 00 00       	call   802276 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 40 3b 80 00       	push   $0x803b40
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 14 3d 80 00       	push   $0x803d14
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 19 3d 80 00       	push   $0x803d19
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 bc 17 00 00       	call   801d0b <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 a7 17 00 00       	call   801d0b <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 85 16 00 00       	call   801d96 <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 77 16 00 00       	call   801d96 <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 52 1b 00 00       	call   802290 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 0d 1b 00 00       	call   80225c <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 2e 1b 00 00       	call   802290 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 0c 1b 00 00       	call   802276 <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 56 19 00 00       	call   8020d7 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 c2 1a 00 00       	call   80225c <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 2f 19 00 00       	call   8020d7 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 c0 1a 00 00       	call   802276 <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 7f 1c 00 00       	call   80244f <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 21 1a 00 00       	call   80225c <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 38 3d 80 00       	push   $0x803d38
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 60 3d 80 00       	push   $0x803d60
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 88 3d 80 00       	push   $0x803d88
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 e0 3d 80 00       	push   $0x803de0
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 38 3d 80 00       	push   $0x803d38
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 a1 19 00 00       	call   802276 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 2e 1b 00 00       	call   80241b <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 83 1b 00 00       	call   802481 <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 f4 3d 80 00       	push   $0x803df4
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 f9 3d 80 00       	push   $0x803df9
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 15 3e 80 00       	push   $0x803e15
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 18 3e 80 00       	push   $0x803e18
  800990:	6a 26                	push   $0x26
  800992:	68 64 3e 80 00       	push   $0x803e64
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 70 3e 80 00       	push   $0x803e70
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 64 3e 80 00       	push   $0x803e64
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 c4 3e 80 00       	push   $0x803ec4
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 64 3e 80 00       	push   $0x803e64
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 82 15 00 00       	call   8020ae <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 0b 15 00 00       	call   8020ae <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 6f 16 00 00       	call   80225c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 69 16 00 00       	call   802276 <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 85 2c 00 00       	call   8038dc <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 45 2d 00 00       	call   8039ec <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 34 41 80 00       	add    $0x804134,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 45 41 80 00       	push   $0x804145
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 4e 41 80 00       	push   $0x80414e
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be 51 41 80 00       	mov    $0x804151,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 b0 42 80 00       	push   $0x8042b0
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 b3 42 80 00       	push   $0x8042b3
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 1c 0f 00 00       	call   80225c <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 b0 42 80 00       	push   $0x8042b0
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 b3 42 80 00       	push   $0x8042b3
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 da 0e 00 00       	call   802276 <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 42 0e 00 00       	call   802276 <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 c4 42 80 00       	push   $0x8042c4
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801b7c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b83:	00 00 00 
  801b86:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b8d:	00 00 00 
  801b90:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b97:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801b9a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ba1:	00 00 00 
  801ba4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801bab:	00 00 00 
  801bae:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801bb5:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801bb8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bbf:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801bc2:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801bc9:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bdd:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801be2:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	6a 06                	push   $0x6
  801bfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfe:	50                   	push   %eax
  801bff:	e8 ee 05 00 00       	call   8021f2 <sys_allocate_chunk>
  801c04:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c07:	a1 20 51 80 00       	mov    0x805120,%eax
  801c0c:	83 ec 0c             	sub    $0xc,%esp
  801c0f:	50                   	push   %eax
  801c10:	e8 63 0c 00 00       	call   802878 <initialize_MemBlocksList>
  801c15:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801c18:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c23:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c3b:	89 c2                	mov    %eax,%edx
  801c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c40:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c46:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801c4d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c57:	8b 50 08             	mov    0x8(%eax),%edx
  801c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5d:	01 d0                	add    %edx,%eax
  801c5f:	48                   	dec    %eax
  801c60:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c66:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6b:	f7 75 e0             	divl   -0x20(%ebp)
  801c6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c71:	29 d0                	sub    %edx,%eax
  801c73:	89 c2                	mov    %eax,%edx
  801c75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c78:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801c7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c7f:	75 14                	jne    801c95 <initialize_dyn_block_system+0x11f>
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	68 e9 42 80 00       	push   $0x8042e9
  801c89:	6a 34                	push   $0x34
  801c8b:	68 07 43 80 00       	push   $0x804307
  801c90:	e8 6c ec ff ff       	call   800901 <_panic>
  801c95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c98:	8b 00                	mov    (%eax),%eax
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	74 10                	je     801cae <initialize_dyn_block_system+0x138>
  801c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca6:	8b 52 04             	mov    0x4(%edx),%edx
  801ca9:	89 50 04             	mov    %edx,0x4(%eax)
  801cac:	eb 0b                	jmp    801cb9 <initialize_dyn_block_system+0x143>
  801cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb1:	8b 40 04             	mov    0x4(%eax),%eax
  801cb4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cbc:	8b 40 04             	mov    0x4(%eax),%eax
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	74 0f                	je     801cd2 <initialize_dyn_block_system+0x15c>
  801cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc6:	8b 40 04             	mov    0x4(%eax),%eax
  801cc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ccc:	8b 12                	mov    (%edx),%edx
  801cce:	89 10                	mov    %edx,(%eax)
  801cd0:	eb 0a                	jmp    801cdc <initialize_dyn_block_system+0x166>
  801cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cd5:	8b 00                	mov    (%eax),%eax
  801cd7:	a3 48 51 80 00       	mov    %eax,0x805148
  801cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cef:	a1 54 51 80 00       	mov    0x805154,%eax
  801cf4:	48                   	dec    %eax
  801cf5:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	ff 75 e8             	pushl  -0x18(%ebp)
  801d00:	e8 c4 13 00 00       	call   8030c9 <insert_sorted_with_merge_freeList>
  801d05:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801d08:	90                   	nop
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <malloc>:
//=================================



void* malloc(uint32 size)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d11:	e8 2f fe ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d1a:	75 07                	jne    801d23 <malloc+0x18>
  801d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d21:	eb 71                	jmp    801d94 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801d23:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d2a:	76 07                	jbe    801d33 <malloc+0x28>
	return NULL;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d31:	eb 61                	jmp    801d94 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d33:	e8 88 08 00 00       	call   8025c0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	74 53                	je     801d8f <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d3c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d43:	8b 55 08             	mov    0x8(%ebp),%edx
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	01 d0                	add    %edx,%eax
  801d4b:	48                   	dec    %eax
  801d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
  801d57:	f7 75 f4             	divl   -0xc(%ebp)
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5d:	29 d0                	sub    %edx,%eax
  801d5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801d62:	83 ec 0c             	sub    $0xc,%esp
  801d65:	ff 75 ec             	pushl  -0x14(%ebp)
  801d68:	e8 d2 0d 00 00       	call   802b3f <alloc_block_FF>
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801d73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d77:	74 16                	je     801d8f <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801d79:	83 ec 0c             	sub    $0xc,%esp
  801d7c:	ff 75 e8             	pushl  -0x18(%ebp)
  801d7f:	e8 0c 0c 00 00       	call   802990 <insert_sorted_allocList>
  801d84:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d8a:	8b 40 08             	mov    0x8(%eax),%eax
  801d8d:	eb 05                	jmp    801d94 <malloc+0x89>
    }

			}


	return NULL;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801dad:	83 ec 08             	sub    $0x8,%esp
  801db0:	ff 75 f0             	pushl  -0x10(%ebp)
  801db3:	68 40 50 80 00       	push   $0x805040
  801db8:	e8 a0 0b 00 00       	call   80295d <find_block>
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc6:	8b 50 0c             	mov    0xc(%eax),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	52                   	push   %edx
  801dd0:	50                   	push   %eax
  801dd1:	e8 e4 03 00 00       	call   8021ba <sys_free_user_mem>
  801dd6:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801dd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ddd:	75 17                	jne    801df6 <free+0x60>
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	68 e9 42 80 00       	push   $0x8042e9
  801de7:	68 84 00 00 00       	push   $0x84
  801dec:	68 07 43 80 00       	push   $0x804307
  801df1:	e8 0b eb ff ff       	call   800901 <_panic>
  801df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df9:	8b 00                	mov    (%eax),%eax
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	74 10                	je     801e0f <free+0x79>
  801dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e02:	8b 00                	mov    (%eax),%eax
  801e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e07:	8b 52 04             	mov    0x4(%edx),%edx
  801e0a:	89 50 04             	mov    %edx,0x4(%eax)
  801e0d:	eb 0b                	jmp    801e1a <free+0x84>
  801e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e12:	8b 40 04             	mov    0x4(%eax),%eax
  801e15:	a3 44 50 80 00       	mov    %eax,0x805044
  801e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1d:	8b 40 04             	mov    0x4(%eax),%eax
  801e20:	85 c0                	test   %eax,%eax
  801e22:	74 0f                	je     801e33 <free+0x9d>
  801e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e27:	8b 40 04             	mov    0x4(%eax),%eax
  801e2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e2d:	8b 12                	mov    (%edx),%edx
  801e2f:	89 10                	mov    %edx,(%eax)
  801e31:	eb 0a                	jmp    801e3d <free+0xa7>
  801e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e36:	8b 00                	mov    (%eax),%eax
  801e38:	a3 40 50 80 00       	mov    %eax,0x805040
  801e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e50:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e55:	48                   	dec    %eax
  801e56:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	ff 75 ec             	pushl  -0x14(%ebp)
  801e61:	e8 63 12 00 00       	call   8030c9 <insert_sorted_with_merge_freeList>
  801e66:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801e69:	90                   	nop
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 38             	sub    $0x38,%esp
  801e72:	8b 45 10             	mov    0x10(%ebp),%eax
  801e75:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e78:	e8 c8 fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e81:	75 0a                	jne    801e8d <smalloc+0x21>
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
  801e88:	e9 a0 00 00 00       	jmp    801f2d <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801e8d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801e94:	76 0a                	jbe    801ea0 <smalloc+0x34>
		return NULL;
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	e9 8d 00 00 00       	jmp    801f2d <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ea0:	e8 1b 07 00 00       	call   8025c0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	74 7f                	je     801f28 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801ea9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb6:	01 d0                	add    %edx,%eax
  801eb8:	48                   	dec    %eax
  801eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec4:	f7 75 f4             	divl   -0xc(%ebp)
  801ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eca:	29 d0                	sub    %edx,%eax
  801ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	ff 75 ec             	pushl  -0x14(%ebp)
  801ed5:	e8 65 0c 00 00       	call   802b3f <alloc_block_FF>
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801ee0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ee4:	74 42                	je     801f28 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801ee6:	83 ec 0c             	sub    $0xc,%esp
  801ee9:	ff 75 e8             	pushl  -0x18(%ebp)
  801eec:	e8 9f 0a 00 00       	call   802990 <insert_sorted_allocList>
  801ef1:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef7:	8b 40 08             	mov    0x8(%eax),%eax
  801efa:	89 c2                	mov    %eax,%edx
  801efc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	ff 75 0c             	pushl  0xc(%ebp)
  801f05:	ff 75 08             	pushl  0x8(%ebp)
  801f08:	e8 38 04 00 00       	call   802345 <sys_createSharedObject>
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f17:	79 07                	jns    801f20 <smalloc+0xb4>
	    		  return NULL;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	eb 0d                	jmp    801f2d <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f23:	8b 40 08             	mov    0x8(%eax),%eax
  801f26:	eb 05                	jmp    801f2d <smalloc+0xc1>


				}


		return NULL;
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f35:	e8 0b fc ff ff       	call   801b45 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f3a:	e8 81 06 00 00       	call   8025c0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	0f 84 9f 00 00 00    	je     801fe6 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f47:	83 ec 08             	sub    $0x8,%esp
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	e8 1a 04 00 00       	call   80236f <sys_getSizeOfSharedObject>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5f:	79 0a                	jns    801f6b <sget+0x3c>
		return NULL;
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	e9 80 00 00 00       	jmp    801feb <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801f6b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	48                   	dec    %eax
  801f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f81:	ba 00 00 00 00       	mov    $0x0,%edx
  801f86:	f7 75 f0             	divl   -0x10(%ebp)
  801f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8c:	29 d0                	sub    %edx,%eax
  801f8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	ff 75 e8             	pushl  -0x18(%ebp)
  801f97:	e8 a3 0b 00 00       	call   802b3f <alloc_block_FF>
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801fa2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fa6:	74 3e                	je     801fe6 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fae:	e8 dd 09 00 00       	call   802990 <insert_sorted_allocList>
  801fb3:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb9:	8b 40 08             	mov    0x8(%eax),%eax
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	50                   	push   %eax
  801fc0:	ff 75 0c             	pushl  0xc(%ebp)
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	e8 c1 03 00 00       	call   80238c <sys_getSharedObject>
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801fd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fd5:	79 07                	jns    801fde <sget+0xaf>
	    		  return NULL;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	eb 0d                	jmp    801feb <sget+0xbc>
	  	return(void*) returned_block->sva;
  801fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe1:	8b 40 08             	mov    0x8(%eax),%eax
  801fe4:	eb 05                	jmp    801feb <sget+0xbc>
	      }
	}
	   return NULL;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff3:	e8 4d fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 14 43 80 00       	push   $0x804314
  802000:	68 12 01 00 00       	push   $0x112
  802005:	68 07 43 80 00       	push   $0x804307
  80200a:	e8 f2 e8 ff ff       	call   800901 <_panic>

0080200f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 3c 43 80 00       	push   $0x80433c
  80201d:	68 26 01 00 00       	push   $0x126
  802022:	68 07 43 80 00       	push   $0x804307
  802027:	e8 d5 e8 ff ff       	call   800901 <_panic>

0080202c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802032:	83 ec 04             	sub    $0x4,%esp
  802035:	68 60 43 80 00       	push   $0x804360
  80203a:	68 31 01 00 00       	push   $0x131
  80203f:	68 07 43 80 00       	push   $0x804307
  802044:	e8 b8 e8 ff ff       	call   800901 <_panic>

00802049 <shrink>:

}
void shrink(uint32 newSize)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	68 60 43 80 00       	push   $0x804360
  802057:	68 36 01 00 00       	push   $0x136
  80205c:	68 07 43 80 00       	push   $0x804307
  802061:	e8 9b e8 ff ff       	call   800901 <_panic>

00802066 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	68 60 43 80 00       	push   $0x804360
  802074:	68 3b 01 00 00       	push   $0x13b
  802079:	68 07 43 80 00       	push   $0x804307
  80207e:	e8 7e e8 ff ff       	call   800901 <_panic>

00802083 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	57                   	push   %edi
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
  802089:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802092:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802095:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802098:	8b 7d 18             	mov    0x18(%ebp),%edi
  80209b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80209e:	cd 30                	int    $0x30
  8020a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020a6:	83 c4 10             	add    $0x10,%esp
  8020a9:	5b                   	pop    %ebx
  8020aa:	5e                   	pop    %esi
  8020ab:	5f                   	pop    %edi
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    

008020ae <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020ba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	52                   	push   %edx
  8020c6:	ff 75 0c             	pushl  0xc(%ebp)
  8020c9:	50                   	push   %eax
  8020ca:	6a 00                	push   $0x0
  8020cc:	e8 b2 ff ff ff       	call   802083 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 01                	push   $0x1
  8020e6:	e8 98 ff ff ff       	call   802083 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	52                   	push   %edx
  802100:	50                   	push   %eax
  802101:	6a 05                	push   $0x5
  802103:	e8 7b ff ff ff       	call   802083 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	56                   	push   %esi
  802111:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802112:	8b 75 18             	mov    0x18(%ebp),%esi
  802115:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802118:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	56                   	push   %esi
  802122:	53                   	push   %ebx
  802123:	51                   	push   %ecx
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	6a 06                	push   $0x6
  802128:	e8 56 ff ff ff       	call   802083 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5d                   	pop    %ebp
  802136:	c3                   	ret    

00802137 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	52                   	push   %edx
  802147:	50                   	push   %eax
  802148:	6a 07                	push   $0x7
  80214a:	e8 34 ff ff ff       	call   802083 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	ff 75 0c             	pushl  0xc(%ebp)
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	6a 08                	push   $0x8
  802165:	e8 19 ff ff ff       	call   802083 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 09                	push   $0x9
  80217e:	e8 00 ff ff ff       	call   802083 <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 0a                	push   $0xa
  802197:	e8 e7 fe ff ff       	call   802083 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 0b                	push   $0xb
  8021b0:	e8 ce fe ff ff       	call   802083 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	ff 75 0c             	pushl  0xc(%ebp)
  8021c6:	ff 75 08             	pushl  0x8(%ebp)
  8021c9:	6a 0f                	push   $0xf
  8021cb:	e8 b3 fe ff ff       	call   802083 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
	return;
  8021d3:	90                   	nop
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 0c             	pushl  0xc(%ebp)
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	6a 10                	push   $0x10
  8021e7:	e8 97 fe ff ff       	call   802083 <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ef:	90                   	nop
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	ff 75 10             	pushl  0x10(%ebp)
  8021fc:	ff 75 0c             	pushl  0xc(%ebp)
  8021ff:	ff 75 08             	pushl  0x8(%ebp)
  802202:	6a 11                	push   $0x11
  802204:	e8 7a fe ff ff       	call   802083 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
	return ;
  80220c:	90                   	nop
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 0c                	push   $0xc
  80221e:	e8 60 fe ff ff       	call   802083 <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	ff 75 08             	pushl  0x8(%ebp)
  802236:	6a 0d                	push   $0xd
  802238:	e8 46 fe ff ff       	call   802083 <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 0e                	push   $0xe
  802251:	e8 2d fe ff ff       	call   802083 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	90                   	nop
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 13                	push   $0x13
  80226b:	e8 13 fe ff ff       	call   802083 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	90                   	nop
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 14                	push   $0x14
  802285:	e8 f9 fd ff ff       	call   802083 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	90                   	nop
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_cputc>:


void
sys_cputc(const char c)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80229c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	50                   	push   %eax
  8022a9:	6a 15                	push   $0x15
  8022ab:	e8 d3 fd ff ff       	call   802083 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	90                   	nop
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 16                	push   $0x16
  8022c5:	e8 b9 fd ff ff       	call   802083 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	90                   	nop
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	ff 75 0c             	pushl  0xc(%ebp)
  8022df:	50                   	push   %eax
  8022e0:	6a 17                	push   $0x17
  8022e2:	e8 9c fd ff ff       	call   802083 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	52                   	push   %edx
  8022fc:	50                   	push   %eax
  8022fd:	6a 1a                	push   $0x1a
  8022ff:	e8 7f fd ff ff       	call   802083 <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80230c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	52                   	push   %edx
  802319:	50                   	push   %eax
  80231a:	6a 18                	push   $0x18
  80231c:	e8 62 fd ff ff       	call   802083 <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	90                   	nop
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80232a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	52                   	push   %edx
  802337:	50                   	push   %eax
  802338:	6a 19                	push   $0x19
  80233a:	e8 44 fd ff ff       	call   802083 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	90                   	nop
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 04             	sub    $0x4,%esp
  80234b:	8b 45 10             	mov    0x10(%ebp),%eax
  80234e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802351:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802354:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	51                   	push   %ecx
  80235e:	52                   	push   %edx
  80235f:	ff 75 0c             	pushl  0xc(%ebp)
  802362:	50                   	push   %eax
  802363:	6a 1b                	push   $0x1b
  802365:	e8 19 fd ff ff       	call   802083 <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802372:	8b 55 0c             	mov    0xc(%ebp),%edx
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	52                   	push   %edx
  80237f:	50                   	push   %eax
  802380:	6a 1c                	push   $0x1c
  802382:	e8 fc fc ff ff       	call   802083 <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80238f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802392:	8b 55 0c             	mov    0xc(%ebp),%edx
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	51                   	push   %ecx
  80239d:	52                   	push   %edx
  80239e:	50                   	push   %eax
  80239f:	6a 1d                	push   $0x1d
  8023a1:	e8 dd fc ff ff       	call   802083 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	52                   	push   %edx
  8023bb:	50                   	push   %eax
  8023bc:	6a 1e                	push   $0x1e
  8023be:	e8 c0 fc ff ff       	call   802083 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 1f                	push   $0x1f
  8023d7:	e8 a7 fc ff ff       	call   802083 <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	6a 00                	push   $0x0
  8023e9:	ff 75 14             	pushl  0x14(%ebp)
  8023ec:	ff 75 10             	pushl  0x10(%ebp)
  8023ef:	ff 75 0c             	pushl  0xc(%ebp)
  8023f2:	50                   	push   %eax
  8023f3:	6a 20                	push   $0x20
  8023f5:	e8 89 fc ff ff       	call   802083 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	50                   	push   %eax
  80240e:	6a 21                	push   $0x21
  802410:	e8 6e fc ff ff       	call   802083 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	90                   	nop
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	50                   	push   %eax
  80242a:	6a 22                	push   $0x22
  80242c:	e8 52 fc ff ff       	call   802083 <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 02                	push   $0x2
  802445:	e8 39 fc ff ff       	call   802083 <syscall>
  80244a:	83 c4 18             	add    $0x18,%esp
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 03                	push   $0x3
  80245e:	e8 20 fc ff ff       	call   802083 <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 04                	push   $0x4
  802477:	e8 07 fc ff ff       	call   802083 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_exit_env>:


void sys_exit_env(void)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 23                	push   $0x23
  802490:	e8 ee fb ff ff       	call   802083 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	90                   	nop
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024a1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024a4:	8d 50 04             	lea    0x4(%eax),%edx
  8024a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	52                   	push   %edx
  8024b1:	50                   	push   %eax
  8024b2:	6a 24                	push   $0x24
  8024b4:	e8 ca fb ff ff       	call   802083 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
	return result;
  8024bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024c5:	89 01                	mov    %eax,(%ecx)
  8024c7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	c9                   	leave  
  8024ce:	c2 04 00             	ret    $0x4

008024d1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	ff 75 10             	pushl  0x10(%ebp)
  8024db:	ff 75 0c             	pushl  0xc(%ebp)
  8024de:	ff 75 08             	pushl  0x8(%ebp)
  8024e1:	6a 12                	push   $0x12
  8024e3:	e8 9b fb ff ff       	call   802083 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024eb:	90                   	nop
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 25                	push   $0x25
  8024fd:	e8 81 fb ff ff       	call   802083 <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802513:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	50                   	push   %eax
  802520:	6a 26                	push   $0x26
  802522:	e8 5c fb ff ff       	call   802083 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
	return ;
  80252a:	90                   	nop
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <rsttst>:
void rsttst()
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 28                	push   $0x28
  80253c:	e8 42 fb ff ff       	call   802083 <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
	return ;
  802544:	90                   	nop
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	8b 45 14             	mov    0x14(%ebp),%eax
  802550:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802553:	8b 55 18             	mov    0x18(%ebp),%edx
  802556:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80255a:	52                   	push   %edx
  80255b:	50                   	push   %eax
  80255c:	ff 75 10             	pushl  0x10(%ebp)
  80255f:	ff 75 0c             	pushl  0xc(%ebp)
  802562:	ff 75 08             	pushl  0x8(%ebp)
  802565:	6a 27                	push   $0x27
  802567:	e8 17 fb ff ff       	call   802083 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
	return ;
  80256f:	90                   	nop
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <chktst>:
void chktst(uint32 n)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	ff 75 08             	pushl  0x8(%ebp)
  802580:	6a 29                	push   $0x29
  802582:	e8 fc fa ff ff       	call   802083 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
	return ;
  80258a:	90                   	nop
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <inctst>:

void inctst()
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 2a                	push   $0x2a
  80259c:	e8 e2 fa ff ff       	call   802083 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a4:	90                   	nop
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <gettst>:
uint32 gettst()
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 2b                	push   $0x2b
  8025b6:	e8 c8 fa ff ff       	call   802083 <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 2c                	push   $0x2c
  8025d2:	e8 ac fa ff ff       	call   802083 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
  8025da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025dd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025e1:	75 07                	jne    8025ea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e8:	eb 05                	jmp    8025ef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 2c                	push   $0x2c
  802603:	e8 7b fa ff ff       	call   802083 <syscall>
  802608:	83 c4 18             	add    $0x18,%esp
  80260b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80260e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802612:	75 07                	jne    80261b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802614:	b8 01 00 00 00       	mov    $0x1,%eax
  802619:	eb 05                	jmp    802620 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80261b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 2c                	push   $0x2c
  802634:	e8 4a fa ff ff       	call   802083 <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
  80263c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80263f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802643:	75 07                	jne    80264c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802645:	b8 01 00 00 00       	mov    $0x1,%eax
  80264a:	eb 05                	jmp    802651 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 2c                	push   $0x2c
  802665:	e8 19 fa ff ff       	call   802083 <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
  80266d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802670:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802674:	75 07                	jne    80267d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802676:	b8 01 00 00 00       	mov    $0x1,%eax
  80267b:	eb 05                	jmp    802682 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	ff 75 08             	pushl  0x8(%ebp)
  802692:	6a 2d                	push   $0x2d
  802694:	e8 ea f9 ff ff       	call   802083 <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
	return ;
  80269c:	90                   	nop
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	6a 00                	push   $0x0
  8026b1:	53                   	push   %ebx
  8026b2:	51                   	push   %ecx
  8026b3:	52                   	push   %edx
  8026b4:	50                   	push   %eax
  8026b5:	6a 2e                	push   $0x2e
  8026b7:	e8 c7 f9 ff ff       	call   802083 <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
}
  8026bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	52                   	push   %edx
  8026d4:	50                   	push   %eax
  8026d5:	6a 2f                	push   $0x2f
  8026d7:	e8 a7 f9 ff ff       	call   802083 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026e7:	83 ec 0c             	sub    $0xc,%esp
  8026ea:	68 70 43 80 00       	push   $0x804370
  8026ef:	e8 c1 e4 ff ff       	call   800bb5 <cprintf>
  8026f4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	68 9c 43 80 00       	push   $0x80439c
  802706:	e8 aa e4 ff ff       	call   800bb5 <cprintf>
  80270b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80270e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802712:	a1 38 51 80 00       	mov    0x805138,%eax
  802717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271a:	eb 56                	jmp    802772 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80271c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802720:	74 1c                	je     80273e <print_mem_block_lists+0x5d>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 50 08             	mov    0x8(%eax),%edx
  802728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272b:	8b 48 08             	mov    0x8(%eax),%ecx
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 40 0c             	mov    0xc(%eax),%eax
  802734:	01 c8                	add    %ecx,%eax
  802736:	39 c2                	cmp    %eax,%edx
  802738:	73 04                	jae    80273e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80273a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 50 08             	mov    0x8(%eax),%edx
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 40 0c             	mov    0xc(%eax),%eax
  80274a:	01 c2                	add    %eax,%edx
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 08             	mov    0x8(%eax),%eax
  802752:	83 ec 04             	sub    $0x4,%esp
  802755:	52                   	push   %edx
  802756:	50                   	push   %eax
  802757:	68 b1 43 80 00       	push   $0x8043b1
  80275c:	e8 54 e4 ff ff       	call   800bb5 <cprintf>
  802761:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80276a:	a1 40 51 80 00       	mov    0x805140,%eax
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802776:	74 07                	je     80277f <print_mem_block_lists+0x9e>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	eb 05                	jmp    802784 <print_mem_block_lists+0xa3>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	a3 40 51 80 00       	mov    %eax,0x805140
  802789:	a1 40 51 80 00       	mov    0x805140,%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	75 8a                	jne    80271c <print_mem_block_lists+0x3b>
  802792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802796:	75 84                	jne    80271c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802798:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80279c:	75 10                	jne    8027ae <print_mem_block_lists+0xcd>
  80279e:	83 ec 0c             	sub    $0xc,%esp
  8027a1:	68 c0 43 80 00       	push   $0x8043c0
  8027a6:	e8 0a e4 ff ff       	call   800bb5 <cprintf>
  8027ab:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	68 e4 43 80 00       	push   $0x8043e4
  8027bd:	e8 f3 e3 ff ff       	call   800bb5 <cprintf>
  8027c2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027c5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	eb 56                	jmp    802829 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d7:	74 1c                	je     8027f5 <print_mem_block_lists+0x114>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 48 08             	mov    0x8(%eax),%ecx
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	01 c8                	add    %ecx,%eax
  8027ed:	39 c2                	cmp    %eax,%edx
  8027ef:	73 04                	jae    8027f5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027f1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 50 08             	mov    0x8(%eax),%edx
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802801:	01 c2                	add    %eax,%edx
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	83 ec 04             	sub    $0x4,%esp
  80280c:	52                   	push   %edx
  80280d:	50                   	push   %eax
  80280e:	68 b1 43 80 00       	push   $0x8043b1
  802813:	e8 9d e3 ff ff       	call   800bb5 <cprintf>
  802818:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802821:	a1 48 50 80 00       	mov    0x805048,%eax
  802826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282d:	74 07                	je     802836 <print_mem_block_lists+0x155>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	eb 05                	jmp    80283b <print_mem_block_lists+0x15a>
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	a3 48 50 80 00       	mov    %eax,0x805048
  802840:	a1 48 50 80 00       	mov    0x805048,%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	75 8a                	jne    8027d3 <print_mem_block_lists+0xf2>
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	75 84                	jne    8027d3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80284f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802853:	75 10                	jne    802865 <print_mem_block_lists+0x184>
  802855:	83 ec 0c             	sub    $0xc,%esp
  802858:	68 fc 43 80 00       	push   $0x8043fc
  80285d:	e8 53 e3 ff ff       	call   800bb5 <cprintf>
  802862:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	68 70 43 80 00       	push   $0x804370
  80286d:	e8 43 e3 ff ff       	call   800bb5 <cprintf>
  802872:	83 c4 10             	add    $0x10,%esp

}
  802875:	90                   	nop
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80287e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802885:	00 00 00 
  802888:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80288f:	00 00 00 
  802892:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802899:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80289c:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8028a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028ab:	e9 9e 00 00 00       	jmp    80294e <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8028b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b8:	c1 e2 04             	shl    $0x4,%edx
  8028bb:	01 d0                	add    %edx,%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	75 14                	jne    8028d5 <initialize_MemBlocksList+0x5d>
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	68 24 44 80 00       	push   $0x804424
  8028c9:	6a 48                	push   $0x48
  8028cb:	68 47 44 80 00       	push   $0x804447
  8028d0:	e8 2c e0 ff ff       	call   800901 <_panic>
  8028d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8028da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dd:	c1 e2 04             	shl    $0x4,%edx
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028e8:	89 10                	mov    %edx,(%eax)
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	74 18                	je     802908 <initialize_MemBlocksList+0x90>
  8028f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028fe:	c1 e1 04             	shl    $0x4,%ecx
  802901:	01 ca                	add    %ecx,%edx
  802903:	89 50 04             	mov    %edx,0x4(%eax)
  802906:	eb 12                	jmp    80291a <initialize_MemBlocksList+0xa2>
  802908:	a1 50 50 80 00       	mov    0x805050,%eax
  80290d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802910:	c1 e2 04             	shl    $0x4,%edx
  802913:	01 d0                	add    %edx,%eax
  802915:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80291a:	a1 50 50 80 00       	mov    0x805050,%eax
  80291f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802922:	c1 e2 04             	shl    $0x4,%edx
  802925:	01 d0                	add    %edx,%eax
  802927:	a3 48 51 80 00       	mov    %eax,0x805148
  80292c:	a1 50 50 80 00       	mov    0x805050,%eax
  802931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802934:	c1 e2 04             	shl    $0x4,%edx
  802937:	01 d0                	add    %edx,%eax
  802939:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802940:	a1 54 51 80 00       	mov    0x805154,%eax
  802945:	40                   	inc    %eax
  802946:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80294b:	ff 45 f4             	incl   -0xc(%ebp)
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	3b 45 08             	cmp    0x8(%ebp),%eax
  802954:	0f 82 56 ff ff ff    	jb     8028b0 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80295a:	90                   	nop
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
  802960:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80296b:	eb 18                	jmp    802985 <find_block+0x28>
		{
			if(tmp->sva==va)
  80296d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802970:	8b 40 08             	mov    0x8(%eax),%eax
  802973:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802976:	75 05                	jne    80297d <find_block+0x20>
			{
				return tmp;
  802978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80297b:	eb 11                	jmp    80298e <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80297d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802985:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802989:	75 e2                	jne    80296d <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80298b:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802996:	a1 40 50 80 00       	mov    0x805040,%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	0f 85 83 00 00 00    	jne    802a26 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8029a3:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8029aa:	00 00 00 
  8029ad:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8029b4:	00 00 00 
  8029b7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8029be:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8029c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c5:	75 14                	jne    8029db <insert_sorted_allocList+0x4b>
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 24 44 80 00       	push   $0x804424
  8029cf:	6a 7f                	push   $0x7f
  8029d1:	68 47 44 80 00       	push   $0x804447
  8029d6:	e8 26 df ff ff       	call   800901 <_panic>
  8029db:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	89 10                	mov    %edx,(%eax)
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0d                	je     8029fc <insert_sorted_allocList+0x6c>
  8029ef:	a1 40 50 80 00       	mov    0x805040,%eax
  8029f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f7:	89 50 04             	mov    %edx,0x4(%eax)
  8029fa:	eb 08                	jmp    802a04 <insert_sorted_allocList+0x74>
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	a3 44 50 80 00       	mov    %eax,0x805044
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	a3 40 50 80 00       	mov    %eax,0x805040
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a16:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a1b:	40                   	inc    %eax
  802a1c:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a21:	e9 16 01 00 00       	jmp    802b3c <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	8b 50 08             	mov    0x8(%eax),%edx
  802a2c:	a1 44 50 80 00       	mov    0x805044,%eax
  802a31:	8b 40 08             	mov    0x8(%eax),%eax
  802a34:	39 c2                	cmp    %eax,%edx
  802a36:	76 68                	jbe    802aa0 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802a38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3c:	75 17                	jne    802a55 <insert_sorted_allocList+0xc5>
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	68 60 44 80 00       	push   $0x804460
  802a46:	68 85 00 00 00       	push   $0x85
  802a4b:	68 47 44 80 00       	push   $0x804447
  802a50:	e8 ac de ff ff       	call   800901 <_panic>
  802a55:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	89 50 04             	mov    %edx,0x4(%eax)
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0c                	je     802a77 <insert_sorted_allocList+0xe7>
  802a6b:	a1 44 50 80 00       	mov    0x805044,%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 10                	mov    %edx,(%eax)
  802a75:	eb 08                	jmp    802a7f <insert_sorted_allocList+0xef>
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	a3 44 50 80 00       	mov    %eax,0x805044
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a90:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a95:	40                   	inc    %eax
  802a96:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a9b:	e9 9c 00 00 00       	jmp    802b3c <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802aa0:	a1 40 50 80 00       	mov    0x805040,%eax
  802aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802aa8:	e9 85 00 00 00       	jmp    802b32 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	8b 50 08             	mov    0x8(%eax),%edx
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 08             	mov    0x8(%eax),%eax
  802ab9:	39 c2                	cmp    %eax,%edx
  802abb:	73 6d                	jae    802b2a <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac1:	74 06                	je     802ac9 <insert_sorted_allocList+0x139>
  802ac3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac7:	75 17                	jne    802ae0 <insert_sorted_allocList+0x150>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 84 44 80 00       	push   $0x804484
  802ad1:	68 90 00 00 00       	push   $0x90
  802ad6:	68 47 44 80 00       	push   $0x804447
  802adb:	e8 21 de ff ff       	call   800901 <_panic>
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 50 04             	mov    0x4(%eax),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	74 0d                	je     802b0b <insert_sorted_allocList+0x17b>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	8b 55 08             	mov    0x8(%ebp),%edx
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	eb 08                	jmp    802b13 <insert_sorted_allocList+0x183>
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	a3 40 50 80 00       	mov    %eax,0x805040
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 55 08             	mov    0x8(%ebp),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b21:	40                   	inc    %eax
  802b22:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b27:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802b28:	eb 12                	jmp    802b3c <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b36:	0f 85 71 ff ff ff    	jne    802aad <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802b3c:	90                   	nop
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802b3f:	55                   	push   %ebp
  802b40:	89 e5                	mov    %esp,%ebp
  802b42:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802b45:	a1 38 51 80 00       	mov    0x805138,%eax
  802b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802b4d:	e9 76 01 00 00       	jmp    802cc8 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 0c             	mov    0xc(%eax),%eax
  802b58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5b:	0f 85 8a 00 00 00    	jne    802beb <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	75 17                	jne    802b7e <alloc_block_FF+0x3f>
  802b67:	83 ec 04             	sub    $0x4,%esp
  802b6a:	68 b9 44 80 00       	push   $0x8044b9
  802b6f:	68 a8 00 00 00       	push   $0xa8
  802b74:	68 47 44 80 00       	push   $0x804447
  802b79:	e8 83 dd ff ff       	call   800901 <_panic>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 10                	je     802b97 <alloc_block_FF+0x58>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8f:	8b 52 04             	mov    0x4(%edx),%edx
  802b92:	89 50 04             	mov    %edx,0x4(%eax)
  802b95:	eb 0b                	jmp    802ba2 <alloc_block_FF+0x63>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	74 0f                	je     802bbb <alloc_block_FF+0x7c>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 04             	mov    0x4(%eax),%eax
  802bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb5:	8b 12                	mov    (%edx),%edx
  802bb7:	89 10                	mov    %edx,(%eax)
  802bb9:	eb 0a                	jmp    802bc5 <alloc_block_FF+0x86>
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	a3 38 51 80 00       	mov    %eax,0x805138
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd8:	a1 44 51 80 00       	mov    0x805144,%eax
  802bdd:	48                   	dec    %eax
  802bde:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	e9 ea 00 00 00       	jmp    802cd5 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf4:	0f 86 c6 00 00 00    	jbe    802cc0 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802bfa:	a1 48 51 80 00       	mov    0x805148,%eax
  802bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1d:	2b 45 08             	sub    0x8(%ebp),%eax
  802c20:	89 c2                	mov    %eax,%edx
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	01 c2                	add    %eax,%edx
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3d:	75 17                	jne    802c56 <alloc_block_FF+0x117>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 b9 44 80 00       	push   $0x8044b9
  802c47:	68 b6 00 00 00       	push   $0xb6
  802c4c:	68 47 44 80 00       	push   $0x804447
  802c51:	e8 ab dc ff ff       	call   800901 <_panic>
  802c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 10                	je     802c6f <alloc_block_FF+0x130>
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c67:	8b 52 04             	mov    0x4(%edx),%edx
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	eb 0b                	jmp    802c7a <alloc_block_FF+0x13b>
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 0f                	je     802c93 <alloc_block_FF+0x154>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8d:	8b 12                	mov    (%edx),%edx
  802c8f:	89 10                	mov    %edx,(%eax)
  802c91:	eb 0a                	jmp    802c9d <alloc_block_FF+0x15e>
  802c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	a3 48 51 80 00       	mov    %eax,0x805148
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb0:	a1 54 51 80 00       	mov    0x805154,%eax
  802cb5:	48                   	dec    %eax
  802cb6:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	eb 15                	jmp    802cd5 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccc:	0f 85 80 fe ff ff    	jne    802b52 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802cd5:	c9                   	leave  
  802cd6:	c3                   	ret    

00802cd7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
  802cda:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802cdd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802ce5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802cec:	e9 c0 00 00 00       	jmp    802db1 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfa:	0f 85 8a 00 00 00    	jne    802d8a <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802d00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d04:	75 17                	jne    802d1d <alloc_block_BF+0x46>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 b9 44 80 00       	push   $0x8044b9
  802d0e:	68 cf 00 00 00       	push   $0xcf
  802d13:	68 47 44 80 00       	push   $0x804447
  802d18:	e8 e4 db ff ff       	call   800901 <_panic>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 10                	je     802d36 <alloc_block_BF+0x5f>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2e:	8b 52 04             	mov    0x4(%edx),%edx
  802d31:	89 50 04             	mov    %edx,0x4(%eax)
  802d34:	eb 0b                	jmp    802d41 <alloc_block_BF+0x6a>
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 0f                	je     802d5a <alloc_block_BF+0x83>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 04             	mov    0x4(%eax),%eax
  802d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d54:	8b 12                	mov    (%edx),%edx
  802d56:	89 10                	mov    %edx,(%eax)
  802d58:	eb 0a                	jmp    802d64 <alloc_block_BF+0x8d>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d77:	a1 44 51 80 00       	mov    0x805144,%eax
  802d7c:	48                   	dec    %eax
  802d7d:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	e9 2a 01 00 00       	jmp    802eb4 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d93:	73 14                	jae    802da9 <alloc_block_BF+0xd2>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9e:	76 09                	jbe    802da9 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 0c             	mov    0xc(%eax),%eax
  802da6:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db5:	0f 85 36 ff ff ff    	jne    802cf1 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802dbb:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802dc3:	e9 dd 00 00 00       	jmp    802ea5 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dd1:	0f 85 c6 00 00 00    	jne    802e9d <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802dd7:	a1 48 51 80 00       	mov    0x805148,%eax
  802ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 50 08             	mov    0x8(%eax),%edx
  802de5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de8:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	8b 55 08             	mov    0x8(%ebp),%edx
  802df1:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 50 08             	mov    0x8(%eax),%edx
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	01 c2                	add    %eax,%edx
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e0e:	89 c2                	mov    %eax,%edx
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802e16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e1a:	75 17                	jne    802e33 <alloc_block_BF+0x15c>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 b9 44 80 00       	push   $0x8044b9
  802e24:	68 eb 00 00 00       	push   $0xeb
  802e29:	68 47 44 80 00       	push   $0x804447
  802e2e:	e8 ce da ff ff       	call   800901 <_panic>
  802e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <alloc_block_BF+0x175>
  802e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <alloc_block_BF+0x180>
  802e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <alloc_block_BF+0x199>
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <alloc_block_BF+0x1a3>
  802e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9b:	eb 17                	jmp    802eb4 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802ea5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea9:	0f 85 19 ff ff ff    	jne    802dc8 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802eaf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802eb4:	c9                   	leave  
  802eb5:	c3                   	ret    

00802eb6 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802eb6:	55                   	push   %ebp
  802eb7:	89 e5                	mov    %esp,%ebp
  802eb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802ebc:	a1 40 50 80 00       	mov    0x805040,%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	75 19                	jne    802ede <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	ff 75 08             	pushl  0x8(%ebp)
  802ecb:	e8 6f fc ff ff       	call   802b3f <alloc_block_FF>
  802ed0:	83 c4 10             	add    $0x10,%esp
  802ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	e9 e9 01 00 00       	jmp    8030c7 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802ede:	a1 44 50 80 00       	mov    0x805044,%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802ee9:	a1 44 50 80 00       	mov    0x805044,%eax
  802eee:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef1:	a1 44 50 80 00       	mov    0x805044,%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	01 d0                	add    %edx,%eax
  802efb:	83 ec 08             	sub    $0x8,%esp
  802efe:	50                   	push   %eax
  802eff:	68 38 51 80 00       	push   $0x805138
  802f04:	e8 54 fa ff ff       	call   80295d <find_block>
  802f09:	83 c4 10             	add    $0x10,%esp
  802f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f18:	0f 85 9b 00 00 00    	jne    802fb9 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 50 0c             	mov    0xc(%eax),%edx
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 08             	mov    0x8(%eax),%eax
  802f2a:	01 d0                	add    %edx,%eax
  802f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f33:	75 17                	jne    802f4c <alloc_block_NF+0x96>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 b9 44 80 00       	push   $0x8044b9
  802f3d:	68 1a 01 00 00       	push   $0x11a
  802f42:	68 47 44 80 00       	push   $0x804447
  802f47:	e8 b5 d9 ff ff       	call   800901 <_panic>
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 10                	je     802f65 <alloc_block_NF+0xaf>
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5d:	8b 52 04             	mov    0x4(%edx),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%eax)
  802f63:	eb 0b                	jmp    802f70 <alloc_block_NF+0xba>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	74 0f                	je     802f89 <alloc_block_NF+0xd3>
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	8b 40 04             	mov    0x4(%eax),%eax
  802f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f83:	8b 12                	mov    (%edx),%edx
  802f85:	89 10                	mov    %edx,(%eax)
  802f87:	eb 0a                	jmp    802f93 <alloc_block_NF+0xdd>
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa6:	a1 44 51 80 00       	mov    0x805144,%eax
  802fab:	48                   	dec    %eax
  802fac:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	e9 0e 01 00 00       	jmp    8030c7 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fc2:	0f 86 cf 00 00 00    	jbe    803097 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802fc8:	a1 48 51 80 00       	mov    0x805148,%eax
  802fcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd6:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe8:	8b 50 08             	mov    0x8(%eax),%edx
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	01 c2                	add    %eax,%edx
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffc:	2b 45 08             	sub    0x8(%ebp),%eax
  802fff:	89 c2                	mov    %eax,%edx
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803010:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803014:	75 17                	jne    80302d <alloc_block_NF+0x177>
  803016:	83 ec 04             	sub    $0x4,%esp
  803019:	68 b9 44 80 00       	push   $0x8044b9
  80301e:	68 28 01 00 00       	push   $0x128
  803023:	68 47 44 80 00       	push   $0x804447
  803028:	e8 d4 d8 ff ff       	call   800901 <_panic>
  80302d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 10                	je     803046 <alloc_block_NF+0x190>
  803036:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80303e:	8b 52 04             	mov    0x4(%edx),%edx
  803041:	89 50 04             	mov    %edx,0x4(%eax)
  803044:	eb 0b                	jmp    803051 <alloc_block_NF+0x19b>
  803046:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803049:	8b 40 04             	mov    0x4(%eax),%eax
  80304c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	8b 40 04             	mov    0x4(%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 0f                	je     80306a <alloc_block_NF+0x1b4>
  80305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803064:	8b 12                	mov    (%edx),%edx
  803066:	89 10                	mov    %edx,(%eax)
  803068:	eb 0a                	jmp    803074 <alloc_block_NF+0x1be>
  80306a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	a3 48 51 80 00       	mov    %eax,0x805148
  803074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	a1 54 51 80 00       	mov    0x805154,%eax
  80308c:	48                   	dec    %eax
  80308d:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803095:	eb 30                	jmp    8030c7 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803097:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80309c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80309f:	75 0a                	jne    8030ab <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8030a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a9:	eb 08                	jmp    8030b3 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030bc:	0f 85 4d fe ff ff    	jne    802f0f <alloc_block_NF+0x59>

			return NULL;
  8030c2:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8030c7:	c9                   	leave  
  8030c8:	c3                   	ret    

008030c9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030c9:	55                   	push   %ebp
  8030ca:	89 e5                	mov    %esp,%ebp
  8030cc:	53                   	push   %ebx
  8030cd:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8030d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	0f 85 86 00 00 00    	jne    803163 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8030dd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8030e4:	00 00 00 
  8030e7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8030ee:	00 00 00 
  8030f1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8030f8:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ff:	75 17                	jne    803118 <insert_sorted_with_merge_freeList+0x4f>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 24 44 80 00       	push   $0x804424
  803109:	68 48 01 00 00       	push   $0x148
  80310e:	68 47 44 80 00       	push   $0x804447
  803113:	e8 e9 d7 ff ff       	call   800901 <_panic>
  803118:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	89 10                	mov    %edx,(%eax)
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 0d                	je     803139 <insert_sorted_with_merge_freeList+0x70>
  80312c:	a1 38 51 80 00       	mov    0x805138,%eax
  803131:	8b 55 08             	mov    0x8(%ebp),%edx
  803134:	89 50 04             	mov    %edx,0x4(%eax)
  803137:	eb 08                	jmp    803141 <insert_sorted_with_merge_freeList+0x78>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	a3 38 51 80 00       	mov    %eax,0x805138
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803153:	a1 44 51 80 00       	mov    0x805144,%eax
  803158:	40                   	inc    %eax
  803159:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80315e:	e9 73 07 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	8b 50 08             	mov    0x8(%eax),%edx
  803169:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80316e:	8b 40 08             	mov    0x8(%eax),%eax
  803171:	39 c2                	cmp    %eax,%edx
  803173:	0f 86 84 00 00 00    	jbe    8031fd <insert_sorted_with_merge_freeList+0x134>
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	8b 50 08             	mov    0x8(%eax),%edx
  80317f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803184:	8b 48 0c             	mov    0xc(%eax),%ecx
  803187:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80318c:	8b 40 08             	mov    0x8(%eax),%eax
  80318f:	01 c8                	add    %ecx,%eax
  803191:	39 c2                	cmp    %eax,%edx
  803193:	74 68                	je     8031fd <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803195:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803199:	75 17                	jne    8031b2 <insert_sorted_with_merge_freeList+0xe9>
  80319b:	83 ec 04             	sub    $0x4,%esp
  80319e:	68 60 44 80 00       	push   $0x804460
  8031a3:	68 4c 01 00 00       	push   $0x14c
  8031a8:	68 47 44 80 00       	push   $0x804447
  8031ad:	e8 4f d7 ff ff       	call   800901 <_panic>
  8031b2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	89 50 04             	mov    %edx,0x4(%eax)
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	74 0c                	je     8031d4 <insert_sorted_with_merge_freeList+0x10b>
  8031c8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d0:	89 10                	mov    %edx,(%eax)
  8031d2:	eb 08                	jmp    8031dc <insert_sorted_with_merge_freeList+0x113>
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f2:	40                   	inc    %eax
  8031f3:	a3 44 51 80 00       	mov    %eax,0x805144
  8031f8:	e9 d9 06 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 50 08             	mov    0x8(%eax),%edx
  803203:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803208:	8b 40 08             	mov    0x8(%eax),%eax
  80320b:	39 c2                	cmp    %eax,%edx
  80320d:	0f 86 b5 00 00 00    	jbe    8032c8 <insert_sorted_with_merge_freeList+0x1ff>
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	8b 50 08             	mov    0x8(%eax),%edx
  803219:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80321e:	8b 48 0c             	mov    0xc(%eax),%ecx
  803221:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803226:	8b 40 08             	mov    0x8(%eax),%eax
  803229:	01 c8                	add    %ecx,%eax
  80322b:	39 c2                	cmp    %eax,%edx
  80322d:	0f 85 95 00 00 00    	jne    8032c8 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803233:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803238:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80323e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803241:	8b 55 08             	mov    0x8(%ebp),%edx
  803244:	8b 52 0c             	mov    0xc(%edx),%edx
  803247:	01 ca                	add    %ecx,%edx
  803249:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x1b4>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 24 44 80 00       	push   $0x804424
  80326e:	68 54 01 00 00       	push   $0x154
  803273:	68 47 44 80 00       	push   $0x804447
  803278:	e8 84 d6 ff ff       	call   800901 <_panic>
  80327d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0d                	je     80329e <insert_sorted_with_merge_freeList+0x1d5>
  803291:	a1 48 51 80 00       	mov    0x805148,%eax
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 08                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x1dd>
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032bd:	40                   	inc    %eax
  8032be:	a3 54 51 80 00       	mov    %eax,0x805154
  8032c3:	e9 0e 06 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 50 08             	mov    0x8(%eax),%edx
  8032ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d3:	8b 40 08             	mov    0x8(%eax),%eax
  8032d6:	39 c2                	cmp    %eax,%edx
  8032d8:	0f 83 c1 00 00 00    	jae    80339f <insert_sorted_with_merge_freeList+0x2d6>
  8032de:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e3:	8b 50 08             	mov    0x8(%eax),%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 48 08             	mov    0x8(%eax),%ecx
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f2:	01 c8                	add    %ecx,%eax
  8032f4:	39 c2                	cmp    %eax,%edx
  8032f6:	0f 85 a3 00 00 00    	jne    80339f <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8032fc:	a1 38 51 80 00       	mov    0x805138,%eax
  803301:	8b 55 08             	mov    0x8(%ebp),%edx
  803304:	8b 52 08             	mov    0x8(%edx),%edx
  803307:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80330a:	a1 38 51 80 00       	mov    0x805138,%eax
  80330f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803315:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803318:	8b 55 08             	mov    0x8(%ebp),%edx
  80331b:	8b 52 0c             	mov    0xc(%edx),%edx
  80331e:	01 ca                	add    %ecx,%edx
  803320:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333b:	75 17                	jne    803354 <insert_sorted_with_merge_freeList+0x28b>
  80333d:	83 ec 04             	sub    $0x4,%esp
  803340:	68 24 44 80 00       	push   $0x804424
  803345:	68 5d 01 00 00       	push   $0x15d
  80334a:	68 47 44 80 00       	push   $0x804447
  80334f:	e8 ad d5 ff ff       	call   800901 <_panic>
  803354:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	89 10                	mov    %edx,(%eax)
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 0d                	je     803375 <insert_sorted_with_merge_freeList+0x2ac>
  803368:	a1 48 51 80 00       	mov    0x805148,%eax
  80336d:	8b 55 08             	mov    0x8(%ebp),%edx
  803370:	89 50 04             	mov    %edx,0x4(%eax)
  803373:	eb 08                	jmp    80337d <insert_sorted_with_merge_freeList+0x2b4>
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	a3 48 51 80 00       	mov    %eax,0x805148
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338f:	a1 54 51 80 00       	mov    0x805154,%eax
  803394:	40                   	inc    %eax
  803395:	a3 54 51 80 00       	mov    %eax,0x805154
  80339a:	e9 37 05 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 50 08             	mov    0x8(%eax),%edx
  8033a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033aa:	8b 40 08             	mov    0x8(%eax),%eax
  8033ad:	39 c2                	cmp    %eax,%edx
  8033af:	0f 83 82 00 00 00    	jae    803437 <insert_sorted_with_merge_freeList+0x36e>
  8033b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ba:	8b 50 08             	mov    0x8(%eax),%edx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c9:	01 c8                	add    %ecx,%eax
  8033cb:	39 c2                	cmp    %eax,%edx
  8033cd:	74 68                	je     803437 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d3:	75 17                	jne    8033ec <insert_sorted_with_merge_freeList+0x323>
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	68 24 44 80 00       	push   $0x804424
  8033dd:	68 62 01 00 00       	push   $0x162
  8033e2:	68 47 44 80 00       	push   $0x804447
  8033e7:	e8 15 d5 ff ff       	call   800901 <_panic>
  8033ec:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	89 10                	mov    %edx,(%eax)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 0d                	je     80340d <insert_sorted_with_merge_freeList+0x344>
  803400:	a1 38 51 80 00       	mov    0x805138,%eax
  803405:	8b 55 08             	mov    0x8(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 08                	jmp    803415 <insert_sorted_with_merge_freeList+0x34c>
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	a3 38 51 80 00       	mov    %eax,0x805138
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803427:	a1 44 51 80 00       	mov    0x805144,%eax
  80342c:	40                   	inc    %eax
  80342d:	a3 44 51 80 00       	mov    %eax,0x805144
  803432:	e9 9f 04 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803437:	a1 38 51 80 00       	mov    0x805138,%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803441:	e9 84 04 00 00       	jmp    8038ca <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 50 08             	mov    0x8(%eax),%edx
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	8b 40 08             	mov    0x8(%eax),%eax
  803452:	39 c2                	cmp    %eax,%edx
  803454:	0f 86 a9 00 00 00    	jbe    803503 <insert_sorted_with_merge_freeList+0x43a>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 50 08             	mov    0x8(%eax),%edx
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	8b 48 08             	mov    0x8(%eax),%ecx
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	8b 40 0c             	mov    0xc(%eax),%eax
  80346c:	01 c8                	add    %ecx,%eax
  80346e:	39 c2                	cmp    %eax,%edx
  803470:	0f 84 8d 00 00 00    	je     803503 <insert_sorted_with_merge_freeList+0x43a>
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 50 08             	mov    0x8(%eax),%edx
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	8b 48 08             	mov    0x8(%eax),%ecx
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	8b 40 04             	mov    0x4(%eax),%eax
  80348b:	8b 40 0c             	mov    0xc(%eax),%eax
  80348e:	01 c8                	add    %ecx,%eax
  803490:	39 c2                	cmp    %eax,%edx
  803492:	74 6f                	je     803503 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803494:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803498:	74 06                	je     8034a0 <insert_sorted_with_merge_freeList+0x3d7>
  80349a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349e:	75 17                	jne    8034b7 <insert_sorted_with_merge_freeList+0x3ee>
  8034a0:	83 ec 04             	sub    $0x4,%esp
  8034a3:	68 84 44 80 00       	push   $0x804484
  8034a8:	68 6b 01 00 00       	push   $0x16b
  8034ad:	68 47 44 80 00       	push   $0x804447
  8034b2:	e8 4a d4 ff ff       	call   800901 <_panic>
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 50 04             	mov    0x4(%eax),%edx
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	89 50 04             	mov    %edx,0x4(%eax)
  8034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c9:	89 10                	mov    %edx,(%eax)
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	8b 40 04             	mov    0x4(%eax),%eax
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	74 0d                	je     8034e2 <insert_sorted_with_merge_freeList+0x419>
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	8b 40 04             	mov    0x4(%eax),%eax
  8034db:	8b 55 08             	mov    0x8(%ebp),%edx
  8034de:	89 10                	mov    %edx,(%eax)
  8034e0:	eb 08                	jmp    8034ea <insert_sorted_with_merge_freeList+0x421>
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%eax)
  8034f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f8:	40                   	inc    %eax
  8034f9:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8034fe:	e9 d3 03 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	8b 50 08             	mov    0x8(%eax),%edx
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 40 08             	mov    0x8(%eax),%eax
  80350f:	39 c2                	cmp    %eax,%edx
  803511:	0f 86 da 00 00 00    	jbe    8035f1 <insert_sorted_with_merge_freeList+0x528>
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	8b 50 08             	mov    0x8(%eax),%edx
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	8b 48 08             	mov    0x8(%eax),%ecx
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	8b 40 0c             	mov    0xc(%eax),%eax
  803529:	01 c8                	add    %ecx,%eax
  80352b:	39 c2                	cmp    %eax,%edx
  80352d:	0f 85 be 00 00 00    	jne    8035f1 <insert_sorted_with_merge_freeList+0x528>
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	8b 50 08             	mov    0x8(%eax),%edx
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	8b 40 04             	mov    0x4(%eax),%eax
  80353f:	8b 48 08             	mov    0x8(%eax),%ecx
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	8b 40 0c             	mov    0xc(%eax),%eax
  80354b:	01 c8                	add    %ecx,%eax
  80354d:	39 c2                	cmp    %eax,%edx
  80354f:	0f 84 9c 00 00 00    	je     8035f1 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	8b 50 08             	mov    0x8(%eax),%edx
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	8b 50 0c             	mov    0xc(%eax),%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	8b 40 0c             	mov    0xc(%eax),%eax
  80356d:	01 c2                	add    %eax,%edx
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358d:	75 17                	jne    8035a6 <insert_sorted_with_merge_freeList+0x4dd>
  80358f:	83 ec 04             	sub    $0x4,%esp
  803592:	68 24 44 80 00       	push   $0x804424
  803597:	68 74 01 00 00       	push   $0x174
  80359c:	68 47 44 80 00       	push   $0x804447
  8035a1:	e8 5b d3 ff ff       	call   800901 <_panic>
  8035a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	85 c0                	test   %eax,%eax
  8035b8:	74 0d                	je     8035c7 <insert_sorted_with_merge_freeList+0x4fe>
  8035ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8035bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c2:	89 50 04             	mov    %edx,0x4(%eax)
  8035c5:	eb 08                	jmp    8035cf <insert_sorted_with_merge_freeList+0x506>
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e6:	40                   	inc    %eax
  8035e7:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8035ec:	e9 e5 02 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	8b 50 08             	mov    0x8(%eax),%edx
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	8b 40 08             	mov    0x8(%eax),%eax
  8035fd:	39 c2                	cmp    %eax,%edx
  8035ff:	0f 86 d7 00 00 00    	jbe    8036dc <insert_sorted_with_merge_freeList+0x613>
  803605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803608:	8b 50 08             	mov    0x8(%eax),%edx
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 48 08             	mov    0x8(%eax),%ecx
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	8b 40 0c             	mov    0xc(%eax),%eax
  803617:	01 c8                	add    %ecx,%eax
  803619:	39 c2                	cmp    %eax,%edx
  80361b:	0f 84 bb 00 00 00    	je     8036dc <insert_sorted_with_merge_freeList+0x613>
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	8b 50 08             	mov    0x8(%eax),%edx
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	8b 40 04             	mov    0x4(%eax),%eax
  80362d:	8b 48 08             	mov    0x8(%eax),%ecx
  803630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	8b 40 0c             	mov    0xc(%eax),%eax
  803639:	01 c8                	add    %ecx,%eax
  80363b:	39 c2                	cmp    %eax,%edx
  80363d:	0f 85 99 00 00 00    	jne    8036dc <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803646:	8b 40 04             	mov    0x4(%eax),%eax
  803649:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80364c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364f:	8b 50 0c             	mov    0xc(%eax),%edx
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	8b 40 0c             	mov    0xc(%eax),%eax
  803658:	01 c2                	add    %eax,%edx
  80365a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365d:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803674:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803678:	75 17                	jne    803691 <insert_sorted_with_merge_freeList+0x5c8>
  80367a:	83 ec 04             	sub    $0x4,%esp
  80367d:	68 24 44 80 00       	push   $0x804424
  803682:	68 7d 01 00 00       	push   $0x17d
  803687:	68 47 44 80 00       	push   $0x804447
  80368c:	e8 70 d2 ff ff       	call   800901 <_panic>
  803691:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	89 10                	mov    %edx,(%eax)
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 00                	mov    (%eax),%eax
  8036a1:	85 c0                	test   %eax,%eax
  8036a3:	74 0d                	je     8036b2 <insert_sorted_with_merge_freeList+0x5e9>
  8036a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8036aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ad:	89 50 04             	mov    %edx,0x4(%eax)
  8036b0:	eb 08                	jmp    8036ba <insert_sorted_with_merge_freeList+0x5f1>
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8036d1:	40                   	inc    %eax
  8036d2:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8036d7:	e9 fa 01 00 00       	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 50 08             	mov    0x8(%eax),%edx
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	8b 40 08             	mov    0x8(%eax),%eax
  8036e8:	39 c2                	cmp    %eax,%edx
  8036ea:	0f 86 d2 01 00 00    	jbe    8038c2 <insert_sorted_with_merge_freeList+0x7f9>
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	8b 50 08             	mov    0x8(%eax),%edx
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803702:	01 c8                	add    %ecx,%eax
  803704:	39 c2                	cmp    %eax,%edx
  803706:	0f 85 b6 01 00 00    	jne    8038c2 <insert_sorted_with_merge_freeList+0x7f9>
  80370c:	8b 45 08             	mov    0x8(%ebp),%eax
  80370f:	8b 50 08             	mov    0x8(%eax),%edx
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 40 04             	mov    0x4(%eax),%eax
  803718:	8b 48 08             	mov    0x8(%eax),%ecx
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 40 04             	mov    0x4(%eax),%eax
  803721:	8b 40 0c             	mov    0xc(%eax),%eax
  803724:	01 c8                	add    %ecx,%eax
  803726:	39 c2                	cmp    %eax,%edx
  803728:	0f 85 94 01 00 00    	jne    8038c2 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	8b 40 04             	mov    0x4(%eax),%eax
  803734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803737:	8b 52 04             	mov    0x4(%edx),%edx
  80373a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80373d:	8b 55 08             	mov    0x8(%ebp),%edx
  803740:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803746:	8b 52 0c             	mov    0xc(%edx),%edx
  803749:	01 da                	add    %ebx,%edx
  80374b:	01 ca                	add    %ecx,%edx
  80374d:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803753:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803768:	75 17                	jne    803781 <insert_sorted_with_merge_freeList+0x6b8>
  80376a:	83 ec 04             	sub    $0x4,%esp
  80376d:	68 b9 44 80 00       	push   $0x8044b9
  803772:	68 86 01 00 00       	push   $0x186
  803777:	68 47 44 80 00       	push   $0x804447
  80377c:	e8 80 d1 ff ff       	call   800901 <_panic>
  803781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803784:	8b 00                	mov    (%eax),%eax
  803786:	85 c0                	test   %eax,%eax
  803788:	74 10                	je     80379a <insert_sorted_with_merge_freeList+0x6d1>
  80378a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803792:	8b 52 04             	mov    0x4(%edx),%edx
  803795:	89 50 04             	mov    %edx,0x4(%eax)
  803798:	eb 0b                	jmp    8037a5 <insert_sorted_with_merge_freeList+0x6dc>
  80379a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379d:	8b 40 04             	mov    0x4(%eax),%eax
  8037a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a8:	8b 40 04             	mov    0x4(%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 0f                	je     8037be <insert_sorted_with_merge_freeList+0x6f5>
  8037af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b2:	8b 40 04             	mov    0x4(%eax),%eax
  8037b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037b8:	8b 12                	mov    (%edx),%edx
  8037ba:	89 10                	mov    %edx,(%eax)
  8037bc:	eb 0a                	jmp    8037c8 <insert_sorted_with_merge_freeList+0x6ff>
  8037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8037c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037db:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e0:	48                   	dec    %eax
  8037e1:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8037e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ea:	75 17                	jne    803803 <insert_sorted_with_merge_freeList+0x73a>
  8037ec:	83 ec 04             	sub    $0x4,%esp
  8037ef:	68 24 44 80 00       	push   $0x804424
  8037f4:	68 87 01 00 00       	push   $0x187
  8037f9:	68 47 44 80 00       	push   $0x804447
  8037fe:	e8 fe d0 ff ff       	call   800901 <_panic>
  803803:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380c:	89 10                	mov    %edx,(%eax)
  80380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	85 c0                	test   %eax,%eax
  803815:	74 0d                	je     803824 <insert_sorted_with_merge_freeList+0x75b>
  803817:	a1 48 51 80 00       	mov    0x805148,%eax
  80381c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80381f:	89 50 04             	mov    %edx,0x4(%eax)
  803822:	eb 08                	jmp    80382c <insert_sorted_with_merge_freeList+0x763>
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80382c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382f:	a3 48 51 80 00       	mov    %eax,0x805148
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383e:	a1 54 51 80 00       	mov    0x805154,%eax
  803843:	40                   	inc    %eax
  803844:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80385d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803861:	75 17                	jne    80387a <insert_sorted_with_merge_freeList+0x7b1>
  803863:	83 ec 04             	sub    $0x4,%esp
  803866:	68 24 44 80 00       	push   $0x804424
  80386b:	68 8a 01 00 00       	push   $0x18a
  803870:	68 47 44 80 00       	push   $0x804447
  803875:	e8 87 d0 ff ff       	call   800901 <_panic>
  80387a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	89 10                	mov    %edx,(%eax)
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	8b 00                	mov    (%eax),%eax
  80388a:	85 c0                	test   %eax,%eax
  80388c:	74 0d                	je     80389b <insert_sorted_with_merge_freeList+0x7d2>
  80388e:	a1 48 51 80 00       	mov    0x805148,%eax
  803893:	8b 55 08             	mov    0x8(%ebp),%edx
  803896:	89 50 04             	mov    %edx,0x4(%eax)
  803899:	eb 08                	jmp    8038a3 <insert_sorted_with_merge_freeList+0x7da>
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ba:	40                   	inc    %eax
  8038bb:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8038c0:	eb 14                	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8038c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8038ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ce:	0f 85 72 fb ff ff    	jne    803446 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8038d4:	eb 00                	jmp    8038d6 <insert_sorted_with_merge_freeList+0x80d>
  8038d6:	90                   	nop
  8038d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038da:	c9                   	leave  
  8038db:	c3                   	ret    

008038dc <__udivdi3>:
  8038dc:	55                   	push   %ebp
  8038dd:	57                   	push   %edi
  8038de:	56                   	push   %esi
  8038df:	53                   	push   %ebx
  8038e0:	83 ec 1c             	sub    $0x1c,%esp
  8038e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038f3:	89 ca                	mov    %ecx,%edx
  8038f5:	89 f8                	mov    %edi,%eax
  8038f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038fb:	85 f6                	test   %esi,%esi
  8038fd:	75 2d                	jne    80392c <__udivdi3+0x50>
  8038ff:	39 cf                	cmp    %ecx,%edi
  803901:	77 65                	ja     803968 <__udivdi3+0x8c>
  803903:	89 fd                	mov    %edi,%ebp
  803905:	85 ff                	test   %edi,%edi
  803907:	75 0b                	jne    803914 <__udivdi3+0x38>
  803909:	b8 01 00 00 00       	mov    $0x1,%eax
  80390e:	31 d2                	xor    %edx,%edx
  803910:	f7 f7                	div    %edi
  803912:	89 c5                	mov    %eax,%ebp
  803914:	31 d2                	xor    %edx,%edx
  803916:	89 c8                	mov    %ecx,%eax
  803918:	f7 f5                	div    %ebp
  80391a:	89 c1                	mov    %eax,%ecx
  80391c:	89 d8                	mov    %ebx,%eax
  80391e:	f7 f5                	div    %ebp
  803920:	89 cf                	mov    %ecx,%edi
  803922:	89 fa                	mov    %edi,%edx
  803924:	83 c4 1c             	add    $0x1c,%esp
  803927:	5b                   	pop    %ebx
  803928:	5e                   	pop    %esi
  803929:	5f                   	pop    %edi
  80392a:	5d                   	pop    %ebp
  80392b:	c3                   	ret    
  80392c:	39 ce                	cmp    %ecx,%esi
  80392e:	77 28                	ja     803958 <__udivdi3+0x7c>
  803930:	0f bd fe             	bsr    %esi,%edi
  803933:	83 f7 1f             	xor    $0x1f,%edi
  803936:	75 40                	jne    803978 <__udivdi3+0x9c>
  803938:	39 ce                	cmp    %ecx,%esi
  80393a:	72 0a                	jb     803946 <__udivdi3+0x6a>
  80393c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803940:	0f 87 9e 00 00 00    	ja     8039e4 <__udivdi3+0x108>
  803946:	b8 01 00 00 00       	mov    $0x1,%eax
  80394b:	89 fa                	mov    %edi,%edx
  80394d:	83 c4 1c             	add    $0x1c,%esp
  803950:	5b                   	pop    %ebx
  803951:	5e                   	pop    %esi
  803952:	5f                   	pop    %edi
  803953:	5d                   	pop    %ebp
  803954:	c3                   	ret    
  803955:	8d 76 00             	lea    0x0(%esi),%esi
  803958:	31 ff                	xor    %edi,%edi
  80395a:	31 c0                	xor    %eax,%eax
  80395c:	89 fa                	mov    %edi,%edx
  80395e:	83 c4 1c             	add    $0x1c,%esp
  803961:	5b                   	pop    %ebx
  803962:	5e                   	pop    %esi
  803963:	5f                   	pop    %edi
  803964:	5d                   	pop    %ebp
  803965:	c3                   	ret    
  803966:	66 90                	xchg   %ax,%ax
  803968:	89 d8                	mov    %ebx,%eax
  80396a:	f7 f7                	div    %edi
  80396c:	31 ff                	xor    %edi,%edi
  80396e:	89 fa                	mov    %edi,%edx
  803970:	83 c4 1c             	add    $0x1c,%esp
  803973:	5b                   	pop    %ebx
  803974:	5e                   	pop    %esi
  803975:	5f                   	pop    %edi
  803976:	5d                   	pop    %ebp
  803977:	c3                   	ret    
  803978:	bd 20 00 00 00       	mov    $0x20,%ebp
  80397d:	89 eb                	mov    %ebp,%ebx
  80397f:	29 fb                	sub    %edi,%ebx
  803981:	89 f9                	mov    %edi,%ecx
  803983:	d3 e6                	shl    %cl,%esi
  803985:	89 c5                	mov    %eax,%ebp
  803987:	88 d9                	mov    %bl,%cl
  803989:	d3 ed                	shr    %cl,%ebp
  80398b:	89 e9                	mov    %ebp,%ecx
  80398d:	09 f1                	or     %esi,%ecx
  80398f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803993:	89 f9                	mov    %edi,%ecx
  803995:	d3 e0                	shl    %cl,%eax
  803997:	89 c5                	mov    %eax,%ebp
  803999:	89 d6                	mov    %edx,%esi
  80399b:	88 d9                	mov    %bl,%cl
  80399d:	d3 ee                	shr    %cl,%esi
  80399f:	89 f9                	mov    %edi,%ecx
  8039a1:	d3 e2                	shl    %cl,%edx
  8039a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a7:	88 d9                	mov    %bl,%cl
  8039a9:	d3 e8                	shr    %cl,%eax
  8039ab:	09 c2                	or     %eax,%edx
  8039ad:	89 d0                	mov    %edx,%eax
  8039af:	89 f2                	mov    %esi,%edx
  8039b1:	f7 74 24 0c          	divl   0xc(%esp)
  8039b5:	89 d6                	mov    %edx,%esi
  8039b7:	89 c3                	mov    %eax,%ebx
  8039b9:	f7 e5                	mul    %ebp
  8039bb:	39 d6                	cmp    %edx,%esi
  8039bd:	72 19                	jb     8039d8 <__udivdi3+0xfc>
  8039bf:	74 0b                	je     8039cc <__udivdi3+0xf0>
  8039c1:	89 d8                	mov    %ebx,%eax
  8039c3:	31 ff                	xor    %edi,%edi
  8039c5:	e9 58 ff ff ff       	jmp    803922 <__udivdi3+0x46>
  8039ca:	66 90                	xchg   %ax,%ax
  8039cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039d0:	89 f9                	mov    %edi,%ecx
  8039d2:	d3 e2                	shl    %cl,%edx
  8039d4:	39 c2                	cmp    %eax,%edx
  8039d6:	73 e9                	jae    8039c1 <__udivdi3+0xe5>
  8039d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039db:	31 ff                	xor    %edi,%edi
  8039dd:	e9 40 ff ff ff       	jmp    803922 <__udivdi3+0x46>
  8039e2:	66 90                	xchg   %ax,%ax
  8039e4:	31 c0                	xor    %eax,%eax
  8039e6:	e9 37 ff ff ff       	jmp    803922 <__udivdi3+0x46>
  8039eb:	90                   	nop

008039ec <__umoddi3>:
  8039ec:	55                   	push   %ebp
  8039ed:	57                   	push   %edi
  8039ee:	56                   	push   %esi
  8039ef:	53                   	push   %ebx
  8039f0:	83 ec 1c             	sub    $0x1c,%esp
  8039f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a0b:	89 f3                	mov    %esi,%ebx
  803a0d:	89 fa                	mov    %edi,%edx
  803a0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a13:	89 34 24             	mov    %esi,(%esp)
  803a16:	85 c0                	test   %eax,%eax
  803a18:	75 1a                	jne    803a34 <__umoddi3+0x48>
  803a1a:	39 f7                	cmp    %esi,%edi
  803a1c:	0f 86 a2 00 00 00    	jbe    803ac4 <__umoddi3+0xd8>
  803a22:	89 c8                	mov    %ecx,%eax
  803a24:	89 f2                	mov    %esi,%edx
  803a26:	f7 f7                	div    %edi
  803a28:	89 d0                	mov    %edx,%eax
  803a2a:	31 d2                	xor    %edx,%edx
  803a2c:	83 c4 1c             	add    $0x1c,%esp
  803a2f:	5b                   	pop    %ebx
  803a30:	5e                   	pop    %esi
  803a31:	5f                   	pop    %edi
  803a32:	5d                   	pop    %ebp
  803a33:	c3                   	ret    
  803a34:	39 f0                	cmp    %esi,%eax
  803a36:	0f 87 ac 00 00 00    	ja     803ae8 <__umoddi3+0xfc>
  803a3c:	0f bd e8             	bsr    %eax,%ebp
  803a3f:	83 f5 1f             	xor    $0x1f,%ebp
  803a42:	0f 84 ac 00 00 00    	je     803af4 <__umoddi3+0x108>
  803a48:	bf 20 00 00 00       	mov    $0x20,%edi
  803a4d:	29 ef                	sub    %ebp,%edi
  803a4f:	89 fe                	mov    %edi,%esi
  803a51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a55:	89 e9                	mov    %ebp,%ecx
  803a57:	d3 e0                	shl    %cl,%eax
  803a59:	89 d7                	mov    %edx,%edi
  803a5b:	89 f1                	mov    %esi,%ecx
  803a5d:	d3 ef                	shr    %cl,%edi
  803a5f:	09 c7                	or     %eax,%edi
  803a61:	89 e9                	mov    %ebp,%ecx
  803a63:	d3 e2                	shl    %cl,%edx
  803a65:	89 14 24             	mov    %edx,(%esp)
  803a68:	89 d8                	mov    %ebx,%eax
  803a6a:	d3 e0                	shl    %cl,%eax
  803a6c:	89 c2                	mov    %eax,%edx
  803a6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a72:	d3 e0                	shl    %cl,%eax
  803a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a78:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a7c:	89 f1                	mov    %esi,%ecx
  803a7e:	d3 e8                	shr    %cl,%eax
  803a80:	09 d0                	or     %edx,%eax
  803a82:	d3 eb                	shr    %cl,%ebx
  803a84:	89 da                	mov    %ebx,%edx
  803a86:	f7 f7                	div    %edi
  803a88:	89 d3                	mov    %edx,%ebx
  803a8a:	f7 24 24             	mull   (%esp)
  803a8d:	89 c6                	mov    %eax,%esi
  803a8f:	89 d1                	mov    %edx,%ecx
  803a91:	39 d3                	cmp    %edx,%ebx
  803a93:	0f 82 87 00 00 00    	jb     803b20 <__umoddi3+0x134>
  803a99:	0f 84 91 00 00 00    	je     803b30 <__umoddi3+0x144>
  803a9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aa3:	29 f2                	sub    %esi,%edx
  803aa5:	19 cb                	sbb    %ecx,%ebx
  803aa7:	89 d8                	mov    %ebx,%eax
  803aa9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803aad:	d3 e0                	shl    %cl,%eax
  803aaf:	89 e9                	mov    %ebp,%ecx
  803ab1:	d3 ea                	shr    %cl,%edx
  803ab3:	09 d0                	or     %edx,%eax
  803ab5:	89 e9                	mov    %ebp,%ecx
  803ab7:	d3 eb                	shr    %cl,%ebx
  803ab9:	89 da                	mov    %ebx,%edx
  803abb:	83 c4 1c             	add    $0x1c,%esp
  803abe:	5b                   	pop    %ebx
  803abf:	5e                   	pop    %esi
  803ac0:	5f                   	pop    %edi
  803ac1:	5d                   	pop    %ebp
  803ac2:	c3                   	ret    
  803ac3:	90                   	nop
  803ac4:	89 fd                	mov    %edi,%ebp
  803ac6:	85 ff                	test   %edi,%edi
  803ac8:	75 0b                	jne    803ad5 <__umoddi3+0xe9>
  803aca:	b8 01 00 00 00       	mov    $0x1,%eax
  803acf:	31 d2                	xor    %edx,%edx
  803ad1:	f7 f7                	div    %edi
  803ad3:	89 c5                	mov    %eax,%ebp
  803ad5:	89 f0                	mov    %esi,%eax
  803ad7:	31 d2                	xor    %edx,%edx
  803ad9:	f7 f5                	div    %ebp
  803adb:	89 c8                	mov    %ecx,%eax
  803add:	f7 f5                	div    %ebp
  803adf:	89 d0                	mov    %edx,%eax
  803ae1:	e9 44 ff ff ff       	jmp    803a2a <__umoddi3+0x3e>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	89 c8                	mov    %ecx,%eax
  803aea:	89 f2                	mov    %esi,%edx
  803aec:	83 c4 1c             	add    $0x1c,%esp
  803aef:	5b                   	pop    %ebx
  803af0:	5e                   	pop    %esi
  803af1:	5f                   	pop    %edi
  803af2:	5d                   	pop    %ebp
  803af3:	c3                   	ret    
  803af4:	3b 04 24             	cmp    (%esp),%eax
  803af7:	72 06                	jb     803aff <__umoddi3+0x113>
  803af9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803afd:	77 0f                	ja     803b0e <__umoddi3+0x122>
  803aff:	89 f2                	mov    %esi,%edx
  803b01:	29 f9                	sub    %edi,%ecx
  803b03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b07:	89 14 24             	mov    %edx,(%esp)
  803b0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b12:	8b 14 24             	mov    (%esp),%edx
  803b15:	83 c4 1c             	add    $0x1c,%esp
  803b18:	5b                   	pop    %ebx
  803b19:	5e                   	pop    %esi
  803b1a:	5f                   	pop    %edi
  803b1b:	5d                   	pop    %ebp
  803b1c:	c3                   	ret    
  803b1d:	8d 76 00             	lea    0x0(%esi),%esi
  803b20:	2b 04 24             	sub    (%esp),%eax
  803b23:	19 fa                	sbb    %edi,%edx
  803b25:	89 d1                	mov    %edx,%ecx
  803b27:	89 c6                	mov    %eax,%esi
  803b29:	e9 71 ff ff ff       	jmp    803a9f <__umoddi3+0xb3>
  803b2e:	66 90                	xchg   %ax,%ax
  803b30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b34:	72 ea                	jb     803b20 <__umoddi3+0x134>
  803b36:	89 d9                	mov    %ebx,%ecx
  803b38:	e9 62 ff ff ff       	jmp    803a9f <__umoddi3+0xb3>
