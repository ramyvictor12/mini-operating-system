
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
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
  800041:	e8 02 20 00 00       	call   802048 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 39 80 00       	push   $0x803940
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 39 80 00       	push   $0x803942
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 39 80 00       	push   $0x803958
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 39 80 00       	push   $0x803942
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 39 80 00       	push   $0x803940
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 70 39 80 00       	push   $0x803970
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 8f 39 80 00       	push   $0x80398f
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 28 1a 00 00       	call   801af7 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 94 39 80 00       	push   $0x803994
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 b6 39 80 00       	push   $0x8039b6
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 c4 39 80 00       	push   $0x8039c4
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 d3 39 80 00       	push   $0x8039d3
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 e3 39 80 00       	push   $0x8039e3
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 05 1f 00 00       	call   802062 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 76 1e 00 00       	call   802048 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 ec 39 80 00       	push   $0x8039ec
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 7b 1e 00 00       	call   802062 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 20 3a 80 00       	push   $0x803a20
  800209:	6a 4e                	push   $0x4e
  80020b:	68 42 3a 80 00       	push   $0x803a42
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 2e 1e 00 00       	call   802048 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 60 3a 80 00       	push   $0x803a60
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 94 3a 80 00       	push   $0x803a94
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 c8 3a 80 00       	push   $0x803ac8
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 13 1e 00 00       	call   802062 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 28 19 00 00       	call   801b82 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 e6 1d 00 00       	call   802048 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 fa 3a 80 00       	push   $0x803afa
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 ab 1d 00 00       	call   802062 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>
}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 40 39 80 00       	push   $0x803940
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 18 3b 80 00       	push   $0x803b18
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 8f 39 80 00       	push   $0x80398f
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 b6 15 00 00       	call   801af7 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 a1 15 00 00       	call   801af7 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 7f 14 00 00       	call   801b82 <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 71 14 00 00       	call   801b82 <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 4c 19 00 00       	call   80207c <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 07 19 00 00       	call   802048 <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 28 19 00 00       	call   80207c <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 06 19 00 00       	call   802062 <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 50 17 00 00       	call   801ec3 <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 bc 18 00 00       	call   802048 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 29 17 00 00       	call   801ec3 <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 ba 18 00 00       	call   802062 <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 79 1a 00 00       	call   80223b <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 1b 18 00 00       	call   802048 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 38 3b 80 00       	push   $0x803b38
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 60 3b 80 00       	push   $0x803b60
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 88 3b 80 00       	push   $0x803b88
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 e0 3b 80 00       	push   $0x803be0
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 38 3b 80 00       	push   $0x803b38
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 9b 17 00 00       	call   802062 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 28 19 00 00       	call   802207 <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 7d 19 00 00       	call   80226d <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 f4 3b 80 00       	push   $0x803bf4
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 f9 3b 80 00       	push   $0x803bf9
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 15 3c 80 00       	push   $0x803c15
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 18 3c 80 00       	push   $0x803c18
  800982:	6a 26                	push   $0x26
  800984:	68 64 3c 80 00       	push   $0x803c64
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 70 3c 80 00       	push   $0x803c70
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 64 3c 80 00       	push   $0x803c64
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 c4 3c 80 00       	push   $0x803cc4
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 64 3c 80 00       	push   $0x803c64
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 7c 13 00 00       	call   801e9a <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 05 13 00 00       	call   801e9a <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 69 14 00 00       	call   802048 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 63 14 00 00       	call   802062 <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 7f 2a 00 00       	call   8036c8 <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 3f 2b 00 00       	call   8037d8 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 34 3f 80 00       	add    $0x803f34,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 45 3f 80 00       	push   $0x803f45
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 4e 3f 80 00       	push   $0x803f4e
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 b0 40 80 00       	push   $0x8040b0
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801968:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80196f:	00 00 00 
  801972:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801979:	00 00 00 
  80197c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801983:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801986:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80198d:	00 00 00 
  801990:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801997:	00 00 00 
  80199a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019a1:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8019a4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019ab:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8019ae:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8019b5:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019c4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019c9:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8019ce:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8019d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019dd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	6a 06                	push   $0x6
  8019e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ea:	50                   	push   %eax
  8019eb:	e8 ee 05 00 00       	call   801fde <sys_allocate_chunk>
  8019f0:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8019f3:	a1 20 51 80 00       	mov    0x805120,%eax
  8019f8:	83 ec 0c             	sub    $0xc,%esp
  8019fb:	50                   	push   %eax
  8019fc:	e8 63 0c 00 00       	call   802664 <initialize_MemBlocksList>
  801a01:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801a04:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a09:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a0f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a19:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a27:	89 c2                	mov    %eax,%edx
  801a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a2c:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a32:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801a39:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a43:	8b 50 08             	mov    0x8(%eax),%edx
  801a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	48                   	dec    %eax
  801a4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
  801a57:	f7 75 e0             	divl   -0x20(%ebp)
  801a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a5d:	29 d0                	sub    %edx,%eax
  801a5f:	89 c2                	mov    %eax,%edx
  801a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a64:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801a67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a6b:	75 14                	jne    801a81 <initialize_dyn_block_system+0x11f>
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	68 d5 40 80 00       	push   $0x8040d5
  801a75:	6a 34                	push   $0x34
  801a77:	68 f3 40 80 00       	push   $0x8040f3
  801a7c:	e8 72 ee ff ff       	call   8008f3 <_panic>
  801a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a84:	8b 00                	mov    (%eax),%eax
  801a86:	85 c0                	test   %eax,%eax
  801a88:	74 10                	je     801a9a <initialize_dyn_block_system+0x138>
  801a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8d:	8b 00                	mov    (%eax),%eax
  801a8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a92:	8b 52 04             	mov    0x4(%edx),%edx
  801a95:	89 50 04             	mov    %edx,0x4(%eax)
  801a98:	eb 0b                	jmp    801aa5 <initialize_dyn_block_system+0x143>
  801a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9d:	8b 40 04             	mov    0x4(%eax),%eax
  801aa0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aa8:	8b 40 04             	mov    0x4(%eax),%eax
  801aab:	85 c0                	test   %eax,%eax
  801aad:	74 0f                	je     801abe <initialize_dyn_block_system+0x15c>
  801aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab2:	8b 40 04             	mov    0x4(%eax),%eax
  801ab5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ab8:	8b 12                	mov    (%edx),%edx
  801aba:	89 10                	mov    %edx,(%eax)
  801abc:	eb 0a                	jmp    801ac8 <initialize_dyn_block_system+0x166>
  801abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ac1:	8b 00                	mov    (%eax),%eax
  801ac3:	a3 48 51 80 00       	mov    %eax,0x805148
  801ac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ad1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801adb:	a1 54 51 80 00       	mov    0x805154,%eax
  801ae0:	48                   	dec    %eax
  801ae1:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801ae6:	83 ec 0c             	sub    $0xc,%esp
  801ae9:	ff 75 e8             	pushl  -0x18(%ebp)
  801aec:	e8 c4 13 00 00       	call   802eb5 <insert_sorted_with_merge_freeList>
  801af1:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801afd:	e8 2f fe ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b06:	75 07                	jne    801b0f <malloc+0x18>
  801b08:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0d:	eb 71                	jmp    801b80 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801b0f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b16:	76 07                	jbe    801b1f <malloc+0x28>
	return NULL;
  801b18:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1d:	eb 61                	jmp    801b80 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b1f:	e8 88 08 00 00       	call   8023ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b24:	85 c0                	test   %eax,%eax
  801b26:	74 53                	je     801b7b <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b28:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	01 d0                	add    %edx,%eax
  801b37:	48                   	dec    %eax
  801b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b43:	f7 75 f4             	divl   -0xc(%ebp)
  801b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b49:	29 d0                	sub    %edx,%eax
  801b4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	ff 75 ec             	pushl  -0x14(%ebp)
  801b54:	e8 d2 0d 00 00       	call   80292b <alloc_block_FF>
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801b5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b63:	74 16                	je     801b7b <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 e8             	pushl  -0x18(%ebp)
  801b6b:	e8 0c 0c 00 00       	call   80277c <insert_sorted_allocList>
  801b70:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b76:	8b 40 08             	mov    0x8(%eax),%eax
  801b79:	eb 05                	jmp    801b80 <malloc+0x89>
    }

			}


	return NULL;
  801b7b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b9f:	68 40 50 80 00       	push   $0x805040
  801ba4:	e8 a0 0b 00 00       	call   802749 <find_block>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb2:	8b 50 0c             	mov    0xc(%eax),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	52                   	push   %edx
  801bbc:	50                   	push   %eax
  801bbd:	e8 e4 03 00 00       	call   801fa6 <sys_free_user_mem>
  801bc2:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801bc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bc9:	75 17                	jne    801be2 <free+0x60>
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	68 d5 40 80 00       	push   $0x8040d5
  801bd3:	68 84 00 00 00       	push   $0x84
  801bd8:	68 f3 40 80 00       	push   $0x8040f3
  801bdd:	e8 11 ed ff ff       	call   8008f3 <_panic>
  801be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be5:	8b 00                	mov    (%eax),%eax
  801be7:	85 c0                	test   %eax,%eax
  801be9:	74 10                	je     801bfb <free+0x79>
  801beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bee:	8b 00                	mov    (%eax),%eax
  801bf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bf3:	8b 52 04             	mov    0x4(%edx),%edx
  801bf6:	89 50 04             	mov    %edx,0x4(%eax)
  801bf9:	eb 0b                	jmp    801c06 <free+0x84>
  801bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfe:	8b 40 04             	mov    0x4(%eax),%eax
  801c01:	a3 44 50 80 00       	mov    %eax,0x805044
  801c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c09:	8b 40 04             	mov    0x4(%eax),%eax
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	74 0f                	je     801c1f <free+0x9d>
  801c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c13:	8b 40 04             	mov    0x4(%eax),%eax
  801c16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c19:	8b 12                	mov    (%edx),%edx
  801c1b:	89 10                	mov    %edx,(%eax)
  801c1d:	eb 0a                	jmp    801c29 <free+0xa7>
  801c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c22:	8b 00                	mov    (%eax),%eax
  801c24:	a3 40 50 80 00       	mov    %eax,0x805040
  801c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c3c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c41:	48                   	dec    %eax
  801c42:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801c47:	83 ec 0c             	sub    $0xc,%esp
  801c4a:	ff 75 ec             	pushl  -0x14(%ebp)
  801c4d:	e8 63 12 00 00       	call   802eb5 <insert_sorted_with_merge_freeList>
  801c52:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801c55:	90                   	nop
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 38             	sub    $0x38,%esp
  801c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c61:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c64:	e8 c8 fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c6d:	75 0a                	jne    801c79 <smalloc+0x21>
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c74:	e9 a0 00 00 00       	jmp    801d19 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801c79:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801c80:	76 0a                	jbe    801c8c <smalloc+0x34>
		return NULL;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	e9 8d 00 00 00       	jmp    801d19 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c8c:	e8 1b 07 00 00       	call   8023ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c91:	85 c0                	test   %eax,%eax
  801c93:	74 7f                	je     801d14 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801c95:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	01 d0                	add    %edx,%eax
  801ca4:	48                   	dec    %eax
  801ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb0:	f7 75 f4             	divl   -0xc(%ebp)
  801cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb6:	29 d0                	sub    %edx,%eax
  801cb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	ff 75 ec             	pushl  -0x14(%ebp)
  801cc1:	e8 65 0c 00 00       	call   80292b <alloc_block_FF>
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801cd0:	74 42                	je     801d14 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	ff 75 e8             	pushl  -0x18(%ebp)
  801cd8:	e8 9f 0a 00 00       	call   80277c <insert_sorted_allocList>
  801cdd:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801ce0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce3:	8b 40 08             	mov    0x8(%eax),%eax
  801ce6:	89 c2                	mov    %eax,%edx
  801ce8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	e8 38 04 00 00       	call   802131 <sys_createSharedObject>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801cff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d03:	79 07                	jns    801d0c <smalloc+0xb4>
	    		  return NULL;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 0d                	jmp    801d19 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d0f:	8b 40 08             	mov    0x8(%eax),%eax
  801d12:	eb 05                	jmp    801d19 <smalloc+0xc1>


				}


		return NULL;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d21:	e8 0b fc ff ff       	call   801931 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d26:	e8 81 06 00 00       	call   8023ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	0f 84 9f 00 00 00    	je     801dd2 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	e8 1a 04 00 00       	call   80215b <sys_getSizeOfSharedObject>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4b:	79 0a                	jns    801d57 <sget+0x3c>
		return NULL;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	e9 80 00 00 00       	jmp    801dd7 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d57:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d64:	01 d0                	add    %edx,%eax
  801d66:	48                   	dec    %eax
  801d67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d72:	f7 75 f0             	divl   -0x10(%ebp)
  801d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d78:	29 d0                	sub    %edx,%eax
  801d7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 75 e8             	pushl  -0x18(%ebp)
  801d83:	e8 a3 0b 00 00       	call   80292b <alloc_block_FF>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801d8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d92:	74 3e                	je     801dd2 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d9a:	e8 dd 09 00 00       	call   80277c <insert_sorted_allocList>
  801d9f:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da5:	8b 40 08             	mov    0x8(%eax),%eax
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	50                   	push   %eax
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	e8 c1 03 00 00       	call   802178 <sys_getSharedObject>
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801dbd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dc1:	79 07                	jns    801dca <sget+0xaf>
	    		  return NULL;
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc8:	eb 0d                	jmp    801dd7 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcd:	8b 40 08             	mov    0x8(%eax),%eax
  801dd0:	eb 05                	jmp    801dd7 <sget+0xbc>
	      }
	}
	   return NULL;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ddf:	e8 4d fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	68 00 41 80 00       	push   $0x804100
  801dec:	68 12 01 00 00       	push   $0x112
  801df1:	68 f3 40 80 00       	push   $0x8040f3
  801df6:	e8 f8 ea ff ff       	call   8008f3 <_panic>

