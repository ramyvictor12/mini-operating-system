
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 ed 1c 00 00       	call   801d30 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 00 36 80 00       	push   $0x803600
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 93 17 00 00       	call   8017f7 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 04 36 80 00       	push   $0x803604
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 7d 17 00 00       	call   8017f7 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 0c 36 80 00       	push   $0x80360c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 60 17 00 00       	call   8017f7 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 1a 36 80 00       	push   $0x80361a
  8000b0:	e8 7f 16 00 00       	call   801734 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 29 36 80 00       	push   $0x803629
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 45 36 80 00       	push   $0x803645
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 47 36 80 00       	push   $0x803647
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 4c 36 80 00       	push   $0x80364c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 36 13 00 00       	call   8015d3 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 21 13 00 00       	call   8015d3 <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 ff 11 00 00       	call   80165e <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 f1 11 00 00       	call   80165e <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 99 18 00 00       	call   801d17 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 3b 16 00 00       	call   801b24 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 68 36 80 00       	push   $0x803668
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 90 36 80 00       	push   $0x803690
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 40 80 00       	mov    0x804020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 b8 36 80 00       	push   $0x8036b8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 10 37 80 00       	push   $0x803710
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 68 36 80 00       	push   $0x803668
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 bb 15 00 00       	call   801b3e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 48 17 00 00       	call   801ce3 <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 9d 17 00 00       	call   801d49 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 40 80 00       	mov    0x804024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 7c 13 00 00       	call   801976 <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 40 80 00       	mov    0x804024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 05 13 00 00       	call   801976 <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 69 14 00 00       	call   801b24 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 63 14 00 00       	call   801b3e <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 5f 2c 00 00       	call   803384 <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 1f 2d 00 00       	call   803494 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 54 39 80 00       	add    $0x803954,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 65 39 80 00       	push   $0x803965
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 6e 39 80 00       	push   $0x80396e
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 d0 3a 80 00       	push   $0x803ad0
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801444:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80144b:	00 00 00 
  80144e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801455:	00 00 00 
  801458:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80145f:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801462:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801469:	00 00 00 
  80146c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801473:	00 00 00 
  801476:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80147d:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801480:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801487:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80148a:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801491:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a5:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8014aa:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8014b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014be:	83 ec 04             	sub    $0x4,%esp
  8014c1:	6a 06                	push   $0x6
  8014c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c6:	50                   	push   %eax
  8014c7:	e8 ee 05 00 00       	call   801aba <sys_allocate_chunk>
  8014cc:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014cf:	a1 20 41 80 00       	mov    0x804120,%eax
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	50                   	push   %eax
  8014d8:	e8 63 0c 00 00       	call   802140 <initialize_MemBlocksList>
  8014dd:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8014e0:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8014e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014eb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8014f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801503:	89 c2                	mov    %eax,%edx
  801505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801508:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80150b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801515:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80151c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151f:	8b 50 08             	mov    0x8(%eax),%edx
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	48                   	dec    %eax
  801528:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80152b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152e:	ba 00 00 00 00       	mov    $0x0,%edx
  801533:	f7 75 e0             	divl   -0x20(%ebp)
  801536:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801539:	29 d0                	sub    %edx,%eax
  80153b:	89 c2                	mov    %eax,%edx
  80153d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801540:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801543:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801547:	75 14                	jne    80155d <initialize_dyn_block_system+0x11f>
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 f5 3a 80 00       	push   $0x803af5
  801551:	6a 34                	push   $0x34
  801553:	68 13 3b 80 00       	push   $0x803b13
  801558:	e8 47 1c 00 00       	call   8031a4 <_panic>
  80155d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801560:	8b 00                	mov    (%eax),%eax
  801562:	85 c0                	test   %eax,%eax
  801564:	74 10                	je     801576 <initialize_dyn_block_system+0x138>
  801566:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80156e:	8b 52 04             	mov    0x4(%edx),%edx
  801571:	89 50 04             	mov    %edx,0x4(%eax)
  801574:	eb 0b                	jmp    801581 <initialize_dyn_block_system+0x143>
  801576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801579:	8b 40 04             	mov    0x4(%eax),%eax
  80157c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801584:	8b 40 04             	mov    0x4(%eax),%eax
  801587:	85 c0                	test   %eax,%eax
  801589:	74 0f                	je     80159a <initialize_dyn_block_system+0x15c>
  80158b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158e:	8b 40 04             	mov    0x4(%eax),%eax
  801591:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801594:	8b 12                	mov    (%edx),%edx
  801596:	89 10                	mov    %edx,(%eax)
  801598:	eb 0a                	jmp    8015a4 <initialize_dyn_block_system+0x166>
  80159a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159d:	8b 00                	mov    (%eax),%eax
  80159f:	a3 48 41 80 00       	mov    %eax,0x804148
  8015a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8015bc:	48                   	dec    %eax
  8015bd:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8015c2:	83 ec 0c             	sub    $0xc,%esp
  8015c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015c8:	e8 c4 13 00 00       	call   802991 <insert_sorted_with_merge_freeList>
  8015cd:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d9:	e8 2f fe ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  8015de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e2:	75 07                	jne    8015eb <malloc+0x18>
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e9:	eb 71                	jmp    80165c <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8015eb:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015f2:	76 07                	jbe    8015fb <malloc+0x28>
	return NULL;
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f9:	eb 61                	jmp    80165c <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015fb:	e8 88 08 00 00       	call   801e88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801600:	85 c0                	test   %eax,%eax
  801602:	74 53                	je     801657 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801604:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80160b:	8b 55 08             	mov    0x8(%ebp),%edx
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	48                   	dec    %eax
  801614:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	f7 75 f4             	divl   -0xc(%ebp)
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	29 d0                	sub    %edx,%eax
  801627:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	ff 75 ec             	pushl  -0x14(%ebp)
  801630:	e8 d2 0d 00 00       	call   802407 <alloc_block_FF>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80163b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80163f:	74 16                	je     801657 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	ff 75 e8             	pushl  -0x18(%ebp)
  801647:	e8 0c 0c 00 00       	call   802258 <insert_sorted_allocList>
  80164c:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80164f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801652:	8b 40 08             	mov    0x8(%eax),%eax
  801655:	eb 05                	jmp    80165c <malloc+0x89>
    }

			}


	return NULL;
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	ff 75 f0             	pushl  -0x10(%ebp)
  80167b:	68 40 40 80 00       	push   $0x804040
  801680:	e8 a0 0b 00 00       	call   802225 <find_block>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80168b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168e:	8b 50 0c             	mov    0xc(%eax),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	52                   	push   %edx
  801698:	50                   	push   %eax
  801699:	e8 e4 03 00 00       	call   801a82 <sys_free_user_mem>
  80169e:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8016a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a5:	75 17                	jne    8016be <free+0x60>
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	68 f5 3a 80 00       	push   $0x803af5
  8016af:	68 84 00 00 00       	push   $0x84
  8016b4:	68 13 3b 80 00       	push   $0x803b13
  8016b9:	e8 e6 1a 00 00       	call   8031a4 <_panic>
  8016be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	74 10                	je     8016d7 <free+0x79>
  8016c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016cf:	8b 52 04             	mov    0x4(%edx),%edx
  8016d2:	89 50 04             	mov    %edx,0x4(%eax)
  8016d5:	eb 0b                	jmp    8016e2 <free+0x84>
  8016d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016da:	8b 40 04             	mov    0x4(%eax),%eax
  8016dd:	a3 44 40 80 00       	mov    %eax,0x804044
  8016e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e5:	8b 40 04             	mov    0x4(%eax),%eax
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 0f                	je     8016fb <free+0x9d>
  8016ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ef:	8b 40 04             	mov    0x4(%eax),%eax
  8016f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f5:	8b 12                	mov    (%edx),%edx
  8016f7:	89 10                	mov    %edx,(%eax)
  8016f9:	eb 0a                	jmp    801705 <free+0xa7>
  8016fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fe:	8b 00                	mov    (%eax),%eax
  801700:	a3 40 40 80 00       	mov    %eax,0x804040
  801705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80170e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801718:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80171d:	48                   	dec    %eax
  80171e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	ff 75 ec             	pushl  -0x14(%ebp)
  801729:	e8 63 12 00 00       	call   802991 <insert_sorted_with_merge_freeList>
  80172e:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801731:	90                   	nop
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 38             	sub    $0x38,%esp
  80173a:	8b 45 10             	mov    0x10(%ebp),%eax
  80173d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801740:	e8 c8 fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801745:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801749:	75 0a                	jne    801755 <smalloc+0x21>
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
  801750:	e9 a0 00 00 00       	jmp    8017f5 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801755:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80175c:	76 0a                	jbe    801768 <smalloc+0x34>
		return NULL;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	e9 8d 00 00 00       	jmp    8017f5 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801768:	e8 1b 07 00 00       	call   801e88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176d:	85 c0                	test   %eax,%eax
  80176f:	74 7f                	je     8017f0 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801771:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	48                   	dec    %eax
  801781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	ba 00 00 00 00       	mov    $0x0,%edx
  80178c:	f7 75 f4             	divl   -0xc(%ebp)
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	29 d0                	sub    %edx,%eax
  801794:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801797:	83 ec 0c             	sub    $0xc,%esp
  80179a:	ff 75 ec             	pushl  -0x14(%ebp)
  80179d:	e8 65 0c 00 00       	call   802407 <alloc_block_FF>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8017a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017ac:	74 42                	je     8017f0 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b4:	e8 9f 0a 00 00       	call   802258 <insert_sorted_allocList>
  8017b9:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8017bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017bf:	8b 40 08             	mov    0x8(%eax),%eax
  8017c2:	89 c2                	mov    %eax,%edx
  8017c4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 38 04 00 00       	call   801c0d <sys_createSharedObject>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8017db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017df:	79 07                	jns    8017e8 <smalloc+0xb4>
	    		  return NULL;
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	eb 0d                	jmp    8017f5 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8017e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017eb:	8b 40 08             	mov    0x8(%eax),%eax
  8017ee:	eb 05                	jmp    8017f5 <smalloc+0xc1>


				}


		return NULL;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fd:	e8 0b fc ff ff       	call   80140d <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801802:	e8 81 06 00 00       	call   801e88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801807:	85 c0                	test   %eax,%eax
  801809:	0f 84 9f 00 00 00    	je     8018ae <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	e8 1a 04 00 00       	call   801c37 <sys_getSizeOfSharedObject>
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801827:	79 0a                	jns    801833 <sget+0x3c>
		return NULL;
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
  80182e:	e9 80 00 00 00       	jmp    8018b3 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801833:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80183a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801840:	01 d0                	add    %edx,%eax
  801842:	48                   	dec    %eax
  801843:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801849:	ba 00 00 00 00       	mov    $0x0,%edx
  80184e:	f7 75 f0             	divl   -0x10(%ebp)
  801851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801854:	29 d0                	sub    %edx,%eax
  801856:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801859:	83 ec 0c             	sub    $0xc,%esp
  80185c:	ff 75 e8             	pushl  -0x18(%ebp)
  80185f:	e8 a3 0b 00 00       	call   802407 <alloc_block_FF>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80186a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80186e:	74 3e                	je     8018ae <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	ff 75 e4             	pushl  -0x1c(%ebp)
  801876:	e8 dd 09 00 00       	call   802258 <insert_sorted_allocList>
  80187b:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80187e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801881:	8b 40 08             	mov    0x8(%eax),%eax
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 c1 03 00 00       	call   801c54 <sys_getSharedObject>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801899:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80189d:	79 07                	jns    8018a6 <sget+0xaf>
	    		  return NULL;
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a4:	eb 0d                	jmp    8018b3 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8018a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a9:	8b 40 08             	mov    0x8(%eax),%eax
  8018ac:	eb 05                	jmp    8018b3 <sget+0xbc>
	      }
	}
	   return NULL;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018bb:	e8 4d fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 20 3b 80 00       	push   $0x803b20
  8018c8:	68 12 01 00 00       	push   $0x112
  8018cd:	68 13 3b 80 00       	push   $0x803b13
  8018d2:	e8 cd 18 00 00       	call   8031a4 <_panic>

