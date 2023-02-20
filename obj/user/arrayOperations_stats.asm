
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 75 1d 00 00       	call   801db8 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 9f 1d 00 00       	call   801dea <sys_getparentenvid>
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
  80005f:	68 c0 36 80 00       	push   $0x8036c0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 45 18 00 00       	call   8018b1 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c4 36 80 00       	push   $0x8036c4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 2f 18 00 00       	call   8018b1 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 cc 36 80 00       	push   $0x8036cc
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 12 18 00 00       	call   8018b1 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 da 36 80 00       	push   $0x8036da
  8000b8:	e8 31 17 00 00       	call   8017ee <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 e4 36 80 00       	push   $0x8036e4
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 09 37 80 00       	push   $0x803709
  80013f:	e8 aa 16 00 00       	call   8017ee <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 0e 37 80 00       	push   $0x80370e
  80015e:	e8 8b 16 00 00       	call   8017ee <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 12 37 80 00       	push   $0x803712
  80017d:	e8 6c 16 00 00       	call   8017ee <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 16 37 80 00       	push   $0x803716
  80019c:	e8 4d 16 00 00       	call   8017ee <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 1a 37 80 00       	push   $0x80371a
  8001bb:	e8 2e 16 00 00       	call   8017ee <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 e8 1b 00 00       	call   801e1d <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 99 18 00 00       	call   801dd1 <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 40 80 00       	mov    0x804020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 3b 16 00 00       	call   801bde <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 38 37 80 00       	push   $0x803738
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 60 37 80 00       	push   $0x803760
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 88 37 80 00       	push   $0x803788
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 40 80 00       	mov    0x804020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 e0 37 80 00       	push   $0x8037e0
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 38 37 80 00       	push   $0x803738
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 bb 15 00 00       	call   801bf8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 48 17 00 00       	call   801d9d <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 9d 17 00 00       	call   801e03 <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 7c 13 00 00       	call   801a30 <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 40 80 00       	mov    0x804024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 05 13 00 00       	call   801a30 <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 69 14 00 00       	call   801bde <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 63 14 00 00       	call   801bf8 <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 61 2c 00 00       	call   803440 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 21 2d 00 00       	call   803550 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 14 3a 80 00       	add    $0x803a14,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 38 3a 80 00 	mov    0x803a38(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d 80 38 80 00 	mov    0x803880(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 25 3a 80 00       	push   $0x803a25
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 2e 3a 80 00       	push   $0x803a2e
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be 31 3a 80 00       	mov    $0x803a31,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 90 3b 80 00       	push   $0x803b90
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8014fe:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801505:	00 00 00 
  801508:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80150f:	00 00 00 
  801512:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801519:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801523:	00 00 00 
  801526:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80152d:	00 00 00 
  801530:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801537:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80153a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801541:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801544:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80154b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80155f:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801564:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80156b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801573:	2d 00 10 00 00       	sub    $0x1000,%eax
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	6a 06                	push   $0x6
  80157d:	ff 75 f4             	pushl  -0xc(%ebp)
  801580:	50                   	push   %eax
  801581:	e8 ee 05 00 00       	call   801b74 <sys_allocate_chunk>
  801586:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801589:	a1 20 41 80 00       	mov    0x804120,%eax
  80158e:	83 ec 0c             	sub    $0xc,%esp
  801591:	50                   	push   %eax
  801592:	e8 63 0c 00 00       	call   8021fa <initialize_MemBlocksList>
  801597:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80159a:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80159f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8015a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8015ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015af:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bd:	89 c2                	mov    %eax,%edx
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8015c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8015cf:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8015d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d9:	8b 50 08             	mov    0x8(%eax),%edx
  8015dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	48                   	dec    %eax
  8015e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8015e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	f7 75 e0             	divl   -0x20(%ebp)
  8015f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015f3:	29 d0                	sub    %edx,%eax
  8015f5:	89 c2                	mov    %eax,%edx
  8015f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015fa:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8015fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801601:	75 14                	jne    801617 <initialize_dyn_block_system+0x11f>
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	68 b5 3b 80 00       	push   $0x803bb5
  80160b:	6a 34                	push   $0x34
  80160d:	68 d3 3b 80 00       	push   $0x803bd3
  801612:	e8 47 1c 00 00       	call   80325e <_panic>
  801617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80161a:	8b 00                	mov    (%eax),%eax
  80161c:	85 c0                	test   %eax,%eax
  80161e:	74 10                	je     801630 <initialize_dyn_block_system+0x138>
  801620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801623:	8b 00                	mov    (%eax),%eax
  801625:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801628:	8b 52 04             	mov    0x4(%edx),%edx
  80162b:	89 50 04             	mov    %edx,0x4(%eax)
  80162e:	eb 0b                	jmp    80163b <initialize_dyn_block_system+0x143>
  801630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801633:	8b 40 04             	mov    0x4(%eax),%eax
  801636:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80163b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163e:	8b 40 04             	mov    0x4(%eax),%eax
  801641:	85 c0                	test   %eax,%eax
  801643:	74 0f                	je     801654 <initialize_dyn_block_system+0x15c>
  801645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801648:	8b 40 04             	mov    0x4(%eax),%eax
  80164b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80164e:	8b 12                	mov    (%edx),%edx
  801650:	89 10                	mov    %edx,(%eax)
  801652:	eb 0a                	jmp    80165e <initialize_dyn_block_system+0x166>
  801654:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	a3 48 41 80 00       	mov    %eax,0x804148
  80165e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801661:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801671:	a1 54 41 80 00       	mov    0x804154,%eax
  801676:	48                   	dec    %eax
  801677:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	ff 75 e8             	pushl  -0x18(%ebp)
  801682:	e8 c4 13 00 00       	call   802a4b <insert_sorted_with_merge_freeList>
  801687:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80168a:	90                   	nop
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <malloc>:
//=================================



void* malloc(uint32 size)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801693:	e8 2f fe ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801698:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80169c:	75 07                	jne    8016a5 <malloc+0x18>
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 71                	jmp    801716 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016a5:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016ac:	76 07                	jbe    8016b5 <malloc+0x28>
	return NULL;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b3:	eb 61                	jmp    801716 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016b5:	e8 88 08 00 00       	call   801f42 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 53                	je     801711 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016be:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	48                   	dec    %eax
  8016ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	f7 75 f4             	divl   -0xc(%ebp)
  8016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016df:	29 d0                	sub    %edx,%eax
  8016e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8016ea:	e8 d2 0d 00 00       	call   8024c1 <alloc_block_FF>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8016f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016f9:	74 16                	je     801711 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801701:	e8 0c 0c 00 00       	call   802312 <insert_sorted_allocList>
  801706:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170c:	8b 40 08             	mov    0x8(%eax),%eax
  80170f:	eb 05                	jmp    801716 <malloc+0x89>
    }

			}


	return NULL;
  801711:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801727:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80172c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	ff 75 f0             	pushl  -0x10(%ebp)
  801735:	68 40 40 80 00       	push   $0x804040
  80173a:	e8 a0 0b 00 00       	call   8022df <find_block>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801748:	8b 50 0c             	mov    0xc(%eax),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	52                   	push   %edx
  801752:	50                   	push   %eax
  801753:	e8 e4 03 00 00       	call   801b3c <sys_free_user_mem>
  801758:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80175b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80175f:	75 17                	jne    801778 <free+0x60>
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 b5 3b 80 00       	push   $0x803bb5
  801769:	68 84 00 00 00       	push   $0x84
  80176e:	68 d3 3b 80 00       	push   $0x803bd3
  801773:	e8 e6 1a 00 00       	call   80325e <_panic>
  801778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177b:	8b 00                	mov    (%eax),%eax
  80177d:	85 c0                	test   %eax,%eax
  80177f:	74 10                	je     801791 <free+0x79>
  801781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801789:	8b 52 04             	mov    0x4(%edx),%edx
  80178c:	89 50 04             	mov    %edx,0x4(%eax)
  80178f:	eb 0b                	jmp    80179c <free+0x84>
  801791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801794:	8b 40 04             	mov    0x4(%eax),%eax
  801797:	a3 44 40 80 00       	mov    %eax,0x804044
  80179c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179f:	8b 40 04             	mov    0x4(%eax),%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 0f                	je     8017b5 <free+0x9d>
  8017a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a9:	8b 40 04             	mov    0x4(%eax),%eax
  8017ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017af:	8b 12                	mov    (%edx),%edx
  8017b1:	89 10                	mov    %edx,(%eax)
  8017b3:	eb 0a                	jmp    8017bf <free+0xa7>
  8017b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b8:	8b 00                	mov    (%eax),%eax
  8017ba:	a3 40 40 80 00       	mov    %eax,0x804040
  8017bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017d2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017d7:	48                   	dec    %eax
  8017d8:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8017dd:	83 ec 0c             	sub    $0xc,%esp
  8017e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8017e3:	e8 63 12 00 00       	call   802a4b <insert_sorted_with_merge_freeList>
  8017e8:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8017eb:	90                   	nop
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 38             	sub    $0x38,%esp
  8017f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fa:	e8 c8 fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801803:	75 0a                	jne    80180f <smalloc+0x21>
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
  80180a:	e9 a0 00 00 00       	jmp    8018af <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80180f:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801816:	76 0a                	jbe    801822 <smalloc+0x34>
		return NULL;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
  80181d:	e9 8d 00 00 00       	jmp    8018af <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801822:	e8 1b 07 00 00       	call   801f42 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801827:	85 c0                	test   %eax,%eax
  801829:	74 7f                	je     8018aa <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80182b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801838:	01 d0                	add    %edx,%eax
  80183a:	48                   	dec    %eax
  80183b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	f7 75 f4             	divl   -0xc(%ebp)
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184c:	29 d0                	sub    %edx,%eax
  80184e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	ff 75 ec             	pushl  -0x14(%ebp)
  801857:	e8 65 0c 00 00       	call   8024c1 <alloc_block_FF>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801862:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801866:	74 42                	je     8018aa <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 e8             	pushl  -0x18(%ebp)
  80186e:	e8 9f 0a 00 00       	call   802312 <insert_sorted_allocList>
  801873:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801879:	8b 40 08             	mov    0x8(%eax),%eax
  80187c:	89 c2                	mov    %eax,%edx
  80187e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	e8 38 04 00 00       	call   801cc7 <sys_createSharedObject>
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801899:	79 07                	jns    8018a2 <smalloc+0xb4>
	    		  return NULL;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a0:	eb 0d                	jmp    8018af <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8018a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a5:	8b 40 08             	mov    0x8(%eax),%eax
  8018a8:	eb 05                	jmp    8018af <smalloc+0xc1>


				}


		return NULL;
  8018aa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b7:	e8 0b fc ff ff       	call   8014c7 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018bc:	e8 81 06 00 00       	call   801f42 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	0f 84 9f 00 00 00    	je     801968 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	e8 1a 04 00 00       	call   801cf1 <sys_getSizeOfSharedObject>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8018dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e1:	79 0a                	jns    8018ed <sget+0x3c>
		return NULL;
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e8:	e9 80 00 00 00       	jmp    80196d <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8018ed:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	48                   	dec    %eax
  8018fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801903:	ba 00 00 00 00       	mov    $0x0,%edx
  801908:	f7 75 f0             	divl   -0x10(%ebp)
  80190b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190e:	29 d0                	sub    %edx,%eax
  801910:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	ff 75 e8             	pushl  -0x18(%ebp)
  801919:	e8 a3 0b 00 00       	call   8024c1 <alloc_block_FF>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801928:	74 3e                	je     801968 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80192a:	83 ec 0c             	sub    $0xc,%esp
  80192d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801930:	e8 dd 09 00 00       	call   802312 <insert_sorted_allocList>
  801935:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193b:	8b 40 08             	mov    0x8(%eax),%eax
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	50                   	push   %eax
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	e8 c1 03 00 00       	call   801d0e <sys_getSharedObject>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801953:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801957:	79 07                	jns    801960 <sget+0xaf>
	    		  return NULL;
  801959:	b8 00 00 00 00       	mov    $0x0,%eax
  80195e:	eb 0d                	jmp    80196d <sget+0xbc>
	  	return(void*) returned_block->sva;
  801960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801963:	8b 40 08             	mov    0x8(%eax),%eax
  801966:	eb 05                	jmp    80196d <sget+0xbc>
	      }
	}
	   return NULL;
  801968:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801975:	e8 4d fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	68 e0 3b 80 00       	push   $0x803be0
  801982:	68 12 01 00 00       	push   $0x112
  801987:	68 d3 3b 80 00       	push   $0x803bd3
  80198c:	e8 cd 18 00 00       	call   80325e <_panic>

