
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 ac 22 00 00       	call   8022fd <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 00 3c 80 00       	push   $0x803c00
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 1c 1d 00 00       	call   801dac <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 5a 21 00 00       	call   802210 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 6c 21 00 00       	call   802229 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 20 3c 80 00       	push   $0x803c20
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 43 3c 80 00       	push   $0x803c43
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 51 3c 80 00       	push   $0x803c51
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 60 3c 80 00       	push   $0x803c60
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 70 3c 80 00       	push   $0x803c70
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 ac 21 00 00       	call   802317 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 7c 3c 80 00       	push   $0x803c7c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 9e 3c 80 00       	push   $0x803c9e
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 bc 3c 80 00       	push   $0x803cbc
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 f0 3c 80 00       	push   $0x803cf0
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 24 3d 80 00       	push   $0x803d24
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 56 3d 80 00       	push   $0x803d56
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 e5 1b 00 00       	call   801e37 <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 6c 3d 80 00       	push   $0x803d6c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 9e 3c 80 00       	push   $0x803c9e
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 70 1f 00 00       	call   802210 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 82 1f 00 00       	call   802229 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 bc 3d 80 00       	push   $0x803dbc
  8002c5:	68 e1 3d 80 00       	push   $0x803de1
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 9e 3c 80 00       	push   $0x803c9e
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 6c 3d 80 00       	push   $0x803d6c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 9e 3c 80 00       	push   $0x803c9e
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 f8 1e 00 00       	call   802210 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 0a 1f 00 00       	call   802229 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 bc 3d 80 00       	push   $0x803dbc
  80033d:	68 e1 3d 80 00       	push   $0x803de1
  800342:	6a 77                	push   $0x77
  800344:	68 9e 3c 80 00       	push   $0x803c9e
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 6c 3d 80 00       	push   $0x803d6c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 9e 3c 80 00       	push   $0x803c9e
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 80 1e 00 00       	call   802210 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 92 1e 00 00       	call   802229 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 bc 3d 80 00       	push   $0x803dbc
  8003b1:	68 e1 3d 80 00       	push   $0x803de1
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 9e 3c 80 00       	push   $0x803c9e
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 33 1f 00 00       	call   8022fd <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 f6 3d 80 00       	push   $0x803df6
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 f4 1e 00 00       	call   802317 <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 14 3e 80 00       	push   $0x803e14
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 9e 3c 80 00       	push   $0x803c9e
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 42 3e 80 00       	push   $0x803e42
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 44 3e 80 00       	push   $0x803e44
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 49 3e 80 00       	push   $0x803e49
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 52 1b 00 00       	call   802331 <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 0d 1b 00 00       	call   8022fd <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 2e 1b 00 00       	call   802331 <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 0c 1b 00 00       	call   802317 <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 56 19 00 00       	call   802178 <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 c2 1a 00 00       	call   8022fd <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 2f 19 00 00       	call   802178 <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 c0 1a 00 00       	call   802317 <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 7f 1c 00 00       	call   8024f0 <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 21 1a 00 00       	call   8022fd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 68 3e 80 00       	push   $0x803e68
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 90 3e 80 00       	push   $0x803e90
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 b8 3e 80 00       	push   $0x803eb8
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 10 3f 80 00       	push   $0x803f10
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 68 3e 80 00       	push   $0x803e68
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 a1 19 00 00       	call   802317 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 2e 1b 00 00       	call   8024bc <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 83 1b 00 00       	call   802522 <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 24 3f 80 00       	push   $0x803f24
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 29 3f 80 00       	push   $0x803f29
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 45 3f 80 00       	push   $0x803f45
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 48 3f 80 00       	push   $0x803f48
  800a31:	6a 26                	push   $0x26
  800a33:	68 94 3f 80 00       	push   $0x803f94
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 a0 3f 80 00       	push   $0x803fa0
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 94 3f 80 00       	push   $0x803f94
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 f4 3f 80 00       	push   $0x803ff4
  800b73:	6a 44                	push   $0x44
  800b75:	68 94 3f 80 00       	push   $0x803f94
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 82 15 00 00       	call   80214f <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 0b 15 00 00       	call   80214f <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 6f 16 00 00       	call   8022fd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 69 16 00 00       	call   802317 <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 88 2c 00 00       	call   803980 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 48 2d 00 00       	call   803a90 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 54 42 80 00       	add    $0x804254,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 65 42 80 00       	push   $0x804265
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 6e 42 80 00       	push   $0x80426e
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be 71 42 80 00       	mov    $0x804271,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 d0 43 80 00       	push   $0x8043d0
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 d3 43 80 00       	push   $0x8043d3
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 1c 0f 00 00       	call   8022fd <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 d0 43 80 00       	push   $0x8043d0
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 d3 43 80 00       	push   $0x8043d3
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 da 0e 00 00       	call   802317 <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 42 0e 00 00       	call   802317 <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 e4 43 80 00       	push   $0x8043e4
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801c1d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c24:	00 00 00 
  801c27:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c2e:	00 00 00 
  801c31:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c38:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801c3b:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c42:	00 00 00 
  801c45:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c4c:	00 00 00 
  801c4f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c56:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801c59:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801c60:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801c63:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801c6a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c79:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c7e:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801c83:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c92:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	6a 06                	push   $0x6
  801c9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9f:	50                   	push   %eax
  801ca0:	e8 ee 05 00 00       	call   802293 <sys_allocate_chunk>
  801ca5:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ca8:	a1 20 51 80 00       	mov    0x805120,%eax
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	50                   	push   %eax
  801cb1:	e8 63 0c 00 00       	call   802919 <initialize_MemBlocksList>
  801cb6:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801cb9:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cce:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cdc:	89 c2                	mov    %eax,%edx
  801cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce1:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801cee:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cf8:	8b 50 08             	mov    0x8(%eax),%edx
  801cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfe:	01 d0                	add    %edx,%eax
  801d00:	48                   	dec    %eax
  801d01:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d07:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0c:	f7 75 e0             	divl   -0x20(%ebp)
  801d0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d12:	29 d0                	sub    %edx,%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d19:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801d1c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d20:	75 14                	jne    801d36 <initialize_dyn_block_system+0x11f>
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	68 09 44 80 00       	push   $0x804409
  801d2a:	6a 34                	push   $0x34
  801d2c:	68 27 44 80 00       	push   $0x804427
  801d31:	e8 6c ec ff ff       	call   8009a2 <_panic>
  801d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d39:	8b 00                	mov    (%eax),%eax
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	74 10                	je     801d4f <initialize_dyn_block_system+0x138>
  801d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d42:	8b 00                	mov    (%eax),%eax
  801d44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d47:	8b 52 04             	mov    0x4(%edx),%edx
  801d4a:	89 50 04             	mov    %edx,0x4(%eax)
  801d4d:	eb 0b                	jmp    801d5a <initialize_dyn_block_system+0x143>
  801d4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d52:	8b 40 04             	mov    0x4(%eax),%eax
  801d55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d5d:	8b 40 04             	mov    0x4(%eax),%eax
  801d60:	85 c0                	test   %eax,%eax
  801d62:	74 0f                	je     801d73 <initialize_dyn_block_system+0x15c>
  801d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d67:	8b 40 04             	mov    0x4(%eax),%eax
  801d6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d6d:	8b 12                	mov    (%edx),%edx
  801d6f:	89 10                	mov    %edx,(%eax)
  801d71:	eb 0a                	jmp    801d7d <initialize_dyn_block_system+0x166>
  801d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d76:	8b 00                	mov    (%eax),%eax
  801d78:	a3 48 51 80 00       	mov    %eax,0x805148
  801d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d90:	a1 54 51 80 00       	mov    0x805154,%eax
  801d95:	48                   	dec    %eax
  801d96:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 e8             	pushl  -0x18(%ebp)
  801da1:	e8 c4 13 00 00       	call   80316a <insert_sorted_with_merge_freeList>
  801da6:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801da9:	90                   	nop
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <malloc>:
//=================================