00801dfb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	68 28 41 80 00       	push   $0x804128
  801e09:	68 26 01 00 00       	push   $0x126
  801e0e:	68 f3 40 80 00       	push   $0x8040f3
  801e13:	e8 db ea ff ff       	call   8008f3 <_panic>

00801e18 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 4c 41 80 00       	push   $0x80414c
  801e26:	68 31 01 00 00       	push   $0x131
  801e2b:	68 f3 40 80 00       	push   $0x8040f3
  801e30:	e8 be ea ff ff       	call   8008f3 <_panic>

00801e35 <shrink>:

}
void shrink(uint32 newSize)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	68 4c 41 80 00       	push   $0x80414c
  801e43:	68 36 01 00 00       	push   $0x136
  801e48:	68 f3 40 80 00       	push   $0x8040f3
  801e4d:	e8 a1 ea ff ff       	call   8008f3 <_panic>

00801e52 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 4c 41 80 00       	push   $0x80414c
  801e60:	68 3b 01 00 00       	push   $0x13b
  801e65:	68 f3 40 80 00       	push   $0x8040f3
  801e6a:	e8 84 ea ff ff       	call   8008f3 <_panic>

00801e6f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	57                   	push   %edi
  801e73:	56                   	push   %esi
  801e74:	53                   	push   %ebx
  801e75:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e84:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e87:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e8a:	cd 30                	int    $0x30
  801e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5f                   	pop    %edi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ea6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	52                   	push   %edx
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	50                   	push   %eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	e8 b2 ff ff ff       	call   801e6f <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	90                   	nop
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 01                	push   $0x1
  801ed2:	e8 98 ff ff ff       	call   801e6f <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 05                	push   $0x5
  801eef:	e8 7b ff ff ff       	call   801e6f <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801efe:	8b 75 18             	mov    0x18(%ebp),%esi
  801f01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	56                   	push   %esi
  801f0e:	53                   	push   %ebx
  801f0f:	51                   	push   %ecx
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 06                	push   $0x6
  801f14:	e8 56 ff ff ff       	call   801e6f <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	6a 07                	push   $0x7
  801f36:	e8 34 ff ff ff       	call   801e6f <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	ff 75 08             	pushl  0x8(%ebp)
  801f4f:	6a 08                	push   $0x8
  801f51:	e8 19 ff ff ff       	call   801e6f <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 09                	push   $0x9
  801f6a:	e8 00 ff ff ff       	call   801e6f <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 0a                	push   $0xa
  801f83:	e8 e7 fe ff ff       	call   801e6f <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 0b                	push   $0xb
  801f9c:	e8 ce fe ff ff       	call   801e6f <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	6a 0f                	push   $0xf
  801fb7:	e8 b3 fe ff ff       	call   801e6f <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
	return;
  801fbf:	90                   	nop
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	ff 75 08             	pushl  0x8(%ebp)
  801fd1:	6a 10                	push   $0x10
  801fd3:	e8 97 fe ff ff       	call   801e6f <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdb:	90                   	nop
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	ff 75 10             	pushl  0x10(%ebp)
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	6a 11                	push   $0x11
  801ff0:	e8 7a fe ff ff       	call   801e6f <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff8:	90                   	nop
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 0c                	push   $0xc
  80200a:	e8 60 fe ff ff       	call   801e6f <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	6a 0d                	push   $0xd
  802024:	e8 46 fe ff ff       	call   801e6f <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 0e                	push   $0xe
  80203d:	e8 2d fe ff ff       	call   801e6f <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	90                   	nop
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 13                	push   $0x13
  802057:	e8 13 fe ff ff       	call   801e6f <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	90                   	nop
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 14                	push   $0x14
  802071:	e8 f9 fd ff ff       	call   801e6f <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	90                   	nop
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_cputc>:


void
sys_cputc(const char c)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802088:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	50                   	push   %eax
  802095:	6a 15                	push   $0x15
  802097:	e8 d3 fd ff ff       	call   801e6f <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
}
  80209f:	90                   	nop
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 16                	push   $0x16
  8020b1:	e8 b9 fd ff ff       	call   801e6f <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	90                   	nop
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	50                   	push   %eax
  8020cc:	6a 17                	push   $0x17
  8020ce:	e8 9c fd ff ff       	call   801e6f <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	52                   	push   %edx
  8020e8:	50                   	push   %eax
  8020e9:	6a 1a                	push   $0x1a
  8020eb:	e8 7f fd ff ff       	call   801e6f <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	52                   	push   %edx
  802105:	50                   	push   %eax
  802106:	6a 18                	push   $0x18
  802108:	e8 62 fd ff ff       	call   801e6f <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	90                   	nop
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802116:	8b 55 0c             	mov    0xc(%ebp),%edx
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	6a 19                	push   $0x19
  802126:	e8 44 fd ff ff       	call   801e6f <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	90                   	nop
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 04             	sub    $0x4,%esp
  802137:	8b 45 10             	mov    0x10(%ebp),%eax
  80213a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80213d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802140:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	6a 00                	push   $0x0
  802149:	51                   	push   %ecx
  80214a:	52                   	push   %edx
  80214b:	ff 75 0c             	pushl  0xc(%ebp)
  80214e:	50                   	push   %eax
  80214f:	6a 1b                	push   $0x1b
  802151:	e8 19 fd ff ff       	call   801e6f <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80215e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	52                   	push   %edx
  80216b:	50                   	push   %eax
  80216c:	6a 1c                	push   $0x1c
  80216e:	e8 fc fc ff ff       	call   801e6f <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80217b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80217e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	51                   	push   %ecx
  802189:	52                   	push   %edx
  80218a:	50                   	push   %eax
  80218b:	6a 1d                	push   $0x1d
  80218d:	e8 dd fc ff ff       	call   801e6f <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80219a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	6a 1e                	push   $0x1e
  8021aa:	e8 c0 fc ff ff       	call   801e6f <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 1f                	push   $0x1f
  8021c3:	e8 a7 fc ff ff       	call   801e6f <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	ff 75 14             	pushl  0x14(%ebp)
  8021d8:	ff 75 10             	pushl  0x10(%ebp)
  8021db:	ff 75 0c             	pushl  0xc(%ebp)
  8021de:	50                   	push   %eax
  8021df:	6a 20                	push   $0x20
  8021e1:	e8 89 fc ff ff       	call   801e6f <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	50                   	push   %eax
  8021fa:	6a 21                	push   $0x21
  8021fc:	e8 6e fc ff ff       	call   801e6f <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	90                   	nop
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	50                   	push   %eax
  802216:	6a 22                	push   $0x22
  802218:	e8 52 fc ff ff       	call   801e6f <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 02                	push   $0x2
  802231:	e8 39 fc ff ff       	call   801e6f <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 03                	push   $0x3
  80224a:	e8 20 fc ff ff       	call   801e6f <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 04                	push   $0x4
  802263:	e8 07 fc ff ff       	call   801e6f <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_exit_env>:


