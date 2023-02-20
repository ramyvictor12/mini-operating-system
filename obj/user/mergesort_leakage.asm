
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 ec 21 00 00       	call   802232 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3b 80 00       	push   $0x803b20
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3b 80 00       	push   $0x803b22
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3b 80 00       	push   $0x803b38
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3b 80 00       	push   $0x803b22
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3b 80 00       	push   $0x803b20
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 3b 80 00       	push   $0x803b50
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 0c 1c 00 00       	call   801ce1 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 70 3b 80 00       	push   $0x803b70
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 92 3b 80 00       	push   $0x803b92
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a0 3b 80 00       	push   $0x803ba0
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 af 3b 80 00       	push   $0x803baf
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 bf 3b 80 00       	push   $0x803bbf
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 e5 20 00 00       	call   80224c <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 56 20 00 00       	call   802232 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c8 3b 80 00       	push   $0x803bc8
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 5b 20 00 00       	call   80224c <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 fc 3b 80 00       	push   $0x803bfc
  800213:	6a 4a                	push   $0x4a
  800215:	68 1e 3c 80 00       	push   $0x803c1e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 0e 20 00 00       	call   802232 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 38 3c 80 00       	push   $0x803c38
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 6c 3c 80 00       	push   $0x803c6c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 a0 3c 80 00       	push   $0x803ca0
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 f3 1f 00 00       	call   80224c <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 d4 1f 00 00       	call   802232 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 d2 3c 80 00       	push   $0x803cd2
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 95 1f 00 00       	call   80224c <sys_enable_interrupt>

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
  800446:	68 20 3b 80 00       	push   $0x803b20
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 f0 3c 80 00       	push   $0x803cf0
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
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
  800496:	68 f5 3c 80 00       	push   $0x803cf5
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
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
  80053c:	e8 a0 17 00 00       	call   801ce1 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 8b 17 00 00       	call   801ce1 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

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

	//	int Left[5000] ;
	//	int Right[5000] ;

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

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 52 1b 00 00       	call   802266 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 0d 1b 00 00       	call   802232 <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 2e 1b 00 00       	call   802266 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 0c 1b 00 00       	call   80224c <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 56 19 00 00       	call   8020ad <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 c2 1a 00 00       	call   802232 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 2f 19 00 00       	call   8020ad <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 c0 1a 00 00       	call   80224c <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 7f 1c 00 00       	call   802425 <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 21 1a 00 00       	call   802232 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 14 3d 80 00       	push   $0x803d14
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 3c 3d 80 00       	push   $0x803d3c
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 64 3d 80 00       	push   $0x803d64
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 bc 3d 80 00       	push   $0x803dbc
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 14 3d 80 00       	push   $0x803d14
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 a1 19 00 00       	call   80224c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 2e 1b 00 00       	call   8023f1 <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 83 1b 00 00       	call   802457 <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 d0 3d 80 00       	push   $0x803dd0
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 d5 3d 80 00       	push   $0x803dd5
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 f1 3d 80 00       	push   $0x803df1
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 f4 3d 80 00       	push   $0x803df4
  800966:	6a 26                	push   $0x26
  800968:	68 40 3e 80 00       	push   $0x803e40
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 4c 3e 80 00       	push   $0x803e4c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 40 3e 80 00       	push   $0x803e40
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 a0 3e 80 00       	push   $0x803ea0
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 40 3e 80 00       	push   $0x803e40
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 82 15 00 00       	call   802084 <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 0b 15 00 00       	call   802084 <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 6f 16 00 00       	call   802232 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 69 16 00 00       	call   80224c <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 87 2c 00 00       	call   8038b4 <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 47 2d 00 00       	call   8039c4 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 14 41 80 00       	add    $0x804114,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 25 41 80 00       	push   $0x804125
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 2e 41 80 00       	push   $0x80412e
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be 31 41 80 00       	mov    $0x804131,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 90 42 80 00       	push   $0x804290
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 93 42 80 00       	push   $0x804293
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 1c 0f 00 00       	call   802232 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 90 42 80 00       	push   $0x804290
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 93 42 80 00       	push   $0x804293
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 da 0e 00 00       	call   80224c <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 42 0e 00 00       	call   80224c <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 a4 42 80 00       	push   $0x8042a4
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801b52:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b59:	00 00 00 
  801b5c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b63:	00 00 00 
  801b66:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b6d:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801b70:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b77:	00 00 00 
  801b7a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b81:	00 00 00 
  801b84:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b8b:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801b8e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b95:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801b98:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801b9f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bae:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb3:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801bb8:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	6a 06                	push   $0x6
  801bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd4:	50                   	push   %eax
  801bd5:	e8 ee 05 00 00       	call   8021c8 <sys_allocate_chunk>
  801bda:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bdd:	a1 20 51 80 00       	mov    0x805120,%eax
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	50                   	push   %eax
  801be6:	e8 63 0c 00 00       	call   80284e <initialize_MemBlocksList>
  801beb:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801bee:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801bf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c03:	8b 40 0c             	mov    0xc(%eax),%eax
  801c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c11:	89 c2                	mov    %eax,%edx
  801c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c16:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c1c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801c23:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c2d:	8b 50 08             	mov    0x8(%eax),%edx
  801c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c33:	01 d0                	add    %edx,%eax
  801c35:	48                   	dec    %eax
  801c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c41:	f7 75 e0             	divl   -0x20(%ebp)
  801c44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c47:	29 d0                	sub    %edx,%eax
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c4e:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801c51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c55:	75 14                	jne    801c6b <initialize_dyn_block_system+0x11f>
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 c9 42 80 00       	push   $0x8042c9
  801c5f:	6a 34                	push   $0x34
  801c61:	68 e7 42 80 00       	push   $0x8042e7
  801c66:	e8 6c ec ff ff       	call   8008d7 <_panic>
  801c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c6e:	8b 00                	mov    (%eax),%eax
  801c70:	85 c0                	test   %eax,%eax
  801c72:	74 10                	je     801c84 <initialize_dyn_block_system+0x138>
  801c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c77:	8b 00                	mov    (%eax),%eax
  801c79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c7c:	8b 52 04             	mov    0x4(%edx),%edx
  801c7f:	89 50 04             	mov    %edx,0x4(%eax)
  801c82:	eb 0b                	jmp    801c8f <initialize_dyn_block_system+0x143>
  801c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c87:	8b 40 04             	mov    0x4(%eax),%eax
  801c8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c92:	8b 40 04             	mov    0x4(%eax),%eax
  801c95:	85 c0                	test   %eax,%eax
  801c97:	74 0f                	je     801ca8 <initialize_dyn_block_system+0x15c>
  801c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c9c:	8b 40 04             	mov    0x4(%eax),%eax
  801c9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca2:	8b 12                	mov    (%edx),%edx
  801ca4:	89 10                	mov    %edx,(%eax)
  801ca6:	eb 0a                	jmp    801cb2 <initialize_dyn_block_system+0x166>
  801ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cab:	8b 00                	mov    (%eax),%eax
  801cad:	a3 48 51 80 00       	mov    %eax,0x805148
  801cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cc5:	a1 54 51 80 00       	mov    0x805154,%eax
  801cca:	48                   	dec    %eax
  801ccb:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801cd0:	83 ec 0c             	sub    $0xc,%esp
  801cd3:	ff 75 e8             	pushl  -0x18(%ebp)
  801cd6:	e8 c4 13 00 00       	call   80309f <insert_sorted_with_merge_freeList>
  801cdb:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801cde:	90                   	nop
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce7:	e8 2f fe ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801cec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cf0:	75 07                	jne    801cf9 <malloc+0x18>
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf7:	eb 71                	jmp    801d6a <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801cf9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d00:	76 07                	jbe    801d09 <malloc+0x28>
	return NULL;
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	eb 61                	jmp    801d6a <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d09:	e8 88 08 00 00       	call   802596 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	74 53                	je     801d65 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801d12:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d19:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1f:	01 d0                	add    %edx,%eax
  801d21:	48                   	dec    %eax
  801d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d28:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2d:	f7 75 f4             	divl   -0xc(%ebp)
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	29 d0                	sub    %edx,%eax
  801d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 ec             	pushl  -0x14(%ebp)
  801d3e:	e8 d2 0d 00 00       	call   802b15 <alloc_block_FF>
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801d49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d4d:	74 16                	je     801d65 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	ff 75 e8             	pushl  -0x18(%ebp)
  801d55:	e8 0c 0c 00 00       	call   802966 <insert_sorted_allocList>
  801d5a:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d60:	8b 40 08             	mov    0x8(%eax),%eax
  801d63:	eb 05                	jmp    801d6a <malloc+0x89>
    }

			}


	return NULL;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801d83:	83 ec 08             	sub    $0x8,%esp
  801d86:	ff 75 f0             	pushl  -0x10(%ebp)
  801d89:	68 40 50 80 00       	push   $0x805040
  801d8e:	e8 a0 0b 00 00       	call   802933 <find_block>
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9c:	8b 50 0c             	mov    0xc(%eax),%edx
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	e8 e4 03 00 00       	call   802190 <sys_free_user_mem>
  801dac:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801daf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801db3:	75 17                	jne    801dcc <free+0x60>
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	68 c9 42 80 00       	push   $0x8042c9
  801dbd:	68 84 00 00 00       	push   $0x84
  801dc2:	68 e7 42 80 00       	push   $0x8042e7
  801dc7:	e8 0b eb ff ff       	call   8008d7 <_panic>
  801dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcf:	8b 00                	mov    (%eax),%eax
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	74 10                	je     801de5 <free+0x79>
  801dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd8:	8b 00                	mov    (%eax),%eax
  801dda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ddd:	8b 52 04             	mov    0x4(%edx),%edx
  801de0:	89 50 04             	mov    %edx,0x4(%eax)
  801de3:	eb 0b                	jmp    801df0 <free+0x84>
  801de5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de8:	8b 40 04             	mov    0x4(%eax),%eax
  801deb:	a3 44 50 80 00       	mov    %eax,0x805044
  801df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df3:	8b 40 04             	mov    0x4(%eax),%eax
  801df6:	85 c0                	test   %eax,%eax
  801df8:	74 0f                	je     801e09 <free+0x9d>
  801dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dfd:	8b 40 04             	mov    0x4(%eax),%eax
  801e00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e03:	8b 12                	mov    (%edx),%edx
  801e05:	89 10                	mov    %edx,(%eax)
  801e07:	eb 0a                	jmp    801e13 <free+0xa7>
  801e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0c:	8b 00                	mov    (%eax),%eax
  801e0e:	a3 40 50 80 00       	mov    %eax,0x805040
  801e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e26:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e2b:	48                   	dec    %eax
  801e2c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	ff 75 ec             	pushl  -0x14(%ebp)
  801e37:	e8 63 12 00 00       	call   80309f <insert_sorted_with_merge_freeList>
  801e3c:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 38             	sub    $0x38,%esp
  801e48:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4e:	e8 c8 fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801e53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e57:	75 0a                	jne    801e63 <smalloc+0x21>
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	e9 a0 00 00 00       	jmp    801f03 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801e63:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801e6a:	76 0a                	jbe    801e76 <smalloc+0x34>
		return NULL;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e71:	e9 8d 00 00 00       	jmp    801f03 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e76:	e8 1b 07 00 00       	call   802596 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	74 7f                	je     801efe <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801e7f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	48                   	dec    %eax
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9a:	f7 75 f4             	divl   -0xc(%ebp)
  801e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea0:	29 d0                	sub    %edx,%eax
  801ea2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	ff 75 ec             	pushl  -0x14(%ebp)
  801eab:	e8 65 0c 00 00       	call   802b15 <alloc_block_FF>
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801eb6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801eba:	74 42                	je     801efe <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	ff 75 e8             	pushl  -0x18(%ebp)
  801ec2:	e8 9f 0a 00 00       	call   802966 <insert_sorted_allocList>
  801ec7:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ecd:	8b 40 08             	mov    0x8(%eax),%eax
  801ed0:	89 c2                	mov    %eax,%edx
  801ed2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	ff 75 0c             	pushl  0xc(%ebp)
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	e8 38 04 00 00       	call   80231b <sys_createSharedObject>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801ee9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eed:	79 07                	jns    801ef6 <smalloc+0xb4>
	    		  return NULL;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	eb 0d                	jmp    801f03 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef9:	8b 40 08             	mov    0x8(%eax),%eax
  801efc:	eb 05                	jmp    801f03 <smalloc+0xc1>


				}


		return NULL;
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f0b:	e8 0b fc ff ff       	call   801b1b <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f10:	e8 81 06 00 00       	call   802596 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f15:	85 c0                	test   %eax,%eax
  801f17:	0f 84 9f 00 00 00    	je     801fbc <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	ff 75 08             	pushl  0x8(%ebp)
  801f26:	e8 1a 04 00 00       	call   802345 <sys_getSizeOfSharedObject>
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f35:	79 0a                	jns    801f41 <sget+0x3c>
		return NULL;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	e9 80 00 00 00       	jmp    801fc1 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801f41:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4e:	01 d0                	add    %edx,%eax
  801f50:	48                   	dec    %eax
  801f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5c:	f7 75 f0             	divl   -0x10(%ebp)
  801f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f62:	29 d0                	sub    %edx,%eax
  801f64:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	ff 75 e8             	pushl  -0x18(%ebp)
  801f6d:	e8 a3 0b 00 00       	call   802b15 <alloc_block_FF>
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801f78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f7c:	74 3e                	je     801fbc <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f84:	e8 dd 09 00 00       	call   802966 <insert_sorted_allocList>
  801f89:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f8f:	8b 40 08             	mov    0x8(%eax),%eax
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	50                   	push   %eax
  801f96:	ff 75 0c             	pushl  0xc(%ebp)
  801f99:	ff 75 08             	pushl  0x8(%ebp)
  801f9c:	e8 c1 03 00 00       	call   802362 <sys_getSharedObject>
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801fa7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fab:	79 07                	jns    801fb4 <sget+0xaf>
	    		  return NULL;
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	eb 0d                	jmp    801fc1 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb7:	8b 40 08             	mov    0x8(%eax),%eax
  801fba:	eb 05                	jmp    801fc1 <sget+0xbc>
	      }
	}
	   return NULL;
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fc9:	e8 4d fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	68 f4 42 80 00       	push   $0x8042f4
  801fd6:	68 12 01 00 00       	push   $0x112
  801fdb:	68 e7 42 80 00       	push   $0x8042e7
  801fe0:	e8 f2 e8 ff ff       	call   8008d7 <_panic>

