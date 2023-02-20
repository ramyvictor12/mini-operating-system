
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 9e 1b 00 00       	call   801be1 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 c8 1b 00 00       	call   801c13 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e0 34 80 00       	push   $0x8034e0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 6e 16 00 00       	call   8016da <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 34 80 00       	push   $0x8034e4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 58 16 00 00       	call   8016da <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 34 80 00       	push   $0x8034ec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 3b 16 00 00       	call   8016da <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 fa 34 80 00       	push   $0x8034fa
  8000b8:	e8 5a 15 00 00       	call   801617 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 09 35 80 00       	push   $0x803509
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 db 1a 00 00       	call   801c46 <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 25 35 80 00       	push   $0x803525
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 27 35 80 00       	push   $0x803527
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 2c 35 80 00       	push   $0x80352c
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 99 18 00 00       	call   801bfa <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 3b 16 00 00       	call   801a07 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 48 35 80 00       	push   $0x803548
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 70 35 80 00       	push   $0x803570
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 40 80 00       	mov    0x804020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 98 35 80 00       	push   $0x803598
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 f0 35 80 00       	push   $0x8035f0
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 48 35 80 00       	push   $0x803548
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 bb 15 00 00       	call   801a21 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 48 17 00 00       	call   801bc6 <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 9d 17 00 00       	call   801c2c <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 40 80 00       	mov    0x804024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 7c 13 00 00       	call   801859 <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 40 80 00       	mov    0x804024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 05 13 00 00       	call   801859 <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 69 14 00 00       	call   801a07 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 63 14 00 00       	call   801a21 <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 60 2c 00 00       	call   803268 <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 20 2d 00 00       	call   803378 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 34 38 80 00       	add    $0x803834,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 58 38 80 00 	mov    0x803858(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d a0 36 80 00 	mov    0x8036a0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 45 38 80 00       	push   $0x803845
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 4e 38 80 00       	push   $0x80384e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 51 38 80 00       	mov    $0x803851,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 b0 39 80 00       	push   $0x8039b0
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801327:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80132e:	00 00 00 
  801331:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801338:	00 00 00 
  80133b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801342:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801345:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134c:	00 00 00 
  80134f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801356:	00 00 00 
  801359:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801360:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801363:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136a:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80136d:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801374:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80137b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801383:	2d 00 10 00 00       	sub    $0x1000,%eax
  801388:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80138d:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801397:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139c:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	6a 06                	push   $0x6
  8013a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a9:	50                   	push   %eax
  8013aa:	e8 ee 05 00 00       	call   80199d <sys_allocate_chunk>
  8013af:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b2:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b7:	83 ec 0c             	sub    $0xc,%esp
  8013ba:	50                   	push   %eax
  8013bb:	e8 63 0c 00 00       	call   802023 <initialize_MemBlocksList>
  8013c0:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013c3:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8013cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ce:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013eb:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013f8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801402:	8b 50 08             	mov    0x8(%eax),%edx
  801405:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801408:	01 d0                	add    %edx,%eax
  80140a:	48                   	dec    %eax
  80140b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80140e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801411:	ba 00 00 00 00       	mov    $0x0,%edx
  801416:	f7 75 e0             	divl   -0x20(%ebp)
  801419:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141c:	29 d0                	sub    %edx,%eax
  80141e:	89 c2                	mov    %eax,%edx
  801420:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801423:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801426:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80142a:	75 14                	jne    801440 <initialize_dyn_block_system+0x11f>
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	68 d5 39 80 00       	push   $0x8039d5
  801434:	6a 34                	push   $0x34
  801436:	68 f3 39 80 00       	push   $0x8039f3
  80143b:	e8 47 1c 00 00       	call   803087 <_panic>
  801440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 10                	je     801459 <initialize_dyn_block_system+0x138>
  801449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144c:	8b 00                	mov    (%eax),%eax
  80144e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801451:	8b 52 04             	mov    0x4(%edx),%edx
  801454:	89 50 04             	mov    %edx,0x4(%eax)
  801457:	eb 0b                	jmp    801464 <initialize_dyn_block_system+0x143>
  801459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145c:	8b 40 04             	mov    0x4(%eax),%eax
  80145f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801467:	8b 40 04             	mov    0x4(%eax),%eax
  80146a:	85 c0                	test   %eax,%eax
  80146c:	74 0f                	je     80147d <initialize_dyn_block_system+0x15c>
  80146e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801471:	8b 40 04             	mov    0x4(%eax),%eax
  801474:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801477:	8b 12                	mov    (%edx),%edx
  801479:	89 10                	mov    %edx,(%eax)
  80147b:	eb 0a                	jmp    801487 <initialize_dyn_block_system+0x166>
  80147d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	a3 48 41 80 00       	mov    %eax,0x804148
  801487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149a:	a1 54 41 80 00       	mov    0x804154,%eax
  80149f:	48                   	dec    %eax
  8014a0:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8014a5:	83 ec 0c             	sub    $0xc,%esp
  8014a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ab:	e8 c4 13 00 00       	call   802874 <insert_sorted_with_merge_freeList>
  8014b0:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014b3:	90                   	nop
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014bc:	e8 2f fe ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c5:	75 07                	jne    8014ce <malloc+0x18>
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cc:	eb 71                	jmp    80153f <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8014ce:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014d5:	76 07                	jbe    8014de <malloc+0x28>
	return NULL;
  8014d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dc:	eb 61                	jmp    80153f <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014de:	e8 88 08 00 00       	call   801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	74 53                	je     80153a <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014e7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	48                   	dec    %eax
  8014f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	f7 75 f4             	divl   -0xc(%ebp)
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	29 d0                	sub    %edx,%eax
  80150a:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	ff 75 ec             	pushl  -0x14(%ebp)
  801513:	e8 d2 0d 00 00       	call   8022ea <alloc_block_FF>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80151e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801522:	74 16                	je     80153a <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801524:	83 ec 0c             	sub    $0xc,%esp
  801527:	ff 75 e8             	pushl  -0x18(%ebp)
  80152a:	e8 0c 0c 00 00       	call   80213b <insert_sorted_allocList>
  80152f:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801535:	8b 40 08             	mov    0x8(%eax),%eax
  801538:	eb 05                	jmp    80153f <malloc+0x89>
    }

			}


	return NULL;
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80154d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801550:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801555:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	ff 75 f0             	pushl  -0x10(%ebp)
  80155e:	68 40 40 80 00       	push   $0x804040
  801563:	e8 a0 0b 00 00       	call   802108 <find_block>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80156e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801571:	8b 50 0c             	mov    0xc(%eax),%edx
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	52                   	push   %edx
  80157b:	50                   	push   %eax
  80157c:	e8 e4 03 00 00       	call   801965 <sys_free_user_mem>
  801581:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801588:	75 17                	jne    8015a1 <free+0x60>
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	68 d5 39 80 00       	push   $0x8039d5
  801592:	68 84 00 00 00       	push   $0x84
  801597:	68 f3 39 80 00       	push   $0x8039f3
  80159c:	e8 e6 1a 00 00       	call   803087 <_panic>
  8015a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a4:	8b 00                	mov    (%eax),%eax
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	74 10                	je     8015ba <free+0x79>
  8015aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b2:	8b 52 04             	mov    0x4(%edx),%edx
  8015b5:	89 50 04             	mov    %edx,0x4(%eax)
  8015b8:	eb 0b                	jmp    8015c5 <free+0x84>
  8015ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bd:	8b 40 04             	mov    0x4(%eax),%eax
  8015c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8015c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c8:	8b 40 04             	mov    0x4(%eax),%eax
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	74 0f                	je     8015de <free+0x9d>
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	8b 40 04             	mov    0x4(%eax),%eax
  8015d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015d8:	8b 12                	mov    (%edx),%edx
  8015da:	89 10                	mov    %edx,(%eax)
  8015dc:	eb 0a                	jmp    8015e8 <free+0xa7>
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	8b 00                	mov    (%eax),%eax
  8015e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015fb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801600:	48                   	dec    %eax
  801601:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801606:	83 ec 0c             	sub    $0xc,%esp
  801609:	ff 75 ec             	pushl  -0x14(%ebp)
  80160c:	e8 63 12 00 00       	call   802874 <insert_sorted_with_merge_freeList>
  801611:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801614:	90                   	nop
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 38             	sub    $0x38,%esp
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801623:	e8 c8 fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801628:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162c:	75 0a                	jne    801638 <smalloc+0x21>
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
  801633:	e9 a0 00 00 00       	jmp    8016d8 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801638:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80163f:	76 0a                	jbe    80164b <smalloc+0x34>
		return NULL;
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
  801646:	e9 8d 00 00 00       	jmp    8016d8 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80164b:	e8 1b 07 00 00       	call   801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801650:	85 c0                	test   %eax,%eax
  801652:	74 7f                	je     8016d3 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801654:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801661:	01 d0                	add    %edx,%eax
  801663:	48                   	dec    %eax
  801664:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166a:	ba 00 00 00 00       	mov    $0x0,%edx
  80166f:	f7 75 f4             	divl   -0xc(%ebp)
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801675:	29 d0                	sub    %edx,%eax
  801677:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	ff 75 ec             	pushl  -0x14(%ebp)
  801680:	e8 65 0c 00 00       	call   8022ea <alloc_block_FF>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80168b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80168f:	74 42                	je     8016d3 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	ff 75 e8             	pushl  -0x18(%ebp)
  801697:	e8 9f 0a 00 00       	call   80213b <insert_sorted_allocList>
  80169c:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80169f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a2:	8b 40 08             	mov    0x8(%eax),%eax
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 0c             	pushl  0xc(%ebp)
  8016b0:	ff 75 08             	pushl  0x8(%ebp)
  8016b3:	e8 38 04 00 00       	call   801af0 <sys_createSharedObject>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8016be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016c2:	79 07                	jns    8016cb <smalloc+0xb4>
	    		  return NULL;
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	eb 0d                	jmp    8016d8 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8016cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ce:	8b 40 08             	mov    0x8(%eax),%eax
  8016d1:	eb 05                	jmp    8016d8 <smalloc+0xc1>


				}


		return NULL;
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e0:	e8 0b fc ff ff       	call   8012f0 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016e5:	e8 81 06 00 00       	call   801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	0f 84 9f 00 00 00    	je     801791 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 1a 04 00 00       	call   801b1a <sys_getSizeOfSharedObject>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80170a:	79 0a                	jns    801716 <sget+0x3c>
		return NULL;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
  801711:	e9 80 00 00 00       	jmp    801796 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801716:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80171d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801723:	01 d0                	add    %edx,%eax
  801725:	48                   	dec    %eax
  801726:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172c:	ba 00 00 00 00       	mov    $0x0,%edx
  801731:	f7 75 f0             	divl   -0x10(%ebp)
  801734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801737:	29 d0                	sub    %edx,%eax
  801739:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	ff 75 e8             	pushl  -0x18(%ebp)
  801742:	e8 a3 0b 00 00       	call   8022ea <alloc_block_FF>
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80174d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801751:	74 3e                	je     801791 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801753:	83 ec 0c             	sub    $0xc,%esp
  801756:	ff 75 e4             	pushl  -0x1c(%ebp)
  801759:	e8 dd 09 00 00       	call   80213b <insert_sorted_allocList>
  80175e:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801764:	8b 40 08             	mov    0x8(%eax),%eax
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	50                   	push   %eax
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	e8 c1 03 00 00       	call   801b37 <sys_getSharedObject>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80177c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801780:	79 07                	jns    801789 <sget+0xaf>
	    		  return NULL;
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
  801787:	eb 0d                	jmp    801796 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80178c:	8b 40 08             	mov    0x8(%eax),%eax
  80178f:	eb 05                	jmp    801796 <sget+0xbc>
	      }
	}
	   return NULL;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80179e:	e8 4d fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 00 3a 80 00       	push   $0x803a00
  8017ab:	68 12 01 00 00       	push   $0x112
  8017b0:	68 f3 39 80 00       	push   $0x8039f3
  8017b5:	e8 cd 18 00 00       	call   803087 <_panic>