008018d7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 48 3b 80 00       	push   $0x803b48
  8018e5:	68 26 01 00 00       	push   $0x126
  8018ea:	68 13 3b 80 00       	push   $0x803b13
  8018ef:	e8 b0 18 00 00       	call   8031a4 <_panic>

008018f4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	68 6c 3b 80 00       	push   $0x803b6c
  801902:	68 31 01 00 00       	push   $0x131
  801907:	68 13 3b 80 00       	push   $0x803b13
  80190c:	e8 93 18 00 00       	call   8031a4 <_panic>

00801911 <shrink>:

}
void shrink(uint32 newSize)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	68 6c 3b 80 00       	push   $0x803b6c
  80191f:	68 36 01 00 00       	push   $0x136
  801924:	68 13 3b 80 00       	push   $0x803b13
  801929:	e8 76 18 00 00       	call   8031a4 <_panic>

0080192e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	68 6c 3b 80 00       	push   $0x803b6c
  80193c:	68 3b 01 00 00       	push   $0x13b
  801941:	68 13 3b 80 00       	push   $0x803b13
  801946:	e8 59 18 00 00       	call   8031a4 <_panic>

0080194b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801960:	8b 7d 18             	mov    0x18(%ebp),%edi
  801963:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801966:	cd 30                	int    $0x30
  801968:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80196b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5f                   	pop    %edi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    

00801976 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	8b 45 10             	mov    0x10(%ebp),%eax
  80197f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801982:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	6a 00                	push   $0x0
  801994:	e8 b2 ff ff ff       	call   80194b <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_cgetc>:

int
sys_cgetc(void)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 01                	push   $0x1
  8019ae:	e8 98 ff ff ff       	call   80194b <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	6a 05                	push   $0x5
  8019cb:	e8 7b ff ff ff       	call   80194b <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019da:	8b 75 18             	mov    0x18(%ebp),%esi
  8019dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	56                   	push   %esi
  8019ea:	53                   	push   %ebx
  8019eb:	51                   	push   %ecx
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 06                	push   $0x6
  8019f0:	e8 56 ff ff ff       	call   80194b <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5d                   	pop    %ebp
  8019fe:	c3                   	ret    

008019ff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	52                   	push   %edx
  801a0f:	50                   	push   %eax
  801a10:	6a 07                	push   $0x7
  801a12:	e8 34 ff ff ff       	call   80194b <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	6a 08                	push   $0x8
  801a2d:	e8 19 ff ff ff       	call   80194b <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 09                	push   $0x9
  801a46:	e8 00 ff ff ff       	call   80194b <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 0a                	push   $0xa
  801a5f:	e8 e7 fe ff ff       	call   80194b <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 0b                	push   $0xb
  801a78:	e8 ce fe ff ff       	call   80194b <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	ff 75 08             	pushl  0x8(%ebp)
  801a91:	6a 0f                	push   $0xf
  801a93:	e8 b3 fe ff ff       	call   80194b <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
	return;
  801a9b:	90                   	nop
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	6a 10                	push   $0x10
  801aaf:	e8 97 fe ff ff       	call   80194b <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab7:	90                   	nop
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	ff 75 10             	pushl  0x10(%ebp)
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	ff 75 08             	pushl  0x8(%ebp)
  801aca:	6a 11                	push   $0x11
  801acc:	e8 7a fe ff ff       	call   80194b <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad4:	90                   	nop
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 0c                	push   $0xc
  801ae6:	e8 60 fe ff ff       	call   80194b <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	6a 0d                	push   $0xd
  801b00:	e8 46 fe ff ff       	call   80194b <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 0e                	push   $0xe
  801b19:	e8 2d fe ff ff       	call   80194b <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 13                	push   $0x13
  801b33:	e8 13 fe ff ff       	call   80194b <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 14                	push   $0x14
  801b4d:	e8 f9 fd ff ff       	call   80194b <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	90                   	nop
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b64:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	50                   	push   %eax
  801b71:	6a 15                	push   $0x15
  801b73:	e8 d3 fd ff ff       	call   80194b <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 16                	push   $0x16
  801b8d:	e8 b9 fd ff ff       	call   80194b <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	90                   	nop
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	50                   	push   %eax
  801ba8:	6a 17                	push   $0x17
  801baa:	e8 9c fd ff ff       	call   80194b <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 1a                	push   $0x1a
  801bc7:	e8 7f fd ff ff       	call   80194b <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	52                   	push   %edx
  801be1:	50                   	push   %eax
  801be2:	6a 18                	push   $0x18
  801be4:	e8 62 fd ff ff       	call   80194b <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	6a 19                	push   $0x19
  801c02:	e8 44 fd ff ff       	call   80194b <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	90                   	nop
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	8b 45 10             	mov    0x10(%ebp),%eax
  801c16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	6a 00                	push   $0x0
  801c25:	51                   	push   %ecx
  801c26:	52                   	push   %edx
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	50                   	push   %eax
  801c2b:	6a 1b                	push   $0x1b
  801c2d:	e8 19 fd ff ff       	call   80194b <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	52                   	push   %edx
  801c47:	50                   	push   %eax
  801c48:	6a 1c                	push   $0x1c
  801c4a:	e8 fc fc ff ff       	call   80194b <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	51                   	push   %ecx
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	6a 1d                	push   $0x1d
  801c69:	e8 dd fc ff ff       	call   80194b <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	6a 1e                	push   $0x1e
  801c86:	e8 c0 fc ff ff       	call   80194b <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 1f                	push   $0x1f
  801c9f:	e8 a7 fc ff ff       	call   80194b <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	6a 00                	push   $0x0
  801cb1:	ff 75 14             	pushl  0x14(%ebp)
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	50                   	push   %eax
  801cbb:	6a 20                	push   $0x20
  801cbd:	e8 89 fc ff ff       	call   80194b <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	50                   	push   %eax
  801cd6:	6a 21                	push   $0x21
  801cd8:	e8 6e fc ff ff       	call   80194b <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	50                   	push   %eax
  801cf2:	6a 22                	push   $0x22
  801cf4:	e8 52 fc ff ff       	call   80194b <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 02                	push   $0x2
  801d0d:	e8 39 fc ff ff       	call   80194b <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 03                	push   $0x3
  801d26:	e8 20 fc ff ff       	call   80194b <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 04                	push   $0x4
  801d3f:	e8 07 fc ff ff       	call   80194b <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_exit_env>:


void sys_exit_env(void)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 23                	push   $0x23
  801d58:	e8 ee fb ff ff       	call   80194b <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	90                   	nop
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6c:	8d 50 04             	lea    0x4(%eax),%edx
  801d6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	6a 24                	push   $0x24
  801d7c:	e8 ca fb ff ff       	call   80194b <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
	return result;
  801d84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d8d:	89 01                	mov    %eax,(%ecx)
  801d8f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	c9                   	leave  
  801d96:	c2 04 00             	ret    $0x4