00801fe5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 1c 43 80 00       	push   $0x80431c
  801ff3:	68 26 01 00 00       	push   $0x126
  801ff8:	68 e7 42 80 00       	push   $0x8042e7
  801ffd:	e8 d5 e8 ff ff       	call   8008d7 <_panic>

00802002 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	68 40 43 80 00       	push   $0x804340
  802010:	68 31 01 00 00       	push   $0x131
  802015:	68 e7 42 80 00       	push   $0x8042e7
  80201a:	e8 b8 e8 ff ff       	call   8008d7 <_panic>

0080201f <shrink>:

}
void shrink(uint32 newSize)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	68 40 43 80 00       	push   $0x804340
  80202d:	68 36 01 00 00       	push   $0x136
  802032:	68 e7 42 80 00       	push   $0x8042e7
  802037:	e8 9b e8 ff ff       	call   8008d7 <_panic>

0080203c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	68 40 43 80 00       	push   $0x804340
  80204a:	68 3b 01 00 00       	push   $0x13b
  80204f:	68 e7 42 80 00       	push   $0x8042e7
  802054:	e8 7e e8 ff ff       	call   8008d7 <_panic>

00802059 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	57                   	push   %edi
  80205d:	56                   	push   %esi
  80205e:	53                   	push   %ebx
  80205f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	8b 55 0c             	mov    0xc(%ebp),%edx
  802068:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80206e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802071:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802074:	cd 30                	int    $0x30
  802076:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	8b 45 10             	mov    0x10(%ebp),%eax
  80208d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802090:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	52                   	push   %edx
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	50                   	push   %eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 b2 ff ff ff       	call   802059 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_cgetc>:

int
sys_cgetc(void)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 01                	push   $0x1
  8020bc:	e8 98 ff ff ff       	call   802059 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	52                   	push   %edx
  8020d6:	50                   	push   %eax
  8020d7:	6a 05                	push   $0x5
  8020d9:	e8 7b ff ff ff       	call   802059 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8020eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	51                   	push   %ecx
  8020fa:	52                   	push   %edx
  8020fb:	50                   	push   %eax
  8020fc:	6a 06                	push   $0x6
  8020fe:	e8 56 ff ff ff       	call   802059 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802109:	5b                   	pop    %ebx
  80210a:	5e                   	pop    %esi
  80210b:	5d                   	pop    %ebp
  80210c:	c3                   	ret    

0080210d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802110:	8b 55 0c             	mov    0xc(%ebp),%edx
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	52                   	push   %edx
  80211d:	50                   	push   %eax
  80211e:	6a 07                	push   $0x7
  802120:	e8 34 ff ff ff       	call   802059 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	6a 08                	push   $0x8
  80213b:	e8 19 ff ff ff       	call   802059 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 09                	push   $0x9
  802154:	e8 00 ff ff ff       	call   802059 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 0a                	push   $0xa
  80216d:	e8 e7 fe ff ff       	call   802059 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 0b                	push   $0xb
  802186:	e8 ce fe ff ff       	call   802059 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	ff 75 08             	pushl  0x8(%ebp)
  80219f:	6a 0f                	push   $0xf
  8021a1:	e8 b3 fe ff ff       	call   802059 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
	return;
  8021a9:	90                   	nop
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	ff 75 0c             	pushl  0xc(%ebp)
  8021b8:	ff 75 08             	pushl  0x8(%ebp)
  8021bb:	6a 10                	push   $0x10
  8021bd:	e8 97 fe ff ff       	call   802059 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c5:	90                   	nop
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	ff 75 10             	pushl  0x10(%ebp)
  8021d2:	ff 75 0c             	pushl  0xc(%ebp)
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	6a 11                	push   $0x11
  8021da:	e8 7a fe ff ff       	call   802059 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e2:	90                   	nop
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 0c                	push   $0xc
  8021f4:	e8 60 fe ff ff       	call   802059 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	ff 75 08             	pushl  0x8(%ebp)
  80220c:	6a 0d                	push   $0xd
  80220e:	e8 46 fe ff ff       	call   802059 <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 0e                	push   $0xe
  802227:	e8 2d fe ff ff       	call   802059 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 13                	push   $0x13
  802241:	e8 13 fe ff ff       	call   802059 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	90                   	nop
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 14                	push   $0x14
  80225b:	e8 f9 fd ff ff       	call   802059 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_cputc>:


void
sys_cputc(const char c)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 04             	sub    $0x4,%esp
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802272:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	50                   	push   %eax
  80227f:	6a 15                	push   $0x15
  802281:	e8 d3 fd ff ff       	call   802059 <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
}
  802289:	90                   	nop
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 16                	push   $0x16
  80229b:	e8 b9 fd ff ff       	call   802059 <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	90                   	nop
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	ff 75 0c             	pushl  0xc(%ebp)
  8022b5:	50                   	push   %eax
  8022b6:	6a 17                	push   $0x17
  8022b8:	e8 9c fd ff ff       	call   802059 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	52                   	push   %edx
  8022d2:	50                   	push   %eax
  8022d3:	6a 1a                	push   $0x1a
  8022d5:	e8 7f fd ff ff       	call   802059 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	52                   	push   %edx
  8022ef:	50                   	push   %eax
  8022f0:	6a 18                	push   $0x18
  8022f2:	e8 62 fd ff ff       	call   802059 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	52                   	push   %edx
  80230d:	50                   	push   %eax
  80230e:	6a 19                	push   $0x19
  802310:	e8 44 fd ff ff       	call   802059 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	90                   	nop
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	8b 45 10             	mov    0x10(%ebp),%eax
  802324:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802327:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80232a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	6a 00                	push   $0x0
  802333:	51                   	push   %ecx
  802334:	52                   	push   %edx
  802335:	ff 75 0c             	pushl  0xc(%ebp)
  802338:	50                   	push   %eax
  802339:	6a 1b                	push   $0x1b
  80233b:	e8 19 fd ff ff       	call   802059 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802348:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	52                   	push   %edx
  802355:	50                   	push   %eax
  802356:	6a 1c                	push   $0x1c
  802358:	e8 fc fc ff ff       	call   802059 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802365:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	51                   	push   %ecx
  802373:	52                   	push   %edx
  802374:	50                   	push   %eax
  802375:	6a 1d                	push   $0x1d
  802377:	e8 dd fc ff ff       	call   802059 <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802384:	8b 55 0c             	mov    0xc(%ebp),%edx
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	52                   	push   %edx
  802391:	50                   	push   %eax
  802392:	6a 1e                	push   $0x1e
  802394:	e8 c0 fc ff ff       	call   802059 <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 1f                	push   $0x1f
  8023ad:	e8 a7 fc ff ff       	call   802059 <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	6a 00                	push   $0x0
  8023bf:	ff 75 14             	pushl  0x14(%ebp)
  8023c2:	ff 75 10             	pushl  0x10(%ebp)
  8023c5:	ff 75 0c             	pushl  0xc(%ebp)
  8023c8:	50                   	push   %eax
  8023c9:	6a 20                	push   $0x20
  8023cb:	e8 89 fc ff ff       	call   802059 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	50                   	push   %eax
  8023e4:	6a 21                	push   $0x21
  8023e6:	e8 6e fc ff ff       	call   802059 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	90                   	nop
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	50                   	push   %eax
  802400:	6a 22                	push   $0x22
  802402:	e8 52 fc ff ff       	call   802059 <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 02                	push   $0x2
  80241b:	e8 39 fc ff ff       	call   802059 <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 03                	push   $0x3
  802434:	e8 20 fc ff ff       	call   802059 <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 04                	push   $0x4
  80244d:	e8 07 fc ff ff       	call   802059 <syscall>
  802452:	83 c4 18             	add    $0x18,%esp
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <sys_exit_env>:


void sys_exit_env(void)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 23                	push   $0x23
  802466:	e8 ee fb ff ff       	call   802059 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
}
  80246e:	90                   	nop
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802477:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80247a:	8d 50 04             	lea    0x4(%eax),%edx
  80247d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	52                   	push   %edx
  802487:	50                   	push   %eax
  802488:	6a 24                	push   $0x24
  80248a:	e8 ca fb ff ff       	call   802059 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
	return result;
  802492:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802495:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802498:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249b:	89 01                	mov    %eax,(%ecx)
  80249d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	c9                   	leave  
  8024a4:	c2 04 00             	ret    $0x4

008024a7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	ff 75 10             	pushl  0x10(%ebp)
  8024b1:	ff 75 0c             	pushl  0xc(%ebp)
  8024b4:	ff 75 08             	pushl  0x8(%ebp)
  8024b7:	6a 12                	push   $0x12
  8024b9:	e8 9b fb ff ff       	call   802059 <syscall>
  8024be:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c1:	90                   	nop
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 25                	push   $0x25
  8024d3:	e8 81 fb ff ff       	call   802059 <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 04             	sub    $0x4,%esp
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024e9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	50                   	push   %eax
  8024f6:	6a 26                	push   $0x26
  8024f8:	e8 5c fb ff ff       	call   802059 <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802500:	90                   	nop
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <rsttst>:
void rsttst()
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 28                	push   $0x28
  802512:	e8 42 fb ff ff       	call   802059 <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
	return ;
  80251a:	90                   	nop
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	8b 45 14             	mov    0x14(%ebp),%eax
  802526:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802529:	8b 55 18             	mov    0x18(%ebp),%edx
  80252c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802530:	52                   	push   %edx
  802531:	50                   	push   %eax
  802532:	ff 75 10             	pushl  0x10(%ebp)
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	6a 27                	push   $0x27
  80253d:	e8 17 fb ff ff       	call   802059 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
	return ;
  802545:	90                   	nop
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <chktst>:
void chktst(uint32 n)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	ff 75 08             	pushl  0x8(%ebp)
  802556:	6a 29                	push   $0x29
  802558:	e8 fc fa ff ff       	call   802059 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
	return ;
  802560:	90                   	nop
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <inctst>:

void inctst()
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 2a                	push   $0x2a
  802572:	e8 e2 fa ff ff       	call   802059 <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
	return ;
  80257a:	90                   	nop
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <gettst>:
uint32 gettst()
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 2b                	push   $0x2b
  80258c:	e8 c8 fa ff ff       	call   802059 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 2c                	push   $0x2c
  8025a8:	e8 ac fa ff ff       	call   802059 <syscall>
  8025ad:	83 c4 18             	add    $0x18,%esp
  8025b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025b3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025b7:	75 07                	jne    8025c0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8025be:	eb 05                	jmp    8025c5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 2c                	push   $0x2c
  8025d9:	e8 7b fa ff ff       	call   802059 <syscall>
  8025de:	83 c4 18             	add    $0x18,%esp
  8025e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025e4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025e8:	75 07                	jne    8025f1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ef:	eb 05                	jmp    8025f6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 2c                	push   $0x2c
  80260a:	e8 4a fa ff ff       	call   802059 <syscall>
  80260f:	83 c4 18             	add    $0x18,%esp
  802612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802615:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802619:	75 07                	jne    802622 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80261b:	b8 01 00 00 00       	mov    $0x1,%eax
  802620:	eb 05                	jmp    802627 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802627:	c9                   	leave  
  802628:	c3                   	ret    

00802629 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 2c                	push   $0x2c
  80263b:	e8 19 fa ff ff       	call   802059 <syscall>
  802640:	83 c4 18             	add    $0x18,%esp
  802643:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802646:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80264a:	75 07                	jne    802653 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80264c:	b8 01 00 00 00       	mov    $0x1,%eax
  802651:	eb 05                	jmp    802658 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	ff 75 08             	pushl  0x8(%ebp)
  802668:	6a 2d                	push   $0x2d
  80266a:	e8 ea f9 ff ff       	call   802059 <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
	return ;
  802672:	90                   	nop
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802679:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80267c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80267f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	6a 00                	push   $0x0
  802687:	53                   	push   %ebx
  802688:	51                   	push   %ecx
  802689:	52                   	push   %edx
  80268a:	50                   	push   %eax
  80268b:	6a 2e                	push   $0x2e
  80268d:	e8 c7 f9 ff ff       	call   802059 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
}
  802695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80269d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	52                   	push   %edx
  8026aa:	50                   	push   %eax
  8026ab:	6a 2f                	push   $0x2f
  8026ad:	e8 a7 f9 ff ff       	call   802059 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
  8026ba:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	68 50 43 80 00       	push   $0x804350
  8026c5:	e8 c1 e4 ff ff       	call   800b8b <cprintf>
  8026ca:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	68 7c 43 80 00       	push   $0x80437c
  8026dc:	e8 aa e4 ff ff       	call   800b8b <cprintf>
  8026e1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026e4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f0:	eb 56                	jmp    802748 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f6:	74 1c                	je     802714 <print_mem_block_lists+0x5d>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 50 08             	mov    0x8(%eax),%edx
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 48 08             	mov    0x8(%eax),%ecx
  802704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	01 c8                	add    %ecx,%eax
  80270c:	39 c2                	cmp    %eax,%edx
  80270e:	73 04                	jae    802714 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802710:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 50 08             	mov    0x8(%eax),%edx
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 0c             	mov    0xc(%eax),%eax
  802720:	01 c2                	add    %eax,%edx
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 08             	mov    0x8(%eax),%eax
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	52                   	push   %edx
  80272c:	50                   	push   %eax
  80272d:	68 91 43 80 00       	push   $0x804391
  802732:	e8 54 e4 ff ff       	call   800b8b <cprintf>
  802737:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802740:	a1 40 51 80 00       	mov    0x805140,%eax
  802745:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274c:	74 07                	je     802755 <print_mem_block_lists+0x9e>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	eb 05                	jmp    80275a <print_mem_block_lists+0xa3>
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	a3 40 51 80 00       	mov    %eax,0x805140
  80275f:	a1 40 51 80 00       	mov    0x805140,%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	75 8a                	jne    8026f2 <print_mem_block_lists+0x3b>
  802768:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276c:	75 84                	jne    8026f2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80276e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802772:	75 10                	jne    802784 <print_mem_block_lists+0xcd>
  802774:	83 ec 0c             	sub    $0xc,%esp
  802777:	68 a0 43 80 00       	push   $0x8043a0
  80277c:	e8 0a e4 ff ff       	call   800b8b <cprintf>
  802781:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802784:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80278b:	83 ec 0c             	sub    $0xc,%esp
  80278e:	68 c4 43 80 00       	push   $0x8043c4
  802793:	e8 f3 e3 ff ff       	call   800b8b <cprintf>
  802798:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80279b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80279f:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a7:	eb 56                	jmp    8027ff <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ad:	74 1c                	je     8027cb <print_mem_block_lists+0x114>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 50 08             	mov    0x8(%eax),%edx
  8027b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b8:	8b 48 08             	mov    0x8(%eax),%ecx
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c1:	01 c8                	add    %ecx,%eax
  8027c3:	39 c2                	cmp    %eax,%edx
  8027c5:	73 04                	jae    8027cb <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027c7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 50 08             	mov    0x8(%eax),%edx
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	01 c2                	add    %eax,%edx
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 40 08             	mov    0x8(%eax),%eax
  8027df:	83 ec 04             	sub    $0x4,%esp
  8027e2:	52                   	push   %edx
  8027e3:	50                   	push   %eax
  8027e4:	68 91 43 80 00       	push   $0x804391
  8027e9:	e8 9d e3 ff ff       	call   800b8b <cprintf>
  8027ee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027f7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	74 07                	je     80280c <print_mem_block_lists+0x155>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	eb 05                	jmp    802811 <print_mem_block_lists+0x15a>
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	a3 48 50 80 00       	mov    %eax,0x805048
  802816:	a1 48 50 80 00       	mov    0x805048,%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	75 8a                	jne    8027a9 <print_mem_block_lists+0xf2>
  80281f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802823:	75 84                	jne    8027a9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802825:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802829:	75 10                	jne    80283b <print_mem_block_lists+0x184>
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	68 dc 43 80 00       	push   $0x8043dc
  802833:	e8 53 e3 ff ff       	call   800b8b <cprintf>
  802838:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	68 50 43 80 00       	push   $0x804350
  802843:	e8 43 e3 ff ff       	call   800b8b <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp

}
  80284b:	90                   	nop
  80284c:	c9                   	leave  
  80284d:	c3                   	ret    