00801991 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	68 08 3c 80 00       	push   $0x803c08
  80199f:	68 26 01 00 00       	push   $0x126
  8019a4:	68 d3 3b 80 00       	push   $0x803bd3
  8019a9:	e8 b0 18 00 00       	call   80325e <_panic>

008019ae <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	68 2c 3c 80 00       	push   $0x803c2c
  8019bc:	68 31 01 00 00       	push   $0x131
  8019c1:	68 d3 3b 80 00       	push   $0x803bd3
  8019c6:	e8 93 18 00 00       	call   80325e <_panic>

008019cb <shrink>:

}
void shrink(uint32 newSize)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	68 2c 3c 80 00       	push   $0x803c2c
  8019d9:	68 36 01 00 00       	push   $0x136
  8019de:	68 d3 3b 80 00       	push   $0x803bd3
  8019e3:	e8 76 18 00 00       	call   80325e <_panic>

008019e8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	68 2c 3c 80 00       	push   $0x803c2c
  8019f6:	68 3b 01 00 00       	push   $0x13b
  8019fb:	68 d3 3b 80 00       	push   $0x803bd3
  801a00:	e8 59 18 00 00       	call   80325e <_panic>

00801a05 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	57                   	push   %edi
  801a09:	56                   	push   %esi
  801a0a:	53                   	push   %ebx
  801a0b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a17:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a1d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a20:	cd 30                	int    $0x30
  801a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 10             	mov    0x10(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a3c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	50                   	push   %eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	e8 b2 ff ff ff       	call   801a05 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	90                   	nop
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 01                	push   $0x1
  801a68:	e8 98 ff ff ff       	call   801a05 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 05                	push   $0x5
  801a85:	e8 7b ff ff ff       	call   801a05 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a94:	8b 75 18             	mov    0x18(%ebp),%esi
  801a97:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	56                   	push   %esi
  801aa4:	53                   	push   %ebx
  801aa5:	51                   	push   %ecx
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 06                	push   $0x6
  801aaa:	e8 56 ff ff ff       	call   801a05 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5e                   	pop    %esi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801abc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	52                   	push   %edx
  801ac9:	50                   	push   %eax
  801aca:	6a 07                	push   $0x7
  801acc:	e8 34 ff ff ff       	call   801a05 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 08                	push   $0x8
  801ae7:	e8 19 ff ff ff       	call   801a05 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 09                	push   $0x9
  801b00:	e8 00 ff ff ff       	call   801a05 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 0a                	push   $0xa
  801b19:	e8 e7 fe ff ff       	call   801a05 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 0b                	push   $0xb
  801b32:	e8 ce fe ff ff       	call   801a05 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	ff 75 08             	pushl  0x8(%ebp)
  801b4b:	6a 0f                	push   $0xf
  801b4d:	e8 b3 fe ff ff       	call   801a05 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
	return;
  801b55:	90                   	nop
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	6a 10                	push   $0x10
  801b69:	e8 97 fe ff ff       	call   801a05 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b71:	90                   	nop
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 10             	pushl  0x10(%ebp)
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	6a 11                	push   $0x11
  801b86:	e8 7a fe ff ff       	call   801a05 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8e:	90                   	nop
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 0c                	push   $0xc
  801ba0:	e8 60 fe ff ff       	call   801a05 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 0d                	push   $0xd
  801bba:	e8 46 fe ff ff       	call   801a05 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 0e                	push   $0xe
  801bd3:	e8 2d fe ff ff       	call   801a05 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	90                   	nop
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 13                	push   $0x13
  801bed:	e8 13 fe ff ff       	call   801a05 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	90                   	nop
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 14                	push   $0x14
  801c07:	e8 f9 fd ff ff       	call   801a05 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	90                   	nop
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	50                   	push   %eax
  801c2b:	6a 15                	push   $0x15
  801c2d:	e8 d3 fd ff ff       	call   801a05 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	90                   	nop
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 16                	push   $0x16
  801c47:	e8 b9 fd ff ff       	call   801a05 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	90                   	nop
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	ff 75 0c             	pushl  0xc(%ebp)
  801c61:	50                   	push   %eax
  801c62:	6a 17                	push   $0x17
  801c64:	e8 9c fd ff ff       	call   801a05 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 1a                	push   $0x1a
  801c81:	e8 7f fd ff ff       	call   801a05 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	52                   	push   %edx
  801c9b:	50                   	push   %eax
  801c9c:	6a 18                	push   $0x18
  801c9e:	e8 62 fd ff ff       	call   801a05 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	90                   	nop
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 19                	push   $0x19
  801cbc:	e8 44 fd ff ff       	call   801a05 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cd3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	51                   	push   %ecx
  801ce0:	52                   	push   %edx
  801ce1:	ff 75 0c             	pushl  0xc(%ebp)
  801ce4:	50                   	push   %eax
  801ce5:	6a 1b                	push   $0x1b
  801ce7:	e8 19 fd ff ff       	call   801a05 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 1c                	push   $0x1c
  801d04:	e8 fc fc ff ff       	call   801a05 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	51                   	push   %ecx
  801d1f:	52                   	push   %edx
  801d20:	50                   	push   %eax
  801d21:	6a 1d                	push   $0x1d
  801d23:	e8 dd fc ff ff       	call   801a05 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 1e                	push   $0x1e
  801d40:	e8 c0 fc ff ff       	call   801a05 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 1f                	push   $0x1f
  801d59:	e8 a7 fc ff ff       	call   801a05 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 14             	pushl  0x14(%ebp)
  801d6e:	ff 75 10             	pushl  0x10(%ebp)
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	50                   	push   %eax
  801d75:	6a 20                	push   $0x20
  801d77:	e8 89 fc ff ff       	call   801a05 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	50                   	push   %eax
  801d90:	6a 21                	push   $0x21
  801d92:	e8 6e fc ff ff       	call   801a05 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	50                   	push   %eax
  801dac:	6a 22                	push   $0x22
  801dae:	e8 52 fc ff ff       	call   801a05 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 02                	push   $0x2
  801dc7:	e8 39 fc ff ff       	call   801a05 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 03                	push   $0x3
  801de0:	e8 20 fc ff ff       	call   801a05 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 04                	push   $0x4
  801df9:	e8 07 fc ff ff       	call   801a05 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_exit_env>:


void sys_exit_env(void)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 23                	push   $0x23
  801e12:	e8 ee fb ff ff       	call   801a05 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	90                   	nop
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e26:	8d 50 04             	lea    0x4(%eax),%edx
  801e29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	6a 24                	push   $0x24
  801e36:	e8 ca fb ff ff       	call   801a05 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
	return result;
  801e3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e47:	89 01                	mov    %eax,(%ecx)
  801e49:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	c9                   	leave  
  801e50:	c2 04 00             	ret    $0x4

00801e53 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 10             	pushl  0x10(%ebp)
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	6a 12                	push   $0x12
  801e65:	e8 9b fb ff ff       	call   801a05 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6d:	90                   	nop
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 25                	push   $0x25
  801e7f:	e8 81 fb ff ff       	call   801a05 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e95:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	50                   	push   %eax
  801ea2:	6a 26                	push   $0x26
  801ea4:	e8 5c fb ff ff       	call   801a05 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <rsttst>:
void rsttst()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 28                	push   $0x28
  801ebe:	e8 42 fb ff ff       	call   801a05 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec6:	90                   	nop
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	ff 75 10             	pushl  0x10(%ebp)
  801ee1:	ff 75 0c             	pushl  0xc(%ebp)
  801ee4:	ff 75 08             	pushl  0x8(%ebp)
  801ee7:	6a 27                	push   $0x27
  801ee9:	e8 17 fb ff ff       	call   801a05 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef1:	90                   	nop
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <chktst>:
void chktst(uint32 n)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	6a 29                	push   $0x29
  801f04:	e8 fc fa ff ff       	call   801a05 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0c:	90                   	nop
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <inctst>:

void inctst()
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 2a                	push   $0x2a
  801f1e:	e8 e2 fa ff ff       	call   801a05 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
	return ;
  801f26:	90                   	nop
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <gettst>:
uint32 gettst()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 2b                	push   $0x2b
  801f38:	e8 c8 fa ff ff       	call   801a05 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 2c                	push   $0x2c
  801f54:	e8 ac fa ff ff       	call   801a05 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f5f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f63:	75 07                	jne    801f6c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6a:	eb 05                	jmp    801f71 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 2c                	push   $0x2c
  801f85:	e8 7b fa ff ff       	call   801a05 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
  801f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f90:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f94:	75 07                	jne    801f9d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	eb 05                	jmp    801fa2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 2c                	push   $0x2c
  801fb6:	e8 4a fa ff ff       	call   801a05 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc5:	75 07                	jne    801fce <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcc:	eb 05                	jmp    801fd3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 2c                	push   $0x2c
  801fe7:	e8 19 fa ff ff       	call   801a05 <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ff2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff6:	75 07                	jne    801fff <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffd:	eb 05                	jmp    802004 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	6a 2d                	push   $0x2d
  802016:	e8 ea f9 ff ff       	call   801a05 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
	return ;
  80201e:	90                   	nop
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802025:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802028:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	53                   	push   %ebx
  802034:	51                   	push   %ecx
  802035:	52                   	push   %edx
  802036:	50                   	push   %eax
  802037:	6a 2e                	push   $0x2e
  802039:	e8 c7 f9 ff ff       	call   801a05 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	6a 2f                	push   $0x2f
  802059:	e8 a7 f9 ff ff       	call   801a05 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	68 3c 3c 80 00       	push   $0x803c3c
  802071:	e8 c7 e6 ff ff       	call   80073d <cprintf>
  802076:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802079:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	68 68 3c 80 00       	push   $0x803c68
  802088:	e8 b0 e6 ff ff       	call   80073d <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802090:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802094:	a1 38 41 80 00       	mov    0x804138,%eax
  802099:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209c:	eb 56                	jmp    8020f4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80209e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a2:	74 1c                	je     8020c0 <print_mem_block_lists+0x5d>
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	8b 50 08             	mov    0x8(%eax),%edx
  8020aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ad:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b6:	01 c8                	add    %ecx,%eax
  8020b8:	39 c2                	cmp    %eax,%edx
  8020ba:	73 04                	jae    8020c0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020bc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 50 08             	mov    0x8(%eax),%edx
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cc:	01 c2                	add    %eax,%edx
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 40 08             	mov    0x8(%eax),%eax
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	68 7d 3c 80 00       	push   $0x803c7d
  8020de:	e8 5a e6 ff ff       	call   80073d <cprintf>
  8020e3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ec:	a1 40 41 80 00       	mov    0x804140,%eax
  8020f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f8:	74 07                	je     802101 <print_mem_block_lists+0x9e>
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	eb 05                	jmp    802106 <print_mem_block_lists+0xa3>
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	a3 40 41 80 00       	mov    %eax,0x804140
  80210b:	a1 40 41 80 00       	mov    0x804140,%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	75 8a                	jne    80209e <print_mem_block_lists+0x3b>
  802114:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802118:	75 84                	jne    80209e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80211a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80211e:	75 10                	jne    802130 <print_mem_block_lists+0xcd>
  802120:	83 ec 0c             	sub    $0xc,%esp
  802123:	68 8c 3c 80 00       	push   $0x803c8c
  802128:	e8 10 e6 ff ff       	call   80073d <cprintf>
  80212d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802130:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	68 b0 3c 80 00       	push   $0x803cb0
  80213f:	e8 f9 e5 ff ff       	call   80073d <cprintf>
  802144:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802147:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80214b:	a1 40 40 80 00       	mov    0x804040,%eax
  802150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802153:	eb 56                	jmp    8021ab <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802159:	74 1c                	je     802177 <print_mem_block_lists+0x114>
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 50 08             	mov    0x8(%eax),%edx
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	8b 48 08             	mov    0x8(%eax),%ecx
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	8b 40 0c             	mov    0xc(%eax),%eax
  80216d:	01 c8                	add    %ecx,%eax
  80216f:	39 c2                	cmp    %eax,%edx
  802171:	73 04                	jae    802177 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802173:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	8b 50 08             	mov    0x8(%eax),%edx
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 40 0c             	mov    0xc(%eax),%eax
  802183:	01 c2                	add    %eax,%edx
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 40 08             	mov    0x8(%eax),%eax
  80218b:	83 ec 04             	sub    $0x4,%esp
  80218e:	52                   	push   %edx
  80218f:	50                   	push   %eax
  802190:	68 7d 3c 80 00       	push   $0x803c7d
  802195:	e8 a3 e5 ff ff       	call   80073d <cprintf>
  80219a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021a3:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021af:	74 07                	je     8021b8 <print_mem_block_lists+0x155>
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	eb 05                	jmp    8021bd <print_mem_block_lists+0x15a>
  8021b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bd:	a3 48 40 80 00       	mov    %eax,0x804048
  8021c2:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	75 8a                	jne    802155 <print_mem_block_lists+0xf2>
  8021cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cf:	75 84                	jne    802155 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021d1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d5:	75 10                	jne    8021e7 <print_mem_block_lists+0x184>
  8021d7:	83 ec 0c             	sub    $0xc,%esp
  8021da:	68 c8 3c 80 00       	push   $0x803cc8
  8021df:	e8 59 e5 ff ff       	call   80073d <cprintf>
  8021e4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	68 3c 3c 80 00       	push   $0x803c3c
  8021ef:	e8 49 e5 ff ff       	call   80073d <cprintf>
  8021f4:	83 c4 10             	add    $0x10,%esp

}
  8021f7:	90                   	nop
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802200:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802207:	00 00 00 
  80220a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802211:	00 00 00 
  802214:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80221b:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80221e:	a1 50 40 80 00       	mov    0x804050,%eax
  802223:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80222d:	e9 9e 00 00 00       	jmp    8022d0 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802232:	a1 50 40 80 00       	mov    0x804050,%eax
  802237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223a:	c1 e2 04             	shl    $0x4,%edx
  80223d:	01 d0                	add    %edx,%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	75 14                	jne    802257 <initialize_MemBlocksList+0x5d>
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	68 f0 3c 80 00       	push   $0x803cf0
  80224b:	6a 48                	push   $0x48
  80224d:	68 13 3d 80 00       	push   $0x803d13
  802252:	e8 07 10 00 00       	call   80325e <_panic>
  802257:	a1 50 40 80 00       	mov    0x804050,%eax
  80225c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225f:	c1 e2 04             	shl    $0x4,%edx
  802262:	01 d0                	add    %edx,%eax
  802264:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80226a:	89 10                	mov    %edx,(%eax)
  80226c:	8b 00                	mov    (%eax),%eax
  80226e:	85 c0                	test   %eax,%eax
  802270:	74 18                	je     80228a <initialize_MemBlocksList+0x90>
  802272:	a1 48 41 80 00       	mov    0x804148,%eax
  802277:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80227d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802280:	c1 e1 04             	shl    $0x4,%ecx
  802283:	01 ca                	add    %ecx,%edx
  802285:	89 50 04             	mov    %edx,0x4(%eax)
  802288:	eb 12                	jmp    80229c <initialize_MemBlocksList+0xa2>
  80228a:	a1 50 40 80 00       	mov    0x804050,%eax
  80228f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802292:	c1 e2 04             	shl    $0x4,%edx
  802295:	01 d0                	add    %edx,%eax
  802297:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80229c:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a4:	c1 e2 04             	shl    $0x4,%edx
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	a3 48 41 80 00       	mov    %eax,0x804148
  8022ae:	a1 50 40 80 00       	mov    0x804050,%eax
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	c1 e2 04             	shl    $0x4,%edx
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c2:	a1 54 41 80 00       	mov    0x804154,%eax
  8022c7:	40                   	inc    %eax
  8022c8:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8022cd:	ff 45 f4             	incl   -0xc(%ebp)
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d6:	0f 82 56 ff ff ff    	jb     802232 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8022dc:	90                   	nop
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8022ed:	eb 18                	jmp    802307 <find_block+0x28>
		{
			if(tmp->sva==va)
  8022ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f2:	8b 40 08             	mov    0x8(%eax),%eax
  8022f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022f8:	75 05                	jne    8022ff <find_block+0x20>
			{
				return tmp;
  8022fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022fd:	eb 11                	jmp    802310 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8022ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802307:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80230b:	75 e2                	jne    8022ef <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80230d:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802318:	a1 40 40 80 00       	mov    0x804040,%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	0f 85 83 00 00 00    	jne    8023a8 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802325:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80232c:	00 00 00 
  80232f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802336:	00 00 00 
  802339:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802340:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802343:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802347:	75 14                	jne    80235d <insert_sorted_allocList+0x4b>
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 f0 3c 80 00       	push   $0x803cf0
  802351:	6a 7f                	push   $0x7f
  802353:	68 13 3d 80 00       	push   $0x803d13
  802358:	e8 01 0f 00 00       	call   80325e <_panic>
  80235d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	89 10                	mov    %edx,(%eax)
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 0d                	je     80237e <insert_sorted_allocList+0x6c>
  802371:	a1 40 40 80 00       	mov    0x804040,%eax
  802376:	8b 55 08             	mov    0x8(%ebp),%edx
  802379:	89 50 04             	mov    %edx,0x4(%eax)
  80237c:	eb 08                	jmp    802386 <insert_sorted_allocList+0x74>
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 44 40 80 00       	mov    %eax,0x804044
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	a3 40 40 80 00       	mov    %eax,0x804040
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802398:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80239d:	40                   	inc    %eax
  80239e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023a3:	e9 16 01 00 00       	jmp    8024be <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 50 08             	mov    0x8(%eax),%edx
  8023ae:	a1 44 40 80 00       	mov    0x804044,%eax
  8023b3:	8b 40 08             	mov    0x8(%eax),%eax
  8023b6:	39 c2                	cmp    %eax,%edx
  8023b8:	76 68                	jbe    802422 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8023ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023be:	75 17                	jne    8023d7 <insert_sorted_allocList+0xc5>
  8023c0:	83 ec 04             	sub    $0x4,%esp
  8023c3:	68 2c 3d 80 00       	push   $0x803d2c
  8023c8:	68 85 00 00 00       	push   $0x85
  8023cd:	68 13 3d 80 00       	push   $0x803d13
  8023d2:	e8 87 0e 00 00       	call   80325e <_panic>
  8023d7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	89 50 04             	mov    %edx,0x4(%eax)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 40 04             	mov    0x4(%eax),%eax
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	74 0c                	je     8023f9 <insert_sorted_allocList+0xe7>
  8023ed:	a1 44 40 80 00       	mov    0x804044,%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 10                	mov    %edx,(%eax)
  8023f7:	eb 08                	jmp    802401 <insert_sorted_allocList+0xef>
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 40 40 80 00       	mov    %eax,0x804040
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	a3 44 40 80 00       	mov    %eax,0x804044
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802412:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802417:	40                   	inc    %eax
  802418:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80241d:	e9 9c 00 00 00       	jmp    8024be <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802422:	a1 40 40 80 00       	mov    0x804040,%eax
  802427:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80242a:	e9 85 00 00 00       	jmp    8024b4 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8b 50 08             	mov    0x8(%eax),%edx
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 08             	mov    0x8(%eax),%eax
  80243b:	39 c2                	cmp    %eax,%edx
  80243d:	73 6d                	jae    8024ac <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80243f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802443:	74 06                	je     80244b <insert_sorted_allocList+0x139>
  802445:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802449:	75 17                	jne    802462 <insert_sorted_allocList+0x150>
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	68 50 3d 80 00       	push   $0x803d50
  802453:	68 90 00 00 00       	push   $0x90
  802458:	68 13 3d 80 00       	push   $0x803d13
  80245d:	e8 fc 0d 00 00       	call   80325e <_panic>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 50 04             	mov    0x4(%eax),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	89 50 04             	mov    %edx,0x4(%eax)
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802474:	89 10                	mov    %edx,(%eax)
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 40 04             	mov    0x4(%eax),%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	74 0d                	je     80248d <insert_sorted_allocList+0x17b>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 04             	mov    0x4(%eax),%eax
  802486:	8b 55 08             	mov    0x8(%ebp),%edx
  802489:	89 10                	mov    %edx,(%eax)
  80248b:	eb 08                	jmp    802495 <insert_sorted_allocList+0x183>
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	a3 40 40 80 00       	mov    %eax,0x804040
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 55 08             	mov    0x8(%ebp),%edx
  80249b:	89 50 04             	mov    %edx,0x4(%eax)
  80249e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024a3:	40                   	inc    %eax
  8024a4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8024a9:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024aa:	eb 12                	jmp    8024be <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8024b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b8:	0f 85 71 ff ff ff    	jne    80242f <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024be:	90                   	nop
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024c7:	a1 38 41 80 00       	mov    0x804138,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8024cf:	e9 76 01 00 00       	jmp    80264a <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 85 8a 00 00 00    	jne    80256d <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e7:	75 17                	jne    802500 <alloc_block_FF+0x3f>
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	68 85 3d 80 00       	push   $0x803d85
  8024f1:	68 a8 00 00 00       	push   $0xa8
  8024f6:	68 13 3d 80 00       	push   $0x803d13
  8024fb:	e8 5e 0d 00 00       	call   80325e <_panic>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 10                	je     802519 <alloc_block_FF+0x58>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802511:	8b 52 04             	mov    0x4(%edx),%edx
  802514:	89 50 04             	mov    %edx,0x4(%eax)
  802517:	eb 0b                	jmp    802524 <alloc_block_FF+0x63>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 40 04             	mov    0x4(%eax),%eax
  80252a:	85 c0                	test   %eax,%eax
  80252c:	74 0f                	je     80253d <alloc_block_FF+0x7c>
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 40 04             	mov    0x4(%eax),%eax
  802534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802537:	8b 12                	mov    (%edx),%edx
  802539:	89 10                	mov    %edx,(%eax)
  80253b:	eb 0a                	jmp    802547 <alloc_block_FF+0x86>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	a3 38 41 80 00       	mov    %eax,0x804138
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255a:	a1 44 41 80 00       	mov    0x804144,%eax
  80255f:	48                   	dec    %eax
  802560:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	e9 ea 00 00 00       	jmp    802657 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 40 0c             	mov    0xc(%eax),%eax
  802573:	3b 45 08             	cmp    0x8(%ebp),%eax
  802576:	0f 86 c6 00 00 00    	jbe    802642 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80257c:	a1 48 41 80 00       	mov    0x804148,%eax
  802581:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	8b 55 08             	mov    0x8(%ebp),%edx
  80258a:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 50 08             	mov    0x8(%eax),%edx
  802593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802596:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 0c             	mov    0xc(%eax),%eax
  80259f:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a2:	89 c2                	mov    %eax,%edx
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 50 08             	mov    0x8(%eax),%edx
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	01 c2                	add    %eax,%edx
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025bf:	75 17                	jne    8025d8 <alloc_block_FF+0x117>
  8025c1:	83 ec 04             	sub    $0x4,%esp
  8025c4:	68 85 3d 80 00       	push   $0x803d85
  8025c9:	68 b6 00 00 00       	push   $0xb6
  8025ce:	68 13 3d 80 00       	push   $0x803d13
  8025d3:	e8 86 0c 00 00       	call   80325e <_panic>
  8025d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 10                	je     8025f1 <alloc_block_FF+0x130>
  8025e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e9:	8b 52 04             	mov    0x4(%edx),%edx
  8025ec:	89 50 04             	mov    %edx,0x4(%eax)
  8025ef:	eb 0b                	jmp    8025fc <alloc_block_FF+0x13b>
  8025f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f4:	8b 40 04             	mov    0x4(%eax),%eax
  8025f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 40 04             	mov    0x4(%eax),%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	74 0f                	je     802615 <alloc_block_FF+0x154>
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80260f:	8b 12                	mov    (%edx),%edx
  802611:	89 10                	mov    %edx,(%eax)
  802613:	eb 0a                	jmp    80261f <alloc_block_FF+0x15e>
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	a3 48 41 80 00       	mov    %eax,0x804148
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802632:	a1 54 41 80 00       	mov    0x804154,%eax
  802637:	48                   	dec    %eax
  802638:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802640:	eb 15                	jmp    802657 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	0f 85 80 fe ff ff    	jne    8024d4 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80265f:	a1 38 41 80 00       	mov    0x804138,%eax
  802664:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802667:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80266e:	e9 c0 00 00 00       	jmp    802733 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 0c             	mov    0xc(%eax),%eax
  802679:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267c:	0f 85 8a 00 00 00    	jne    80270c <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802686:	75 17                	jne    80269f <alloc_block_BF+0x46>
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	68 85 3d 80 00       	push   $0x803d85
  802690:	68 cf 00 00 00       	push   $0xcf
  802695:	68 13 3d 80 00       	push   $0x803d13
  80269a:	e8 bf 0b 00 00       	call   80325e <_panic>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 10                	je     8026b8 <alloc_block_BF+0x5f>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b0:	8b 52 04             	mov    0x4(%edx),%edx
  8026b3:	89 50 04             	mov    %edx,0x4(%eax)
  8026b6:	eb 0b                	jmp    8026c3 <alloc_block_BF+0x6a>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 0f                	je     8026dc <alloc_block_BF+0x83>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d6:	8b 12                	mov    (%edx),%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	eb 0a                	jmp    8026e6 <alloc_block_BF+0x8d>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f9:	a1 44 41 80 00       	mov    0x804144,%eax
  8026fe:	48                   	dec    %eax
  8026ff:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	e9 2a 01 00 00       	jmp    802836 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 0c             	mov    0xc(%eax),%eax
  802712:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802715:	73 14                	jae    80272b <alloc_block_BF+0xd2>
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 40 0c             	mov    0xc(%eax),%eax
  80271d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802720:	76 09                	jbe    80272b <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 0c             	mov    0xc(%eax),%eax
  802728:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802737:	0f 85 36 ff ff ff    	jne    802673 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80273d:	a1 38 41 80 00       	mov    0x804138,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802745:	e9 dd 00 00 00       	jmp    802827 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 0c             	mov    0xc(%eax),%eax
  802750:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802753:	0f 85 c6 00 00 00    	jne    80281f <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802759:	a1 48 41 80 00       	mov    0x804148,%eax
  80275e:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 50 08             	mov    0x8(%eax),%edx
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80276d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802770:	8b 55 08             	mov    0x8(%ebp),%edx
  802773:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 50 08             	mov    0x8(%eax),%edx
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	01 c2                	add    %eax,%edx
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 0c             	mov    0xc(%eax),%eax
  80278d:	2b 45 08             	sub    0x8(%ebp),%eax
  802790:	89 c2                	mov    %eax,%edx
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802798:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80279c:	75 17                	jne    8027b5 <alloc_block_BF+0x15c>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 85 3d 80 00       	push   $0x803d85
  8027a6:	68 eb 00 00 00       	push   $0xeb
  8027ab:	68 13 3d 80 00       	push   $0x803d13
  8027b0:	e8 a9 0a 00 00       	call   80325e <_panic>
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	74 10                	je     8027ce <alloc_block_BF+0x175>
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027c6:	8b 52 04             	mov    0x4(%edx),%edx
  8027c9:	89 50 04             	mov    %edx,0x4(%eax)
  8027cc:	eb 0b                	jmp    8027d9 <alloc_block_BF+0x180>
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	8b 40 04             	mov    0x4(%eax),%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	74 0f                	je     8027f2 <alloc_block_BF+0x199>
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ec:	8b 12                	mov    (%edx),%edx
  8027ee:	89 10                	mov    %edx,(%eax)
  8027f0:	eb 0a                	jmp    8027fc <alloc_block_BF+0x1a3>
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	a3 48 41 80 00       	mov    %eax,0x804148
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802808:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280f:	a1 54 41 80 00       	mov    0x804154,%eax
  802814:	48                   	dec    %eax
  802815:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  80281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281d:	eb 17                	jmp    802836 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282b:	0f 85 19 ff ff ff    	jne    80274a <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802831:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80283e:	a1 40 40 80 00       	mov    0x804040,%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	75 19                	jne    802860 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802847:	83 ec 0c             	sub    $0xc,%esp
  80284a:	ff 75 08             	pushl  0x8(%ebp)
  80284d:	e8 6f fc ff ff       	call   8024c1 <alloc_block_FF>
  802852:	83 c4 10             	add    $0x10,%esp
  802855:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	e9 e9 01 00 00       	jmp    802a49 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802860:	a1 44 40 80 00       	mov    0x804044,%eax
  802865:	8b 40 08             	mov    0x8(%eax),%eax
  802868:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80286b:	a1 44 40 80 00       	mov    0x804044,%eax
  802870:	8b 50 0c             	mov    0xc(%eax),%edx
  802873:	a1 44 40 80 00       	mov    0x804044,%eax
  802878:	8b 40 08             	mov    0x8(%eax),%eax
  80287b:	01 d0                	add    %edx,%eax
  80287d:	83 ec 08             	sub    $0x8,%esp
  802880:	50                   	push   %eax
  802881:	68 38 41 80 00       	push   $0x804138
  802886:	e8 54 fa ff ff       	call   8022df <find_block>
  80288b:	83 c4 10             	add    $0x10,%esp
  80288e:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 0c             	mov    0xc(%eax),%eax
  802897:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289a:	0f 85 9b 00 00 00    	jne    80293b <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	01 d0                	add    %edx,%eax
  8028ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8028b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b5:	75 17                	jne    8028ce <alloc_block_NF+0x96>
  8028b7:	83 ec 04             	sub    $0x4,%esp
  8028ba:	68 85 3d 80 00       	push   $0x803d85
  8028bf:	68 1a 01 00 00       	push   $0x11a
  8028c4:	68 13 3d 80 00       	push   $0x803d13
  8028c9:	e8 90 09 00 00       	call   80325e <_panic>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 10                	je     8028e7 <alloc_block_NF+0xaf>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028df:	8b 52 04             	mov    0x4(%edx),%edx
  8028e2:	89 50 04             	mov    %edx,0x4(%eax)
  8028e5:	eb 0b                	jmp    8028f2 <alloc_block_NF+0xba>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	74 0f                	je     80290b <alloc_block_NF+0xd3>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802905:	8b 12                	mov    (%edx),%edx
  802907:	89 10                	mov    %edx,(%eax)
  802909:	eb 0a                	jmp    802915 <alloc_block_NF+0xdd>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	a3 38 41 80 00       	mov    %eax,0x804138
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802928:	a1 44 41 80 00       	mov    0x804144,%eax
  80292d:	48                   	dec    %eax
  80292e:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	e9 0e 01 00 00       	jmp    802a49 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 0c             	mov    0xc(%eax),%eax
  802941:	3b 45 08             	cmp    0x8(%ebp),%eax
  802944:	0f 86 cf 00 00 00    	jbe    802a19 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80294a:	a1 48 41 80 00       	mov    0x804148,%eax
  80294f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 55 08             	mov    0x8(%ebp),%edx
  802958:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	01 c2                	add    %eax,%edx
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 0c             	mov    0xc(%eax),%eax
  80297e:	2b 45 08             	sub    0x8(%ebp),%eax
  802981:	89 c2                	mov    %eax,%edx
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 08             	mov    0x8(%eax),%eax
  80298f:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802992:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802996:	75 17                	jne    8029af <alloc_block_NF+0x177>
  802998:	83 ec 04             	sub    $0x4,%esp
  80299b:	68 85 3d 80 00       	push   $0x803d85
  8029a0:	68 28 01 00 00       	push   $0x128
  8029a5:	68 13 3d 80 00       	push   $0x803d13
  8029aa:	e8 af 08 00 00       	call   80325e <_panic>
  8029af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 10                	je     8029c8 <alloc_block_NF+0x190>
  8029b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c0:	8b 52 04             	mov    0x4(%edx),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%eax)
  8029c6:	eb 0b                	jmp    8029d3 <alloc_block_NF+0x19b>
  8029c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d6:	8b 40 04             	mov    0x4(%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0f                	je     8029ec <alloc_block_NF+0x1b4>
  8029dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e6:	8b 12                	mov    (%edx),%edx
  8029e8:	89 10                	mov    %edx,(%eax)
  8029ea:	eb 0a                	jmp    8029f6 <alloc_block_NF+0x1be>
  8029ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a09:	a1 54 41 80 00       	mov    0x804154,%eax
  802a0e:	48                   	dec    %eax
  802a0f:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	eb 30                	jmp    802a49 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802a19:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a21:	75 0a                	jne    802a2d <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802a23:	a1 38 41 80 00       	mov    0x804138,%eax
  802a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2b:	eb 08                	jmp    802a35 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 08             	mov    0x8(%eax),%eax
  802a3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a3e:	0f 85 4d fe ff ff    	jne    802891 <alloc_block_NF+0x59>

			return NULL;
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	53                   	push   %ebx
  802a4f:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802a52:	a1 38 41 80 00       	mov    0x804138,%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	0f 85 86 00 00 00    	jne    802ae5 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802a5f:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802a66:	00 00 00 
  802a69:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802a70:	00 00 00 
  802a73:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802a7a:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a81:	75 17                	jne    802a9a <insert_sorted_with_merge_freeList+0x4f>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 f0 3c 80 00       	push   $0x803cf0
  802a8b:	68 48 01 00 00       	push   $0x148
  802a90:	68 13 3d 80 00       	push   $0x803d13
  802a95:	e8 c4 07 00 00       	call   80325e <_panic>
  802a9a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	89 10                	mov    %edx,(%eax)
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0d                	je     802abb <insert_sorted_with_merge_freeList+0x70>
  802aae:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab6:	89 50 04             	mov    %edx,0x4(%eax)
  802ab9:	eb 08                	jmp    802ac3 <insert_sorted_with_merge_freeList+0x78>
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	a3 38 41 80 00       	mov    %eax,0x804138
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad5:	a1 44 41 80 00       	mov    0x804144,%eax
  802ada:	40                   	inc    %eax
  802adb:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802ae0:	e9 73 07 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	8b 50 08             	mov    0x8(%eax),%edx
  802aeb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af0:	8b 40 08             	mov    0x8(%eax),%eax
  802af3:	39 c2                	cmp    %eax,%edx
  802af5:	0f 86 84 00 00 00    	jbe    802b7f <insert_sorted_with_merge_freeList+0x134>
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8b 50 08             	mov    0x8(%eax),%edx
  802b01:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b06:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b09:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b0e:	8b 40 08             	mov    0x8(%eax),%eax
  802b11:	01 c8                	add    %ecx,%eax
  802b13:	39 c2                	cmp    %eax,%edx
  802b15:	74 68                	je     802b7f <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802b17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1b:	75 17                	jne    802b34 <insert_sorted_with_merge_freeList+0xe9>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 2c 3d 80 00       	push   $0x803d2c
  802b25:	68 4c 01 00 00       	push   $0x14c
  802b2a:	68 13 3d 80 00       	push   $0x803d13
  802b2f:	e8 2a 07 00 00       	call   80325e <_panic>
  802b34:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0c                	je     802b56 <insert_sorted_with_merge_freeList+0x10b>
  802b4a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b52:	89 10                	mov    %edx,(%eax)
  802b54:	eb 08                	jmp    802b5e <insert_sorted_with_merge_freeList+0x113>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	a3 38 41 80 00       	mov    %eax,0x804138
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b74:	40                   	inc    %eax
  802b75:	a3 44 41 80 00       	mov    %eax,0x804144
  802b7a:	e9 d9 06 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 50 08             	mov    0x8(%eax),%edx
  802b85:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	39 c2                	cmp    %eax,%edx
  802b8f:	0f 86 b5 00 00 00    	jbe    802c4a <insert_sorted_with_merge_freeList+0x1ff>
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba0:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ba3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba8:	8b 40 08             	mov    0x8(%eax),%eax
  802bab:	01 c8                	add    %ecx,%eax
  802bad:	39 c2                	cmp    %eax,%edx
  802baf:	0f 85 95 00 00 00    	jne    802c4a <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802bb5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bba:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bc0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc6:	8b 52 0c             	mov    0xc(%edx),%edx
  802bc9:	01 ca                	add    %ecx,%edx
  802bcb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be6:	75 17                	jne    802bff <insert_sorted_with_merge_freeList+0x1b4>
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	68 f0 3c 80 00       	push   $0x803cf0
  802bf0:	68 54 01 00 00       	push   $0x154
  802bf5:	68 13 3d 80 00       	push   $0x803d13
  802bfa:	e8 5f 06 00 00       	call   80325e <_panic>
  802bff:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	89 10                	mov    %edx,(%eax)
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	85 c0                	test   %eax,%eax
  802c11:	74 0d                	je     802c20 <insert_sorted_with_merge_freeList+0x1d5>
  802c13:	a1 48 41 80 00       	mov    0x804148,%eax
  802c18:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	eb 08                	jmp    802c28 <insert_sorted_with_merge_freeList+0x1dd>
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	a3 48 41 80 00       	mov    %eax,0x804148
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3a:	a1 54 41 80 00       	mov    0x804154,%eax
  802c3f:	40                   	inc    %eax
  802c40:	a3 54 41 80 00       	mov    %eax,0x804154
  802c45:	e9 0e 06 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	8b 50 08             	mov    0x8(%eax),%edx
  802c50:	a1 38 41 80 00       	mov    0x804138,%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	39 c2                	cmp    %eax,%edx
  802c5a:	0f 83 c1 00 00 00    	jae    802d21 <insert_sorted_with_merge_freeList+0x2d6>
  802c60:	a1 38 41 80 00       	mov    0x804138,%eax
  802c65:	8b 50 08             	mov    0x8(%eax),%edx
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 48 08             	mov    0x8(%eax),%ecx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	01 c8                	add    %ecx,%eax
  802c76:	39 c2                	cmp    %eax,%edx
  802c78:	0f 85 a3 00 00 00    	jne    802d21 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c7e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c83:	8b 55 08             	mov    0x8(%ebp),%edx
  802c86:	8b 52 08             	mov    0x8(%edx),%edx
  802c89:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802c8c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c91:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c97:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9d:	8b 52 0c             	mov    0xc(%edx),%edx
  802ca0:	01 ca                	add    %ecx,%edx
  802ca2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbd:	75 17                	jne    802cd6 <insert_sorted_with_merge_freeList+0x28b>
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	68 f0 3c 80 00       	push   $0x803cf0
  802cc7:	68 5d 01 00 00       	push   $0x15d
  802ccc:	68 13 3d 80 00       	push   $0x803d13
  802cd1:	e8 88 05 00 00       	call   80325e <_panic>
  802cd6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	89 10                	mov    %edx,(%eax)
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0d                	je     802cf7 <insert_sorted_with_merge_freeList+0x2ac>
  802cea:	a1 48 41 80 00       	mov    0x804148,%eax
  802cef:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf2:	89 50 04             	mov    %edx,0x4(%eax)
  802cf5:	eb 08                	jmp    802cff <insert_sorted_with_merge_freeList+0x2b4>
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	a3 48 41 80 00       	mov    %eax,0x804148
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d11:	a1 54 41 80 00       	mov    0x804154,%eax
  802d16:	40                   	inc    %eax
  802d17:	a3 54 41 80 00       	mov    %eax,0x804154
  802d1c:	e9 37 05 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	a1 38 41 80 00       	mov    0x804138,%eax
  802d2c:	8b 40 08             	mov    0x8(%eax),%eax
  802d2f:	39 c2                	cmp    %eax,%edx
  802d31:	0f 83 82 00 00 00    	jae    802db9 <insert_sorted_with_merge_freeList+0x36e>
  802d37:	a1 38 41 80 00       	mov    0x804138,%eax
  802d3c:	8b 50 08             	mov    0x8(%eax),%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	8b 48 08             	mov    0x8(%eax),%ecx
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4b:	01 c8                	add    %ecx,%eax
  802d4d:	39 c2                	cmp    %eax,%edx
  802d4f:	74 68                	je     802db9 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d55:	75 17                	jne    802d6e <insert_sorted_with_merge_freeList+0x323>
  802d57:	83 ec 04             	sub    $0x4,%esp
  802d5a:	68 f0 3c 80 00       	push   $0x803cf0
  802d5f:	68 62 01 00 00       	push   $0x162
  802d64:	68 13 3d 80 00       	push   $0x803d13
  802d69:	e8 f0 04 00 00       	call   80325e <_panic>
  802d6e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	89 10                	mov    %edx,(%eax)
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 0d                	je     802d8f <insert_sorted_with_merge_freeList+0x344>
  802d82:	a1 38 41 80 00       	mov    0x804138,%eax
  802d87:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	eb 08                	jmp    802d97 <insert_sorted_with_merge_freeList+0x34c>
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da9:	a1 44 41 80 00       	mov    0x804144,%eax
  802dae:	40                   	inc    %eax
  802daf:	a3 44 41 80 00       	mov    %eax,0x804144
  802db4:	e9 9f 04 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802db9:	a1 38 41 80 00       	mov    0x804138,%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802dc3:	e9 84 04 00 00       	jmp    80324c <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 50 08             	mov    0x8(%eax),%edx
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 40 08             	mov    0x8(%eax),%eax
  802dd4:	39 c2                	cmp    %eax,%edx
  802dd6:	0f 86 a9 00 00 00    	jbe    802e85 <insert_sorted_with_merge_freeList+0x43a>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 50 08             	mov    0x8(%eax),%edx
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 48 08             	mov    0x8(%eax),%ecx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dee:	01 c8                	add    %ecx,%eax
  802df0:	39 c2                	cmp    %eax,%edx
  802df2:	0f 84 8d 00 00 00    	je     802e85 <insert_sorted_with_merge_freeList+0x43a>
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 50 08             	mov    0x8(%eax),%edx
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	8b 48 08             	mov    0x8(%eax),%ecx
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 04             	mov    0x4(%eax),%eax
  802e0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e10:	01 c8                	add    %ecx,%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	74 6f                	je     802e85 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1a:	74 06                	je     802e22 <insert_sorted_with_merge_freeList+0x3d7>
  802e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e20:	75 17                	jne    802e39 <insert_sorted_with_merge_freeList+0x3ee>
  802e22:	83 ec 04             	sub    $0x4,%esp
  802e25:	68 50 3d 80 00       	push   $0x803d50
  802e2a:	68 6b 01 00 00       	push   $0x16b
  802e2f:	68 13 3d 80 00       	push   $0x803d13
  802e34:	e8 25 04 00 00       	call   80325e <_panic>
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 50 04             	mov    0x4(%eax),%edx
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	89 50 04             	mov    %edx,0x4(%eax)
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4b:	89 10                	mov    %edx,(%eax)
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	74 0d                	je     802e64 <insert_sorted_with_merge_freeList+0x419>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	eb 08                	jmp    802e6c <insert_sorted_with_merge_freeList+0x421>
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 38 41 80 00       	mov    %eax,0x804138
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e72:	89 50 04             	mov    %edx,0x4(%eax)
  802e75:	a1 44 41 80 00       	mov    0x804144,%eax
  802e7a:	40                   	inc    %eax
  802e7b:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802e80:	e9 d3 03 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 50 08             	mov    0x8(%eax),%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 40 08             	mov    0x8(%eax),%eax
  802e91:	39 c2                	cmp    %eax,%edx
  802e93:	0f 86 da 00 00 00    	jbe    802f73 <insert_sorted_with_merge_freeList+0x528>
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 50 08             	mov    0x8(%eax),%edx
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	01 c8                	add    %ecx,%eax
  802ead:	39 c2                	cmp    %eax,%edx
  802eaf:	0f 85 be 00 00 00    	jne    802f73 <insert_sorted_with_merge_freeList+0x528>
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 50 08             	mov    0x8(%eax),%edx
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecd:	01 c8                	add    %ecx,%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	0f 84 9c 00 00 00    	je     802f73 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 50 08             	mov    0x8(%eax),%edx
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 40 0c             	mov    0xc(%eax),%eax
  802eef:	01 c2                	add    %eax,%edx
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0f:	75 17                	jne    802f28 <insert_sorted_with_merge_freeList+0x4dd>
  802f11:	83 ec 04             	sub    $0x4,%esp
  802f14:	68 f0 3c 80 00       	push   $0x803cf0
  802f19:	68 74 01 00 00       	push   $0x174
  802f1e:	68 13 3d 80 00       	push   $0x803d13
  802f23:	e8 36 03 00 00       	call   80325e <_panic>
  802f28:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	89 10                	mov    %edx,(%eax)
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0d                	je     802f49 <insert_sorted_with_merge_freeList+0x4fe>
  802f3c:	a1 48 41 80 00       	mov    0x804148,%eax
  802f41:	8b 55 08             	mov    0x8(%ebp),%edx
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	eb 08                	jmp    802f51 <insert_sorted_with_merge_freeList+0x506>
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	a3 48 41 80 00       	mov    %eax,0x804148
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f63:	a1 54 41 80 00       	mov    0x804154,%eax
  802f68:	40                   	inc    %eax
  802f69:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f6e:	e9 e5 02 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	0f 86 d7 00 00 00    	jbe    80305e <insert_sorted_with_merge_freeList+0x613>
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 50 08             	mov    0x8(%eax),%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 48 08             	mov    0x8(%eax),%ecx
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 40 0c             	mov    0xc(%eax),%eax
  802f99:	01 c8                	add    %ecx,%eax
  802f9b:	39 c2                	cmp    %eax,%edx
  802f9d:	0f 84 bb 00 00 00    	je     80305e <insert_sorted_with_merge_freeList+0x613>
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 50 08             	mov    0x8(%eax),%edx
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 04             	mov    0x4(%eax),%eax
  802faf:	8b 48 08             	mov    0x8(%eax),%ecx
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbb:	01 c8                	add    %ecx,%eax
  802fbd:	39 c2                	cmp    %eax,%edx
  802fbf:	0f 85 99 00 00 00    	jne    80305e <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 40 04             	mov    0x4(%eax),%eax
  802fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	01 c2                	add    %eax,%edx
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ff6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffa:	75 17                	jne    803013 <insert_sorted_with_merge_freeList+0x5c8>
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 f0 3c 80 00       	push   $0x803cf0
  803004:	68 7d 01 00 00       	push   $0x17d
  803009:	68 13 3d 80 00       	push   $0x803d13
  80300e:	e8 4b 02 00 00       	call   80325e <_panic>
  803013:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	89 10                	mov    %edx,(%eax)
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	74 0d                	je     803034 <insert_sorted_with_merge_freeList+0x5e9>
  803027:	a1 48 41 80 00       	mov    0x804148,%eax
  80302c:	8b 55 08             	mov    0x8(%ebp),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	eb 08                	jmp    80303c <insert_sorted_with_merge_freeList+0x5f1>
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	a3 48 41 80 00       	mov    %eax,0x804148
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304e:	a1 54 41 80 00       	mov    0x804154,%eax
  803053:	40                   	inc    %eax
  803054:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  803059:	e9 fa 01 00 00       	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 50 08             	mov    0x8(%eax),%edx
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	8b 40 08             	mov    0x8(%eax),%eax
  80306a:	39 c2                	cmp    %eax,%edx
  80306c:	0f 86 d2 01 00 00    	jbe    803244 <insert_sorted_with_merge_freeList+0x7f9>
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 50 08             	mov    0x8(%eax),%edx
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	8b 48 08             	mov    0x8(%eax),%ecx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	8b 40 0c             	mov    0xc(%eax),%eax
  803084:	01 c8                	add    %ecx,%eax
  803086:	39 c2                	cmp    %eax,%edx
  803088:	0f 85 b6 01 00 00    	jne    803244 <insert_sorted_with_merge_freeList+0x7f9>
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	8b 48 08             	mov    0x8(%eax),%ecx
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a6:	01 c8                	add    %ecx,%eax
  8030a8:	39 c2                	cmp    %eax,%edx
  8030aa:	0f 85 94 01 00 00    	jne    803244 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b9:	8b 52 04             	mov    0x4(%edx),%edx
  8030bc:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c2:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8030c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8030cb:	01 da                	add    %ebx,%edx
  8030cd:	01 ca                	add    %ecx,%edx
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8030e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ea:	75 17                	jne    803103 <insert_sorted_with_merge_freeList+0x6b8>
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 85 3d 80 00       	push   $0x803d85
  8030f4:	68 86 01 00 00       	push   $0x186
  8030f9:	68 13 3d 80 00       	push   $0x803d13
  8030fe:	e8 5b 01 00 00       	call   80325e <_panic>
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	74 10                	je     80311c <insert_sorted_with_merge_freeList+0x6d1>
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803114:	8b 52 04             	mov    0x4(%edx),%edx
  803117:	89 50 04             	mov    %edx,0x4(%eax)
  80311a:	eb 0b                	jmp    803127 <insert_sorted_with_merge_freeList+0x6dc>
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	8b 40 04             	mov    0x4(%eax),%eax
  803122:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 40 04             	mov    0x4(%eax),%eax
  80312d:	85 c0                	test   %eax,%eax
  80312f:	74 0f                	je     803140 <insert_sorted_with_merge_freeList+0x6f5>
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313a:	8b 12                	mov    (%edx),%edx
  80313c:	89 10                	mov    %edx,(%eax)
  80313e:	eb 0a                	jmp    80314a <insert_sorted_with_merge_freeList+0x6ff>
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	a3 38 41 80 00       	mov    %eax,0x804138
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315d:	a1 44 41 80 00       	mov    0x804144,%eax
  803162:	48                   	dec    %eax
  803163:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316c:	75 17                	jne    803185 <insert_sorted_with_merge_freeList+0x73a>
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	68 f0 3c 80 00       	push   $0x803cf0
  803176:	68 87 01 00 00       	push   $0x187
  80317b:	68 13 3d 80 00       	push   $0x803d13
  803180:	e8 d9 00 00 00       	call   80325e <_panic>
  803185:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 0d                	je     8031a6 <insert_sorted_with_merge_freeList+0x75b>
  803199:	a1 48 41 80 00       	mov    0x804148,%eax
  80319e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a1:	89 50 04             	mov    %edx,0x4(%eax)
  8031a4:	eb 08                	jmp    8031ae <insert_sorted_with_merge_freeList+0x763>
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	a3 48 41 80 00       	mov    %eax,0x804148
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c0:	a1 54 41 80 00       	mov    0x804154,%eax
  8031c5:	40                   	inc    %eax
  8031c6:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e3:	75 17                	jne    8031fc <insert_sorted_with_merge_freeList+0x7b1>
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	68 f0 3c 80 00       	push   $0x803cf0
  8031ed:	68 8a 01 00 00       	push   $0x18a
  8031f2:	68 13 3d 80 00       	push   $0x803d13
  8031f7:	e8 62 00 00 00       	call   80325e <_panic>
  8031fc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	89 10                	mov    %edx,(%eax)
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 0d                	je     80321d <insert_sorted_with_merge_freeList+0x7d2>
  803210:	a1 48 41 80 00       	mov    0x804148,%eax
  803215:	8b 55 08             	mov    0x8(%ebp),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	eb 08                	jmp    803225 <insert_sorted_with_merge_freeList+0x7da>
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	a3 48 41 80 00       	mov    %eax,0x804148
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803237:	a1 54 41 80 00       	mov    0x804154,%eax
  80323c:	40                   	inc    %eax
  80323d:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803242:	eb 14                	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80324c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803250:	0f 85 72 fb ff ff    	jne    802dc8 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803256:	eb 00                	jmp    803258 <insert_sorted_with_merge_freeList+0x80d>
  803258:	90                   	nop
  803259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
  803261:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803264:	8d 45 10             	lea    0x10(%ebp),%eax
  803267:	83 c0 04             	add    $0x4,%eax
  80326a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80326d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	74 16                	je     80328c <_panic+0x2e>
		cprintf("%s: ", argv0);
  803276:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80327b:	83 ec 08             	sub    $0x8,%esp
  80327e:	50                   	push   %eax
  80327f:	68 a4 3d 80 00       	push   $0x803da4
  803284:	e8 b4 d4 ff ff       	call   80073d <cprintf>
  803289:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80328c:	a1 00 40 80 00       	mov    0x804000,%eax
  803291:	ff 75 0c             	pushl  0xc(%ebp)
  803294:	ff 75 08             	pushl  0x8(%ebp)
  803297:	50                   	push   %eax
  803298:	68 a9 3d 80 00       	push   $0x803da9
  80329d:	e8 9b d4 ff ff       	call   80073d <cprintf>
  8032a2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8032a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8032a8:	83 ec 08             	sub    $0x8,%esp
  8032ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ae:	50                   	push   %eax
  8032af:	e8 1e d4 ff ff       	call   8006d2 <vcprintf>
  8032b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8032b7:	83 ec 08             	sub    $0x8,%esp
  8032ba:	6a 00                	push   $0x0
  8032bc:	68 c5 3d 80 00       	push   $0x803dc5
  8032c1:	e8 0c d4 ff ff       	call   8006d2 <vcprintf>
  8032c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8032c9:	e8 8d d3 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  8032ce:	eb fe                	jmp    8032ce <_panic+0x70>

008032d0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8032db:	8b 50 74             	mov    0x74(%eax),%edx
  8032de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e1:	39 c2                	cmp    %eax,%edx
  8032e3:	74 14                	je     8032f9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	68 c8 3d 80 00       	push   $0x803dc8
  8032ed:	6a 26                	push   $0x26
  8032ef:	68 14 3e 80 00       	push   $0x803e14
  8032f4:	e8 65 ff ff ff       	call   80325e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803307:	e9 c2 00 00 00       	jmp    8033ce <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80330c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	01 d0                	add    %edx,%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	85 c0                	test   %eax,%eax
  80331f:	75 08                	jne    803329 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803321:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803324:	e9 a2 00 00 00       	jmp    8033cb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803329:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803330:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803337:	eb 69                	jmp    8033a2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803339:	a1 20 40 80 00       	mov    0x804020,%eax
  80333e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803344:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803347:	89 d0                	mov    %edx,%eax
  803349:	01 c0                	add    %eax,%eax
  80334b:	01 d0                	add    %edx,%eax
  80334d:	c1 e0 03             	shl    $0x3,%eax
  803350:	01 c8                	add    %ecx,%eax
  803352:	8a 40 04             	mov    0x4(%eax),%al
  803355:	84 c0                	test   %al,%al
  803357:	75 46                	jne    80339f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803359:	a1 20 40 80 00       	mov    0x804020,%eax
  80335e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803364:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803367:	89 d0                	mov    %edx,%eax
  803369:	01 c0                	add    %eax,%eax
  80336b:	01 d0                	add    %edx,%eax
  80336d:	c1 e0 03             	shl    $0x3,%eax
  803370:	01 c8                	add    %ecx,%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803377:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80337a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80337f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803384:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	01 c8                	add    %ecx,%eax
  803390:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803392:	39 c2                	cmp    %eax,%edx
  803394:	75 09                	jne    80339f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803396:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80339d:	eb 12                	jmp    8033b1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80339f:	ff 45 e8             	incl   -0x18(%ebp)
  8033a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8033a7:	8b 50 74             	mov    0x74(%eax),%edx
  8033aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ad:	39 c2                	cmp    %eax,%edx
  8033af:	77 88                	ja     803339 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8033b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033b5:	75 14                	jne    8033cb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8033b7:	83 ec 04             	sub    $0x4,%esp
  8033ba:	68 20 3e 80 00       	push   $0x803e20
  8033bf:	6a 3a                	push   $0x3a
  8033c1:	68 14 3e 80 00       	push   $0x803e14
  8033c6:	e8 93 fe ff ff       	call   80325e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8033cb:	ff 45 f0             	incl   -0x10(%ebp)
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033d4:	0f 8c 32 ff ff ff    	jl     80330c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033e8:	eb 26                	jmp    803410 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8033ef:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033f8:	89 d0                	mov    %edx,%eax
  8033fa:	01 c0                	add    %eax,%eax
  8033fc:	01 d0                	add    %edx,%eax
  8033fe:	c1 e0 03             	shl    $0x3,%eax
  803401:	01 c8                	add    %ecx,%eax
  803403:	8a 40 04             	mov    0x4(%eax),%al
  803406:	3c 01                	cmp    $0x1,%al
  803408:	75 03                	jne    80340d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80340a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80340d:	ff 45 e0             	incl   -0x20(%ebp)
  803410:	a1 20 40 80 00       	mov    0x804020,%eax
  803415:	8b 50 74             	mov    0x74(%eax),%edx
  803418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80341b:	39 c2                	cmp    %eax,%edx
  80341d:	77 cb                	ja     8033ea <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803425:	74 14                	je     80343b <CheckWSWithoutLastIndex+0x16b>
		panic(
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 74 3e 80 00       	push   $0x803e74
  80342f:	6a 44                	push   $0x44
  803431:	68 14 3e 80 00       	push   $0x803e14
  803436:	e8 23 fe ff ff       	call   80325e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80343b:	90                   	nop
  80343c:	c9                   	leave  
  80343d:	c3                   	ret    
  80343e:	66 90                	xchg   %ax,%ax

00803440 <__udivdi3>:
  803440:	55                   	push   %ebp
  803441:	57                   	push   %edi
  803442:	56                   	push   %esi
  803443:	53                   	push   %ebx
  803444:	83 ec 1c             	sub    $0x1c,%esp
  803447:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80344b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80344f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803453:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803457:	89 ca                	mov    %ecx,%edx
  803459:	89 f8                	mov    %edi,%eax
  80345b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80345f:	85 f6                	test   %esi,%esi
  803461:	75 2d                	jne    803490 <__udivdi3+0x50>
  803463:	39 cf                	cmp    %ecx,%edi
  803465:	77 65                	ja     8034cc <__udivdi3+0x8c>
  803467:	89 fd                	mov    %edi,%ebp
  803469:	85 ff                	test   %edi,%edi
  80346b:	75 0b                	jne    803478 <__udivdi3+0x38>
  80346d:	b8 01 00 00 00       	mov    $0x1,%eax
  803472:	31 d2                	xor    %edx,%edx
  803474:	f7 f7                	div    %edi
  803476:	89 c5                	mov    %eax,%ebp
  803478:	31 d2                	xor    %edx,%edx
  80347a:	89 c8                	mov    %ecx,%eax
  80347c:	f7 f5                	div    %ebp
  80347e:	89 c1                	mov    %eax,%ecx
  803480:	89 d8                	mov    %ebx,%eax
  803482:	f7 f5                	div    %ebp
  803484:	89 cf                	mov    %ecx,%edi
  803486:	89 fa                	mov    %edi,%edx
  803488:	83 c4 1c             	add    $0x1c,%esp
  80348b:	5b                   	pop    %ebx
  80348c:	5e                   	pop    %esi
  80348d:	5f                   	pop    %edi
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    
  803490:	39 ce                	cmp    %ecx,%esi
  803492:	77 28                	ja     8034bc <__udivdi3+0x7c>
  803494:	0f bd fe             	bsr    %esi,%edi
  803497:	83 f7 1f             	xor    $0x1f,%edi
  80349a:	75 40                	jne    8034dc <__udivdi3+0x9c>
  80349c:	39 ce                	cmp    %ecx,%esi
  80349e:	72 0a                	jb     8034aa <__udivdi3+0x6a>
  8034a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034a4:	0f 87 9e 00 00 00    	ja     803548 <__udivdi3+0x108>
  8034aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034af:	89 fa                	mov    %edi,%edx
  8034b1:	83 c4 1c             	add    $0x1c,%esp
  8034b4:	5b                   	pop    %ebx
  8034b5:	5e                   	pop    %esi
  8034b6:	5f                   	pop    %edi
  8034b7:	5d                   	pop    %ebp
  8034b8:	c3                   	ret    
  8034b9:	8d 76 00             	lea    0x0(%esi),%esi
  8034bc:	31 ff                	xor    %edi,%edi
  8034be:	31 c0                	xor    %eax,%eax
  8034c0:	89 fa                	mov    %edi,%edx
  8034c2:	83 c4 1c             	add    $0x1c,%esp
  8034c5:	5b                   	pop    %ebx
  8034c6:	5e                   	pop    %esi
  8034c7:	5f                   	pop    %edi
  8034c8:	5d                   	pop    %ebp
  8034c9:	c3                   	ret    
  8034ca:	66 90                	xchg   %ax,%ax
  8034cc:	89 d8                	mov    %ebx,%eax
  8034ce:	f7 f7                	div    %edi
  8034d0:	31 ff                	xor    %edi,%edi
  8034d2:	89 fa                	mov    %edi,%edx
  8034d4:	83 c4 1c             	add    $0x1c,%esp
  8034d7:	5b                   	pop    %ebx
  8034d8:	5e                   	pop    %esi
  8034d9:	5f                   	pop    %edi
  8034da:	5d                   	pop    %ebp
  8034db:	c3                   	ret    
  8034dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e1:	89 eb                	mov    %ebp,%ebx
  8034e3:	29 fb                	sub    %edi,%ebx
  8034e5:	89 f9                	mov    %edi,%ecx
  8034e7:	d3 e6                	shl    %cl,%esi
  8034e9:	89 c5                	mov    %eax,%ebp
  8034eb:	88 d9                	mov    %bl,%cl
  8034ed:	d3 ed                	shr    %cl,%ebp
  8034ef:	89 e9                	mov    %ebp,%ecx
  8034f1:	09 f1                	or     %esi,%ecx
  8034f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034f7:	89 f9                	mov    %edi,%ecx
  8034f9:	d3 e0                	shl    %cl,%eax
  8034fb:	89 c5                	mov    %eax,%ebp
  8034fd:	89 d6                	mov    %edx,%esi
  8034ff:	88 d9                	mov    %bl,%cl
  803501:	d3 ee                	shr    %cl,%esi
  803503:	89 f9                	mov    %edi,%ecx
  803505:	d3 e2                	shl    %cl,%edx
  803507:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350b:	88 d9                	mov    %bl,%cl
  80350d:	d3 e8                	shr    %cl,%eax
  80350f:	09 c2                	or     %eax,%edx
  803511:	89 d0                	mov    %edx,%eax
  803513:	89 f2                	mov    %esi,%edx
  803515:	f7 74 24 0c          	divl   0xc(%esp)
  803519:	89 d6                	mov    %edx,%esi
  80351b:	89 c3                	mov    %eax,%ebx
  80351d:	f7 e5                	mul    %ebp
  80351f:	39 d6                	cmp    %edx,%esi
  803521:	72 19                	jb     80353c <__udivdi3+0xfc>
  803523:	74 0b                	je     803530 <__udivdi3+0xf0>
  803525:	89 d8                	mov    %ebx,%eax
  803527:	31 ff                	xor    %edi,%edi
  803529:	e9 58 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  80352e:	66 90                	xchg   %ax,%ax
  803530:	8b 54 24 08          	mov    0x8(%esp),%edx
  803534:	89 f9                	mov    %edi,%ecx
  803536:	d3 e2                	shl    %cl,%edx
  803538:	39 c2                	cmp    %eax,%edx
  80353a:	73 e9                	jae    803525 <__udivdi3+0xe5>
  80353c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80353f:	31 ff                	xor    %edi,%edi
  803541:	e9 40 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  803546:	66 90                	xchg   %ax,%ax
  803548:	31 c0                	xor    %eax,%eax
  80354a:	e9 37 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  80354f:	90                   	nop

00803550 <__umoddi3>:
  803550:	55                   	push   %ebp
  803551:	57                   	push   %edi
  803552:	56                   	push   %esi
  803553:	53                   	push   %ebx
  803554:	83 ec 1c             	sub    $0x1c,%esp
  803557:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80355b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80355f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803563:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803567:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80356b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80356f:	89 f3                	mov    %esi,%ebx
  803571:	89 fa                	mov    %edi,%edx
  803573:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803577:	89 34 24             	mov    %esi,(%esp)
  80357a:	85 c0                	test   %eax,%eax
  80357c:	75 1a                	jne    803598 <__umoddi3+0x48>
  80357e:	39 f7                	cmp    %esi,%edi
  803580:	0f 86 a2 00 00 00    	jbe    803628 <__umoddi3+0xd8>
  803586:	89 c8                	mov    %ecx,%eax
  803588:	89 f2                	mov    %esi,%edx
  80358a:	f7 f7                	div    %edi
  80358c:	89 d0                	mov    %edx,%eax
  80358e:	31 d2                	xor    %edx,%edx
  803590:	83 c4 1c             	add    $0x1c,%esp
  803593:	5b                   	pop    %ebx
  803594:	5e                   	pop    %esi
  803595:	5f                   	pop    %edi
  803596:	5d                   	pop    %ebp
  803597:	c3                   	ret    
  803598:	39 f0                	cmp    %esi,%eax
  80359a:	0f 87 ac 00 00 00    	ja     80364c <__umoddi3+0xfc>
  8035a0:	0f bd e8             	bsr    %eax,%ebp
  8035a3:	83 f5 1f             	xor    $0x1f,%ebp
  8035a6:	0f 84 ac 00 00 00    	je     803658 <__umoddi3+0x108>
  8035ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b1:	29 ef                	sub    %ebp,%edi
  8035b3:	89 fe                	mov    %edi,%esi
  8035b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035b9:	89 e9                	mov    %ebp,%ecx
  8035bb:	d3 e0                	shl    %cl,%eax
  8035bd:	89 d7                	mov    %edx,%edi
  8035bf:	89 f1                	mov    %esi,%ecx
  8035c1:	d3 ef                	shr    %cl,%edi
  8035c3:	09 c7                	or     %eax,%edi
  8035c5:	89 e9                	mov    %ebp,%ecx
  8035c7:	d3 e2                	shl    %cl,%edx
  8035c9:	89 14 24             	mov    %edx,(%esp)
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	d3 e0                	shl    %cl,%eax
  8035d0:	89 c2                	mov    %eax,%edx
  8035d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d6:	d3 e0                	shl    %cl,%eax
  8035d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e0:	89 f1                	mov    %esi,%ecx
  8035e2:	d3 e8                	shr    %cl,%eax
  8035e4:	09 d0                	or     %edx,%eax
  8035e6:	d3 eb                	shr    %cl,%ebx
  8035e8:	89 da                	mov    %ebx,%edx
  8035ea:	f7 f7                	div    %edi
  8035ec:	89 d3                	mov    %edx,%ebx
  8035ee:	f7 24 24             	mull   (%esp)
  8035f1:	89 c6                	mov    %eax,%esi
  8035f3:	89 d1                	mov    %edx,%ecx
  8035f5:	39 d3                	cmp    %edx,%ebx
  8035f7:	0f 82 87 00 00 00    	jb     803684 <__umoddi3+0x134>
  8035fd:	0f 84 91 00 00 00    	je     803694 <__umoddi3+0x144>
  803603:	8b 54 24 04          	mov    0x4(%esp),%edx
  803607:	29 f2                	sub    %esi,%edx
  803609:	19 cb                	sbb    %ecx,%ebx
  80360b:	89 d8                	mov    %ebx,%eax
  80360d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803611:	d3 e0                	shl    %cl,%eax
  803613:	89 e9                	mov    %ebp,%ecx
  803615:	d3 ea                	shr    %cl,%edx
  803617:	09 d0                	or     %edx,%eax
  803619:	89 e9                	mov    %ebp,%ecx
  80361b:	d3 eb                	shr    %cl,%ebx
  80361d:	89 da                	mov    %ebx,%edx
  80361f:	83 c4 1c             	add    $0x1c,%esp
  803622:	5b                   	pop    %ebx
  803623:	5e                   	pop    %esi
  803624:	5f                   	pop    %edi
  803625:	5d                   	pop    %ebp
  803626:	c3                   	ret    
  803627:	90                   	nop
  803628:	89 fd                	mov    %edi,%ebp
  80362a:	85 ff                	test   %edi,%edi
  80362c:	75 0b                	jne    803639 <__umoddi3+0xe9>
  80362e:	b8 01 00 00 00       	mov    $0x1,%eax
  803633:	31 d2                	xor    %edx,%edx
  803635:	f7 f7                	div    %edi
  803637:	89 c5                	mov    %eax,%ebp
  803639:	89 f0                	mov    %esi,%eax
  80363b:	31 d2                	xor    %edx,%edx
  80363d:	f7 f5                	div    %ebp
  80363f:	89 c8                	mov    %ecx,%eax
  803641:	f7 f5                	div    %ebp
  803643:	89 d0                	mov    %edx,%eax
  803645:	e9 44 ff ff ff       	jmp    80358e <__umoddi3+0x3e>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	89 c8                	mov    %ecx,%eax
  80364e:	89 f2                	mov    %esi,%edx
  803650:	83 c4 1c             	add    $0x1c,%esp
  803653:	5b                   	pop    %ebx
  803654:	5e                   	pop    %esi
  803655:	5f                   	pop    %edi
  803656:	5d                   	pop    %ebp
  803657:	c3                   	ret    
  803658:	3b 04 24             	cmp    (%esp),%eax
  80365b:	72 06                	jb     803663 <__umoddi3+0x113>
  80365d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803661:	77 0f                	ja     803672 <__umoddi3+0x122>
  803663:	89 f2                	mov    %esi,%edx
  803665:	29 f9                	sub    %edi,%ecx
  803667:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80366b:	89 14 24             	mov    %edx,(%esp)
  80366e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803672:	8b 44 24 04          	mov    0x4(%esp),%eax
  803676:	8b 14 24             	mov    (%esp),%edx
  803679:	83 c4 1c             	add    $0x1c,%esp
  80367c:	5b                   	pop    %ebx
  80367d:	5e                   	pop    %esi
  80367e:	5f                   	pop    %edi
  80367f:	5d                   	pop    %ebp
  803680:	c3                   	ret    
  803681:	8d 76 00             	lea    0x0(%esi),%esi
  803684:	2b 04 24             	sub    (%esp),%eax
  803687:	19 fa                	sbb    %edi,%edx
  803689:	89 d1                	mov    %edx,%ecx
  80368b:	89 c6                	mov    %eax,%esi
  80368d:	e9 71 ff ff ff       	jmp    803603 <__umoddi3+0xb3>
  803692:	66 90                	xchg   %ax,%ax
  803694:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803698:	72 ea                	jb     803684 <__umoddi3+0x134>
  80369a:	89 d9                	mov    %ebx,%ecx
  80369c:	e9 62 ff ff ff       	jmp    803603 <__umoddi3+0xb3>