008017ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 28 3a 80 00       	push   $0x803a28
  8017c8:	68 26 01 00 00       	push   $0x126
  8017cd:	68 f3 39 80 00       	push   $0x8039f3
  8017d2:	e8 b0 18 00 00       	call   803087 <_panic>

008017d7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 4c 3a 80 00       	push   $0x803a4c
  8017e5:	68 31 01 00 00       	push   $0x131
  8017ea:	68 f3 39 80 00       	push   $0x8039f3
  8017ef:	e8 93 18 00 00       	call   803087 <_panic>

008017f4 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	68 4c 3a 80 00       	push   $0x803a4c
  801802:	68 36 01 00 00       	push   $0x136
  801807:	68 f3 39 80 00       	push   $0x8039f3
  80180c:	e8 76 18 00 00       	call   803087 <_panic>

00801811 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	68 4c 3a 80 00       	push   $0x803a4c
  80181f:	68 3b 01 00 00       	push   $0x13b
  801824:	68 f3 39 80 00       	push   $0x8039f3
  801829:	e8 59 18 00 00       	call   803087 <_panic>

0080182e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	57                   	push   %edi
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801840:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801843:	8b 7d 18             	mov    0x18(%ebp),%edi
  801846:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801849:	cd 30                	int    $0x30
  80184b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80184e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	5b                   	pop    %ebx
  801855:	5e                   	pop    %esi
  801856:	5f                   	pop    %edi
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    

00801859 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	8b 45 10             	mov    0x10(%ebp),%eax
  801862:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801865:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	50                   	push   %eax
  801875:	6a 00                	push   $0x0
  801877:	e8 b2 ff ff ff       	call   80182e <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_cgetc>:

int
sys_cgetc(void)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 01                	push   $0x1
  801891:	e8 98 ff ff ff       	call   80182e <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 05                	push   $0x5
  8018ae:	e8 7b ff ff ff       	call   80182e <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018bd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	56                   	push   %esi
  8018cd:	53                   	push   %ebx
  8018ce:	51                   	push   %ecx
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 06                	push   $0x6
  8018d3:	e8 56 ff ff ff       	call   80182e <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 07                	push   $0x7
  8018f5:	e8 34 ff ff ff       	call   80182e <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	6a 08                	push   $0x8
  801910:	e8 19 ff ff ff       	call   80182e <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 09                	push   $0x9
  801929:	e8 00 ff ff ff       	call   80182e <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 0a                	push   $0xa
  801942:	e8 e7 fe ff ff       	call   80182e <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 0b                	push   $0xb
  80195b:	e8 ce fe ff ff       	call   80182e <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 0f                	push   $0xf
  801976:	e8 b3 fe ff ff       	call   80182e <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 10                	push   $0x10
  801992:	e8 97 fe ff ff       	call   80182e <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return ;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 10             	pushl  0x10(%ebp)
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	6a 11                	push   $0x11
  8019af:	e8 7a fe ff ff       	call   80182e <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b7:	90                   	nop
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 0c                	push   $0xc
  8019c9:	e8 60 fe ff ff       	call   80182e <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 0d                	push   $0xd
  8019e3:	e8 46 fe ff ff       	call   80182e <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 0e                	push   $0xe
  8019fc:	e8 2d fe ff ff       	call   80182e <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 13                	push   $0x13
  801a16:	e8 13 fe ff ff       	call   80182e <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 14                	push   $0x14
  801a30:	e8 f9 fd ff ff       	call   80182e <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	90                   	nop
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_cputc>:


void
sys_cputc(const char c)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	50                   	push   %eax
  801a54:	6a 15                	push   $0x15
  801a56:	e8 d3 fd ff ff       	call   80182e <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	90                   	nop
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 16                	push   $0x16
  801a70:	e8 b9 fd ff ff       	call   80182e <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	50                   	push   %eax
  801a8b:	6a 17                	push   $0x17
  801a8d:	e8 9c fd ff ff       	call   80182e <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 1a                	push   $0x1a
  801aaa:	e8 7f fd ff ff       	call   80182e <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 18                	push   $0x18
  801ac7:	e8 62 fd ff ff       	call   80182e <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 19                	push   $0x19
  801ae5:	e8 44 fd ff ff       	call   80182e <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	8b 45 10             	mov    0x10(%ebp),%eax
  801af9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801afc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	51                   	push   %ecx
  801b09:	52                   	push   %edx
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	6a 1b                	push   $0x1b
  801b10:	e8 19 fd ff ff       	call   80182e <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 1c                	push   $0x1c
  801b2d:	e8 fc fc ff ff       	call   80182e <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	51                   	push   %ecx
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 1d                	push   $0x1d
  801b4c:	e8 dd fc ff ff       	call   80182e <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 1e                	push   $0x1e
  801b69:	e8 c0 fc ff ff       	call   80182e <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 1f                	push   $0x1f
  801b82:	e8 a7 fc ff ff       	call   80182e <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 14             	pushl  0x14(%ebp)
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	50                   	push   %eax
  801b9e:	6a 20                	push   $0x20
  801ba0:	e8 89 fc ff ff       	call   80182e <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	50                   	push   %eax
  801bb9:	6a 21                	push   $0x21
  801bbb:	e8 6e fc ff ff       	call   80182e <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	90                   	nop
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	50                   	push   %eax
  801bd5:	6a 22                	push   $0x22
  801bd7:	e8 52 fc ff ff       	call   80182e <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 02                	push   $0x2
  801bf0:	e8 39 fc ff ff       	call   80182e <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 03                	push   $0x3
  801c09:	e8 20 fc ff ff       	call   80182e <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 04                	push   $0x4
  801c22:	e8 07 fc ff ff       	call   80182e <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_exit_env>:


void sys_exit_env(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 23                	push   $0x23
  801c3b:	e8 ee fb ff ff       	call   80182e <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4f:	8d 50 04             	lea    0x4(%eax),%edx
  801c52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 24                	push   $0x24
  801c5f:	e8 ca fb ff ff       	call   80182e <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return result;
  801c67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c70:	89 01                	mov    %eax,(%ecx)
  801c72:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	c9                   	leave  
  801c79:	c2 04 00             	ret    $0x4

00801c7c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 12                	push   $0x12
  801c8e:	e8 9b fb ff ff       	call   80182e <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 25                	push   $0x25
  801ca8:	e8 81 fb ff ff       	call   80182e <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cbe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	50                   	push   %eax
  801ccb:	6a 26                	push   $0x26
  801ccd:	e8 5c fb ff ff       	call   80182e <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd5:	90                   	nop
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <rsttst>:
void rsttst()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 28                	push   $0x28
  801ce7:	e8 42 fb ff ff       	call   80182e <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfe:	8b 55 18             	mov    0x18(%ebp),%edx
  801d01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	ff 75 10             	pushl  0x10(%ebp)
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	ff 75 08             	pushl  0x8(%ebp)
  801d10:	6a 27                	push   $0x27
  801d12:	e8 17 fb ff ff       	call   80182e <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <chktst>:
void chktst(uint32 n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 29                	push   $0x29
  801d2d:	e8 fc fa ff ff       	call   80182e <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
	return ;
  801d35:	90                   	nop
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <inctst>:

void inctst()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 2a                	push   $0x2a
  801d47:	e8 e2 fa ff ff       	call   80182e <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4f:	90                   	nop
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <gettst>:
uint32 gettst()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 2b                	push   $0x2b
  801d61:	e8 c8 fa ff ff       	call   80182e <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 2c                	push   $0x2c
  801d7d:	e8 ac fa ff ff       	call   80182e <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d88:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d8c:	75 07                	jne    801d95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	eb 05                	jmp    801d9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2c                	push   $0x2c
  801dae:	e8 7b fa ff ff       	call   80182e <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 2c                	push   $0x2c
  801ddf:	e8 4a fa ff ff       	call   80182e <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
  801de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dee:	75 07                	jne    801df7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df0:	b8 01 00 00 00       	mov    $0x1,%eax
  801df5:	eb 05                	jmp    801dfc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 2c                	push   $0x2c
  801e10:	e8 19 fa ff ff       	call   80182e <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
  801e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1f:	75 07                	jne    801e28 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e21:	b8 01 00 00 00       	mov    $0x1,%eax
  801e26:	eb 05                	jmp    801e2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 08             	pushl  0x8(%ebp)
  801e3d:	6a 2d                	push   $0x2d
  801e3f:	e8 ea f9 ff ff       	call   80182e <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
	return ;
  801e47:	90                   	nop
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	53                   	push   %ebx
  801e5d:	51                   	push   %ecx
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	6a 2e                	push   $0x2e
  801e62:	e8 c7 f9 ff ff       	call   80182e <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 2f                	push   $0x2f
  801e82:	e8 a7 f9 ff ff       	call   80182e <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	68 5c 3a 80 00       	push   $0x803a5c
  801e9a:	e8 c7 e6 ff ff       	call   800566 <cprintf>
  801e9f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	68 88 3a 80 00       	push   $0x803a88
  801eb1:	e8 b0 e6 ff ff       	call   800566 <cprintf>
  801eb6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eb9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebd:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec5:	eb 56                	jmp    801f1d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ec7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ecb:	74 1c                	je     801ee9 <print_mem_block_lists+0x5d>
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	8b 50 08             	mov    0x8(%eax),%edx
  801ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edc:	8b 40 0c             	mov    0xc(%eax),%eax
  801edf:	01 c8                	add    %ecx,%eax
  801ee1:	39 c2                	cmp    %eax,%edx
  801ee3:	73 04                	jae    801ee9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ee5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 50 08             	mov    0x8(%eax),%edx
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef5:	01 c2                	add    %eax,%edx
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 40 08             	mov    0x8(%eax),%eax
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	68 9d 3a 80 00       	push   $0x803a9d
  801f07:	e8 5a e6 ff ff       	call   800566 <cprintf>
  801f0c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f15:	a1 40 41 80 00       	mov    0x804140,%eax
  801f1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f21:	74 07                	je     801f2a <print_mem_block_lists+0x9e>
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	8b 00                	mov    (%eax),%eax
  801f28:	eb 05                	jmp    801f2f <print_mem_block_lists+0xa3>
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2f:	a3 40 41 80 00       	mov    %eax,0x804140
  801f34:	a1 40 41 80 00       	mov    0x804140,%eax
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	75 8a                	jne    801ec7 <print_mem_block_lists+0x3b>
  801f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f41:	75 84                	jne    801ec7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f43:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f47:	75 10                	jne    801f59 <print_mem_block_lists+0xcd>
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	68 ac 3a 80 00       	push   $0x803aac
  801f51:	e8 10 e6 ff ff       	call   800566 <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	68 d0 3a 80 00       	push   $0x803ad0
  801f68:	e8 f9 e5 ff ff       	call   800566 <cprintf>
  801f6d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f70:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f74:	a1 40 40 80 00       	mov    0x804040,%eax
  801f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7c:	eb 56                	jmp    801fd4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f82:	74 1c                	je     801fa0 <print_mem_block_lists+0x114>
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 50 08             	mov    0x8(%eax),%edx
  801f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f93:	8b 40 0c             	mov    0xc(%eax),%eax
  801f96:	01 c8                	add    %ecx,%eax
  801f98:	39 c2                	cmp    %eax,%edx
  801f9a:	73 04                	jae    801fa0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f9c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 50 08             	mov    0x8(%eax),%edx
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fac:	01 c2                	add    %eax,%edx
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	8b 40 08             	mov    0x8(%eax),%eax
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	68 9d 3a 80 00       	push   $0x803a9d
  801fbe:	e8 a3 e5 ff ff       	call   800566 <cprintf>
  801fc3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fcc:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd8:	74 07                	je     801fe1 <print_mem_block_lists+0x155>
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 00                	mov    (%eax),%eax
  801fdf:	eb 05                	jmp    801fe6 <print_mem_block_lists+0x15a>
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe6:	a3 48 40 80 00       	mov    %eax,0x804048
  801feb:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	75 8a                	jne    801f7e <print_mem_block_lists+0xf2>
  801ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff8:	75 84                	jne    801f7e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ffa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ffe:	75 10                	jne    802010 <print_mem_block_lists+0x184>
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	68 e8 3a 80 00       	push   $0x803ae8
  802008:	e8 59 e5 ff ff       	call   800566 <cprintf>
  80200d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	68 5c 3a 80 00       	push   $0x803a5c
  802018:	e8 49 e5 ff ff       	call   800566 <cprintf>
  80201d:	83 c4 10             	add    $0x10,%esp

}
  802020:	90                   	nop
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802029:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802030:	00 00 00 
  802033:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80203a:	00 00 00 
  80203d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802044:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802047:	a1 50 40 80 00       	mov    0x804050,%eax
  80204c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80204f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802056:	e9 9e 00 00 00       	jmp    8020f9 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80205b:	a1 50 40 80 00       	mov    0x804050,%eax
  802060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802063:	c1 e2 04             	shl    $0x4,%edx
  802066:	01 d0                	add    %edx,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 14                	jne    802080 <initialize_MemBlocksList+0x5d>
  80206c:	83 ec 04             	sub    $0x4,%esp
  80206f:	68 10 3b 80 00       	push   $0x803b10
  802074:	6a 48                	push   $0x48
  802076:	68 33 3b 80 00       	push   $0x803b33
  80207b:	e8 07 10 00 00       	call   803087 <_panic>
  802080:	a1 50 40 80 00       	mov    0x804050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802093:	89 10                	mov    %edx,(%eax)
  802095:	8b 00                	mov    (%eax),%eax
  802097:	85 c0                	test   %eax,%eax
  802099:	74 18                	je     8020b3 <initialize_MemBlocksList+0x90>
  80209b:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a0:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020a6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020a9:	c1 e1 04             	shl    $0x4,%ecx
  8020ac:	01 ca                	add    %ecx,%edx
  8020ae:	89 50 04             	mov    %edx,0x4(%eax)
  8020b1:	eb 12                	jmp    8020c5 <initialize_MemBlocksList+0xa2>
  8020b3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bb:	c1 e2 04             	shl    $0x4,%edx
  8020be:	01 d0                	add    %edx,%eax
  8020c0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cd:	c1 e2 04             	shl    $0x4,%edx
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8020d7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020df:	c1 e2 04             	shl    $0x4,%edx
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020eb:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f0:	40                   	inc    %eax
  8020f1:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020f6:	ff 45 f4             	incl   -0xc(%ebp)
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ff:	0f 82 56 ff ff ff    	jb     80205b <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802105:	90                   	nop
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802116:	eb 18                	jmp    802130 <find_block+0x28>
		{
			if(tmp->sva==va)
  802118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211b:	8b 40 08             	mov    0x8(%eax),%eax
  80211e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802121:	75 05                	jne    802128 <find_block+0x20>
			{
				return tmp;
  802123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802126:	eb 11                	jmp    802139 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802130:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802134:	75 e2                	jne    802118 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802136:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802141:	a1 40 40 80 00       	mov    0x804040,%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	0f 85 83 00 00 00    	jne    8021d1 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80214e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802155:	00 00 00 
  802158:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80215f:	00 00 00 
  802162:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802169:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80216c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802170:	75 14                	jne    802186 <insert_sorted_allocList+0x4b>
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 10 3b 80 00       	push   $0x803b10
  80217a:	6a 7f                	push   $0x7f
  80217c:	68 33 3b 80 00       	push   $0x803b33
  802181:	e8 01 0f 00 00       	call   803087 <_panic>
  802186:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	89 10                	mov    %edx,(%eax)
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	8b 00                	mov    (%eax),%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	74 0d                	je     8021a7 <insert_sorted_allocList+0x6c>
  80219a:	a1 40 40 80 00       	mov    0x804040,%eax
  80219f:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a2:	89 50 04             	mov    %edx,0x4(%eax)
  8021a5:	eb 08                	jmp    8021af <insert_sorted_allocList+0x74>
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	a3 44 40 80 00       	mov    %eax,0x804044
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 40 40 80 00       	mov    %eax,0x804040
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c6:	40                   	inc    %eax
  8021c7:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021cc:	e9 16 01 00 00       	jmp    8022e7 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8b 50 08             	mov    0x8(%eax),%edx
  8021d7:	a1 44 40 80 00       	mov    0x804044,%eax
  8021dc:	8b 40 08             	mov    0x8(%eax),%eax
  8021df:	39 c2                	cmp    %eax,%edx
  8021e1:	76 68                	jbe    80224b <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e7:	75 17                	jne    802200 <insert_sorted_allocList+0xc5>
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 4c 3b 80 00       	push   $0x803b4c
  8021f1:	68 85 00 00 00       	push   $0x85
  8021f6:	68 33 3b 80 00       	push   $0x803b33
  8021fb:	e8 87 0e 00 00       	call   803087 <_panic>
  802200:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 50 04             	mov    %edx,0x4(%eax)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 40 04             	mov    0x4(%eax),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	74 0c                	je     802222 <insert_sorted_allocList+0xe7>
  802216:	a1 44 40 80 00       	mov    0x804044,%eax
  80221b:	8b 55 08             	mov    0x8(%ebp),%edx
  80221e:	89 10                	mov    %edx,(%eax)
  802220:	eb 08                	jmp    80222a <insert_sorted_allocList+0xef>
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	a3 40 40 80 00       	mov    %eax,0x804040
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 44 40 80 00       	mov    %eax,0x804044
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802240:	40                   	inc    %eax
  802241:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802246:	e9 9c 00 00 00       	jmp    8022e7 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80224b:	a1 40 40 80 00       	mov    0x804040,%eax
  802250:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802253:	e9 85 00 00 00       	jmp    8022dd <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	8b 50 08             	mov    0x8(%eax),%edx
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 08             	mov    0x8(%eax),%eax
  802264:	39 c2                	cmp    %eax,%edx
  802266:	73 6d                	jae    8022d5 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226c:	74 06                	je     802274 <insert_sorted_allocList+0x139>
  80226e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802272:	75 17                	jne    80228b <insert_sorted_allocList+0x150>
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	68 70 3b 80 00       	push   $0x803b70
  80227c:	68 90 00 00 00       	push   $0x90
  802281:	68 33 3b 80 00       	push   $0x803b33
  802286:	e8 fc 0d 00 00       	call   803087 <_panic>
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 50 04             	mov    0x4(%eax),%edx
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 40 04             	mov    0x4(%eax),%eax
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	74 0d                	je     8022b6 <insert_sorted_allocList+0x17b>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 04             	mov    0x4(%eax),%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
  8022b4:	eb 08                	jmp    8022be <insert_sorted_allocList+0x183>
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 40 40 80 00       	mov    %eax,0x804040
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c4:	89 50 04             	mov    %edx,0x4(%eax)
  8022c7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022cc:	40                   	inc    %eax
  8022cd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022d2:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022d3:	eb 12                	jmp    8022e7 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e1:	0f 85 71 ff ff ff    	jne    802258 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022e7:	90                   	nop
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022f8:	e9 76 01 00 00       	jmp    802473 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 0c             	mov    0xc(%eax),%eax
  802303:	3b 45 08             	cmp    0x8(%ebp),%eax
  802306:	0f 85 8a 00 00 00    	jne    802396 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80230c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802310:	75 17                	jne    802329 <alloc_block_FF+0x3f>
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 a5 3b 80 00       	push   $0x803ba5
  80231a:	68 a8 00 00 00       	push   $0xa8
  80231f:	68 33 3b 80 00       	push   $0x803b33
  802324:	e8 5e 0d 00 00       	call   803087 <_panic>
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	85 c0                	test   %eax,%eax
  802330:	74 10                	je     802342 <alloc_block_FF+0x58>
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233a:	8b 52 04             	mov    0x4(%edx),%edx
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	eb 0b                	jmp    80234d <alloc_block_FF+0x63>
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 40 04             	mov    0x4(%eax),%eax
  802348:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	74 0f                	je     802366 <alloc_block_FF+0x7c>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	8b 12                	mov    (%edx),%edx
  802362:	89 10                	mov    %edx,(%eax)
  802364:	eb 0a                	jmp    802370 <alloc_block_FF+0x86>
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	a3 38 41 80 00       	mov    %eax,0x804138
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802383:	a1 44 41 80 00       	mov    0x804144,%eax
  802388:	48                   	dec    %eax
  802389:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	e9 ea 00 00 00       	jmp    802480 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 0c             	mov    0xc(%eax),%eax
  80239c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239f:	0f 86 c6 00 00 00    	jbe    80246b <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8023a5:	a1 48 41 80 00       	mov    0x804148,%eax
  8023aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b3:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 50 08             	mov    0x8(%eax),%edx
  8023bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bf:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8023cb:	89 c2                	mov    %eax,%edx
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 50 08             	mov    0x8(%eax),%edx
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	01 c2                	add    %eax,%edx
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e8:	75 17                	jne    802401 <alloc_block_FF+0x117>
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	68 a5 3b 80 00       	push   $0x803ba5
  8023f2:	68 b6 00 00 00       	push   $0xb6
  8023f7:	68 33 3b 80 00       	push   $0x803b33
  8023fc:	e8 86 0c 00 00       	call   803087 <_panic>
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	85 c0                	test   %eax,%eax
  802408:	74 10                	je     80241a <alloc_block_FF+0x130>
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802412:	8b 52 04             	mov    0x4(%edx),%edx
  802415:	89 50 04             	mov    %edx,0x4(%eax)
  802418:	eb 0b                	jmp    802425 <alloc_block_FF+0x13b>
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 40 04             	mov    0x4(%eax),%eax
  802420:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 0f                	je     80243e <alloc_block_FF+0x154>
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	8b 40 04             	mov    0x4(%eax),%eax
  802435:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802438:	8b 12                	mov    (%edx),%edx
  80243a:	89 10                	mov    %edx,(%eax)
  80243c:	eb 0a                	jmp    802448 <alloc_block_FF+0x15e>
  80243e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	a3 48 41 80 00       	mov    %eax,0x804148
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245b:	a1 54 41 80 00       	mov    0x804154,%eax
  802460:	48                   	dec    %eax
  802461:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	eb 15                	jmp    802480 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802477:	0f 85 80 fe ff ff    	jne    8022fd <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802488:	a1 38 41 80 00       	mov    0x804138,%eax
  80248d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802490:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802497:	e9 c0 00 00 00       	jmp    80255c <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a5:	0f 85 8a 00 00 00    	jne    802535 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024af:	75 17                	jne    8024c8 <alloc_block_BF+0x46>
  8024b1:	83 ec 04             	sub    $0x4,%esp
  8024b4:	68 a5 3b 80 00       	push   $0x803ba5
  8024b9:	68 cf 00 00 00       	push   $0xcf
  8024be:	68 33 3b 80 00       	push   $0x803b33
  8024c3:	e8 bf 0b 00 00       	call   803087 <_panic>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	74 10                	je     8024e1 <alloc_block_BF+0x5f>
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 00                	mov    (%eax),%eax
  8024d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d9:	8b 52 04             	mov    0x4(%edx),%edx
  8024dc:	89 50 04             	mov    %edx,0x4(%eax)
  8024df:	eb 0b                	jmp    8024ec <alloc_block_BF+0x6a>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 04             	mov    0x4(%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 0f                	je     802505 <alloc_block_BF+0x83>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 40 04             	mov    0x4(%eax),%eax
  8024fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ff:	8b 12                	mov    (%edx),%edx
  802501:	89 10                	mov    %edx,(%eax)
  802503:	eb 0a                	jmp    80250f <alloc_block_BF+0x8d>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	a3 38 41 80 00       	mov    %eax,0x804138
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802522:	a1 44 41 80 00       	mov    0x804144,%eax
  802527:	48                   	dec    %eax
  802528:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	e9 2a 01 00 00       	jmp    80265f <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 40 0c             	mov    0xc(%eax),%eax
  80253b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80253e:	73 14                	jae    802554 <alloc_block_BF+0xd2>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 0c             	mov    0xc(%eax),%eax
  802546:	3b 45 08             	cmp    0x8(%ebp),%eax
  802549:	76 09                	jbe    802554 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 0c             	mov    0xc(%eax),%eax
  802551:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80255c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802560:	0f 85 36 ff ff ff    	jne    80249c <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802566:	a1 38 41 80 00       	mov    0x804138,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80256e:	e9 dd 00 00 00       	jmp    802650 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 0c             	mov    0xc(%eax),%eax
  802579:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80257c:	0f 85 c6 00 00 00    	jne    802648 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802582:	a1 48 41 80 00       	mov    0x804148,%eax
  802587:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 50 08             	mov    0x8(%eax),%edx
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802599:	8b 55 08             	mov    0x8(%ebp),%edx
  80259c:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 50 08             	mov    0x8(%eax),%edx
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	01 c2                	add    %eax,%edx
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b9:	89 c2                	mov    %eax,%edx
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c5:	75 17                	jne    8025de <alloc_block_BF+0x15c>
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	68 a5 3b 80 00       	push   $0x803ba5
  8025cf:	68 eb 00 00 00       	push   $0xeb
  8025d4:	68 33 3b 80 00       	push   $0x803b33
  8025d9:	e8 a9 0a 00 00       	call   803087 <_panic>
  8025de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	74 10                	je     8025f7 <alloc_block_BF+0x175>
  8025e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ef:	8b 52 04             	mov    0x4(%edx),%edx
  8025f2:	89 50 04             	mov    %edx,0x4(%eax)
  8025f5:	eb 0b                	jmp    802602 <alloc_block_BF+0x180>
  8025f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fa:	8b 40 04             	mov    0x4(%eax),%eax
  8025fd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802605:	8b 40 04             	mov    0x4(%eax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	74 0f                	je     80261b <alloc_block_BF+0x199>
  80260c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260f:	8b 40 04             	mov    0x4(%eax),%eax
  802612:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802615:	8b 12                	mov    (%edx),%edx
  802617:	89 10                	mov    %edx,(%eax)
  802619:	eb 0a                	jmp    802625 <alloc_block_BF+0x1a3>
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	a3 48 41 80 00       	mov    %eax,0x804148
  802625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802628:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802638:	a1 54 41 80 00       	mov    0x804154,%eax
  80263d:	48                   	dec    %eax
  80263e:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802646:	eb 17                	jmp    80265f <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802654:	0f 85 19 ff ff ff    	jne    802573 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80265a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802667:	a1 40 40 80 00       	mov    0x804040,%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	75 19                	jne    802689 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	ff 75 08             	pushl  0x8(%ebp)
  802676:	e8 6f fc ff ff       	call   8022ea <alloc_block_FF>
  80267b:	83 c4 10             	add    $0x10,%esp
  80267e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	e9 e9 01 00 00       	jmp    802872 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802689:	a1 44 40 80 00       	mov    0x804044,%eax
  80268e:	8b 40 08             	mov    0x8(%eax),%eax
  802691:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802694:	a1 44 40 80 00       	mov    0x804044,%eax
  802699:	8b 50 0c             	mov    0xc(%eax),%edx
  80269c:	a1 44 40 80 00       	mov    0x804044,%eax
  8026a1:	8b 40 08             	mov    0x8(%eax),%eax
  8026a4:	01 d0                	add    %edx,%eax
  8026a6:	83 ec 08             	sub    $0x8,%esp
  8026a9:	50                   	push   %eax
  8026aa:	68 38 41 80 00       	push   $0x804138
  8026af:	e8 54 fa ff ff       	call   802108 <find_block>
  8026b4:	83 c4 10             	add    $0x10,%esp
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c3:	0f 85 9b 00 00 00    	jne    802764 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 40 08             	mov    0x8(%eax),%eax
  8026d5:	01 d0                	add    %edx,%eax
  8026d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026de:	75 17                	jne    8026f7 <alloc_block_NF+0x96>
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	68 a5 3b 80 00       	push   $0x803ba5
  8026e8:	68 1a 01 00 00       	push   $0x11a
  8026ed:	68 33 3b 80 00       	push   $0x803b33
  8026f2:	e8 90 09 00 00       	call   803087 <_panic>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 10                	je     802710 <alloc_block_NF+0xaf>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	8b 52 04             	mov    0x4(%edx),%edx
  80270b:	89 50 04             	mov    %edx,0x4(%eax)
  80270e:	eb 0b                	jmp    80271b <alloc_block_NF+0xba>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	74 0f                	je     802734 <alloc_block_NF+0xd3>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272e:	8b 12                	mov    (%edx),%edx
  802730:	89 10                	mov    %edx,(%eax)
  802732:	eb 0a                	jmp    80273e <alloc_block_NF+0xdd>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	a3 38 41 80 00       	mov    %eax,0x804138
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802751:	a1 44 41 80 00       	mov    0x804144,%eax
  802756:	48                   	dec    %eax
  802757:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	e9 0e 01 00 00       	jmp    802872 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 0c             	mov    0xc(%eax),%eax
  80276a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276d:	0f 86 cf 00 00 00    	jbe    802842 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802773:	a1 48 41 80 00       	mov    0x804148,%eax
  802778:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277e:	8b 55 08             	mov    0x8(%ebp),%edx
  802781:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 50 08             	mov    0x8(%eax),%edx
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 50 08             	mov    0x8(%eax),%edx
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	01 c2                	add    %eax,%edx
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027aa:	89 c2                	mov    %eax,%edx
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 40 08             	mov    0x8(%eax),%eax
  8027b8:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027bf:	75 17                	jne    8027d8 <alloc_block_NF+0x177>
  8027c1:	83 ec 04             	sub    $0x4,%esp
  8027c4:	68 a5 3b 80 00       	push   $0x803ba5
  8027c9:	68 28 01 00 00       	push   $0x128
  8027ce:	68 33 3b 80 00       	push   $0x803b33
  8027d3:	e8 af 08 00 00       	call   803087 <_panic>
  8027d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	74 10                	je     8027f1 <alloc_block_NF+0x190>
  8027e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e9:	8b 52 04             	mov    0x4(%edx),%edx
  8027ec:	89 50 04             	mov    %edx,0x4(%eax)
  8027ef:	eb 0b                	jmp    8027fc <alloc_block_NF+0x19b>
  8027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	74 0f                	je     802815 <alloc_block_NF+0x1b4>
  802806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80280f:	8b 12                	mov    (%edx),%edx
  802811:	89 10                	mov    %edx,(%eax)
  802813:	eb 0a                	jmp    80281f <alloc_block_NF+0x1be>
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	a3 48 41 80 00       	mov    %eax,0x804148
  80281f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802832:	a1 54 41 80 00       	mov    0x804154,%eax
  802837:	48                   	dec    %eax
  802838:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	eb 30                	jmp    802872 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802842:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802847:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284a:	75 0a                	jne    802856 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80284c:	a1 38 41 80 00       	mov    0x804138,%eax
  802851:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802854:	eb 08                	jmp    80285e <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 08             	mov    0x8(%eax),%eax
  802864:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802867:	0f 85 4d fe ff ff    	jne    8026ba <alloc_block_NF+0x59>

			return NULL;
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	53                   	push   %ebx
  802878:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80287b:	a1 38 41 80 00       	mov    0x804138,%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	0f 85 86 00 00 00    	jne    80290e <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802888:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80288f:	00 00 00 
  802892:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802899:	00 00 00 
  80289c:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8028a3:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028aa:	75 17                	jne    8028c3 <insert_sorted_with_merge_freeList+0x4f>
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	68 10 3b 80 00       	push   $0x803b10
  8028b4:	68 48 01 00 00       	push   $0x148
  8028b9:	68 33 3b 80 00       	push   $0x803b33
  8028be:	e8 c4 07 00 00       	call   803087 <_panic>
  8028c3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	89 10                	mov    %edx,(%eax)
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 0d                	je     8028e4 <insert_sorted_with_merge_freeList+0x70>
  8028d7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028df:	89 50 04             	mov    %edx,0x4(%eax)
  8028e2:	eb 08                	jmp    8028ec <insert_sorted_with_merge_freeList+0x78>
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	a3 38 41 80 00       	mov    %eax,0x804138
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fe:	a1 44 41 80 00       	mov    0x804144,%eax
  802903:	40                   	inc    %eax
  802904:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802909:	e9 73 07 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	8b 50 08             	mov    0x8(%eax),%edx
  802914:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802919:	8b 40 08             	mov    0x8(%eax),%eax
  80291c:	39 c2                	cmp    %eax,%edx
  80291e:	0f 86 84 00 00 00    	jbe    8029a8 <insert_sorted_with_merge_freeList+0x134>
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	8b 50 08             	mov    0x8(%eax),%edx
  80292a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80292f:	8b 48 0c             	mov    0xc(%eax),%ecx
  802932:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802937:	8b 40 08             	mov    0x8(%eax),%eax
  80293a:	01 c8                	add    %ecx,%eax
  80293c:	39 c2                	cmp    %eax,%edx
  80293e:	74 68                	je     8029a8 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802940:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802944:	75 17                	jne    80295d <insert_sorted_with_merge_freeList+0xe9>
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	68 4c 3b 80 00       	push   $0x803b4c
  80294e:	68 4c 01 00 00       	push   $0x14c
  802953:	68 33 3b 80 00       	push   $0x803b33
  802958:	e8 2a 07 00 00       	call   803087 <_panic>
  80295d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	89 50 04             	mov    %edx,0x4(%eax)
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 0c                	je     80297f <insert_sorted_with_merge_freeList+0x10b>
  802973:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802978:	8b 55 08             	mov    0x8(%ebp),%edx
  80297b:	89 10                	mov    %edx,(%eax)
  80297d:	eb 08                	jmp    802987 <insert_sorted_with_merge_freeList+0x113>
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	a3 38 41 80 00       	mov    %eax,0x804138
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802998:	a1 44 41 80 00       	mov    0x804144,%eax
  80299d:	40                   	inc    %eax
  80299e:	a3 44 41 80 00       	mov    %eax,0x804144
  8029a3:	e9 d9 06 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	8b 50 08             	mov    0x8(%eax),%edx
  8029ae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b3:	8b 40 08             	mov    0x8(%eax),%eax
  8029b6:	39 c2                	cmp    %eax,%edx
  8029b8:	0f 86 b5 00 00 00    	jbe    802a73 <insert_sorted_with_merge_freeList+0x1ff>
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8b 50 08             	mov    0x8(%eax),%edx
  8029c4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029c9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029cc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	01 c8                	add    %ecx,%eax
  8029d6:	39 c2                	cmp    %eax,%edx
  8029d8:	0f 85 95 00 00 00    	jne    802a73 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029de:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029e9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8029f2:	01 ca                	add    %ecx,%edx
  8029f4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0f:	75 17                	jne    802a28 <insert_sorted_with_merge_freeList+0x1b4>
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 10 3b 80 00       	push   $0x803b10
  802a19:	68 54 01 00 00       	push   $0x154
  802a1e:	68 33 3b 80 00       	push   $0x803b33
  802a23:	e8 5f 06 00 00       	call   803087 <_panic>
  802a28:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	89 10                	mov    %edx,(%eax)
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 0d                	je     802a49 <insert_sorted_with_merge_freeList+0x1d5>
  802a3c:	a1 48 41 80 00       	mov    0x804148,%eax
  802a41:	8b 55 08             	mov    0x8(%ebp),%edx
  802a44:	89 50 04             	mov    %edx,0x4(%eax)
  802a47:	eb 08                	jmp    802a51 <insert_sorted_with_merge_freeList+0x1dd>
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	a3 48 41 80 00       	mov    %eax,0x804148
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a63:	a1 54 41 80 00       	mov    0x804154,%eax
  802a68:	40                   	inc    %eax
  802a69:	a3 54 41 80 00       	mov    %eax,0x804154
  802a6e:	e9 0e 06 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	8b 50 08             	mov    0x8(%eax),%edx
  802a79:	a1 38 41 80 00       	mov    0x804138,%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	39 c2                	cmp    %eax,%edx
  802a83:	0f 83 c1 00 00 00    	jae    802b4a <insert_sorted_with_merge_freeList+0x2d6>
  802a89:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8e:	8b 50 08             	mov    0x8(%eax),%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	8b 48 08             	mov    0x8(%eax),%ecx
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9d:	01 c8                	add    %ecx,%eax
  802a9f:	39 c2                	cmp    %eax,%edx
  802aa1:	0f 85 a3 00 00 00    	jne    802b4a <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802aa7:	a1 38 41 80 00       	mov    0x804138,%eax
  802aac:	8b 55 08             	mov    0x8(%ebp),%edx
  802aaf:	8b 52 08             	mov    0x8(%edx),%edx
  802ab2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ab5:	a1 38 41 80 00       	mov    0x804138,%eax
  802aba:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	8b 52 0c             	mov    0xc(%edx),%edx
  802ac9:	01 ca                	add    %ecx,%edx
  802acb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae6:	75 17                	jne    802aff <insert_sorted_with_merge_freeList+0x28b>
  802ae8:	83 ec 04             	sub    $0x4,%esp
  802aeb:	68 10 3b 80 00       	push   $0x803b10
  802af0:	68 5d 01 00 00       	push   $0x15d
  802af5:	68 33 3b 80 00       	push   $0x803b33
  802afa:	e8 88 05 00 00       	call   803087 <_panic>
  802aff:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 0d                	je     802b20 <insert_sorted_with_merge_freeList+0x2ac>
  802b13:	a1 48 41 80 00       	mov    0x804148,%eax
  802b18:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1b:	89 50 04             	mov    %edx,0x4(%eax)
  802b1e:	eb 08                	jmp    802b28 <insert_sorted_with_merge_freeList+0x2b4>
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b3f:	40                   	inc    %eax
  802b40:	a3 54 41 80 00       	mov    %eax,0x804154
  802b45:	e9 37 05 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 50 08             	mov    0x8(%eax),%edx
  802b50:	a1 38 41 80 00       	mov    0x804138,%eax
  802b55:	8b 40 08             	mov    0x8(%eax),%eax
  802b58:	39 c2                	cmp    %eax,%edx
  802b5a:	0f 83 82 00 00 00    	jae    802be2 <insert_sorted_with_merge_freeList+0x36e>
  802b60:	a1 38 41 80 00       	mov    0x804138,%eax
  802b65:	8b 50 08             	mov    0x8(%eax),%edx
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 48 08             	mov    0x8(%eax),%ecx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	01 c8                	add    %ecx,%eax
  802b76:	39 c2                	cmp    %eax,%edx
  802b78:	74 68                	je     802be2 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7e:	75 17                	jne    802b97 <insert_sorted_with_merge_freeList+0x323>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 10 3b 80 00       	push   $0x803b10
  802b88:	68 62 01 00 00       	push   $0x162
  802b8d:	68 33 3b 80 00       	push   $0x803b33
  802b92:	e8 f0 04 00 00       	call   803087 <_panic>
  802b97:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	74 0d                	je     802bb8 <insert_sorted_with_merge_freeList+0x344>
  802bab:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 08                	jmp    802bc0 <insert_sorted_with_merge_freeList+0x34c>
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd2:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd7:	40                   	inc    %eax
  802bd8:	a3 44 41 80 00       	mov    %eax,0x804144
  802bdd:	e9 9f 04 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802be2:	a1 38 41 80 00       	mov    0x804138,%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bec:	e9 84 04 00 00       	jmp    803075 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 50 08             	mov    0x8(%eax),%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 40 08             	mov    0x8(%eax),%eax
  802bfd:	39 c2                	cmp    %eax,%edx
  802bff:	0f 86 a9 00 00 00    	jbe    802cae <insert_sorted_with_merge_freeList+0x43a>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 50 08             	mov    0x8(%eax),%edx
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	8b 48 08             	mov    0x8(%eax),%ecx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	01 c8                	add    %ecx,%eax
  802c19:	39 c2                	cmp    %eax,%edx
  802c1b:	0f 84 8d 00 00 00    	je     802cae <insert_sorted_with_merge_freeList+0x43a>
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	8b 48 08             	mov    0x8(%eax),%ecx
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	8b 40 0c             	mov    0xc(%eax),%eax
  802c39:	01 c8                	add    %ecx,%eax
  802c3b:	39 c2                	cmp    %eax,%edx
  802c3d:	74 6f                	je     802cae <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	74 06                	je     802c4b <insert_sorted_with_merge_freeList+0x3d7>
  802c45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c49:	75 17                	jne    802c62 <insert_sorted_with_merge_freeList+0x3ee>
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	68 70 3b 80 00       	push   $0x803b70
  802c53:	68 6b 01 00 00       	push   $0x16b
  802c58:	68 33 3b 80 00       	push   $0x803b33
  802c5d:	e8 25 04 00 00       	call   803087 <_panic>
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 50 04             	mov    0x4(%eax),%edx
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	89 50 04             	mov    %edx,0x4(%eax)
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0d                	je     802c8d <insert_sorted_with_merge_freeList+0x419>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 08             	mov    0x8(%ebp),%edx
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	eb 08                	jmp    802c95 <insert_sorted_with_merge_freeList+0x421>
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	a3 38 41 80 00       	mov    %eax,0x804138
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9b:	89 50 04             	mov    %edx,0x4(%eax)
  802c9e:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802ca9:	e9 d3 03 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	39 c2                	cmp    %eax,%edx
  802cbc:	0f 86 da 00 00 00    	jbe    802d9c <insert_sorted_with_merge_freeList+0x528>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 50 08             	mov    0x8(%eax),%edx
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	8b 48 08             	mov    0x8(%eax),%ecx
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd4:	01 c8                	add    %ecx,%eax
  802cd6:	39 c2                	cmp    %eax,%edx
  802cd8:	0f 85 be 00 00 00    	jne    802d9c <insert_sorted_with_merge_freeList+0x528>
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	8b 50 08             	mov    0x8(%eax),%edx
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 48 08             	mov    0x8(%eax),%ecx
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf6:	01 c8                	add    %ecx,%eax
  802cf8:	39 c2                	cmp    %eax,%edx
  802cfa:	0f 84 9c 00 00 00    	je     802d9c <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 08             	mov    0x8(%eax),%edx
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	01 c2                	add    %eax,%edx
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d38:	75 17                	jne    802d51 <insert_sorted_with_merge_freeList+0x4dd>
  802d3a:	83 ec 04             	sub    $0x4,%esp
  802d3d:	68 10 3b 80 00       	push   $0x803b10
  802d42:	68 74 01 00 00       	push   $0x174
  802d47:	68 33 3b 80 00       	push   $0x803b33
  802d4c:	e8 36 03 00 00       	call   803087 <_panic>
  802d51:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 0d                	je     802d72 <insert_sorted_with_merge_freeList+0x4fe>
  802d65:	a1 48 41 80 00       	mov    0x804148,%eax
  802d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6d:	89 50 04             	mov    %edx,0x4(%eax)
  802d70:	eb 08                	jmp    802d7a <insert_sorted_with_merge_freeList+0x506>
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	a3 48 41 80 00       	mov    %eax,0x804148
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802d91:	40                   	inc    %eax
  802d92:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d97:	e9 e5 02 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 50 08             	mov    0x8(%eax),%edx
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 40 08             	mov    0x8(%eax),%eax
  802da8:	39 c2                	cmp    %eax,%edx
  802daa:	0f 86 d7 00 00 00    	jbe    802e87 <insert_sorted_with_merge_freeList+0x613>
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 50 08             	mov    0x8(%eax),%edx
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 48 08             	mov    0x8(%eax),%ecx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c8                	add    %ecx,%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 84 bb 00 00 00    	je     802e87 <insert_sorted_with_merge_freeList+0x613>
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	8b 48 08             	mov    0x8(%eax),%ecx
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	8b 40 0c             	mov    0xc(%eax),%eax
  802de4:	01 c8                	add    %ecx,%eax
  802de6:	39 c2                	cmp    %eax,%edx
  802de8:	0f 85 99 00 00 00    	jne    802e87 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	01 c2                	add    %eax,%edx
  802e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e08:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e23:	75 17                	jne    802e3c <insert_sorted_with_merge_freeList+0x5c8>
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	68 10 3b 80 00       	push   $0x803b10
  802e2d:	68 7d 01 00 00       	push   $0x17d
  802e32:	68 33 3b 80 00       	push   $0x803b33
  802e37:	e8 4b 02 00 00       	call   803087 <_panic>
  802e3c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0d                	je     802e5d <insert_sorted_with_merge_freeList+0x5e9>
  802e50:	a1 48 41 80 00       	mov    0x804148,%eax
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 08                	jmp    802e65 <insert_sorted_with_merge_freeList+0x5f1>
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7c:	40                   	inc    %eax
  802e7d:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e82:	e9 fa 01 00 00       	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	39 c2                	cmp    %eax,%edx
  802e95:	0f 86 d2 01 00 00    	jbe    80306d <insert_sorted_with_merge_freeList+0x7f9>
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	01 c8                	add    %ecx,%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 85 b6 01 00 00    	jne    80306d <insert_sorted_with_merge_freeList+0x7f9>
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecf:	01 c8                	add    %ecx,%eax
  802ed1:	39 c2                	cmp    %eax,%edx
  802ed3:	0f 85 94 01 00 00    	jne    80306d <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee2:	8b 52 04             	mov    0x4(%edx),%edx
  802ee5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eeb:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef1:	8b 52 0c             	mov    0xc(%edx),%edx
  802ef4:	01 da                	add    %ebx,%edx
  802ef6:	01 ca                	add    %ecx,%edx
  802ef8:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f13:	75 17                	jne    802f2c <insert_sorted_with_merge_freeList+0x6b8>
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	68 a5 3b 80 00       	push   $0x803ba5
  802f1d:	68 86 01 00 00       	push   $0x186
  802f22:	68 33 3b 80 00       	push   $0x803b33
  802f27:	e8 5b 01 00 00       	call   803087 <_panic>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 10                	je     802f45 <insert_sorted_with_merge_freeList+0x6d1>
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3d:	8b 52 04             	mov    0x4(%edx),%edx
  802f40:	89 50 04             	mov    %edx,0x4(%eax)
  802f43:	eb 0b                	jmp    802f50 <insert_sorted_with_merge_freeList+0x6dc>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0f                	je     802f69 <insert_sorted_with_merge_freeList+0x6f5>
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f63:	8b 12                	mov    (%edx),%edx
  802f65:	89 10                	mov    %edx,(%eax)
  802f67:	eb 0a                	jmp    802f73 <insert_sorted_with_merge_freeList+0x6ff>
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	a3 38 41 80 00       	mov    %eax,0x804138
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f86:	a1 44 41 80 00       	mov    0x804144,%eax
  802f8b:	48                   	dec    %eax
  802f8c:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f95:	75 17                	jne    802fae <insert_sorted_with_merge_freeList+0x73a>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 10 3b 80 00       	push   $0x803b10
  802f9f:	68 87 01 00 00       	push   $0x187
  802fa4:	68 33 3b 80 00       	push   $0x803b33
  802fa9:	e8 d9 00 00 00       	call   803087 <_panic>
  802fae:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0d                	je     802fcf <insert_sorted_with_merge_freeList+0x75b>
  802fc2:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fca:	89 50 04             	mov    %edx,0x4(%eax)
  802fcd:	eb 08                	jmp    802fd7 <insert_sorted_with_merge_freeList+0x763>
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	a3 48 41 80 00       	mov    %eax,0x804148
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fee:	40                   	inc    %eax
  802fef:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803008:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300c:	75 17                	jne    803025 <insert_sorted_with_merge_freeList+0x7b1>
  80300e:	83 ec 04             	sub    $0x4,%esp
  803011:	68 10 3b 80 00       	push   $0x803b10
  803016:	68 8a 01 00 00       	push   $0x18a
  80301b:	68 33 3b 80 00       	push   $0x803b33
  803020:	e8 62 00 00 00       	call   803087 <_panic>
  803025:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	89 10                	mov    %edx,(%eax)
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 0d                	je     803046 <insert_sorted_with_merge_freeList+0x7d2>
  803039:	a1 48 41 80 00       	mov    0x804148,%eax
  80303e:	8b 55 08             	mov    0x8(%ebp),%edx
  803041:	89 50 04             	mov    %edx,0x4(%eax)
  803044:	eb 08                	jmp    80304e <insert_sorted_with_merge_freeList+0x7da>
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	a3 48 41 80 00       	mov    %eax,0x804148
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803060:	a1 54 41 80 00       	mov    0x804154,%eax
  803065:	40                   	inc    %eax
  803066:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  80306b:	eb 14                	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803079:	0f 85 72 fb ff ff    	jne    802bf1 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80307f:	eb 00                	jmp    803081 <insert_sorted_with_merge_freeList+0x80d>
  803081:	90                   	nop
  803082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803085:	c9                   	leave  
  803086:	c3                   	ret    

00803087 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803087:	55                   	push   %ebp
  803088:	89 e5                	mov    %esp,%ebp
  80308a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80308d:	8d 45 10             	lea    0x10(%ebp),%eax
  803090:	83 c0 04             	add    $0x4,%eax
  803093:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803096:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	74 16                	je     8030b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80309f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030a4:	83 ec 08             	sub    $0x8,%esp
  8030a7:	50                   	push   %eax
  8030a8:	68 c4 3b 80 00       	push   $0x803bc4
  8030ad:	e8 b4 d4 ff ff       	call   800566 <cprintf>
  8030b2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8030b5:	a1 00 40 80 00       	mov    0x804000,%eax
  8030ba:	ff 75 0c             	pushl  0xc(%ebp)
  8030bd:	ff 75 08             	pushl  0x8(%ebp)
  8030c0:	50                   	push   %eax
  8030c1:	68 c9 3b 80 00       	push   $0x803bc9
  8030c6:	e8 9b d4 ff ff       	call   800566 <cprintf>
  8030cb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8030ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8030d1:	83 ec 08             	sub    $0x8,%esp
  8030d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8030d7:	50                   	push   %eax
  8030d8:	e8 1e d4 ff ff       	call   8004fb <vcprintf>
  8030dd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8030e0:	83 ec 08             	sub    $0x8,%esp
  8030e3:	6a 00                	push   $0x0
  8030e5:	68 e5 3b 80 00       	push   $0x803be5
  8030ea:	e8 0c d4 ff ff       	call   8004fb <vcprintf>
  8030ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8030f2:	e8 8d d3 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  8030f7:	eb fe                	jmp    8030f7 <_panic+0x70>

008030f9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
  8030fc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8030ff:	a1 20 40 80 00       	mov    0x804020,%eax
  803104:	8b 50 74             	mov    0x74(%eax),%edx
  803107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310a:	39 c2                	cmp    %eax,%edx
  80310c:	74 14                	je     803122 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	68 e8 3b 80 00       	push   $0x803be8
  803116:	6a 26                	push   $0x26
  803118:	68 34 3c 80 00       	push   $0x803c34
  80311d:	e8 65 ff ff ff       	call   803087 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803122:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803129:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803130:	e9 c2 00 00 00       	jmp    8031f7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803138:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	01 d0                	add    %edx,%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	75 08                	jne    803152 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80314a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80314d:	e9 a2 00 00 00       	jmp    8031f4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803152:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803159:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803160:	eb 69                	jmp    8031cb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803162:	a1 20 40 80 00       	mov    0x804020,%eax
  803167:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80316d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803170:	89 d0                	mov    %edx,%eax
  803172:	01 c0                	add    %eax,%eax
  803174:	01 d0                	add    %edx,%eax
  803176:	c1 e0 03             	shl    $0x3,%eax
  803179:	01 c8                	add    %ecx,%eax
  80317b:	8a 40 04             	mov    0x4(%eax),%al
  80317e:	84 c0                	test   %al,%al
  803180:	75 46                	jne    8031c8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803182:	a1 20 40 80 00       	mov    0x804020,%eax
  803187:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80318d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803190:	89 d0                	mov    %edx,%eax
  803192:	01 c0                	add    %eax,%eax
  803194:	01 d0                	add    %edx,%eax
  803196:	c1 e0 03             	shl    $0x3,%eax
  803199:	01 c8                	add    %ecx,%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8031a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8031a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	01 c8                	add    %ecx,%eax
  8031b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031bb:	39 c2                	cmp    %eax,%edx
  8031bd:	75 09                	jne    8031c8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8031bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8031c6:	eb 12                	jmp    8031da <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031c8:	ff 45 e8             	incl   -0x18(%ebp)
  8031cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8031d0:	8b 50 74             	mov    0x74(%eax),%edx
  8031d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d6:	39 c2                	cmp    %eax,%edx
  8031d8:	77 88                	ja     803162 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8031da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031de:	75 14                	jne    8031f4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	68 40 3c 80 00       	push   $0x803c40
  8031e8:	6a 3a                	push   $0x3a
  8031ea:	68 34 3c 80 00       	push   $0x803c34
  8031ef:	e8 93 fe ff ff       	call   803087 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8031f4:	ff 45 f0             	incl   -0x10(%ebp)
  8031f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031fd:	0f 8c 32 ff ff ff    	jl     803135 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803203:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80320a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803211:	eb 26                	jmp    803239 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803213:	a1 20 40 80 00       	mov    0x804020,%eax
  803218:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80321e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803221:	89 d0                	mov    %edx,%eax
  803223:	01 c0                	add    %eax,%eax
  803225:	01 d0                	add    %edx,%eax
  803227:	c1 e0 03             	shl    $0x3,%eax
  80322a:	01 c8                	add    %ecx,%eax
  80322c:	8a 40 04             	mov    0x4(%eax),%al
  80322f:	3c 01                	cmp    $0x1,%al
  803231:	75 03                	jne    803236 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803233:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803236:	ff 45 e0             	incl   -0x20(%ebp)
  803239:	a1 20 40 80 00       	mov    0x804020,%eax
  80323e:	8b 50 74             	mov    0x74(%eax),%edx
  803241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803244:	39 c2                	cmp    %eax,%edx
  803246:	77 cb                	ja     803213 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80324e:	74 14                	je     803264 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 94 3c 80 00       	push   $0x803c94
  803258:	6a 44                	push   $0x44
  80325a:	68 34 3c 80 00       	push   $0x803c34
  80325f:	e8 23 fe ff ff       	call   803087 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803264:	90                   	nop
  803265:	c9                   	leave  
  803266:	c3                   	ret    
  803267:	90                   	nop

00803268 <__udivdi3>:
  803268:	55                   	push   %ebp
  803269:	57                   	push   %edi
  80326a:	56                   	push   %esi
  80326b:	53                   	push   %ebx
  80326c:	83 ec 1c             	sub    $0x1c,%esp
  80326f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803273:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803277:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80327b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80327f:	89 ca                	mov    %ecx,%edx
  803281:	89 f8                	mov    %edi,%eax
  803283:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803287:	85 f6                	test   %esi,%esi
  803289:	75 2d                	jne    8032b8 <__udivdi3+0x50>
  80328b:	39 cf                	cmp    %ecx,%edi
  80328d:	77 65                	ja     8032f4 <__udivdi3+0x8c>
  80328f:	89 fd                	mov    %edi,%ebp
  803291:	85 ff                	test   %edi,%edi
  803293:	75 0b                	jne    8032a0 <__udivdi3+0x38>
  803295:	b8 01 00 00 00       	mov    $0x1,%eax
  80329a:	31 d2                	xor    %edx,%edx
  80329c:	f7 f7                	div    %edi
  80329e:	89 c5                	mov    %eax,%ebp
  8032a0:	31 d2                	xor    %edx,%edx
  8032a2:	89 c8                	mov    %ecx,%eax
  8032a4:	f7 f5                	div    %ebp
  8032a6:	89 c1                	mov    %eax,%ecx
  8032a8:	89 d8                	mov    %ebx,%eax
  8032aa:	f7 f5                	div    %ebp
  8032ac:	89 cf                	mov    %ecx,%edi
  8032ae:	89 fa                	mov    %edi,%edx
  8032b0:	83 c4 1c             	add    $0x1c,%esp
  8032b3:	5b                   	pop    %ebx
  8032b4:	5e                   	pop    %esi
  8032b5:	5f                   	pop    %edi
  8032b6:	5d                   	pop    %ebp
  8032b7:	c3                   	ret    
  8032b8:	39 ce                	cmp    %ecx,%esi
  8032ba:	77 28                	ja     8032e4 <__udivdi3+0x7c>
  8032bc:	0f bd fe             	bsr    %esi,%edi
  8032bf:	83 f7 1f             	xor    $0x1f,%edi
  8032c2:	75 40                	jne    803304 <__udivdi3+0x9c>
  8032c4:	39 ce                	cmp    %ecx,%esi
  8032c6:	72 0a                	jb     8032d2 <__udivdi3+0x6a>
  8032c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032cc:	0f 87 9e 00 00 00    	ja     803370 <__udivdi3+0x108>
  8032d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d7:	89 fa                	mov    %edi,%edx
  8032d9:	83 c4 1c             	add    $0x1c,%esp
  8032dc:	5b                   	pop    %ebx
  8032dd:	5e                   	pop    %esi
  8032de:	5f                   	pop    %edi
  8032df:	5d                   	pop    %ebp
  8032e0:	c3                   	ret    
  8032e1:	8d 76 00             	lea    0x0(%esi),%esi
  8032e4:	31 ff                	xor    %edi,%edi
  8032e6:	31 c0                	xor    %eax,%eax
  8032e8:	89 fa                	mov    %edi,%edx
  8032ea:	83 c4 1c             	add    $0x1c,%esp
  8032ed:	5b                   	pop    %ebx
  8032ee:	5e                   	pop    %esi
  8032ef:	5f                   	pop    %edi
  8032f0:	5d                   	pop    %ebp
  8032f1:	c3                   	ret    
  8032f2:	66 90                	xchg   %ax,%ax
  8032f4:	89 d8                	mov    %ebx,%eax
  8032f6:	f7 f7                	div    %edi
  8032f8:	31 ff                	xor    %edi,%edi
  8032fa:	89 fa                	mov    %edi,%edx
  8032fc:	83 c4 1c             	add    $0x1c,%esp
  8032ff:	5b                   	pop    %ebx
  803300:	5e                   	pop    %esi
  803301:	5f                   	pop    %edi
  803302:	5d                   	pop    %ebp
  803303:	c3                   	ret    
  803304:	bd 20 00 00 00       	mov    $0x20,%ebp
  803309:	89 eb                	mov    %ebp,%ebx
  80330b:	29 fb                	sub    %edi,%ebx
  80330d:	89 f9                	mov    %edi,%ecx
  80330f:	d3 e6                	shl    %cl,%esi
  803311:	89 c5                	mov    %eax,%ebp
  803313:	88 d9                	mov    %bl,%cl
  803315:	d3 ed                	shr    %cl,%ebp
  803317:	89 e9                	mov    %ebp,%ecx
  803319:	09 f1                	or     %esi,%ecx
  80331b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80331f:	89 f9                	mov    %edi,%ecx
  803321:	d3 e0                	shl    %cl,%eax
  803323:	89 c5                	mov    %eax,%ebp
  803325:	89 d6                	mov    %edx,%esi
  803327:	88 d9                	mov    %bl,%cl
  803329:	d3 ee                	shr    %cl,%esi
  80332b:	89 f9                	mov    %edi,%ecx
  80332d:	d3 e2                	shl    %cl,%edx
  80332f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803333:	88 d9                	mov    %bl,%cl
  803335:	d3 e8                	shr    %cl,%eax
  803337:	09 c2                	or     %eax,%edx
  803339:	89 d0                	mov    %edx,%eax
  80333b:	89 f2                	mov    %esi,%edx
  80333d:	f7 74 24 0c          	divl   0xc(%esp)
  803341:	89 d6                	mov    %edx,%esi
  803343:	89 c3                	mov    %eax,%ebx
  803345:	f7 e5                	mul    %ebp
  803347:	39 d6                	cmp    %edx,%esi
  803349:	72 19                	jb     803364 <__udivdi3+0xfc>
  80334b:	74 0b                	je     803358 <__udivdi3+0xf0>
  80334d:	89 d8                	mov    %ebx,%eax
  80334f:	31 ff                	xor    %edi,%edi
  803351:	e9 58 ff ff ff       	jmp    8032ae <__udivdi3+0x46>
  803356:	66 90                	xchg   %ax,%ax
  803358:	8b 54 24 08          	mov    0x8(%esp),%edx
  80335c:	89 f9                	mov    %edi,%ecx
  80335e:	d3 e2                	shl    %cl,%edx
  803360:	39 c2                	cmp    %eax,%edx
  803362:	73 e9                	jae    80334d <__udivdi3+0xe5>
  803364:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803367:	31 ff                	xor    %edi,%edi
  803369:	e9 40 ff ff ff       	jmp    8032ae <__udivdi3+0x46>
  80336e:	66 90                	xchg   %ax,%ax
  803370:	31 c0                	xor    %eax,%eax
  803372:	e9 37 ff ff ff       	jmp    8032ae <__udivdi3+0x46>
  803377:	90                   	nop

00803378 <__umoddi3>:
  803378:	55                   	push   %ebp
  803379:	57                   	push   %edi
  80337a:	56                   	push   %esi
  80337b:	53                   	push   %ebx
  80337c:	83 ec 1c             	sub    $0x1c,%esp
  80337f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803383:	8b 74 24 34          	mov    0x34(%esp),%esi
  803387:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80338b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80338f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803393:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803397:	89 f3                	mov    %esi,%ebx
  803399:	89 fa                	mov    %edi,%edx
  80339b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80339f:	89 34 24             	mov    %esi,(%esp)
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	75 1a                	jne    8033c0 <__umoddi3+0x48>
  8033a6:	39 f7                	cmp    %esi,%edi
  8033a8:	0f 86 a2 00 00 00    	jbe    803450 <__umoddi3+0xd8>
  8033ae:	89 c8                	mov    %ecx,%eax
  8033b0:	89 f2                	mov    %esi,%edx
  8033b2:	f7 f7                	div    %edi
  8033b4:	89 d0                	mov    %edx,%eax
  8033b6:	31 d2                	xor    %edx,%edx
  8033b8:	83 c4 1c             	add    $0x1c,%esp
  8033bb:	5b                   	pop    %ebx
  8033bc:	5e                   	pop    %esi
  8033bd:	5f                   	pop    %edi
  8033be:	5d                   	pop    %ebp
  8033bf:	c3                   	ret    
  8033c0:	39 f0                	cmp    %esi,%eax
  8033c2:	0f 87 ac 00 00 00    	ja     803474 <__umoddi3+0xfc>
  8033c8:	0f bd e8             	bsr    %eax,%ebp
  8033cb:	83 f5 1f             	xor    $0x1f,%ebp
  8033ce:	0f 84 ac 00 00 00    	je     803480 <__umoddi3+0x108>
  8033d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8033d9:	29 ef                	sub    %ebp,%edi
  8033db:	89 fe                	mov    %edi,%esi
  8033dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033e1:	89 e9                	mov    %ebp,%ecx
  8033e3:	d3 e0                	shl    %cl,%eax
  8033e5:	89 d7                	mov    %edx,%edi
  8033e7:	89 f1                	mov    %esi,%ecx
  8033e9:	d3 ef                	shr    %cl,%edi
  8033eb:	09 c7                	or     %eax,%edi
  8033ed:	89 e9                	mov    %ebp,%ecx
  8033ef:	d3 e2                	shl    %cl,%edx
  8033f1:	89 14 24             	mov    %edx,(%esp)
  8033f4:	89 d8                	mov    %ebx,%eax
  8033f6:	d3 e0                	shl    %cl,%eax
  8033f8:	89 c2                	mov    %eax,%edx
  8033fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033fe:	d3 e0                	shl    %cl,%eax
  803400:	89 44 24 04          	mov    %eax,0x4(%esp)
  803404:	8b 44 24 08          	mov    0x8(%esp),%eax
  803408:	89 f1                	mov    %esi,%ecx
  80340a:	d3 e8                	shr    %cl,%eax
  80340c:	09 d0                	or     %edx,%eax
  80340e:	d3 eb                	shr    %cl,%ebx
  803410:	89 da                	mov    %ebx,%edx
  803412:	f7 f7                	div    %edi
  803414:	89 d3                	mov    %edx,%ebx
  803416:	f7 24 24             	mull   (%esp)
  803419:	89 c6                	mov    %eax,%esi
  80341b:	89 d1                	mov    %edx,%ecx
  80341d:	39 d3                	cmp    %edx,%ebx
  80341f:	0f 82 87 00 00 00    	jb     8034ac <__umoddi3+0x134>
  803425:	0f 84 91 00 00 00    	je     8034bc <__umoddi3+0x144>
  80342b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80342f:	29 f2                	sub    %esi,%edx
  803431:	19 cb                	sbb    %ecx,%ebx
  803433:	89 d8                	mov    %ebx,%eax
  803435:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803439:	d3 e0                	shl    %cl,%eax
  80343b:	89 e9                	mov    %ebp,%ecx
  80343d:	d3 ea                	shr    %cl,%edx
  80343f:	09 d0                	or     %edx,%eax
  803441:	89 e9                	mov    %ebp,%ecx
  803443:	d3 eb                	shr    %cl,%ebx
  803445:	89 da                	mov    %ebx,%edx
  803447:	83 c4 1c             	add    $0x1c,%esp
  80344a:	5b                   	pop    %ebx
  80344b:	5e                   	pop    %esi
  80344c:	5f                   	pop    %edi
  80344d:	5d                   	pop    %ebp
  80344e:	c3                   	ret    
  80344f:	90                   	nop
  803450:	89 fd                	mov    %edi,%ebp
  803452:	85 ff                	test   %edi,%edi
  803454:	75 0b                	jne    803461 <__umoddi3+0xe9>
  803456:	b8 01 00 00 00       	mov    $0x1,%eax
  80345b:	31 d2                	xor    %edx,%edx
  80345d:	f7 f7                	div    %edi
  80345f:	89 c5                	mov    %eax,%ebp
  803461:	89 f0                	mov    %esi,%eax
  803463:	31 d2                	xor    %edx,%edx
  803465:	f7 f5                	div    %ebp
  803467:	89 c8                	mov    %ecx,%eax
  803469:	f7 f5                	div    %ebp
  80346b:	89 d0                	mov    %edx,%eax
  80346d:	e9 44 ff ff ff       	jmp    8033b6 <__umoddi3+0x3e>
  803472:	66 90                	xchg   %ax,%ax
  803474:	89 c8                	mov    %ecx,%eax
  803476:	89 f2                	mov    %esi,%edx
  803478:	83 c4 1c             	add    $0x1c,%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	3b 04 24             	cmp    (%esp),%eax
  803483:	72 06                	jb     80348b <__umoddi3+0x113>
  803485:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803489:	77 0f                	ja     80349a <__umoddi3+0x122>
  80348b:	89 f2                	mov    %esi,%edx
  80348d:	29 f9                	sub    %edi,%ecx
  80348f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803493:	89 14 24             	mov    %edx,(%esp)
  803496:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80349a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80349e:	8b 14 24             	mov    (%esp),%edx
  8034a1:	83 c4 1c             	add    $0x1c,%esp
  8034a4:	5b                   	pop    %ebx
  8034a5:	5e                   	pop    %esi
  8034a6:	5f                   	pop    %edi
  8034a7:	5d                   	pop    %ebp
  8034a8:	c3                   	ret    
  8034a9:	8d 76 00             	lea    0x0(%esi),%esi
  8034ac:	2b 04 24             	sub    (%esp),%eax
  8034af:	19 fa                	sbb    %edi,%edx
  8034b1:	89 d1                	mov    %edx,%ecx
  8034b3:	89 c6                	mov    %eax,%esi
  8034b5:	e9 71 ff ff ff       	jmp    80342b <__umoddi3+0xb3>
  8034ba:	66 90                	xchg   %ax,%ax
  8034bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034c0:	72 ea                	jb     8034ac <__umoddi3+0x134>
  8034c2:	89 d9                	mov    %ebx,%ecx
  8034c4:	e9 62 ff ff ff       	jmp    80342b <__umoddi3+0xb3>