0080284e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802854:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80285b:	00 00 00 
  80285e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802865:	00 00 00 
  802868:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80286f:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802872:	a1 50 50 80 00       	mov    0x805050,%eax
  802877:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80287a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802881:	e9 9e 00 00 00       	jmp    802924 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802886:	a1 50 50 80 00       	mov    0x805050,%eax
  80288b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288e:	c1 e2 04             	shl    $0x4,%edx
  802891:	01 d0                	add    %edx,%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	75 14                	jne    8028ab <initialize_MemBlocksList+0x5d>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 04 44 80 00       	push   $0x804404
  80289f:	6a 48                	push   $0x48
  8028a1:	68 27 44 80 00       	push   $0x804427
  8028a6:	e8 2c e0 ff ff       	call   8008d7 <_panic>
  8028ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b3:	c1 e2 04             	shl    $0x4,%edx
  8028b6:	01 d0                	add    %edx,%eax
  8028b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028be:	89 10                	mov    %edx,(%eax)
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	74 18                	je     8028de <initialize_MemBlocksList+0x90>
  8028c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028cb:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028d4:	c1 e1 04             	shl    $0x4,%ecx
  8028d7:	01 ca                	add    %ecx,%edx
  8028d9:	89 50 04             	mov    %edx,0x4(%eax)
  8028dc:	eb 12                	jmp    8028f0 <initialize_MemBlocksList+0xa2>
  8028de:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e6:	c1 e2 04             	shl    $0x4,%edx
  8028e9:	01 d0                	add    %edx,%eax
  8028eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f8:	c1 e2 04             	shl    $0x4,%edx
  8028fb:	01 d0                	add    %edx,%eax
  8028fd:	a3 48 51 80 00       	mov    %eax,0x805148
  802902:	a1 50 50 80 00       	mov    0x805050,%eax
  802907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290a:	c1 e2 04             	shl    $0x4,%edx
  80290d:	01 d0                	add    %edx,%eax
  80290f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802916:	a1 54 51 80 00       	mov    0x805154,%eax
  80291b:	40                   	inc    %eax
  80291c:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802921:	ff 45 f4             	incl   -0xc(%ebp)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292a:	0f 82 56 ff ff ff    	jb     802886 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802930:	90                   	nop
  802931:	c9                   	leave  
  802932:	c3                   	ret    

