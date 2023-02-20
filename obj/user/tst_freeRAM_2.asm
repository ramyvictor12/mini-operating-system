
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 20 38 80 00       	push   $0x803820
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 50 80 00       	mov    0x805020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 52 38 80 00       	push   $0x803852
  8000bf:	e8 34 1f 00 00       	call   801ff8 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 b7 1c 00 00       	call   801d86 <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 56 38 80 00       	push   $0x803856
  8000fa:	e8 f9 1e 00 00       	call   801ff8 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 79 1c 00 00       	call   801d86 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 d2 33 00 00       	call   8034f3 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 65 38 80 00       	push   $0x803865
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 70 38 80 00       	push   $0x803870
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 50 80 00       	mov    0x805020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 94 38 80 00       	push   $0x803894
  80016c:	e8 87 1e 00 00       	call   801ff8 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 6f 33 00 00       	call   8034f3 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 65 38 80 00       	push   $0x803865
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 9c 38 80 00       	push   $0x80389c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 64 1e 00 00       	call   802016 <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 b9 38 80 00       	push   $0x8038b9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 21 33 00 00       	call   8034f3 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 3c 17 00 00       	call   801922 <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 f8 16 00 00       	call   801922 <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 1b 1b 00 00       	call   801d86 <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 a5 16 00 00       	call   801922 <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 54 16 00 00       	call   801922 <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 d0 38 80 00       	push   $0x8038d0
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 ac 1c 00 00       	call   802016 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 b9 38 80 00       	push   $0x8038b9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 69 31 00 00       	call   8034f3 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 f4 19 00 00       	call   801d86 <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 79 15 00 00       	call   801922 <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 2f 15 00 00       	call   801922 <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 f4 38 80 00       	push   $0x8038f4
  800449:	6a 62                	push   $0x62
  80044b:	68 29 39 80 00       	push   $0x803929
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 f4 38 80 00       	push   $0x8038f4
  80047e:	6a 63                	push   $0x63
  800480:	68 29 39 80 00       	push   $0x803929
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 f4 38 80 00       	push   $0x8038f4
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 29 39 80 00       	push   $0x803929
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 f4 38 80 00       	push   $0x8038f4
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 29 39 80 00       	push   $0x803929
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 f4 38 80 00       	push   $0x8038f4
  80051a:	6a 66                	push   $0x66
  80051c:	68 29 39 80 00       	push   $0x803929
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 f4 38 80 00       	push   $0x8038f4
  80054e:	6a 68                	push   $0x68
  800550:	68 29 39 80 00       	push   $0x803929
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 f4 38 80 00       	push   $0x8038f4
  800588:	6a 69                	push   $0x69
  80058a:	68 29 39 80 00       	push   $0x803929
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 f4 38 80 00       	push   $0x8038f4
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 29 39 80 00       	push   $0x803929
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 40 39 80 00       	push   $0x803940
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 79 1a 00 00       	call   802066 <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 50 80 00       	mov    0x805020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 1b 18 00 00       	call   801e73 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 94 39 80 00       	push   $0x803994
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 bc 39 80 00       	push   $0x8039bc
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 e4 39 80 00       	push   $0x8039e4
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 3c 3a 80 00       	push   $0x803a3c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 94 39 80 00       	push   $0x803994
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 9b 17 00 00       	call   801e8d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 28 19 00 00       	call   802032 <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 7d 19 00 00       	call   802098 <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 50 3a 80 00       	push   $0x803a50
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 55 3a 80 00       	push   $0x803a55
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 71 3a 80 00       	push   $0x803a71
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 50 80 00       	mov    0x805020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 74 3a 80 00       	push   $0x803a74
  8007ad:	6a 26                	push   $0x26
  8007af:	68 c0 3a 80 00       	push   $0x803ac0
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 50 80 00       	mov    0x805020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 cc 3a 80 00       	push   $0x803acc
  80087f:	6a 3a                	push   $0x3a
  800881:	68 c0 3a 80 00       	push   $0x803ac0
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 20 3b 80 00       	push   $0x803b20
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 c0 3a 80 00       	push   $0x803ac0
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 50 80 00       	mov    0x805024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 7c 13 00 00       	call   801cc5 <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 50 80 00       	mov    0x805024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 05 13 00 00       	call   801cc5 <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 69 14 00 00       	call   801e73 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 63 14 00 00       	call   801e8d <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 34 2b 00 00       	call   8035a8 <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 f4 2b 00 00       	call   8036b8 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 94 3d 80 00       	add    $0x803d94,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 a5 3d 80 00       	push   $0x803da5
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 ae 3d 80 00       	push   $0x803dae
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be b1 3d 80 00       	mov    $0x803db1,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 50 80 00       	mov    0x805004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 10 3f 80 00       	push   $0x803f10
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801793:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80179a:	00 00 00 
  80179d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017a4:	00 00 00 
  8017a7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017ae:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8017b1:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017b8:	00 00 00 
  8017bb:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017c2:	00 00 00 
  8017c5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017cc:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8017cf:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017d6:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8017d9:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8017e0:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8017e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ef:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f4:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8017f9:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801808:	2d 00 10 00 00       	sub    $0x1000,%eax
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	6a 06                	push   $0x6
  801812:	ff 75 f4             	pushl  -0xc(%ebp)
  801815:	50                   	push   %eax
  801816:	e8 ee 05 00 00       	call   801e09 <sys_allocate_chunk>
  80181b:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80181e:	a1 20 51 80 00       	mov    0x805120,%eax
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	50                   	push   %eax
  801827:	e8 63 0c 00 00       	call   80248f <initialize_MemBlocksList>
  80182c:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80182f:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801834:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801837:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801841:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801844:	8b 40 0c             	mov    0xc(%eax),%eax
  801847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80184a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801852:	89 c2                	mov    %eax,%edx
  801854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801857:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80185a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801864:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80186b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186e:	8b 50 08             	mov    0x8(%eax),%edx
  801871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801874:	01 d0                	add    %edx,%eax
  801876:	48                   	dec    %eax
  801877:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80187a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80187d:	ba 00 00 00 00       	mov    $0x0,%edx
  801882:	f7 75 e0             	divl   -0x20(%ebp)
  801885:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801888:	29 d0                	sub    %edx,%eax
  80188a:	89 c2                	mov    %eax,%edx
  80188c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188f:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801892:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801896:	75 14                	jne    8018ac <initialize_dyn_block_system+0x11f>
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	68 35 3f 80 00       	push   $0x803f35
  8018a0:	6a 34                	push   $0x34
  8018a2:	68 53 3f 80 00       	push   $0x803f53
  8018a7:	e8 72 ee ff ff       	call   80071e <_panic>
  8018ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018af:	8b 00                	mov    (%eax),%eax
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	74 10                	je     8018c5 <initialize_dyn_block_system+0x138>
  8018b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b8:	8b 00                	mov    (%eax),%eax
  8018ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018bd:	8b 52 04             	mov    0x4(%edx),%edx
  8018c0:	89 50 04             	mov    %edx,0x4(%eax)
  8018c3:	eb 0b                	jmp    8018d0 <initialize_dyn_block_system+0x143>
  8018c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c8:	8b 40 04             	mov    0x4(%eax),%eax
  8018cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d3:	8b 40 04             	mov    0x4(%eax),%eax
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	74 0f                	je     8018e9 <initialize_dyn_block_system+0x15c>
  8018da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018dd:	8b 40 04             	mov    0x4(%eax),%eax
  8018e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e3:	8b 12                	mov    (%edx),%edx
  8018e5:	89 10                	mov    %edx,(%eax)
  8018e7:	eb 0a                	jmp    8018f3 <initialize_dyn_block_system+0x166>
  8018e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ec:	8b 00                	mov    (%eax),%eax
  8018ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8018f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801906:	a1 54 51 80 00       	mov    0x805154,%eax
  80190b:	48                   	dec    %eax
  80190c:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	ff 75 e8             	pushl  -0x18(%ebp)
  801917:	e8 c4 13 00 00       	call   802ce0 <insert_sorted_with_merge_freeList>
  80191c:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80191f:	90                   	nop
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801928:	e8 2f fe ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  80192d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801931:	75 07                	jne    80193a <malloc+0x18>
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
  801938:	eb 71                	jmp    8019ab <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80193a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801941:	76 07                	jbe    80194a <malloc+0x28>
	return NULL;
  801943:	b8 00 00 00 00       	mov    $0x0,%eax
  801948:	eb 61                	jmp    8019ab <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80194a:	e8 88 08 00 00       	call   8021d7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194f:	85 c0                	test   %eax,%eax
  801951:	74 53                	je     8019a6 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801953:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80195a:	8b 55 08             	mov    0x8(%ebp),%edx
  80195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801960:	01 d0                	add    %edx,%eax
  801962:	48                   	dec    %eax
  801963:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	f7 75 f4             	divl   -0xc(%ebp)
  801971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801974:	29 d0                	sub    %edx,%eax
  801976:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801979:	83 ec 0c             	sub    $0xc,%esp
  80197c:	ff 75 ec             	pushl  -0x14(%ebp)
  80197f:	e8 d2 0d 00 00       	call   802756 <alloc_block_FF>
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80198a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80198e:	74 16                	je     8019a6 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801990:	83 ec 0c             	sub    $0xc,%esp
  801993:	ff 75 e8             	pushl  -0x18(%ebp)
  801996:	e8 0c 0c 00 00       	call   8025a7 <insert_sorted_allocList>
  80199b:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80199e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a1:	8b 40 08             	mov    0x8(%eax),%eax
  8019a4:	eb 05                	jmp    8019ab <malloc+0x89>
    }

			}


	return NULL;
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ca:	68 40 50 80 00       	push   $0x805040
  8019cf:	e8 a0 0b 00 00       	call   802574 <find_block>
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8019da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	52                   	push   %edx
  8019e7:	50                   	push   %eax
  8019e8:	e8 e4 03 00 00       	call   801dd1 <sys_free_user_mem>
  8019ed:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8019f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019f4:	75 17                	jne    801a0d <free+0x60>
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	68 35 3f 80 00       	push   $0x803f35
  8019fe:	68 84 00 00 00       	push   $0x84
  801a03:	68 53 3f 80 00       	push   $0x803f53
  801a08:	e8 11 ed ff ff       	call   80071e <_panic>
  801a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a10:	8b 00                	mov    (%eax),%eax
  801a12:	85 c0                	test   %eax,%eax
  801a14:	74 10                	je     801a26 <free+0x79>
  801a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a1e:	8b 52 04             	mov    0x4(%edx),%edx
  801a21:	89 50 04             	mov    %edx,0x4(%eax)
  801a24:	eb 0b                	jmp    801a31 <free+0x84>
  801a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a29:	8b 40 04             	mov    0x4(%eax),%eax
  801a2c:	a3 44 50 80 00       	mov    %eax,0x805044
  801a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a34:	8b 40 04             	mov    0x4(%eax),%eax
  801a37:	85 c0                	test   %eax,%eax
  801a39:	74 0f                	je     801a4a <free+0x9d>
  801a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3e:	8b 40 04             	mov    0x4(%eax),%eax
  801a41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a44:	8b 12                	mov    (%edx),%edx
  801a46:	89 10                	mov    %edx,(%eax)
  801a48:	eb 0a                	jmp    801a54 <free+0xa7>
  801a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4d:	8b 00                	mov    (%eax),%eax
  801a4f:	a3 40 50 80 00       	mov    %eax,0x805040
  801a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a67:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a6c:	48                   	dec    %eax
  801a6d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	ff 75 ec             	pushl  -0x14(%ebp)
  801a78:	e8 63 12 00 00       	call   802ce0 <insert_sorted_with_merge_freeList>
  801a7d:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 38             	sub    $0x38,%esp
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a8f:	e8 c8 fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801a94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a98:	75 0a                	jne    801aa4 <smalloc+0x21>
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9f:	e9 a0 00 00 00       	jmp    801b44 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801aa4:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801aab:	76 0a                	jbe    801ab7 <smalloc+0x34>
		return NULL;
  801aad:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab2:	e9 8d 00 00 00       	jmp    801b44 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ab7:	e8 1b 07 00 00       	call   8021d7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801abc:	85 c0                	test   %eax,%eax
  801abe:	74 7f                	je     801b3f <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801ac0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acd:	01 d0                	add    %edx,%eax
  801acf:	48                   	dec    %eax
  801ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  801adb:	f7 75 f4             	divl   -0xc(%ebp)
  801ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae1:	29 d0                	sub    %edx,%eax
  801ae3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801ae6:	83 ec 0c             	sub    $0xc,%esp
  801ae9:	ff 75 ec             	pushl  -0x14(%ebp)
  801aec:	e8 65 0c 00 00       	call   802756 <alloc_block_FF>
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801af7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801afb:	74 42                	je     801b3f <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 75 e8             	pushl  -0x18(%ebp)
  801b03:	e8 9f 0a 00 00       	call   8025a7 <insert_sorted_allocList>
  801b08:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0e:	8b 40 08             	mov    0x8(%eax),%eax
  801b11:	89 c2                	mov    %eax,%edx
  801b13:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b17:	52                   	push   %edx
  801b18:	50                   	push   %eax
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	e8 38 04 00 00       	call   801f5c <sys_createSharedObject>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801b2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b2e:	79 07                	jns    801b37 <smalloc+0xb4>
	    		  return NULL;
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
  801b35:	eb 0d                	jmp    801b44 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b3a:	8b 40 08             	mov    0x8(%eax),%eax
  801b3d:	eb 05                	jmp    801b44 <smalloc+0xc1>


				}


		return NULL;
  801b3f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b4c:	e8 0b fc ff ff       	call   80175c <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b51:	e8 81 06 00 00       	call   8021d7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b56:	85 c0                	test   %eax,%eax
  801b58:	0f 84 9f 00 00 00    	je     801bfd <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	e8 1a 04 00 00       	call   801f86 <sys_getSizeOfSharedObject>
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b76:	79 0a                	jns    801b82 <sget+0x3c>
		return NULL;
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7d:	e9 80 00 00 00       	jmp    801c02 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b82:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8f:	01 d0                	add    %edx,%eax
  801b91:	48                   	dec    %eax
  801b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b98:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9d:	f7 75 f0             	divl   -0x10(%ebp)
  801ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba3:	29 d0                	sub    %edx,%eax
  801ba5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	ff 75 e8             	pushl  -0x18(%ebp)
  801bae:	e8 a3 0b 00 00       	call   802756 <alloc_block_FF>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801bb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bbd:	74 3e                	je     801bfd <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bc5:	e8 dd 09 00 00       	call   8025a7 <insert_sorted_allocList>
  801bca:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd0:	8b 40 08             	mov    0x8(%eax),%eax
  801bd3:	83 ec 04             	sub    $0x4,%esp
  801bd6:	50                   	push   %eax
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	ff 75 08             	pushl  0x8(%ebp)
  801bdd:	e8 c1 03 00 00       	call   801fa3 <sys_getSharedObject>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801be8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bec:	79 07                	jns    801bf5 <sget+0xaf>
	    		  return NULL;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	eb 0d                	jmp    801c02 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf8:	8b 40 08             	mov    0x8(%eax),%eax
  801bfb:	eb 05                	jmp    801c02 <sget+0xbc>
	      }
	}
	   return NULL;
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c0a:	e8 4d fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 60 3f 80 00       	push   $0x803f60
  801c17:	68 12 01 00 00       	push   $0x112
  801c1c:	68 53 3f 80 00       	push   $0x803f53
  801c21:	e8 f8 ea ff ff       	call   80071e <_panic>