void* malloc(uint32 size)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801db2:	e8 2f fe ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dbb:	75 07                	jne    801dc4 <malloc+0x18>
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	eb 71                	jmp    801e35 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801dc4:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801dcb:	76 07                	jbe    801dd4 <malloc+0x28>
	return NULL;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	eb 61                	jmp    801e35 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dd4:	e8 88 08 00 00       	call   802661 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	74 53                	je     801e30 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801ddd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801de4:	8b 55 08             	mov    0x8(%ebp),%edx
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	01 d0                	add    %edx,%eax
  801dec:	48                   	dec    %eax
  801ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df3:	ba 00 00 00 00       	mov    $0x0,%edx
  801df8:	f7 75 f4             	divl   -0xc(%ebp)
  801dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfe:	29 d0                	sub    %edx,%eax
  801e00:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	ff 75 ec             	pushl  -0x14(%ebp)
  801e09:	e8 d2 0d 00 00       	call   802be0 <alloc_block_FF>
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801e14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e18:	74 16                	je     801e30 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	ff 75 e8             	pushl  -0x18(%ebp)
  801e20:	e8 0c 0c 00 00       	call   802a31 <insert_sorted_allocList>
  801e25:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e2b:	8b 40 08             	mov    0x8(%eax),%eax
  801e2e:	eb 05                	jmp    801e35 <malloc+0x89>
    }

			}


	return NULL;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801e4e:	83 ec 08             	sub    $0x8,%esp
  801e51:	ff 75 f0             	pushl  -0x10(%ebp)
  801e54:	68 40 50 80 00       	push   $0x805040
  801e59:	e8 a0 0b 00 00       	call   8029fe <find_block>
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e67:	8b 50 0c             	mov    0xc(%eax),%edx
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	52                   	push   %edx
  801e71:	50                   	push   %eax
  801e72:	e8 e4 03 00 00       	call   80225b <sys_free_user_mem>
  801e77:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801e7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e7e:	75 17                	jne    801e97 <free+0x60>
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	68 09 44 80 00       	push   $0x804409
  801e88:	68 84 00 00 00       	push   $0x84
  801e8d:	68 27 44 80 00       	push   $0x804427
  801e92:	e8 0b eb ff ff       	call   8009a2 <_panic>
  801e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9a:	8b 00                	mov    (%eax),%eax
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	74 10                	je     801eb0 <free+0x79>
  801ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea3:	8b 00                	mov    (%eax),%eax
  801ea5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea8:	8b 52 04             	mov    0x4(%edx),%edx
  801eab:	89 50 04             	mov    %edx,0x4(%eax)
  801eae:	eb 0b                	jmp    801ebb <free+0x84>
  801eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb3:	8b 40 04             	mov    0x4(%eax),%eax
  801eb6:	a3 44 50 80 00       	mov    %eax,0x805044
  801ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebe:	8b 40 04             	mov    0x4(%eax),%eax
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	74 0f                	je     801ed4 <free+0x9d>
  801ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec8:	8b 40 04             	mov    0x4(%eax),%eax
  801ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ece:	8b 12                	mov    (%edx),%edx
  801ed0:	89 10                	mov    %edx,(%eax)
  801ed2:	eb 0a                	jmp    801ede <free+0xa7>
  801ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed7:	8b 00                	mov    (%eax),%eax
  801ed9:	a3 40 50 80 00       	mov    %eax,0x805040
  801ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ef1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ef6:	48                   	dec    %eax
  801ef7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801efc:	83 ec 0c             	sub    $0xc,%esp
  801eff:	ff 75 ec             	pushl  -0x14(%ebp)
  801f02:	e8 63 12 00 00       	call   80316a <insert_sorted_with_merge_freeList>
  801f07:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801f0a:	90                   	nop
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 38             	sub    $0x38,%esp
  801f13:	8b 45 10             	mov    0x10(%ebp),%eax
  801f16:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f19:	e8 c8 fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f22:	75 0a                	jne    801f2e <smalloc+0x21>
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
  801f29:	e9 a0 00 00 00       	jmp    801fce <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801f2e:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801f35:	76 0a                	jbe    801f41 <smalloc+0x34>
		return NULL;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	e9 8d 00 00 00       	jmp    801fce <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f41:	e8 1b 07 00 00       	call   802661 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f46:	85 c0                	test   %eax,%eax
  801f48:	74 7f                	je     801fc9 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801f4a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	01 d0                	add    %edx,%eax
  801f59:	48                   	dec    %eax
  801f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	ba 00 00 00 00       	mov    $0x0,%edx
  801f65:	f7 75 f4             	divl   -0xc(%ebp)
  801f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6b:	29 d0                	sub    %edx,%eax
  801f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	ff 75 ec             	pushl  -0x14(%ebp)
  801f76:	e8 65 0c 00 00       	call   802be0 <alloc_block_FF>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801f81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f85:	74 42                	je     801fc9 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	ff 75 e8             	pushl  -0x18(%ebp)
  801f8d:	e8 9f 0a 00 00       	call   802a31 <insert_sorted_allocList>
  801f92:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f98:	8b 40 08             	mov    0x8(%eax),%eax
  801f9b:	89 c2                	mov    %eax,%edx
  801f9d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 38 04 00 00       	call   8023e6 <sys_createSharedObject>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801fb4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fb8:	79 07                	jns    801fc1 <smalloc+0xb4>
	    		  return NULL;
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbf:	eb 0d                	jmp    801fce <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc4:	8b 40 08             	mov    0x8(%eax),%eax
  801fc7:	eb 05                	jmp    801fce <smalloc+0xc1>


				}


		return NULL;
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fd6:	e8 0b fc ff ff       	call   801be6 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801fdb:	e8 81 06 00 00       	call   802661 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	0f 84 9f 00 00 00    	je     802087 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fe8:	83 ec 08             	sub    $0x8,%esp
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	e8 1a 04 00 00       	call   802410 <sys_getSizeOfSharedObject>
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802000:	79 0a                	jns    80200c <sget+0x3c>
		return NULL;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
  802007:	e9 80 00 00 00       	jmp    80208c <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80200c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802019:	01 d0                	add    %edx,%eax
  80201b:	48                   	dec    %eax
  80201c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80201f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802022:	ba 00 00 00 00       	mov    $0x0,%edx
  802027:	f7 75 f0             	divl   -0x10(%ebp)
  80202a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202d:	29 d0                	sub    %edx,%eax
  80202f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	ff 75 e8             	pushl  -0x18(%ebp)
  802038:	e8 a3 0b 00 00       	call   802be0 <alloc_block_FF>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  802043:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802047:	74 3e                	je     802087 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80204f:	e8 dd 09 00 00       	call   802a31 <insert_sorted_allocList>
  802054:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802057:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80205a:	8b 40 08             	mov    0x8(%eax),%eax
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	50                   	push   %eax
  802061:	ff 75 0c             	pushl  0xc(%ebp)
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	e8 c1 03 00 00       	call   80242d <sys_getSharedObject>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  802072:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802076:	79 07                	jns    80207f <sget+0xaf>
	    		  return NULL;
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	eb 0d                	jmp    80208c <sget+0xbc>
	  	return(void*) returned_block->sva;
  80207f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802082:	8b 40 08             	mov    0x8(%eax),%eax
  802085:	eb 05                	jmp    80208c <sget+0xbc>
	      }
	}
	   return NULL;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802094:	e8 4d fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	68 34 44 80 00       	push   $0x804434
  8020a1:	68 12 01 00 00       	push   $0x112
  8020a6:	68 27 44 80 00       	push   $0x804427
  8020ab:	e8 f2 e8 ff ff       	call   8009a2 <_panic>

008020b0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	68 5c 44 80 00       	push   $0x80445c
  8020be:	68 26 01 00 00       	push   $0x126
  8020c3:	68 27 44 80 00       	push   $0x804427
  8020c8:	e8 d5 e8 ff ff       	call   8009a2 <_panic>

008020cd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020d3:	83 ec 04             	sub    $0x4,%esp
  8020d6:	68 80 44 80 00       	push   $0x804480
  8020db:	68 31 01 00 00       	push   $0x131
  8020e0:	68 27 44 80 00       	push   $0x804427
  8020e5:	e8 b8 e8 ff ff       	call   8009a2 <_panic>

008020ea <shrink>:

}
void shrink(uint32 newSize)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	68 80 44 80 00       	push   $0x804480
  8020f8:	68 36 01 00 00       	push   $0x136
  8020fd:	68 27 44 80 00       	push   $0x804427
  802102:	e8 9b e8 ff ff       	call   8009a2 <_panic>

00802107 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	68 80 44 80 00       	push   $0x804480
  802115:	68 3b 01 00 00       	push   $0x13b
  80211a:	68 27 44 80 00       	push   $0x804427
  80211f:	e8 7e e8 ff ff       	call   8009a2 <_panic>

00802124 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	57                   	push   %edi
  802128:	56                   	push   %esi
  802129:	53                   	push   %ebx
  80212a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	8b 55 0c             	mov    0xc(%ebp),%edx
  802133:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802136:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802139:	8b 7d 18             	mov    0x18(%ebp),%edi
  80213c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80213f:	cd 30                	int    $0x30
  802141:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	5b                   	pop    %ebx
  80214b:	5e                   	pop    %esi
  80214c:	5f                   	pop    %edi
  80214d:	5d                   	pop    %ebp
  80214e:	c3                   	ret    

0080214f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	8b 45 10             	mov    0x10(%ebp),%eax
  802158:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80215b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	52                   	push   %edx
  802167:	ff 75 0c             	pushl  0xc(%ebp)
  80216a:	50                   	push   %eax
  80216b:	6a 00                	push   $0x0
  80216d:	e8 b2 ff ff ff       	call   802124 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	90                   	nop
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_cgetc>:

int
sys_cgetc(void)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 01                	push   $0x1
  802187:	e8 98 ff ff ff       	call   802124 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802194:	8b 55 0c             	mov    0xc(%ebp),%edx
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	52                   	push   %edx
  8021a1:	50                   	push   %eax
  8021a2:	6a 05                	push   $0x5
  8021a4:	e8 7b ff ff ff       	call   802124 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	56                   	push   %esi
  8021b2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8021b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	51                   	push   %ecx
  8021c5:	52                   	push   %edx
  8021c6:	50                   	push   %eax
  8021c7:	6a 06                	push   $0x6
  8021c9:	e8 56 ff ff ff       	call   802124 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d4:	5b                   	pop    %ebx
  8021d5:	5e                   	pop    %esi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	52                   	push   %edx
  8021e8:	50                   	push   %eax
  8021e9:	6a 07                	push   $0x7
  8021eb:	e8 34 ff ff ff       	call   802124 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	ff 75 0c             	pushl  0xc(%ebp)
  802201:	ff 75 08             	pushl  0x8(%ebp)
  802204:	6a 08                	push   $0x8
  802206:	e8 19 ff ff ff       	call   802124 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 09                	push   $0x9
  80221f:	e8 00 ff ff ff       	call   802124 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 0a                	push   $0xa
  802238:	e8 e7 fe ff ff       	call   802124 <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 0b                	push   $0xb
  802251:	e8 ce fe ff ff       	call   802124 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	ff 75 0c             	pushl  0xc(%ebp)
  802267:	ff 75 08             	pushl  0x8(%ebp)
  80226a:	6a 0f                	push   $0xf
  80226c:	e8 b3 fe ff ff       	call   802124 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
	return;
  802274:	90                   	nop
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	ff 75 08             	pushl  0x8(%ebp)
  802286:	6a 10                	push   $0x10
  802288:	e8 97 fe ff ff       	call   802124 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return ;
  802290:	90                   	nop
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 10             	pushl  0x10(%ebp)
  80229d:	ff 75 0c             	pushl  0xc(%ebp)
  8022a0:	ff 75 08             	pushl  0x8(%ebp)
  8022a3:	6a 11                	push   $0x11
  8022a5:	e8 7a fe ff ff       	call   802124 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ad:	90                   	nop
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 0c                	push   $0xc
  8022bf:	e8 60 fe ff ff       	call   802124 <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	ff 75 08             	pushl  0x8(%ebp)
  8022d7:	6a 0d                	push   $0xd
  8022d9:	e8 46 fe ff ff       	call   802124 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 0e                	push   $0xe
  8022f2:	e8 2d fe ff ff       	call   802124 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 13                	push   $0x13
  80230c:	e8 13 fe ff ff       	call   802124 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	90                   	nop
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 14                	push   $0x14
  802326:	e8 f9 fd ff ff       	call   802124 <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	90                   	nop
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_cputc>:


void
sys_cputc(const char c)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 04             	sub    $0x4,%esp
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80233d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	50                   	push   %eax
  80234a:	6a 15                	push   $0x15
  80234c:	e8 d3 fd ff ff       	call   802124 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	90                   	nop
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 16                	push   $0x16
  802366:	e8 b9 fd ff ff       	call   802124 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	90                   	nop
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	50                   	push   %eax
  802381:	6a 17                	push   $0x17
  802383:	e8 9c fd ff ff       	call   802124 <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802390:	8b 55 0c             	mov    0xc(%ebp),%edx
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	52                   	push   %edx
  80239d:	50                   	push   %eax
  80239e:	6a 1a                	push   $0x1a
  8023a0:	e8 7f fd ff ff       	call   802124 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	52                   	push   %edx
  8023ba:	50                   	push   %eax
  8023bb:	6a 18                	push   $0x18
  8023bd:	e8 62 fd ff ff       	call   802124 <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
}
  8023c5:	90                   	nop
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	52                   	push   %edx
  8023d8:	50                   	push   %eax
  8023d9:	6a 19                	push   $0x19
  8023db:	e8 44 fd ff ff       	call   802124 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	90                   	nop
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023f5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	6a 00                	push   $0x0
  8023fe:	51                   	push   %ecx
  8023ff:	52                   	push   %edx
  802400:	ff 75 0c             	pushl  0xc(%ebp)
  802403:	50                   	push   %eax
  802404:	6a 1b                	push   $0x1b
  802406:	e8 19 fd ff ff       	call   802124 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802413:	8b 55 0c             	mov    0xc(%ebp),%edx
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	52                   	push   %edx
  802420:	50                   	push   %eax
  802421:	6a 1c                	push   $0x1c
  802423:	e8 fc fc ff ff       	call   802124 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802430:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802433:	8b 55 0c             	mov    0xc(%ebp),%edx
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	51                   	push   %ecx
  80243e:	52                   	push   %edx
  80243f:	50                   	push   %eax
  802440:	6a 1d                	push   $0x1d
  802442:	e8 dd fc ff ff       	call   802124 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80244f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	52                   	push   %edx
  80245c:	50                   	push   %eax
  80245d:	6a 1e                	push   $0x1e
  80245f:	e8 c0 fc ff ff       	call   802124 <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 1f                	push   $0x1f
  802478:	e8 a7 fc ff ff       	call   802124 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	6a 00                	push   $0x0
  80248a:	ff 75 14             	pushl  0x14(%ebp)
  80248d:	ff 75 10             	pushl  0x10(%ebp)
  802490:	ff 75 0c             	pushl  0xc(%ebp)
  802493:	50                   	push   %eax
  802494:	6a 20                	push   $0x20
  802496:	e8 89 fc ff ff       	call   802124 <syscall>
  80249b:	83 c4 18             	add    $0x18,%esp
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	50                   	push   %eax
  8024af:	6a 21                	push   $0x21
  8024b1:	e8 6e fc ff ff       	call   802124 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
}
  8024b9:	90                   	nop
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	50                   	push   %eax
  8024cb:	6a 22                	push   $0x22
  8024cd:	e8 52 fc ff ff       	call   802124 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 02                	push   $0x2
  8024e6:	e8 39 fc ff ff       	call   802124 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 03                	push   $0x3
  8024ff:	e8 20 fc ff ff       	call   802124 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 04                	push   $0x4
  802518:	e8 07 fc ff ff       	call   802124 <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_exit_env>:


void sys_exit_env(void)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 23                	push   $0x23
  802531:	e8 ee fb ff ff       	call   802124 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	90                   	nop
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802542:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802545:	8d 50 04             	lea    0x4(%eax),%edx
  802548:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	52                   	push   %edx
  802552:	50                   	push   %eax
  802553:	6a 24                	push   $0x24
  802555:	e8 ca fb ff ff       	call   802124 <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
	return result;
  80255d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802563:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802566:	89 01                	mov    %eax,(%ecx)
  802568:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	c9                   	leave  
  80256f:	c2 04 00             	ret    $0x4

00802572 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	ff 75 10             	pushl  0x10(%ebp)
  80257c:	ff 75 0c             	pushl  0xc(%ebp)
  80257f:	ff 75 08             	pushl  0x8(%ebp)
  802582:	6a 12                	push   $0x12
  802584:	e8 9b fb ff ff       	call   802124 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
	return ;
  80258c:	90                   	nop
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_rcr2>:
uint32 sys_rcr2()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 25                	push   $0x25
  80259e:	e8 81 fb ff ff       	call   802124 <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	83 ec 04             	sub    $0x4,%esp
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	50                   	push   %eax
  8025c1:	6a 26                	push   $0x26
  8025c3:	e8 5c fb ff ff       	call   802124 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cb:	90                   	nop
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <rsttst>:
void rsttst()
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 28                	push   $0x28
  8025dd:	e8 42 fb ff ff       	call   802124 <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e5:	90                   	nop
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8025f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025fb:	52                   	push   %edx
  8025fc:	50                   	push   %eax
  8025fd:	ff 75 10             	pushl  0x10(%ebp)
  802600:	ff 75 0c             	pushl  0xc(%ebp)
  802603:	ff 75 08             	pushl  0x8(%ebp)
  802606:	6a 27                	push   $0x27
  802608:	e8 17 fb ff ff       	call   802124 <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
	return ;
  802610:	90                   	nop
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <chktst>:
void chktst(uint32 n)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	6a 29                	push   $0x29
  802623:	e8 fc fa ff ff       	call   802124 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
	return ;
  80262b:	90                   	nop
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <inctst>:

void inctst()
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 2a                	push   $0x2a
  80263d:	e8 e2 fa ff ff       	call   802124 <syscall>
  802642:	83 c4 18             	add    $0x18,%esp
	return ;
  802645:	90                   	nop
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <gettst>:
uint32 gettst()
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 2b                	push   $0x2b
  802657:	e8 c8 fa ff ff       	call   802124 <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
}
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 2c                	push   $0x2c
  802673:	e8 ac fa ff ff       	call   802124 <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
  80267b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80267e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802682:	75 07                	jne    80268b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802684:	b8 01 00 00 00       	mov    $0x1,%eax
  802689:	eb 05                	jmp    802690 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80268b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 2c                	push   $0x2c
  8026a4:	e8 7b fa ff ff       	call   802124 <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
  8026ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026af:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026b3:	75 07                	jne    8026bc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ba:	eb 05                	jmp    8026c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 2c                	push   $0x2c
  8026d5:	e8 4a fa ff ff       	call   802124 <syscall>
  8026da:	83 c4 18             	add    $0x18,%esp
  8026dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026e0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026e4:	75 07                	jne    8026ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026eb:	eb 05                	jmp    8026f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    

008026f4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 2c                	push   $0x2c
  802706:	e8 19 fa ff ff       	call   802124 <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
  80270e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802711:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802715:	75 07                	jne    80271e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802717:	b8 01 00 00 00       	mov    $0x1,%eax
  80271c:	eb 05                	jmp    802723 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80271e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	ff 75 08             	pushl  0x8(%ebp)
  802733:	6a 2d                	push   $0x2d
  802735:	e8 ea f9 ff ff       	call   802124 <syscall>
  80273a:	83 c4 18             	add    $0x18,%esp
	return ;
  80273d:	90                   	nop
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802744:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	6a 00                	push   $0x0
  802752:	53                   	push   %ebx
  802753:	51                   	push   %ecx
  802754:	52                   	push   %edx
  802755:	50                   	push   %eax
  802756:	6a 2e                	push   $0x2e
  802758:	e8 c7 f9 ff ff       	call   802124 <syscall>
  80275d:	83 c4 18             	add    $0x18,%esp
}
  802760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	52                   	push   %edx
  802775:	50                   	push   %eax
  802776:	6a 2f                	push   $0x2f
  802778:	e8 a7 f9 ff ff       	call   802124 <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	68 90 44 80 00       	push   $0x804490
  802790:	e8 c1 e4 ff ff       	call   800c56 <cprintf>
  802795:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802798:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80279f:	83 ec 0c             	sub    $0xc,%esp
  8027a2:	68 bc 44 80 00       	push   $0x8044bc
  8027a7:	e8 aa e4 ff ff       	call   800c56 <cprintf>
  8027ac:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027af:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bb:	eb 56                	jmp    802813 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c1:	74 1c                	je     8027df <print_mem_block_lists+0x5d>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 50 08             	mov    0x8(%eax),%edx
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 48 08             	mov    0x8(%eax),%ecx
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	01 c8                	add    %ecx,%eax
  8027d7:	39 c2                	cmp    %eax,%edx
  8027d9:	73 04                	jae    8027df <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027db:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 50 08             	mov    0x8(%eax),%edx
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	01 c2                	add    %eax,%edx
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	52                   	push   %edx
  8027f7:	50                   	push   %eax
  8027f8:	68 d1 44 80 00       	push   $0x8044d1
  8027fd:	e8 54 e4 ff ff       	call   800c56 <cprintf>
  802802:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80280b:	a1 40 51 80 00       	mov    0x805140,%eax
  802810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802817:	74 07                	je     802820 <print_mem_block_lists+0x9e>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	eb 05                	jmp    802825 <print_mem_block_lists+0xa3>
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
  802825:	a3 40 51 80 00       	mov    %eax,0x805140
  80282a:	a1 40 51 80 00       	mov    0x805140,%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	75 8a                	jne    8027bd <print_mem_block_lists+0x3b>
  802833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802837:	75 84                	jne    8027bd <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802839:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80283d:	75 10                	jne    80284f <print_mem_block_lists+0xcd>
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	68 e0 44 80 00       	push   $0x8044e0
  802847:	e8 0a e4 ff ff       	call   800c56 <cprintf>
  80284c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80284f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	68 04 45 80 00       	push   $0x804504
  80285e:	e8 f3 e3 ff ff       	call   800c56 <cprintf>
  802863:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802866:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80286a:	a1 40 50 80 00       	mov    0x805040,%eax
  80286f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802872:	eb 56                	jmp    8028ca <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802878:	74 1c                	je     802896 <print_mem_block_lists+0x114>
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 50 08             	mov    0x8(%eax),%edx
  802880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802883:	8b 48 08             	mov    0x8(%eax),%ecx
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 40 0c             	mov    0xc(%eax),%eax
  80288c:	01 c8                	add    %ecx,%eax
  80288e:	39 c2                	cmp    %eax,%edx
  802890:	73 04                	jae    802896 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802892:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 50 08             	mov    0x8(%eax),%edx
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a2:	01 c2                	add    %eax,%edx
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 08             	mov    0x8(%eax),%eax
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	52                   	push   %edx
  8028ae:	50                   	push   %eax
  8028af:	68 d1 44 80 00       	push   $0x8044d1
  8028b4:	e8 9d e3 ff ff       	call   800c56 <cprintf>
  8028b9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	74 07                	je     8028d7 <print_mem_block_lists+0x155>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	eb 05                	jmp    8028dc <print_mem_block_lists+0x15a>
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028dc:	a3 48 50 80 00       	mov    %eax,0x805048
  8028e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	75 8a                	jne    802874 <print_mem_block_lists+0xf2>
  8028ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ee:	75 84                	jne    802874 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028f0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028f4:	75 10                	jne    802906 <print_mem_block_lists+0x184>
  8028f6:	83 ec 0c             	sub    $0xc,%esp
  8028f9:	68 1c 45 80 00       	push   $0x80451c
  8028fe:	e8 53 e3 ff ff       	call   800c56 <cprintf>
  802903:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802906:	83 ec 0c             	sub    $0xc,%esp
  802909:	68 90 44 80 00       	push   $0x804490
  80290e:	e8 43 e3 ff ff       	call   800c56 <cprintf>
  802913:	83 c4 10             	add    $0x10,%esp

}
  802916:	90                   	nop
  802917:	c9                   	leave  
  802918:	c3                   	ret    