00801d99 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	ff 75 10             	pushl  0x10(%ebp)
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 12                	push   $0x12
  801dab:	e8 9b fb ff ff       	call   80194b <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return ;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 25                	push   $0x25
  801dc5:	e8 81 fb ff ff       	call   80194b <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 04             	sub    $0x4,%esp
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ddb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	50                   	push   %eax
  801de8:	6a 26                	push   $0x26
  801dea:	e8 5c fb ff ff       	call   80194b <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
	return ;
  801df2:	90                   	nop
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <rsttst>:
void rsttst()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 28                	push   $0x28
  801e04:	e8 42 fb ff ff       	call   80194b <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0c:	90                   	nop
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 04             	sub    $0x4,%esp
  801e15:	8b 45 14             	mov    0x14(%ebp),%eax
  801e18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e1b:	8b 55 18             	mov    0x18(%ebp),%edx
  801e1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e22:	52                   	push   %edx
  801e23:	50                   	push   %eax
  801e24:	ff 75 10             	pushl  0x10(%ebp)
  801e27:	ff 75 0c             	pushl  0xc(%ebp)
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	6a 27                	push   $0x27
  801e2f:	e8 17 fb ff ff       	call   80194b <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
	return ;
  801e37:	90                   	nop
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <chktst>:
void chktst(uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 29                	push   $0x29
  801e4a:	e8 fc fa ff ff       	call   80194b <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <inctst>:

void inctst()
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 2a                	push   $0x2a
  801e64:	e8 e2 fa ff ff       	call   80194b <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6c:	90                   	nop
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <gettst>:
uint32 gettst()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 2b                	push   $0x2b
  801e7e:	e8 c8 fa ff ff       	call   80194b <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 2c                	push   $0x2c
  801e9a:	e8 ac fa ff ff       	call   80194b <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
  801ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ea9:	75 07                	jne    801eb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eab:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb0:	eb 05                	jmp    801eb7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 2c                	push   $0x2c
  801ecb:	e8 7b fa ff ff       	call   80194b <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eda:	75 07                	jne    801ee3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801edc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee1:	eb 05                	jmp    801ee8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 2c                	push   $0x2c
  801efc:	e8 4a fa ff ff       	call   80194b <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
  801f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f07:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f0b:	75 07                	jne    801f14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f12:	eb 05                	jmp    801f19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 2c                	push   $0x2c
  801f2d:	e8 19 fa ff ff       	call   80194b <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
  801f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f3c:	75 07                	jne    801f45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f43:	eb 05                	jmp    801f4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	6a 2d                	push   $0x2d
  801f5c:	e8 ea f9 ff ff       	call   80194b <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
	return ;
  801f64:	90                   	nop
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	53                   	push   %ebx
  801f7a:	51                   	push   %ecx
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 2e                	push   $0x2e
  801f7f:	e8 c7 f9 ff ff       	call   80194b <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	52                   	push   %edx
  801f9c:	50                   	push   %eax
  801f9d:	6a 2f                	push   $0x2f
  801f9f:	e8 a7 f9 ff ff       	call   80194b <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	68 7c 3b 80 00       	push   $0x803b7c
  801fb7:	e8 c7 e6 ff ff       	call   800683 <cprintf>
  801fbc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	68 a8 3b 80 00       	push   $0x803ba8
  801fce:	e8 b0 e6 ff ff       	call   800683 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fd6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fda:	a1 38 41 80 00       	mov    0x804138,%eax
  801fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe2:	eb 56                	jmp    80203a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe8:	74 1c                	je     802006 <print_mem_block_lists+0x5d>
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 50 08             	mov    0x8(%eax),%edx
  801ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff3:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffc:	01 c8                	add    %ecx,%eax
  801ffe:	39 c2                	cmp    %eax,%edx
  802000:	73 04                	jae    802006 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802002:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	8b 50 08             	mov    0x8(%eax),%edx
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 40 0c             	mov    0xc(%eax),%eax
  802012:	01 c2                	add    %eax,%edx
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 40 08             	mov    0x8(%eax),%eax
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	68 bd 3b 80 00       	push   $0x803bbd
  802024:	e8 5a e6 ff ff       	call   800683 <cprintf>
  802029:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802032:	a1 40 41 80 00       	mov    0x804140,%eax
  802037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203e:	74 07                	je     802047 <print_mem_block_lists+0x9e>
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	eb 05                	jmp    80204c <print_mem_block_lists+0xa3>
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	a3 40 41 80 00       	mov    %eax,0x804140
  802051:	a1 40 41 80 00       	mov    0x804140,%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	75 8a                	jne    801fe4 <print_mem_block_lists+0x3b>
  80205a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205e:	75 84                	jne    801fe4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802060:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802064:	75 10                	jne    802076 <print_mem_block_lists+0xcd>
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	68 cc 3b 80 00       	push   $0x803bcc
  80206e:	e8 10 e6 ff ff       	call   800683 <cprintf>
  802073:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802076:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	68 f0 3b 80 00       	push   $0x803bf0
  802085:	e8 f9 e5 ff ff       	call   800683 <cprintf>
  80208a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80208d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802091:	a1 40 40 80 00       	mov    0x804040,%eax
  802096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802099:	eb 56                	jmp    8020f1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80209b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209f:	74 1c                	je     8020bd <print_mem_block_lists+0x114>
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 50 08             	mov    0x8(%eax),%edx
  8020a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b3:	01 c8                	add    %ecx,%eax
  8020b5:	39 c2                	cmp    %eax,%edx
  8020b7:	73 04                	jae    8020bd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020b9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c0:	8b 50 08             	mov    0x8(%eax),%edx
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c9:	01 c2                	add    %eax,%edx
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 40 08             	mov    0x8(%eax),%eax
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	52                   	push   %edx
  8020d5:	50                   	push   %eax
  8020d6:	68 bd 3b 80 00       	push   $0x803bbd
  8020db:	e8 a3 e5 ff ff       	call   800683 <cprintf>
  8020e0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020e9:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f5:	74 07                	je     8020fe <print_mem_block_lists+0x155>
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	8b 00                	mov    (%eax),%eax
  8020fc:	eb 05                	jmp    802103 <print_mem_block_lists+0x15a>
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802103:	a3 48 40 80 00       	mov    %eax,0x804048
  802108:	a1 48 40 80 00       	mov    0x804048,%eax
  80210d:	85 c0                	test   %eax,%eax
  80210f:	75 8a                	jne    80209b <print_mem_block_lists+0xf2>
  802111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802115:	75 84                	jne    80209b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802117:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80211b:	75 10                	jne    80212d <print_mem_block_lists+0x184>
  80211d:	83 ec 0c             	sub    $0xc,%esp
  802120:	68 08 3c 80 00       	push   $0x803c08
  802125:	e8 59 e5 ff ff       	call   800683 <cprintf>
  80212a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	68 7c 3b 80 00       	push   $0x803b7c
  802135:	e8 49 e5 ff ff       	call   800683 <cprintf>
  80213a:	83 c4 10             	add    $0x10,%esp

}
  80213d:	90                   	nop
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802146:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80214d:	00 00 00 
  802150:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802157:	00 00 00 
  80215a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802161:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802164:	a1 50 40 80 00       	mov    0x804050,%eax
  802169:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80216c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802173:	e9 9e 00 00 00       	jmp    802216 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802178:	a1 50 40 80 00       	mov    0x804050,%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	c1 e2 04             	shl    $0x4,%edx
  802183:	01 d0                	add    %edx,%eax
  802185:	85 c0                	test   %eax,%eax
  802187:	75 14                	jne    80219d <initialize_MemBlocksList+0x5d>
  802189:	83 ec 04             	sub    $0x4,%esp
  80218c:	68 30 3c 80 00       	push   $0x803c30
  802191:	6a 48                	push   $0x48
  802193:	68 53 3c 80 00       	push   $0x803c53
  802198:	e8 07 10 00 00       	call   8031a4 <_panic>
  80219d:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a5:	c1 e2 04             	shl    $0x4,%edx
  8021a8:	01 d0                	add    %edx,%eax
  8021aa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021b0:	89 10                	mov    %edx,(%eax)
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	74 18                	je     8021d0 <initialize_MemBlocksList+0x90>
  8021b8:	a1 48 41 80 00       	mov    0x804148,%eax
  8021bd:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021c3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021c6:	c1 e1 04             	shl    $0x4,%ecx
  8021c9:	01 ca                	add    %ecx,%edx
  8021cb:	89 50 04             	mov    %edx,0x4(%eax)
  8021ce:	eb 12                	jmp    8021e2 <initialize_MemBlocksList+0xa2>
  8021d0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d8:	c1 e2 04             	shl    $0x4,%edx
  8021db:	01 d0                	add    %edx,%eax
  8021dd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021e2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ea:	c1 e2 04             	shl    $0x4,%edx
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	a3 48 41 80 00       	mov    %eax,0x804148
  8021f4:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fc:	c1 e2 04             	shl    $0x4,%edx
  8021ff:	01 d0                	add    %edx,%eax
  802201:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802208:	a1 54 41 80 00       	mov    0x804154,%eax
  80220d:	40                   	inc    %eax
  80220e:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802213:	ff 45 f4             	incl   -0xc(%ebp)
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	3b 45 08             	cmp    0x8(%ebp),%eax
  80221c:	0f 82 56 ff ff ff    	jb     802178 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802222:	90                   	nop
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802233:	eb 18                	jmp    80224d <find_block+0x28>
		{
			if(tmp->sva==va)
  802235:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802238:	8b 40 08             	mov    0x8(%eax),%eax
  80223b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80223e:	75 05                	jne    802245 <find_block+0x20>
			{
				return tmp;
  802240:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802243:	eb 11                	jmp    802256 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802245:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80224d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802251:	75 e2                	jne    802235 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802253:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80225e:	a1 40 40 80 00       	mov    0x804040,%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	0f 85 83 00 00 00    	jne    8022ee <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80226b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802272:	00 00 00 
  802275:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80227c:	00 00 00 
  80227f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802286:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228d:	75 14                	jne    8022a3 <insert_sorted_allocList+0x4b>
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	68 30 3c 80 00       	push   $0x803c30
  802297:	6a 7f                	push   $0x7f
  802299:	68 53 3c 80 00       	push   $0x803c53
  80229e:	e8 01 0f 00 00       	call   8031a4 <_panic>
  8022a3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 0d                	je     8022c4 <insert_sorted_allocList+0x6c>
  8022b7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	eb 08                	jmp    8022cc <insert_sorted_allocList+0x74>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 44 40 80 00       	mov    %eax,0x804044
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 40 40 80 00       	mov    %eax,0x804040
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022de:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e3:	40                   	inc    %eax
  8022e4:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022e9:	e9 16 01 00 00       	jmp    802404 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8b 50 08             	mov    0x8(%eax),%edx
  8022f4:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f9:	8b 40 08             	mov    0x8(%eax),%eax
  8022fc:	39 c2                	cmp    %eax,%edx
  8022fe:	76 68                	jbe    802368 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802304:	75 17                	jne    80231d <insert_sorted_allocList+0xc5>
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	68 6c 3c 80 00       	push   $0x803c6c
  80230e:	68 85 00 00 00       	push   $0x85
  802313:	68 53 3c 80 00       	push   $0x803c53
  802318:	e8 87 0e 00 00       	call   8031a4 <_panic>
  80231d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	89 50 04             	mov    %edx,0x4(%eax)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 40 04             	mov    0x4(%eax),%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 0c                	je     80233f <insert_sorted_allocList+0xe7>
  802333:	a1 44 40 80 00       	mov    0x804044,%eax
  802338:	8b 55 08             	mov    0x8(%ebp),%edx
  80233b:	89 10                	mov    %edx,(%eax)
  80233d:	eb 08                	jmp    802347 <insert_sorted_allocList+0xef>
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	a3 40 40 80 00       	mov    %eax,0x804040
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	a3 44 40 80 00       	mov    %eax,0x804044
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802358:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80235d:	40                   	inc    %eax
  80235e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802363:	e9 9c 00 00 00       	jmp    802404 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802368:	a1 40 40 80 00       	mov    0x804040,%eax
  80236d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802370:	e9 85 00 00 00       	jmp    8023fa <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	8b 50 08             	mov    0x8(%eax),%edx
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 08             	mov    0x8(%eax),%eax
  802381:	39 c2                	cmp    %eax,%edx
  802383:	73 6d                	jae    8023f2 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802389:	74 06                	je     802391 <insert_sorted_allocList+0x139>
  80238b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238f:	75 17                	jne    8023a8 <insert_sorted_allocList+0x150>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 90 3c 80 00       	push   $0x803c90
  802399:	68 90 00 00 00       	push   $0x90
  80239e:	68 53 3c 80 00       	push   $0x803c53
  8023a3:	e8 fc 0d 00 00       	call   8031a4 <_panic>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 50 04             	mov    0x4(%eax),%edx
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	74 0d                	je     8023d3 <insert_sorted_allocList+0x17b>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 10                	mov    %edx,(%eax)
  8023d1:	eb 08                	jmp    8023db <insert_sorted_allocList+0x183>
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	a3 40 40 80 00       	mov    %eax,0x804040
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023e9:	40                   	inc    %eax
  8023ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023ef:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023f0:	eb 12                	jmp    802404 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8023fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fe:	0f 85 71 ff ff ff    	jne    802375 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802404:	90                   	nop
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80240d:	a1 38 41 80 00       	mov    0x804138,%eax
  802412:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802415:	e9 76 01 00 00       	jmp    802590 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 0c             	mov    0xc(%eax),%eax
  802420:	3b 45 08             	cmp    0x8(%ebp),%eax
  802423:	0f 85 8a 00 00 00    	jne    8024b3 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242d:	75 17                	jne    802446 <alloc_block_FF+0x3f>
  80242f:	83 ec 04             	sub    $0x4,%esp
  802432:	68 c5 3c 80 00       	push   $0x803cc5
  802437:	68 a8 00 00 00       	push   $0xa8
  80243c:	68 53 3c 80 00       	push   $0x803c53
  802441:	e8 5e 0d 00 00       	call   8031a4 <_panic>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 10                	je     80245f <alloc_block_FF+0x58>
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802457:	8b 52 04             	mov    0x4(%edx),%edx
  80245a:	89 50 04             	mov    %edx,0x4(%eax)
  80245d:	eb 0b                	jmp    80246a <alloc_block_FF+0x63>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 04             	mov    0x4(%eax),%eax
  802465:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 40 04             	mov    0x4(%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 0f                	je     802483 <alloc_block_FF+0x7c>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247d:	8b 12                	mov    (%edx),%edx
  80247f:	89 10                	mov    %edx,(%eax)
  802481:	eb 0a                	jmp    80248d <alloc_block_FF+0x86>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	a3 38 41 80 00       	mov    %eax,0x804138
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a0:	a1 44 41 80 00       	mov    0x804144,%eax
  8024a5:	48                   	dec    %eax
  8024a6:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	e9 ea 00 00 00       	jmp    80259d <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024bc:	0f 86 c6 00 00 00    	jbe    802588 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8024c2:	a1 48 41 80 00       	mov    0x804148,%eax
  8024c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d0:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 50 08             	mov    0x8(%eax),%edx
  8024d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dc:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e8:	89 c2                	mov    %eax,%edx
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 50 08             	mov    0x8(%eax),%edx
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	01 c2                	add    %eax,%edx
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802501:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802505:	75 17                	jne    80251e <alloc_block_FF+0x117>
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	68 c5 3c 80 00       	push   $0x803cc5
  80250f:	68 b6 00 00 00       	push   $0xb6
  802514:	68 53 3c 80 00       	push   $0x803c53
  802519:	e8 86 0c 00 00       	call   8031a4 <_panic>
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	8b 00                	mov    (%eax),%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	74 10                	je     802537 <alloc_block_FF+0x130>
  802527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252f:	8b 52 04             	mov    0x4(%edx),%edx
  802532:	89 50 04             	mov    %edx,0x4(%eax)
  802535:	eb 0b                	jmp    802542 <alloc_block_FF+0x13b>
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802545:	8b 40 04             	mov    0x4(%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 0f                	je     80255b <alloc_block_FF+0x154>
  80254c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254f:	8b 40 04             	mov    0x4(%eax),%eax
  802552:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802555:	8b 12                	mov    (%edx),%edx
  802557:	89 10                	mov    %edx,(%eax)
  802559:	eb 0a                	jmp    802565 <alloc_block_FF+0x15e>
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	a3 48 41 80 00       	mov    %eax,0x804148
  802565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802571:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802578:	a1 54 41 80 00       	mov    0x804154,%eax
  80257d:	48                   	dec    %eax
  80257e:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	eb 15                	jmp    80259d <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802594:	0f 85 80 fe ff ff    	jne    80241a <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8025a5:	a1 38 41 80 00       	mov    0x804138,%eax
  8025aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8025ad:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8025b4:	e9 c0 00 00 00       	jmp    802679 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c2:	0f 85 8a 00 00 00    	jne    802652 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	75 17                	jne    8025e5 <alloc_block_BF+0x46>
  8025ce:	83 ec 04             	sub    $0x4,%esp
  8025d1:	68 c5 3c 80 00       	push   $0x803cc5
  8025d6:	68 cf 00 00 00       	push   $0xcf
  8025db:	68 53 3c 80 00       	push   $0x803c53
  8025e0:	e8 bf 0b 00 00       	call   8031a4 <_panic>
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 00                	mov    (%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 10                	je     8025fe <alloc_block_BF+0x5f>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	8b 52 04             	mov    0x4(%edx),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
  8025fc:	eb 0b                	jmp    802609 <alloc_block_BF+0x6a>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 0f                	je     802622 <alloc_block_BF+0x83>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261c:	8b 12                	mov    (%edx),%edx
  80261e:	89 10                	mov    %edx,(%eax)
  802620:	eb 0a                	jmp    80262c <alloc_block_BF+0x8d>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	a3 38 41 80 00       	mov    %eax,0x804138
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263f:	a1 44 41 80 00       	mov    0x804144,%eax
  802644:	48                   	dec    %eax
  802645:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	e9 2a 01 00 00       	jmp    80277c <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80265b:	73 14                	jae    802671 <alloc_block_BF+0xd2>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	3b 45 08             	cmp    0x8(%ebp),%eax
  802666:	76 09                	jbe    802671 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267d:	0f 85 36 ff ff ff    	jne    8025b9 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802683:	a1 38 41 80 00       	mov    0x804138,%eax
  802688:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80268b:	e9 dd 00 00 00       	jmp    80276d <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 0c             	mov    0xc(%eax),%eax
  802696:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802699:	0f 85 c6 00 00 00    	jne    802765 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80269f:	a1 48 41 80 00       	mov    0x804148,%eax
  8026a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 50 08             	mov    0x8(%eax),%edx
  8026ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b0:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b9:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 50 08             	mov    0x8(%eax),%edx
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	01 c2                	add    %eax,%edx
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8026d6:	89 c2                	mov    %eax,%edx
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8026de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026e2:	75 17                	jne    8026fb <alloc_block_BF+0x15c>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 c5 3c 80 00       	push   $0x803cc5
  8026ec:	68 eb 00 00 00       	push   $0xeb
  8026f1:	68 53 3c 80 00       	push   $0x803c53
  8026f6:	e8 a9 0a 00 00       	call   8031a4 <_panic>
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 10                	je     802714 <alloc_block_BF+0x175>
  802704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80270c:	8b 52 04             	mov    0x4(%edx),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	eb 0b                	jmp    80271f <alloc_block_BF+0x180>
  802714:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0f                	je     802738 <alloc_block_BF+0x199>
  802729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802732:	8b 12                	mov    (%edx),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 0a                	jmp    802742 <alloc_block_BF+0x1a3>
  802738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	a3 48 41 80 00       	mov    %eax,0x804148
  802742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 54 41 80 00       	mov    0x804154,%eax
  80275a:	48                   	dec    %eax
  80275b:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802763:	eb 17                	jmp    80277c <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	0f 85 19 ff ff ff    	jne    802690 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802784:	a1 40 40 80 00       	mov    0x804040,%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	75 19                	jne    8027a6 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80278d:	83 ec 0c             	sub    $0xc,%esp
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	e8 6f fc ff ff       	call   802407 <alloc_block_FF>
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	e9 e9 01 00 00       	jmp    80298f <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8027a6:	a1 44 40 80 00       	mov    0x804044,%eax
  8027ab:	8b 40 08             	mov    0x8(%eax),%eax
  8027ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8027b1:	a1 44 40 80 00       	mov    0x804044,%eax
  8027b6:	8b 50 0c             	mov    0xc(%eax),%edx
  8027b9:	a1 44 40 80 00       	mov    0x804044,%eax
  8027be:	8b 40 08             	mov    0x8(%eax),%eax
  8027c1:	01 d0                	add    %edx,%eax
  8027c3:	83 ec 08             	sub    $0x8,%esp
  8027c6:	50                   	push   %eax
  8027c7:	68 38 41 80 00       	push   $0x804138
  8027cc:	e8 54 fa ff ff       	call   802225 <find_block>
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e0:	0f 85 9b 00 00 00    	jne    802881 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 08             	mov    0x8(%eax),%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8027f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fb:	75 17                	jne    802814 <alloc_block_NF+0x96>
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	68 c5 3c 80 00       	push   $0x803cc5
  802805:	68 1a 01 00 00       	push   $0x11a
  80280a:	68 53 3c 80 00       	push   $0x803c53
  80280f:	e8 90 09 00 00       	call   8031a4 <_panic>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	74 10                	je     80282d <alloc_block_NF+0xaf>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802825:	8b 52 04             	mov    0x4(%edx),%edx
  802828:	89 50 04             	mov    %edx,0x4(%eax)
  80282b:	eb 0b                	jmp    802838 <alloc_block_NF+0xba>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 04             	mov    0x4(%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 0f                	je     802851 <alloc_block_NF+0xd3>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 04             	mov    0x4(%eax),%eax
  802848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284b:	8b 12                	mov    (%edx),%edx
  80284d:	89 10                	mov    %edx,(%eax)
  80284f:	eb 0a                	jmp    80285b <alloc_block_NF+0xdd>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	a3 38 41 80 00       	mov    %eax,0x804138
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286e:	a1 44 41 80 00       	mov    0x804144,%eax
  802873:	48                   	dec    %eax
  802874:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	e9 0e 01 00 00       	jmp    80298f <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288a:	0f 86 cf 00 00 00    	jbe    80295f <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802890:	a1 48 41 80 00       	mov    0x804148,%eax
  802895:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289b:	8b 55 08             	mov    0x8(%ebp),%edx
  80289e:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 50 08             	mov    0x8(%eax),%edx
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 50 08             	mov    0x8(%eax),%edx
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	01 c2                	add    %eax,%edx
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c7:	89 c2                	mov    %eax,%edx
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 08             	mov    0x8(%eax),%eax
  8028d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8028d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028dc:	75 17                	jne    8028f5 <alloc_block_NF+0x177>
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 c5 3c 80 00       	push   $0x803cc5
  8028e6:	68 28 01 00 00       	push   $0x128
  8028eb:	68 53 3c 80 00       	push   $0x803c53
  8028f0:	e8 af 08 00 00       	call   8031a4 <_panic>
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 10                	je     80290e <alloc_block_NF+0x190>
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802906:	8b 52 04             	mov    0x4(%edx),%edx
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	eb 0b                	jmp    802919 <alloc_block_NF+0x19b>
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0f                	je     802932 <alloc_block_NF+0x1b4>
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80292c:	8b 12                	mov    (%edx),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	eb 0a                	jmp    80293c <alloc_block_NF+0x1be>
  802932:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	a3 48 41 80 00       	mov    %eax,0x804148
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294f:	a1 54 41 80 00       	mov    0x804154,%eax
  802954:	48                   	dec    %eax
  802955:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80295a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295d:	eb 30                	jmp    80298f <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80295f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802964:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802967:	75 0a                	jne    802973 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802969:	a1 38 41 80 00       	mov    0x804138,%eax
  80296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802971:	eb 08                	jmp    80297b <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 08             	mov    0x8(%eax),%eax
  802981:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802984:	0f 85 4d fe ff ff    	jne    8027d7 <alloc_block_NF+0x59>

			return NULL;
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80298f:	c9                   	leave  
  802990:	c3                   	ret    

00802991 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802991:	55                   	push   %ebp
  802992:	89 e5                	mov    %esp,%ebp
  802994:	53                   	push   %ebx
  802995:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802998:	a1 38 41 80 00       	mov    0x804138,%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	0f 85 86 00 00 00    	jne    802a2b <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8029a5:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8029ac:	00 00 00 
  8029af:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8029b6:	00 00 00 
  8029b9:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8029c0:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c7:	75 17                	jne    8029e0 <insert_sorted_with_merge_freeList+0x4f>
  8029c9:	83 ec 04             	sub    $0x4,%esp
  8029cc:	68 30 3c 80 00       	push   $0x803c30
  8029d1:	68 48 01 00 00       	push   $0x148
  8029d6:	68 53 3c 80 00       	push   $0x803c53
  8029db:	e8 c4 07 00 00       	call   8031a4 <_panic>
  8029e0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	89 10                	mov    %edx,(%eax)
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0d                	je     802a01 <insert_sorted_with_merge_freeList+0x70>
  8029f4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fc:	89 50 04             	mov    %edx,0x4(%eax)
  8029ff:	eb 08                	jmp    802a09 <insert_sorted_with_merge_freeList+0x78>
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a20:	40                   	inc    %eax
  802a21:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802a26:	e9 73 07 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	8b 50 08             	mov    0x8(%eax),%edx
  802a31:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a36:	8b 40 08             	mov    0x8(%eax),%eax
  802a39:	39 c2                	cmp    %eax,%edx
  802a3b:	0f 86 84 00 00 00    	jbe    802ac5 <insert_sorted_with_merge_freeList+0x134>
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	8b 50 08             	mov    0x8(%eax),%edx
  802a47:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a4c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a4f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a54:	8b 40 08             	mov    0x8(%eax),%eax
  802a57:	01 c8                	add    %ecx,%eax
  802a59:	39 c2                	cmp    %eax,%edx
  802a5b:	74 68                	je     802ac5 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802a5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a61:	75 17                	jne    802a7a <insert_sorted_with_merge_freeList+0xe9>
  802a63:	83 ec 04             	sub    $0x4,%esp
  802a66:	68 6c 3c 80 00       	push   $0x803c6c
  802a6b:	68 4c 01 00 00       	push   $0x14c
  802a70:	68 53 3c 80 00       	push   $0x803c53
  802a75:	e8 2a 07 00 00       	call   8031a4 <_panic>
  802a7a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	89 50 04             	mov    %edx,0x4(%eax)
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 40 04             	mov    0x4(%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0c                	je     802a9c <insert_sorted_with_merge_freeList+0x10b>
  802a90:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	eb 08                	jmp    802aa4 <insert_sorted_with_merge_freeList+0x113>
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab5:	a1 44 41 80 00       	mov    0x804144,%eax
  802aba:	40                   	inc    %eax
  802abb:	a3 44 41 80 00       	mov    %eax,0x804144
  802ac0:	e9 d9 06 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	8b 50 08             	mov    0x8(%eax),%edx
  802acb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad0:	8b 40 08             	mov    0x8(%eax),%eax
  802ad3:	39 c2                	cmp    %eax,%edx
  802ad5:	0f 86 b5 00 00 00    	jbe    802b90 <insert_sorted_with_merge_freeList+0x1ff>
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	8b 50 08             	mov    0x8(%eax),%edx
  802ae1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ae9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aee:	8b 40 08             	mov    0x8(%eax),%eax
  802af1:	01 c8                	add    %ecx,%eax
  802af3:	39 c2                	cmp    %eax,%edx
  802af5:	0f 85 95 00 00 00    	jne    802b90 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802afb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b00:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b06:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b09:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0c:	8b 52 0c             	mov    0xc(%edx),%edx
  802b0f:	01 ca                	add    %ecx,%edx
  802b11:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2c:	75 17                	jne    802b45 <insert_sorted_with_merge_freeList+0x1b4>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 30 3c 80 00       	push   $0x803c30
  802b36:	68 54 01 00 00       	push   $0x154
  802b3b:	68 53 3c 80 00       	push   $0x803c53
  802b40:	e8 5f 06 00 00       	call   8031a4 <_panic>
  802b45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 10                	mov    %edx,(%eax)
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 0d                	je     802b66 <insert_sorted_with_merge_freeList+0x1d5>
  802b59:	a1 48 41 80 00       	mov    0x804148,%eax
  802b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 08                	jmp    802b6e <insert_sorted_with_merge_freeList+0x1dd>
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 48 41 80 00       	mov    %eax,0x804148
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b80:	a1 54 41 80 00       	mov    0x804154,%eax
  802b85:	40                   	inc    %eax
  802b86:	a3 54 41 80 00       	mov    %eax,0x804154
  802b8b:	e9 0e 06 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	8b 50 08             	mov    0x8(%eax),%edx
  802b96:	a1 38 41 80 00       	mov    0x804138,%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	39 c2                	cmp    %eax,%edx
  802ba0:	0f 83 c1 00 00 00    	jae    802c67 <insert_sorted_with_merge_freeList+0x2d6>
  802ba6:	a1 38 41 80 00       	mov    0x804138,%eax
  802bab:	8b 50 08             	mov    0x8(%eax),%edx
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 48 08             	mov    0x8(%eax),%ecx
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bba:	01 c8                	add    %ecx,%eax
  802bbc:	39 c2                	cmp    %eax,%edx
  802bbe:	0f 85 a3 00 00 00    	jne    802c67 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802bc4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcc:	8b 52 08             	mov    0x8(%edx),%edx
  802bcf:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802bd2:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bdd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
  802be3:	8b 52 0c             	mov    0xc(%edx),%edx
  802be6:	01 ca                	add    %ecx,%edx
  802be8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c03:	75 17                	jne    802c1c <insert_sorted_with_merge_freeList+0x28b>
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	68 30 3c 80 00       	push   $0x803c30
  802c0d:	68 5d 01 00 00       	push   $0x15d
  802c12:	68 53 3c 80 00       	push   $0x803c53
  802c17:	e8 88 05 00 00       	call   8031a4 <_panic>
  802c1c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	89 10                	mov    %edx,(%eax)
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	8b 00                	mov    (%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 0d                	je     802c3d <insert_sorted_with_merge_freeList+0x2ac>
  802c30:	a1 48 41 80 00       	mov    0x804148,%eax
  802c35:	8b 55 08             	mov    0x8(%ebp),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	eb 08                	jmp    802c45 <insert_sorted_with_merge_freeList+0x2b4>
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c57:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5c:	40                   	inc    %eax
  802c5d:	a3 54 41 80 00       	mov    %eax,0x804154
  802c62:	e9 37 05 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	8b 50 08             	mov    0x8(%eax),%edx
  802c6d:	a1 38 41 80 00       	mov    0x804138,%eax
  802c72:	8b 40 08             	mov    0x8(%eax),%eax
  802c75:	39 c2                	cmp    %eax,%edx
  802c77:	0f 83 82 00 00 00    	jae    802cff <insert_sorted_with_merge_freeList+0x36e>
  802c7d:	a1 38 41 80 00       	mov    0x804138,%eax
  802c82:	8b 50 08             	mov    0x8(%eax),%edx
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	8b 48 08             	mov    0x8(%eax),%ecx
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c91:	01 c8                	add    %ecx,%eax
  802c93:	39 c2                	cmp    %eax,%edx
  802c95:	74 68                	je     802cff <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9b:	75 17                	jne    802cb4 <insert_sorted_with_merge_freeList+0x323>
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	68 30 3c 80 00       	push   $0x803c30
  802ca5:	68 62 01 00 00       	push   $0x162
  802caa:	68 53 3c 80 00       	push   $0x803c53
  802caf:	e8 f0 04 00 00       	call   8031a4 <_panic>
  802cb4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	89 10                	mov    %edx,(%eax)
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 0d                	je     802cd5 <insert_sorted_with_merge_freeList+0x344>
  802cc8:	a1 38 41 80 00       	mov    0x804138,%eax
  802ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd0:	89 50 04             	mov    %edx,0x4(%eax)
  802cd3:	eb 08                	jmp    802cdd <insert_sorted_with_merge_freeList+0x34c>
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cef:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf4:	40                   	inc    %eax
  802cf5:	a3 44 41 80 00       	mov    %eax,0x804144
  802cfa:	e9 9f 04 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802cff:	a1 38 41 80 00       	mov    0x804138,%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802d09:	e9 84 04 00 00       	jmp    803192 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 50 08             	mov    0x8(%eax),%edx
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 40 08             	mov    0x8(%eax),%eax
  802d1a:	39 c2                	cmp    %eax,%edx
  802d1c:	0f 86 a9 00 00 00    	jbe    802dcb <insert_sorted_with_merge_freeList+0x43a>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 50 08             	mov    0x8(%eax),%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 48 08             	mov    0x8(%eax),%ecx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	01 c8                	add    %ecx,%eax
  802d36:	39 c2                	cmp    %eax,%edx
  802d38:	0f 84 8d 00 00 00    	je     802dcb <insert_sorted_with_merge_freeList+0x43a>
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 50 08             	mov    0x8(%eax),%edx
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 40 04             	mov    0x4(%eax),%eax
  802d4a:	8b 48 08             	mov    0x8(%eax),%ecx
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	8b 40 0c             	mov    0xc(%eax),%eax
  802d56:	01 c8                	add    %ecx,%eax
  802d58:	39 c2                	cmp    %eax,%edx
  802d5a:	74 6f                	je     802dcb <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d60:	74 06                	je     802d68 <insert_sorted_with_merge_freeList+0x3d7>
  802d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d66:	75 17                	jne    802d7f <insert_sorted_with_merge_freeList+0x3ee>
  802d68:	83 ec 04             	sub    $0x4,%esp
  802d6b:	68 90 3c 80 00       	push   $0x803c90
  802d70:	68 6b 01 00 00       	push   $0x16b
  802d75:	68 53 3c 80 00       	push   $0x803c53
  802d7a:	e8 25 04 00 00       	call   8031a4 <_panic>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 50 04             	mov    0x4(%eax),%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	89 50 04             	mov    %edx,0x4(%eax)
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d91:	89 10                	mov    %edx,(%eax)
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 0d                	je     802daa <insert_sorted_with_merge_freeList+0x419>
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	8b 55 08             	mov    0x8(%ebp),%edx
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	eb 08                	jmp    802db2 <insert_sorted_with_merge_freeList+0x421>
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	a3 38 41 80 00       	mov    %eax,0x804138
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 55 08             	mov    0x8(%ebp),%edx
  802db8:	89 50 04             	mov    %edx,0x4(%eax)
  802dbb:	a1 44 41 80 00       	mov    0x804144,%eax
  802dc0:	40                   	inc    %eax
  802dc1:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802dc6:	e9 d3 03 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 40 08             	mov    0x8(%eax),%eax
  802dd7:	39 c2                	cmp    %eax,%edx
  802dd9:	0f 86 da 00 00 00    	jbe    802eb9 <insert_sorted_with_merge_freeList+0x528>
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 50 08             	mov    0x8(%eax),%edx
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 48 08             	mov    0x8(%eax),%ecx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 40 0c             	mov    0xc(%eax),%eax
  802df1:	01 c8                	add    %ecx,%eax
  802df3:	39 c2                	cmp    %eax,%edx
  802df5:	0f 85 be 00 00 00    	jne    802eb9 <insert_sorted_with_merge_freeList+0x528>
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 50 08             	mov    0x8(%eax),%edx
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	8b 48 08             	mov    0x8(%eax),%ecx
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	8b 40 0c             	mov    0xc(%eax),%eax
  802e13:	01 c8                	add    %ecx,%eax
  802e15:	39 c2                	cmp    %eax,%edx
  802e17:	0f 84 9c 00 00 00    	je     802eb9 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	8b 50 08             	mov    0x8(%eax),%edx
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	01 c2                	add    %eax,%edx
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e55:	75 17                	jne    802e6e <insert_sorted_with_merge_freeList+0x4dd>
  802e57:	83 ec 04             	sub    $0x4,%esp
  802e5a:	68 30 3c 80 00       	push   $0x803c30
  802e5f:	68 74 01 00 00       	push   $0x174
  802e64:	68 53 3c 80 00       	push   $0x803c53
  802e69:	e8 36 03 00 00       	call   8031a4 <_panic>
  802e6e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	89 10                	mov    %edx,(%eax)
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 0d                	je     802e8f <insert_sorted_with_merge_freeList+0x4fe>
  802e82:	a1 48 41 80 00       	mov    0x804148,%eax
  802e87:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8a:	89 50 04             	mov    %edx,0x4(%eax)
  802e8d:	eb 08                	jmp    802e97 <insert_sorted_with_merge_freeList+0x506>
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea9:	a1 54 41 80 00       	mov    0x804154,%eax
  802eae:	40                   	inc    %eax
  802eaf:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802eb4:	e9 e5 02 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 50 08             	mov    0x8(%eax),%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 40 08             	mov    0x8(%eax),%eax
  802ec5:	39 c2                	cmp    %eax,%edx
  802ec7:	0f 86 d7 00 00 00    	jbe    802fa4 <insert_sorted_with_merge_freeList+0x613>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 50 08             	mov    0x8(%eax),%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 48 08             	mov    0x8(%eax),%ecx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	8b 40 0c             	mov    0xc(%eax),%eax
  802edf:	01 c8                	add    %ecx,%eax
  802ee1:	39 c2                	cmp    %eax,%edx
  802ee3:	0f 84 bb 00 00 00    	je     802fa4 <insert_sorted_with_merge_freeList+0x613>
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 50 08             	mov    0x8(%eax),%edx
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	8b 48 08             	mov    0x8(%eax),%ecx
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 40 0c             	mov    0xc(%eax),%eax
  802f01:	01 c8                	add    %ecx,%eax
  802f03:	39 c2                	cmp    %eax,%edx
  802f05:	0f 85 99 00 00 00    	jne    802fa4 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f17:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f20:	01 c2                	add    %eax,%edx
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f40:	75 17                	jne    802f59 <insert_sorted_with_merge_freeList+0x5c8>
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	68 30 3c 80 00       	push   $0x803c30
  802f4a:	68 7d 01 00 00       	push   $0x17d
  802f4f:	68 53 3c 80 00       	push   $0x803c53
  802f54:	e8 4b 02 00 00       	call   8031a4 <_panic>
  802f59:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	89 10                	mov    %edx,(%eax)
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 0d                	je     802f7a <insert_sorted_with_merge_freeList+0x5e9>
  802f6d:	a1 48 41 80 00       	mov    0x804148,%eax
  802f72:	8b 55 08             	mov    0x8(%ebp),%edx
  802f75:	89 50 04             	mov    %edx,0x4(%eax)
  802f78:	eb 08                	jmp    802f82 <insert_sorted_with_merge_freeList+0x5f1>
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	a3 48 41 80 00       	mov    %eax,0x804148
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f94:	a1 54 41 80 00       	mov    0x804154,%eax
  802f99:	40                   	inc    %eax
  802f9a:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f9f:	e9 fa 01 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 50 08             	mov    0x8(%eax),%edx
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	39 c2                	cmp    %eax,%edx
  802fb2:	0f 86 d2 01 00 00    	jbe    80318a <insert_sorted_with_merge_freeList+0x7f9>
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 50 08             	mov    0x8(%eax),%edx
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	8b 48 08             	mov    0x8(%eax),%ecx
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fca:	01 c8                	add    %ecx,%eax
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	0f 85 b6 01 00 00    	jne    80318a <insert_sorted_with_merge_freeList+0x7f9>
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	8b 48 08             	mov    0x8(%eax),%ecx
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	01 c8                	add    %ecx,%eax
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	0f 85 94 01 00 00    	jne    80318a <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fff:	8b 52 04             	mov    0x4(%edx),%edx
  803002:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803005:	8b 55 08             	mov    0x8(%ebp),%edx
  803008:	8b 5a 0c             	mov    0xc(%edx),%ebx
  80300b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80300e:	8b 52 0c             	mov    0xc(%edx),%edx
  803011:	01 da                	add    %ebx,%edx
  803013:	01 ca                	add    %ecx,%edx
  803015:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80302c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803030:	75 17                	jne    803049 <insert_sorted_with_merge_freeList+0x6b8>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 c5 3c 80 00       	push   $0x803cc5
  80303a:	68 86 01 00 00       	push   $0x186
  80303f:	68 53 3c 80 00       	push   $0x803c53
  803044:	e8 5b 01 00 00       	call   8031a4 <_panic>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 10                	je     803062 <insert_sorted_with_merge_freeList+0x6d1>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305a:	8b 52 04             	mov    0x4(%edx),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	eb 0b                	jmp    80306d <insert_sorted_with_merge_freeList+0x6dc>
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 0f                	je     803086 <insert_sorted_with_merge_freeList+0x6f5>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803080:	8b 12                	mov    (%edx),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	eb 0a                	jmp    803090 <insert_sorted_with_merge_freeList+0x6ff>
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	a3 38 41 80 00       	mov    %eax,0x804138
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8030a8:	48                   	dec    %eax
  8030a9:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8030ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b2:	75 17                	jne    8030cb <insert_sorted_with_merge_freeList+0x73a>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 30 3c 80 00       	push   $0x803c30
  8030bc:	68 87 01 00 00       	push   $0x187
  8030c1:	68 53 3c 80 00       	push   $0x803c53
  8030c6:	e8 d9 00 00 00       	call   8031a4 <_panic>
  8030cb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	89 10                	mov    %edx,(%eax)
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	74 0d                	je     8030ec <insert_sorted_with_merge_freeList+0x75b>
  8030df:	a1 48 41 80 00       	mov    0x804148,%eax
  8030e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ea:	eb 08                	jmp    8030f4 <insert_sorted_with_merge_freeList+0x763>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	a3 48 41 80 00       	mov    %eax,0x804148
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803106:	a1 54 41 80 00       	mov    0x804154,%eax
  80310b:	40                   	inc    %eax
  80310c:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803129:	75 17                	jne    803142 <insert_sorted_with_merge_freeList+0x7b1>
  80312b:	83 ec 04             	sub    $0x4,%esp
  80312e:	68 30 3c 80 00       	push   $0x803c30
  803133:	68 8a 01 00 00       	push   $0x18a
  803138:	68 53 3c 80 00       	push   $0x803c53
  80313d:	e8 62 00 00 00       	call   8031a4 <_panic>
  803142:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	89 10                	mov    %edx,(%eax)
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	74 0d                	je     803163 <insert_sorted_with_merge_freeList+0x7d2>
  803156:	a1 48 41 80 00       	mov    0x804148,%eax
  80315b:	8b 55 08             	mov    0x8(%ebp),%edx
  80315e:	89 50 04             	mov    %edx,0x4(%eax)
  803161:	eb 08                	jmp    80316b <insert_sorted_with_merge_freeList+0x7da>
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	a3 48 41 80 00       	mov    %eax,0x804148
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317d:	a1 54 41 80 00       	mov    0x804154,%eax
  803182:	40                   	inc    %eax
  803183:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803188:	eb 14                	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803192:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803196:	0f 85 72 fb ff ff    	jne    802d0e <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80319c:	eb 00                	jmp    80319e <insert_sorted_with_merge_freeList+0x80d>
  80319e:	90                   	nop
  80319f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031a2:	c9                   	leave  
  8031a3:	c3                   	ret    

008031a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8031a4:	55                   	push   %ebp
  8031a5:	89 e5                	mov    %esp,%ebp
  8031a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8031aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8031ad:	83 c0 04             	add    $0x4,%eax
  8031b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8031b3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	74 16                	je     8031d2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8031bc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031c1:	83 ec 08             	sub    $0x8,%esp
  8031c4:	50                   	push   %eax
  8031c5:	68 e4 3c 80 00       	push   $0x803ce4
  8031ca:	e8 b4 d4 ff ff       	call   800683 <cprintf>
  8031cf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031d2:	a1 00 40 80 00       	mov    0x804000,%eax
  8031d7:	ff 75 0c             	pushl  0xc(%ebp)
  8031da:	ff 75 08             	pushl  0x8(%ebp)
  8031dd:	50                   	push   %eax
  8031de:	68 e9 3c 80 00       	push   $0x803ce9
  8031e3:	e8 9b d4 ff ff       	call   800683 <cprintf>
  8031e8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8031ee:	83 ec 08             	sub    $0x8,%esp
  8031f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8031f4:	50                   	push   %eax
  8031f5:	e8 1e d4 ff ff       	call   800618 <vcprintf>
  8031fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031fd:	83 ec 08             	sub    $0x8,%esp
  803200:	6a 00                	push   $0x0
  803202:	68 05 3d 80 00       	push   $0x803d05
  803207:	e8 0c d4 ff ff       	call   800618 <vcprintf>
  80320c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80320f:	e8 8d d3 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  803214:	eb fe                	jmp    803214 <_panic+0x70>

00803216 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80321c:	a1 20 40 80 00       	mov    0x804020,%eax
  803221:	8b 50 74             	mov    0x74(%eax),%edx
  803224:	8b 45 0c             	mov    0xc(%ebp),%eax
  803227:	39 c2                	cmp    %eax,%edx
  803229:	74 14                	je     80323f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 08 3d 80 00       	push   $0x803d08
  803233:	6a 26                	push   $0x26
  803235:	68 54 3d 80 00       	push   $0x803d54
  80323a:	e8 65 ff ff ff       	call   8031a4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80323f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803246:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80324d:	e9 c2 00 00 00       	jmp    803314 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803255:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	01 d0                	add    %edx,%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	75 08                	jne    80326f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803267:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80326a:	e9 a2 00 00 00       	jmp    803311 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80326f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803276:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80327d:	eb 69                	jmp    8032e8 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80327f:	a1 20 40 80 00       	mov    0x804020,%eax
  803284:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80328a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328d:	89 d0                	mov    %edx,%eax
  80328f:	01 c0                	add    %eax,%eax
  803291:	01 d0                	add    %edx,%eax
  803293:	c1 e0 03             	shl    $0x3,%eax
  803296:	01 c8                	add    %ecx,%eax
  803298:	8a 40 04             	mov    0x4(%eax),%al
  80329b:	84 c0                	test   %al,%al
  80329d:	75 46                	jne    8032e5 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80329f:	a1 20 40 80 00       	mov    0x804020,%eax
  8032a4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ad:	89 d0                	mov    %edx,%eax
  8032af:	01 c0                	add    %eax,%eax
  8032b1:	01 d0                	add    %edx,%eax
  8032b3:	c1 e0 03             	shl    $0x3,%eax
  8032b6:	01 c8                	add    %ecx,%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	01 c8                	add    %ecx,%eax
  8032d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032d8:	39 c2                	cmp    %eax,%edx
  8032da:	75 09                	jne    8032e5 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032e3:	eb 12                	jmp    8032f7 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032e5:	ff 45 e8             	incl   -0x18(%ebp)
  8032e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8032ed:	8b 50 74             	mov    0x74(%eax),%edx
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	39 c2                	cmp    %eax,%edx
  8032f5:	77 88                	ja     80327f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032fb:	75 14                	jne    803311 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032fd:	83 ec 04             	sub    $0x4,%esp
  803300:	68 60 3d 80 00       	push   $0x803d60
  803305:	6a 3a                	push   $0x3a
  803307:	68 54 3d 80 00       	push   $0x803d54
  80330c:	e8 93 fe ff ff       	call   8031a4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803311:	ff 45 f0             	incl   -0x10(%ebp)
  803314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803317:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80331a:	0f 8c 32 ff ff ff    	jl     803252 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803320:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803327:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80332e:	eb 26                	jmp    803356 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803330:	a1 20 40 80 00       	mov    0x804020,%eax
  803335:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80333b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80333e:	89 d0                	mov    %edx,%eax
  803340:	01 c0                	add    %eax,%eax
  803342:	01 d0                	add    %edx,%eax
  803344:	c1 e0 03             	shl    $0x3,%eax
  803347:	01 c8                	add    %ecx,%eax
  803349:	8a 40 04             	mov    0x4(%eax),%al
  80334c:	3c 01                	cmp    $0x1,%al
  80334e:	75 03                	jne    803353 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803350:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803353:	ff 45 e0             	incl   -0x20(%ebp)
  803356:	a1 20 40 80 00       	mov    0x804020,%eax
  80335b:	8b 50 74             	mov    0x74(%eax),%edx
  80335e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803361:	39 c2                	cmp    %eax,%edx
  803363:	77 cb                	ja     803330 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80336b:	74 14                	je     803381 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 b4 3d 80 00       	push   $0x803db4
  803375:	6a 44                	push   $0x44
  803377:	68 54 3d 80 00       	push   $0x803d54
  80337c:	e8 23 fe ff ff       	call   8031a4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803381:	90                   	nop
  803382:	c9                   	leave  
  803383:	c3                   	ret    

00803384 <__udivdi3>:
  803384:	55                   	push   %ebp
  803385:	57                   	push   %edi
  803386:	56                   	push   %esi
  803387:	53                   	push   %ebx
  803388:	83 ec 1c             	sub    $0x1c,%esp
  80338b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80338f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803393:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803397:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80339b:	89 ca                	mov    %ecx,%edx
  80339d:	89 f8                	mov    %edi,%eax
  80339f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033a3:	85 f6                	test   %esi,%esi
  8033a5:	75 2d                	jne    8033d4 <__udivdi3+0x50>
  8033a7:	39 cf                	cmp    %ecx,%edi
  8033a9:	77 65                	ja     803410 <__udivdi3+0x8c>
  8033ab:	89 fd                	mov    %edi,%ebp
  8033ad:	85 ff                	test   %edi,%edi
  8033af:	75 0b                	jne    8033bc <__udivdi3+0x38>
  8033b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b6:	31 d2                	xor    %edx,%edx
  8033b8:	f7 f7                	div    %edi
  8033ba:	89 c5                	mov    %eax,%ebp
  8033bc:	31 d2                	xor    %edx,%edx
  8033be:	89 c8                	mov    %ecx,%eax
  8033c0:	f7 f5                	div    %ebp
  8033c2:	89 c1                	mov    %eax,%ecx
  8033c4:	89 d8                	mov    %ebx,%eax
  8033c6:	f7 f5                	div    %ebp
  8033c8:	89 cf                	mov    %ecx,%edi
  8033ca:	89 fa                	mov    %edi,%edx
  8033cc:	83 c4 1c             	add    $0x1c,%esp
  8033cf:	5b                   	pop    %ebx
  8033d0:	5e                   	pop    %esi
  8033d1:	5f                   	pop    %edi
  8033d2:	5d                   	pop    %ebp
  8033d3:	c3                   	ret    
  8033d4:	39 ce                	cmp    %ecx,%esi
  8033d6:	77 28                	ja     803400 <__udivdi3+0x7c>
  8033d8:	0f bd fe             	bsr    %esi,%edi
  8033db:	83 f7 1f             	xor    $0x1f,%edi
  8033de:	75 40                	jne    803420 <__udivdi3+0x9c>
  8033e0:	39 ce                	cmp    %ecx,%esi
  8033e2:	72 0a                	jb     8033ee <__udivdi3+0x6a>
  8033e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033e8:	0f 87 9e 00 00 00    	ja     80348c <__udivdi3+0x108>
  8033ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f3:	89 fa                	mov    %edi,%edx
  8033f5:	83 c4 1c             	add    $0x1c,%esp
  8033f8:	5b                   	pop    %ebx
  8033f9:	5e                   	pop    %esi
  8033fa:	5f                   	pop    %edi
  8033fb:	5d                   	pop    %ebp
  8033fc:	c3                   	ret    
  8033fd:	8d 76 00             	lea    0x0(%esi),%esi
  803400:	31 ff                	xor    %edi,%edi
  803402:	31 c0                	xor    %eax,%eax
  803404:	89 fa                	mov    %edi,%edx
  803406:	83 c4 1c             	add    $0x1c,%esp
  803409:	5b                   	pop    %ebx
  80340a:	5e                   	pop    %esi
  80340b:	5f                   	pop    %edi
  80340c:	5d                   	pop    %ebp
  80340d:	c3                   	ret    
  80340e:	66 90                	xchg   %ax,%ax
  803410:	89 d8                	mov    %ebx,%eax
  803412:	f7 f7                	div    %edi
  803414:	31 ff                	xor    %edi,%edi
  803416:	89 fa                	mov    %edi,%edx
  803418:	83 c4 1c             	add    $0x1c,%esp
  80341b:	5b                   	pop    %ebx
  80341c:	5e                   	pop    %esi
  80341d:	5f                   	pop    %edi
  80341e:	5d                   	pop    %ebp
  80341f:	c3                   	ret    
  803420:	bd 20 00 00 00       	mov    $0x20,%ebp
  803425:	89 eb                	mov    %ebp,%ebx
  803427:	29 fb                	sub    %edi,%ebx
  803429:	89 f9                	mov    %edi,%ecx
  80342b:	d3 e6                	shl    %cl,%esi
  80342d:	89 c5                	mov    %eax,%ebp
  80342f:	88 d9                	mov    %bl,%cl
  803431:	d3 ed                	shr    %cl,%ebp
  803433:	89 e9                	mov    %ebp,%ecx
  803435:	09 f1                	or     %esi,%ecx
  803437:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80343b:	89 f9                	mov    %edi,%ecx
  80343d:	d3 e0                	shl    %cl,%eax
  80343f:	89 c5                	mov    %eax,%ebp
  803441:	89 d6                	mov    %edx,%esi
  803443:	88 d9                	mov    %bl,%cl
  803445:	d3 ee                	shr    %cl,%esi
  803447:	89 f9                	mov    %edi,%ecx
  803449:	d3 e2                	shl    %cl,%edx
  80344b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80344f:	88 d9                	mov    %bl,%cl
  803451:	d3 e8                	shr    %cl,%eax
  803453:	09 c2                	or     %eax,%edx
  803455:	89 d0                	mov    %edx,%eax
  803457:	89 f2                	mov    %esi,%edx
  803459:	f7 74 24 0c          	divl   0xc(%esp)
  80345d:	89 d6                	mov    %edx,%esi
  80345f:	89 c3                	mov    %eax,%ebx
  803461:	f7 e5                	mul    %ebp
  803463:	39 d6                	cmp    %edx,%esi
  803465:	72 19                	jb     803480 <__udivdi3+0xfc>
  803467:	74 0b                	je     803474 <__udivdi3+0xf0>
  803469:	89 d8                	mov    %ebx,%eax
  80346b:	31 ff                	xor    %edi,%edi
  80346d:	e9 58 ff ff ff       	jmp    8033ca <__udivdi3+0x46>
  803472:	66 90                	xchg   %ax,%ax
  803474:	8b 54 24 08          	mov    0x8(%esp),%edx
  803478:	89 f9                	mov    %edi,%ecx
  80347a:	d3 e2                	shl    %cl,%edx
  80347c:	39 c2                	cmp    %eax,%edx
  80347e:	73 e9                	jae    803469 <__udivdi3+0xe5>
  803480:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803483:	31 ff                	xor    %edi,%edi
  803485:	e9 40 ff ff ff       	jmp    8033ca <__udivdi3+0x46>
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	31 c0                	xor    %eax,%eax
  80348e:	e9 37 ff ff ff       	jmp    8033ca <__udivdi3+0x46>
  803493:	90                   	nop

00803494 <__umoddi3>:
  803494:	55                   	push   %ebp
  803495:	57                   	push   %edi
  803496:	56                   	push   %esi
  803497:	53                   	push   %ebx
  803498:	83 ec 1c             	sub    $0x1c,%esp
  80349b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80349f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034b3:	89 f3                	mov    %esi,%ebx
  8034b5:	89 fa                	mov    %edi,%edx
  8034b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034bb:	89 34 24             	mov    %esi,(%esp)
  8034be:	85 c0                	test   %eax,%eax
  8034c0:	75 1a                	jne    8034dc <__umoddi3+0x48>
  8034c2:	39 f7                	cmp    %esi,%edi
  8034c4:	0f 86 a2 00 00 00    	jbe    80356c <__umoddi3+0xd8>
  8034ca:	89 c8                	mov    %ecx,%eax
  8034cc:	89 f2                	mov    %esi,%edx
  8034ce:	f7 f7                	div    %edi
  8034d0:	89 d0                	mov    %edx,%eax
  8034d2:	31 d2                	xor    %edx,%edx
  8034d4:	83 c4 1c             	add    $0x1c,%esp
  8034d7:	5b                   	pop    %ebx
  8034d8:	5e                   	pop    %esi
  8034d9:	5f                   	pop    %edi
  8034da:	5d                   	pop    %ebp
  8034db:	c3                   	ret    
  8034dc:	39 f0                	cmp    %esi,%eax
  8034de:	0f 87 ac 00 00 00    	ja     803590 <__umoddi3+0xfc>
  8034e4:	0f bd e8             	bsr    %eax,%ebp
  8034e7:	83 f5 1f             	xor    $0x1f,%ebp
  8034ea:	0f 84 ac 00 00 00    	je     80359c <__umoddi3+0x108>
  8034f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034f5:	29 ef                	sub    %ebp,%edi
  8034f7:	89 fe                	mov    %edi,%esi
  8034f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034fd:	89 e9                	mov    %ebp,%ecx
  8034ff:	d3 e0                	shl    %cl,%eax
  803501:	89 d7                	mov    %edx,%edi
  803503:	89 f1                	mov    %esi,%ecx
  803505:	d3 ef                	shr    %cl,%edi
  803507:	09 c7                	or     %eax,%edi
  803509:	89 e9                	mov    %ebp,%ecx
  80350b:	d3 e2                	shl    %cl,%edx
  80350d:	89 14 24             	mov    %edx,(%esp)
  803510:	89 d8                	mov    %ebx,%eax
  803512:	d3 e0                	shl    %cl,%eax
  803514:	89 c2                	mov    %eax,%edx
  803516:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351a:	d3 e0                	shl    %cl,%eax
  80351c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803520:	8b 44 24 08          	mov    0x8(%esp),%eax
  803524:	89 f1                	mov    %esi,%ecx
  803526:	d3 e8                	shr    %cl,%eax
  803528:	09 d0                	or     %edx,%eax
  80352a:	d3 eb                	shr    %cl,%ebx
  80352c:	89 da                	mov    %ebx,%edx
  80352e:	f7 f7                	div    %edi
  803530:	89 d3                	mov    %edx,%ebx
  803532:	f7 24 24             	mull   (%esp)
  803535:	89 c6                	mov    %eax,%esi
  803537:	89 d1                	mov    %edx,%ecx
  803539:	39 d3                	cmp    %edx,%ebx
  80353b:	0f 82 87 00 00 00    	jb     8035c8 <__umoddi3+0x134>
  803541:	0f 84 91 00 00 00    	je     8035d8 <__umoddi3+0x144>
  803547:	8b 54 24 04          	mov    0x4(%esp),%edx
  80354b:	29 f2                	sub    %esi,%edx
  80354d:	19 cb                	sbb    %ecx,%ebx
  80354f:	89 d8                	mov    %ebx,%eax
  803551:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803555:	d3 e0                	shl    %cl,%eax
  803557:	89 e9                	mov    %ebp,%ecx
  803559:	d3 ea                	shr    %cl,%edx
  80355b:	09 d0                	or     %edx,%eax
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 eb                	shr    %cl,%ebx
  803561:	89 da                	mov    %ebx,%edx
  803563:	83 c4 1c             	add    $0x1c,%esp
  803566:	5b                   	pop    %ebx
  803567:	5e                   	pop    %esi
  803568:	5f                   	pop    %edi
  803569:	5d                   	pop    %ebp
  80356a:	c3                   	ret    
  80356b:	90                   	nop
  80356c:	89 fd                	mov    %edi,%ebp
  80356e:	85 ff                	test   %edi,%edi
  803570:	75 0b                	jne    80357d <__umoddi3+0xe9>
  803572:	b8 01 00 00 00       	mov    $0x1,%eax
  803577:	31 d2                	xor    %edx,%edx
  803579:	f7 f7                	div    %edi
  80357b:	89 c5                	mov    %eax,%ebp
  80357d:	89 f0                	mov    %esi,%eax
  80357f:	31 d2                	xor    %edx,%edx
  803581:	f7 f5                	div    %ebp
  803583:	89 c8                	mov    %ecx,%eax
  803585:	f7 f5                	div    %ebp
  803587:	89 d0                	mov    %edx,%eax
  803589:	e9 44 ff ff ff       	jmp    8034d2 <__umoddi3+0x3e>
  80358e:	66 90                	xchg   %ax,%ax
  803590:	89 c8                	mov    %ecx,%eax
  803592:	89 f2                	mov    %esi,%edx
  803594:	83 c4 1c             	add    $0x1c,%esp
  803597:	5b                   	pop    %ebx
  803598:	5e                   	pop    %esi
  803599:	5f                   	pop    %edi
  80359a:	5d                   	pop    %ebp
  80359b:	c3                   	ret    
  80359c:	3b 04 24             	cmp    (%esp),%eax
  80359f:	72 06                	jb     8035a7 <__umoddi3+0x113>
  8035a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035a5:	77 0f                	ja     8035b6 <__umoddi3+0x122>
  8035a7:	89 f2                	mov    %esi,%edx
  8035a9:	29 f9                	sub    %edi,%ecx
  8035ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035af:	89 14 24             	mov    %edx,(%esp)
  8035b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035ba:	8b 14 24             	mov    (%esp),%edx
  8035bd:	83 c4 1c             	add    $0x1c,%esp
  8035c0:	5b                   	pop    %ebx
  8035c1:	5e                   	pop    %esi
  8035c2:	5f                   	pop    %edi
  8035c3:	5d                   	pop    %ebp
  8035c4:	c3                   	ret    
  8035c5:	8d 76 00             	lea    0x0(%esi),%esi
  8035c8:	2b 04 24             	sub    (%esp),%eax
  8035cb:	19 fa                	sbb    %edi,%edx
  8035cd:	89 d1                	mov    %edx,%ecx
  8035cf:	89 c6                	mov    %eax,%esi
  8035d1:	e9 71 ff ff ff       	jmp    803547 <__umoddi3+0xb3>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035dc:	72 ea                	jb     8035c8 <__umoddi3+0x134>
  8035de:	89 d9                	mov    %ebx,%ecx
  8035e0:	e9 62 ff ff ff       	jmp    803547 <__umoddi3+0xb3>
