
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 40 80 00       	mov    0x804020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 40 35 80 00       	push   $0x803540
  800095:	6a 1a                	push   $0x1a
  800097:	68 5c 35 80 00       	push   $0x80355c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 4b 16 00 00       	call   8016f6 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 f3 15 00 00       	call   8016f6 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 af 15 00 00       	call   8016f6 <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 61 15 00 00       	call   8016f6 <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 11 15 00 00       	call   8016f6 <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 70 35 80 00       	push   $0x803570
  800287:	6a 45                	push   $0x45
  800289:	68 5c 35 80 00       	push   $0x80355c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 70 35 80 00       	push   $0x803570
  8002bc:	6a 46                	push   $0x46
  8002be:	68 5c 35 80 00       	push   $0x80355c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 70 35 80 00       	push   $0x803570
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 5c 35 80 00       	push   $0x80355c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 70 35 80 00       	push   $0x803570
  800324:	6a 49                	push   $0x49
  800326:	68 5c 35 80 00       	push   $0x80355c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 70 35 80 00       	push   $0x803570
  80035e:	6a 4a                	push   $0x4a
  800360:	68 5c 35 80 00       	push   $0x80355c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 70 35 80 00       	push   $0x803570
  800394:	6a 4b                	push   $0x4b
  800396:	68 5c 35 80 00       	push   $0x80355c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 a8 35 80 00       	push   $0x8035a8
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 79 1a 00 00       	call   801e3a <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 1b 18 00 00       	call   801c47 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 fc 35 80 00       	push   $0x8035fc
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 40 80 00       	mov    0x804020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 24 36 80 00       	push   $0x803624
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 40 80 00       	mov    0x804020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 40 80 00       	mov    0x804020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 4c 36 80 00       	push   $0x80364c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 40 80 00       	mov    0x804020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 a4 36 80 00       	push   $0x8036a4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 fc 35 80 00       	push   $0x8035fc
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 9b 17 00 00       	call   801c61 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 28 19 00 00       	call   801e06 <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 7d 19 00 00       	call   801e6c <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 b8 36 80 00       	push   $0x8036b8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 40 80 00       	mov    0x804000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 bd 36 80 00       	push   $0x8036bd
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 d9 36 80 00       	push   $0x8036d9
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 40 80 00       	mov    0x804020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 dc 36 80 00       	push   $0x8036dc
  800581:	6a 26                	push   $0x26
  800583:	68 28 37 80 00       	push   $0x803728
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 34 37 80 00       	push   $0x803734
  800653:	6a 3a                	push   $0x3a
  800655:	68 28 37 80 00       	push   $0x803728
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 40 80 00       	mov    0x804020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 88 37 80 00       	push   $0x803788
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 28 37 80 00       	push   $0x803728
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 40 80 00       	mov    0x804024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 7c 13 00 00       	call   801a99 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 40 80 00       	mov    0x804024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 05 13 00 00       	call   801a99 <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 69 14 00 00       	call   801c47 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 63 14 00 00       	call   801c61 <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 80 2a 00 00       	call   8032c8 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 40 2b 00 00       	call   8033d8 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 f4 39 80 00       	add    $0x8039f4,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 18 3a 80 00 	mov    0x803a18(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 60 38 80 00 	mov    0x803860(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 05 3a 80 00       	push   $0x803a05
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 0e 3a 80 00       	push   $0x803a0e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 11 3a 80 00       	mov    $0x803a11,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 40 80 00       	mov    0x804004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 70 3b 80 00       	push   $0x803b70
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801567:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80156e:	00 00 00 
  801571:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801578:	00 00 00 
  80157b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801582:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801585:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80158c:	00 00 00 
  80158f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801596:	00 00 00 
  801599:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8015a0:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8015a3:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8015aa:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8015ad:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8015b4:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c8:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8015cd:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8015d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015dc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	6a 06                	push   $0x6
  8015e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e9:	50                   	push   %eax
  8015ea:	e8 ee 05 00 00       	call   801bdd <sys_allocate_chunk>
  8015ef:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015f2:	a1 20 41 80 00       	mov    0x804120,%eax
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	50                   	push   %eax
  8015fb:	e8 63 0c 00 00       	call   802263 <initialize_MemBlocksList>
  801600:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801603:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801608:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80160b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80160e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801618:	8b 40 0c             	mov    0xc(%eax),%eax
  80161b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80161e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801621:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801626:	89 c2                	mov    %eax,%edx
  801628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162b:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80162e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801631:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801638:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80163f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801642:	8b 50 08             	mov    0x8(%eax),%edx
  801645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801648:	01 d0                	add    %edx,%eax
  80164a:	48                   	dec    %eax
  80164b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80164e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	f7 75 e0             	divl   -0x20(%ebp)
  801659:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80165c:	29 d0                	sub    %edx,%eax
  80165e:	89 c2                	mov    %eax,%edx
  801660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801663:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801666:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80166a:	75 14                	jne    801680 <initialize_dyn_block_system+0x11f>
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	68 95 3b 80 00       	push   $0x803b95
  801674:	6a 34                	push   $0x34
  801676:	68 b3 3b 80 00       	push   $0x803bb3
  80167b:	e8 72 ee ff ff       	call   8004f2 <_panic>
  801680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	85 c0                	test   %eax,%eax
  801687:	74 10                	je     801699 <initialize_dyn_block_system+0x138>
  801689:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801691:	8b 52 04             	mov    0x4(%edx),%edx
  801694:	89 50 04             	mov    %edx,0x4(%eax)
  801697:	eb 0b                	jmp    8016a4 <initialize_dyn_block_system+0x143>
  801699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169c:	8b 40 04             	mov    0x4(%eax),%eax
  80169f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8016a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a7:	8b 40 04             	mov    0x4(%eax),%eax
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	74 0f                	je     8016bd <initialize_dyn_block_system+0x15c>
  8016ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b1:	8b 40 04             	mov    0x4(%eax),%eax
  8016b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016b7:	8b 12                	mov    (%edx),%edx
  8016b9:	89 10                	mov    %edx,(%eax)
  8016bb:	eb 0a                	jmp    8016c7 <initialize_dyn_block_system+0x166>
  8016bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c0:	8b 00                	mov    (%eax),%eax
  8016c2:	a3 48 41 80 00       	mov    %eax,0x804148
  8016c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016da:	a1 54 41 80 00       	mov    0x804154,%eax
  8016df:	48                   	dec    %eax
  8016e0:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8016eb:	e8 c4 13 00 00       	call   802ab4 <insert_sorted_with_merge_freeList>
  8016f0:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016f3:	90                   	nop
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fc:	e8 2f fe ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801701:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801705:	75 07                	jne    80170e <malloc+0x18>
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	eb 71                	jmp    80177f <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80170e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801715:	76 07                	jbe    80171e <malloc+0x28>
	return NULL;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	eb 61                	jmp    80177f <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80171e:	e8 88 08 00 00       	call   801fab <sys_isUHeapPlacementStrategyFIRSTFIT>
  801723:	85 c0                	test   %eax,%eax
  801725:	74 53                	je     80177a <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801727:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80172e:	8b 55 08             	mov    0x8(%ebp),%edx
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	01 d0                	add    %edx,%eax
  801736:	48                   	dec    %eax
  801737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	ba 00 00 00 00       	mov    $0x0,%edx
  801742:	f7 75 f4             	divl   -0xc(%ebp)
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	29 d0                	sub    %edx,%eax
  80174a:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	ff 75 ec             	pushl  -0x14(%ebp)
  801753:	e8 d2 0d 00 00       	call   80252a <alloc_block_FF>
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80175e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801762:	74 16                	je     80177a <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801764:	83 ec 0c             	sub    $0xc,%esp
  801767:	ff 75 e8             	pushl  -0x18(%ebp)
  80176a:	e8 0c 0c 00 00       	call   80237b <insert_sorted_allocList>
  80176f:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801772:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801775:	8b 40 08             	mov    0x8(%eax),%eax
  801778:	eb 05                	jmp    80177f <malloc+0x89>
    }

			}


	return NULL;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801790:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801795:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	ff 75 f0             	pushl  -0x10(%ebp)
  80179e:	68 40 40 80 00       	push   $0x804040
  8017a3:	e8 a0 0b 00 00       	call   802348 <find_block>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8017ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	83 ec 08             	sub    $0x8,%esp
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	e8 e4 03 00 00       	call   801ba5 <sys_free_user_mem>
  8017c1:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8017c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c8:	75 17                	jne    8017e1 <free+0x60>
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	68 95 3b 80 00       	push   $0x803b95
  8017d2:	68 84 00 00 00       	push   $0x84
  8017d7:	68 b3 3b 80 00       	push   $0x803bb3
  8017dc:	e8 11 ed ff ff       	call   8004f2 <_panic>
  8017e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e4:	8b 00                	mov    (%eax),%eax
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	74 10                	je     8017fa <free+0x79>
  8017ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ed:	8b 00                	mov    (%eax),%eax
  8017ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017f2:	8b 52 04             	mov    0x4(%edx),%edx
  8017f5:	89 50 04             	mov    %edx,0x4(%eax)
  8017f8:	eb 0b                	jmp    801805 <free+0x84>
  8017fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fd:	8b 40 04             	mov    0x4(%eax),%eax
  801800:	a3 44 40 80 00       	mov    %eax,0x804044
  801805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801808:	8b 40 04             	mov    0x4(%eax),%eax
  80180b:	85 c0                	test   %eax,%eax
  80180d:	74 0f                	je     80181e <free+0x9d>
  80180f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801812:	8b 40 04             	mov    0x4(%eax),%eax
  801815:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801818:	8b 12                	mov    (%edx),%edx
  80181a:	89 10                	mov    %edx,(%eax)
  80181c:	eb 0a                	jmp    801828 <free+0xa7>
  80181e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801821:	8b 00                	mov    (%eax),%eax
  801823:	a3 40 40 80 00       	mov    %eax,0x804040
  801828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80183b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801840:	48                   	dec    %eax
  801841:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	ff 75 ec             	pushl  -0x14(%ebp)
  80184c:	e8 63 12 00 00       	call   802ab4 <insert_sorted_with_merge_freeList>
  801851:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 38             	sub    $0x38,%esp
  80185d:	8b 45 10             	mov    0x10(%ebp),%eax
  801860:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801863:	e8 c8 fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80186c:	75 0a                	jne    801878 <smalloc+0x21>
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	e9 a0 00 00 00       	jmp    801918 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801878:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80187f:	76 0a                	jbe    80188b <smalloc+0x34>
		return NULL;
  801881:	b8 00 00 00 00       	mov    $0x0,%eax
  801886:	e9 8d 00 00 00       	jmp    801918 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80188b:	e8 1b 07 00 00       	call   801fab <sys_isUHeapPlacementStrategyFIRSTFIT>
  801890:	85 c0                	test   %eax,%eax
  801892:	74 7f                	je     801913 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801894:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80189b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	48                   	dec    %eax
  8018a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018af:	f7 75 f4             	divl   -0xc(%ebp)
  8018b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b5:	29 d0                	sub    %edx,%eax
  8018b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8018c0:	e8 65 0c 00 00       	call   80252a <alloc_block_FF>
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8018cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018cf:	74 42                	je     801913 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8018d1:	83 ec 0c             	sub    $0xc,%esp
  8018d4:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d7:	e8 9f 0a 00 00       	call   80237b <insert_sorted_allocList>
  8018dc:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8018df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e2:	8b 40 08             	mov    0x8(%eax),%eax
  8018e5:	89 c2                	mov    %eax,%edx
  8018e7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 38 04 00 00       	call   801d30 <sys_createSharedObject>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8018fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801902:	79 07                	jns    80190b <smalloc+0xb4>
	    		  return NULL;
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
  801909:	eb 0d                	jmp    801918 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80190b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190e:	8b 40 08             	mov    0x8(%eax),%eax
  801911:	eb 05                	jmp    801918 <smalloc+0xc1>


				}


		return NULL;
  801913:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801920:	e8 0b fc ff ff       	call   801530 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801925:	e8 81 06 00 00       	call   801fab <sys_isUHeapPlacementStrategyFIRSTFIT>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	0f 84 9f 00 00 00    	je     8019d1 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	ff 75 0c             	pushl  0xc(%ebp)
  801938:	ff 75 08             	pushl  0x8(%ebp)
  80193b:	e8 1a 04 00 00       	call   801d5a <sys_getSizeOfSharedObject>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80194a:	79 0a                	jns    801956 <sget+0x3c>
		return NULL;
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
  801951:	e9 80 00 00 00       	jmp    8019d6 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801956:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80195d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801963:	01 d0                	add    %edx,%eax
  801965:	48                   	dec    %eax
  801966:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196c:	ba 00 00 00 00       	mov    $0x0,%edx
  801971:	f7 75 f0             	divl   -0x10(%ebp)
  801974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801977:	29 d0                	sub    %edx,%eax
  801979:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	ff 75 e8             	pushl  -0x18(%ebp)
  801982:	e8 a3 0b 00 00       	call   80252a <alloc_block_FF>
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80198d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801991:	74 3e                	je     8019d1 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801993:	83 ec 0c             	sub    $0xc,%esp
  801996:	ff 75 e4             	pushl  -0x1c(%ebp)
  801999:	e8 dd 09 00 00       	call   80237b <insert_sorted_allocList>
  80199e:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8019a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a4:	8b 40 08             	mov    0x8(%eax),%eax
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	50                   	push   %eax
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	e8 c1 03 00 00       	call   801d77 <sys_getSharedObject>
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8019bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019c0:	79 07                	jns    8019c9 <sget+0xaf>
	    		  return NULL;
  8019c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c7:	eb 0d                	jmp    8019d6 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8019c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019cc:	8b 40 08             	mov    0x8(%eax),%eax
  8019cf:	eb 05                	jmp    8019d6 <sget+0xbc>
	      }
	}
	   return NULL;
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019de:	e8 4d fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 c0 3b 80 00       	push   $0x803bc0
  8019eb:	68 12 01 00 00       	push   $0x112
  8019f0:	68 b3 3b 80 00       	push   $0x803bb3
  8019f5:	e8 f8 ea ff ff       	call   8004f2 <_panic>