00802919 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80291f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802926:	00 00 00 
  802929:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802930:	00 00 00 
  802933:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80293a:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80293d:	a1 50 50 80 00       	mov    0x805050,%eax
  802942:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80294c:	e9 9e 00 00 00       	jmp    8029ef <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802951:	a1 50 50 80 00       	mov    0x805050,%eax
  802956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802959:	c1 e2 04             	shl    $0x4,%edx
  80295c:	01 d0                	add    %edx,%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	75 14                	jne    802976 <initialize_MemBlocksList+0x5d>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 44 45 80 00       	push   $0x804544
  80296a:	6a 48                	push   $0x48
  80296c:	68 67 45 80 00       	push   $0x804567
  802971:	e8 2c e0 ff ff       	call   8009a2 <_panic>
  802976:	a1 50 50 80 00       	mov    0x805050,%eax
  80297b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297e:	c1 e2 04             	shl    $0x4,%edx
  802981:	01 d0                	add    %edx,%eax
  802983:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802989:	89 10                	mov    %edx,(%eax)
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 18                	je     8029a9 <initialize_MemBlocksList+0x90>
  802991:	a1 48 51 80 00       	mov    0x805148,%eax
  802996:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80299c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80299f:	c1 e1 04             	shl    $0x4,%ecx
  8029a2:	01 ca                	add    %ecx,%edx
  8029a4:	89 50 04             	mov    %edx,0x4(%eax)
  8029a7:	eb 12                	jmp    8029bb <initialize_MemBlocksList+0xa2>
  8029a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8029ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b1:	c1 e2 04             	shl    $0x4,%edx
  8029b4:	01 d0                	add    %edx,%eax
  8029b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8029c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c3:	c1 e2 04             	shl    $0x4,%edx
  8029c6:	01 d0                	add    %edx,%eax
  8029c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8029cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8029d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d5:	c1 e2 04             	shl    $0x4,%edx
  8029d8:	01 d0                	add    %edx,%eax
  8029da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e6:	40                   	inc    %eax
  8029e7:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8029ec:	ff 45 f4             	incl   -0xc(%ebp)
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 82 56 ff ff ff    	jb     802951 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8029fb:	90                   	nop
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
  802a01:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802a0c:	eb 18                	jmp    802a26 <find_block+0x28>
		{
			if(tmp->sva==va)
  802a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a11:	8b 40 08             	mov    0x8(%eax),%eax
  802a14:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a17:	75 05                	jne    802a1e <find_block+0x20>
			{
				return tmp;
  802a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a1c:	eb 11                	jmp    802a2f <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a2a:	75 e2                	jne    802a0e <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802a2f:	c9                   	leave  
  802a30:	c3                   	ret    

00802a31 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a31:	55                   	push   %ebp
  802a32:	89 e5                	mov    %esp,%ebp
  802a34:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802a37:	a1 40 50 80 00       	mov    0x805040,%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	0f 85 83 00 00 00    	jne    802ac7 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802a44:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802a4b:	00 00 00 
  802a4e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802a55:	00 00 00 
  802a58:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802a5f:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802a62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a66:	75 14                	jne    802a7c <insert_sorted_allocList+0x4b>
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	68 44 45 80 00       	push   $0x804544
  802a70:	6a 7f                	push   $0x7f
  802a72:	68 67 45 80 00       	push   $0x804567
  802a77:	e8 26 df ff ff       	call   8009a2 <_panic>
  802a7c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0d                	je     802a9d <insert_sorted_allocList+0x6c>
  802a90:	a1 40 50 80 00       	mov    0x805040,%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 08                	jmp    802aa5 <insert_sorted_allocList+0x74>
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	a3 44 50 80 00       	mov    %eax,0x805044
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	a3 40 50 80 00       	mov    %eax,0x805040
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ac2:	e9 16 01 00 00       	jmp    802bdd <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	a1 44 50 80 00       	mov    0x805044,%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	76 68                	jbe    802b41 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802ad9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802add:	75 17                	jne    802af6 <insert_sorted_allocList+0xc5>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 80 45 80 00       	push   $0x804580
  802ae7:	68 85 00 00 00       	push   $0x85
  802aec:	68 67 45 80 00       	push   $0x804567
  802af1:	e8 ac de ff ff       	call   8009a2 <_panic>
  802af6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 0c                	je     802b18 <insert_sorted_allocList+0xe7>
  802b0c:	a1 44 50 80 00       	mov    0x805044,%eax
  802b11:	8b 55 08             	mov    0x8(%ebp),%edx
  802b14:	89 10                	mov    %edx,(%eax)
  802b16:	eb 08                	jmp    802b20 <insert_sorted_allocList+0xef>
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	a3 40 50 80 00       	mov    %eax,0x805040
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	a3 44 50 80 00       	mov    %eax,0x805044
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b31:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b36:	40                   	inc    %eax
  802b37:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802b3c:	e9 9c 00 00 00       	jmp    802bdd <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802b41:	a1 40 50 80 00       	mov    0x805040,%eax
  802b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802b49:	e9 85 00 00 00       	jmp    802bd3 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	8b 50 08             	mov    0x8(%eax),%edx
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 08             	mov    0x8(%eax),%eax
  802b5a:	39 c2                	cmp    %eax,%edx
  802b5c:	73 6d                	jae    802bcb <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802b5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b62:	74 06                	je     802b6a <insert_sorted_allocList+0x139>
  802b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b68:	75 17                	jne    802b81 <insert_sorted_allocList+0x150>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 a4 45 80 00       	push   $0x8045a4
  802b72:	68 90 00 00 00       	push   $0x90
  802b77:	68 67 45 80 00       	push   $0x804567
  802b7c:	e8 21 de ff ff       	call   8009a2 <_panic>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 50 04             	mov    0x4(%eax),%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	74 0d                	je     802bac <insert_sorted_allocList+0x17b>
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	eb 08                	jmp    802bb4 <insert_sorted_allocList+0x183>
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	a3 40 50 80 00       	mov    %eax,0x805040
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc2:	40                   	inc    %eax
  802bc3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bc8:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802bc9:	eb 12                	jmp    802bdd <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd7:	0f 85 71 ff ff ff    	jne    802b4e <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802bdd:	90                   	nop
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802be6:	a1 38 51 80 00       	mov    0x805138,%eax
  802beb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802bee:	e9 76 01 00 00       	jmp    802d69 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfc:	0f 85 8a 00 00 00    	jne    802c8c <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c06:	75 17                	jne    802c1f <alloc_block_FF+0x3f>
  802c08:	83 ec 04             	sub    $0x4,%esp
  802c0b:	68 d9 45 80 00       	push   $0x8045d9
  802c10:	68 a8 00 00 00       	push   $0xa8
  802c15:	68 67 45 80 00       	push   $0x804567
  802c1a:	e8 83 dd ff ff       	call   8009a2 <_panic>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 10                	je     802c38 <alloc_block_FF+0x58>
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c30:	8b 52 04             	mov    0x4(%edx),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	eb 0b                	jmp    802c43 <alloc_block_FF+0x63>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0f                	je     802c5c <alloc_block_FF+0x7c>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c56:	8b 12                	mov    (%edx),%edx
  802c58:	89 10                	mov    %edx,(%eax)
  802c5a:	eb 0a                	jmp    802c66 <alloc_block_FF+0x86>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	a3 38 51 80 00       	mov    %eax,0x805138
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c79:	a1 44 51 80 00       	mov    0x805144,%eax
  802c7e:	48                   	dec    %eax
  802c7f:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	e9 ea 00 00 00       	jmp    802d76 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c95:	0f 86 c6 00 00 00    	jbe    802d61 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802c9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca9:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 50 08             	mov    0x8(%eax),%edx
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	2b 45 08             	sub    0x8(%ebp),%eax
  802cc1:	89 c2                	mov    %eax,%edx
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 50 08             	mov    0x8(%eax),%edx
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	01 c2                	add    %eax,%edx
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802cda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cde:	75 17                	jne    802cf7 <alloc_block_FF+0x117>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 d9 45 80 00       	push   $0x8045d9
  802ce8:	68 b6 00 00 00       	push   $0xb6
  802ced:	68 67 45 80 00       	push   $0x804567
  802cf2:	e8 ab dc ff ff       	call   8009a2 <_panic>
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 10                	je     802d10 <alloc_block_FF+0x130>
  802d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d08:	8b 52 04             	mov    0x4(%edx),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 0b                	jmp    802d1b <alloc_block_FF+0x13b>
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0f                	je     802d34 <alloc_block_FF+0x154>
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2e:	8b 12                	mov    (%edx),%edx
  802d30:	89 10                	mov    %edx,(%eax)
  802d32:	eb 0a                	jmp    802d3e <alloc_block_FF+0x15e>
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	a3 48 51 80 00       	mov    %eax,0x805148
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d51:	a1 54 51 80 00       	mov    0x805154,%eax
  802d56:	48                   	dec    %eax
  802d57:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	eb 15                	jmp    802d76 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	0f 85 80 fe ff ff    	jne    802bf3 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802d76:	c9                   	leave  
  802d77:	c3                   	ret    

00802d78 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d78:	55                   	push   %ebp
  802d79:	89 e5                	mov    %esp,%ebp
  802d7b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802d7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802d86:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802d8d:	e9 c0 00 00 00       	jmp    802e52 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 40 0c             	mov    0xc(%eax),%eax
  802d98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9b:	0f 85 8a 00 00 00    	jne    802e2b <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da5:	75 17                	jne    802dbe <alloc_block_BF+0x46>
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	68 d9 45 80 00       	push   $0x8045d9
  802daf:	68 cf 00 00 00       	push   $0xcf
  802db4:	68 67 45 80 00       	push   $0x804567
  802db9:	e8 e4 db ff ff       	call   8009a2 <_panic>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	74 10                	je     802dd7 <alloc_block_BF+0x5f>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dcf:	8b 52 04             	mov    0x4(%edx),%edx
  802dd2:	89 50 04             	mov    %edx,0x4(%eax)
  802dd5:	eb 0b                	jmp    802de2 <alloc_block_BF+0x6a>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 0f                	je     802dfb <alloc_block_BF+0x83>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df5:	8b 12                	mov    (%edx),%edx
  802df7:	89 10                	mov    %edx,(%eax)
  802df9:	eb 0a                	jmp    802e05 <alloc_block_BF+0x8d>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	a3 38 51 80 00       	mov    %eax,0x805138
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e18:	a1 44 51 80 00       	mov    0x805144,%eax
  802e1d:	48                   	dec    %eax
  802e1e:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	e9 2a 01 00 00       	jmp    802f55 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e34:	73 14                	jae    802e4a <alloc_block_BF+0xd2>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e3f:	76 09                	jbe    802e4a <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 40 0c             	mov    0xc(%eax),%eax
  802e47:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802e52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e56:	0f 85 36 ff ff ff    	jne    802d92 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802e5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802e64:	e9 dd 00 00 00       	jmp    802f46 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e72:	0f 85 c6 00 00 00    	jne    802f3e <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802e78:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7d:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 50 08             	mov    0x8(%eax),%edx
  802e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e89:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e92:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	01 c2                	add    %eax,%edx
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eac:	2b 45 08             	sub    0x8(%ebp),%eax
  802eaf:	89 c2                	mov    %eax,%edx
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802eb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ebb:	75 17                	jne    802ed4 <alloc_block_BF+0x15c>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 d9 45 80 00       	push   $0x8045d9
  802ec5:	68 eb 00 00 00       	push   $0xeb
  802eca:	68 67 45 80 00       	push   $0x804567
  802ecf:	e8 ce da ff ff       	call   8009a2 <_panic>
  802ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 10                	je     802eed <alloc_block_BF+0x175>
  802edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee5:	8b 52 04             	mov    0x4(%edx),%edx
  802ee8:	89 50 04             	mov    %edx,0x4(%eax)
  802eeb:	eb 0b                	jmp    802ef8 <alloc_block_BF+0x180>
  802eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 0f                	je     802f11 <alloc_block_BF+0x199>
  802f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f0b:	8b 12                	mov    (%edx),%edx
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	eb 0a                	jmp    802f1b <alloc_block_BF+0x1a3>
  802f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f33:	48                   	dec    %eax
  802f34:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3c:	eb 17                	jmp    802f55 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4a:	0f 85 19 ff ff ff    	jne    802e69 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802f50:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802f55:	c9                   	leave  
  802f56:	c3                   	ret    

00802f57 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802f57:	55                   	push   %ebp
  802f58:	89 e5                	mov    %esp,%ebp
  802f5a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802f5d:	a1 40 50 80 00       	mov    0x805040,%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	75 19                	jne    802f7f <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802f66:	83 ec 0c             	sub    $0xc,%esp
  802f69:	ff 75 08             	pushl  0x8(%ebp)
  802f6c:	e8 6f fc ff ff       	call   802be0 <alloc_block_FF>
  802f71:	83 c4 10             	add    $0x10,%esp
  802f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	e9 e9 01 00 00       	jmp    803168 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802f7f:	a1 44 50 80 00       	mov    0x805044,%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802f8a:	a1 44 50 80 00       	mov    0x805044,%eax
  802f8f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f92:	a1 44 50 80 00       	mov    0x805044,%eax
  802f97:	8b 40 08             	mov    0x8(%eax),%eax
  802f9a:	01 d0                	add    %edx,%eax
  802f9c:	83 ec 08             	sub    $0x8,%esp
  802f9f:	50                   	push   %eax
  802fa0:	68 38 51 80 00       	push   $0x805138
  802fa5:	e8 54 fa ff ff       	call   8029fe <find_block>
  802faa:	83 c4 10             	add    $0x10,%esp
  802fad:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb9:	0f 85 9b 00 00 00    	jne    80305a <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 40 08             	mov    0x8(%eax),%eax
  802fcb:	01 d0                	add    %edx,%eax
  802fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd4:	75 17                	jne    802fed <alloc_block_NF+0x96>
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	68 d9 45 80 00       	push   $0x8045d9
  802fde:	68 1a 01 00 00       	push   $0x11a
  802fe3:	68 67 45 80 00       	push   $0x804567
  802fe8:	e8 b5 d9 ff ff       	call   8009a2 <_panic>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 10                	je     803006 <alloc_block_NF+0xaf>
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffe:	8b 52 04             	mov    0x4(%edx),%edx
  803001:	89 50 04             	mov    %edx,0x4(%eax)
  803004:	eb 0b                	jmp    803011 <alloc_block_NF+0xba>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 04             	mov    0x4(%eax),%eax
  80300c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0f                	je     80302a <alloc_block_NF+0xd3>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803024:	8b 12                	mov    (%edx),%edx
  803026:	89 10                	mov    %edx,(%eax)
  803028:	eb 0a                	jmp    803034 <alloc_block_NF+0xdd>
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	a3 38 51 80 00       	mov    %eax,0x805138
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803047:	a1 44 51 80 00       	mov    0x805144,%eax
  80304c:	48                   	dec    %eax
  80304d:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	e9 0e 01 00 00       	jmp    803168 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 40 0c             	mov    0xc(%eax),%eax
  803060:	3b 45 08             	cmp    0x8(%ebp),%eax
  803063:	0f 86 cf 00 00 00    	jbe    803138 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803069:	a1 48 51 80 00       	mov    0x805148,%eax
  80306e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  803071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803074:	8b 55 08             	mov    0x8(%ebp),%edx
  803077:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 50 08             	mov    0x8(%eax),%edx
  803080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803083:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 50 08             	mov    0x8(%eax),%edx
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	01 c2                	add    %eax,%edx
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 0c             	mov    0xc(%eax),%eax
  80309d:	2b 45 08             	sub    0x8(%ebp),%eax
  8030a0:	89 c2                	mov    %eax,%edx
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 08             	mov    0x8(%eax),%eax
  8030ae:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8030b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b5:	75 17                	jne    8030ce <alloc_block_NF+0x177>
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	68 d9 45 80 00       	push   $0x8045d9
  8030bf:	68 28 01 00 00       	push   $0x128
  8030c4:	68 67 45 80 00       	push   $0x804567
  8030c9:	e8 d4 d8 ff ff       	call   8009a2 <_panic>
  8030ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 10                	je     8030e7 <alloc_block_NF+0x190>
  8030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030df:	8b 52 04             	mov    0x4(%edx),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	eb 0b                	jmp    8030f2 <alloc_block_NF+0x19b>
  8030e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ea:	8b 40 04             	mov    0x4(%eax),%eax
  8030ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f5:	8b 40 04             	mov    0x4(%eax),%eax
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	74 0f                	je     80310b <alloc_block_NF+0x1b4>
  8030fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803105:	8b 12                	mov    (%edx),%edx
  803107:	89 10                	mov    %edx,(%eax)
  803109:	eb 0a                	jmp    803115 <alloc_block_NF+0x1be>
  80310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	a3 48 51 80 00       	mov    %eax,0x805148
  803115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803118:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803121:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803128:	a1 54 51 80 00       	mov    0x805154,%eax
  80312d:	48                   	dec    %eax
  80312e:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803136:	eb 30                	jmp    803168 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803138:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80313d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803140:	75 0a                	jne    80314c <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803142:	a1 38 51 80 00       	mov    0x805138,%eax
  803147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314a:	eb 08                	jmp    803154 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 40 08             	mov    0x8(%eax),%eax
  80315a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80315d:	0f 85 4d fe ff ff    	jne    802fb0 <alloc_block_NF+0x59>

			return NULL;
  803163:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
  80316d:	53                   	push   %ebx
  80316e:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  803171:	a1 38 51 80 00       	mov    0x805138,%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	0f 85 86 00 00 00    	jne    803204 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80317e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803185:	00 00 00 
  803188:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80318f:	00 00 00 
  803192:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803199:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80319c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0x4f>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 44 45 80 00       	push   $0x804544
  8031aa:	68 48 01 00 00       	push   $0x148
  8031af:	68 67 45 80 00       	push   $0x804567
  8031b4:	e8 e9 d7 ff ff       	call   8009a2 <_panic>
  8031b9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0d                	je     8031da <insert_sorted_with_merge_freeList+0x70>
  8031cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 08                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x78>
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8031ff:	e9 73 07 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 50 08             	mov    0x8(%eax),%edx
  80320a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80320f:	8b 40 08             	mov    0x8(%eax),%eax
  803212:	39 c2                	cmp    %eax,%edx
  803214:	0f 86 84 00 00 00    	jbe    80329e <insert_sorted_with_merge_freeList+0x134>
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	8b 50 08             	mov    0x8(%eax),%edx
  803220:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803225:	8b 48 0c             	mov    0xc(%eax),%ecx
  803228:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80322d:	8b 40 08             	mov    0x8(%eax),%eax
  803230:	01 c8                	add    %ecx,%eax
  803232:	39 c2                	cmp    %eax,%edx
  803234:	74 68                	je     80329e <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323a:	75 17                	jne    803253 <insert_sorted_with_merge_freeList+0xe9>
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	68 80 45 80 00       	push   $0x804580
  803244:	68 4c 01 00 00       	push   $0x14c
  803249:	68 67 45 80 00       	push   $0x804567
  80324e:	e8 4f d7 ff ff       	call   8009a2 <_panic>
  803253:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	89 50 04             	mov    %edx,0x4(%eax)
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	8b 40 04             	mov    0x4(%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 0c                	je     803275 <insert_sorted_with_merge_freeList+0x10b>
  803269:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80326e:	8b 55 08             	mov    0x8(%ebp),%edx
  803271:	89 10                	mov    %edx,(%eax)
  803273:	eb 08                	jmp    80327d <insert_sorted_with_merge_freeList+0x113>
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	a3 38 51 80 00       	mov    %eax,0x805138
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328e:	a1 44 51 80 00       	mov    0x805144,%eax
  803293:	40                   	inc    %eax
  803294:	a3 44 51 80 00       	mov    %eax,0x805144
  803299:	e9 d9 06 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	8b 50 08             	mov    0x8(%eax),%edx
  8032a4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032a9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ac:	39 c2                	cmp    %eax,%edx
  8032ae:	0f 86 b5 00 00 00    	jbe    803369 <insert_sorted_with_merge_freeList+0x1ff>
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	8b 50 08             	mov    0x8(%eax),%edx
  8032ba:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032bf:	8b 48 0c             	mov    0xc(%eax),%ecx
  8032c2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032c7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ca:	01 c8                	add    %ecx,%eax
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	0f 85 95 00 00 00    	jne    803369 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8032d4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032d9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032df:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8032e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8032e8:	01 ca                	add    %ecx,%edx
  8032ea:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803305:	75 17                	jne    80331e <insert_sorted_with_merge_freeList+0x1b4>
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	68 44 45 80 00       	push   $0x804544
  80330f:	68 54 01 00 00       	push   $0x154
  803314:	68 67 45 80 00       	push   $0x804567
  803319:	e8 84 d6 ff ff       	call   8009a2 <_panic>
  80331e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	89 10                	mov    %edx,(%eax)
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	85 c0                	test   %eax,%eax
  803330:	74 0d                	je     80333f <insert_sorted_with_merge_freeList+0x1d5>
  803332:	a1 48 51 80 00       	mov    0x805148,%eax
  803337:	8b 55 08             	mov    0x8(%ebp),%edx
  80333a:	89 50 04             	mov    %edx,0x4(%eax)
  80333d:	eb 08                	jmp    803347 <insert_sorted_with_merge_freeList+0x1dd>
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	a3 48 51 80 00       	mov    %eax,0x805148
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803359:	a1 54 51 80 00       	mov    0x805154,%eax
  80335e:	40                   	inc    %eax
  80335f:	a3 54 51 80 00       	mov    %eax,0x805154
  803364:	e9 0e 06 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	8b 50 08             	mov    0x8(%eax),%edx
  80336f:	a1 38 51 80 00       	mov    0x805138,%eax
  803374:	8b 40 08             	mov    0x8(%eax),%eax
  803377:	39 c2                	cmp    %eax,%edx
  803379:	0f 83 c1 00 00 00    	jae    803440 <insert_sorted_with_merge_freeList+0x2d6>
  80337f:	a1 38 51 80 00       	mov    0x805138,%eax
  803384:	8b 50 08             	mov    0x8(%eax),%edx
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	8b 48 08             	mov    0x8(%eax),%ecx
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	8b 40 0c             	mov    0xc(%eax),%eax
  803393:	01 c8                	add    %ecx,%eax
  803395:	39 c2                	cmp    %eax,%edx
  803397:	0f 85 a3 00 00 00    	jne    803440 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80339d:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a5:	8b 52 08             	mov    0x8(%edx),%edx
  8033a8:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8033ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033b6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8033bf:	01 ca                	add    %ecx,%edx
  8033c1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033dc:	75 17                	jne    8033f5 <insert_sorted_with_merge_freeList+0x28b>
  8033de:	83 ec 04             	sub    $0x4,%esp
  8033e1:	68 44 45 80 00       	push   $0x804544
  8033e6:	68 5d 01 00 00       	push   $0x15d
  8033eb:	68 67 45 80 00       	push   $0x804567
  8033f0:	e8 ad d5 ff ff       	call   8009a2 <_panic>
  8033f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	74 0d                	je     803416 <insert_sorted_with_merge_freeList+0x2ac>
  803409:	a1 48 51 80 00       	mov    0x805148,%eax
  80340e:	8b 55 08             	mov    0x8(%ebp),%edx
  803411:	89 50 04             	mov    %edx,0x4(%eax)
  803414:	eb 08                	jmp    80341e <insert_sorted_with_merge_freeList+0x2b4>
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	a3 48 51 80 00       	mov    %eax,0x805148
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803430:	a1 54 51 80 00       	mov    0x805154,%eax
  803435:	40                   	inc    %eax
  803436:	a3 54 51 80 00       	mov    %eax,0x805154
  80343b:	e9 37 05 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 50 08             	mov    0x8(%eax),%edx
  803446:	a1 38 51 80 00       	mov    0x805138,%eax
  80344b:	8b 40 08             	mov    0x8(%eax),%eax
  80344e:	39 c2                	cmp    %eax,%edx
  803450:	0f 83 82 00 00 00    	jae    8034d8 <insert_sorted_with_merge_freeList+0x36e>
  803456:	a1 38 51 80 00       	mov    0x805138,%eax
  80345b:	8b 50 08             	mov    0x8(%eax),%edx
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	8b 48 08             	mov    0x8(%eax),%ecx
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	8b 40 0c             	mov    0xc(%eax),%eax
  80346a:	01 c8                	add    %ecx,%eax
  80346c:	39 c2                	cmp    %eax,%edx
  80346e:	74 68                	je     8034d8 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803470:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803474:	75 17                	jne    80348d <insert_sorted_with_merge_freeList+0x323>
  803476:	83 ec 04             	sub    $0x4,%esp
  803479:	68 44 45 80 00       	push   $0x804544
  80347e:	68 62 01 00 00       	push   $0x162
  803483:	68 67 45 80 00       	push   $0x804567
  803488:	e8 15 d5 ff ff       	call   8009a2 <_panic>
  80348d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	89 10                	mov    %edx,(%eax)
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	8b 00                	mov    (%eax),%eax
  80349d:	85 c0                	test   %eax,%eax
  80349f:	74 0d                	je     8034ae <insert_sorted_with_merge_freeList+0x344>
  8034a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8034a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a9:	89 50 04             	mov    %edx,0x4(%eax)
  8034ac:	eb 08                	jmp    8034b6 <insert_sorted_with_merge_freeList+0x34c>
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cd:	40                   	inc    %eax
  8034ce:	a3 44 51 80 00       	mov    %eax,0x805144
  8034d3:	e9 9f 04 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8034d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8034e2:	e9 84 04 00 00       	jmp    80396b <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 50 08             	mov    0x8(%eax),%edx
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	8b 40 08             	mov    0x8(%eax),%eax
  8034f3:	39 c2                	cmp    %eax,%edx
  8034f5:	0f 86 a9 00 00 00    	jbe    8035a4 <insert_sorted_with_merge_freeList+0x43a>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 50 08             	mov    0x8(%eax),%edx
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	8b 48 08             	mov    0x8(%eax),%ecx
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	8b 40 0c             	mov    0xc(%eax),%eax
  80350d:	01 c8                	add    %ecx,%eax
  80350f:	39 c2                	cmp    %eax,%edx
  803511:	0f 84 8d 00 00 00    	je     8035a4 <insert_sorted_with_merge_freeList+0x43a>
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	8b 50 08             	mov    0x8(%eax),%edx
  80351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803520:	8b 40 04             	mov    0x4(%eax),%eax
  803523:	8b 48 08             	mov    0x8(%eax),%ecx
  803526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803529:	8b 40 04             	mov    0x4(%eax),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	01 c8                	add    %ecx,%eax
  803531:	39 c2                	cmp    %eax,%edx
  803533:	74 6f                	je     8035a4 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803539:	74 06                	je     803541 <insert_sorted_with_merge_freeList+0x3d7>
  80353b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353f:	75 17                	jne    803558 <insert_sorted_with_merge_freeList+0x3ee>
  803541:	83 ec 04             	sub    $0x4,%esp
  803544:	68 a4 45 80 00       	push   $0x8045a4
  803549:	68 6b 01 00 00       	push   $0x16b
  80354e:	68 67 45 80 00       	push   $0x804567
  803553:	e8 4a d4 ff ff       	call   8009a2 <_panic>
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 50 04             	mov    0x4(%eax),%edx
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80356a:	89 10                	mov    %edx,(%eax)
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 40 04             	mov    0x4(%eax),%eax
  803572:	85 c0                	test   %eax,%eax
  803574:	74 0d                	je     803583 <insert_sorted_with_merge_freeList+0x419>
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	8b 40 04             	mov    0x4(%eax),%eax
  80357c:	8b 55 08             	mov    0x8(%ebp),%edx
  80357f:	89 10                	mov    %edx,(%eax)
  803581:	eb 08                	jmp    80358b <insert_sorted_with_merge_freeList+0x421>
  803583:	8b 45 08             	mov    0x8(%ebp),%eax
  803586:	a3 38 51 80 00       	mov    %eax,0x805138
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 55 08             	mov    0x8(%ebp),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	a1 44 51 80 00       	mov    0x805144,%eax
  803599:	40                   	inc    %eax
  80359a:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80359f:	e9 d3 03 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a7:	8b 50 08             	mov    0x8(%eax),%edx
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	8b 40 08             	mov    0x8(%eax),%eax
  8035b0:	39 c2                	cmp    %eax,%edx
  8035b2:	0f 86 da 00 00 00    	jbe    803692 <insert_sorted_with_merge_freeList+0x528>
  8035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bb:	8b 50 08             	mov    0x8(%eax),%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ca:	01 c8                	add    %ecx,%eax
  8035cc:	39 c2                	cmp    %eax,%edx
  8035ce:	0f 85 be 00 00 00    	jne    803692 <insert_sorted_with_merge_freeList+0x528>
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	8b 50 08             	mov    0x8(%eax),%edx
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	8b 48 08             	mov    0x8(%eax),%ecx
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	8b 40 04             	mov    0x4(%eax),%eax
  8035e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ec:	01 c8                	add    %ecx,%eax
  8035ee:	39 c2                	cmp    %eax,%edx
  8035f0:	0f 84 9c 00 00 00    	je     803692 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 50 08             	mov    0x8(%eax),%edx
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 50 0c             	mov    0xc(%eax),%edx
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	01 c2                	add    %eax,%edx
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80362a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362e:	75 17                	jne    803647 <insert_sorted_with_merge_freeList+0x4dd>
  803630:	83 ec 04             	sub    $0x4,%esp
  803633:	68 44 45 80 00       	push   $0x804544
  803638:	68 74 01 00 00       	push   $0x174
  80363d:	68 67 45 80 00       	push   $0x804567
  803642:	e8 5b d3 ff ff       	call   8009a2 <_panic>
  803647:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	89 10                	mov    %edx,(%eax)
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	8b 00                	mov    (%eax),%eax
  803657:	85 c0                	test   %eax,%eax
  803659:	74 0d                	je     803668 <insert_sorted_with_merge_freeList+0x4fe>
  80365b:	a1 48 51 80 00       	mov    0x805148,%eax
  803660:	8b 55 08             	mov    0x8(%ebp),%edx
  803663:	89 50 04             	mov    %edx,0x4(%eax)
  803666:	eb 08                	jmp    803670 <insert_sorted_with_merge_freeList+0x506>
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	a3 48 51 80 00       	mov    %eax,0x805148
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803682:	a1 54 51 80 00       	mov    0x805154,%eax
  803687:	40                   	inc    %eax
  803688:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80368d:	e9 e5 02 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	8b 50 08             	mov    0x8(%eax),%edx
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	8b 40 08             	mov    0x8(%eax),%eax
  80369e:	39 c2                	cmp    %eax,%edx
  8036a0:	0f 86 d7 00 00 00    	jbe    80377d <insert_sorted_with_merge_freeList+0x613>
  8036a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	8b 48 08             	mov    0x8(%eax),%ecx
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b8:	01 c8                	add    %ecx,%eax
  8036ba:	39 c2                	cmp    %eax,%edx
  8036bc:	0f 84 bb 00 00 00    	je     80377d <insert_sorted_with_merge_freeList+0x613>
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	8b 50 08             	mov    0x8(%eax),%edx
  8036c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d4:	8b 40 04             	mov    0x4(%eax),%eax
  8036d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036da:	01 c8                	add    %ecx,%eax
  8036dc:	39 c2                	cmp    %eax,%edx
  8036de:	0f 85 99 00 00 00    	jne    80377d <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8036ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f9:	01 c2                	add    %eax,%edx
  8036fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fe:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803701:	8b 45 08             	mov    0x8(%ebp),%eax
  803704:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803715:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803719:	75 17                	jne    803732 <insert_sorted_with_merge_freeList+0x5c8>
  80371b:	83 ec 04             	sub    $0x4,%esp
  80371e:	68 44 45 80 00       	push   $0x804544
  803723:	68 7d 01 00 00       	push   $0x17d
  803728:	68 67 45 80 00       	push   $0x804567
  80372d:	e8 70 d2 ff ff       	call   8009a2 <_panic>
  803732:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803738:	8b 45 08             	mov    0x8(%ebp),%eax
  80373b:	89 10                	mov    %edx,(%eax)
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	85 c0                	test   %eax,%eax
  803744:	74 0d                	je     803753 <insert_sorted_with_merge_freeList+0x5e9>
  803746:	a1 48 51 80 00       	mov    0x805148,%eax
  80374b:	8b 55 08             	mov    0x8(%ebp),%edx
  80374e:	89 50 04             	mov    %edx,0x4(%eax)
  803751:	eb 08                	jmp    80375b <insert_sorted_with_merge_freeList+0x5f1>
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	a3 48 51 80 00       	mov    %eax,0x805148
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376d:	a1 54 51 80 00       	mov    0x805154,%eax
  803772:	40                   	inc    %eax
  803773:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803778:	e9 fa 01 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	8b 50 08             	mov    0x8(%eax),%edx
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	8b 40 08             	mov    0x8(%eax),%eax
  803789:	39 c2                	cmp    %eax,%edx
  80378b:	0f 86 d2 01 00 00    	jbe    803963 <insert_sorted_with_merge_freeList+0x7f9>
  803791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803794:	8b 50 08             	mov    0x8(%eax),%edx
  803797:	8b 45 08             	mov    0x8(%ebp),%eax
  80379a:	8b 48 08             	mov    0x8(%eax),%ecx
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a3:	01 c8                	add    %ecx,%eax
  8037a5:	39 c2                	cmp    %eax,%edx
  8037a7:	0f 85 b6 01 00 00    	jne    803963 <insert_sorted_with_merge_freeList+0x7f9>
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b6:	8b 40 04             	mov    0x4(%eax),%eax
  8037b9:	8b 48 08             	mov    0x8(%eax),%ecx
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	8b 40 04             	mov    0x4(%eax),%eax
  8037c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c5:	01 c8                	add    %ecx,%eax
  8037c7:	39 c2                	cmp    %eax,%edx
  8037c9:	0f 85 94 01 00 00    	jne    803963 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	8b 40 04             	mov    0x4(%eax),%eax
  8037d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037d8:	8b 52 04             	mov    0x4(%edx),%edx
  8037db:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8037de:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e1:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8037e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8037ea:	01 da                	add    %ebx,%edx
  8037ec:	01 ca                	add    %ecx,%edx
  8037ee:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803809:	75 17                	jne    803822 <insert_sorted_with_merge_freeList+0x6b8>
  80380b:	83 ec 04             	sub    $0x4,%esp
  80380e:	68 d9 45 80 00       	push   $0x8045d9
  803813:	68 86 01 00 00       	push   $0x186
  803818:	68 67 45 80 00       	push   $0x804567
  80381d:	e8 80 d1 ff ff       	call   8009a2 <_panic>
  803822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 10                	je     80383b <insert_sorted_with_merge_freeList+0x6d1>
  80382b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803833:	8b 52 04             	mov    0x4(%edx),%edx
  803836:	89 50 04             	mov    %edx,0x4(%eax)
  803839:	eb 0b                	jmp    803846 <insert_sorted_with_merge_freeList+0x6dc>
  80383b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383e:	8b 40 04             	mov    0x4(%eax),%eax
  803841:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803849:	8b 40 04             	mov    0x4(%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 0f                	je     80385f <insert_sorted_with_merge_freeList+0x6f5>
  803850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803859:	8b 12                	mov    (%edx),%edx
  80385b:	89 10                	mov    %edx,(%eax)
  80385d:	eb 0a                	jmp    803869 <insert_sorted_with_merge_freeList+0x6ff>
  80385f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	a3 38 51 80 00       	mov    %eax,0x805138
  803869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803875:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387c:	a1 44 51 80 00       	mov    0x805144,%eax
  803881:	48                   	dec    %eax
  803882:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388b:	75 17                	jne    8038a4 <insert_sorted_with_merge_freeList+0x73a>
  80388d:	83 ec 04             	sub    $0x4,%esp
  803890:	68 44 45 80 00       	push   $0x804544
  803895:	68 87 01 00 00       	push   $0x187
  80389a:	68 67 45 80 00       	push   $0x804567
  80389f:	e8 fe d0 ff ff       	call   8009a2 <_panic>
  8038a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ad:	89 10                	mov    %edx,(%eax)
  8038af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b2:	8b 00                	mov    (%eax),%eax
  8038b4:	85 c0                	test   %eax,%eax
  8038b6:	74 0d                	je     8038c5 <insert_sorted_with_merge_freeList+0x75b>
  8038b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8038bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038c0:	89 50 04             	mov    %edx,0x4(%eax)
  8038c3:	eb 08                	jmp    8038cd <insert_sorted_with_merge_freeList+0x763>
  8038c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038df:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e4:	40                   	inc    %eax
  8038e5:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8038fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803902:	75 17                	jne    80391b <insert_sorted_with_merge_freeList+0x7b1>
  803904:	83 ec 04             	sub    $0x4,%esp
  803907:	68 44 45 80 00       	push   $0x804544
  80390c:	68 8a 01 00 00       	push   $0x18a
  803911:	68 67 45 80 00       	push   $0x804567
  803916:	e8 87 d0 ff ff       	call   8009a2 <_panic>
  80391b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	89 10                	mov    %edx,(%eax)
  803926:	8b 45 08             	mov    0x8(%ebp),%eax
  803929:	8b 00                	mov    (%eax),%eax
  80392b:	85 c0                	test   %eax,%eax
  80392d:	74 0d                	je     80393c <insert_sorted_with_merge_freeList+0x7d2>
  80392f:	a1 48 51 80 00       	mov    0x805148,%eax
  803934:	8b 55 08             	mov    0x8(%ebp),%edx
  803937:	89 50 04             	mov    %edx,0x4(%eax)
  80393a:	eb 08                	jmp    803944 <insert_sorted_with_merge_freeList+0x7da>
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	a3 48 51 80 00       	mov    %eax,0x805148
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803956:	a1 54 51 80 00       	mov    0x805154,%eax
  80395b:	40                   	inc    %eax
  80395c:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803961:	eb 14                	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803966:	8b 00                	mov    (%eax),%eax
  803968:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80396b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396f:	0f 85 72 fb ff ff    	jne    8034e7 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803975:	eb 00                	jmp    803977 <insert_sorted_with_merge_freeList+0x80d>
  803977:	90                   	nop
  803978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80397b:	c9                   	leave  
  80397c:	c3                   	ret    
  80397d:	66 90                	xchg   %ax,%ax
  80397f:	90                   	nop

00803980 <__udivdi3>:
  803980:	55                   	push   %ebp
  803981:	57                   	push   %edi
  803982:	56                   	push   %esi
  803983:	53                   	push   %ebx
  803984:	83 ec 1c             	sub    $0x1c,%esp
  803987:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80398b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80398f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803993:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803997:	89 ca                	mov    %ecx,%edx
  803999:	89 f8                	mov    %edi,%eax
  80399b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80399f:	85 f6                	test   %esi,%esi
  8039a1:	75 2d                	jne    8039d0 <__udivdi3+0x50>
  8039a3:	39 cf                	cmp    %ecx,%edi
  8039a5:	77 65                	ja     803a0c <__udivdi3+0x8c>
  8039a7:	89 fd                	mov    %edi,%ebp
  8039a9:	85 ff                	test   %edi,%edi
  8039ab:	75 0b                	jne    8039b8 <__udivdi3+0x38>
  8039ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b2:	31 d2                	xor    %edx,%edx
  8039b4:	f7 f7                	div    %edi
  8039b6:	89 c5                	mov    %eax,%ebp
  8039b8:	31 d2                	xor    %edx,%edx
  8039ba:	89 c8                	mov    %ecx,%eax
  8039bc:	f7 f5                	div    %ebp
  8039be:	89 c1                	mov    %eax,%ecx
  8039c0:	89 d8                	mov    %ebx,%eax
  8039c2:	f7 f5                	div    %ebp
  8039c4:	89 cf                	mov    %ecx,%edi
  8039c6:	89 fa                	mov    %edi,%edx
  8039c8:	83 c4 1c             	add    $0x1c,%esp
  8039cb:	5b                   	pop    %ebx
  8039cc:	5e                   	pop    %esi
  8039cd:	5f                   	pop    %edi
  8039ce:	5d                   	pop    %ebp
  8039cf:	c3                   	ret    
  8039d0:	39 ce                	cmp    %ecx,%esi
  8039d2:	77 28                	ja     8039fc <__udivdi3+0x7c>
  8039d4:	0f bd fe             	bsr    %esi,%edi
  8039d7:	83 f7 1f             	xor    $0x1f,%edi
  8039da:	75 40                	jne    803a1c <__udivdi3+0x9c>
  8039dc:	39 ce                	cmp    %ecx,%esi
  8039de:	72 0a                	jb     8039ea <__udivdi3+0x6a>
  8039e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039e4:	0f 87 9e 00 00 00    	ja     803a88 <__udivdi3+0x108>
  8039ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ef:	89 fa                	mov    %edi,%edx
  8039f1:	83 c4 1c             	add    $0x1c,%esp
  8039f4:	5b                   	pop    %ebx
  8039f5:	5e                   	pop    %esi
  8039f6:	5f                   	pop    %edi
  8039f7:	5d                   	pop    %ebp
  8039f8:	c3                   	ret    
  8039f9:	8d 76 00             	lea    0x0(%esi),%esi
  8039fc:	31 ff                	xor    %edi,%edi
  8039fe:	31 c0                	xor    %eax,%eax
  803a00:	89 fa                	mov    %edi,%edx
  803a02:	83 c4 1c             	add    $0x1c,%esp
  803a05:	5b                   	pop    %ebx
  803a06:	5e                   	pop    %esi
  803a07:	5f                   	pop    %edi
  803a08:	5d                   	pop    %ebp
  803a09:	c3                   	ret    
  803a0a:	66 90                	xchg   %ax,%ax
  803a0c:	89 d8                	mov    %ebx,%eax
  803a0e:	f7 f7                	div    %edi
  803a10:	31 ff                	xor    %edi,%edi
  803a12:	89 fa                	mov    %edi,%edx
  803a14:	83 c4 1c             	add    $0x1c,%esp
  803a17:	5b                   	pop    %ebx
  803a18:	5e                   	pop    %esi
  803a19:	5f                   	pop    %edi
  803a1a:	5d                   	pop    %ebp
  803a1b:	c3                   	ret    
  803a1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a21:	89 eb                	mov    %ebp,%ebx
  803a23:	29 fb                	sub    %edi,%ebx
  803a25:	89 f9                	mov    %edi,%ecx
  803a27:	d3 e6                	shl    %cl,%esi
  803a29:	89 c5                	mov    %eax,%ebp
  803a2b:	88 d9                	mov    %bl,%cl
  803a2d:	d3 ed                	shr    %cl,%ebp
  803a2f:	89 e9                	mov    %ebp,%ecx
  803a31:	09 f1                	or     %esi,%ecx
  803a33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a37:	89 f9                	mov    %edi,%ecx
  803a39:	d3 e0                	shl    %cl,%eax
  803a3b:	89 c5                	mov    %eax,%ebp
  803a3d:	89 d6                	mov    %edx,%esi
  803a3f:	88 d9                	mov    %bl,%cl
  803a41:	d3 ee                	shr    %cl,%esi
  803a43:	89 f9                	mov    %edi,%ecx
  803a45:	d3 e2                	shl    %cl,%edx
  803a47:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a4b:	88 d9                	mov    %bl,%cl
  803a4d:	d3 e8                	shr    %cl,%eax
  803a4f:	09 c2                	or     %eax,%edx
  803a51:	89 d0                	mov    %edx,%eax
  803a53:	89 f2                	mov    %esi,%edx
  803a55:	f7 74 24 0c          	divl   0xc(%esp)
  803a59:	89 d6                	mov    %edx,%esi
  803a5b:	89 c3                	mov    %eax,%ebx
  803a5d:	f7 e5                	mul    %ebp
  803a5f:	39 d6                	cmp    %edx,%esi
  803a61:	72 19                	jb     803a7c <__udivdi3+0xfc>
  803a63:	74 0b                	je     803a70 <__udivdi3+0xf0>
  803a65:	89 d8                	mov    %ebx,%eax
  803a67:	31 ff                	xor    %edi,%edi
  803a69:	e9 58 ff ff ff       	jmp    8039c6 <__udivdi3+0x46>
  803a6e:	66 90                	xchg   %ax,%ax
  803a70:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a74:	89 f9                	mov    %edi,%ecx
  803a76:	d3 e2                	shl    %cl,%edx
  803a78:	39 c2                	cmp    %eax,%edx
  803a7a:	73 e9                	jae    803a65 <__udivdi3+0xe5>
  803a7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a7f:	31 ff                	xor    %edi,%edi
  803a81:	e9 40 ff ff ff       	jmp    8039c6 <__udivdi3+0x46>
  803a86:	66 90                	xchg   %ax,%ax
  803a88:	31 c0                	xor    %eax,%eax
  803a8a:	e9 37 ff ff ff       	jmp    8039c6 <__udivdi3+0x46>
  803a8f:	90                   	nop

00803a90 <__umoddi3>:
  803a90:	55                   	push   %ebp
  803a91:	57                   	push   %edi
  803a92:	56                   	push   %esi
  803a93:	53                   	push   %ebx
  803a94:	83 ec 1c             	sub    $0x1c,%esp
  803a97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aaf:	89 f3                	mov    %esi,%ebx
  803ab1:	89 fa                	mov    %edi,%edx
  803ab3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab7:	89 34 24             	mov    %esi,(%esp)
  803aba:	85 c0                	test   %eax,%eax
  803abc:	75 1a                	jne    803ad8 <__umoddi3+0x48>
  803abe:	39 f7                	cmp    %esi,%edi
  803ac0:	0f 86 a2 00 00 00    	jbe    803b68 <__umoddi3+0xd8>
  803ac6:	89 c8                	mov    %ecx,%eax
  803ac8:	89 f2                	mov    %esi,%edx
  803aca:	f7 f7                	div    %edi
  803acc:	89 d0                	mov    %edx,%eax
  803ace:	31 d2                	xor    %edx,%edx
  803ad0:	83 c4 1c             	add    $0x1c,%esp
  803ad3:	5b                   	pop    %ebx
  803ad4:	5e                   	pop    %esi
  803ad5:	5f                   	pop    %edi
  803ad6:	5d                   	pop    %ebp
  803ad7:	c3                   	ret    
  803ad8:	39 f0                	cmp    %esi,%eax
  803ada:	0f 87 ac 00 00 00    	ja     803b8c <__umoddi3+0xfc>
  803ae0:	0f bd e8             	bsr    %eax,%ebp
  803ae3:	83 f5 1f             	xor    $0x1f,%ebp
  803ae6:	0f 84 ac 00 00 00    	je     803b98 <__umoddi3+0x108>
  803aec:	bf 20 00 00 00       	mov    $0x20,%edi
  803af1:	29 ef                	sub    %ebp,%edi
  803af3:	89 fe                	mov    %edi,%esi
  803af5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803af9:	89 e9                	mov    %ebp,%ecx
  803afb:	d3 e0                	shl    %cl,%eax
  803afd:	89 d7                	mov    %edx,%edi
  803aff:	89 f1                	mov    %esi,%ecx
  803b01:	d3 ef                	shr    %cl,%edi
  803b03:	09 c7                	or     %eax,%edi
  803b05:	89 e9                	mov    %ebp,%ecx
  803b07:	d3 e2                	shl    %cl,%edx
  803b09:	89 14 24             	mov    %edx,(%esp)
  803b0c:	89 d8                	mov    %ebx,%eax
  803b0e:	d3 e0                	shl    %cl,%eax
  803b10:	89 c2                	mov    %eax,%edx
  803b12:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b16:	d3 e0                	shl    %cl,%eax
  803b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b20:	89 f1                	mov    %esi,%ecx
  803b22:	d3 e8                	shr    %cl,%eax
  803b24:	09 d0                	or     %edx,%eax
  803b26:	d3 eb                	shr    %cl,%ebx
  803b28:	89 da                	mov    %ebx,%edx
  803b2a:	f7 f7                	div    %edi
  803b2c:	89 d3                	mov    %edx,%ebx
  803b2e:	f7 24 24             	mull   (%esp)
  803b31:	89 c6                	mov    %eax,%esi
  803b33:	89 d1                	mov    %edx,%ecx
  803b35:	39 d3                	cmp    %edx,%ebx
  803b37:	0f 82 87 00 00 00    	jb     803bc4 <__umoddi3+0x134>
  803b3d:	0f 84 91 00 00 00    	je     803bd4 <__umoddi3+0x144>
  803b43:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b47:	29 f2                	sub    %esi,%edx
  803b49:	19 cb                	sbb    %ecx,%ebx
  803b4b:	89 d8                	mov    %ebx,%eax
  803b4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b51:	d3 e0                	shl    %cl,%eax
  803b53:	89 e9                	mov    %ebp,%ecx
  803b55:	d3 ea                	shr    %cl,%edx
  803b57:	09 d0                	or     %edx,%eax
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 eb                	shr    %cl,%ebx
  803b5d:	89 da                	mov    %ebx,%edx
  803b5f:	83 c4 1c             	add    $0x1c,%esp
  803b62:	5b                   	pop    %ebx
  803b63:	5e                   	pop    %esi
  803b64:	5f                   	pop    %edi
  803b65:	5d                   	pop    %ebp
  803b66:	c3                   	ret    
  803b67:	90                   	nop
  803b68:	89 fd                	mov    %edi,%ebp
  803b6a:	85 ff                	test   %edi,%edi
  803b6c:	75 0b                	jne    803b79 <__umoddi3+0xe9>
  803b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b73:	31 d2                	xor    %edx,%edx
  803b75:	f7 f7                	div    %edi
  803b77:	89 c5                	mov    %eax,%ebp
  803b79:	89 f0                	mov    %esi,%eax
  803b7b:	31 d2                	xor    %edx,%edx
  803b7d:	f7 f5                	div    %ebp
  803b7f:	89 c8                	mov    %ecx,%eax
  803b81:	f7 f5                	div    %ebp
  803b83:	89 d0                	mov    %edx,%eax
  803b85:	e9 44 ff ff ff       	jmp    803ace <__umoddi3+0x3e>
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	89 c8                	mov    %ecx,%eax
  803b8e:	89 f2                	mov    %esi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	3b 04 24             	cmp    (%esp),%eax
  803b9b:	72 06                	jb     803ba3 <__umoddi3+0x113>
  803b9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ba1:	77 0f                	ja     803bb2 <__umoddi3+0x122>
  803ba3:	89 f2                	mov    %esi,%edx
  803ba5:	29 f9                	sub    %edi,%ecx
  803ba7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bab:	89 14 24             	mov    %edx,(%esp)
  803bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bb6:	8b 14 24             	mov    (%esp),%edx
  803bb9:	83 c4 1c             	add    $0x1c,%esp
  803bbc:	5b                   	pop    %ebx
  803bbd:	5e                   	pop    %esi
  803bbe:	5f                   	pop    %edi
  803bbf:	5d                   	pop    %ebp
  803bc0:	c3                   	ret    
  803bc1:	8d 76 00             	lea    0x0(%esi),%esi
  803bc4:	2b 04 24             	sub    (%esp),%eax
  803bc7:	19 fa                	sbb    %edi,%edx
  803bc9:	89 d1                	mov    %edx,%ecx
  803bcb:	89 c6                	mov    %eax,%esi
  803bcd:	e9 71 ff ff ff       	jmp    803b43 <__umoddi3+0xb3>
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bd8:	72 ea                	jb     803bc4 <__umoddi3+0x134>
  803bda:	89 d9                	mov    %ebx,%ecx
  803bdc:	e9 62 ff ff ff       	jmp    803b43 <__umoddi3+0xb3>