void sys_exit_env(void)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 23                	push   $0x23
  80227c:	e8 ee fb ff ff       	call   801e6f <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	90                   	nop
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80228d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802290:	8d 50 04             	lea    0x4(%eax),%edx
  802293:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	52                   	push   %edx
  80229d:	50                   	push   %eax
  80229e:	6a 24                	push   $0x24
  8022a0:	e8 ca fb ff ff       	call   801e6f <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
	return result;
  8022a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b1:	89 01                	mov    %eax,(%ecx)
  8022b3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	c9                   	leave  
  8022ba:	c2 04 00             	ret    $0x4

008022bd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	ff 75 10             	pushl  0x10(%ebp)
  8022c7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ca:	ff 75 08             	pushl  0x8(%ebp)
  8022cd:	6a 12                	push   $0x12
  8022cf:	e8 9b fb ff ff       	call   801e6f <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d7:	90                   	nop
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_rcr2>:
uint32 sys_rcr2()
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 25                	push   $0x25
  8022e9:	e8 81 fb ff ff       	call   801e6f <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 04             	sub    $0x4,%esp
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022ff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	50                   	push   %eax
  80230c:	6a 26                	push   $0x26
  80230e:	e8 5c fb ff ff       	call   801e6f <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
	return ;
  802316:	90                   	nop
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <rsttst>:
void rsttst()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 28                	push   $0x28
  802328:	e8 42 fb ff ff       	call   801e6f <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
	return ;
  802330:	90                   	nop
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 04             	sub    $0x4,%esp
  802339:	8b 45 14             	mov    0x14(%ebp),%eax
  80233c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80233f:	8b 55 18             	mov    0x18(%ebp),%edx
  802342:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	ff 75 10             	pushl  0x10(%ebp)
  80234b:	ff 75 0c             	pushl  0xc(%ebp)
  80234e:	ff 75 08             	pushl  0x8(%ebp)
  802351:	6a 27                	push   $0x27
  802353:	e8 17 fb ff ff       	call   801e6f <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
	return ;
  80235b:	90                   	nop
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <chktst>:
void chktst(uint32 n)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 29                	push   $0x29
  80236e:	e8 fc fa ff ff       	call   801e6f <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return ;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <inctst>:

void inctst()
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 2a                	push   $0x2a
  802388:	e8 e2 fa ff ff       	call   801e6f <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
	return ;
  802390:	90                   	nop
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <gettst>:
uint32 gettst()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 2b                	push   $0x2b
  8023a2:	e8 c8 fa ff ff       	call   801e6f <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 2c                	push   $0x2c
  8023be:	e8 ac fa ff ff       	call   801e6f <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
  8023c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023c9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023cd:	75 07                	jne    8023d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d4:	eb 05                	jmp    8023db <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 2c                	push   $0x2c
  8023ef:	e8 7b fa ff ff       	call   801e6f <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
  8023f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023fa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023fe:	75 07                	jne    802407 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802400:	b8 01 00 00 00       	mov    $0x1,%eax
  802405:	eb 05                	jmp    80240c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 2c                	push   $0x2c
  802420:	e8 4a fa ff ff       	call   801e6f <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
  802428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80242b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80242f:	75 07                	jne    802438 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802431:	b8 01 00 00 00       	mov    $0x1,%eax
  802436:	eb 05                	jmp    80243d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  802451:	e8 19 fa ff ff       	call   801e6f <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
  802459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80245c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802460:	75 07                	jne    802469 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802462:	b8 01 00 00 00       	mov    $0x1,%eax
  802467:	eb 05                	jmp    80246e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	ff 75 08             	pushl  0x8(%ebp)
  80247e:	6a 2d                	push   $0x2d
  802480:	e8 ea f9 ff ff       	call   801e6f <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
	return ;
  802488:	90                   	nop
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80248f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802492:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802495:	8b 55 0c             	mov    0xc(%ebp),%edx
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	6a 00                	push   $0x0
  80249d:	53                   	push   %ebx
  80249e:	51                   	push   %ecx
  80249f:	52                   	push   %edx
  8024a0:	50                   	push   %eax
  8024a1:	6a 2e                	push   $0x2e
  8024a3:	e8 c7 f9 ff ff       	call   801e6f <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
}
  8024ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	52                   	push   %edx
  8024c0:	50                   	push   %eax
  8024c1:	6a 2f                	push   $0x2f
  8024c3:	e8 a7 f9 ff ff       	call   801e6f <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
  8024d0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	68 5c 41 80 00       	push   $0x80415c
  8024db:	e8 c7 e6 ff ff       	call   800ba7 <cprintf>
  8024e0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024ea:	83 ec 0c             	sub    $0xc,%esp
  8024ed:	68 88 41 80 00       	push   $0x804188
  8024f2:	e8 b0 e6 ff ff       	call   800ba7 <cprintf>
  8024f7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024fa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802503:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802506:	eb 56                	jmp    80255e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802508:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80250c:	74 1c                	je     80252a <print_mem_block_lists+0x5d>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 50 08             	mov    0x8(%eax),%edx
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	8b 48 08             	mov    0x8(%eax),%ecx
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 40 0c             	mov    0xc(%eax),%eax
  802520:	01 c8                	add    %ecx,%eax
  802522:	39 c2                	cmp    %eax,%edx
  802524:	73 04                	jae    80252a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802526:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 50 08             	mov    0x8(%eax),%edx
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 0c             	mov    0xc(%eax),%eax
  802536:	01 c2                	add    %eax,%edx
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 08             	mov    0x8(%eax),%eax
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	52                   	push   %edx
  802542:	50                   	push   %eax
  802543:	68 9d 41 80 00       	push   $0x80419d
  802548:	e8 5a e6 ff ff       	call   800ba7 <cprintf>
  80254d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802556:	a1 40 51 80 00       	mov    0x805140,%eax
  80255b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802562:	74 07                	je     80256b <print_mem_block_lists+0x9e>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	eb 05                	jmp    802570 <print_mem_block_lists+0xa3>
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
  802570:	a3 40 51 80 00       	mov    %eax,0x805140
  802575:	a1 40 51 80 00       	mov    0x805140,%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	75 8a                	jne    802508 <print_mem_block_lists+0x3b>
  80257e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802582:	75 84                	jne    802508 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802584:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802588:	75 10                	jne    80259a <print_mem_block_lists+0xcd>
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	68 ac 41 80 00       	push   $0x8041ac
  802592:	e8 10 e6 ff ff       	call   800ba7 <cprintf>
  802597:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80259a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025a1:	83 ec 0c             	sub    $0xc,%esp
  8025a4:	68 d0 41 80 00       	push   $0x8041d0
  8025a9:	e8 f9 e5 ff ff       	call   800ba7 <cprintf>
  8025ae:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025b1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bd:	eb 56                	jmp    802615 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c3:	74 1c                	je     8025e1 <print_mem_block_lists+0x114>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 50 08             	mov    0x8(%eax),%edx
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d7:	01 c8                	add    %ecx,%eax
  8025d9:	39 c2                	cmp    %eax,%edx
  8025db:	73 04                	jae    8025e1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025dd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 50 08             	mov    0x8(%eax),%edx
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	01 c2                	add    %eax,%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 08             	mov    0x8(%eax),%eax
  8025f5:	83 ec 04             	sub    $0x4,%esp
  8025f8:	52                   	push   %edx
  8025f9:	50                   	push   %eax
  8025fa:	68 9d 41 80 00       	push   $0x80419d
  8025ff:	e8 a3 e5 ff ff       	call   800ba7 <cprintf>
  802604:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80260d:	a1 48 50 80 00       	mov    0x805048,%eax
  802612:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	74 07                	je     802622 <print_mem_block_lists+0x155>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	eb 05                	jmp    802627 <print_mem_block_lists+0x15a>
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	a3 48 50 80 00       	mov    %eax,0x805048
  80262c:	a1 48 50 80 00       	mov    0x805048,%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	75 8a                	jne    8025bf <print_mem_block_lists+0xf2>
  802635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802639:	75 84                	jne    8025bf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80263b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80263f:	75 10                	jne    802651 <print_mem_block_lists+0x184>
  802641:	83 ec 0c             	sub    $0xc,%esp
  802644:	68 e8 41 80 00       	push   $0x8041e8
  802649:	e8 59 e5 ff ff       	call   800ba7 <cprintf>
  80264e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	68 5c 41 80 00       	push   $0x80415c
  802659:	e8 49 e5 ff ff       	call   800ba7 <cprintf>
  80265e:	83 c4 10             	add    $0x10,%esp

}
  802661:	90                   	nop
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80266a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802671:	00 00 00 
  802674:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80267b:	00 00 00 
  80267e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802685:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802688:	a1 50 50 80 00       	mov    0x805050,%eax
  80268d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802690:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802697:	e9 9e 00 00 00       	jmp    80273a <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80269c:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a4:	c1 e2 04             	shl    $0x4,%edx
  8026a7:	01 d0                	add    %edx,%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	75 14                	jne    8026c1 <initialize_MemBlocksList+0x5d>
  8026ad:	83 ec 04             	sub    $0x4,%esp
  8026b0:	68 10 42 80 00       	push   $0x804210
  8026b5:	6a 48                	push   $0x48
  8026b7:	68 33 42 80 00       	push   $0x804233
  8026bc:	e8 32 e2 ff ff       	call   8008f3 <_panic>
  8026c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c9:	c1 e2 04             	shl    $0x4,%edx
  8026cc:	01 d0                	add    %edx,%eax
  8026ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026d4:	89 10                	mov    %edx,(%eax)
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	74 18                	je     8026f4 <initialize_MemBlocksList+0x90>
  8026dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026ea:	c1 e1 04             	shl    $0x4,%ecx
  8026ed:	01 ca                	add    %ecx,%edx
  8026ef:	89 50 04             	mov    %edx,0x4(%eax)
  8026f2:	eb 12                	jmp    802706 <initialize_MemBlocksList+0xa2>
  8026f4:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fc:	c1 e2 04             	shl    $0x4,%edx
  8026ff:	01 d0                	add    %edx,%eax
  802701:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802706:	a1 50 50 80 00       	mov    0x805050,%eax
  80270b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270e:	c1 e2 04             	shl    $0x4,%edx
  802711:	01 d0                	add    %edx,%eax
  802713:	a3 48 51 80 00       	mov    %eax,0x805148
  802718:	a1 50 50 80 00       	mov    0x805050,%eax
  80271d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802720:	c1 e2 04             	shl    $0x4,%edx
  802723:	01 d0                	add    %edx,%eax
  802725:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272c:	a1 54 51 80 00       	mov    0x805154,%eax
  802731:	40                   	inc    %eax
  802732:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802737:	ff 45 f4             	incl   -0xc(%ebp)
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802740:	0f 82 56 ff ff ff    	jb     80269c <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802746:	90                   	nop
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802757:	eb 18                	jmp    802771 <find_block+0x28>
		{
			if(tmp->sva==va)
  802759:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80275c:	8b 40 08             	mov    0x8(%eax),%eax
  80275f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802762:	75 05                	jne    802769 <find_block+0x20>
			{
				return tmp;
  802764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802767:	eb 11                	jmp    80277a <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802771:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802775:	75 e2                	jne    802759 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802777:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802782:	a1 40 50 80 00       	mov    0x805040,%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 85 83 00 00 00    	jne    802812 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80278f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802796:	00 00 00 
  802799:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8027a0:	00 00 00 
  8027a3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8027aa:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b1:	75 14                	jne    8027c7 <insert_sorted_allocList+0x4b>
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	68 10 42 80 00       	push   $0x804210
  8027bb:	6a 7f                	push   $0x7f
  8027bd:	68 33 42 80 00       	push   $0x804233
  8027c2:	e8 2c e1 ff ff       	call   8008f3 <_panic>
  8027c7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0d                	je     8027e8 <insert_sorted_allocList+0x6c>
  8027db:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	eb 08                	jmp    8027f0 <insert_sorted_allocList+0x74>
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802802:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802807:	40                   	inc    %eax
  802808:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80280d:	e9 16 01 00 00       	jmp    802928 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	8b 50 08             	mov    0x8(%eax),%edx
  802818:	a1 44 50 80 00       	mov    0x805044,%eax
  80281d:	8b 40 08             	mov    0x8(%eax),%eax
  802820:	39 c2                	cmp    %eax,%edx
  802822:	76 68                	jbe    80288c <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802824:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802828:	75 17                	jne    802841 <insert_sorted_allocList+0xc5>
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 4c 42 80 00       	push   $0x80424c
  802832:	68 85 00 00 00       	push   $0x85
  802837:	68 33 42 80 00       	push   $0x804233
  80283c:	e8 b2 e0 ff ff       	call   8008f3 <_panic>
  802841:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	89 50 04             	mov    %edx,0x4(%eax)
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	8b 40 04             	mov    0x4(%eax),%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	74 0c                	je     802863 <insert_sorted_allocList+0xe7>
  802857:	a1 44 50 80 00       	mov    0x805044,%eax
  80285c:	8b 55 08             	mov    0x8(%ebp),%edx
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	eb 08                	jmp    80286b <insert_sorted_allocList+0xef>
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	a3 40 50 80 00       	mov    %eax,0x805040
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	a3 44 50 80 00       	mov    %eax,0x805044
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802881:	40                   	inc    %eax
  802882:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802887:	e9 9c 00 00 00       	jmp    802928 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80288c:	a1 40 50 80 00       	mov    0x805040,%eax
  802891:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802894:	e9 85 00 00 00       	jmp    80291e <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8b 50 08             	mov    0x8(%eax),%edx
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 08             	mov    0x8(%eax),%eax
  8028a5:	39 c2                	cmp    %eax,%edx
  8028a7:	73 6d                	jae    802916 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	74 06                	je     8028b5 <insert_sorted_allocList+0x139>
  8028af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b3:	75 17                	jne    8028cc <insert_sorted_allocList+0x150>
  8028b5:	83 ec 04             	sub    $0x4,%esp
  8028b8:	68 70 42 80 00       	push   $0x804270
  8028bd:	68 90 00 00 00       	push   $0x90
  8028c2:	68 33 42 80 00       	push   $0x804233
  8028c7:	e8 27 e0 ff ff       	call   8008f3 <_panic>
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 50 04             	mov    0x4(%eax),%edx
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028de:	89 10                	mov    %edx,(%eax)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 0d                	je     8028f7 <insert_sorted_allocList+0x17b>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	eb 08                	jmp    8028ff <insert_sorted_allocList+0x183>
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 55 08             	mov    0x8(%ebp),%edx
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290d:	40                   	inc    %eax
  80290e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802913:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802914:	eb 12                	jmp    802928 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  80291e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802922:	0f 85 71 ff ff ff    	jne    802899 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802928:	90                   	nop
  802929:	c9                   	leave  
  80292a:	c3                   	ret    

0080292b <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802931:	a1 38 51 80 00       	mov    0x805138,%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802939:	e9 76 01 00 00       	jmp    802ab4 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 40 0c             	mov    0xc(%eax),%eax
  802944:	3b 45 08             	cmp    0x8(%ebp),%eax
  802947:	0f 85 8a 00 00 00    	jne    8029d7 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80294d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802951:	75 17                	jne    80296a <alloc_block_FF+0x3f>
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	68 a5 42 80 00       	push   $0x8042a5
  80295b:	68 a8 00 00 00       	push   $0xa8
  802960:	68 33 42 80 00       	push   $0x804233
  802965:	e8 89 df ff ff       	call   8008f3 <_panic>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 10                	je     802983 <alloc_block_FF+0x58>
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297b:	8b 52 04             	mov    0x4(%edx),%edx
  80297e:	89 50 04             	mov    %edx,0x4(%eax)
  802981:	eb 0b                	jmp    80298e <alloc_block_FF+0x63>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 04             	mov    0x4(%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 0f                	je     8029a7 <alloc_block_FF+0x7c>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 04             	mov    0x4(%eax),%eax
  80299e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a1:	8b 12                	mov    (%edx),%edx
  8029a3:	89 10                	mov    %edx,(%eax)
  8029a5:	eb 0a                	jmp    8029b1 <alloc_block_FF+0x86>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8029c9:	48                   	dec    %eax
  8029ca:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	e9 ea 00 00 00       	jmp    802ac1 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e0:	0f 86 c6 00 00 00    	jbe    802aac <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8029e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8029eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f4:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 50 08             	mov    0x8(%eax),%edx
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 40 0c             	mov    0xc(%eax),%eax
  802a09:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0c:	89 c2                	mov    %eax,%edx
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 50 08             	mov    0x8(%eax),%edx
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	01 c2                	add    %eax,%edx
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802a25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a29:	75 17                	jne    802a42 <alloc_block_FF+0x117>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 a5 42 80 00       	push   $0x8042a5
  802a33:	68 b6 00 00 00       	push   $0xb6
  802a38:	68 33 42 80 00       	push   $0x804233
  802a3d:	e8 b1 de ff ff       	call   8008f3 <_panic>
  802a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 10                	je     802a5b <alloc_block_FF+0x130>
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a53:	8b 52 04             	mov    0x4(%edx),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 0b                	jmp    802a66 <alloc_block_FF+0x13b>
  802a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0f                	je     802a7f <alloc_block_FF+0x154>
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a79:	8b 12                	mov    (%edx),%edx
  802a7b:	89 10                	mov    %edx,(%eax)
  802a7d:	eb 0a                	jmp    802a89 <alloc_block_FF+0x15e>
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	a3 48 51 80 00       	mov    %eax,0x805148
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaa:	eb 15                	jmp    802ac1 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab8:	0f 85 80 fe ff ff    	jne    80293e <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ac1:	c9                   	leave  
  802ac2:	c3                   	ret    

00802ac3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ac3:	55                   	push   %ebp
  802ac4:	89 e5                	mov    %esp,%ebp
  802ac6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802ac9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802ad1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802ad8:	e9 c0 00 00 00       	jmp    802b9d <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae6:	0f 85 8a 00 00 00    	jne    802b76 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af0:	75 17                	jne    802b09 <alloc_block_BF+0x46>
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	68 a5 42 80 00       	push   $0x8042a5
  802afa:	68 cf 00 00 00       	push   $0xcf
  802aff:	68 33 42 80 00       	push   $0x804233
  802b04:	e8 ea dd ff ff       	call   8008f3 <_panic>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 10                	je     802b22 <alloc_block_BF+0x5f>
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1a:	8b 52 04             	mov    0x4(%edx),%edx
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	eb 0b                	jmp    802b2d <alloc_block_BF+0x6a>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	74 0f                	je     802b46 <alloc_block_BF+0x83>
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b40:	8b 12                	mov    (%edx),%edx
  802b42:	89 10                	mov    %edx,(%eax)
  802b44:	eb 0a                	jmp    802b50 <alloc_block_BF+0x8d>
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b63:	a1 44 51 80 00       	mov    0x805144,%eax
  802b68:	48                   	dec    %eax
  802b69:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	e9 2a 01 00 00       	jmp    802ca0 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b7f:	73 14                	jae    802b95 <alloc_block_BF+0xd2>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 0c             	mov    0xc(%eax),%eax
  802b87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8a:	76 09                	jbe    802b95 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b92:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	0f 85 36 ff ff ff    	jne    802add <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802ba7:	a1 38 51 80 00       	mov    0x805138,%eax
  802bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802baf:	e9 dd 00 00 00       	jmp    802c91 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bbd:	0f 85 c6 00 00 00    	jne    802c89 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802bc3:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc8:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 50 08             	mov    0x8(%eax),%edx
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bda:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdd:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 50 08             	mov    0x8(%eax),%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	01 c2                	add    %eax,%edx
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bfa:	89 c2                	mov    %eax,%edx
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c06:	75 17                	jne    802c1f <alloc_block_BF+0x15c>
  802c08:	83 ec 04             	sub    $0x4,%esp
  802c0b:	68 a5 42 80 00       	push   $0x8042a5
  802c10:	68 eb 00 00 00       	push   $0xeb
  802c15:	68 33 42 80 00       	push   $0x804233
  802c1a:	e8 d4 dc ff ff       	call   8008f3 <_panic>
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 10                	je     802c38 <alloc_block_BF+0x175>
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c30:	8b 52 04             	mov    0x4(%edx),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	eb 0b                	jmp    802c43 <alloc_block_BF+0x180>
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0f                	je     802c5c <alloc_block_BF+0x199>
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c56:	8b 12                	mov    (%edx),%edx
  802c58:	89 10                	mov    %edx,(%eax)
  802c5a:	eb 0a                	jmp    802c66 <alloc_block_BF+0x1a3>
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	a3 48 51 80 00       	mov    %eax,0x805148
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c79:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7e:	48                   	dec    %eax
  802c7f:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	eb 17                	jmp    802ca0 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c95:	0f 85 19 ff ff ff    	jne    802bb4 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802ca0:	c9                   	leave  
  802ca1:	c3                   	ret    

00802ca2 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802ca2:	55                   	push   %ebp
  802ca3:	89 e5                	mov    %esp,%ebp
  802ca5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802ca8:	a1 40 50 80 00       	mov    0x805040,%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	75 19                	jne    802cca <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802cb1:	83 ec 0c             	sub    $0xc,%esp
  802cb4:	ff 75 08             	pushl  0x8(%ebp)
  802cb7:	e8 6f fc ff ff       	call   80292b <alloc_block_FF>
  802cbc:	83 c4 10             	add    $0x10,%esp
  802cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	e9 e9 01 00 00       	jmp    802eb3 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802cca:	a1 44 50 80 00       	mov    0x805044,%eax
  802ccf:	8b 40 08             	mov    0x8(%eax),%eax
  802cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802cd5:	a1 44 50 80 00       	mov    0x805044,%eax
  802cda:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdd:	a1 44 50 80 00       	mov    0x805044,%eax
  802ce2:	8b 40 08             	mov    0x8(%eax),%eax
  802ce5:	01 d0                	add    %edx,%eax
  802ce7:	83 ec 08             	sub    $0x8,%esp
  802cea:	50                   	push   %eax
  802ceb:	68 38 51 80 00       	push   $0x805138
  802cf0:	e8 54 fa ff ff       	call   802749 <find_block>
  802cf5:	83 c4 10             	add    $0x10,%esp
  802cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d04:	0f 85 9b 00 00 00    	jne    802da5 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 08             	mov    0x8(%eax),%eax
  802d16:	01 d0                	add    %edx,%eax
  802d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1f:	75 17                	jne    802d38 <alloc_block_NF+0x96>
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 a5 42 80 00       	push   $0x8042a5
  802d29:	68 1a 01 00 00       	push   $0x11a
  802d2e:	68 33 42 80 00       	push   $0x804233
  802d33:	e8 bb db ff ff       	call   8008f3 <_panic>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 10                	je     802d51 <alloc_block_NF+0xaf>
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d49:	8b 52 04             	mov    0x4(%edx),%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	eb 0b                	jmp    802d5c <alloc_block_NF+0xba>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 0f                	je     802d75 <alloc_block_NF+0xd3>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6f:	8b 12                	mov    (%edx),%edx
  802d71:	89 10                	mov    %edx,(%eax)
  802d73:	eb 0a                	jmp    802d7f <alloc_block_NF+0xdd>
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d92:	a1 44 51 80 00       	mov    0x805144,%eax
  802d97:	48                   	dec    %eax
  802d98:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	e9 0e 01 00 00       	jmp    802eb3 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dae:	0f 86 cf 00 00 00    	jbe    802e83 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802db4:	a1 48 51 80 00       	mov    0x805148,%eax
  802db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc2:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 50 08             	mov    0x8(%eax),%edx
  802dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dce:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	2b 45 08             	sub    0x8(%ebp),%eax
  802deb:	89 c2                	mov    %eax,%edx
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 08             	mov    0x8(%eax),%eax
  802df9:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e00:	75 17                	jne    802e19 <alloc_block_NF+0x177>
  802e02:	83 ec 04             	sub    $0x4,%esp
  802e05:	68 a5 42 80 00       	push   $0x8042a5
  802e0a:	68 28 01 00 00       	push   $0x128
  802e0f:	68 33 42 80 00       	push   $0x804233
  802e14:	e8 da da ff ff       	call   8008f3 <_panic>
  802e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 10                	je     802e32 <alloc_block_NF+0x190>
  802e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e2a:	8b 52 04             	mov    0x4(%edx),%edx
  802e2d:	89 50 04             	mov    %edx,0x4(%eax)
  802e30:	eb 0b                	jmp    802e3d <alloc_block_NF+0x19b>
  802e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e35:	8b 40 04             	mov    0x4(%eax),%eax
  802e38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	8b 40 04             	mov    0x4(%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 0f                	je     802e56 <alloc_block_NF+0x1b4>
  802e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e50:	8b 12                	mov    (%edx),%edx
  802e52:	89 10                	mov    %edx,(%eax)
  802e54:	eb 0a                	jmp    802e60 <alloc_block_NF+0x1be>
  802e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e73:	a1 54 51 80 00       	mov    0x805154,%eax
  802e78:	48                   	dec    %eax
  802e79:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e81:	eb 30                	jmp    802eb3 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802e83:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e8b:	75 0a                	jne    802e97 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802e8d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e95:	eb 08                	jmp    802e9f <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 08             	mov    0x8(%eax),%eax
  802ea5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ea8:	0f 85 4d fe ff ff    	jne    802cfb <alloc_block_NF+0x59>

			return NULL;
  802eae:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802eb3:	c9                   	leave  
  802eb4:	c3                   	ret    

00802eb5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
  802eb8:	53                   	push   %ebx
  802eb9:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802ebc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	0f 85 86 00 00 00    	jne    802f4f <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802ec9:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802ed0:	00 00 00 
  802ed3:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802eda:	00 00 00 
  802edd:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802ee4:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eeb:	75 17                	jne    802f04 <insert_sorted_with_merge_freeList+0x4f>
  802eed:	83 ec 04             	sub    $0x4,%esp
  802ef0:	68 10 42 80 00       	push   $0x804210
  802ef5:	68 48 01 00 00       	push   $0x148
  802efa:	68 33 42 80 00       	push   $0x804233
  802eff:	e8 ef d9 ff ff       	call   8008f3 <_panic>
  802f04:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0d                	je     802f25 <insert_sorted_with_merge_freeList+0x70>
  802f18:	a1 38 51 80 00       	mov    0x805138,%eax
  802f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	eb 08                	jmp    802f2d <insert_sorted_with_merge_freeList+0x78>
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	a3 38 51 80 00       	mov    %eax,0x805138
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f44:	40                   	inc    %eax
  802f45:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802f4a:	e9 73 07 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	39 c2                	cmp    %eax,%edx
  802f5f:	0f 86 84 00 00 00    	jbe    802fe9 <insert_sorted_with_merge_freeList+0x134>
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f70:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f73:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f78:	8b 40 08             	mov    0x8(%eax),%eax
  802f7b:	01 c8                	add    %ecx,%eax
  802f7d:	39 c2                	cmp    %eax,%edx
  802f7f:	74 68                	je     802fe9 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f85:	75 17                	jne    802f9e <insert_sorted_with_merge_freeList+0xe9>
  802f87:	83 ec 04             	sub    $0x4,%esp
  802f8a:	68 4c 42 80 00       	push   $0x80424c
  802f8f:	68 4c 01 00 00       	push   $0x14c
  802f94:	68 33 42 80 00       	push   $0x804233
  802f99:	e8 55 d9 ff ff       	call   8008f3 <_panic>
  802f9e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	89 50 04             	mov    %edx,0x4(%eax)
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 40 04             	mov    0x4(%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 0c                	je     802fc0 <insert_sorted_with_merge_freeList+0x10b>
  802fb4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbc:	89 10                	mov    %edx,(%eax)
  802fbe:	eb 08                	jmp    802fc8 <insert_sorted_with_merge_freeList+0x113>
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	a3 38 51 80 00       	mov    %eax,0x805138
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 44 51 80 00       	mov    %eax,0x805144
  802fe4:	e9 d9 06 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ff4:	8b 40 08             	mov    0x8(%eax),%eax
  802ff7:	39 c2                	cmp    %eax,%edx
  802ff9:	0f 86 b5 00 00 00    	jbe    8030b4 <insert_sorted_with_merge_freeList+0x1ff>
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8b 50 08             	mov    0x8(%eax),%edx
  803005:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80300a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80300d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803012:	8b 40 08             	mov    0x8(%eax),%eax
  803015:	01 c8                	add    %ecx,%eax
  803017:	39 c2                	cmp    %eax,%edx
  803019:	0f 85 95 00 00 00    	jne    8030b4 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  80301f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803024:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80302a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80302d:	8b 55 08             	mov    0x8(%ebp),%edx
  803030:	8b 52 0c             	mov    0xc(%edx),%edx
  803033:	01 ca                	add    %ecx,%edx
  803035:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80304c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803050:	75 17                	jne    803069 <insert_sorted_with_merge_freeList+0x1b4>
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	68 10 42 80 00       	push   $0x804210
  80305a:	68 54 01 00 00       	push   $0x154
  80305f:	68 33 42 80 00       	push   $0x804233
  803064:	e8 8a d8 ff ff       	call   8008f3 <_panic>
  803069:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	89 10                	mov    %edx,(%eax)
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0d                	je     80308a <insert_sorted_with_merge_freeList+0x1d5>
  80307d:	a1 48 51 80 00       	mov    0x805148,%eax
  803082:	8b 55 08             	mov    0x8(%ebp),%edx
  803085:	89 50 04             	mov    %edx,0x4(%eax)
  803088:	eb 08                	jmp    803092 <insert_sorted_with_merge_freeList+0x1dd>
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	a3 48 51 80 00       	mov    %eax,0x805148
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a9:	40                   	inc    %eax
  8030aa:	a3 54 51 80 00       	mov    %eax,0x805154
  8030af:	e9 0e 06 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	39 c2                	cmp    %eax,%edx
  8030c4:	0f 83 c1 00 00 00    	jae    80318b <insert_sorted_with_merge_freeList+0x2d6>
  8030ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8030cf:	8b 50 08             	mov    0x8(%eax),%edx
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 48 08             	mov    0x8(%eax),%ecx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 0c             	mov    0xc(%eax),%eax
  8030de:	01 c8                	add    %ecx,%eax
  8030e0:	39 c2                	cmp    %eax,%edx
  8030e2:	0f 85 a3 00 00 00    	jne    80318b <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8030e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f0:	8b 52 08             	mov    0x8(%edx),%edx
  8030f3:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8030f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030fb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803101:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803104:	8b 55 08             	mov    0x8(%ebp),%edx
  803107:	8b 52 0c             	mov    0xc(%edx),%edx
  80310a:	01 ca                	add    %ecx,%edx
  80310c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803123:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803127:	75 17                	jne    803140 <insert_sorted_with_merge_freeList+0x28b>
  803129:	83 ec 04             	sub    $0x4,%esp
  80312c:	68 10 42 80 00       	push   $0x804210
  803131:	68 5d 01 00 00       	push   $0x15d
  803136:	68 33 42 80 00       	push   $0x804233
  80313b:	e8 b3 d7 ff ff       	call   8008f3 <_panic>
  803140:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	89 10                	mov    %edx,(%eax)
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0d                	je     803161 <insert_sorted_with_merge_freeList+0x2ac>
  803154:	a1 48 51 80 00       	mov    0x805148,%eax
  803159:	8b 55 08             	mov    0x8(%ebp),%edx
  80315c:	89 50 04             	mov    %edx,0x4(%eax)
  80315f:	eb 08                	jmp    803169 <insert_sorted_with_merge_freeList+0x2b4>
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	a3 48 51 80 00       	mov    %eax,0x805148
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 54 51 80 00       	mov    0x805154,%eax
  803180:	40                   	inc    %eax
  803181:	a3 54 51 80 00       	mov    %eax,0x805154
  803186:	e9 37 05 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8b 50 08             	mov    0x8(%eax),%edx
  803191:	a1 38 51 80 00       	mov    0x805138,%eax
  803196:	8b 40 08             	mov    0x8(%eax),%eax
  803199:	39 c2                	cmp    %eax,%edx
  80319b:	0f 83 82 00 00 00    	jae    803223 <insert_sorted_with_merge_freeList+0x36e>
  8031a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 48 08             	mov    0x8(%eax),%ecx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b5:	01 c8                	add    %ecx,%eax
  8031b7:	39 c2                	cmp    %eax,%edx
  8031b9:	74 68                	je     803223 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8031bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bf:	75 17                	jne    8031d8 <insert_sorted_with_merge_freeList+0x323>
  8031c1:	83 ec 04             	sub    $0x4,%esp
  8031c4:	68 10 42 80 00       	push   $0x804210
  8031c9:	68 62 01 00 00       	push   $0x162
  8031ce:	68 33 42 80 00       	push   $0x804233
  8031d3:	e8 1b d7 ff ff       	call   8008f3 <_panic>
  8031d8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	89 10                	mov    %edx,(%eax)
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	85 c0                	test   %eax,%eax
  8031ea:	74 0d                	je     8031f9 <insert_sorted_with_merge_freeList+0x344>
  8031ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f4:	89 50 04             	mov    %edx,0x4(%eax)
  8031f7:	eb 08                	jmp    803201 <insert_sorted_with_merge_freeList+0x34c>
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	a3 38 51 80 00       	mov    %eax,0x805138
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803213:	a1 44 51 80 00       	mov    0x805144,%eax
  803218:	40                   	inc    %eax
  803219:	a3 44 51 80 00       	mov    %eax,0x805144
  80321e:	e9 9f 04 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803223:	a1 38 51 80 00       	mov    0x805138,%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80322d:	e9 84 04 00 00       	jmp    8036b6 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 50 08             	mov    0x8(%eax),%edx
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	8b 40 08             	mov    0x8(%eax),%eax
  80323e:	39 c2                	cmp    %eax,%edx
  803240:	0f 86 a9 00 00 00    	jbe    8032ef <insert_sorted_with_merge_freeList+0x43a>
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 50 08             	mov    0x8(%eax),%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	8b 48 08             	mov    0x8(%eax),%ecx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	8b 40 0c             	mov    0xc(%eax),%eax
  803258:	01 c8                	add    %ecx,%eax
  80325a:	39 c2                	cmp    %eax,%edx
  80325c:	0f 84 8d 00 00 00    	je     8032ef <insert_sorted_with_merge_freeList+0x43a>
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	8b 50 08             	mov    0x8(%eax),%edx
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	8b 48 08             	mov    0x8(%eax),%ecx
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	8b 40 04             	mov    0x4(%eax),%eax
  803277:	8b 40 0c             	mov    0xc(%eax),%eax
  80327a:	01 c8                	add    %ecx,%eax
  80327c:	39 c2                	cmp    %eax,%edx
  80327e:	74 6f                	je     8032ef <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803284:	74 06                	je     80328c <insert_sorted_with_merge_freeList+0x3d7>
  803286:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328a:	75 17                	jne    8032a3 <insert_sorted_with_merge_freeList+0x3ee>
  80328c:	83 ec 04             	sub    $0x4,%esp
  80328f:	68 70 42 80 00       	push   $0x804270
  803294:	68 6b 01 00 00       	push   $0x16b
  803299:	68 33 42 80 00       	push   $0x804233
  80329e:	e8 50 d6 ff ff       	call   8008f3 <_panic>
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 50 04             	mov    0x4(%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	89 50 04             	mov    %edx,0x4(%eax)
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 40 04             	mov    0x4(%eax),%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	74 0d                	je     8032ce <insert_sorted_with_merge_freeList+0x419>
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	8b 40 04             	mov    0x4(%eax),%eax
  8032c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ca:	89 10                	mov    %edx,(%eax)
  8032cc:	eb 08                	jmp    8032d6 <insert_sorted_with_merge_freeList+0x421>
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dc:	89 50 04             	mov    %edx,0x4(%eax)
  8032df:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e4:	40                   	inc    %eax
  8032e5:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8032ea:	e9 d3 03 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 50 08             	mov    0x8(%eax),%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	8b 40 08             	mov    0x8(%eax),%eax
  8032fb:	39 c2                	cmp    %eax,%edx
  8032fd:	0f 86 da 00 00 00    	jbe    8033dd <insert_sorted_with_merge_freeList+0x528>
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 50 08             	mov    0x8(%eax),%edx
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 48 08             	mov    0x8(%eax),%ecx
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	8b 40 0c             	mov    0xc(%eax),%eax
  803315:	01 c8                	add    %ecx,%eax
  803317:	39 c2                	cmp    %eax,%edx
  803319:	0f 85 be 00 00 00    	jne    8033dd <insert_sorted_with_merge_freeList+0x528>
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 50 08             	mov    0x8(%eax),%edx
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 40 04             	mov    0x4(%eax),%eax
  80332b:	8b 48 08             	mov    0x8(%eax),%ecx
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	8b 40 0c             	mov    0xc(%eax),%eax
  803337:	01 c8                	add    %ecx,%eax
  803339:	39 c2                	cmp    %eax,%edx
  80333b:	0f 84 9c 00 00 00    	je     8033dd <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 50 08             	mov    0x8(%eax),%edx
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 50 0c             	mov    0xc(%eax),%edx
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	8b 40 0c             	mov    0xc(%eax),%eax
  803359:	01 c2                	add    %eax,%edx
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803379:	75 17                	jne    803392 <insert_sorted_with_merge_freeList+0x4dd>
  80337b:	83 ec 04             	sub    $0x4,%esp
  80337e:	68 10 42 80 00       	push   $0x804210
  803383:	68 74 01 00 00       	push   $0x174
  803388:	68 33 42 80 00       	push   $0x804233
  80338d:	e8 61 d5 ff ff       	call   8008f3 <_panic>
  803392:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	89 10                	mov    %edx,(%eax)
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	8b 00                	mov    (%eax),%eax
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	74 0d                	je     8033b3 <insert_sorted_with_merge_freeList+0x4fe>
  8033a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ae:	89 50 04             	mov    %edx,0x4(%eax)
  8033b1:	eb 08                	jmp    8033bb <insert_sorted_with_merge_freeList+0x506>
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	a3 48 51 80 00       	mov    %eax,0x805148
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8033d2:	40                   	inc    %eax
  8033d3:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8033d8:	e9 e5 02 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 50 08             	mov    0x8(%eax),%edx
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 40 08             	mov    0x8(%eax),%eax
  8033e9:	39 c2                	cmp    %eax,%edx
  8033eb:	0f 86 d7 00 00 00    	jbe    8034c8 <insert_sorted_with_merge_freeList+0x613>
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 50 08             	mov    0x8(%eax),%edx
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	8b 40 0c             	mov    0xc(%eax),%eax
  803403:	01 c8                	add    %ecx,%eax
  803405:	39 c2                	cmp    %eax,%edx
  803407:	0f 84 bb 00 00 00    	je     8034c8 <insert_sorted_with_merge_freeList+0x613>
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 50 08             	mov    0x8(%eax),%edx
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	8b 48 08             	mov    0x8(%eax),%ecx
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 40 04             	mov    0x4(%eax),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	01 c8                	add    %ecx,%eax
  803427:	39 c2                	cmp    %eax,%edx
  803429:	0f 85 99 00 00 00    	jne    8034c8 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343b:	8b 50 0c             	mov    0xc(%eax),%edx
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	8b 40 0c             	mov    0xc(%eax),%eax
  803444:	01 c2                	add    %eax,%edx
  803446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803449:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803460:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803464:	75 17                	jne    80347d <insert_sorted_with_merge_freeList+0x5c8>
  803466:	83 ec 04             	sub    $0x4,%esp
  803469:	68 10 42 80 00       	push   $0x804210
  80346e:	68 7d 01 00 00       	push   $0x17d
  803473:	68 33 42 80 00       	push   $0x804233
  803478:	e8 76 d4 ff ff       	call   8008f3 <_panic>
  80347d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	89 10                	mov    %edx,(%eax)
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	85 c0                	test   %eax,%eax
  80348f:	74 0d                	je     80349e <insert_sorted_with_merge_freeList+0x5e9>
  803491:	a1 48 51 80 00       	mov    0x805148,%eax
  803496:	8b 55 08             	mov    0x8(%ebp),%edx
  803499:	89 50 04             	mov    %edx,0x4(%eax)
  80349c:	eb 08                	jmp    8034a6 <insert_sorted_with_merge_freeList+0x5f1>
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8034bd:	40                   	inc    %eax
  8034be:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8034c3:	e9 fa 01 00 00       	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	8b 50 08             	mov    0x8(%eax),%edx
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	8b 40 08             	mov    0x8(%eax),%eax
  8034d4:	39 c2                	cmp    %eax,%edx
  8034d6:	0f 86 d2 01 00 00    	jbe    8036ae <insert_sorted_with_merge_freeList+0x7f9>
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	8b 50 08             	mov    0x8(%eax),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 48 08             	mov    0x8(%eax),%ecx
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ee:	01 c8                	add    %ecx,%eax
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	0f 85 b6 01 00 00    	jne    8036ae <insert_sorted_with_merge_freeList+0x7f9>
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 50 08             	mov    0x8(%eax),%edx
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 40 04             	mov    0x4(%eax),%eax
  803504:	8b 48 08             	mov    0x8(%eax),%ecx
  803507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350a:	8b 40 04             	mov    0x4(%eax),%eax
  80350d:	8b 40 0c             	mov    0xc(%eax),%eax
  803510:	01 c8                	add    %ecx,%eax
  803512:	39 c2                	cmp    %eax,%edx
  803514:	0f 85 94 01 00 00    	jne    8036ae <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 40 04             	mov    0x4(%eax),%eax
  803520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803523:	8b 52 04             	mov    0x4(%edx),%edx
  803526:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803529:	8b 55 08             	mov    0x8(%ebp),%edx
  80352c:	8b 5a 0c             	mov    0xc(%edx),%ebx
  80352f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803532:	8b 52 0c             	mov    0xc(%edx),%edx
  803535:	01 da                	add    %ebx,%edx
  803537:	01 ca                	add    %ecx,%edx
  803539:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  80353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803554:	75 17                	jne    80356d <insert_sorted_with_merge_freeList+0x6b8>
  803556:	83 ec 04             	sub    $0x4,%esp
  803559:	68 a5 42 80 00       	push   $0x8042a5
  80355e:	68 86 01 00 00       	push   $0x186
  803563:	68 33 42 80 00       	push   $0x804233
  803568:	e8 86 d3 ff ff       	call   8008f3 <_panic>
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	85 c0                	test   %eax,%eax
  803574:	74 10                	je     803586 <insert_sorted_with_merge_freeList+0x6d1>
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	8b 00                	mov    (%eax),%eax
  80357b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357e:	8b 52 04             	mov    0x4(%edx),%edx
  803581:	89 50 04             	mov    %edx,0x4(%eax)
  803584:	eb 0b                	jmp    803591 <insert_sorted_with_merge_freeList+0x6dc>
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 40 04             	mov    0x4(%eax),%eax
  80358c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	8b 40 04             	mov    0x4(%eax),%eax
  803597:	85 c0                	test   %eax,%eax
  803599:	74 0f                	je     8035aa <insert_sorted_with_merge_freeList+0x6f5>
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a4:	8b 12                	mov    (%edx),%edx
  8035a6:	89 10                	mov    %edx,(%eax)
  8035a8:	eb 0a                	jmp    8035b4 <insert_sorted_with_merge_freeList+0x6ff>
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8035cc:	48                   	dec    %eax
  8035cd:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8035d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d6:	75 17                	jne    8035ef <insert_sorted_with_merge_freeList+0x73a>
  8035d8:	83 ec 04             	sub    $0x4,%esp
  8035db:	68 10 42 80 00       	push   $0x804210
  8035e0:	68 87 01 00 00       	push   $0x187
  8035e5:	68 33 42 80 00       	push   $0x804233
  8035ea:	e8 04 d3 ff ff       	call   8008f3 <_panic>
  8035ef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f8:	89 10                	mov    %edx,(%eax)
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	85 c0                	test   %eax,%eax
  803601:	74 0d                	je     803610 <insert_sorted_with_merge_freeList+0x75b>
  803603:	a1 48 51 80 00       	mov    0x805148,%eax
  803608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80360b:	89 50 04             	mov    %edx,0x4(%eax)
  80360e:	eb 08                	jmp    803618 <insert_sorted_with_merge_freeList+0x763>
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361b:	a3 48 51 80 00       	mov    %eax,0x805148
  803620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803623:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362a:	a1 54 51 80 00       	mov    0x805154,%eax
  80362f:	40                   	inc    %eax
  803630:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803649:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364d:	75 17                	jne    803666 <insert_sorted_with_merge_freeList+0x7b1>
  80364f:	83 ec 04             	sub    $0x4,%esp
  803652:	68 10 42 80 00       	push   $0x804210
  803657:	68 8a 01 00 00       	push   $0x18a
  80365c:	68 33 42 80 00       	push   $0x804233
  803661:	e8 8d d2 ff ff       	call   8008f3 <_panic>
  803666:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	89 10                	mov    %edx,(%eax)
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	85 c0                	test   %eax,%eax
  803678:	74 0d                	je     803687 <insert_sorted_with_merge_freeList+0x7d2>
  80367a:	a1 48 51 80 00       	mov    0x805148,%eax
  80367f:	8b 55 08             	mov    0x8(%ebp),%edx
  803682:	89 50 04             	mov    %edx,0x4(%eax)
  803685:	eb 08                	jmp    80368f <insert_sorted_with_merge_freeList+0x7da>
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	a3 48 51 80 00       	mov    %eax,0x805148
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a6:	40                   	inc    %eax
  8036a7:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8036ac:	eb 14                	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8036b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ba:	0f 85 72 fb ff ff    	jne    803232 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8036c0:	eb 00                	jmp    8036c2 <insert_sorted_with_merge_freeList+0x80d>
  8036c2:	90                   	nop
  8036c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036c6:	c9                   	leave  
  8036c7:	c3                   	ret    

008036c8 <__udivdi3>:
  8036c8:	55                   	push   %ebp
  8036c9:	57                   	push   %edi
  8036ca:	56                   	push   %esi
  8036cb:	53                   	push   %ebx
  8036cc:	83 ec 1c             	sub    $0x1c,%esp
  8036cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036df:	89 ca                	mov    %ecx,%edx
  8036e1:	89 f8                	mov    %edi,%eax
  8036e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036e7:	85 f6                	test   %esi,%esi
  8036e9:	75 2d                	jne    803718 <__udivdi3+0x50>
  8036eb:	39 cf                	cmp    %ecx,%edi
  8036ed:	77 65                	ja     803754 <__udivdi3+0x8c>
  8036ef:	89 fd                	mov    %edi,%ebp
  8036f1:	85 ff                	test   %edi,%edi
  8036f3:	75 0b                	jne    803700 <__udivdi3+0x38>
  8036f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036fa:	31 d2                	xor    %edx,%edx
  8036fc:	f7 f7                	div    %edi
  8036fe:	89 c5                	mov    %eax,%ebp
  803700:	31 d2                	xor    %edx,%edx
  803702:	89 c8                	mov    %ecx,%eax
  803704:	f7 f5                	div    %ebp
  803706:	89 c1                	mov    %eax,%ecx
  803708:	89 d8                	mov    %ebx,%eax
  80370a:	f7 f5                	div    %ebp
  80370c:	89 cf                	mov    %ecx,%edi
  80370e:	89 fa                	mov    %edi,%edx
  803710:	83 c4 1c             	add    $0x1c,%esp
  803713:	5b                   	pop    %ebx
  803714:	5e                   	pop    %esi
  803715:	5f                   	pop    %edi
  803716:	5d                   	pop    %ebp
  803717:	c3                   	ret    
  803718:	39 ce                	cmp    %ecx,%esi
  80371a:	77 28                	ja     803744 <__udivdi3+0x7c>
  80371c:	0f bd fe             	bsr    %esi,%edi
  80371f:	83 f7 1f             	xor    $0x1f,%edi
  803722:	75 40                	jne    803764 <__udivdi3+0x9c>
  803724:	39 ce                	cmp    %ecx,%esi
  803726:	72 0a                	jb     803732 <__udivdi3+0x6a>
  803728:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80372c:	0f 87 9e 00 00 00    	ja     8037d0 <__udivdi3+0x108>
  803732:	b8 01 00 00 00       	mov    $0x1,%eax
  803737:	89 fa                	mov    %edi,%edx
  803739:	83 c4 1c             	add    $0x1c,%esp
  80373c:	5b                   	pop    %ebx
  80373d:	5e                   	pop    %esi
  80373e:	5f                   	pop    %edi
  80373f:	5d                   	pop    %ebp
  803740:	c3                   	ret    
  803741:	8d 76 00             	lea    0x0(%esi),%esi
  803744:	31 ff                	xor    %edi,%edi
  803746:	31 c0                	xor    %eax,%eax
  803748:	89 fa                	mov    %edi,%edx
  80374a:	83 c4 1c             	add    $0x1c,%esp
  80374d:	5b                   	pop    %ebx
  80374e:	5e                   	pop    %esi
  80374f:	5f                   	pop    %edi
  803750:	5d                   	pop    %ebp
  803751:	c3                   	ret    
  803752:	66 90                	xchg   %ax,%ax
  803754:	89 d8                	mov    %ebx,%eax
  803756:	f7 f7                	div    %edi
  803758:	31 ff                	xor    %edi,%edi
  80375a:	89 fa                	mov    %edi,%edx
  80375c:	83 c4 1c             	add    $0x1c,%esp
  80375f:	5b                   	pop    %ebx
  803760:	5e                   	pop    %esi
  803761:	5f                   	pop    %edi
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    
  803764:	bd 20 00 00 00       	mov    $0x20,%ebp
  803769:	89 eb                	mov    %ebp,%ebx
  80376b:	29 fb                	sub    %edi,%ebx
  80376d:	89 f9                	mov    %edi,%ecx
  80376f:	d3 e6                	shl    %cl,%esi
  803771:	89 c5                	mov    %eax,%ebp
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 ed                	shr    %cl,%ebp
  803777:	89 e9                	mov    %ebp,%ecx
  803779:	09 f1                	or     %esi,%ecx
  80377b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80377f:	89 f9                	mov    %edi,%ecx
  803781:	d3 e0                	shl    %cl,%eax
  803783:	89 c5                	mov    %eax,%ebp
  803785:	89 d6                	mov    %edx,%esi
  803787:	88 d9                	mov    %bl,%cl
  803789:	d3 ee                	shr    %cl,%esi
  80378b:	89 f9                	mov    %edi,%ecx
  80378d:	d3 e2                	shl    %cl,%edx
  80378f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803793:	88 d9                	mov    %bl,%cl
  803795:	d3 e8                	shr    %cl,%eax
  803797:	09 c2                	or     %eax,%edx
  803799:	89 d0                	mov    %edx,%eax
  80379b:	89 f2                	mov    %esi,%edx
  80379d:	f7 74 24 0c          	divl   0xc(%esp)
  8037a1:	89 d6                	mov    %edx,%esi
  8037a3:	89 c3                	mov    %eax,%ebx
  8037a5:	f7 e5                	mul    %ebp
  8037a7:	39 d6                	cmp    %edx,%esi
  8037a9:	72 19                	jb     8037c4 <__udivdi3+0xfc>
  8037ab:	74 0b                	je     8037b8 <__udivdi3+0xf0>
  8037ad:	89 d8                	mov    %ebx,%eax
  8037af:	31 ff                	xor    %edi,%edi
  8037b1:	e9 58 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037bc:	89 f9                	mov    %edi,%ecx
  8037be:	d3 e2                	shl    %cl,%edx
  8037c0:	39 c2                	cmp    %eax,%edx
  8037c2:	73 e9                	jae    8037ad <__udivdi3+0xe5>
  8037c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037c7:	31 ff                	xor    %edi,%edi
  8037c9:	e9 40 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037ce:	66 90                	xchg   %ax,%ax
  8037d0:	31 c0                	xor    %eax,%eax
  8037d2:	e9 37 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037d7:	90                   	nop

008037d8 <__umoddi3>:
  8037d8:	55                   	push   %ebp
  8037d9:	57                   	push   %edi
  8037da:	56                   	push   %esi
  8037db:	53                   	push   %ebx
  8037dc:	83 ec 1c             	sub    $0x1c,%esp
  8037df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037f7:	89 f3                	mov    %esi,%ebx
  8037f9:	89 fa                	mov    %edi,%edx
  8037fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ff:	89 34 24             	mov    %esi,(%esp)
  803802:	85 c0                	test   %eax,%eax
  803804:	75 1a                	jne    803820 <__umoddi3+0x48>
  803806:	39 f7                	cmp    %esi,%edi
  803808:	0f 86 a2 00 00 00    	jbe    8038b0 <__umoddi3+0xd8>
  80380e:	89 c8                	mov    %ecx,%eax
  803810:	89 f2                	mov    %esi,%edx
  803812:	f7 f7                	div    %edi
  803814:	89 d0                	mov    %edx,%eax
  803816:	31 d2                	xor    %edx,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	39 f0                	cmp    %esi,%eax
  803822:	0f 87 ac 00 00 00    	ja     8038d4 <__umoddi3+0xfc>
  803828:	0f bd e8             	bsr    %eax,%ebp
  80382b:	83 f5 1f             	xor    $0x1f,%ebp
  80382e:	0f 84 ac 00 00 00    	je     8038e0 <__umoddi3+0x108>
  803834:	bf 20 00 00 00       	mov    $0x20,%edi
  803839:	29 ef                	sub    %ebp,%edi
  80383b:	89 fe                	mov    %edi,%esi
  80383d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803841:	89 e9                	mov    %ebp,%ecx
  803843:	d3 e0                	shl    %cl,%eax
  803845:	89 d7                	mov    %edx,%edi
  803847:	89 f1                	mov    %esi,%ecx
  803849:	d3 ef                	shr    %cl,%edi
  80384b:	09 c7                	or     %eax,%edi
  80384d:	89 e9                	mov    %ebp,%ecx
  80384f:	d3 e2                	shl    %cl,%edx
  803851:	89 14 24             	mov    %edx,(%esp)
  803854:	89 d8                	mov    %ebx,%eax
  803856:	d3 e0                	shl    %cl,%eax
  803858:	89 c2                	mov    %eax,%edx
  80385a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80385e:	d3 e0                	shl    %cl,%eax
  803860:	89 44 24 04          	mov    %eax,0x4(%esp)
  803864:	8b 44 24 08          	mov    0x8(%esp),%eax
  803868:	89 f1                	mov    %esi,%ecx
  80386a:	d3 e8                	shr    %cl,%eax
  80386c:	09 d0                	or     %edx,%eax
  80386e:	d3 eb                	shr    %cl,%ebx
  803870:	89 da                	mov    %ebx,%edx
  803872:	f7 f7                	div    %edi
  803874:	89 d3                	mov    %edx,%ebx
  803876:	f7 24 24             	mull   (%esp)
  803879:	89 c6                	mov    %eax,%esi
  80387b:	89 d1                	mov    %edx,%ecx
  80387d:	39 d3                	cmp    %edx,%ebx
  80387f:	0f 82 87 00 00 00    	jb     80390c <__umoddi3+0x134>
  803885:	0f 84 91 00 00 00    	je     80391c <__umoddi3+0x144>
  80388b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80388f:	29 f2                	sub    %esi,%edx
  803891:	19 cb                	sbb    %ecx,%ebx
  803893:	89 d8                	mov    %ebx,%eax
  803895:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803899:	d3 e0                	shl    %cl,%eax
  80389b:	89 e9                	mov    %ebp,%ecx
  80389d:	d3 ea                	shr    %cl,%edx
  80389f:	09 d0                	or     %edx,%eax
  8038a1:	89 e9                	mov    %ebp,%ecx
  8038a3:	d3 eb                	shr    %cl,%ebx
  8038a5:	89 da                	mov    %ebx,%edx
  8038a7:	83 c4 1c             	add    $0x1c,%esp
  8038aa:	5b                   	pop    %ebx
  8038ab:	5e                   	pop    %esi
  8038ac:	5f                   	pop    %edi
  8038ad:	5d                   	pop    %ebp
  8038ae:	c3                   	ret    
  8038af:	90                   	nop
  8038b0:	89 fd                	mov    %edi,%ebp
  8038b2:	85 ff                	test   %edi,%edi
  8038b4:	75 0b                	jne    8038c1 <__umoddi3+0xe9>
  8038b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038bb:	31 d2                	xor    %edx,%edx
  8038bd:	f7 f7                	div    %edi
  8038bf:	89 c5                	mov    %eax,%ebp
  8038c1:	89 f0                	mov    %esi,%eax
  8038c3:	31 d2                	xor    %edx,%edx
  8038c5:	f7 f5                	div    %ebp
  8038c7:	89 c8                	mov    %ecx,%eax
  8038c9:	f7 f5                	div    %ebp
  8038cb:	89 d0                	mov    %edx,%eax
  8038cd:	e9 44 ff ff ff       	jmp    803816 <__umoddi3+0x3e>
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	89 c8                	mov    %ecx,%eax
  8038d6:	89 f2                	mov    %esi,%edx
  8038d8:	83 c4 1c             	add    $0x1c,%esp
  8038db:	5b                   	pop    %ebx
  8038dc:	5e                   	pop    %esi
  8038dd:	5f                   	pop    %edi
  8038de:	5d                   	pop    %ebp
  8038df:	c3                   	ret    
  8038e0:	3b 04 24             	cmp    (%esp),%eax
  8038e3:	72 06                	jb     8038eb <__umoddi3+0x113>
  8038e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038e9:	77 0f                	ja     8038fa <__umoddi3+0x122>
  8038eb:	89 f2                	mov    %esi,%edx
  8038ed:	29 f9                	sub    %edi,%ecx
  8038ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038f3:	89 14 24             	mov    %edx,(%esp)
  8038f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038fe:	8b 14 24             	mov    (%esp),%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d 76 00             	lea    0x0(%esi),%esi
  80390c:	2b 04 24             	sub    (%esp),%eax
  80390f:	19 fa                	sbb    %edi,%edx
  803911:	89 d1                	mov    %edx,%ecx
  803913:	89 c6                	mov    %eax,%esi
  803915:	e9 71 ff ff ff       	jmp    80388b <__umoddi3+0xb3>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803920:	72 ea                	jb     80390c <__umoddi3+0x134>
  803922:	89 d9                	mov    %ebx,%ecx
  803924:	e9 62 ff ff ff       	jmp    80388b <__umoddi3+0xb3>