00801c26 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	68 88 3f 80 00       	push   $0x803f88
  801c34:	68 26 01 00 00       	push   $0x126
  801c39:	68 53 3f 80 00       	push   $0x803f53
  801c3e:	e8 db ea ff ff       	call   80071e <_panic>

00801c43 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	68 ac 3f 80 00       	push   $0x803fac
  801c51:	68 31 01 00 00       	push   $0x131
  801c56:	68 53 3f 80 00       	push   $0x803f53
  801c5b:	e8 be ea ff ff       	call   80071e <_panic>

00801c60 <shrink>:

}
void shrink(uint32 newSize)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	68 ac 3f 80 00       	push   $0x803fac
  801c6e:	68 36 01 00 00       	push   $0x136
  801c73:	68 53 3f 80 00       	push   $0x803f53
  801c78:	e8 a1 ea ff ff       	call   80071e <_panic>

00801c7d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	68 ac 3f 80 00       	push   $0x803fac
  801c8b:	68 3b 01 00 00       	push   $0x13b
  801c90:	68 53 3f 80 00       	push   $0x803f53
  801c95:	e8 84 ea ff ff       	call   80071e <_panic>

00801c9a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801caf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cb2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb5:	cd 30                	int    $0x30
  801cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5f                   	pop    %edi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    

00801cc5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cd1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	52                   	push   %edx
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	e8 b2 ff ff ff       	call   801c9a <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	90                   	nop
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_cgetc>:

int
sys_cgetc(void)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 01                	push   $0x1
  801cfd:	e8 98 ff ff ff       	call   801c9a <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	6a 05                	push   $0x5
  801d1a:	e8 7b ff ff ff       	call   801c9a <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d29:	8b 75 18             	mov    0x18(%ebp),%esi
  801d2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	51                   	push   %ecx
  801d3b:	52                   	push   %edx
  801d3c:	50                   	push   %eax
  801d3d:	6a 06                	push   $0x6
  801d3f:	e8 56 ff ff ff       	call   801c9a <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 07                	push   $0x7
  801d61:	e8 34 ff ff ff       	call   801c9a <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	6a 08                	push   $0x8
  801d7c:	e8 19 ff ff ff       	call   801c9a <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 09                	push   $0x9
  801d95:	e8 00 ff ff ff       	call   801c9a <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 0a                	push   $0xa
  801dae:	e8 e7 fe ff ff       	call   801c9a <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 0b                	push   $0xb
  801dc7:	e8 ce fe ff ff       	call   801c9a <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 0f                	push   $0xf
  801de2:	e8 b3 fe ff ff       	call   801c9a <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 10                	push   $0x10
  801dfe:	e8 97 fe ff ff       	call   801c9a <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return ;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	ff 75 10             	pushl  0x10(%ebp)
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	6a 11                	push   $0x11
  801e1b:	e8 7a fe ff ff       	call   801c9a <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
	return ;
  801e23:	90                   	nop
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 0c                	push   $0xc
  801e35:	e8 60 fe ff ff       	call   801c9a <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	6a 0d                	push   $0xd
  801e4f:	e8 46 fe ff ff       	call   801c9a <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 0e                	push   $0xe
  801e68:	e8 2d fe ff ff       	call   801c9a <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	90                   	nop
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 13                	push   $0x13
  801e82:	e8 13 fe ff ff       	call   801c9a <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	90                   	nop
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 14                	push   $0x14
  801e9c:	e8 f9 fd ff ff       	call   801c9a <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	90                   	nop
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eb3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	50                   	push   %eax
  801ec0:	6a 15                	push   $0x15
  801ec2:	e8 d3 fd ff ff       	call   801c9a <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	90                   	nop
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 16                	push   $0x16
  801edc:	e8 b9 fd ff ff       	call   801c9a <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	90                   	nop
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	50                   	push   %eax
  801ef7:	6a 17                	push   $0x17
  801ef9:	e8 9c fd ff ff       	call   801c9a <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 1a                	push   $0x1a
  801f16:	e8 7f fd ff ff       	call   801c9a <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	52                   	push   %edx
  801f30:	50                   	push   %eax
  801f31:	6a 18                	push   $0x18
  801f33:	e8 62 fd ff ff       	call   801c9a <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	90                   	nop
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 19                	push   $0x19
  801f51:	e8 44 fd ff ff       	call   801c9a <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	8b 45 10             	mov    0x10(%ebp),%eax
  801f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f68:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f6b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	51                   	push   %ecx
  801f75:	52                   	push   %edx
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	50                   	push   %eax
  801f7a:	6a 1b                	push   $0x1b
  801f7c:	e8 19 fd ff ff       	call   801c9a <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	52                   	push   %edx
  801f96:	50                   	push   %eax
  801f97:	6a 1c                	push   $0x1c
  801f99:	e8 fc fc ff ff       	call   801c9a <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	51                   	push   %ecx
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 1d                	push   $0x1d
  801fb8:	e8 dd fc ff ff       	call   801c9a <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	52                   	push   %edx
  801fd2:	50                   	push   %eax
  801fd3:	6a 1e                	push   $0x1e
  801fd5:	e8 c0 fc ff ff       	call   801c9a <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 1f                	push   $0x1f
  801fee:	e8 a7 fc ff ff       	call   801c9a <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	ff 75 14             	pushl  0x14(%ebp)
  802003:	ff 75 10             	pushl  0x10(%ebp)
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	50                   	push   %eax
  80200a:	6a 20                	push   $0x20
  80200c:	e8 89 fc ff ff       	call   801c9a <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	50                   	push   %eax
  802025:	6a 21                	push   $0x21
  802027:	e8 6e fc ff ff       	call   801c9a <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	90                   	nop
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	50                   	push   %eax
  802041:	6a 22                	push   $0x22
  802043:	e8 52 fc ff ff       	call   801c9a <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 02                	push   $0x2
  80205c:	e8 39 fc ff ff       	call   801c9a <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 03                	push   $0x3
  802075:	e8 20 fc ff ff       	call   801c9a <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 04                	push   $0x4
  80208e:	e8 07 fc ff ff       	call   801c9a <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_exit_env>:


void sys_exit_env(void)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 23                	push   $0x23
  8020a7:	e8 ee fb ff ff       	call   801c9a <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	90                   	nop
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020bb:	8d 50 04             	lea    0x4(%eax),%edx
  8020be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	52                   	push   %edx
  8020c8:	50                   	push   %eax
  8020c9:	6a 24                	push   $0x24
  8020cb:	e8 ca fb ff ff       	call   801c9a <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
	return result;
  8020d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020dc:	89 01                	mov    %eax,(%ecx)
  8020de:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	c9                   	leave  
  8020e5:	c2 04 00             	ret    $0x4

008020e8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	ff 75 10             	pushl  0x10(%ebp)
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	6a 12                	push   $0x12
  8020fa:	e8 9b fb ff ff       	call   801c9a <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802102:	90                   	nop
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_rcr2>:
uint32 sys_rcr2()
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 25                	push   $0x25
  802114:	e8 81 fb ff ff       	call   801c9a <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80212a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	50                   	push   %eax
  802137:	6a 26                	push   $0x26
  802139:	e8 5c fb ff ff       	call   801c9a <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
	return ;
  802141:	90                   	nop
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <rsttst>:
void rsttst()
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 28                	push   $0x28
  802153:	e8 42 fb ff ff       	call   801c9a <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
	return ;
  80215b:	90                   	nop
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	8b 45 14             	mov    0x14(%ebp),%eax
  802167:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80216a:	8b 55 18             	mov    0x18(%ebp),%edx
  80216d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802171:	52                   	push   %edx
  802172:	50                   	push   %eax
  802173:	ff 75 10             	pushl  0x10(%ebp)
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	ff 75 08             	pushl  0x8(%ebp)
  80217c:	6a 27                	push   $0x27
  80217e:	e8 17 fb ff ff       	call   801c9a <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
	return ;
  802186:	90                   	nop
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <chktst>:
void chktst(uint32 n)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	ff 75 08             	pushl  0x8(%ebp)
  802197:	6a 29                	push   $0x29
  802199:	e8 fc fa ff ff       	call   801c9a <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a1:	90                   	nop
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <inctst>:

void inctst()
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 2a                	push   $0x2a
  8021b3:	e8 e2 fa ff ff       	call   801c9a <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bb:	90                   	nop
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <gettst>:
uint32 gettst()
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 2b                	push   $0x2b
  8021cd:	e8 c8 fa ff ff       	call   801c9a <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 2c                	push   $0x2c
  8021e9:	e8 ac fa ff ff       	call   801c9a <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
  8021f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021f8:	75 07                	jne    802201 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ff:	eb 05                	jmp    802206 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 2c                	push   $0x2c
  80221a:	e8 7b fa ff ff       	call   801c9a <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
  802222:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802225:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802229:	75 07                	jne    802232 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80222b:	b8 01 00 00 00       	mov    $0x1,%eax
  802230:	eb 05                	jmp    802237 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 2c                	push   $0x2c
  80224b:	e8 4a fa ff ff       	call   801c9a <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
  802253:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802256:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80225a:	75 07                	jne    802263 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80225c:	b8 01 00 00 00       	mov    $0x1,%eax
  802261:	eb 05                	jmp    802268 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 2c                	push   $0x2c
  80227c:	e8 19 fa ff ff       	call   801c9a <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
  802284:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802287:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80228b:	75 07                	jne    802294 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80228d:	b8 01 00 00 00       	mov    $0x1,%eax
  802292:	eb 05                	jmp    802299 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	ff 75 08             	pushl  0x8(%ebp)
  8022a9:	6a 2d                	push   $0x2d
  8022ab:	e8 ea f9 ff ff       	call   801c9a <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b3:	90                   	nop
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	53                   	push   %ebx
  8022c9:	51                   	push   %ecx
  8022ca:	52                   	push   %edx
  8022cb:	50                   	push   %eax
  8022cc:	6a 2e                	push   $0x2e
  8022ce:	e8 c7 f9 ff ff       	call   801c9a <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	52                   	push   %edx
  8022eb:	50                   	push   %eax
  8022ec:	6a 2f                	push   $0x2f
  8022ee:	e8 a7 f9 ff ff       	call   801c9a <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022fe:	83 ec 0c             	sub    $0xc,%esp
  802301:	68 bc 3f 80 00       	push   $0x803fbc
  802306:	e8 c7 e6 ff ff       	call   8009d2 <cprintf>
  80230b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80230e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	68 e8 3f 80 00       	push   $0x803fe8
  80231d:	e8 b0 e6 ff ff       	call   8009d2 <cprintf>
  802322:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802325:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802329:	a1 38 51 80 00       	mov    0x805138,%eax
  80232e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802331:	eb 56                	jmp    802389 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802337:	74 1c                	je     802355 <print_mem_block_lists+0x5d>
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 50 08             	mov    0x8(%eax),%edx
  80233f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802342:	8b 48 08             	mov    0x8(%eax),%ecx
  802345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802348:	8b 40 0c             	mov    0xc(%eax),%eax
  80234b:	01 c8                	add    %ecx,%eax
  80234d:	39 c2                	cmp    %eax,%edx
  80234f:	73 04                	jae    802355 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802351:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 50 08             	mov    0x8(%eax),%edx
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 0c             	mov    0xc(%eax),%eax
  802361:	01 c2                	add    %eax,%edx
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 40 08             	mov    0x8(%eax),%eax
  802369:	83 ec 04             	sub    $0x4,%esp
  80236c:	52                   	push   %edx
  80236d:	50                   	push   %eax
  80236e:	68 fd 3f 80 00       	push   $0x803ffd
  802373:	e8 5a e6 ff ff       	call   8009d2 <cprintf>
  802378:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802381:	a1 40 51 80 00       	mov    0x805140,%eax
  802386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	74 07                	je     802396 <print_mem_block_lists+0x9e>
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	eb 05                	jmp    80239b <print_mem_block_lists+0xa3>
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
  80239b:	a3 40 51 80 00       	mov    %eax,0x805140
  8023a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	75 8a                	jne    802333 <print_mem_block_lists+0x3b>
  8023a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ad:	75 84                	jne    802333 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023af:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023b3:	75 10                	jne    8023c5 <print_mem_block_lists+0xcd>
  8023b5:	83 ec 0c             	sub    $0xc,%esp
  8023b8:	68 0c 40 80 00       	push   $0x80400c
  8023bd:	e8 10 e6 ff ff       	call   8009d2 <cprintf>
  8023c2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023cc:	83 ec 0c             	sub    $0xc,%esp
  8023cf:	68 30 40 80 00       	push   $0x804030
  8023d4:	e8 f9 e5 ff ff       	call   8009d2 <cprintf>
  8023d9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023dc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e8:	eb 56                	jmp    802440 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ee:	74 1c                	je     80240c <print_mem_block_lists+0x114>
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 50 08             	mov    0x8(%eax),%edx
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	01 c8                	add    %ecx,%eax
  802404:	39 c2                	cmp    %eax,%edx
  802406:	73 04                	jae    80240c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802408:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 50 08             	mov    0x8(%eax),%edx
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	01 c2                	add    %eax,%edx
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 08             	mov    0x8(%eax),%eax
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	68 fd 3f 80 00       	push   $0x803ffd
  80242a:	e8 a3 e5 ff ff       	call   8009d2 <cprintf>
  80242f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802438:	a1 48 50 80 00       	mov    0x805048,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	74 07                	je     80244d <print_mem_block_lists+0x155>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	eb 05                	jmp    802452 <print_mem_block_lists+0x15a>
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	a3 48 50 80 00       	mov    %eax,0x805048
  802457:	a1 48 50 80 00       	mov    0x805048,%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	75 8a                	jne    8023ea <print_mem_block_lists+0xf2>
  802460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802464:	75 84                	jne    8023ea <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802466:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80246a:	75 10                	jne    80247c <print_mem_block_lists+0x184>
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	68 48 40 80 00       	push   $0x804048
  802474:	e8 59 e5 ff ff       	call   8009d2 <cprintf>
  802479:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80247c:	83 ec 0c             	sub    $0xc,%esp
  80247f:	68 bc 3f 80 00       	push   $0x803fbc
  802484:	e8 49 e5 ff ff       	call   8009d2 <cprintf>
  802489:	83 c4 10             	add    $0x10,%esp

}
  80248c:	90                   	nop
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802495:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80249c:	00 00 00 
  80249f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024a6:	00 00 00 
  8024a9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024b0:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8024b3:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8024bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024c2:	e9 9e 00 00 00       	jmp    802565 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8024c7:	a1 50 50 80 00       	mov    0x805050,%eax
  8024cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cf:	c1 e2 04             	shl    $0x4,%edx
  8024d2:	01 d0                	add    %edx,%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	75 14                	jne    8024ec <initialize_MemBlocksList+0x5d>
  8024d8:	83 ec 04             	sub    $0x4,%esp
  8024db:	68 70 40 80 00       	push   $0x804070
  8024e0:	6a 48                	push   $0x48
  8024e2:	68 93 40 80 00       	push   $0x804093
  8024e7:	e8 32 e2 ff ff       	call   80071e <_panic>
  8024ec:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f4:	c1 e2 04             	shl    $0x4,%edx
  8024f7:	01 d0                	add    %edx,%eax
  8024f9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024ff:	89 10                	mov    %edx,(%eax)
  802501:	8b 00                	mov    (%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 18                	je     80251f <initialize_MemBlocksList+0x90>
  802507:	a1 48 51 80 00       	mov    0x805148,%eax
  80250c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802512:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802515:	c1 e1 04             	shl    $0x4,%ecx
  802518:	01 ca                	add    %ecx,%edx
  80251a:	89 50 04             	mov    %edx,0x4(%eax)
  80251d:	eb 12                	jmp    802531 <initialize_MemBlocksList+0xa2>
  80251f:	a1 50 50 80 00       	mov    0x805050,%eax
  802524:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802527:	c1 e2 04             	shl    $0x4,%edx
  80252a:	01 d0                	add    %edx,%eax
  80252c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802531:	a1 50 50 80 00       	mov    0x805050,%eax
  802536:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802539:	c1 e2 04             	shl    $0x4,%edx
  80253c:	01 d0                	add    %edx,%eax
  80253e:	a3 48 51 80 00       	mov    %eax,0x805148
  802543:	a1 50 50 80 00       	mov    0x805050,%eax
  802548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254b:	c1 e2 04             	shl    $0x4,%edx
  80254e:	01 d0                	add    %edx,%eax
  802550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802557:	a1 54 51 80 00       	mov    0x805154,%eax
  80255c:	40                   	inc    %eax
  80255d:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802562:	ff 45 f4             	incl   -0xc(%ebp)
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256b:	0f 82 56 ff ff ff    	jb     8024c7 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802571:	90                   	nop
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802582:	eb 18                	jmp    80259c <find_block+0x28>
		{
			if(tmp->sva==va)
  802584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802587:	8b 40 08             	mov    0x8(%eax),%eax
  80258a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80258d:	75 05                	jne    802594 <find_block+0x20>
			{
				return tmp;
  80258f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802592:	eb 11                	jmp    8025a5 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802594:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80259c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025a0:	75 e2                	jne    802584 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8025a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8025ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	0f 85 83 00 00 00    	jne    80263d <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8025ba:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8025c1:	00 00 00 
  8025c4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8025cb:	00 00 00 
  8025ce:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8025d5:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8025d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025dc:	75 14                	jne    8025f2 <insert_sorted_allocList+0x4b>
  8025de:	83 ec 04             	sub    $0x4,%esp
  8025e1:	68 70 40 80 00       	push   $0x804070
  8025e6:	6a 7f                	push   $0x7f
  8025e8:	68 93 40 80 00       	push   $0x804093
  8025ed:	e8 2c e1 ff ff       	call   80071e <_panic>
  8025f2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	89 10                	mov    %edx,(%eax)
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	8b 00                	mov    (%eax),%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	74 0d                	je     802613 <insert_sorted_allocList+0x6c>
  802606:	a1 40 50 80 00       	mov    0x805040,%eax
  80260b:	8b 55 08             	mov    0x8(%ebp),%edx
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	eb 08                	jmp    80261b <insert_sorted_allocList+0x74>
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	a3 44 50 80 00       	mov    %eax,0x805044
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	a3 40 50 80 00       	mov    %eax,0x805040
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802632:	40                   	inc    %eax
  802633:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802638:	e9 16 01 00 00       	jmp    802753 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	8b 50 08             	mov    0x8(%eax),%edx
  802643:	a1 44 50 80 00       	mov    0x805044,%eax
  802648:	8b 40 08             	mov    0x8(%eax),%eax
  80264b:	39 c2                	cmp    %eax,%edx
  80264d:	76 68                	jbe    8026b7 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80264f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802653:	75 17                	jne    80266c <insert_sorted_allocList+0xc5>
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	68 ac 40 80 00       	push   $0x8040ac
  80265d:	68 85 00 00 00       	push   $0x85
  802662:	68 93 40 80 00       	push   $0x804093
  802667:	e8 b2 e0 ff ff       	call   80071e <_panic>
  80266c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	74 0c                	je     80268e <insert_sorted_allocList+0xe7>
  802682:	a1 44 50 80 00       	mov    0x805044,%eax
  802687:	8b 55 08             	mov    0x8(%ebp),%edx
  80268a:	89 10                	mov    %edx,(%eax)
  80268c:	eb 08                	jmp    802696 <insert_sorted_allocList+0xef>
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	a3 40 50 80 00       	mov    %eax,0x805040
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	a3 44 50 80 00       	mov    %eax,0x805044
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026ac:	40                   	inc    %eax
  8026ad:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026b2:	e9 9c 00 00 00       	jmp    802753 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8026b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8026bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8026bf:	e9 85 00 00 00       	jmp    802749 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 08             	mov    0x8(%eax),%eax
  8026d0:	39 c2                	cmp    %eax,%edx
  8026d2:	73 6d                	jae    802741 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8026d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d8:	74 06                	je     8026e0 <insert_sorted_allocList+0x139>
  8026da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026de:	75 17                	jne    8026f7 <insert_sorted_allocList+0x150>
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	68 d0 40 80 00       	push   $0x8040d0
  8026e8:	68 90 00 00 00       	push   $0x90
  8026ed:	68 93 40 80 00       	push   $0x804093
  8026f2:	e8 27 e0 ff ff       	call   80071e <_panic>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 50 04             	mov    0x4(%eax),%edx
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	89 50 04             	mov    %edx,0x4(%eax)
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	89 10                	mov    %edx,(%eax)
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 0d                	je     802722 <insert_sorted_allocList+0x17b>
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 40 04             	mov    0x4(%eax),%eax
  80271b:	8b 55 08             	mov    0x8(%ebp),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 08                	jmp    80272a <insert_sorted_allocList+0x183>
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	a3 40 50 80 00       	mov    %eax,0x805040
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 55 08             	mov    0x8(%ebp),%edx
  802730:	89 50 04             	mov    %edx,0x4(%eax)
  802733:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802738:	40                   	inc    %eax
  802739:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80273e:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80273f:	eb 12                	jmp    802753 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274d:	0f 85 71 ff ff ff    	jne    8026c4 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802753:	90                   	nop
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80275c:	a1 38 51 80 00       	mov    0x805138,%eax
  802761:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802764:	e9 76 01 00 00       	jmp    8028df <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802772:	0f 85 8a 00 00 00    	jne    802802 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	75 17                	jne    802795 <alloc_block_FF+0x3f>
  80277e:	83 ec 04             	sub    $0x4,%esp
  802781:	68 05 41 80 00       	push   $0x804105
  802786:	68 a8 00 00 00       	push   $0xa8
  80278b:	68 93 40 80 00       	push   $0x804093
  802790:	e8 89 df ff ff       	call   80071e <_panic>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 10                	je     8027ae <alloc_block_FF+0x58>
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a6:	8b 52 04             	mov    0x4(%edx),%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	eb 0b                	jmp    8027b9 <alloc_block_FF+0x63>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 0f                	je     8027d2 <alloc_block_FF+0x7c>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cc:	8b 12                	mov    (%edx),%edx
  8027ce:	89 10                	mov    %edx,(%eax)
  8027d0:	eb 0a                	jmp    8027dc <alloc_block_FF+0x86>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8027f4:	48                   	dec    %eax
  8027f5:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	e9 ea 00 00 00       	jmp    8028ec <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 0c             	mov    0xc(%eax),%eax
  802808:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280b:	0f 86 c6 00 00 00    	jbe    8028d7 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802811:	a1 48 51 80 00       	mov    0x805148,%eax
  802816:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281c:	8b 55 08             	mov    0x8(%ebp),%edx
  80281f:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 50 08             	mov    0x8(%eax),%edx
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 0c             	mov    0xc(%eax),%eax
  802834:	2b 45 08             	sub    0x8(%ebp),%eax
  802837:	89 c2                	mov    %eax,%edx
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 50 08             	mov    0x8(%eax),%edx
  802845:	8b 45 08             	mov    0x8(%ebp),%eax
  802848:	01 c2                	add    %eax,%edx
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802850:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802854:	75 17                	jne    80286d <alloc_block_FF+0x117>
  802856:	83 ec 04             	sub    $0x4,%esp
  802859:	68 05 41 80 00       	push   $0x804105
  80285e:	68 b6 00 00 00       	push   $0xb6
  802863:	68 93 40 80 00       	push   $0x804093
  802868:	e8 b1 de ff ff       	call   80071e <_panic>
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 10                	je     802886 <alloc_block_FF+0x130>
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80287e:	8b 52 04             	mov    0x4(%edx),%edx
  802881:	89 50 04             	mov    %edx,0x4(%eax)
  802884:	eb 0b                	jmp    802891 <alloc_block_FF+0x13b>
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802894:	8b 40 04             	mov    0x4(%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 0f                	je     8028aa <alloc_block_FF+0x154>
  80289b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289e:	8b 40 04             	mov    0x4(%eax),%eax
  8028a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a4:	8b 12                	mov    (%edx),%edx
  8028a6:	89 10                	mov    %edx,(%eax)
  8028a8:	eb 0a                	jmp    8028b4 <alloc_block_FF+0x15e>
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	a3 48 51 80 00       	mov    %eax,0x805148
  8028b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8028cc:	48                   	dec    %eax
  8028cd:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	eb 15                	jmp    8028ec <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8028df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e3:	0f 85 80 fe ff ff    	jne    802769 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    

008028ee <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
  8028f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8028f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8028fc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802903:	e9 c0 00 00 00       	jmp    8029c8 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 0c             	mov    0xc(%eax),%eax
  80290e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802911:	0f 85 8a 00 00 00    	jne    8029a1 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802917:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291b:	75 17                	jne    802934 <alloc_block_BF+0x46>
  80291d:	83 ec 04             	sub    $0x4,%esp
  802920:	68 05 41 80 00       	push   $0x804105
  802925:	68 cf 00 00 00       	push   $0xcf
  80292a:	68 93 40 80 00       	push   $0x804093
  80292f:	e8 ea dd ff ff       	call   80071e <_panic>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 10                	je     80294d <alloc_block_BF+0x5f>
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802945:	8b 52 04             	mov    0x4(%edx),%edx
  802948:	89 50 04             	mov    %edx,0x4(%eax)
  80294b:	eb 0b                	jmp    802958 <alloc_block_BF+0x6a>
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 40 04             	mov    0x4(%eax),%eax
  802953:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 04             	mov    0x4(%eax),%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	74 0f                	je     802971 <alloc_block_BF+0x83>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296b:	8b 12                	mov    (%edx),%edx
  80296d:	89 10                	mov    %edx,(%eax)
  80296f:	eb 0a                	jmp    80297b <alloc_block_BF+0x8d>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	a3 38 51 80 00       	mov    %eax,0x805138
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298e:	a1 44 51 80 00       	mov    0x805144,%eax
  802993:	48                   	dec    %eax
  802994:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	e9 2a 01 00 00       	jmp    802acb <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029aa:	73 14                	jae    8029c0 <alloc_block_BF+0xd2>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b5:	76 09                	jbe    8029c0 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bd:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8029c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cc:	0f 85 36 ff ff ff    	jne    802908 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8029d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8029da:	e9 dd 00 00 00       	jmp    802abc <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029e8:	0f 85 c6 00 00 00    	jne    802ab4 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8029ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8029f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 50 08             	mov    0x8(%eax),%edx
  8029fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ff:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a05:	8b 55 08             	mov    0x8(%ebp),%edx
  802a08:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 50 08             	mov    0x8(%eax),%edx
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	01 c2                	add    %eax,%edx
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	2b 45 08             	sub    0x8(%ebp),%eax
  802a25:	89 c2                	mov    %eax,%edx
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802a2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a31:	75 17                	jne    802a4a <alloc_block_BF+0x15c>
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 05 41 80 00       	push   $0x804105
  802a3b:	68 eb 00 00 00       	push   $0xeb
  802a40:	68 93 40 80 00       	push   $0x804093
  802a45:	e8 d4 dc ff ff       	call   80071e <_panic>
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	74 10                	je     802a63 <alloc_block_BF+0x175>
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a5b:	8b 52 04             	mov    0x4(%edx),%edx
  802a5e:	89 50 04             	mov    %edx,0x4(%eax)
  802a61:	eb 0b                	jmp    802a6e <alloc_block_BF+0x180>
  802a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	8b 40 04             	mov    0x4(%eax),%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	74 0f                	je     802a87 <alloc_block_BF+0x199>
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a81:	8b 12                	mov    (%edx),%edx
  802a83:	89 10                	mov    %edx,(%eax)
  802a85:	eb 0a                	jmp    802a91 <alloc_block_BF+0x1a3>
  802a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa4:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa9:	48                   	dec    %eax
  802aaa:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab2:	eb 17                	jmp    802acb <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac0:	0f 85 19 ff ff ff    	jne    8029df <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802ac6:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802acb:	c9                   	leave  
  802acc:	c3                   	ret    

00802acd <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802acd:	55                   	push   %ebp
  802ace:	89 e5                	mov    %esp,%ebp
  802ad0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802ad3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	75 19                	jne    802af5 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802adc:	83 ec 0c             	sub    $0xc,%esp
  802adf:	ff 75 08             	pushl  0x8(%ebp)
  802ae2:	e8 6f fc ff ff       	call   802756 <alloc_block_FF>
  802ae7:	83 c4 10             	add    $0x10,%esp
  802aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	e9 e9 01 00 00       	jmp    802cde <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802af5:	a1 44 50 80 00       	mov    0x805044,%eax
  802afa:	8b 40 08             	mov    0x8(%eax),%eax
  802afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802b00:	a1 44 50 80 00       	mov    0x805044,%eax
  802b05:	8b 50 0c             	mov    0xc(%eax),%edx
  802b08:	a1 44 50 80 00       	mov    0x805044,%eax
  802b0d:	8b 40 08             	mov    0x8(%eax),%eax
  802b10:	01 d0                	add    %edx,%eax
  802b12:	83 ec 08             	sub    $0x8,%esp
  802b15:	50                   	push   %eax
  802b16:	68 38 51 80 00       	push   $0x805138
  802b1b:	e8 54 fa ff ff       	call   802574 <find_block>
  802b20:	83 c4 10             	add    $0x10,%esp
  802b23:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2f:	0f 85 9b 00 00 00    	jne    802bd0 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 50 0c             	mov    0xc(%eax),%edx
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 08             	mov    0x8(%eax),%eax
  802b41:	01 d0                	add    %edx,%eax
  802b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4a:	75 17                	jne    802b63 <alloc_block_NF+0x96>
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	68 05 41 80 00       	push   $0x804105
  802b54:	68 1a 01 00 00       	push   $0x11a
  802b59:	68 93 40 80 00       	push   $0x804093
  802b5e:	e8 bb db ff ff       	call   80071e <_panic>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 10                	je     802b7c <alloc_block_NF+0xaf>
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b74:	8b 52 04             	mov    0x4(%edx),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	eb 0b                	jmp    802b87 <alloc_block_NF+0xba>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 0f                	je     802ba0 <alloc_block_NF+0xd3>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 04             	mov    0x4(%eax),%eax
  802b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9a:	8b 12                	mov    (%edx),%edx
  802b9c:	89 10                	mov    %edx,(%eax)
  802b9e:	eb 0a                	jmp    802baa <alloc_block_NF+0xdd>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	a3 38 51 80 00       	mov    %eax,0x805138
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbd:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc2:	48                   	dec    %eax
  802bc3:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	e9 0e 01 00 00       	jmp    802cde <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd9:	0f 86 cf 00 00 00    	jbe    802cae <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802bdf:	a1 48 51 80 00       	mov    0x805148,%eax
  802be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bea:	8b 55 08             	mov    0x8(%ebp),%edx
  802bed:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 50 08             	mov    0x8(%eax),%edx
  802bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf9:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 50 08             	mov    0x8(%eax),%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	01 c2                	add    %eax,%edx
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	2b 45 08             	sub    0x8(%ebp),%eax
  802c16:	89 c2                	mov    %eax,%edx
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802c27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c2b:	75 17                	jne    802c44 <alloc_block_NF+0x177>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 05 41 80 00       	push   $0x804105
  802c35:	68 28 01 00 00       	push   $0x128
  802c3a:	68 93 40 80 00       	push   $0x804093
  802c3f:	e8 da da ff ff       	call   80071e <_panic>
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 10                	je     802c5d <alloc_block_NF+0x190>
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c55:	8b 52 04             	mov    0x4(%edx),%edx
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	eb 0b                	jmp    802c68 <alloc_block_NF+0x19b>
  802c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0f                	je     802c81 <alloc_block_NF+0x1b4>
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7b:	8b 12                	mov    (%edx),%edx
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	eb 0a                	jmp    802c8b <alloc_block_NF+0x1be>
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	a3 48 51 80 00       	mov    %eax,0x805148
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 54 51 80 00       	mov    0x805154,%eax
  802ca3:	48                   	dec    %eax
  802ca4:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cac:	eb 30                	jmp    802cde <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802cae:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cb3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802cb6:	75 0a                	jne    802cc2 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802cb8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc0:	eb 08                	jmp    802cca <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 08             	mov    0x8(%eax),%eax
  802cd0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd3:	0f 85 4d fe ff ff    	jne    802b26 <alloc_block_NF+0x59>

			return NULL;
  802cd9:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802cde:	c9                   	leave  
  802cdf:	c3                   	ret    

00802ce0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	53                   	push   %ebx
  802ce4:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802ce7:	a1 38 51 80 00       	mov    0x805138,%eax
  802cec:	85 c0                	test   %eax,%eax
  802cee:	0f 85 86 00 00 00    	jne    802d7a <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802cf4:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802cfb:	00 00 00 
  802cfe:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802d05:	00 00 00 
  802d08:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802d0f:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d16:	75 17                	jne    802d2f <insert_sorted_with_merge_freeList+0x4f>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 70 40 80 00       	push   $0x804070
  802d20:	68 48 01 00 00       	push   $0x148
  802d25:	68 93 40 80 00       	push   $0x804093
  802d2a:	e8 ef d9 ff ff       	call   80071e <_panic>
  802d2f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 0d                	je     802d50 <insert_sorted_with_merge_freeList+0x70>
  802d43:	a1 38 51 80 00       	mov    0x805138,%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	eb 08                	jmp    802d58 <insert_sorted_with_merge_freeList+0x78>
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d6f:	40                   	inc    %eax
  802d70:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802d75:	e9 73 07 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d85:	8b 40 08             	mov    0x8(%eax),%eax
  802d88:	39 c2                	cmp    %eax,%edx
  802d8a:	0f 86 84 00 00 00    	jbe    802e14 <insert_sorted_with_merge_freeList+0x134>
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 50 08             	mov    0x8(%eax),%edx
  802d96:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d9b:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d9e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	01 c8                	add    %ecx,%eax
  802da8:	39 c2                	cmp    %eax,%edx
  802daa:	74 68                	je     802e14 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0xe9>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 ac 40 80 00       	push   $0x8040ac
  802dba:	68 4c 01 00 00       	push   $0x14c
  802dbf:	68 93 40 80 00       	push   $0x804093
  802dc4:	e8 55 d9 ff ff       	call   80071e <_panic>
  802dc9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 50 04             	mov    %edx,0x4(%eax)
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 40 04             	mov    0x4(%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0c                	je     802deb <insert_sorted_with_merge_freeList+0x10b>
  802ddf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de4:	8b 55 08             	mov    0x8(%ebp),%edx
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	eb 08                	jmp    802df3 <insert_sorted_with_merge_freeList+0x113>
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	a3 38 51 80 00       	mov    %eax,0x805138
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e04:	a1 44 51 80 00       	mov    0x805144,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 44 51 80 00       	mov    %eax,0x805144
  802e0f:	e9 d9 06 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 50 08             	mov    0x8(%eax),%edx
  802e1a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e1f:	8b 40 08             	mov    0x8(%eax),%eax
  802e22:	39 c2                	cmp    %eax,%edx
  802e24:	0f 86 b5 00 00 00    	jbe    802edf <insert_sorted_with_merge_freeList+0x1ff>
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 50 08             	mov    0x8(%eax),%edx
  802e30:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e35:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e38:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e3d:	8b 40 08             	mov    0x8(%eax),%eax
  802e40:	01 c8                	add    %ecx,%eax
  802e42:	39 c2                	cmp    %eax,%edx
  802e44:	0f 85 95 00 00 00    	jne    802edf <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802e4a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e4f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e55:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e58:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5b:	8b 52 0c             	mov    0xc(%edx),%edx
  802e5e:	01 ca                	add    %ecx,%edx
  802e60:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7b:	75 17                	jne    802e94 <insert_sorted_with_merge_freeList+0x1b4>
  802e7d:	83 ec 04             	sub    $0x4,%esp
  802e80:	68 70 40 80 00       	push   $0x804070
  802e85:	68 54 01 00 00       	push   $0x154
  802e8a:	68 93 40 80 00       	push   $0x804093
  802e8f:	e8 8a d8 ff ff       	call   80071e <_panic>
  802e94:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	89 10                	mov    %edx,(%eax)
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 0d                	je     802eb5 <insert_sorted_with_merge_freeList+0x1d5>
  802ea8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ead:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb0:	89 50 04             	mov    %edx,0x4(%eax)
  802eb3:	eb 08                	jmp    802ebd <insert_sorted_with_merge_freeList+0x1dd>
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecf:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed4:	40                   	inc    %eax
  802ed5:	a3 54 51 80 00       	mov    %eax,0x805154
  802eda:	e9 0e 06 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 50 08             	mov    0x8(%eax),%edx
  802ee5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 83 c1 00 00 00    	jae    802fb6 <insert_sorted_with_merge_freeList+0x2d6>
  802ef5:	a1 38 51 80 00       	mov    0x805138,%eax
  802efa:	8b 50 08             	mov    0x8(%eax),%edx
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 48 08             	mov    0x8(%eax),%ecx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 40 0c             	mov    0xc(%eax),%eax
  802f09:	01 c8                	add    %ecx,%eax
  802f0b:	39 c2                	cmp    %eax,%edx
  802f0d:	0f 85 a3 00 00 00    	jne    802fb6 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802f13:	a1 38 51 80 00       	mov    0x805138,%eax
  802f18:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1b:	8b 52 08             	mov    0x8(%edx),%edx
  802f1e:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802f21:	a1 38 51 80 00       	mov    0x805138,%eax
  802f26:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f2c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f32:	8b 52 0c             	mov    0xc(%edx),%edx
  802f35:	01 ca                	add    %ecx,%edx
  802f37:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f52:	75 17                	jne    802f6b <insert_sorted_with_merge_freeList+0x28b>
  802f54:	83 ec 04             	sub    $0x4,%esp
  802f57:	68 70 40 80 00       	push   $0x804070
  802f5c:	68 5d 01 00 00       	push   $0x15d
  802f61:	68 93 40 80 00       	push   $0x804093
  802f66:	e8 b3 d7 ff ff       	call   80071e <_panic>
  802f6b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	89 10                	mov    %edx,(%eax)
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 0d                	je     802f8c <insert_sorted_with_merge_freeList+0x2ac>
  802f7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f84:	8b 55 08             	mov    0x8(%ebp),%edx
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	eb 08                	jmp    802f94 <insert_sorted_with_merge_freeList+0x2b4>
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	a3 48 51 80 00       	mov    %eax,0x805148
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa6:	a1 54 51 80 00       	mov    0x805154,%eax
  802fab:	40                   	inc    %eax
  802fac:	a3 54 51 80 00       	mov    %eax,0x805154
  802fb1:	e9 37 05 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 50 08             	mov    0x8(%eax),%edx
  802fbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc1:	8b 40 08             	mov    0x8(%eax),%eax
  802fc4:	39 c2                	cmp    %eax,%edx
  802fc6:	0f 83 82 00 00 00    	jae    80304e <insert_sorted_with_merge_freeList+0x36e>
  802fcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 48 08             	mov    0x8(%eax),%ecx
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe0:	01 c8                	add    %ecx,%eax
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	74 68                	je     80304e <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fea:	75 17                	jne    803003 <insert_sorted_with_merge_freeList+0x323>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 70 40 80 00       	push   $0x804070
  802ff4:	68 62 01 00 00       	push   $0x162
  802ff9:	68 93 40 80 00       	push   $0x804093
  802ffe:	e8 1b d7 ff ff       	call   80071e <_panic>
  803003:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0d                	je     803024 <insert_sorted_with_merge_freeList+0x344>
  803017:	a1 38 51 80 00       	mov    0x805138,%eax
  80301c:	8b 55 08             	mov    0x8(%ebp),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 08                	jmp    80302c <insert_sorted_with_merge_freeList+0x34c>
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	a3 38 51 80 00       	mov    %eax,0x805138
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 44 51 80 00       	mov    0x805144,%eax
  803043:	40                   	inc    %eax
  803044:	a3 44 51 80 00       	mov    %eax,0x805144
  803049:	e9 9f 04 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  80304e:	a1 38 51 80 00       	mov    0x805138,%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803058:	e9 84 04 00 00       	jmp    8034e1 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 50 08             	mov    0x8(%eax),%edx
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	8b 40 08             	mov    0x8(%eax),%eax
  803069:	39 c2                	cmp    %eax,%edx
  80306b:	0f 86 a9 00 00 00    	jbe    80311a <insert_sorted_with_merge_freeList+0x43a>
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 50 08             	mov    0x8(%eax),%edx
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8b 48 08             	mov    0x8(%eax),%ecx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	8b 40 0c             	mov    0xc(%eax),%eax
  803083:	01 c8                	add    %ecx,%eax
  803085:	39 c2                	cmp    %eax,%edx
  803087:	0f 84 8d 00 00 00    	je     80311a <insert_sorted_with_merge_freeList+0x43a>
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 50 08             	mov    0x8(%eax),%edx
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	8b 48 08             	mov    0x8(%eax),%ecx
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a5:	01 c8                	add    %ecx,%eax
  8030a7:	39 c2                	cmp    %eax,%edx
  8030a9:	74 6f                	je     80311a <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8030ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030af:	74 06                	je     8030b7 <insert_sorted_with_merge_freeList+0x3d7>
  8030b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b5:	75 17                	jne    8030ce <insert_sorted_with_merge_freeList+0x3ee>
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	68 d0 40 80 00       	push   $0x8040d0
  8030bf:	68 6b 01 00 00       	push   $0x16b
  8030c4:	68 93 40 80 00       	push   $0x804093
  8030c9:	e8 50 d6 ff ff       	call   80071e <_panic>
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 50 04             	mov    0x4(%eax),%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	89 50 04             	mov    %edx,0x4(%eax)
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 40 04             	mov    0x4(%eax),%eax
  8030e8:	85 c0                	test   %eax,%eax
  8030ea:	74 0d                	je     8030f9 <insert_sorted_with_merge_freeList+0x419>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 40 04             	mov    0x4(%eax),%eax
  8030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	eb 08                	jmp    803101 <insert_sorted_with_merge_freeList+0x421>
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 55 08             	mov    0x8(%ebp),%edx
  803107:	89 50 04             	mov    %edx,0x4(%eax)
  80310a:	a1 44 51 80 00       	mov    0x805144,%eax
  80310f:	40                   	inc    %eax
  803110:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  803115:	e9 d3 03 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	8b 50 08             	mov    0x8(%eax),%edx
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	8b 40 08             	mov    0x8(%eax),%eax
  803126:	39 c2                	cmp    %eax,%edx
  803128:	0f 86 da 00 00 00    	jbe    803208 <insert_sorted_with_merge_freeList+0x528>
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 50 08             	mov    0x8(%eax),%edx
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 48 08             	mov    0x8(%eax),%ecx
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	01 c8                	add    %ecx,%eax
  803142:	39 c2                	cmp    %eax,%edx
  803144:	0f 85 be 00 00 00    	jne    803208 <insert_sorted_with_merge_freeList+0x528>
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 50 08             	mov    0x8(%eax),%edx
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 40 04             	mov    0x4(%eax),%eax
  803156:	8b 48 08             	mov    0x8(%eax),%ecx
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	8b 40 0c             	mov    0xc(%eax),%eax
  803162:	01 c8                	add    %ecx,%eax
  803164:	39 c2                	cmp    %eax,%edx
  803166:	0f 84 9c 00 00 00    	je     803208 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 50 08             	mov    0x8(%eax),%edx
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 50 0c             	mov    0xc(%eax),%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	8b 40 0c             	mov    0xc(%eax),%eax
  803184:	01 c2                	add    %eax,%edx
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a4:	75 17                	jne    8031bd <insert_sorted_with_merge_freeList+0x4dd>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 70 40 80 00       	push   $0x804070
  8031ae:	68 74 01 00 00       	push   $0x174
  8031b3:	68 93 40 80 00       	push   $0x804093
  8031b8:	e8 61 d5 ff ff       	call   80071e <_panic>
  8031bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	89 10                	mov    %edx,(%eax)
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 0d                	je     8031de <insert_sorted_with_merge_freeList+0x4fe>
  8031d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d9:	89 50 04             	mov    %edx,0x4(%eax)
  8031dc:	eb 08                	jmp    8031e6 <insert_sorted_with_merge_freeList+0x506>
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031fd:	40                   	inc    %eax
  8031fe:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803203:	e9 e5 02 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 50 08             	mov    0x8(%eax),%edx
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 40 08             	mov    0x8(%eax),%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	0f 86 d7 00 00 00    	jbe    8032f3 <insert_sorted_with_merge_freeList+0x613>
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 50 08             	mov    0x8(%eax),%edx
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 48 08             	mov    0x8(%eax),%ecx
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	8b 40 0c             	mov    0xc(%eax),%eax
  80322e:	01 c8                	add    %ecx,%eax
  803230:	39 c2                	cmp    %eax,%edx
  803232:	0f 84 bb 00 00 00    	je     8032f3 <insert_sorted_with_merge_freeList+0x613>
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	8b 50 08             	mov    0x8(%eax),%edx
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	8b 48 08             	mov    0x8(%eax),%ecx
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	8b 40 0c             	mov    0xc(%eax),%eax
  803250:	01 c8                	add    %ecx,%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 85 99 00 00 00    	jne    8032f3 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 50 0c             	mov    0xc(%eax),%edx
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 40 0c             	mov    0xc(%eax),%eax
  80326f:	01 c2                	add    %eax,%edx
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80328b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328f:	75 17                	jne    8032a8 <insert_sorted_with_merge_freeList+0x5c8>
  803291:	83 ec 04             	sub    $0x4,%esp
  803294:	68 70 40 80 00       	push   $0x804070
  803299:	68 7d 01 00 00       	push   $0x17d
  80329e:	68 93 40 80 00       	push   $0x804093
  8032a3:	e8 76 d4 ff ff       	call   80071e <_panic>
  8032a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 0d                	je     8032c9 <insert_sorted_with_merge_freeList+0x5e9>
  8032bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c4:	89 50 04             	mov    %edx,0x4(%eax)
  8032c7:	eb 08                	jmp    8032d1 <insert_sorted_with_merge_freeList+0x5f1>
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8032e8:	40                   	inc    %eax
  8032e9:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8032ee:	e9 fa 01 00 00       	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 50 08             	mov    0x8(%eax),%edx
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 40 08             	mov    0x8(%eax),%eax
  8032ff:	39 c2                	cmp    %eax,%edx
  803301:	0f 86 d2 01 00 00    	jbe    8034d9 <insert_sorted_with_merge_freeList+0x7f9>
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	8b 50 08             	mov    0x8(%eax),%edx
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 48 08             	mov    0x8(%eax),%ecx
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	8b 40 0c             	mov    0xc(%eax),%eax
  803319:	01 c8                	add    %ecx,%eax
  80331b:	39 c2                	cmp    %eax,%edx
  80331d:	0f 85 b6 01 00 00    	jne    8034d9 <insert_sorted_with_merge_freeList+0x7f9>
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	8b 50 08             	mov    0x8(%eax),%edx
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 40 04             	mov    0x4(%eax),%eax
  80332f:	8b 48 08             	mov    0x8(%eax),%ecx
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	8b 40 0c             	mov    0xc(%eax),%eax
  80333b:	01 c8                	add    %ecx,%eax
  80333d:	39 c2                	cmp    %eax,%edx
  80333f:	0f 85 94 01 00 00    	jne    8034d9 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 40 04             	mov    0x4(%eax),%eax
  80334b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334e:	8b 52 04             	mov    0x4(%edx),%edx
  803351:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803354:	8b 55 08             	mov    0x8(%ebp),%edx
  803357:	8b 5a 0c             	mov    0xc(%edx),%ebx
  80335a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335d:	8b 52 0c             	mov    0xc(%edx),%edx
  803360:	01 da                	add    %ebx,%edx
  803362:	01 ca                	add    %ecx,%edx
  803364:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80337b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337f:	75 17                	jne    803398 <insert_sorted_with_merge_freeList+0x6b8>
  803381:	83 ec 04             	sub    $0x4,%esp
  803384:	68 05 41 80 00       	push   $0x804105
  803389:	68 86 01 00 00       	push   $0x186
  80338e:	68 93 40 80 00       	push   $0x804093
  803393:	e8 86 d3 ff ff       	call   80071e <_panic>
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 00                	mov    (%eax),%eax
  80339d:	85 c0                	test   %eax,%eax
  80339f:	74 10                	je     8033b1 <insert_sorted_with_merge_freeList+0x6d1>
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a9:	8b 52 04             	mov    0x4(%edx),%edx
  8033ac:	89 50 04             	mov    %edx,0x4(%eax)
  8033af:	eb 0b                	jmp    8033bc <insert_sorted_with_merge_freeList+0x6dc>
  8033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b4:	8b 40 04             	mov    0x4(%eax),%eax
  8033b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	74 0f                	je     8033d5 <insert_sorted_with_merge_freeList+0x6f5>
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 40 04             	mov    0x4(%eax),%eax
  8033cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033cf:	8b 12                	mov    (%edx),%edx
  8033d1:	89 10                	mov    %edx,(%eax)
  8033d3:	eb 0a                	jmp    8033df <insert_sorted_with_merge_freeList+0x6ff>
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	a3 38 51 80 00       	mov    %eax,0x805138
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f7:	48                   	dec    %eax
  8033f8:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8033fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803401:	75 17                	jne    80341a <insert_sorted_with_merge_freeList+0x73a>
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	68 70 40 80 00       	push   $0x804070
  80340b:	68 87 01 00 00       	push   $0x187
  803410:	68 93 40 80 00       	push   $0x804093
  803415:	e8 04 d3 ff ff       	call   80071e <_panic>
  80341a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	89 10                	mov    %edx,(%eax)
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	74 0d                	je     80343b <insert_sorted_with_merge_freeList+0x75b>
  80342e:	a1 48 51 80 00       	mov    0x805148,%eax
  803433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803436:	89 50 04             	mov    %edx,0x4(%eax)
  803439:	eb 08                	jmp    803443 <insert_sorted_with_merge_freeList+0x763>
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	a3 48 51 80 00       	mov    %eax,0x805148
  80344b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803455:	a1 54 51 80 00       	mov    0x805154,%eax
  80345a:	40                   	inc    %eax
  80345b:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803474:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803478:	75 17                	jne    803491 <insert_sorted_with_merge_freeList+0x7b1>
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	68 70 40 80 00       	push   $0x804070
  803482:	68 8a 01 00 00       	push   $0x18a
  803487:	68 93 40 80 00       	push   $0x804093
  80348c:	e8 8d d2 ff ff       	call   80071e <_panic>
  803491:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 0d                	je     8034b2 <insert_sorted_with_merge_freeList+0x7d2>
  8034a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8034aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ad:	89 50 04             	mov    %edx,0x4(%eax)
  8034b0:	eb 08                	jmp    8034ba <insert_sorted_with_merge_freeList+0x7da>
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d1:	40                   	inc    %eax
  8034d2:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8034d7:	eb 14                	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8034e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e5:	0f 85 72 fb ff ff    	jne    80305d <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8034eb:	eb 00                	jmp    8034ed <insert_sorted_with_merge_freeList+0x80d>
  8034ed:	90                   	nop
  8034ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034f1:	c9                   	leave  
  8034f2:	c3                   	ret    

008034f3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034f3:	55                   	push   %ebp
  8034f4:	89 e5                	mov    %esp,%ebp
  8034f6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fc:	89 d0                	mov    %edx,%eax
  8034fe:	c1 e0 02             	shl    $0x2,%eax
  803501:	01 d0                	add    %edx,%eax
  803503:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80350a:	01 d0                	add    %edx,%eax
  80350c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803513:	01 d0                	add    %edx,%eax
  803515:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80351c:	01 d0                	add    %edx,%eax
  80351e:	c1 e0 04             	shl    $0x4,%eax
  803521:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80352b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80352e:	83 ec 0c             	sub    $0xc,%esp
  803531:	50                   	push   %eax
  803532:	e8 7b eb ff ff       	call   8020b2 <sys_get_virtual_time>
  803537:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80353a:	eb 41                	jmp    80357d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80353c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80353f:	83 ec 0c             	sub    $0xc,%esp
  803542:	50                   	push   %eax
  803543:	e8 6a eb ff ff       	call   8020b2 <sys_get_virtual_time>
  803548:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80354b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80354e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803551:	29 c2                	sub    %eax,%edx
  803553:	89 d0                	mov    %edx,%eax
  803555:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803558:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355e:	89 d1                	mov    %edx,%ecx
  803560:	29 c1                	sub    %eax,%ecx
  803562:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803565:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803568:	39 c2                	cmp    %eax,%edx
  80356a:	0f 97 c0             	seta   %al
  80356d:	0f b6 c0             	movzbl %al,%eax
  803570:	29 c1                	sub    %eax,%ecx
  803572:	89 c8                	mov    %ecx,%eax
  803574:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803577:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80357a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803580:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803583:	72 b7                	jb     80353c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803585:	90                   	nop
  803586:	c9                   	leave  
  803587:	c3                   	ret    

00803588 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803588:	55                   	push   %ebp
  803589:	89 e5                	mov    %esp,%ebp
  80358b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80358e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803595:	eb 03                	jmp    80359a <busy_wait+0x12>
  803597:	ff 45 fc             	incl   -0x4(%ebp)
  80359a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80359d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035a0:	72 f5                	jb     803597 <busy_wait+0xf>
	return i;
  8035a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8035a5:	c9                   	leave  
  8035a6:	c3                   	ret    
  8035a7:	90                   	nop

008035a8 <__udivdi3>:
  8035a8:	55                   	push   %ebp
  8035a9:	57                   	push   %edi
  8035aa:	56                   	push   %esi
  8035ab:	53                   	push   %ebx
  8035ac:	83 ec 1c             	sub    $0x1c,%esp
  8035af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035bf:	89 ca                	mov    %ecx,%edx
  8035c1:	89 f8                	mov    %edi,%eax
  8035c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035c7:	85 f6                	test   %esi,%esi
  8035c9:	75 2d                	jne    8035f8 <__udivdi3+0x50>
  8035cb:	39 cf                	cmp    %ecx,%edi
  8035cd:	77 65                	ja     803634 <__udivdi3+0x8c>
  8035cf:	89 fd                	mov    %edi,%ebp
  8035d1:	85 ff                	test   %edi,%edi
  8035d3:	75 0b                	jne    8035e0 <__udivdi3+0x38>
  8035d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035da:	31 d2                	xor    %edx,%edx
  8035dc:	f7 f7                	div    %edi
  8035de:	89 c5                	mov    %eax,%ebp
  8035e0:	31 d2                	xor    %edx,%edx
  8035e2:	89 c8                	mov    %ecx,%eax
  8035e4:	f7 f5                	div    %ebp
  8035e6:	89 c1                	mov    %eax,%ecx
  8035e8:	89 d8                	mov    %ebx,%eax
  8035ea:	f7 f5                	div    %ebp
  8035ec:	89 cf                	mov    %ecx,%edi
  8035ee:	89 fa                	mov    %edi,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	39 ce                	cmp    %ecx,%esi
  8035fa:	77 28                	ja     803624 <__udivdi3+0x7c>
  8035fc:	0f bd fe             	bsr    %esi,%edi
  8035ff:	83 f7 1f             	xor    $0x1f,%edi
  803602:	75 40                	jne    803644 <__udivdi3+0x9c>
  803604:	39 ce                	cmp    %ecx,%esi
  803606:	72 0a                	jb     803612 <__udivdi3+0x6a>
  803608:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80360c:	0f 87 9e 00 00 00    	ja     8036b0 <__udivdi3+0x108>
  803612:	b8 01 00 00 00       	mov    $0x1,%eax
  803617:	89 fa                	mov    %edi,%edx
  803619:	83 c4 1c             	add    $0x1c,%esp
  80361c:	5b                   	pop    %ebx
  80361d:	5e                   	pop    %esi
  80361e:	5f                   	pop    %edi
  80361f:	5d                   	pop    %ebp
  803620:	c3                   	ret    
  803621:	8d 76 00             	lea    0x0(%esi),%esi
  803624:	31 ff                	xor    %edi,%edi
  803626:	31 c0                	xor    %eax,%eax
  803628:	89 fa                	mov    %edi,%edx
  80362a:	83 c4 1c             	add    $0x1c,%esp
  80362d:	5b                   	pop    %ebx
  80362e:	5e                   	pop    %esi
  80362f:	5f                   	pop    %edi
  803630:	5d                   	pop    %ebp
  803631:	c3                   	ret    
  803632:	66 90                	xchg   %ax,%ax
  803634:	89 d8                	mov    %ebx,%eax
  803636:	f7 f7                	div    %edi
  803638:	31 ff                	xor    %edi,%edi
  80363a:	89 fa                	mov    %edi,%edx
  80363c:	83 c4 1c             	add    $0x1c,%esp
  80363f:	5b                   	pop    %ebx
  803640:	5e                   	pop    %esi
  803641:	5f                   	pop    %edi
  803642:	5d                   	pop    %ebp
  803643:	c3                   	ret    
  803644:	bd 20 00 00 00       	mov    $0x20,%ebp
  803649:	89 eb                	mov    %ebp,%ebx
  80364b:	29 fb                	sub    %edi,%ebx
  80364d:	89 f9                	mov    %edi,%ecx
  80364f:	d3 e6                	shl    %cl,%esi
  803651:	89 c5                	mov    %eax,%ebp
  803653:	88 d9                	mov    %bl,%cl
  803655:	d3 ed                	shr    %cl,%ebp
  803657:	89 e9                	mov    %ebp,%ecx
  803659:	09 f1                	or     %esi,%ecx
  80365b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80365f:	89 f9                	mov    %edi,%ecx
  803661:	d3 e0                	shl    %cl,%eax
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 d6                	mov    %edx,%esi
  803667:	88 d9                	mov    %bl,%cl
  803669:	d3 ee                	shr    %cl,%esi
  80366b:	89 f9                	mov    %edi,%ecx
  80366d:	d3 e2                	shl    %cl,%edx
  80366f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803673:	88 d9                	mov    %bl,%cl
  803675:	d3 e8                	shr    %cl,%eax
  803677:	09 c2                	or     %eax,%edx
  803679:	89 d0                	mov    %edx,%eax
  80367b:	89 f2                	mov    %esi,%edx
  80367d:	f7 74 24 0c          	divl   0xc(%esp)
  803681:	89 d6                	mov    %edx,%esi
  803683:	89 c3                	mov    %eax,%ebx
  803685:	f7 e5                	mul    %ebp
  803687:	39 d6                	cmp    %edx,%esi
  803689:	72 19                	jb     8036a4 <__udivdi3+0xfc>
  80368b:	74 0b                	je     803698 <__udivdi3+0xf0>
  80368d:	89 d8                	mov    %ebx,%eax
  80368f:	31 ff                	xor    %edi,%edi
  803691:	e9 58 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  803696:	66 90                	xchg   %ax,%ax
  803698:	8b 54 24 08          	mov    0x8(%esp),%edx
  80369c:	89 f9                	mov    %edi,%ecx
  80369e:	d3 e2                	shl    %cl,%edx
  8036a0:	39 c2                	cmp    %eax,%edx
  8036a2:	73 e9                	jae    80368d <__udivdi3+0xe5>
  8036a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036a7:	31 ff                	xor    %edi,%edi
  8036a9:	e9 40 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	31 c0                	xor    %eax,%eax
  8036b2:	e9 37 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  8036b7:	90                   	nop

008036b8 <__umoddi3>:
  8036b8:	55                   	push   %ebp
  8036b9:	57                   	push   %edi
  8036ba:	56                   	push   %esi
  8036bb:	53                   	push   %ebx
  8036bc:	83 ec 1c             	sub    $0x1c,%esp
  8036bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036d7:	89 f3                	mov    %esi,%ebx
  8036d9:	89 fa                	mov    %edi,%edx
  8036db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036df:	89 34 24             	mov    %esi,(%esp)
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	75 1a                	jne    803700 <__umoddi3+0x48>
  8036e6:	39 f7                	cmp    %esi,%edi
  8036e8:	0f 86 a2 00 00 00    	jbe    803790 <__umoddi3+0xd8>
  8036ee:	89 c8                	mov    %ecx,%eax
  8036f0:	89 f2                	mov    %esi,%edx
  8036f2:	f7 f7                	div    %edi
  8036f4:	89 d0                	mov    %edx,%eax
  8036f6:	31 d2                	xor    %edx,%edx
  8036f8:	83 c4 1c             	add    $0x1c,%esp
  8036fb:	5b                   	pop    %ebx
  8036fc:	5e                   	pop    %esi
  8036fd:	5f                   	pop    %edi
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    
  803700:	39 f0                	cmp    %esi,%eax
  803702:	0f 87 ac 00 00 00    	ja     8037b4 <__umoddi3+0xfc>
  803708:	0f bd e8             	bsr    %eax,%ebp
  80370b:	83 f5 1f             	xor    $0x1f,%ebp
  80370e:	0f 84 ac 00 00 00    	je     8037c0 <__umoddi3+0x108>
  803714:	bf 20 00 00 00       	mov    $0x20,%edi
  803719:	29 ef                	sub    %ebp,%edi
  80371b:	89 fe                	mov    %edi,%esi
  80371d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803721:	89 e9                	mov    %ebp,%ecx
  803723:	d3 e0                	shl    %cl,%eax
  803725:	89 d7                	mov    %edx,%edi
  803727:	89 f1                	mov    %esi,%ecx
  803729:	d3 ef                	shr    %cl,%edi
  80372b:	09 c7                	or     %eax,%edi
  80372d:	89 e9                	mov    %ebp,%ecx
  80372f:	d3 e2                	shl    %cl,%edx
  803731:	89 14 24             	mov    %edx,(%esp)
  803734:	89 d8                	mov    %ebx,%eax
  803736:	d3 e0                	shl    %cl,%eax
  803738:	89 c2                	mov    %eax,%edx
  80373a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80373e:	d3 e0                	shl    %cl,%eax
  803740:	89 44 24 04          	mov    %eax,0x4(%esp)
  803744:	8b 44 24 08          	mov    0x8(%esp),%eax
  803748:	89 f1                	mov    %esi,%ecx
  80374a:	d3 e8                	shr    %cl,%eax
  80374c:	09 d0                	or     %edx,%eax
  80374e:	d3 eb                	shr    %cl,%ebx
  803750:	89 da                	mov    %ebx,%edx
  803752:	f7 f7                	div    %edi
  803754:	89 d3                	mov    %edx,%ebx
  803756:	f7 24 24             	mull   (%esp)
  803759:	89 c6                	mov    %eax,%esi
  80375b:	89 d1                	mov    %edx,%ecx
  80375d:	39 d3                	cmp    %edx,%ebx
  80375f:	0f 82 87 00 00 00    	jb     8037ec <__umoddi3+0x134>
  803765:	0f 84 91 00 00 00    	je     8037fc <__umoddi3+0x144>
  80376b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80376f:	29 f2                	sub    %esi,%edx
  803771:	19 cb                	sbb    %ecx,%ebx
  803773:	89 d8                	mov    %ebx,%eax
  803775:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803779:	d3 e0                	shl    %cl,%eax
  80377b:	89 e9                	mov    %ebp,%ecx
  80377d:	d3 ea                	shr    %cl,%edx
  80377f:	09 d0                	or     %edx,%eax
  803781:	89 e9                	mov    %ebp,%ecx
  803783:	d3 eb                	shr    %cl,%ebx
  803785:	89 da                	mov    %ebx,%edx
  803787:	83 c4 1c             	add    $0x1c,%esp
  80378a:	5b                   	pop    %ebx
  80378b:	5e                   	pop    %esi
  80378c:	5f                   	pop    %edi
  80378d:	5d                   	pop    %ebp
  80378e:	c3                   	ret    
  80378f:	90                   	nop
  803790:	89 fd                	mov    %edi,%ebp
  803792:	85 ff                	test   %edi,%edi
  803794:	75 0b                	jne    8037a1 <__umoddi3+0xe9>
  803796:	b8 01 00 00 00       	mov    $0x1,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f7                	div    %edi
  80379f:	89 c5                	mov    %eax,%ebp
  8037a1:	89 f0                	mov    %esi,%eax
  8037a3:	31 d2                	xor    %edx,%edx
  8037a5:	f7 f5                	div    %ebp
  8037a7:	89 c8                	mov    %ecx,%eax
  8037a9:	f7 f5                	div    %ebp
  8037ab:	89 d0                	mov    %edx,%eax
  8037ad:	e9 44 ff ff ff       	jmp    8036f6 <__umoddi3+0x3e>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	89 c8                	mov    %ecx,%eax
  8037b6:	89 f2                	mov    %esi,%edx
  8037b8:	83 c4 1c             	add    $0x1c,%esp
  8037bb:	5b                   	pop    %ebx
  8037bc:	5e                   	pop    %esi
  8037bd:	5f                   	pop    %edi
  8037be:	5d                   	pop    %ebp
  8037bf:	c3                   	ret    
  8037c0:	3b 04 24             	cmp    (%esp),%eax
  8037c3:	72 06                	jb     8037cb <__umoddi3+0x113>
  8037c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c9:	77 0f                	ja     8037da <__umoddi3+0x122>
  8037cb:	89 f2                	mov    %esi,%edx
  8037cd:	29 f9                	sub    %edi,%ecx
  8037cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037d3:	89 14 24             	mov    %edx,(%esp)
  8037d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037de:	8b 14 24             	mov    (%esp),%edx
  8037e1:	83 c4 1c             	add    $0x1c,%esp
  8037e4:	5b                   	pop    %ebx
  8037e5:	5e                   	pop    %esi
  8037e6:	5f                   	pop    %edi
  8037e7:	5d                   	pop    %ebp
  8037e8:	c3                   	ret    
  8037e9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ec:	2b 04 24             	sub    (%esp),%eax
  8037ef:	19 fa                	sbb    %edi,%edx
  8037f1:	89 d1                	mov    %edx,%ecx
  8037f3:	89 c6                	mov    %eax,%esi
  8037f5:	e9 71 ff ff ff       	jmp    80376b <__umoddi3+0xb3>
  8037fa:	66 90                	xchg   %ax,%ax
  8037fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803800:	72 ea                	jb     8037ec <__umoddi3+0x134>
  803802:	89 d9                	mov    %ebx,%ecx
  803804:	e9 62 ff ff ff       	jmp    80376b <__umoddi3+0xb3>