00802933 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802933:	55                   	push   %ebp
  802934:	89 e5                	mov    %esp,%ebp
  802936:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802941:	eb 18                	jmp    80295b <find_block+0x28>
		{
			if(tmp->sva==va)
  802943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802946:	8b 40 08             	mov    0x8(%eax),%eax
  802949:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80294c:	75 05                	jne    802953 <find_block+0x20>
			{
				return tmp;
  80294e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802951:	eb 11                	jmp    802964 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802953:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80295b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80295f:	75 e2                	jne    802943 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802961:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80296c:	a1 40 50 80 00       	mov    0x805040,%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	0f 85 83 00 00 00    	jne    8029fc <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802979:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802980:	00 00 00 
  802983:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80298a:	00 00 00 
  80298d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802994:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802997:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299b:	75 14                	jne    8029b1 <insert_sorted_allocList+0x4b>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 04 44 80 00       	push   $0x804404
  8029a5:	6a 7f                	push   $0x7f
  8029a7:	68 27 44 80 00       	push   $0x804427
  8029ac:	e8 26 df ff ff       	call   8008d7 <_panic>
  8029b1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 0d                	je     8029d2 <insert_sorted_allocList+0x6c>
  8029c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	89 50 04             	mov    %edx,0x4(%eax)
  8029d0:	eb 08                	jmp    8029da <insert_sorted_allocList+0x74>
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	a3 44 50 80 00       	mov    %eax,0x805044
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029f1:	40                   	inc    %eax
  8029f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029f7:	e9 16 01 00 00       	jmp    802b12 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	8b 50 08             	mov    0x8(%eax),%edx
  802a02:	a1 44 50 80 00       	mov    0x805044,%eax
  802a07:	8b 40 08             	mov    0x8(%eax),%eax
  802a0a:	39 c2                	cmp    %eax,%edx
  802a0c:	76 68                	jbe    802a76 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a12:	75 17                	jne    802a2b <insert_sorted_allocList+0xc5>
  802a14:	83 ec 04             	sub    $0x4,%esp
  802a17:	68 40 44 80 00       	push   $0x804440
  802a1c:	68 85 00 00 00       	push   $0x85
  802a21:	68 27 44 80 00       	push   $0x804427
  802a26:	e8 ac de ff ff       	call   8008d7 <_panic>
  802a2b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0c                	je     802a4d <insert_sorted_allocList+0xe7>
  802a41:	a1 44 50 80 00       	mov    0x805044,%eax
  802a46:	8b 55 08             	mov    0x8(%ebp),%edx
  802a49:	89 10                	mov    %edx,(%eax)
  802a4b:	eb 08                	jmp    802a55 <insert_sorted_allocList+0xef>
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	a3 40 50 80 00       	mov    %eax,0x805040
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 44 50 80 00       	mov    %eax,0x805044
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a66:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a6b:	40                   	inc    %eax
  802a6c:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a71:	e9 9c 00 00 00       	jmp    802b12 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802a76:	a1 40 50 80 00       	mov    0x805040,%eax
  802a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802a7e:	e9 85 00 00 00       	jmp    802b08 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	39 c2                	cmp    %eax,%edx
  802a91:	73 6d                	jae    802b00 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a97:	74 06                	je     802a9f <insert_sorted_allocList+0x139>
  802a99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9d:	75 17                	jne    802ab6 <insert_sorted_allocList+0x150>
  802a9f:	83 ec 04             	sub    $0x4,%esp
  802aa2:	68 64 44 80 00       	push   $0x804464
  802aa7:	68 90 00 00 00       	push   $0x90
  802aac:	68 27 44 80 00       	push   $0x804427
  802ab1:	e8 21 de ff ff       	call   8008d7 <_panic>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 50 04             	mov    0x4(%eax),%edx
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	89 50 04             	mov    %edx,0x4(%eax)
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac8:	89 10                	mov    %edx,(%eax)
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 04             	mov    0x4(%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 0d                	je     802ae1 <insert_sorted_allocList+0x17b>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	eb 08                	jmp    802ae9 <insert_sorted_allocList+0x183>
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	a3 40 50 80 00       	mov    %eax,0x805040
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 55 08             	mov    0x8(%ebp),%edx
  802aef:	89 50 04             	mov    %edx,0x4(%eax)
  802af2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802af7:	40                   	inc    %eax
  802af8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802afd:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802afe:	eb 12                	jmp    802b12 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0c:	0f 85 71 ff ff ff    	jne    802a83 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802b12:	90                   	nop
  802b13:	c9                   	leave  
  802b14:	c3                   	ret    

00802b15 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
  802b18:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802b1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b20:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802b23:	e9 76 01 00 00       	jmp    802c9e <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b31:	0f 85 8a 00 00 00    	jne    802bc1 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3b:	75 17                	jne    802b54 <alloc_block_FF+0x3f>
  802b3d:	83 ec 04             	sub    $0x4,%esp
  802b40:	68 99 44 80 00       	push   $0x804499
  802b45:	68 a8 00 00 00       	push   $0xa8
  802b4a:	68 27 44 80 00       	push   $0x804427
  802b4f:	e8 83 dd ff ff       	call   8008d7 <_panic>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	74 10                	je     802b6d <alloc_block_FF+0x58>
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b65:	8b 52 04             	mov    0x4(%edx),%edx
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	eb 0b                	jmp    802b78 <alloc_block_FF+0x63>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0f                	je     802b91 <alloc_block_FF+0x7c>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8b:	8b 12                	mov    (%edx),%edx
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	eb 0a                	jmp    802b9b <alloc_block_FF+0x86>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	a3 38 51 80 00       	mov    %eax,0x805138
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bae:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb3:	48                   	dec    %eax
  802bb4:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	e9 ea 00 00 00       	jmp    802cab <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bca:	0f 86 c6 00 00 00    	jbe    802c96 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802bd0:	a1 48 51 80 00       	mov    0x805148,%eax
  802bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bde:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf3:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf6:	89 c2                	mov    %eax,%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	01 c2                	add    %eax,%edx
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c13:	75 17                	jne    802c2c <alloc_block_FF+0x117>
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	68 99 44 80 00       	push   $0x804499
  802c1d:	68 b6 00 00 00       	push   $0xb6
  802c22:	68 27 44 80 00       	push   $0x804427
  802c27:	e8 ab dc ff ff       	call   8008d7 <_panic>
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	74 10                	je     802c45 <alloc_block_FF+0x130>
  802c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3d:	8b 52 04             	mov    0x4(%edx),%edx
  802c40:	89 50 04             	mov    %edx,0x4(%eax)
  802c43:	eb 0b                	jmp    802c50 <alloc_block_FF+0x13b>
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 0f                	je     802c69 <alloc_block_FF+0x154>
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	8b 40 04             	mov    0x4(%eax),%eax
  802c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c63:	8b 12                	mov    (%edx),%edx
  802c65:	89 10                	mov    %edx,(%eax)
  802c67:	eb 0a                	jmp    802c73 <alloc_block_FF+0x15e>
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	a3 48 51 80 00       	mov    %eax,0x805148
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c86:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8b:	48                   	dec    %eax
  802c8c:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	eb 15                	jmp    802cab <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca2:	0f 85 80 fe ff ff    	jne    802b28 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    

00802cad <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
  802cb0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802cb3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802cbb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802cc2:	e9 c0 00 00 00       	jmp    802d87 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd0:	0f 85 8a 00 00 00    	jne    802d60 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cda:	75 17                	jne    802cf3 <alloc_block_BF+0x46>
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	68 99 44 80 00       	push   $0x804499
  802ce4:	68 cf 00 00 00       	push   $0xcf
  802ce9:	68 27 44 80 00       	push   $0x804427
  802cee:	e8 e4 db ff ff       	call   8008d7 <_panic>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 10                	je     802d0c <alloc_block_BF+0x5f>
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d04:	8b 52 04             	mov    0x4(%edx),%edx
  802d07:	89 50 04             	mov    %edx,0x4(%eax)
  802d0a:	eb 0b                	jmp    802d17 <alloc_block_BF+0x6a>
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	74 0f                	je     802d30 <alloc_block_BF+0x83>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2a:	8b 12                	mov    (%edx),%edx
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	eb 0a                	jmp    802d3a <alloc_block_BF+0x8d>
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d52:	48                   	dec    %eax
  802d53:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	e9 2a 01 00 00       	jmp    802e8a <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 0c             	mov    0xc(%eax),%eax
  802d66:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d69:	73 14                	jae    802d7f <alloc_block_BF+0xd2>
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d74:	76 09                	jbe    802d7f <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7c:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	0f 85 36 ff ff ff    	jne    802cc7 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802d91:	a1 38 51 80 00       	mov    0x805138,%eax
  802d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802d99:	e9 dd 00 00 00       	jmp    802e7b <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	8b 40 0c             	mov    0xc(%eax),%eax
  802da4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802da7:	0f 85 c6 00 00 00    	jne    802e73 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802dad:	a1 48 51 80 00       	mov    0x805148,%eax
  802db2:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbe:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802dc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc7:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 50 08             	mov    0x8(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	01 c2                	add    %eax,%edx
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	2b 45 08             	sub    0x8(%ebp),%eax
  802de4:	89 c2                	mov    %eax,%edx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802dec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802df0:	75 17                	jne    802e09 <alloc_block_BF+0x15c>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 99 44 80 00       	push   $0x804499
  802dfa:	68 eb 00 00 00       	push   $0xeb
  802dff:	68 27 44 80 00       	push   $0x804427
  802e04:	e8 ce da ff ff       	call   8008d7 <_panic>
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 10                	je     802e22 <alloc_block_BF+0x175>
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e1a:	8b 52 04             	mov    0x4(%edx),%edx
  802e1d:	89 50 04             	mov    %edx,0x4(%eax)
  802e20:	eb 0b                	jmp    802e2d <alloc_block_BF+0x180>
  802e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e25:	8b 40 04             	mov    0x4(%eax),%eax
  802e28:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e30:	8b 40 04             	mov    0x4(%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	74 0f                	je     802e46 <alloc_block_BF+0x199>
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	8b 40 04             	mov    0x4(%eax),%eax
  802e3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e40:	8b 12                	mov    (%edx),%edx
  802e42:	89 10                	mov    %edx,(%eax)
  802e44:	eb 0a                	jmp    802e50 <alloc_block_BF+0x1a3>
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e63:	a1 54 51 80 00       	mov    0x805154,%eax
  802e68:	48                   	dec    %eax
  802e69:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e71:	eb 17                	jmp    802e8a <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7f:	0f 85 19 ff ff ff    	jne    802d9e <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802e85:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802e8a:	c9                   	leave  
  802e8b:	c3                   	ret    

00802e8c <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802e8c:	55                   	push   %ebp
  802e8d:	89 e5                	mov    %esp,%ebp
  802e8f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802e92:	a1 40 50 80 00       	mov    0x805040,%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	75 19                	jne    802eb4 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802e9b:	83 ec 0c             	sub    $0xc,%esp
  802e9e:	ff 75 08             	pushl  0x8(%ebp)
  802ea1:	e8 6f fc ff ff       	call   802b15 <alloc_block_FF>
  802ea6:	83 c4 10             	add    $0x10,%esp
  802ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	e9 e9 01 00 00       	jmp    80309d <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802eb4:	a1 44 50 80 00       	mov    0x805044,%eax
  802eb9:	8b 40 08             	mov    0x8(%eax),%eax
  802ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802ebf:	a1 44 50 80 00       	mov    0x805044,%eax
  802ec4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec7:	a1 44 50 80 00       	mov    0x805044,%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	01 d0                	add    %edx,%eax
  802ed1:	83 ec 08             	sub    $0x8,%esp
  802ed4:	50                   	push   %eax
  802ed5:	68 38 51 80 00       	push   $0x805138
  802eda:	e8 54 fa ff ff       	call   802933 <find_block>
  802edf:	83 c4 10             	add    $0x10,%esp
  802ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eee:	0f 85 9b 00 00 00    	jne    802f8f <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 50 0c             	mov    0xc(%eax),%edx
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 40 08             	mov    0x8(%eax),%eax
  802f00:	01 d0                	add    %edx,%eax
  802f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f09:	75 17                	jne    802f22 <alloc_block_NF+0x96>
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	68 99 44 80 00       	push   $0x804499
  802f13:	68 1a 01 00 00       	push   $0x11a
  802f18:	68 27 44 80 00       	push   $0x804427
  802f1d:	e8 b5 d9 ff ff       	call   8008d7 <_panic>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	74 10                	je     802f3b <alloc_block_NF+0xaf>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f33:	8b 52 04             	mov    0x4(%edx),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	eb 0b                	jmp    802f46 <alloc_block_NF+0xba>
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	74 0f                	je     802f5f <alloc_block_NF+0xd3>
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f59:	8b 12                	mov    (%edx),%edx
  802f5b:	89 10                	mov    %edx,(%eax)
  802f5d:	eb 0a                	jmp    802f69 <alloc_block_NF+0xdd>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 00                	mov    (%eax),%eax
  802f64:	a3 38 51 80 00       	mov    %eax,0x805138
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f81:	48                   	dec    %eax
  802f82:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	e9 0e 01 00 00       	jmp    80309d <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 0c             	mov    0xc(%eax),%eax
  802f95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f98:	0f 86 cf 00 00 00    	jbe    80306d <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802f9e:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fac:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 50 08             	mov    0x8(%eax),%edx
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 50 08             	mov    0x8(%eax),%edx
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	01 c2                	add    %eax,%edx
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd2:	2b 45 08             	sub    0x8(%ebp),%eax
  802fd5:	89 c2                	mov    %eax,%edx
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 08             	mov    0x8(%eax),%eax
  802fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802fe6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fea:	75 17                	jne    803003 <alloc_block_NF+0x177>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 99 44 80 00       	push   $0x804499
  802ff4:	68 28 01 00 00       	push   $0x128
  802ff9:	68 27 44 80 00       	push   $0x804427
  802ffe:	e8 d4 d8 ff ff       	call   8008d7 <_panic>
  803003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	74 10                	je     80301c <alloc_block_NF+0x190>
  80300c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803014:	8b 52 04             	mov    0x4(%edx),%edx
  803017:	89 50 04             	mov    %edx,0x4(%eax)
  80301a:	eb 0b                	jmp    803027 <alloc_block_NF+0x19b>
  80301c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302a:	8b 40 04             	mov    0x4(%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 0f                	je     803040 <alloc_block_NF+0x1b4>
  803031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803034:	8b 40 04             	mov    0x4(%eax),%eax
  803037:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80303a:	8b 12                	mov    (%edx),%edx
  80303c:	89 10                	mov    %edx,(%eax)
  80303e:	eb 0a                	jmp    80304a <alloc_block_NF+0x1be>
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	a3 48 51 80 00       	mov    %eax,0x805148
  80304a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305d:	a1 54 51 80 00       	mov    0x805154,%eax
  803062:	48                   	dec    %eax
  803063:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306b:	eb 30                	jmp    80309d <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80306d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803072:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803075:	75 0a                	jne    803081 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803077:	a1 38 51 80 00       	mov    0x805138,%eax
  80307c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307f:	eb 08                	jmp    803089 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 40 08             	mov    0x8(%eax),%eax
  80308f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803092:	0f 85 4d fe ff ff    	jne    802ee5 <alloc_block_NF+0x59>

			return NULL;
  803098:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80309d:	c9                   	leave  
  80309e:	c3                   	ret    

0080309f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
  8030a2:	53                   	push   %ebx
  8030a3:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8030a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	0f 85 86 00 00 00    	jne    803139 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8030b3:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8030ba:	00 00 00 
  8030bd:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8030c4:	00 00 00 
  8030c7:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8030ce:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d5:	75 17                	jne    8030ee <insert_sorted_with_merge_freeList+0x4f>
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	68 04 44 80 00       	push   $0x804404
  8030df:	68 48 01 00 00       	push   $0x148
  8030e4:	68 27 44 80 00       	push   $0x804427
  8030e9:	e8 e9 d7 ff ff       	call   8008d7 <_panic>
  8030ee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	89 10                	mov    %edx,(%eax)
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	85 c0                	test   %eax,%eax
  803100:	74 0d                	je     80310f <insert_sorted_with_merge_freeList+0x70>
  803102:	a1 38 51 80 00       	mov    0x805138,%eax
  803107:	8b 55 08             	mov    0x8(%ebp),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 08                	jmp    803117 <insert_sorted_with_merge_freeList+0x78>
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	a3 38 51 80 00       	mov    %eax,0x805138
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803129:	a1 44 51 80 00       	mov    0x805144,%eax
  80312e:	40                   	inc    %eax
  80312f:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803134:	e9 73 07 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 50 08             	mov    0x8(%eax),%edx
  80313f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803144:	8b 40 08             	mov    0x8(%eax),%eax
  803147:	39 c2                	cmp    %eax,%edx
  803149:	0f 86 84 00 00 00    	jbe    8031d3 <insert_sorted_with_merge_freeList+0x134>
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 50 08             	mov    0x8(%eax),%edx
  803155:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80315a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80315d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803162:	8b 40 08             	mov    0x8(%eax),%eax
  803165:	01 c8                	add    %ecx,%eax
  803167:	39 c2                	cmp    %eax,%edx
  803169:	74 68                	je     8031d3 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  80316b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316f:	75 17                	jne    803188 <insert_sorted_with_merge_freeList+0xe9>
  803171:	83 ec 04             	sub    $0x4,%esp
  803174:	68 40 44 80 00       	push   $0x804440
  803179:	68 4c 01 00 00       	push   $0x14c
  80317e:	68 27 44 80 00       	push   $0x804427
  803183:	e8 4f d7 ff ff       	call   8008d7 <_panic>
  803188:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	89 50 04             	mov    %edx,0x4(%eax)
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 0c                	je     8031aa <insert_sorted_with_merge_freeList+0x10b>
  80319e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	eb 08                	jmp    8031b2 <insert_sorted_with_merge_freeList+0x113>
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c8:	40                   	inc    %eax
  8031c9:	a3 44 51 80 00       	mov    %eax,0x805144
  8031ce:	e9 d9 06 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 50 08             	mov    0x8(%eax),%edx
  8031d9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031de:	8b 40 08             	mov    0x8(%eax),%eax
  8031e1:	39 c2                	cmp    %eax,%edx
  8031e3:	0f 86 b5 00 00 00    	jbe    80329e <insert_sorted_with_merge_freeList+0x1ff>
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 50 08             	mov    0x8(%eax),%edx
  8031ef:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031f4:	8b 48 0c             	mov    0xc(%eax),%ecx
  8031f7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031fc:	8b 40 08             	mov    0x8(%eax),%eax
  8031ff:	01 c8                	add    %ecx,%eax
  803201:	39 c2                	cmp    %eax,%edx
  803203:	0f 85 95 00 00 00    	jne    80329e <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803209:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80320e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803214:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803217:	8b 55 08             	mov    0x8(%ebp),%edx
  80321a:	8b 52 0c             	mov    0xc(%edx),%edx
  80321d:	01 ca                	add    %ecx,%edx
  80321f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323a:	75 17                	jne    803253 <insert_sorted_with_merge_freeList+0x1b4>
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	68 04 44 80 00       	push   $0x804404
  803244:	68 54 01 00 00       	push   $0x154
  803249:	68 27 44 80 00       	push   $0x804427
  80324e:	e8 84 d6 ff ff       	call   8008d7 <_panic>
  803253:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	89 10                	mov    %edx,(%eax)
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0d                	je     803274 <insert_sorted_with_merge_freeList+0x1d5>
  803267:	a1 48 51 80 00       	mov    0x805148,%eax
  80326c:	8b 55 08             	mov    0x8(%ebp),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 08                	jmp    80327c <insert_sorted_with_merge_freeList+0x1dd>
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	a3 48 51 80 00       	mov    %eax,0x805148
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328e:	a1 54 51 80 00       	mov    0x805154,%eax
  803293:	40                   	inc    %eax
  803294:	a3 54 51 80 00       	mov    %eax,0x805154
  803299:	e9 0e 06 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	8b 50 08             	mov    0x8(%eax),%edx
  8032a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8032a9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ac:	39 c2                	cmp    %eax,%edx
  8032ae:	0f 83 c1 00 00 00    	jae    803375 <insert_sorted_with_merge_freeList+0x2d6>
  8032b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8032b9:	8b 50 08             	mov    0x8(%eax),%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c8:	01 c8                	add    %ecx,%eax
  8032ca:	39 c2                	cmp    %eax,%edx
  8032cc:	0f 85 a3 00 00 00    	jne    803375 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8032d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032da:	8b 52 08             	mov    0x8(%edx),%edx
  8032dd:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8032e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032eb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8032ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f1:	8b 52 0c             	mov    0xc(%edx),%edx
  8032f4:	01 ca                	add    %ecx,%edx
  8032f6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80330d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803311:	75 17                	jne    80332a <insert_sorted_with_merge_freeList+0x28b>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 04 44 80 00       	push   $0x804404
  80331b:	68 5d 01 00 00       	push   $0x15d
  803320:	68 27 44 80 00       	push   $0x804427
  803325:	e8 ad d5 ff ff       	call   8008d7 <_panic>
  80332a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	89 10                	mov    %edx,(%eax)
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 0d                	je     80334b <insert_sorted_with_merge_freeList+0x2ac>
  80333e:	a1 48 51 80 00       	mov    0x805148,%eax
  803343:	8b 55 08             	mov    0x8(%ebp),%edx
  803346:	89 50 04             	mov    %edx,0x4(%eax)
  803349:	eb 08                	jmp    803353 <insert_sorted_with_merge_freeList+0x2b4>
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	a3 48 51 80 00       	mov    %eax,0x805148
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803365:	a1 54 51 80 00       	mov    0x805154,%eax
  80336a:	40                   	inc    %eax
  80336b:	a3 54 51 80 00       	mov    %eax,0x805154
  803370:	e9 37 05 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	8b 50 08             	mov    0x8(%eax),%edx
  80337b:	a1 38 51 80 00       	mov    0x805138,%eax
  803380:	8b 40 08             	mov    0x8(%eax),%eax
  803383:	39 c2                	cmp    %eax,%edx
  803385:	0f 83 82 00 00 00    	jae    80340d <insert_sorted_with_merge_freeList+0x36e>
  80338b:	a1 38 51 80 00       	mov    0x805138,%eax
  803390:	8b 50 08             	mov    0x8(%eax),%edx
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 48 08             	mov    0x8(%eax),%ecx
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 40 0c             	mov    0xc(%eax),%eax
  80339f:	01 c8                	add    %ecx,%eax
  8033a1:	39 c2                	cmp    %eax,%edx
  8033a3:	74 68                	je     80340d <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a9:	75 17                	jne    8033c2 <insert_sorted_with_merge_freeList+0x323>
  8033ab:	83 ec 04             	sub    $0x4,%esp
  8033ae:	68 04 44 80 00       	push   $0x804404
  8033b3:	68 62 01 00 00       	push   $0x162
  8033b8:	68 27 44 80 00       	push   $0x804427
  8033bd:	e8 15 d5 ff ff       	call   8008d7 <_panic>
  8033c2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	89 10                	mov    %edx,(%eax)
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	74 0d                	je     8033e3 <insert_sorted_with_merge_freeList+0x344>
  8033d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033db:	8b 55 08             	mov    0x8(%ebp),%edx
  8033de:	89 50 04             	mov    %edx,0x4(%eax)
  8033e1:	eb 08                	jmp    8033eb <insert_sorted_with_merge_freeList+0x34c>
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803402:	40                   	inc    %eax
  803403:	a3 44 51 80 00       	mov    %eax,0x805144
  803408:	e9 9f 04 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  80340d:	a1 38 51 80 00       	mov    0x805138,%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803417:	e9 84 04 00 00       	jmp    8038a0 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 50 08             	mov    0x8(%eax),%edx
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	8b 40 08             	mov    0x8(%eax),%eax
  803428:	39 c2                	cmp    %eax,%edx
  80342a:	0f 86 a9 00 00 00    	jbe    8034d9 <insert_sorted_with_merge_freeList+0x43a>
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	8b 50 08             	mov    0x8(%eax),%edx
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	8b 48 08             	mov    0x8(%eax),%ecx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	8b 40 0c             	mov    0xc(%eax),%eax
  803442:	01 c8                	add    %ecx,%eax
  803444:	39 c2                	cmp    %eax,%edx
  803446:	0f 84 8d 00 00 00    	je     8034d9 <insert_sorted_with_merge_freeList+0x43a>
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	8b 50 08             	mov    0x8(%eax),%edx
  803452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803455:	8b 40 04             	mov    0x4(%eax),%eax
  803458:	8b 48 08             	mov    0x8(%eax),%ecx
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	8b 40 04             	mov    0x4(%eax),%eax
  803461:	8b 40 0c             	mov    0xc(%eax),%eax
  803464:	01 c8                	add    %ecx,%eax
  803466:	39 c2                	cmp    %eax,%edx
  803468:	74 6f                	je     8034d9 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  80346a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346e:	74 06                	je     803476 <insert_sorted_with_merge_freeList+0x3d7>
  803470:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803474:	75 17                	jne    80348d <insert_sorted_with_merge_freeList+0x3ee>
  803476:	83 ec 04             	sub    $0x4,%esp
  803479:	68 64 44 80 00       	push   $0x804464
  80347e:	68 6b 01 00 00       	push   $0x16b
  803483:	68 27 44 80 00       	push   $0x804427
  803488:	e8 4a d4 ff ff       	call   8008d7 <_panic>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 50 04             	mov    0x4(%eax),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	89 50 04             	mov    %edx,0x4(%eax)
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349f:	89 10                	mov    %edx,(%eax)
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 40 04             	mov    0x4(%eax),%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	74 0d                	je     8034b8 <insert_sorted_with_merge_freeList+0x419>
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 40 04             	mov    0x4(%eax),%eax
  8034b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b4:	89 10                	mov    %edx,(%eax)
  8034b6:	eb 08                	jmp    8034c0 <insert_sorted_with_merge_freeList+0x421>
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ce:	40                   	inc    %eax
  8034cf:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8034d4:	e9 d3 03 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 50 08             	mov    0x8(%eax),%edx
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	8b 40 08             	mov    0x8(%eax),%eax
  8034e5:	39 c2                	cmp    %eax,%edx
  8034e7:	0f 86 da 00 00 00    	jbe    8035c7 <insert_sorted_with_merge_freeList+0x528>
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 50 08             	mov    0x8(%eax),%edx
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ff:	01 c8                	add    %ecx,%eax
  803501:	39 c2                	cmp    %eax,%edx
  803503:	0f 85 be 00 00 00    	jne    8035c7 <insert_sorted_with_merge_freeList+0x528>
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 50 08             	mov    0x8(%eax),%edx
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 40 04             	mov    0x4(%eax),%eax
  803515:	8b 48 08             	mov    0x8(%eax),%ecx
  803518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	8b 40 0c             	mov    0xc(%eax),%eax
  803521:	01 c8                	add    %ecx,%eax
  803523:	39 c2                	cmp    %eax,%edx
  803525:	0f 84 9c 00 00 00    	je     8035c7 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	8b 50 08             	mov    0x8(%eax),%edx
  803531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803534:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	8b 50 0c             	mov    0xc(%eax),%edx
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	8b 40 0c             	mov    0xc(%eax),%eax
  803543:	01 c2                	add    %eax,%edx
  803545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803548:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80354b:	8b 45 08             	mov    0x8(%ebp),%eax
  80354e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80355f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803563:	75 17                	jne    80357c <insert_sorted_with_merge_freeList+0x4dd>
  803565:	83 ec 04             	sub    $0x4,%esp
  803568:	68 04 44 80 00       	push   $0x804404
  80356d:	68 74 01 00 00       	push   $0x174
  803572:	68 27 44 80 00       	push   $0x804427
  803577:	e8 5b d3 ff ff       	call   8008d7 <_panic>
  80357c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	89 10                	mov    %edx,(%eax)
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 0d                	je     80359d <insert_sorted_with_merge_freeList+0x4fe>
  803590:	a1 48 51 80 00       	mov    0x805148,%eax
  803595:	8b 55 08             	mov    0x8(%ebp),%edx
  803598:	89 50 04             	mov    %edx,0x4(%eax)
  80359b:	eb 08                	jmp    8035a5 <insert_sorted_with_merge_freeList+0x506>
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8035bc:	40                   	inc    %eax
  8035bd:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8035c2:	e9 e5 02 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	8b 50 08             	mov    0x8(%eax),%edx
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	8b 40 08             	mov    0x8(%eax),%eax
  8035d3:	39 c2                	cmp    %eax,%edx
  8035d5:	0f 86 d7 00 00 00    	jbe    8036b2 <insert_sorted_with_merge_freeList+0x613>
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	8b 50 08             	mov    0x8(%eax),%edx
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	8b 48 08             	mov    0x8(%eax),%ecx
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ed:	01 c8                	add    %ecx,%eax
  8035ef:	39 c2                	cmp    %eax,%edx
  8035f1:	0f 84 bb 00 00 00    	je     8036b2 <insert_sorted_with_merge_freeList+0x613>
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	8b 50 08             	mov    0x8(%eax),%edx
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	8b 48 08             	mov    0x8(%eax),%ecx
  803606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803609:	8b 40 04             	mov    0x4(%eax),%eax
  80360c:	8b 40 0c             	mov    0xc(%eax),%eax
  80360f:	01 c8                	add    %ecx,%eax
  803611:	39 c2                	cmp    %eax,%edx
  803613:	0f 85 99 00 00 00    	jne    8036b2 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	8b 40 04             	mov    0x4(%eax),%eax
  80361f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803625:	8b 50 0c             	mov    0xc(%eax),%edx
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	8b 40 0c             	mov    0xc(%eax),%eax
  80362e:	01 c2                	add    %eax,%edx
  803630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803633:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80364a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364e:	75 17                	jne    803667 <insert_sorted_with_merge_freeList+0x5c8>
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	68 04 44 80 00       	push   $0x804404
  803658:	68 7d 01 00 00       	push   $0x17d
  80365d:	68 27 44 80 00       	push   $0x804427
  803662:	e8 70 d2 ff ff       	call   8008d7 <_panic>
  803667:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	89 10                	mov    %edx,(%eax)
  803672:	8b 45 08             	mov    0x8(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0d                	je     803688 <insert_sorted_with_merge_freeList+0x5e9>
  80367b:	a1 48 51 80 00       	mov    0x805148,%eax
  803680:	8b 55 08             	mov    0x8(%ebp),%edx
  803683:	89 50 04             	mov    %edx,0x4(%eax)
  803686:	eb 08                	jmp    803690 <insert_sorted_with_merge_freeList+0x5f1>
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	a3 48 51 80 00       	mov    %eax,0x805148
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a7:	40                   	inc    %eax
  8036a8:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8036ad:	e9 fa 01 00 00       	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8036b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b5:	8b 50 08             	mov    0x8(%eax),%edx
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	8b 40 08             	mov    0x8(%eax),%eax
  8036be:	39 c2                	cmp    %eax,%edx
  8036c0:	0f 86 d2 01 00 00    	jbe    803898 <insert_sorted_with_merge_freeList+0x7f9>
  8036c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c9:	8b 50 08             	mov    0x8(%eax),%edx
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	8b 48 08             	mov    0x8(%eax),%ecx
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d8:	01 c8                	add    %ecx,%eax
  8036da:	39 c2                	cmp    %eax,%edx
  8036dc:	0f 85 b6 01 00 00    	jne    803898 <insert_sorted_with_merge_freeList+0x7f9>
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	8b 50 08             	mov    0x8(%eax),%edx
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	8b 48 08             	mov    0x8(%eax),%ecx
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	8b 40 04             	mov    0x4(%eax),%eax
  8036f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fa:	01 c8                	add    %ecx,%eax
  8036fc:	39 c2                	cmp    %eax,%edx
  8036fe:	0f 85 94 01 00 00    	jne    803898 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803707:	8b 40 04             	mov    0x4(%eax),%eax
  80370a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80370d:	8b 52 04             	mov    0x4(%edx),%edx
  803710:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803713:	8b 55 08             	mov    0x8(%ebp),%edx
  803716:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371c:	8b 52 0c             	mov    0xc(%edx),%edx
  80371f:	01 da                	add    %ebx,%edx
  803721:	01 ca                	add    %ecx,%edx
  803723:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803733:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80373a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373e:	75 17                	jne    803757 <insert_sorted_with_merge_freeList+0x6b8>
  803740:	83 ec 04             	sub    $0x4,%esp
  803743:	68 99 44 80 00       	push   $0x804499
  803748:	68 86 01 00 00       	push   $0x186
  80374d:	68 27 44 80 00       	push   $0x804427
  803752:	e8 80 d1 ff ff       	call   8008d7 <_panic>
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 10                	je     803770 <insert_sorted_with_merge_freeList+0x6d1>
  803760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803768:	8b 52 04             	mov    0x4(%edx),%edx
  80376b:	89 50 04             	mov    %edx,0x4(%eax)
  80376e:	eb 0b                	jmp    80377b <insert_sorted_with_merge_freeList+0x6dc>
  803770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803773:	8b 40 04             	mov    0x4(%eax),%eax
  803776:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	8b 40 04             	mov    0x4(%eax),%eax
  803781:	85 c0                	test   %eax,%eax
  803783:	74 0f                	je     803794 <insert_sorted_with_merge_freeList+0x6f5>
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	8b 40 04             	mov    0x4(%eax),%eax
  80378b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80378e:	8b 12                	mov    (%edx),%edx
  803790:	89 10                	mov    %edx,(%eax)
  803792:	eb 0a                	jmp    80379e <insert_sorted_with_merge_freeList+0x6ff>
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	8b 00                	mov    (%eax),%eax
  803799:	a3 38 51 80 00       	mov    %eax,0x805138
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8037b6:	48                   	dec    %eax
  8037b7:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8037bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c0:	75 17                	jne    8037d9 <insert_sorted_with_merge_freeList+0x73a>
  8037c2:	83 ec 04             	sub    $0x4,%esp
  8037c5:	68 04 44 80 00       	push   $0x804404
  8037ca:	68 87 01 00 00       	push   $0x187
  8037cf:	68 27 44 80 00       	push   $0x804427
  8037d4:	e8 fe d0 ff ff       	call   8008d7 <_panic>
  8037d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e2:	89 10                	mov    %edx,(%eax)
  8037e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	74 0d                	je     8037fa <insert_sorted_with_merge_freeList+0x75b>
  8037ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	eb 08                	jmp    803802 <insert_sorted_with_merge_freeList+0x763>
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803805:	a3 48 51 80 00       	mov    %eax,0x805148
  80380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803814:	a1 54 51 80 00       	mov    0x805154,%eax
  803819:	40                   	inc    %eax
  80381a:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803833:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803837:	75 17                	jne    803850 <insert_sorted_with_merge_freeList+0x7b1>
  803839:	83 ec 04             	sub    $0x4,%esp
  80383c:	68 04 44 80 00       	push   $0x804404
  803841:	68 8a 01 00 00       	push   $0x18a
  803846:	68 27 44 80 00       	push   $0x804427
  80384b:	e8 87 d0 ff ff       	call   8008d7 <_panic>
  803850:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803856:	8b 45 08             	mov    0x8(%ebp),%eax
  803859:	89 10                	mov    %edx,(%eax)
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 0d                	je     803871 <insert_sorted_with_merge_freeList+0x7d2>
  803864:	a1 48 51 80 00       	mov    0x805148,%eax
  803869:	8b 55 08             	mov    0x8(%ebp),%edx
  80386c:	89 50 04             	mov    %edx,0x4(%eax)
  80386f:	eb 08                	jmp    803879 <insert_sorted_with_merge_freeList+0x7da>
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803879:	8b 45 08             	mov    0x8(%ebp),%eax
  80387c:	a3 48 51 80 00       	mov    %eax,0x805148
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80388b:	a1 54 51 80 00       	mov    0x805154,%eax
  803890:	40                   	inc    %eax
  803891:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803896:	eb 14                	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8038a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a4:	0f 85 72 fb ff ff    	jne    80341c <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8038aa:	eb 00                	jmp    8038ac <insert_sorted_with_merge_freeList+0x80d>
  8038ac:	90                   	nop
  8038ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038b0:	c9                   	leave  
  8038b1:	c3                   	ret    
  8038b2:	66 90                	xchg   %ax,%ax

008038b4 <__udivdi3>:
  8038b4:	55                   	push   %ebp
  8038b5:	57                   	push   %edi
  8038b6:	56                   	push   %esi
  8038b7:	53                   	push   %ebx
  8038b8:	83 ec 1c             	sub    $0x1c,%esp
  8038bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038cb:	89 ca                	mov    %ecx,%edx
  8038cd:	89 f8                	mov    %edi,%eax
  8038cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038d3:	85 f6                	test   %esi,%esi
  8038d5:	75 2d                	jne    803904 <__udivdi3+0x50>
  8038d7:	39 cf                	cmp    %ecx,%edi
  8038d9:	77 65                	ja     803940 <__udivdi3+0x8c>
  8038db:	89 fd                	mov    %edi,%ebp
  8038dd:	85 ff                	test   %edi,%edi
  8038df:	75 0b                	jne    8038ec <__udivdi3+0x38>
  8038e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e6:	31 d2                	xor    %edx,%edx
  8038e8:	f7 f7                	div    %edi
  8038ea:	89 c5                	mov    %eax,%ebp
  8038ec:	31 d2                	xor    %edx,%edx
  8038ee:	89 c8                	mov    %ecx,%eax
  8038f0:	f7 f5                	div    %ebp
  8038f2:	89 c1                	mov    %eax,%ecx
  8038f4:	89 d8                	mov    %ebx,%eax
  8038f6:	f7 f5                	div    %ebp
  8038f8:	89 cf                	mov    %ecx,%edi
  8038fa:	89 fa                	mov    %edi,%edx
  8038fc:	83 c4 1c             	add    $0x1c,%esp
  8038ff:	5b                   	pop    %ebx
  803900:	5e                   	pop    %esi
  803901:	5f                   	pop    %edi
  803902:	5d                   	pop    %ebp
  803903:	c3                   	ret    
  803904:	39 ce                	cmp    %ecx,%esi
  803906:	77 28                	ja     803930 <__udivdi3+0x7c>
  803908:	0f bd fe             	bsr    %esi,%edi
  80390b:	83 f7 1f             	xor    $0x1f,%edi
  80390e:	75 40                	jne    803950 <__udivdi3+0x9c>
  803910:	39 ce                	cmp    %ecx,%esi
  803912:	72 0a                	jb     80391e <__udivdi3+0x6a>
  803914:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803918:	0f 87 9e 00 00 00    	ja     8039bc <__udivdi3+0x108>
  80391e:	b8 01 00 00 00       	mov    $0x1,%eax
  803923:	89 fa                	mov    %edi,%edx
  803925:	83 c4 1c             	add    $0x1c,%esp
  803928:	5b                   	pop    %ebx
  803929:	5e                   	pop    %esi
  80392a:	5f                   	pop    %edi
  80392b:	5d                   	pop    %ebp
  80392c:	c3                   	ret    
  80392d:	8d 76 00             	lea    0x0(%esi),%esi
  803930:	31 ff                	xor    %edi,%edi
  803932:	31 c0                	xor    %eax,%eax
  803934:	89 fa                	mov    %edi,%edx
  803936:	83 c4 1c             	add    $0x1c,%esp
  803939:	5b                   	pop    %ebx
  80393a:	5e                   	pop    %esi
  80393b:	5f                   	pop    %edi
  80393c:	5d                   	pop    %ebp
  80393d:	c3                   	ret    
  80393e:	66 90                	xchg   %ax,%ax
  803940:	89 d8                	mov    %ebx,%eax
  803942:	f7 f7                	div    %edi
  803944:	31 ff                	xor    %edi,%edi
  803946:	89 fa                	mov    %edi,%edx
  803948:	83 c4 1c             	add    $0x1c,%esp
  80394b:	5b                   	pop    %ebx
  80394c:	5e                   	pop    %esi
  80394d:	5f                   	pop    %edi
  80394e:	5d                   	pop    %ebp
  80394f:	c3                   	ret    
  803950:	bd 20 00 00 00       	mov    $0x20,%ebp
  803955:	89 eb                	mov    %ebp,%ebx
  803957:	29 fb                	sub    %edi,%ebx
  803959:	89 f9                	mov    %edi,%ecx
  80395b:	d3 e6                	shl    %cl,%esi
  80395d:	89 c5                	mov    %eax,%ebp
  80395f:	88 d9                	mov    %bl,%cl
  803961:	d3 ed                	shr    %cl,%ebp
  803963:	89 e9                	mov    %ebp,%ecx
  803965:	09 f1                	or     %esi,%ecx
  803967:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80396b:	89 f9                	mov    %edi,%ecx
  80396d:	d3 e0                	shl    %cl,%eax
  80396f:	89 c5                	mov    %eax,%ebp
  803971:	89 d6                	mov    %edx,%esi
  803973:	88 d9                	mov    %bl,%cl
  803975:	d3 ee                	shr    %cl,%esi
  803977:	89 f9                	mov    %edi,%ecx
  803979:	d3 e2                	shl    %cl,%edx
  80397b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80397f:	88 d9                	mov    %bl,%cl
  803981:	d3 e8                	shr    %cl,%eax
  803983:	09 c2                	or     %eax,%edx
  803985:	89 d0                	mov    %edx,%eax
  803987:	89 f2                	mov    %esi,%edx
  803989:	f7 74 24 0c          	divl   0xc(%esp)
  80398d:	89 d6                	mov    %edx,%esi
  80398f:	89 c3                	mov    %eax,%ebx
  803991:	f7 e5                	mul    %ebp
  803993:	39 d6                	cmp    %edx,%esi
  803995:	72 19                	jb     8039b0 <__udivdi3+0xfc>
  803997:	74 0b                	je     8039a4 <__udivdi3+0xf0>
  803999:	89 d8                	mov    %ebx,%eax
  80399b:	31 ff                	xor    %edi,%edi
  80399d:	e9 58 ff ff ff       	jmp    8038fa <__udivdi3+0x46>
  8039a2:	66 90                	xchg   %ax,%ax
  8039a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039a8:	89 f9                	mov    %edi,%ecx
  8039aa:	d3 e2                	shl    %cl,%edx
  8039ac:	39 c2                	cmp    %eax,%edx
  8039ae:	73 e9                	jae    803999 <__udivdi3+0xe5>
  8039b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039b3:	31 ff                	xor    %edi,%edi
  8039b5:	e9 40 ff ff ff       	jmp    8038fa <__udivdi3+0x46>
  8039ba:	66 90                	xchg   %ax,%ax
  8039bc:	31 c0                	xor    %eax,%eax
  8039be:	e9 37 ff ff ff       	jmp    8038fa <__udivdi3+0x46>
  8039c3:	90                   	nop

008039c4 <__umoddi3>:
  8039c4:	55                   	push   %ebp
  8039c5:	57                   	push   %edi
  8039c6:	56                   	push   %esi
  8039c7:	53                   	push   %ebx
  8039c8:	83 ec 1c             	sub    $0x1c,%esp
  8039cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039e3:	89 f3                	mov    %esi,%ebx
  8039e5:	89 fa                	mov    %edi,%edx
  8039e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039eb:	89 34 24             	mov    %esi,(%esp)
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	75 1a                	jne    803a0c <__umoddi3+0x48>
  8039f2:	39 f7                	cmp    %esi,%edi
  8039f4:	0f 86 a2 00 00 00    	jbe    803a9c <__umoddi3+0xd8>
  8039fa:	89 c8                	mov    %ecx,%eax
  8039fc:	89 f2                	mov    %esi,%edx
  8039fe:	f7 f7                	div    %edi
  803a00:	89 d0                	mov    %edx,%eax
  803a02:	31 d2                	xor    %edx,%edx
  803a04:	83 c4 1c             	add    $0x1c,%esp
  803a07:	5b                   	pop    %ebx
  803a08:	5e                   	pop    %esi
  803a09:	5f                   	pop    %edi
  803a0a:	5d                   	pop    %ebp
  803a0b:	c3                   	ret    
  803a0c:	39 f0                	cmp    %esi,%eax
  803a0e:	0f 87 ac 00 00 00    	ja     803ac0 <__umoddi3+0xfc>
  803a14:	0f bd e8             	bsr    %eax,%ebp
  803a17:	83 f5 1f             	xor    $0x1f,%ebp
  803a1a:	0f 84 ac 00 00 00    	je     803acc <__umoddi3+0x108>
  803a20:	bf 20 00 00 00       	mov    $0x20,%edi
  803a25:	29 ef                	sub    %ebp,%edi
  803a27:	89 fe                	mov    %edi,%esi
  803a29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a2d:	89 e9                	mov    %ebp,%ecx
  803a2f:	d3 e0                	shl    %cl,%eax
  803a31:	89 d7                	mov    %edx,%edi
  803a33:	89 f1                	mov    %esi,%ecx
  803a35:	d3 ef                	shr    %cl,%edi
  803a37:	09 c7                	or     %eax,%edi
  803a39:	89 e9                	mov    %ebp,%ecx
  803a3b:	d3 e2                	shl    %cl,%edx
  803a3d:	89 14 24             	mov    %edx,(%esp)
  803a40:	89 d8                	mov    %ebx,%eax
  803a42:	d3 e0                	shl    %cl,%eax
  803a44:	89 c2                	mov    %eax,%edx
  803a46:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a4a:	d3 e0                	shl    %cl,%eax
  803a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a50:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a54:	89 f1                	mov    %esi,%ecx
  803a56:	d3 e8                	shr    %cl,%eax
  803a58:	09 d0                	or     %edx,%eax
  803a5a:	d3 eb                	shr    %cl,%ebx
  803a5c:	89 da                	mov    %ebx,%edx
  803a5e:	f7 f7                	div    %edi
  803a60:	89 d3                	mov    %edx,%ebx
  803a62:	f7 24 24             	mull   (%esp)
  803a65:	89 c6                	mov    %eax,%esi
  803a67:	89 d1                	mov    %edx,%ecx
  803a69:	39 d3                	cmp    %edx,%ebx
  803a6b:	0f 82 87 00 00 00    	jb     803af8 <__umoddi3+0x134>
  803a71:	0f 84 91 00 00 00    	je     803b08 <__umoddi3+0x144>
  803a77:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a7b:	29 f2                	sub    %esi,%edx
  803a7d:	19 cb                	sbb    %ecx,%ebx
  803a7f:	89 d8                	mov    %ebx,%eax
  803a81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a85:	d3 e0                	shl    %cl,%eax
  803a87:	89 e9                	mov    %ebp,%ecx
  803a89:	d3 ea                	shr    %cl,%edx
  803a8b:	09 d0                	or     %edx,%eax
  803a8d:	89 e9                	mov    %ebp,%ecx
  803a8f:	d3 eb                	shr    %cl,%ebx
  803a91:	89 da                	mov    %ebx,%edx
  803a93:	83 c4 1c             	add    $0x1c,%esp
  803a96:	5b                   	pop    %ebx
  803a97:	5e                   	pop    %esi
  803a98:	5f                   	pop    %edi
  803a99:	5d                   	pop    %ebp
  803a9a:	c3                   	ret    
  803a9b:	90                   	nop
  803a9c:	89 fd                	mov    %edi,%ebp
  803a9e:	85 ff                	test   %edi,%edi
  803aa0:	75 0b                	jne    803aad <__umoddi3+0xe9>
  803aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa7:	31 d2                	xor    %edx,%edx
  803aa9:	f7 f7                	div    %edi
  803aab:	89 c5                	mov    %eax,%ebp
  803aad:	89 f0                	mov    %esi,%eax
  803aaf:	31 d2                	xor    %edx,%edx
  803ab1:	f7 f5                	div    %ebp
  803ab3:	89 c8                	mov    %ecx,%eax
  803ab5:	f7 f5                	div    %ebp
  803ab7:	89 d0                	mov    %edx,%eax
  803ab9:	e9 44 ff ff ff       	jmp    803a02 <__umoddi3+0x3e>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	89 c8                	mov    %ecx,%eax
  803ac2:	89 f2                	mov    %esi,%edx
  803ac4:	83 c4 1c             	add    $0x1c,%esp
  803ac7:	5b                   	pop    %ebx
  803ac8:	5e                   	pop    %esi
  803ac9:	5f                   	pop    %edi
  803aca:	5d                   	pop    %ebp
  803acb:	c3                   	ret    
  803acc:	3b 04 24             	cmp    (%esp),%eax
  803acf:	72 06                	jb     803ad7 <__umoddi3+0x113>
  803ad1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ad5:	77 0f                	ja     803ae6 <__umoddi3+0x122>
  803ad7:	89 f2                	mov    %esi,%edx
  803ad9:	29 f9                	sub    %edi,%ecx
  803adb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803adf:	89 14 24             	mov    %edx,(%esp)
  803ae2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ae6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aea:	8b 14 24             	mov    (%esp),%edx
  803aed:	83 c4 1c             	add    $0x1c,%esp
  803af0:	5b                   	pop    %ebx
  803af1:	5e                   	pop    %esi
  803af2:	5f                   	pop    %edi
  803af3:	5d                   	pop    %ebp
  803af4:	c3                   	ret    
  803af5:	8d 76 00             	lea    0x0(%esi),%esi
  803af8:	2b 04 24             	sub    (%esp),%eax
  803afb:	19 fa                	sbb    %edi,%edx
  803afd:	89 d1                	mov    %edx,%ecx
  803aff:	89 c6                	mov    %eax,%esi
  803b01:	e9 71 ff ff ff       	jmp    803a77 <__umoddi3+0xb3>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b0c:	72 ea                	jb     803af8 <__umoddi3+0x134>
  803b0e:	89 d9                	mov    %ebx,%ecx
  803b10:	e9 62 ff ff ff       	jmp    803a77 <__umoddi3+0xb3>