008019fa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 e8 3b 80 00       	push   $0x803be8
  801a08:	68 26 01 00 00       	push   $0x126
  801a0d:	68 b3 3b 80 00       	push   $0x803bb3
  801a12:	e8 db ea ff ff       	call   8004f2 <_panic>

00801a17 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	68 0c 3c 80 00       	push   $0x803c0c
  801a25:	68 31 01 00 00       	push   $0x131
  801a2a:	68 b3 3b 80 00       	push   $0x803bb3
  801a2f:	e8 be ea ff ff       	call   8004f2 <_panic>

00801a34 <shrink>:

}
void shrink(uint32 newSize)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	68 0c 3c 80 00       	push   $0x803c0c
  801a42:	68 36 01 00 00       	push   $0x136
  801a47:	68 b3 3b 80 00       	push   $0x803bb3
  801a4c:	e8 a1 ea ff ff       	call   8004f2 <_panic>

00801a51 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	68 0c 3c 80 00       	push   $0x803c0c
  801a5f:	68 3b 01 00 00       	push   $0x13b
  801a64:	68 b3 3b 80 00       	push   $0x803bb3
  801a69:	e8 84 ea ff ff       	call   8004f2 <_panic>

00801a6e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a83:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a86:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a89:	cd 30                	int    $0x30
  801a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5f                   	pop    %edi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    

00801a99 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801aa5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	52                   	push   %edx
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	50                   	push   %eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	e8 b2 ff ff ff       	call   801a6e <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	90                   	nop
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 01                	push   $0x1
  801ad1:	e8 98 ff ff ff       	call   801a6e <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 05                	push   $0x5
  801aee:	e8 7b ff ff ff       	call   801a6e <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	56                   	push   %esi
  801afc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801afd:	8b 75 18             	mov    0x18(%ebp),%esi
  801b00:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	51                   	push   %ecx
  801b0f:	52                   	push   %edx
  801b10:	50                   	push   %eax
  801b11:	6a 06                	push   $0x6
  801b13:	e8 56 ff ff ff       	call   801a6e <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    

00801b22 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	6a 07                	push   $0x7
  801b35:	e8 34 ff ff ff       	call   801a6e <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	ff 75 08             	pushl  0x8(%ebp)
  801b4e:	6a 08                	push   $0x8
  801b50:	e8 19 ff ff ff       	call   801a6e <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 09                	push   $0x9
  801b69:	e8 00 ff ff ff       	call   801a6e <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 0a                	push   $0xa
  801b82:	e8 e7 fe ff ff       	call   801a6e <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 0b                	push   $0xb
  801b9b:	e8 ce fe ff ff       	call   801a6e <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	6a 0f                	push   $0xf
  801bb6:	e8 b3 fe ff ff       	call   801a6e <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return;
  801bbe:	90                   	nop
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 10                	push   $0x10
  801bd2:	e8 97 fe ff ff       	call   801a6e <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	ff 75 10             	pushl  0x10(%ebp)
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	6a 11                	push   $0x11
  801bef:	e8 7a fe ff ff       	call   801a6e <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 0c                	push   $0xc
  801c09:	e8 60 fe ff ff       	call   801a6e <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	6a 0d                	push   $0xd
  801c23:	e8 46 fe ff ff       	call   801a6e <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 0e                	push   $0xe
  801c3c:	e8 2d fe ff ff       	call   801a6e <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	90                   	nop
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 13                	push   $0x13
  801c56:	e8 13 fe ff ff       	call   801a6e <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 14                	push   $0x14
  801c70:	e8 f9 fd ff ff       	call   801a6e <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	90                   	nop
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_cputc>:


void
sys_cputc(const char c)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c87:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	50                   	push   %eax
  801c94:	6a 15                	push   $0x15
  801c96:	e8 d3 fd ff ff       	call   801a6e <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	90                   	nop
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 16                	push   $0x16
  801cb0:	e8 b9 fd ff ff       	call   801a6e <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	90                   	nop
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	ff 75 0c             	pushl  0xc(%ebp)
  801cca:	50                   	push   %eax
  801ccb:	6a 17                	push   $0x17
  801ccd:	e8 9c fd ff ff       	call   801a6e <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	6a 1a                	push   $0x1a
  801cea:	e8 7f fd ff ff       	call   801a6e <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 18                	push   $0x18
  801d07:	e8 62 fd ff ff       	call   801a6e <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	90                   	nop
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	6a 19                	push   $0x19
  801d25:	e8 44 fd ff ff       	call   801a6e <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	90                   	nop
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	8b 45 10             	mov    0x10(%ebp),%eax
  801d39:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d3c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d3f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	51                   	push   %ecx
  801d49:	52                   	push   %edx
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	50                   	push   %eax
  801d4e:	6a 1b                	push   $0x1b
  801d50:	e8 19 fd ff ff       	call   801a6e <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 1c                	push   $0x1c
  801d6d:	e8 fc fc ff ff       	call   801a6e <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	51                   	push   %ecx
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	6a 1d                	push   $0x1d
  801d8c:	e8 dd fc ff ff       	call   801a6e <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	6a 1e                	push   $0x1e
  801da9:	e8 c0 fc ff ff       	call   801a6e <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 1f                	push   $0x1f
  801dc2:	e8 a7 fc ff ff       	call   801a6e <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	ff 75 14             	pushl  0x14(%ebp)
  801dd7:	ff 75 10             	pushl  0x10(%ebp)
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	50                   	push   %eax
  801dde:	6a 20                	push   $0x20
  801de0:	e8 89 fc ff ff       	call   801a6e <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	50                   	push   %eax
  801df9:	6a 21                	push   $0x21
  801dfb:	e8 6e fc ff ff       	call   801a6e <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	90                   	nop
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	50                   	push   %eax
  801e15:	6a 22                	push   $0x22
  801e17:	e8 52 fc ff ff       	call   801a6e <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 02                	push   $0x2
  801e30:	e8 39 fc ff ff       	call   801a6e <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 03                	push   $0x3
  801e49:	e8 20 fc ff ff       	call   801a6e <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 04                	push   $0x4
  801e62:	e8 07 fc ff ff       	call   801a6e <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_exit_env>:


void sys_exit_env(void)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 23                	push   $0x23
  801e7b:	e8 ee fb ff ff       	call   801a6e <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	90                   	nop
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e8f:	8d 50 04             	lea    0x4(%eax),%edx
  801e92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	6a 24                	push   $0x24
  801e9f:	e8 ca fb ff ff       	call   801a6e <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ea7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ead:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eb0:	89 01                	mov    %eax,(%ecx)
  801eb2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	c9                   	leave  
  801eb9:	c2 04 00             	ret    $0x4

00801ebc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	ff 75 10             	pushl  0x10(%ebp)
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	ff 75 08             	pushl  0x8(%ebp)
  801ecc:	6a 12                	push   $0x12
  801ece:	e8 9b fb ff ff       	call   801a6e <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed6:	90                   	nop
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 25                	push   $0x25
  801ee8:	e8 81 fb ff ff       	call   801a6e <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801efe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	50                   	push   %eax
  801f0b:	6a 26                	push   $0x26
  801f0d:	e8 5c fb ff ff       	call   801a6e <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
	return ;
  801f15:	90                   	nop
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <rsttst>:
void rsttst()
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 28                	push   $0x28
  801f27:	e8 42 fb ff ff       	call   801a6e <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 04             	sub    $0x4,%esp
  801f38:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801f41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f45:	52                   	push   %edx
  801f46:	50                   	push   %eax
  801f47:	ff 75 10             	pushl  0x10(%ebp)
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	6a 27                	push   $0x27
  801f52:	e8 17 fb ff ff       	call   801a6e <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5a:	90                   	nop
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <chktst>:
void chktst(uint32 n)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	ff 75 08             	pushl  0x8(%ebp)
  801f6b:	6a 29                	push   $0x29
  801f6d:	e8 fc fa ff ff       	call   801a6e <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
	return ;
  801f75:	90                   	nop
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <inctst>:

void inctst()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 2a                	push   $0x2a
  801f87:	e8 e2 fa ff ff       	call   801a6e <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8f:	90                   	nop
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <gettst>:
uint32 gettst()
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 2b                	push   $0x2b
  801fa1:	e8 c8 fa ff ff       	call   801a6e <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 2c                	push   $0x2c
  801fbd:	e8 ac fa ff ff       	call   801a6e <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
  801fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fc8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fcc:	75 07                	jne    801fd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fce:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd3:	eb 05                	jmp    801fda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 2c                	push   $0x2c
  801fee:	e8 7b fa ff ff       	call   801a6e <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
  801ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ff9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ffd:	75 07                	jne    802006 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fff:	b8 01 00 00 00       	mov    $0x1,%eax
  802004:	eb 05                	jmp    80200b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 2c                	push   $0x2c
  80201f:	e8 4a fa ff ff       	call   801a6e <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
  802027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80202a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80202e:	75 07                	jne    802037 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802030:	b8 01 00 00 00       	mov    $0x1,%eax
  802035:	eb 05                	jmp    80203c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 2c                	push   $0x2c
  802050:	e8 19 fa ff ff       	call   801a6e <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
  802058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80205b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80205f:	75 07                	jne    802068 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802061:	b8 01 00 00 00       	mov    $0x1,%eax
  802066:	eb 05                	jmp    80206d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	ff 75 08             	pushl  0x8(%ebp)
  80207d:	6a 2d                	push   $0x2d
  80207f:	e8 ea f9 ff ff       	call   801a6e <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
	return ;
  802087:	90                   	nop
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80208e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802091:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802094:	8b 55 0c             	mov    0xc(%ebp),%edx
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	6a 00                	push   $0x0
  80209c:	53                   	push   %ebx
  80209d:	51                   	push   %ecx
  80209e:	52                   	push   %edx
  80209f:	50                   	push   %eax
  8020a0:	6a 2e                	push   $0x2e
  8020a2:	e8 c7 f9 ff ff       	call   801a6e <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	6a 2f                	push   $0x2f
  8020c2:	e8 a7 f9 ff ff       	call   801a6e <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	68 1c 3c 80 00       	push   $0x803c1c
  8020da:	e8 c7 e6 ff ff       	call   8007a6 <cprintf>
  8020df:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	68 48 3c 80 00       	push   $0x803c48
  8020f1:	e8 b0 e6 ff ff       	call   8007a6 <cprintf>
  8020f6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020f9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802102:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802105:	eb 56                	jmp    80215d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802107:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210b:	74 1c                	je     802129 <print_mem_block_lists+0x5d>
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 50 08             	mov    0x8(%eax),%edx
  802113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802116:	8b 48 08             	mov    0x8(%eax),%ecx
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	8b 40 0c             	mov    0xc(%eax),%eax
  80211f:	01 c8                	add    %ecx,%eax
  802121:	39 c2                	cmp    %eax,%edx
  802123:	73 04                	jae    802129 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802125:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	8b 50 08             	mov    0x8(%eax),%edx
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 40 0c             	mov    0xc(%eax),%eax
  802135:	01 c2                	add    %eax,%edx
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	83 ec 04             	sub    $0x4,%esp
  802140:	52                   	push   %edx
  802141:	50                   	push   %eax
  802142:	68 5d 3c 80 00       	push   $0x803c5d
  802147:	e8 5a e6 ff ff       	call   8007a6 <cprintf>
  80214c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802155:	a1 40 41 80 00       	mov    0x804140,%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802161:	74 07                	je     80216a <print_mem_block_lists+0x9e>
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	eb 05                	jmp    80216f <print_mem_block_lists+0xa3>
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
  80216f:	a3 40 41 80 00       	mov    %eax,0x804140
  802174:	a1 40 41 80 00       	mov    0x804140,%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	75 8a                	jne    802107 <print_mem_block_lists+0x3b>
  80217d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802181:	75 84                	jne    802107 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802183:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802187:	75 10                	jne    802199 <print_mem_block_lists+0xcd>
  802189:	83 ec 0c             	sub    $0xc,%esp
  80218c:	68 6c 3c 80 00       	push   $0x803c6c
  802191:	e8 10 e6 ff ff       	call   8007a6 <cprintf>
  802196:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802199:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	68 90 3c 80 00       	push   $0x803c90
  8021a8:	e8 f9 e5 ff ff       	call   8007a6 <cprintf>
  8021ad:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021b0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021b4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bc:	eb 56                	jmp    802214 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c2:	74 1c                	je     8021e0 <print_mem_block_lists+0x114>
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cd:	8b 48 08             	mov    0x8(%eax),%ecx
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d6:	01 c8                	add    %ecx,%eax
  8021d8:	39 c2                	cmp    %eax,%edx
  8021da:	73 04                	jae    8021e0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021dc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	8b 50 08             	mov    0x8(%eax),%edx
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ec:	01 c2                	add    %eax,%edx
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	8b 40 08             	mov    0x8(%eax),%eax
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	52                   	push   %edx
  8021f8:	50                   	push   %eax
  8021f9:	68 5d 3c 80 00       	push   $0x803c5d
  8021fe:	e8 a3 e5 ff ff       	call   8007a6 <cprintf>
  802203:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80220c:	a1 48 40 80 00       	mov    0x804048,%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802218:	74 07                	je     802221 <print_mem_block_lists+0x155>
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 00                	mov    (%eax),%eax
  80221f:	eb 05                	jmp    802226 <print_mem_block_lists+0x15a>
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
  802226:	a3 48 40 80 00       	mov    %eax,0x804048
  80222b:	a1 48 40 80 00       	mov    0x804048,%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	75 8a                	jne    8021be <print_mem_block_lists+0xf2>
  802234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802238:	75 84                	jne    8021be <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80223a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80223e:	75 10                	jne    802250 <print_mem_block_lists+0x184>
  802240:	83 ec 0c             	sub    $0xc,%esp
  802243:	68 a8 3c 80 00       	push   $0x803ca8
  802248:	e8 59 e5 ff ff       	call   8007a6 <cprintf>
  80224d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	68 1c 3c 80 00       	push   $0x803c1c
  802258:	e8 49 e5 ff ff       	call   8007a6 <cprintf>
  80225d:	83 c4 10             	add    $0x10,%esp

}
  802260:	90                   	nop
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802269:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802270:	00 00 00 
  802273:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80227a:	00 00 00 
  80227d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802284:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802287:	a1 50 40 80 00       	mov    0x804050,%eax
  80228c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80228f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802296:	e9 9e 00 00 00       	jmp    802339 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80229b:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a3:	c1 e2 04             	shl    $0x4,%edx
  8022a6:	01 d0                	add    %edx,%eax
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	75 14                	jne    8022c0 <initialize_MemBlocksList+0x5d>
  8022ac:	83 ec 04             	sub    $0x4,%esp
  8022af:	68 d0 3c 80 00       	push   $0x803cd0
  8022b4:	6a 48                	push   $0x48
  8022b6:	68 f3 3c 80 00       	push   $0x803cf3
  8022bb:	e8 32 e2 ff ff       	call   8004f2 <_panic>
  8022c0:	a1 50 40 80 00       	mov    0x804050,%eax
  8022c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c8:	c1 e2 04             	shl    $0x4,%edx
  8022cb:	01 d0                	add    %edx,%eax
  8022cd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022d3:	89 10                	mov    %edx,(%eax)
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	74 18                	je     8022f3 <initialize_MemBlocksList+0x90>
  8022db:	a1 48 41 80 00       	mov    0x804148,%eax
  8022e0:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022e6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022e9:	c1 e1 04             	shl    $0x4,%ecx
  8022ec:	01 ca                	add    %ecx,%edx
  8022ee:	89 50 04             	mov    %edx,0x4(%eax)
  8022f1:	eb 12                	jmp    802305 <initialize_MemBlocksList+0xa2>
  8022f3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fb:	c1 e2 04             	shl    $0x4,%edx
  8022fe:	01 d0                	add    %edx,%eax
  802300:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802305:	a1 50 40 80 00       	mov    0x804050,%eax
  80230a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230d:	c1 e2 04             	shl    $0x4,%edx
  802310:	01 d0                	add    %edx,%eax
  802312:	a3 48 41 80 00       	mov    %eax,0x804148
  802317:	a1 50 40 80 00       	mov    0x804050,%eax
  80231c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231f:	c1 e2 04             	shl    $0x4,%edx
  802322:	01 d0                	add    %edx,%eax
  802324:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232b:	a1 54 41 80 00       	mov    0x804154,%eax
  802330:	40                   	inc    %eax
  802331:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802336:	ff 45 f4             	incl   -0xc(%ebp)
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233f:	0f 82 56 ff ff ff    	jb     80229b <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802345:	90                   	nop
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802356:	eb 18                	jmp    802370 <find_block+0x28>
		{
			if(tmp->sva==va)
  802358:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235b:	8b 40 08             	mov    0x8(%eax),%eax
  80235e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802361:	75 05                	jne    802368 <find_block+0x20>
			{
				return tmp;
  802363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802366:	eb 11                	jmp    802379 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802368:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802370:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802374:	75 e2                	jne    802358 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802376:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802381:	a1 40 40 80 00       	mov    0x804040,%eax
  802386:	85 c0                	test   %eax,%eax
  802388:	0f 85 83 00 00 00    	jne    802411 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80238e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802395:	00 00 00 
  802398:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80239f:	00 00 00 
  8023a2:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8023a9:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8023ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b0:	75 14                	jne    8023c6 <insert_sorted_allocList+0x4b>
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	68 d0 3c 80 00       	push   $0x803cd0
  8023ba:	6a 7f                	push   $0x7f
  8023bc:	68 f3 3c 80 00       	push   $0x803cf3
  8023c1:	e8 2c e1 ff ff       	call   8004f2 <_panic>
  8023c6:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	89 10                	mov    %edx,(%eax)
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 0d                	je     8023e7 <insert_sorted_allocList+0x6c>
  8023da:	a1 40 40 80 00       	mov    0x804040,%eax
  8023df:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e2:	89 50 04             	mov    %edx,0x4(%eax)
  8023e5:	eb 08                	jmp    8023ef <insert_sorted_allocList+0x74>
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	a3 40 40 80 00       	mov    %eax,0x804040
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802401:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802406:	40                   	inc    %eax
  802407:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80240c:	e9 16 01 00 00       	jmp    802527 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	8b 50 08             	mov    0x8(%eax),%edx
  802417:	a1 44 40 80 00       	mov    0x804044,%eax
  80241c:	8b 40 08             	mov    0x8(%eax),%eax
  80241f:	39 c2                	cmp    %eax,%edx
  802421:	76 68                	jbe    80248b <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802423:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802427:	75 17                	jne    802440 <insert_sorted_allocList+0xc5>
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	68 0c 3d 80 00       	push   $0x803d0c
  802431:	68 85 00 00 00       	push   $0x85
  802436:	68 f3 3c 80 00       	push   $0x803cf3
  80243b:	e8 b2 e0 ff ff       	call   8004f2 <_panic>
  802440:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	89 50 04             	mov    %edx,0x4(%eax)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0c                	je     802462 <insert_sorted_allocList+0xe7>
  802456:	a1 44 40 80 00       	mov    0x804044,%eax
  80245b:	8b 55 08             	mov    0x8(%ebp),%edx
  80245e:	89 10                	mov    %edx,(%eax)
  802460:	eb 08                	jmp    80246a <insert_sorted_allocList+0xef>
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	a3 40 40 80 00       	mov    %eax,0x804040
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	a3 44 40 80 00       	mov    %eax,0x804044
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802480:	40                   	inc    %eax
  802481:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802486:	e9 9c 00 00 00       	jmp    802527 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80248b:	a1 40 40 80 00       	mov    0x804040,%eax
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802493:	e9 85 00 00 00       	jmp    80251d <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	8b 50 08             	mov    0x8(%eax),%edx
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 40 08             	mov    0x8(%eax),%eax
  8024a4:	39 c2                	cmp    %eax,%edx
  8024a6:	73 6d                	jae    802515 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8024a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ac:	74 06                	je     8024b4 <insert_sorted_allocList+0x139>
  8024ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b2:	75 17                	jne    8024cb <insert_sorted_allocList+0x150>
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	68 30 3d 80 00       	push   $0x803d30
  8024bc:	68 90 00 00 00       	push   $0x90
  8024c1:	68 f3 3c 80 00       	push   $0x803cf3
  8024c6:	e8 27 e0 ff ff       	call   8004f2 <_panic>
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 50 04             	mov    0x4(%eax),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	89 50 04             	mov    %edx,0x4(%eax)
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 0d                	je     8024f6 <insert_sorted_allocList+0x17b>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 04             	mov    0x4(%eax),%eax
  8024ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f2:	89 10                	mov    %edx,(%eax)
  8024f4:	eb 08                	jmp    8024fe <insert_sorted_allocList+0x183>
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	a3 40 40 80 00       	mov    %eax,0x804040
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 55 08             	mov    0x8(%ebp),%edx
  802504:	89 50 04             	mov    %edx,0x4(%eax)
  802507:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80250c:	40                   	inc    %eax
  80250d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802512:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802513:	eb 12                	jmp    802527 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  80251d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802521:	0f 85 71 ff ff ff    	jne    802498 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802527:	90                   	nop
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802530:	a1 38 41 80 00       	mov    0x804138,%eax
  802535:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802538:	e9 76 01 00 00       	jmp    8026b3 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 0c             	mov    0xc(%eax),%eax
  802543:	3b 45 08             	cmp    0x8(%ebp),%eax
  802546:	0f 85 8a 00 00 00    	jne    8025d6 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80254c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802550:	75 17                	jne    802569 <alloc_block_FF+0x3f>
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	68 65 3d 80 00       	push   $0x803d65
  80255a:	68 a8 00 00 00       	push   $0xa8
  80255f:	68 f3 3c 80 00       	push   $0x803cf3
  802564:	e8 89 df ff ff       	call   8004f2 <_panic>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 10                	je     802582 <alloc_block_FF+0x58>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257a:	8b 52 04             	mov    0x4(%edx),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	eb 0b                	jmp    80258d <alloc_block_FF+0x63>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 0f                	je     8025a6 <alloc_block_FF+0x7c>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a0:	8b 12                	mov    (%edx),%edx
  8025a2:	89 10                	mov    %edx,(%eax)
  8025a4:	eb 0a                	jmp    8025b0 <alloc_block_FF+0x86>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	a3 38 41 80 00       	mov    %eax,0x804138
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c3:	a1 44 41 80 00       	mov    0x804144,%eax
  8025c8:	48                   	dec    %eax
  8025c9:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	e9 ea 00 00 00       	jmp    8026c0 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025df:	0f 86 c6 00 00 00    	jbe    8026ab <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8025ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f3:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 50 08             	mov    0x8(%eax),%edx
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 40 0c             	mov    0xc(%eax),%eax
  802608:	2b 45 08             	sub    0x8(%ebp),%eax
  80260b:	89 c2                	mov    %eax,%edx
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 50 08             	mov    0x8(%eax),%edx
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	01 c2                	add    %eax,%edx
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802624:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802628:	75 17                	jne    802641 <alloc_block_FF+0x117>
  80262a:	83 ec 04             	sub    $0x4,%esp
  80262d:	68 65 3d 80 00       	push   $0x803d65
  802632:	68 b6 00 00 00       	push   $0xb6
  802637:	68 f3 3c 80 00       	push   $0x803cf3
  80263c:	e8 b1 de ff ff       	call   8004f2 <_panic>
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 10                	je     80265a <alloc_block_FF+0x130>
  80264a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802652:	8b 52 04             	mov    0x4(%edx),%edx
  802655:	89 50 04             	mov    %edx,0x4(%eax)
  802658:	eb 0b                	jmp    802665 <alloc_block_FF+0x13b>
  80265a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265d:	8b 40 04             	mov    0x4(%eax),%eax
  802660:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802668:	8b 40 04             	mov    0x4(%eax),%eax
  80266b:	85 c0                	test   %eax,%eax
  80266d:	74 0f                	je     80267e <alloc_block_FF+0x154>
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	8b 40 04             	mov    0x4(%eax),%eax
  802675:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802678:	8b 12                	mov    (%edx),%edx
  80267a:	89 10                	mov    %edx,(%eax)
  80267c:	eb 0a                	jmp    802688 <alloc_block_FF+0x15e>
  80267e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	a3 48 41 80 00       	mov    %eax,0x804148
  802688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269b:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a0:	48                   	dec    %eax
  8026a1:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  8026a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a9:	eb 15                	jmp    8026c0 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	0f 85 80 fe ff ff    	jne    80253d <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8026c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8026cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8026d0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8026d7:	e9 c0 00 00 00       	jmp    80279c <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e5:	0f 85 8a 00 00 00    	jne    802775 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8026eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ef:	75 17                	jne    802708 <alloc_block_BF+0x46>
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	68 65 3d 80 00       	push   $0x803d65
  8026f9:	68 cf 00 00 00       	push   $0xcf
  8026fe:	68 f3 3c 80 00       	push   $0x803cf3
  802703:	e8 ea dd ff ff       	call   8004f2 <_panic>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 10                	je     802721 <alloc_block_BF+0x5f>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802719:	8b 52 04             	mov    0x4(%edx),%edx
  80271c:	89 50 04             	mov    %edx,0x4(%eax)
  80271f:	eb 0b                	jmp    80272c <alloc_block_BF+0x6a>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	74 0f                	je     802745 <alloc_block_BF+0x83>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273f:	8b 12                	mov    (%edx),%edx
  802741:	89 10                	mov    %edx,(%eax)
  802743:	eb 0a                	jmp    80274f <alloc_block_BF+0x8d>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 00                	mov    (%eax),%eax
  80274a:	a3 38 41 80 00       	mov    %eax,0x804138
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802762:	a1 44 41 80 00       	mov    0x804144,%eax
  802767:	48                   	dec    %eax
  802768:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	e9 2a 01 00 00       	jmp    80289f <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 40 0c             	mov    0xc(%eax),%eax
  80277b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80277e:	73 14                	jae    802794 <alloc_block_BF+0xd2>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 0c             	mov    0xc(%eax),%eax
  802786:	3b 45 08             	cmp    0x8(%ebp),%eax
  802789:	76 09                	jbe    802794 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80279c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a0:	0f 85 36 ff ff ff    	jne    8026dc <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8027a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8027ae:	e9 dd 00 00 00       	jmp    802890 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027bc:	0f 85 c6 00 00 00    	jne    802888 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027c2:	a1 48 41 80 00       	mov    0x804148,%eax
  8027c7:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 50 08             	mov    0x8(%eax),%edx
  8027d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d3:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dc:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 50 08             	mov    0x8(%eax),%edx
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	01 c2                	add    %eax,%edx
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f9:	89 c2                	mov    %eax,%edx
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802801:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802805:	75 17                	jne    80281e <alloc_block_BF+0x15c>
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 65 3d 80 00       	push   $0x803d65
  80280f:	68 eb 00 00 00       	push   $0xeb
  802814:	68 f3 3c 80 00       	push   $0x803cf3
  802819:	e8 d4 dc ff ff       	call   8004f2 <_panic>
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 10                	je     802837 <alloc_block_BF+0x175>
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282f:	8b 52 04             	mov    0x4(%edx),%edx
  802832:	89 50 04             	mov    %edx,0x4(%eax)
  802835:	eb 0b                	jmp    802842 <alloc_block_BF+0x180>
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	8b 40 04             	mov    0x4(%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 0f                	je     80285b <alloc_block_BF+0x199>
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802855:	8b 12                	mov    (%edx),%edx
  802857:	89 10                	mov    %edx,(%eax)
  802859:	eb 0a                	jmp    802865 <alloc_block_BF+0x1a3>
  80285b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	a3 48 41 80 00       	mov    %eax,0x804148
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802878:	a1 54 41 80 00       	mov    0x804154,%eax
  80287d:	48                   	dec    %eax
  80287e:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	eb 17                	jmp    80289f <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	0f 85 19 ff ff ff    	jne    8027b3 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80289a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8028a7:	a1 40 40 80 00       	mov    0x804040,%eax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	75 19                	jne    8028c9 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8028b0:	83 ec 0c             	sub    $0xc,%esp
  8028b3:	ff 75 08             	pushl  0x8(%ebp)
  8028b6:	e8 6f fc ff ff       	call   80252a <alloc_block_FF>
  8028bb:	83 c4 10             	add    $0x10,%esp
  8028be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	e9 e9 01 00 00       	jmp    802ab2 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8028c9:	a1 44 40 80 00       	mov    0x804044,%eax
  8028ce:	8b 40 08             	mov    0x8(%eax),%eax
  8028d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8028d4:	a1 44 40 80 00       	mov    0x804044,%eax
  8028d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8028dc:	a1 44 40 80 00       	mov    0x804044,%eax
  8028e1:	8b 40 08             	mov    0x8(%eax),%eax
  8028e4:	01 d0                	add    %edx,%eax
  8028e6:	83 ec 08             	sub    $0x8,%esp
  8028e9:	50                   	push   %eax
  8028ea:	68 38 41 80 00       	push   $0x804138
  8028ef:	e8 54 fa ff ff       	call   802348 <find_block>
  8028f4:	83 c4 10             	add    $0x10,%esp
  8028f7:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802900:	3b 45 08             	cmp    0x8(%ebp),%eax
  802903:	0f 85 9b 00 00 00    	jne    8029a4 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 50 0c             	mov    0xc(%eax),%edx
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 08             	mov    0x8(%eax),%eax
  802915:	01 d0                	add    %edx,%eax
  802917:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_NF+0x96>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 65 3d 80 00       	push   $0x803d65
  802928:	68 1a 01 00 00       	push   $0x11a
  80292d:	68 f3 3c 80 00       	push   $0x803cf3
  802932:	e8 bb db ff ff       	call   8004f2 <_panic>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_NF+0xaf>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_NF+0xba>
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_NF+0xd3>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_NF+0xdd>
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 38 41 80 00       	mov    %eax,0x804138
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 44 41 80 00       	mov    0x804144,%eax
  802996:	48                   	dec    %eax
  802997:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	e9 0e 01 00 00       	jmp    802ab2 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ad:	0f 86 cf 00 00 00    	jbe    802a82 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8029b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8029b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8029bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029be:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c1:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 50 08             	mov    0x8(%eax),%edx
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	01 c2                	add    %eax,%edx
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ea:	89 c2                	mov    %eax,%edx
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 08             	mov    0x8(%eax),%eax
  8029f8:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ff:	75 17                	jne    802a18 <alloc_block_NF+0x177>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 65 3d 80 00       	push   $0x803d65
  802a09:	68 28 01 00 00       	push   $0x128
  802a0e:	68 f3 3c 80 00       	push   $0x803cf3
  802a13:	e8 da da ff ff       	call   8004f2 <_panic>
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 10                	je     802a31 <alloc_block_NF+0x190>
  802a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a29:	8b 52 04             	mov    0x4(%edx),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	eb 0b                	jmp    802a3c <alloc_block_NF+0x19b>
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 0f                	je     802a55 <alloc_block_NF+0x1b4>
  802a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a4f:	8b 12                	mov    (%edx),%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	eb 0a                	jmp    802a5f <alloc_block_NF+0x1be>
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	a3 48 41 80 00       	mov    %eax,0x804148
  802a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a72:	a1 54 41 80 00       	mov    0x804154,%eax
  802a77:	48                   	dec    %eax
  802a78:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a80:	eb 30                	jmp    802ab2 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802a82:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a87:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a8a:	75 0a                	jne    802a96 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802a8c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a94:	eb 08                	jmp    802a9e <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 08             	mov    0x8(%eax),%eax
  802aa4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aa7:	0f 85 4d fe ff ff    	jne    8028fa <alloc_block_NF+0x59>

			return NULL;
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	53                   	push   %ebx
  802ab8:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802abb:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	0f 85 86 00 00 00    	jne    802b4e <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802ac8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802acf:	00 00 00 
  802ad2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802ad9:	00 00 00 
  802adc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802ae3:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aea:	75 17                	jne    802b03 <insert_sorted_with_merge_freeList+0x4f>
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 d0 3c 80 00       	push   $0x803cd0
  802af4:	68 48 01 00 00       	push   $0x148
  802af9:	68 f3 3c 80 00       	push   $0x803cf3
  802afe:	e8 ef d9 ff ff       	call   8004f2 <_panic>
  802b03:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	74 0d                	je     802b24 <insert_sorted_with_merge_freeList+0x70>
  802b17:	a1 38 41 80 00       	mov    0x804138,%eax
  802b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	eb 08                	jmp    802b2c <insert_sorted_with_merge_freeList+0x78>
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	a3 38 41 80 00       	mov    %eax,0x804138
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b43:	40                   	inc    %eax
  802b44:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802b49:	e9 73 07 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	8b 50 08             	mov    0x8(%eax),%edx
  802b54:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b59:	8b 40 08             	mov    0x8(%eax),%eax
  802b5c:	39 c2                	cmp    %eax,%edx
  802b5e:	0f 86 84 00 00 00    	jbe    802be8 <insert_sorted_with_merge_freeList+0x134>
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 50 08             	mov    0x8(%eax),%edx
  802b6a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b6f:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b72:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b77:	8b 40 08             	mov    0x8(%eax),%eax
  802b7a:	01 c8                	add    %ecx,%eax
  802b7c:	39 c2                	cmp    %eax,%edx
  802b7e:	74 68                	je     802be8 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802b80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b84:	75 17                	jne    802b9d <insert_sorted_with_merge_freeList+0xe9>
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	68 0c 3d 80 00       	push   $0x803d0c
  802b8e:	68 4c 01 00 00       	push   $0x14c
  802b93:	68 f3 3c 80 00       	push   $0x803cf3
  802b98:	e8 55 d9 ff ff       	call   8004f2 <_panic>
  802b9d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	89 50 04             	mov    %edx,0x4(%eax)
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	8b 40 04             	mov    0x4(%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	74 0c                	je     802bbf <insert_sorted_with_merge_freeList+0x10b>
  802bb3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	eb 08                	jmp    802bc7 <insert_sorted_with_merge_freeList+0x113>
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd8:	a1 44 41 80 00       	mov    0x804144,%eax
  802bdd:	40                   	inc    %eax
  802bde:	a3 44 41 80 00       	mov    %eax,0x804144
  802be3:	e9 d9 06 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	8b 50 08             	mov    0x8(%eax),%edx
  802bee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf3:	8b 40 08             	mov    0x8(%eax),%eax
  802bf6:	39 c2                	cmp    %eax,%edx
  802bf8:	0f 86 b5 00 00 00    	jbe    802cb3 <insert_sorted_with_merge_freeList+0x1ff>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c09:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c0c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c11:	8b 40 08             	mov    0x8(%eax),%eax
  802c14:	01 c8                	add    %ecx,%eax
  802c16:	39 c2                	cmp    %eax,%edx
  802c18:	0f 85 95 00 00 00    	jne    802cb3 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802c1e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c23:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c29:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2f:	8b 52 0c             	mov    0xc(%edx),%edx
  802c32:	01 ca                	add    %ecx,%edx
  802c34:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4f:	75 17                	jne    802c68 <insert_sorted_with_merge_freeList+0x1b4>
  802c51:	83 ec 04             	sub    $0x4,%esp
  802c54:	68 d0 3c 80 00       	push   $0x803cd0
  802c59:	68 54 01 00 00       	push   $0x154
  802c5e:	68 f3 3c 80 00       	push   $0x803cf3
  802c63:	e8 8a d8 ff ff       	call   8004f2 <_panic>
  802c68:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	89 10                	mov    %edx,(%eax)
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0d                	je     802c89 <insert_sorted_with_merge_freeList+0x1d5>
  802c7c:	a1 48 41 80 00       	mov    0x804148,%eax
  802c81:	8b 55 08             	mov    0x8(%ebp),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	eb 08                	jmp    802c91 <insert_sorted_with_merge_freeList+0x1dd>
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	a3 48 41 80 00       	mov    %eax,0x804148
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca8:	40                   	inc    %eax
  802ca9:	a3 54 41 80 00       	mov    %eax,0x804154
  802cae:	e9 0e 06 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 50 08             	mov    0x8(%eax),%edx
  802cb9:	a1 38 41 80 00       	mov    0x804138,%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	39 c2                	cmp    %eax,%edx
  802cc3:	0f 83 c1 00 00 00    	jae    802d8a <insert_sorted_with_merge_freeList+0x2d6>
  802cc9:	a1 38 41 80 00       	mov    0x804138,%eax
  802cce:	8b 50 08             	mov    0x8(%eax),%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 48 08             	mov    0x8(%eax),%ecx
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	01 c8                	add    %ecx,%eax
  802cdf:	39 c2                	cmp    %eax,%edx
  802ce1:	0f 85 a3 00 00 00    	jne    802d8a <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ce7:	a1 38 41 80 00       	mov    0x804138,%eax
  802cec:	8b 55 08             	mov    0x8(%ebp),%edx
  802cef:	8b 52 08             	mov    0x8(%edx),%edx
  802cf2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802cf5:	a1 38 41 80 00       	mov    0x804138,%eax
  802cfa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d00:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d03:	8b 55 08             	mov    0x8(%ebp),%edx
  802d06:	8b 52 0c             	mov    0xc(%edx),%edx
  802d09:	01 ca                	add    %ecx,%edx
  802d0b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d26:	75 17                	jne    802d3f <insert_sorted_with_merge_freeList+0x28b>
  802d28:	83 ec 04             	sub    $0x4,%esp
  802d2b:	68 d0 3c 80 00       	push   $0x803cd0
  802d30:	68 5d 01 00 00       	push   $0x15d
  802d35:	68 f3 3c 80 00       	push   $0x803cf3
  802d3a:	e8 b3 d7 ff ff       	call   8004f2 <_panic>
  802d3f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	89 10                	mov    %edx,(%eax)
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 0d                	je     802d60 <insert_sorted_with_merge_freeList+0x2ac>
  802d53:	a1 48 41 80 00       	mov    0x804148,%eax
  802d58:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 08                	jmp    802d68 <insert_sorted_with_merge_freeList+0x2b4>
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7f:	40                   	inc    %eax
  802d80:	a3 54 41 80 00       	mov    %eax,0x804154
  802d85:	e9 37 05 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 50 08             	mov    0x8(%eax),%edx
  802d90:	a1 38 41 80 00       	mov    0x804138,%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	39 c2                	cmp    %eax,%edx
  802d9a:	0f 83 82 00 00 00    	jae    802e22 <insert_sorted_with_merge_freeList+0x36e>
  802da0:	a1 38 41 80 00       	mov    0x804138,%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 48 08             	mov    0x8(%eax),%ecx
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 40 0c             	mov    0xc(%eax),%eax
  802db4:	01 c8                	add    %ecx,%eax
  802db6:	39 c2                	cmp    %eax,%edx
  802db8:	74 68                	je     802e22 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbe:	75 17                	jne    802dd7 <insert_sorted_with_merge_freeList+0x323>
  802dc0:	83 ec 04             	sub    $0x4,%esp
  802dc3:	68 d0 3c 80 00       	push   $0x803cd0
  802dc8:	68 62 01 00 00       	push   $0x162
  802dcd:	68 f3 3c 80 00       	push   $0x803cf3
  802dd2:	e8 1b d7 ff ff       	call   8004f2 <_panic>
  802dd7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	89 10                	mov    %edx,(%eax)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0d                	je     802df8 <insert_sorted_with_merge_freeList+0x344>
  802deb:	a1 38 41 80 00       	mov    0x804138,%eax
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	89 50 04             	mov    %edx,0x4(%eax)
  802df6:	eb 08                	jmp    802e00 <insert_sorted_with_merge_freeList+0x34c>
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	a3 38 41 80 00       	mov    %eax,0x804138
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e12:	a1 44 41 80 00       	mov    0x804144,%eax
  802e17:	40                   	inc    %eax
  802e18:	a3 44 41 80 00       	mov    %eax,0x804144
  802e1d:	e9 9f 04 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802e22:	a1 38 41 80 00       	mov    0x804138,%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802e2c:	e9 84 04 00 00       	jmp    8032b5 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 50 08             	mov    0x8(%eax),%edx
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	8b 40 08             	mov    0x8(%eax),%eax
  802e3d:	39 c2                	cmp    %eax,%edx
  802e3f:	0f 86 a9 00 00 00    	jbe    802eee <insert_sorted_with_merge_freeList+0x43a>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 48 08             	mov    0x8(%eax),%ecx
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	01 c8                	add    %ecx,%eax
  802e59:	39 c2                	cmp    %eax,%edx
  802e5b:	0f 84 8d 00 00 00    	je     802eee <insert_sorted_with_merge_freeList+0x43a>
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 50 08             	mov    0x8(%eax),%edx
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	8b 48 08             	mov    0x8(%eax),%ecx
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	01 c8                	add    %ecx,%eax
  802e7b:	39 c2                	cmp    %eax,%edx
  802e7d:	74 6f                	je     802eee <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e83:	74 06                	je     802e8b <insert_sorted_with_merge_freeList+0x3d7>
  802e85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e89:	75 17                	jne    802ea2 <insert_sorted_with_merge_freeList+0x3ee>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 30 3d 80 00       	push   $0x803d30
  802e93:	68 6b 01 00 00       	push   $0x16b
  802e98:	68 f3 3c 80 00       	push   $0x803cf3
  802e9d:	e8 50 d6 ff ff       	call   8004f2 <_panic>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 50 04             	mov    0x4(%eax),%edx
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	89 50 04             	mov    %edx,0x4(%eax)
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb4:	89 10                	mov    %edx,(%eax)
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	74 0d                	je     802ecd <insert_sorted_with_merge_freeList+0x419>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 40 04             	mov    0x4(%eax),%eax
  802ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec9:	89 10                	mov    %edx,(%eax)
  802ecb:	eb 08                	jmp    802ed5 <insert_sorted_with_merge_freeList+0x421>
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  802edb:	89 50 04             	mov    %edx,0x4(%eax)
  802ede:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee3:	40                   	inc    %eax
  802ee4:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802ee9:	e9 d3 03 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 50 08             	mov    0x8(%eax),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 08             	mov    0x8(%eax),%eax
  802efa:	39 c2                	cmp    %eax,%edx
  802efc:	0f 86 da 00 00 00    	jbe    802fdc <insert_sorted_with_merge_freeList+0x528>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 48 08             	mov    0x8(%eax),%ecx
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 40 0c             	mov    0xc(%eax),%eax
  802f14:	01 c8                	add    %ecx,%eax
  802f16:	39 c2                	cmp    %eax,%edx
  802f18:	0f 85 be 00 00 00    	jne    802fdc <insert_sorted_with_merge_freeList+0x528>
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 50 08             	mov    0x8(%eax),%edx
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	8b 48 08             	mov    0x8(%eax),%ecx
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	8b 40 0c             	mov    0xc(%eax),%eax
  802f36:	01 c8                	add    %ecx,%eax
  802f38:	39 c2                	cmp    %eax,%edx
  802f3a:	0f 84 9c 00 00 00    	je     802fdc <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 50 08             	mov    0x8(%eax),%edx
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f78:	75 17                	jne    802f91 <insert_sorted_with_merge_freeList+0x4dd>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 d0 3c 80 00       	push   $0x803cd0
  802f82:	68 74 01 00 00       	push   $0x174
  802f87:	68 f3 3c 80 00       	push   $0x803cf3
  802f8c:	e8 61 d5 ff ff       	call   8004f2 <_panic>
  802f91:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 0d                	je     802fb2 <insert_sorted_with_merge_freeList+0x4fe>
  802fa5:	a1 48 41 80 00       	mov    0x804148,%eax
  802faa:	8b 55 08             	mov    0x8(%ebp),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%eax)
  802fb0:	eb 08                	jmp    802fba <insert_sorted_with_merge_freeList+0x506>
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcc:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802fd7:	e9 e5 02 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 50 08             	mov    0x8(%eax),%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 40 08             	mov    0x8(%eax),%eax
  802fe8:	39 c2                	cmp    %eax,%edx
  802fea:	0f 86 d7 00 00 00    	jbe    8030c7 <insert_sorted_with_merge_freeList+0x613>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 50 08             	mov    0x8(%eax),%edx
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 48 08             	mov    0x8(%eax),%ecx
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 40 0c             	mov    0xc(%eax),%eax
  803002:	01 c8                	add    %ecx,%eax
  803004:	39 c2                	cmp    %eax,%edx
  803006:	0f 84 bb 00 00 00    	je     8030c7 <insert_sorted_with_merge_freeList+0x613>
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 50 08             	mov    0x8(%eax),%edx
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	8b 48 08             	mov    0x8(%eax),%ecx
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	01 c8                	add    %ecx,%eax
  803026:	39 c2                	cmp    %eax,%edx
  803028:	0f 85 99 00 00 00    	jne    8030c7 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303a:	8b 50 0c             	mov    0xc(%eax),%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	8b 40 0c             	mov    0xc(%eax),%eax
  803043:	01 c2                	add    %eax,%edx
  803045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803048:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80305f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803063:	75 17                	jne    80307c <insert_sorted_with_merge_freeList+0x5c8>
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	68 d0 3c 80 00       	push   $0x803cd0
  80306d:	68 7d 01 00 00       	push   $0x17d
  803072:	68 f3 3c 80 00       	push   $0x803cf3
  803077:	e8 76 d4 ff ff       	call   8004f2 <_panic>
  80307c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 0d                	je     80309d <insert_sorted_with_merge_freeList+0x5e9>
  803090:	a1 48 41 80 00       	mov    0x804148,%eax
  803095:	8b 55 08             	mov    0x8(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	eb 08                	jmp    8030a5 <insert_sorted_with_merge_freeList+0x5f1>
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8030bc:	40                   	inc    %eax
  8030bd:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  8030c2:	e9 fa 01 00 00       	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 50 08             	mov    0x8(%eax),%edx
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	8b 40 08             	mov    0x8(%eax),%eax
  8030d3:	39 c2                	cmp    %eax,%edx
  8030d5:	0f 86 d2 01 00 00    	jbe    8032ad <insert_sorted_with_merge_freeList+0x7f9>
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 50 08             	mov    0x8(%eax),%edx
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	8b 48 08             	mov    0x8(%eax),%ecx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ed:	01 c8                	add    %ecx,%eax
  8030ef:	39 c2                	cmp    %eax,%edx
  8030f1:	0f 85 b6 01 00 00    	jne    8032ad <insert_sorted_with_merge_freeList+0x7f9>
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 50 08             	mov    0x8(%eax),%edx
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	8b 48 08             	mov    0x8(%eax),%ecx
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	8b 40 0c             	mov    0xc(%eax),%eax
  80310f:	01 c8                	add    %ecx,%eax
  803111:	39 c2                	cmp    %eax,%edx
  803113:	0f 85 94 01 00 00    	jne    8032ad <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 40 04             	mov    0x4(%eax),%eax
  80311f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803122:	8b 52 04             	mov    0x4(%edx),%edx
  803125:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803128:	8b 55 08             	mov    0x8(%ebp),%edx
  80312b:	8b 5a 0c             	mov    0xc(%edx),%ebx
  80312e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803131:	8b 52 0c             	mov    0xc(%edx),%edx
  803134:	01 da                	add    %ebx,%edx
  803136:	01 ca                	add    %ecx,%edx
  803138:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80314f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803153:	75 17                	jne    80316c <insert_sorted_with_merge_freeList+0x6b8>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 65 3d 80 00       	push   $0x803d65
  80315d:	68 86 01 00 00       	push   $0x186
  803162:	68 f3 3c 80 00       	push   $0x803cf3
  803167:	e8 86 d3 ff ff       	call   8004f2 <_panic>
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	74 10                	je     803185 <insert_sorted_with_merge_freeList+0x6d1>
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 00                	mov    (%eax),%eax
  80317a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317d:	8b 52 04             	mov    0x4(%edx),%edx
  803180:	89 50 04             	mov    %edx,0x4(%eax)
  803183:	eb 0b                	jmp    803190 <insert_sorted_with_merge_freeList+0x6dc>
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 40 04             	mov    0x4(%eax),%eax
  80318b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 40 04             	mov    0x4(%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 0f                	je     8031a9 <insert_sorted_with_merge_freeList+0x6f5>
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 40 04             	mov    0x4(%eax),%eax
  8031a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a3:	8b 12                	mov    (%edx),%edx
  8031a5:	89 10                	mov    %edx,(%eax)
  8031a7:	eb 0a                	jmp    8031b3 <insert_sorted_with_merge_freeList+0x6ff>
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8031b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8031cb:	48                   	dec    %eax
  8031cc:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8031d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d5:	75 17                	jne    8031ee <insert_sorted_with_merge_freeList+0x73a>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 d0 3c 80 00       	push   $0x803cd0
  8031df:	68 87 01 00 00       	push   $0x187
  8031e4:	68 f3 3c 80 00       	push   $0x803cf3
  8031e9:	e8 04 d3 ff ff       	call   8004f2 <_panic>
  8031ee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0d                	je     80320f <insert_sorted_with_merge_freeList+0x75b>
  803202:	a1 48 41 80 00       	mov    0x804148,%eax
  803207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 08                	jmp    803217 <insert_sorted_with_merge_freeList+0x763>
  80320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803212:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	a3 48 41 80 00       	mov    %eax,0x804148
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 54 41 80 00       	mov    0x804154,%eax
  80322e:	40                   	inc    %eax
  80322f:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324c:	75 17                	jne    803265 <insert_sorted_with_merge_freeList+0x7b1>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 d0 3c 80 00       	push   $0x803cd0
  803256:	68 8a 01 00 00       	push   $0x18a
  80325b:	68 f3 3c 80 00       	push   $0x803cf3
  803260:	e8 8d d2 ff ff       	call   8004f2 <_panic>
  803265:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 0d                	je     803286 <insert_sorted_with_merge_freeList+0x7d2>
  803279:	a1 48 41 80 00       	mov    0x804148,%eax
  80327e:	8b 55 08             	mov    0x8(%ebp),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	eb 08                	jmp    80328e <insert_sorted_with_merge_freeList+0x7da>
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	a3 48 41 80 00       	mov    %eax,0x804148
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8032a5:	40                   	inc    %eax
  8032a6:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  8032ab:	eb 14                	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8032b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b9:	0f 85 72 fb ff ff    	jne    802e31 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8032bf:	eb 00                	jmp    8032c1 <insert_sorted_with_merge_freeList+0x80d>
  8032c1:	90                   	nop
  8032c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032c5:	c9                   	leave  
  8032c6:	c3                   	ret    
  8032c7:	90                   	nop

008032c8 <__udivdi3>:
  8032c8:	55                   	push   %ebp
  8032c9:	57                   	push   %edi
  8032ca:	56                   	push   %esi
  8032cb:	53                   	push   %ebx
  8032cc:	83 ec 1c             	sub    $0x1c,%esp
  8032cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032df:	89 ca                	mov    %ecx,%edx
  8032e1:	89 f8                	mov    %edi,%eax
  8032e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032e7:	85 f6                	test   %esi,%esi
  8032e9:	75 2d                	jne    803318 <__udivdi3+0x50>
  8032eb:	39 cf                	cmp    %ecx,%edi
  8032ed:	77 65                	ja     803354 <__udivdi3+0x8c>
  8032ef:	89 fd                	mov    %edi,%ebp
  8032f1:	85 ff                	test   %edi,%edi
  8032f3:	75 0b                	jne    803300 <__udivdi3+0x38>
  8032f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fa:	31 d2                	xor    %edx,%edx
  8032fc:	f7 f7                	div    %edi
  8032fe:	89 c5                	mov    %eax,%ebp
  803300:	31 d2                	xor    %edx,%edx
  803302:	89 c8                	mov    %ecx,%eax
  803304:	f7 f5                	div    %ebp
  803306:	89 c1                	mov    %eax,%ecx
  803308:	89 d8                	mov    %ebx,%eax
  80330a:	f7 f5                	div    %ebp
  80330c:	89 cf                	mov    %ecx,%edi
  80330e:	89 fa                	mov    %edi,%edx
  803310:	83 c4 1c             	add    $0x1c,%esp
  803313:	5b                   	pop    %ebx
  803314:	5e                   	pop    %esi
  803315:	5f                   	pop    %edi
  803316:	5d                   	pop    %ebp
  803317:	c3                   	ret    
  803318:	39 ce                	cmp    %ecx,%esi
  80331a:	77 28                	ja     803344 <__udivdi3+0x7c>
  80331c:	0f bd fe             	bsr    %esi,%edi
  80331f:	83 f7 1f             	xor    $0x1f,%edi
  803322:	75 40                	jne    803364 <__udivdi3+0x9c>
  803324:	39 ce                	cmp    %ecx,%esi
  803326:	72 0a                	jb     803332 <__udivdi3+0x6a>
  803328:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80332c:	0f 87 9e 00 00 00    	ja     8033d0 <__udivdi3+0x108>
  803332:	b8 01 00 00 00       	mov    $0x1,%eax
  803337:	89 fa                	mov    %edi,%edx
  803339:	83 c4 1c             	add    $0x1c,%esp
  80333c:	5b                   	pop    %ebx
  80333d:	5e                   	pop    %esi
  80333e:	5f                   	pop    %edi
  80333f:	5d                   	pop    %ebp
  803340:	c3                   	ret    
  803341:	8d 76 00             	lea    0x0(%esi),%esi
  803344:	31 ff                	xor    %edi,%edi
  803346:	31 c0                	xor    %eax,%eax
  803348:	89 fa                	mov    %edi,%edx
  80334a:	83 c4 1c             	add    $0x1c,%esp
  80334d:	5b                   	pop    %ebx
  80334e:	5e                   	pop    %esi
  80334f:	5f                   	pop    %edi
  803350:	5d                   	pop    %ebp
  803351:	c3                   	ret    
  803352:	66 90                	xchg   %ax,%ax
  803354:	89 d8                	mov    %ebx,%eax
  803356:	f7 f7                	div    %edi
  803358:	31 ff                	xor    %edi,%edi
  80335a:	89 fa                	mov    %edi,%edx
  80335c:	83 c4 1c             	add    $0x1c,%esp
  80335f:	5b                   	pop    %ebx
  803360:	5e                   	pop    %esi
  803361:	5f                   	pop    %edi
  803362:	5d                   	pop    %ebp
  803363:	c3                   	ret    
  803364:	bd 20 00 00 00       	mov    $0x20,%ebp
  803369:	89 eb                	mov    %ebp,%ebx
  80336b:	29 fb                	sub    %edi,%ebx
  80336d:	89 f9                	mov    %edi,%ecx
  80336f:	d3 e6                	shl    %cl,%esi
  803371:	89 c5                	mov    %eax,%ebp
  803373:	88 d9                	mov    %bl,%cl
  803375:	d3 ed                	shr    %cl,%ebp
  803377:	89 e9                	mov    %ebp,%ecx
  803379:	09 f1                	or     %esi,%ecx
  80337b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80337f:	89 f9                	mov    %edi,%ecx
  803381:	d3 e0                	shl    %cl,%eax
  803383:	89 c5                	mov    %eax,%ebp
  803385:	89 d6                	mov    %edx,%esi
  803387:	88 d9                	mov    %bl,%cl
  803389:	d3 ee                	shr    %cl,%esi
  80338b:	89 f9                	mov    %edi,%ecx
  80338d:	d3 e2                	shl    %cl,%edx
  80338f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803393:	88 d9                	mov    %bl,%cl
  803395:	d3 e8                	shr    %cl,%eax
  803397:	09 c2                	or     %eax,%edx
  803399:	89 d0                	mov    %edx,%eax
  80339b:	89 f2                	mov    %esi,%edx
  80339d:	f7 74 24 0c          	divl   0xc(%esp)
  8033a1:	89 d6                	mov    %edx,%esi
  8033a3:	89 c3                	mov    %eax,%ebx
  8033a5:	f7 e5                	mul    %ebp
  8033a7:	39 d6                	cmp    %edx,%esi
  8033a9:	72 19                	jb     8033c4 <__udivdi3+0xfc>
  8033ab:	74 0b                	je     8033b8 <__udivdi3+0xf0>
  8033ad:	89 d8                	mov    %ebx,%eax
  8033af:	31 ff                	xor    %edi,%edi
  8033b1:	e9 58 ff ff ff       	jmp    80330e <__udivdi3+0x46>
  8033b6:	66 90                	xchg   %ax,%ax
  8033b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033bc:	89 f9                	mov    %edi,%ecx
  8033be:	d3 e2                	shl    %cl,%edx
  8033c0:	39 c2                	cmp    %eax,%edx
  8033c2:	73 e9                	jae    8033ad <__udivdi3+0xe5>
  8033c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033c7:	31 ff                	xor    %edi,%edi
  8033c9:	e9 40 ff ff ff       	jmp    80330e <__udivdi3+0x46>
  8033ce:	66 90                	xchg   %ax,%ax
  8033d0:	31 c0                	xor    %eax,%eax
  8033d2:	e9 37 ff ff ff       	jmp    80330e <__udivdi3+0x46>
  8033d7:	90                   	nop

008033d8 <__umoddi3>:
  8033d8:	55                   	push   %ebp
  8033d9:	57                   	push   %edi
  8033da:	56                   	push   %esi
  8033db:	53                   	push   %ebx
  8033dc:	83 ec 1c             	sub    $0x1c,%esp
  8033df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033f7:	89 f3                	mov    %esi,%ebx
  8033f9:	89 fa                	mov    %edi,%edx
  8033fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ff:	89 34 24             	mov    %esi,(%esp)
  803402:	85 c0                	test   %eax,%eax
  803404:	75 1a                	jne    803420 <__umoddi3+0x48>
  803406:	39 f7                	cmp    %esi,%edi
  803408:	0f 86 a2 00 00 00    	jbe    8034b0 <__umoddi3+0xd8>
  80340e:	89 c8                	mov    %ecx,%eax
  803410:	89 f2                	mov    %esi,%edx
  803412:	f7 f7                	div    %edi
  803414:	89 d0                	mov    %edx,%eax
  803416:	31 d2                	xor    %edx,%edx
  803418:	83 c4 1c             	add    $0x1c,%esp
  80341b:	5b                   	pop    %ebx
  80341c:	5e                   	pop    %esi
  80341d:	5f                   	pop    %edi
  80341e:	5d                   	pop    %ebp
  80341f:	c3                   	ret    
  803420:	39 f0                	cmp    %esi,%eax
  803422:	0f 87 ac 00 00 00    	ja     8034d4 <__umoddi3+0xfc>
  803428:	0f bd e8             	bsr    %eax,%ebp
  80342b:	83 f5 1f             	xor    $0x1f,%ebp
  80342e:	0f 84 ac 00 00 00    	je     8034e0 <__umoddi3+0x108>
  803434:	bf 20 00 00 00       	mov    $0x20,%edi
  803439:	29 ef                	sub    %ebp,%edi
  80343b:	89 fe                	mov    %edi,%esi
  80343d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803441:	89 e9                	mov    %ebp,%ecx
  803443:	d3 e0                	shl    %cl,%eax
  803445:	89 d7                	mov    %edx,%edi
  803447:	89 f1                	mov    %esi,%ecx
  803449:	d3 ef                	shr    %cl,%edi
  80344b:	09 c7                	or     %eax,%edi
  80344d:	89 e9                	mov    %ebp,%ecx
  80344f:	d3 e2                	shl    %cl,%edx
  803451:	89 14 24             	mov    %edx,(%esp)
  803454:	89 d8                	mov    %ebx,%eax
  803456:	d3 e0                	shl    %cl,%eax
  803458:	89 c2                	mov    %eax,%edx
  80345a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80345e:	d3 e0                	shl    %cl,%eax
  803460:	89 44 24 04          	mov    %eax,0x4(%esp)
  803464:	8b 44 24 08          	mov    0x8(%esp),%eax
  803468:	89 f1                	mov    %esi,%ecx
  80346a:	d3 e8                	shr    %cl,%eax
  80346c:	09 d0                	or     %edx,%eax
  80346e:	d3 eb                	shr    %cl,%ebx
  803470:	89 da                	mov    %ebx,%edx
  803472:	f7 f7                	div    %edi
  803474:	89 d3                	mov    %edx,%ebx
  803476:	f7 24 24             	mull   (%esp)
  803479:	89 c6                	mov    %eax,%esi
  80347b:	89 d1                	mov    %edx,%ecx
  80347d:	39 d3                	cmp    %edx,%ebx
  80347f:	0f 82 87 00 00 00    	jb     80350c <__umoddi3+0x134>
  803485:	0f 84 91 00 00 00    	je     80351c <__umoddi3+0x144>
  80348b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80348f:	29 f2                	sub    %esi,%edx
  803491:	19 cb                	sbb    %ecx,%ebx
  803493:	89 d8                	mov    %ebx,%eax
  803495:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803499:	d3 e0                	shl    %cl,%eax
  80349b:	89 e9                	mov    %ebp,%ecx
  80349d:	d3 ea                	shr    %cl,%edx
  80349f:	09 d0                	or     %edx,%eax
  8034a1:	89 e9                	mov    %ebp,%ecx
  8034a3:	d3 eb                	shr    %cl,%ebx
  8034a5:	89 da                	mov    %ebx,%edx
  8034a7:	83 c4 1c             	add    $0x1c,%esp
  8034aa:	5b                   	pop    %ebx
  8034ab:	5e                   	pop    %esi
  8034ac:	5f                   	pop    %edi
  8034ad:	5d                   	pop    %ebp
  8034ae:	c3                   	ret    
  8034af:	90                   	nop
  8034b0:	89 fd                	mov    %edi,%ebp
  8034b2:	85 ff                	test   %edi,%edi
  8034b4:	75 0b                	jne    8034c1 <__umoddi3+0xe9>
  8034b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034bb:	31 d2                	xor    %edx,%edx
  8034bd:	f7 f7                	div    %edi
  8034bf:	89 c5                	mov    %eax,%ebp
  8034c1:	89 f0                	mov    %esi,%eax
  8034c3:	31 d2                	xor    %edx,%edx
  8034c5:	f7 f5                	div    %ebp
  8034c7:	89 c8                	mov    %ecx,%eax
  8034c9:	f7 f5                	div    %ebp
  8034cb:	89 d0                	mov    %edx,%eax
  8034cd:	e9 44 ff ff ff       	jmp    803416 <__umoddi3+0x3e>
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	89 c8                	mov    %ecx,%eax
  8034d6:	89 f2                	mov    %esi,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	3b 04 24             	cmp    (%esp),%eax
  8034e3:	72 06                	jb     8034eb <__umoddi3+0x113>
  8034e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034e9:	77 0f                	ja     8034fa <__umoddi3+0x122>
  8034eb:	89 f2                	mov    %esi,%edx
  8034ed:	29 f9                	sub    %edi,%ecx
  8034ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034f3:	89 14 24             	mov    %edx,(%esp)
  8034f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034fe:	8b 14 24             	mov    (%esp),%edx
  803501:	83 c4 1c             	add    $0x1c,%esp
  803504:	5b                   	pop    %ebx
  803505:	5e                   	pop    %esi
  803506:	5f                   	pop    %edi
  803507:	5d                   	pop    %ebp
  803508:	c3                   	ret    
  803509:	8d 76 00             	lea    0x0(%esi),%esi
  80350c:	2b 04 24             	sub    (%esp),%eax
  80350f:	19 fa                	sbb    %edi,%edx
  803511:	89 d1                	mov    %edx,%ecx
  803513:	89 c6                	mov    %eax,%esi
  803515:	e9 71 ff ff ff       	jmp    80348b <__umoddi3+0xb3>
  80351a:	66 90                	xchg   %ax,%ax
  80351c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803520:	72 ea                	jb     80350c <__umoddi3+0x134>
  803522:	89 d9                	mov    %ebx,%ecx
  803524:	e9 62 ff ff ff       	jmp    80348b <__umoddi3+0xb3>
