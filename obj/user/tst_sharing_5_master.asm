
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d8 03 00 00       	call   80040e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 40 36 80 00       	push   $0x803640
  800092:	6a 12                	push   $0x12
  800094:	68 5c 36 80 00       	push   $0x80365c
  800099:	e8 ac 04 00 00       	call   80054a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 a6 16 00 00       	call   80174e <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 78 36 80 00       	push   $0x803678
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 ac 36 80 00       	push   $0x8036ac
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 08 37 80 00       	push   $0x803708
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 99 1d 00 00       	call   801e79 <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 3c 37 80 00       	push   $0x80373c
  8000f2:	e8 07 07 00 00       	call   8007fe <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800110:	89 c1                	mov    %eax,%ecx
  800112:	a1 20 50 80 00       	mov    0x805020,%eax
  800117:	8b 40 74             	mov    0x74(%eax),%eax
  80011a:	52                   	push   %edx
  80011b:	51                   	push   %ecx
  80011c:	50                   	push   %eax
  80011d:	68 7d 37 80 00       	push   $0x80377d
  800122:	e8 fd 1c 00 00       	call   801e24 <sys_create_env>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80012d:	a1 20 50 80 00       	mov    0x805020,%eax
  800132:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	a1 20 50 80 00       	mov    0x805020,%eax
  80014a:	8b 40 74             	mov    0x74(%eax),%eax
  80014d:	52                   	push   %edx
  80014e:	51                   	push   %ecx
  80014f:	50                   	push   %eax
  800150:	68 7d 37 80 00       	push   $0x80377d
  800155:	e8 ca 1c 00 00       	call   801e24 <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 4d 1a 00 00       	call   801bb2 <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 88 37 80 00       	push   $0x803788
  800177:	e8 33 17 00 00       	call   8018af <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 8c 37 80 00       	push   $0x80378c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 ac 37 80 00       	push   $0x8037ac
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 5c 36 80 00       	push   $0x80365c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 fb 19 00 00       	call   801bb2 <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 18 38 80 00       	push   $0x803818
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 5c 36 80 00       	push   $0x80365c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 97 1d 00 00       	call   801f70 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 5e 1c 00 00       	call   801e42 <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 50 1c 00 00       	call   801e42 <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 96 38 80 00       	push   $0x803896
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 0d 31 00 00       	call   80331f <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 cf 1d 00 00       	call   801fea <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 8d 19 00 00       	call   801bb2 <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 1f 18 00 00       	call   801a52 <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 b0 38 80 00       	push   $0x8038b0
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 67 19 00 00       	call   801bb2 <sys_calculate_free_frames>
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
  800254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = (1+1) + (1+1);
  800257:	c7 45 e8 04 00 00 00 	movl   $0x4,-0x18(%ebp)
		if ( diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80025e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800264:	74 1a                	je     800280 <_main+0x248>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 e8             	pushl  -0x18(%ebp)
  80026c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026f:	68 d0 38 80 00       	push   $0x8038d0
  800274:	6a 3b                	push   $0x3b
  800276:	68 5c 36 80 00       	push   $0x80365c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 18 39 80 00       	push   $0x803918
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 3c 39 80 00       	push   $0x80393c
  800298:	e8 61 05 00 00       	call   8007fe <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 40 74             	mov    0x74(%eax),%eax
  8002c0:	52                   	push   %edx
  8002c1:	51                   	push   %ecx
  8002c2:	50                   	push   %eax
  8002c3:	68 6c 39 80 00       	push   $0x80396c
  8002c8:	e8 57 1b 00 00       	call   801e24 <sys_create_env>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002de:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e9:	89 c1                	mov    %eax,%ecx
  8002eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	52                   	push   %edx
  8002f4:	51                   	push   %ecx
  8002f5:	50                   	push   %eax
  8002f6:	68 79 39 80 00       	push   $0x803979
  8002fb:	e8 24 1b 00 00       	call   801e24 <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 86 39 80 00       	push   $0x803986
  800315:	e8 95 15 00 00       	call   8018af <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 88 39 80 00       	push   $0x803988
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 88 37 80 00       	push   $0x803788
  80033f:	e8 6b 15 00 00       	call   8018af <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 8c 37 80 00       	push   $0x80378c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 11 1c 00 00       	call   801f70 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 d8 1a 00 00       	call   801e42 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 ca 1a 00 00       	call   801e42 <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 69 1c 00 00       	call   801fea <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 e5 1b 00 00       	call   801f70 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 22 18 00 00       	call   801bb2 <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 b4 16 00 00       	call   801a52 <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 a8 39 80 00       	push   $0x8039a8
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 96 16 00 00       	call   801a52 <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 be 39 80 00       	push   $0x8039be
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 de 17 00 00       	call   801bb2 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d9:	29 c2                	sub    %eax,%edx
  8003db:	89 d0                	mov    %edx,%eax
  8003dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1;
  8003e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 d4 39 80 00       	push   $0x8039d4
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 5c 36 80 00       	push   $0x80365c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 c8 1b 00 00       	call   801fd0 <inctst>


	}


	return;
  800408:	90                   	nop
}
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800414:	e8 79 1a 00 00       	call   801e92 <sys_getenvindex>
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80041c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0f                	je     80045e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	05 5c 05 00 00       	add    $0x55c,%eax
  800459:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800462:	7e 0a                	jle    80046e <libmain+0x60>
		binaryname = argv[0];
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 bc fb ff ff       	call   800038 <_main>
  80047c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80047f:	e8 1b 18 00 00       	call   801c9f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 94 3a 80 00       	push   $0x803a94
  80048c:	e8 6d 03 00 00       	call   8007fe <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	68 bc 3a 80 00       	push   $0x803abc
  8004b4:	e8 45 03 00 00       	call   8007fe <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004dd:	51                   	push   %ecx
  8004de:	52                   	push   %edx
  8004df:	50                   	push   %eax
  8004e0:	68 e4 3a 80 00       	push   $0x803ae4
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 3c 3b 80 00       	push   $0x803b3c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 94 3a 80 00       	push   $0x803a94
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 9b 17 00 00       	call   801cb9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80051e:	e8 19 00 00 00       	call   80053c <exit>
}
  800523:	90                   	nop
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	6a 00                	push   $0x0
  800531:	e8 28 19 00 00       	call   801e5e <sys_destroy_env>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <exit>:

void
exit(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800542:	e8 7d 19 00 00       	call   801ec4 <sys_exit_env>
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800550:	8d 45 10             	lea    0x10(%ebp),%eax
  800553:	83 c0 04             	add    $0x4,%eax
  800556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800559:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 16                	je     800578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800562:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	50                   	push   %eax
  80056b:	68 50 3b 80 00       	push   $0x803b50
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 55 3b 80 00       	push   $0x803b55
  800589:	e8 70 02 00 00       	call   8007fe <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 f3 01 00 00       	call   800793 <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	6a 00                	push   $0x0
  8005a8:	68 71 3b 80 00       	push   $0x803b71
  8005ad:	e8 e1 01 00 00       	call   800793 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b5:	e8 82 ff ff ff       	call   80053c <exit>

	// should not return here
	while (1) ;
  8005ba:	eb fe                	jmp    8005ba <_panic+0x70>

008005bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 74 3b 80 00       	push   $0x803b74
  8005d9:	6a 26                	push   $0x26
  8005db:	68 c0 3b 80 00       	push   $0x803bc0
  8005e0:	e8 65 ff ff ff       	call   80054a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c2 00 00 00       	jmp    8006ba <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a2 00 00 00       	jmp    8006b7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 12                	jmp    80069d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 50 74             	mov    0x74(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 88                	ja     800625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 cc 3b 80 00       	push   $0x803bcc
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 c0 3b 80 00       	push   $0x803bc0
  8006b2:	e8 93 fe ff ff       	call   80054a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 32 ff ff ff    	jl     8005f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 50 74             	mov    0x74(%eax),%edx
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	77 cb                	ja     8006d6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800711:	74 14                	je     800727 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 20 3c 80 00       	push   $0x803c20
  80071b:	6a 44                	push   $0x44
  80071d:	68 c0 3b 80 00       	push   $0x803bc0
  800722:	e8 23 fe ff ff       	call   80054a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800727:	90                   	nop
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 48 01             	lea    0x1(%eax),%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 0a                	mov    %ecx,(%edx)
  80073d:	8b 55 08             	mov    0x8(%ebp),%edx
  800740:	88 d1                	mov    %dl,%cl
  800742:	8b 55 0c             	mov    0xc(%ebp),%edx
  800745:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800753:	75 2c                	jne    800781 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800755:	a0 24 50 80 00       	mov    0x805024,%al
  80075a:	0f b6 c0             	movzbl %al,%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800760:	8b 12                	mov    (%edx),%edx
  800762:	89 d1                	mov    %edx,%ecx
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	50                   	push   %eax
  80076e:	51                   	push   %ecx
  80076f:	52                   	push   %edx
  800770:	e8 7c 13 00 00       	call   801af1 <sys_cputs>
  800775:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 40 04             	mov    0x4(%eax),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 2a 07 80 00       	push   $0x80072a
  8007c2:	e8 11 02 00 00       	call   8009d8 <vprintfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ca:	a0 24 50 80 00       	mov    0x805024,%al
  8007cf:	0f b6 c0             	movzbl %al,%eax
  8007d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	50                   	push   %eax
  8007dc:	52                   	push   %edx
  8007dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e3:	83 c0 08             	add    $0x8,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 05 13 00 00       	call   801af1 <sys_cputs>
  8007ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ef:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800804:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80080b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 f4             	pushl  -0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	e8 73 ff ff ff       	call   800793 <vcprintf>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800831:	e8 69 14 00 00       	call   801c9f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 48 ff ff ff       	call   800793 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800851:	e8 63 14 00 00       	call   801cb9 <sys_enable_interrupt>
	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086e:	8b 45 18             	mov    0x18(%ebp),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800879:	77 55                	ja     8008d0 <printnum+0x75>
  80087b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087e:	72 05                	jb     800885 <printnum+0x2a>
  800880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800883:	77 4b                	ja     8008d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800885:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800888:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088b:	8b 45 18             	mov    0x18(%ebp),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	ff 75 f0             	pushl  -0x10(%ebp)
  80089b:	e8 34 2b 00 00       	call   8033d4 <__udivdi3>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	ff 75 18             	pushl  0x18(%ebp)
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 a1 ff ff ff       	call   80085b <printnum>
  8008ba:	83 c4 20             	add    $0x20,%esp
  8008bd:	eb 1a                	jmp    8008d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 20             	pushl  0x20(%ebp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d7:	7f e6                	jg     8008bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	53                   	push   %ebx
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	e8 f4 2b 00 00       	call   8034e4 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 94 3e 80 00       	add    $0x803e94,%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be c0             	movsbl %al,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	90                   	nop
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800919:	7e 1c                	jle    800937 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 08             	lea    0x8(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 08             	sub    $0x8,%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	eb 40                	jmp    800977 <getuint+0x65>
	else if (lflag)
  800937:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093b:	74 1e                	je     80095b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	eb 1c                	jmp    800977 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800980:	7e 1c                	jle    80099e <getint+0x25>
		return va_arg(*ap, long long);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 08             	lea    0x8(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 08             	sub    $0x8,%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	eb 38                	jmp    8009d6 <getint+0x5d>
	else if (lflag)
  80099e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a2:	74 1a                	je     8009be <getint+0x45>
		return va_arg(*ap, long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
  8009bc:	eb 18                	jmp    8009d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 10                	mov    %edx,(%eax)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	99                   	cltd   
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	eb 17                	jmp    8009f9 <vprintfmt+0x21>
			if (ch == '\0')
  8009e2:	85 db                	test   %ebx,%ebx
  8009e4:	0f 84 af 03 00 00    	je     800d99 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	83 fb 25             	cmp    $0x25,%ebx
  800a0a:	75 d6                	jne    8009e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 10             	mov    %edx,0x10(%ebp)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f b6 d8             	movzbl %al,%ebx
  800a3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3d:	83 f8 55             	cmp    $0x55,%eax
  800a40:	0f 87 2b 03 00 00    	ja     800d71 <vprintfmt+0x399>
  800a46:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
  800a4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d7                	jmp    800a2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d1                	jmp    800a2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 02             	shl    $0x2,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c0                	add    %eax,%eax
  800a6e:	01 d8                	add    %ebx,%eax
  800a70:	83 e8 30             	sub    $0x30,%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a81:	7e 3e                	jle    800ac1 <vprintfmt+0xe9>
  800a83:	83 fb 39             	cmp    $0x39,%ebx
  800a86:	7f 39                	jg     800ac1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8b:	eb d5                	jmp    800a62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	79 83                	jns    800a2c <vprintfmt+0x54>
				width = 0;
  800aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab0:	e9 77 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abc:	e9 6b ff ff ff       	jmp    800a2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	0f 89 60 ff ff ff    	jns    800a2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad9:	e9 4e ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ade:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae1:	e9 46 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 89 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	79 02                	jns    800b22 <vprintfmt+0x14a>
				err = -err;
  800b20:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b22:	83 fb 64             	cmp    $0x64,%ebx
  800b25:	7f 0b                	jg     800b32 <vprintfmt+0x15a>
  800b27:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 a5 3e 80 00       	push   $0x803ea5
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 5e 02 00 00       	call   800da1 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b46:	e9 49 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4b:	56                   	push   %esi
  800b4c:	68 ae 3e 80 00       	push   $0x803eae
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 45 02 00 00       	call   800da1 <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			break;
  800b5f:	e9 30 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	83 e8 04             	sub    $0x4,%eax
  800b73:	8b 30                	mov    (%eax),%esi
  800b75:	85 f6                	test   %esi,%esi
  800b77:	75 05                	jne    800b7e <vprintfmt+0x1a6>
				p = "(null)";
  800b79:	be b1 3e 80 00       	mov    $0x803eb1,%esi
			if (width > 0 && padc != '-')
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7e 6d                	jle    800bf1 <vprintfmt+0x219>
  800b84:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b88:	74 67                	je     800bf1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	50                   	push   %eax
  800b91:	56                   	push   %esi
  800b92:	e8 0c 03 00 00       	call   800ea3 <strnlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	eb 34                	jmp    800bf1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc1:	74 1c                	je     800bdf <vprintfmt+0x207>
  800bc3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc6:	7e 05                	jle    800bcd <vprintfmt+0x1f5>
  800bc8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcb:	7e 12                	jle    800bdf <vprintfmt+0x207>
					putch('?', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 3f                	push   $0x3f
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bee:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	8d 70 01             	lea    0x1(%eax),%esi
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f be d8             	movsbl %al,%ebx
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	74 24                	je     800c23 <vprintfmt+0x24b>
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	78 b8                	js     800bbd <vprintfmt+0x1e5>
  800c05:	ff 4d e0             	decl   -0x20(%ebp)
  800c08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0c:	79 af                	jns    800bbd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0e:	eb 13                	jmp    800c23 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 20                	push   $0x20
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e7                	jg     800c10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c29:	e9 66 01 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 3c fd ff ff       	call   800979 <getint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	79 23                	jns    800c73 <vprintfmt+0x29b>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 2d                	push   $0x2d
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c66:	f7 d8                	neg    %eax
  800c68:	83 d2 00             	adc    $0x0,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 bc 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 84 fc ff ff       	call   800912 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9e:	e9 98 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 58                	push   $0x58
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 58                	push   $0x58
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 58                	push   $0x58
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			break;
  800cd3:	e9 bc 00 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	6a 30                	push   $0x30
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	ff d0                	call   *%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 78                	push   $0x78
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1a:	eb 1f                	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d22:	8d 45 14             	lea    0x14(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	e8 e7 fb ff ff       	call   800912 <getuint>
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	52                   	push   %edx
  800d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d49:	50                   	push   %eax
  800d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 00 fb ff ff       	call   80085b <printnum>
  800d5b:	83 c4 20             	add    $0x20,%esp
			break;
  800d5e:	eb 34                	jmp    800d94 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	eb 23                	jmp    800d94 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	6a 25                	push   $0x25
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	eb 03                	jmp    800d89 <vprintfmt+0x3b1>
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3c 25                	cmp    $0x25,%al
  800d91:	75 f3                	jne    800d86 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d93:	90                   	nop
		}
	}
  800d94:	e9 47 fc ff ff       	jmp    8009e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d99:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da7:	8d 45 10             	lea    0x10(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	ff 75 f4             	pushl  -0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	ff 75 08             	pushl  0x8(%ebp)
  800dbd:	e8 16 fc ff ff       	call   8009d8 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc5:	90                   	nop
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8b 40 08             	mov    0x8(%eax),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 10                	mov    (%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 04             	mov    0x4(%eax),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	73 12                	jae    800dfb <sprintputch+0x33>
		*b->buf++ = ch;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	8d 48 01             	lea    0x1(%eax),%ecx
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 0a                	mov    %ecx,(%edx)
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
}
  800dfb:	90                   	nop
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 06                	je     800e2b <vsnprintf+0x2d>
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	7f 07                	jg     800e32 <vsnprintf+0x34>
		return -E_INVAL;
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	eb 20                	jmp    800e52 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e32:	ff 75 14             	pushl  0x14(%ebp)
  800e35:	ff 75 10             	pushl  0x10(%ebp)
  800e38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e3b:	50                   	push   %eax
  800e3c:	68 c8 0d 80 00       	push   $0x800dc8
  800e41:	e8 92 fb ff ff       	call   8009d8 <vprintfmt>
  800e46:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5d:	83 c0 04             	add    $0x4,%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	ff 75 08             	pushl  0x8(%ebp)
  800e70:	e8 89 ff ff ff       	call   800dfe <vsnprintf>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 06                	jmp    800e95 <strlen+0x15>
		n++;
  800e8f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 f1                	jne    800e8f <strlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 09                	jmp    800ebb <strnlen+0x18>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 4d 0c             	decl   0xc(%ebp)
  800ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebf:	74 09                	je     800eca <strnlen+0x27>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e8                	jne    800eb2 <strnlen+0xf>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800edb:	90                   	nop
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e4                	jne    800edc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f10:	eb 1f                	jmp    800f31 <strncpy+0x34>
		*dst++ = *src;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 03                	je     800f2e <strncpy+0x31>
			src++;
  800f2b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f37:	72 d9                	jb     800f12 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 30                	je     800f80 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f50:	eb 16                	jmp    800f68 <strlcpy+0x2a>
			*dst++ = *src++;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 09                	je     800f7a <strlcpy+0x3c>
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 d8                	jne    800f52 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8f:	eb 06                	jmp    800f97 <strcmp+0xb>
		p++, q++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strcmp+0x22>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 e3                	je     800f91 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 09                	jmp    800fd2 <strncmp+0xe>
		n--, p++, q++;
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 17                	je     800fef <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 da                	je     800fc9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x38>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 14                	jmp    801010 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 12                	jmp    801032 <strchr+0x20>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	75 05                	jne    80102f <strchr+0x1d>
			return (char *) s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	eb 11                	jmp    801040 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 e5                	jne    801020 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104e:	eb 0d                	jmp    80105d <strfind+0x1b>
		if (*s == c)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801058:	74 0e                	je     801068 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 ea                	jne    801050 <strfind+0xe>
  801066:	eb 01                	jmp    801069 <strfind+0x27>
		if (*s == c)
			break;
  801068:	90                   	nop
	return (char *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801080:	eb 0e                	jmp    801090 <memset+0x22>
		*p++ = c;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801090:	ff 4d f8             	decl   -0x8(%ebp)
  801093:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801097:	79 e9                	jns    801082 <memset+0x14>
		*p++ = c;

	return v;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x2a>
		*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801395:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139a:	f7 e9                	imul   %ecx
  80139c:	c1 fa 02             	sar    $0x2,%edx
  80139f:	89 c8                	mov    %ecx,%eax
  8013a1:	c1 f8 1f             	sar    $0x1f,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	c1 e0 02             	shl    $0x2,%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	01 c0                	add    %eax,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 ca                	mov    %ecx,%edx
  8013b3:	85 d2                	test   %edx,%edx
  8013b5:	75 9c                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	48                   	dec    %eax
  8013c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c9:	74 3d                	je     801408 <ltostr+0xe2>
		start = 1 ;
  8013cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d2:	eb 34                	jmp    801408 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801400:	88 02                	mov    %al,(%edx)
		start++ ;
  801402:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801405:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140e:	7c c4                	jl     8013d4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801410:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 54 fa ff ff       	call   800e80 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 46 fa ff ff       	call   800e80 <strlen>
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 17                	jmp    801467 <strcconcat+0x49>
		final[s] = str1[s] ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801464:	ff 45 fc             	incl   -0x4(%ebp)
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146d:	7c e1                	jl     801450 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801476:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147d:	eb 1f                	jmp    80149e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 c2                	add    %eax,%edx
  80148f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	01 c8                	add    %ecx,%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149b:	ff 45 f8             	incl   -0x8(%ebp)
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a4:	7c d9                	jl     80147f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	eb 0c                	jmp    8014e5 <strsplit+0x31>
			*string++ = 0;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8d 50 01             	lea    0x1(%eax),%edx
  8014df:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 18                	je     801506 <strsplit+0x52>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f be c0             	movsbl %al,%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 13 fb ff ff       	call   801012 <strchr>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	75 d3                	jne    8014d9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 5a                	je     801569 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	83 f8 0f             	cmp    $0xf,%eax
  801517:	75 07                	jne    801520 <strsplit+0x6c>
		{
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb 66                	jmp    801586 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 48 01             	lea    0x1(%eax),%ecx
  801528:	8b 55 14             	mov    0x14(%ebp),%edx
  80152b:	89 0a                	mov    %ecx,(%edx)
  80152d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153e:	eb 03                	jmp    801543 <strsplit+0x8f>
			string++;
  801540:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 8b                	je     8014d7 <strsplit+0x23>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 b5 fa ff ff       	call   801012 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	74 dc                	je     801540 <strsplit+0x8c>
			string++;
	}
  801564:	e9 6e ff ff ff       	jmp    8014d7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801569:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80158e:	a1 04 50 80 00       	mov    0x805004,%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1f                	je     8015b6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801597:	e8 1d 00 00 00       	call   8015b9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	68 10 40 80 00       	push   $0x804010
  8015a4:	e8 55 f2 ff ff       	call   8007fe <cprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015ac:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8015b3:	00 00 00 
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8015bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8015c6:	00 00 00 
  8015c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8015d0:	00 00 00 
  8015d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8015da:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8015dd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8015e4:	00 00 00 
  8015e7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8015ee:	00 00 00 
  8015f1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015f8:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8015fb:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801602:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801605:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80160c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801616:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80161b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801620:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801625:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801634:	2d 00 10 00 00       	sub    $0x1000,%eax
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	6a 06                	push   $0x6
  80163e:	ff 75 f4             	pushl  -0xc(%ebp)
  801641:	50                   	push   %eax
  801642:	e8 ee 05 00 00       	call   801c35 <sys_allocate_chunk>
  801647:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80164a:	a1 20 51 80 00       	mov    0x805120,%eax
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	50                   	push   %eax
  801653:	e8 63 0c 00 00       	call   8022bb <initialize_MemBlocksList>
  801658:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80165b:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801660:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801666:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80166d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801670:	8b 40 0c             	mov    0xc(%eax),%eax
  801673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801679:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80167e:	89 c2                	mov    %eax,%edx
  801680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801683:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801689:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801690:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801697:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169a:	8b 50 08             	mov    0x8(%eax),%edx
  80169d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a0:	01 d0                	add    %edx,%eax
  8016a2:	48                   	dec    %eax
  8016a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ae:	f7 75 e0             	divl   -0x20(%ebp)
  8016b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b4:	29 d0                	sub    %edx,%eax
  8016b6:	89 c2                	mov    %eax,%edx
  8016b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016bb:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8016be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016c2:	75 14                	jne    8016d8 <initialize_dyn_block_system+0x11f>
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	68 35 40 80 00       	push   $0x804035
  8016cc:	6a 34                	push   $0x34
  8016ce:	68 53 40 80 00       	push   $0x804053
  8016d3:	e8 72 ee ff ff       	call   80054a <_panic>
  8016d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	74 10                	je     8016f1 <initialize_dyn_block_system+0x138>
  8016e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e4:	8b 00                	mov    (%eax),%eax
  8016e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e9:	8b 52 04             	mov    0x4(%edx),%edx
  8016ec:	89 50 04             	mov    %edx,0x4(%eax)
  8016ef:	eb 0b                	jmp    8016fc <initialize_dyn_block_system+0x143>
  8016f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f4:	8b 40 04             	mov    0x4(%eax),%eax
  8016f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8016fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ff:	8b 40 04             	mov    0x4(%eax),%eax
  801702:	85 c0                	test   %eax,%eax
  801704:	74 0f                	je     801715 <initialize_dyn_block_system+0x15c>
  801706:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801709:	8b 40 04             	mov    0x4(%eax),%eax
  80170c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80170f:	8b 12                	mov    (%edx),%edx
  801711:	89 10                	mov    %edx,(%eax)
  801713:	eb 0a                	jmp    80171f <initialize_dyn_block_system+0x166>
  801715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801718:	8b 00                	mov    (%eax),%eax
  80171a:	a3 48 51 80 00       	mov    %eax,0x805148
  80171f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801732:	a1 54 51 80 00       	mov    0x805154,%eax
  801737:	48                   	dec    %eax
  801738:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	ff 75 e8             	pushl  -0x18(%ebp)
  801743:	e8 c4 13 00 00       	call   802b0c <insert_sorted_with_merge_freeList>
  801748:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80174b:	90                   	nop
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <malloc>:
//=================================



void* malloc(uint32 size)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801754:	e8 2f fe ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801759:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80175d:	75 07                	jne    801766 <malloc+0x18>
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
  801764:	eb 71                	jmp    8017d7 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801766:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80176d:	76 07                	jbe    801776 <malloc+0x28>
	return NULL;
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
  801774:	eb 61                	jmp    8017d7 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801776:	e8 88 08 00 00       	call   802003 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80177b:	85 c0                	test   %eax,%eax
  80177d:	74 53                	je     8017d2 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80177f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801786:	8b 55 08             	mov    0x8(%ebp),%edx
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	01 d0                	add    %edx,%eax
  80178e:	48                   	dec    %eax
  80178f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801795:	ba 00 00 00 00       	mov    $0x0,%edx
  80179a:	f7 75 f4             	divl   -0xc(%ebp)
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	29 d0                	sub    %edx,%eax
  8017a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8017ab:	e8 d2 0d 00 00       	call   802582 <alloc_block_FF>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8017b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017ba:	74 16                	je     8017d2 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8017bc:	83 ec 0c             	sub    $0xc,%esp
  8017bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c2:	e8 0c 0c 00 00       	call   8023d3 <insert_sorted_allocList>
  8017c7:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8017ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017cd:	8b 40 08             	mov    0x8(%eax),%eax
  8017d0:	eb 05                	jmp    8017d7 <malloc+0x89>
    }

			}


	return NULL;
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f6:	68 40 50 80 00       	push   $0x805040
  8017fb:	e8 a0 0b 00 00       	call   8023a0 <find_block>
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801809:	8b 50 0c             	mov    0xc(%eax),%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	52                   	push   %edx
  801813:	50                   	push   %eax
  801814:	e8 e4 03 00 00       	call   801bfd <sys_free_user_mem>
  801819:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80181c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801820:	75 17                	jne    801839 <free+0x60>
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 35 40 80 00       	push   $0x804035
  80182a:	68 84 00 00 00       	push   $0x84
  80182f:	68 53 40 80 00       	push   $0x804053
  801834:	e8 11 ed ff ff       	call   80054a <_panic>
  801839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 10                	je     801852 <free+0x79>
  801842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80184a:	8b 52 04             	mov    0x4(%edx),%edx
  80184d:	89 50 04             	mov    %edx,0x4(%eax)
  801850:	eb 0b                	jmp    80185d <free+0x84>
  801852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801855:	8b 40 04             	mov    0x4(%eax),%eax
  801858:	a3 44 50 80 00       	mov    %eax,0x805044
  80185d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801860:	8b 40 04             	mov    0x4(%eax),%eax
  801863:	85 c0                	test   %eax,%eax
  801865:	74 0f                	je     801876 <free+0x9d>
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	8b 40 04             	mov    0x4(%eax),%eax
  80186d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801870:	8b 12                	mov    (%edx),%edx
  801872:	89 10                	mov    %edx,(%eax)
  801874:	eb 0a                	jmp    801880 <free+0xa7>
  801876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	a3 40 50 80 00       	mov    %eax,0x805040
  801880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801893:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801898:	48                   	dec    %eax
  801899:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8018a4:	e8 63 12 00 00       	call   802b0c <insert_sorted_with_merge_freeList>
  8018a9:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8018ac:	90                   	nop
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 38             	sub    $0x38,%esp
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018bb:	e8 c8 fc ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c4:	75 0a                	jne    8018d0 <smalloc+0x21>
  8018c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cb:	e9 a0 00 00 00       	jmp    801970 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8018d0:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8018d7:	76 0a                	jbe    8018e3 <smalloc+0x34>
		return NULL;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018de:	e9 8d 00 00 00       	jmp    801970 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018e3:	e8 1b 07 00 00       	call   802003 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	74 7f                	je     80196b <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8018ec:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	48                   	dec    %eax
  8018fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	f7 75 f4             	divl   -0xc(%ebp)
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190d:	29 d0                	sub    %edx,%eax
  80190f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801912:	83 ec 0c             	sub    $0xc,%esp
  801915:	ff 75 ec             	pushl  -0x14(%ebp)
  801918:	e8 65 0c 00 00       	call   802582 <alloc_block_FF>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801923:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801927:	74 42                	je     80196b <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	ff 75 e8             	pushl  -0x18(%ebp)
  80192f:	e8 9f 0a 00 00       	call   8023d3 <insert_sorted_allocList>
  801934:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80193a:	8b 40 08             	mov    0x8(%eax),%eax
  80193d:	89 c2                	mov    %eax,%edx
  80193f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	e8 38 04 00 00       	call   801d88 <sys_createSharedObject>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80195a:	79 07                	jns    801963 <smalloc+0xb4>
	    		  return NULL;
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	eb 0d                	jmp    801970 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801966:	8b 40 08             	mov    0x8(%eax),%eax
  801969:	eb 05                	jmp    801970 <smalloc+0xc1>


				}


		return NULL;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801978:	e8 0b fc ff ff       	call   801588 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80197d:	e8 81 06 00 00       	call   802003 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801982:	85 c0                	test   %eax,%eax
  801984:	0f 84 9f 00 00 00    	je     801a29 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 1a 04 00 00       	call   801db2 <sys_getSizeOfSharedObject>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80199e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a2:	79 0a                	jns    8019ae <sget+0x3c>
		return NULL;
  8019a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a9:	e9 80 00 00 00       	jmp    801a2e <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8019ae:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bb:	01 d0                	add    %edx,%eax
  8019bd:	48                   	dec    %eax
  8019be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c9:	f7 75 f0             	divl   -0x10(%ebp)
  8019cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cf:	29 d0                	sub    %edx,%eax
  8019d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8019da:	e8 a3 0b 00 00       	call   802582 <alloc_block_FF>
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8019e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019e9:	74 3e                	je     801a29 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8019eb:	83 ec 0c             	sub    $0xc,%esp
  8019ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019f1:	e8 dd 09 00 00       	call   8023d3 <insert_sorted_allocList>
  8019f6:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8019f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fc:	8b 40 08             	mov    0x8(%eax),%eax
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	50                   	push   %eax
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	ff 75 08             	pushl  0x8(%ebp)
  801a09:	e8 c1 03 00 00       	call   801dcf <sys_getSharedObject>
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801a14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a18:	79 07                	jns    801a21 <sget+0xaf>
	    		  return NULL;
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1f:	eb 0d                	jmp    801a2e <sget+0xbc>
	  	return(void*) returned_block->sva;
  801a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a24:	8b 40 08             	mov    0x8(%eax),%eax
  801a27:	eb 05                	jmp    801a2e <sget+0xbc>
	      }
	}
	   return NULL;
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a36:	e8 4d fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	68 60 40 80 00       	push   $0x804060
  801a43:	68 12 01 00 00       	push   $0x112
  801a48:	68 53 40 80 00       	push   $0x804053
  801a4d:	e8 f8 ea ff ff       	call   80054a <_panic>

00801a52 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	68 88 40 80 00       	push   $0x804088
  801a60:	68 26 01 00 00       	push   $0x126
  801a65:	68 53 40 80 00       	push   $0x804053
  801a6a:	e8 db ea ff ff       	call   80054a <_panic>

00801a6f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	68 ac 40 80 00       	push   $0x8040ac
  801a7d:	68 31 01 00 00       	push   $0x131
  801a82:	68 53 40 80 00       	push   $0x804053
  801a87:	e8 be ea ff ff       	call   80054a <_panic>

00801a8c <shrink>:

}
void shrink(uint32 newSize)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	68 ac 40 80 00       	push   $0x8040ac
  801a9a:	68 36 01 00 00       	push   $0x136
  801a9f:	68 53 40 80 00       	push   $0x804053
  801aa4:	e8 a1 ea ff ff       	call   80054a <_panic>

00801aa9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 ac 40 80 00       	push   $0x8040ac
  801ab7:	68 3b 01 00 00       	push   $0x13b
  801abc:	68 53 40 80 00       	push   $0x804053
  801ac1:	e8 84 ea ff ff       	call   80054a <_panic>

00801ac6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	57                   	push   %edi
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801adb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ade:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ae1:	cd 30                	int    $0x30
  801ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae9:	83 c4 10             	add    $0x10,%esp
  801aec:	5b                   	pop    %ebx
  801aed:	5e                   	pop    %esi
  801aee:	5f                   	pop    %edi
  801aef:	5d                   	pop    %ebp
  801af0:	c3                   	ret    

00801af1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 45 10             	mov    0x10(%ebp),%eax
  801afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801afd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	50                   	push   %eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	e8 b2 ff ff ff       	call   801ac6 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	90                   	nop
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 01                	push   $0x1
  801b29:	e8 98 ff ff ff       	call   801ac6 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 05                	push   $0x5
  801b46:	e8 7b ff ff ff       	call   801ac6 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	56                   	push   %esi
  801b54:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b55:	8b 75 18             	mov    0x18(%ebp),%esi
  801b58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	56                   	push   %esi
  801b65:	53                   	push   %ebx
  801b66:	51                   	push   %ecx
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	6a 06                	push   $0x6
  801b6b:	e8 56 ff ff ff       	call   801ac6 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5e                   	pop    %esi
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 07                	push   $0x7
  801b8d:	e8 34 ff ff ff       	call   801ac6 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	6a 08                	push   $0x8
  801ba8:	e8 19 ff ff ff       	call   801ac6 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 09                	push   $0x9
  801bc1:	e8 00 ff ff ff       	call   801ac6 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 0a                	push   $0xa
  801bda:	e8 e7 fe ff ff       	call   801ac6 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 0b                	push   $0xb
  801bf3:	e8 ce fe ff ff       	call   801ac6 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	6a 0f                	push   $0xf
  801c0e:	e8 b3 fe ff ff       	call   801ac6 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
	return;
  801c16:	90                   	nop
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	ff 75 08             	pushl  0x8(%ebp)
  801c28:	6a 10                	push   $0x10
  801c2a:	e8 97 fe ff ff       	call   801ac6 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c32:	90                   	nop
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 10             	pushl  0x10(%ebp)
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	6a 11                	push   $0x11
  801c47:	e8 7a fe ff ff       	call   801ac6 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4f:	90                   	nop
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 0c                	push   $0xc
  801c61:	e8 60 fe ff ff       	call   801ac6 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 08             	pushl  0x8(%ebp)
  801c79:	6a 0d                	push   $0xd
  801c7b:	e8 46 fe ff ff       	call   801ac6 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 0e                	push   $0xe
  801c94:	e8 2d fe ff ff       	call   801ac6 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 13                	push   $0x13
  801cae:	e8 13 fe ff ff       	call   801ac6 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 14                	push   $0x14
  801cc8:	e8 f9 fd ff ff       	call   801ac6 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	90                   	nop
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 04             	sub    $0x4,%esp
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cdf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	50                   	push   %eax
  801cec:	6a 15                	push   $0x15
  801cee:	e8 d3 fd ff ff       	call   801ac6 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	90                   	nop
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 16                	push   $0x16
  801d08:	e8 b9 fd ff ff       	call   801ac6 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	50                   	push   %eax
  801d23:	6a 17                	push   $0x17
  801d25:	e8 9c fd ff ff       	call   801ac6 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 1a                	push   $0x1a
  801d42:	e8 7f fd ff ff       	call   801ac6 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	52                   	push   %edx
  801d5c:	50                   	push   %eax
  801d5d:	6a 18                	push   $0x18
  801d5f:	e8 62 fd ff ff       	call   801ac6 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	90                   	nop
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	52                   	push   %edx
  801d7a:	50                   	push   %eax
  801d7b:	6a 19                	push   $0x19
  801d7d:	e8 44 fd ff ff       	call   801ac6 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	90                   	nop
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	51                   	push   %ecx
  801da1:	52                   	push   %edx
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	50                   	push   %eax
  801da6:	6a 1b                	push   $0x1b
  801da8:	e8 19 fd ff ff       	call   801ac6 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	6a 1c                	push   $0x1c
  801dc5:	e8 fc fc ff ff       	call   801ac6 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	51                   	push   %ecx
  801de0:	52                   	push   %edx
  801de1:	50                   	push   %eax
  801de2:	6a 1d                	push   $0x1d
  801de4:	e8 dd fc ff ff       	call   801ac6 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	52                   	push   %edx
  801dfe:	50                   	push   %eax
  801dff:	6a 1e                	push   $0x1e
  801e01:	e8 c0 fc ff ff       	call   801ac6 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 1f                	push   $0x1f
  801e1a:	e8 a7 fc ff ff       	call   801ac6 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	ff 75 14             	pushl  0x14(%ebp)
  801e2f:	ff 75 10             	pushl  0x10(%ebp)
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	50                   	push   %eax
  801e36:	6a 20                	push   $0x20
  801e38:	e8 89 fc ff ff       	call   801ac6 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	50                   	push   %eax
  801e51:	6a 21                	push   $0x21
  801e53:	e8 6e fc ff ff       	call   801ac6 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	50                   	push   %eax
  801e6d:	6a 22                	push   $0x22
  801e6f:	e8 52 fc ff ff       	call   801ac6 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 02                	push   $0x2
  801e88:	e8 39 fc ff ff       	call   801ac6 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 03                	push   $0x3
  801ea1:	e8 20 fc ff ff       	call   801ac6 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 04                	push   $0x4
  801eba:	e8 07 fc ff ff       	call   801ac6 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 23                	push   $0x23
  801ed3:	e8 ee fb ff ff       	call   801ac6 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	90                   	nop
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ee4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee7:	8d 50 04             	lea    0x4(%eax),%edx
  801eea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	6a 24                	push   $0x24
  801ef7:	e8 ca fb ff ff       	call   801ac6 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return result;
  801eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f08:	89 01                	mov    %eax,(%ecx)
  801f0a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	c9                   	leave  
  801f11:	c2 04 00             	ret    $0x4

00801f14 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	ff 75 10             	pushl  0x10(%ebp)
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	6a 12                	push   $0x12
  801f26:	e8 9b fb ff ff       	call   801ac6 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2e:	90                   	nop
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 25                	push   $0x25
  801f40:	e8 81 fb ff ff       	call   801ac6 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f56:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	50                   	push   %eax
  801f63:	6a 26                	push   $0x26
  801f65:	e8 5c fb ff ff       	call   801ac6 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6d:	90                   	nop
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <rsttst>:
void rsttst()
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 28                	push   $0x28
  801f7f:	e8 42 fb ff ff       	call   801ac6 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
	return ;
  801f87:	90                   	nop
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	8b 45 14             	mov    0x14(%ebp),%eax
  801f93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f96:	8b 55 18             	mov    0x18(%ebp),%edx
  801f99:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f9d:	52                   	push   %edx
  801f9e:	50                   	push   %eax
  801f9f:	ff 75 10             	pushl  0x10(%ebp)
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	6a 27                	push   $0x27
  801faa:	e8 17 fb ff ff       	call   801ac6 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb2:	90                   	nop
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <chktst>:
void chktst(uint32 n)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	6a 29                	push   $0x29
  801fc5:	e8 fc fa ff ff       	call   801ac6 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcd:	90                   	nop
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <inctst>:

void inctst()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 2a                	push   $0x2a
  801fdf:	e8 e2 fa ff ff       	call   801ac6 <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe7:	90                   	nop
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <gettst>:
uint32 gettst()
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 2b                	push   $0x2b
  801ff9:	e8 c8 fa ff ff       	call   801ac6 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 2c                	push   $0x2c
  802015:	e8 ac fa ff ff       	call   801ac6 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
  80201d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802020:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802024:	75 07                	jne    80202d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802026:	b8 01 00 00 00       	mov    $0x1,%eax
  80202b:	eb 05                	jmp    802032 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 2c                	push   $0x2c
  802046:	e8 7b fa ff ff       	call   801ac6 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
  80204e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802051:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802055:	75 07                	jne    80205e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802057:	b8 01 00 00 00       	mov    $0x1,%eax
  80205c:	eb 05                	jmp    802063 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 2c                	push   $0x2c
  802077:	e8 4a fa ff ff       	call   801ac6 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
  80207f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802082:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802086:	75 07                	jne    80208f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802088:	b8 01 00 00 00       	mov    $0x1,%eax
  80208d:	eb 05                	jmp    802094 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 2c                	push   $0x2c
  8020a8:	e8 19 fa ff ff       	call   801ac6 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
  8020b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020b3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020b7:	75 07                	jne    8020c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020be:	eb 05                	jmp    8020c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	6a 2d                	push   $0x2d
  8020d7:	e8 ea f9 ff ff       	call   801ac6 <syscall>
  8020dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8020df:	90                   	nop
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	6a 00                	push   $0x0
  8020f4:	53                   	push   %ebx
  8020f5:	51                   	push   %ecx
  8020f6:	52                   	push   %edx
  8020f7:	50                   	push   %eax
  8020f8:	6a 2e                	push   $0x2e
  8020fa:	e8 c7 f9 ff ff       	call   801ac6 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80210a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	52                   	push   %edx
  802117:	50                   	push   %eax
  802118:	6a 2f                	push   $0x2f
  80211a:	e8 a7 f9 ff ff       	call   801ac6 <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80212a:	83 ec 0c             	sub    $0xc,%esp
  80212d:	68 bc 40 80 00       	push   $0x8040bc
  802132:	e8 c7 e6 ff ff       	call   8007fe <cprintf>
  802137:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80213a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802141:	83 ec 0c             	sub    $0xc,%esp
  802144:	68 e8 40 80 00       	push   $0x8040e8
  802149:	e8 b0 e6 ff ff       	call   8007fe <cprintf>
  80214e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802151:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802155:	a1 38 51 80 00       	mov    0x805138,%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	eb 56                	jmp    8021b5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80215f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802163:	74 1c                	je     802181 <print_mem_block_lists+0x5d>
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 50 08             	mov    0x8(%eax),%edx
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	8b 48 08             	mov    0x8(%eax),%ecx
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	8b 40 0c             	mov    0xc(%eax),%eax
  802177:	01 c8                	add    %ecx,%eax
  802179:	39 c2                	cmp    %eax,%edx
  80217b:	73 04                	jae    802181 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80217d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 50 08             	mov    0x8(%eax),%edx
  802187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218a:	8b 40 0c             	mov    0xc(%eax),%eax
  80218d:	01 c2                	add    %eax,%edx
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 40 08             	mov    0x8(%eax),%eax
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	52                   	push   %edx
  802199:	50                   	push   %eax
  80219a:	68 fd 40 80 00       	push   $0x8040fd
  80219f:	e8 5a e6 ff ff       	call   8007fe <cprintf>
  8021a4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8021b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b9:	74 07                	je     8021c2 <print_mem_block_lists+0x9e>
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 00                	mov    (%eax),%eax
  8021c0:	eb 05                	jmp    8021c7 <print_mem_block_lists+0xa3>
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	a3 40 51 80 00       	mov    %eax,0x805140
  8021cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	75 8a                	jne    80215f <print_mem_block_lists+0x3b>
  8021d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d9:	75 84                	jne    80215f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021db:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021df:	75 10                	jne    8021f1 <print_mem_block_lists+0xcd>
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	68 0c 41 80 00       	push   $0x80410c
  8021e9:	e8 10 e6 ff ff       	call   8007fe <cprintf>
  8021ee:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021f8:	83 ec 0c             	sub    $0xc,%esp
  8021fb:	68 30 41 80 00       	push   $0x804130
  802200:	e8 f9 e5 ff ff       	call   8007fe <cprintf>
  802205:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802208:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80220c:	a1 40 50 80 00       	mov    0x805040,%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802214:	eb 56                	jmp    80226c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221a:	74 1c                	je     802238 <print_mem_block_lists+0x114>
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 50 08             	mov    0x8(%eax),%edx
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	8b 48 08             	mov    0x8(%eax),%ecx
  802228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222b:	8b 40 0c             	mov    0xc(%eax),%eax
  80222e:	01 c8                	add    %ecx,%eax
  802230:	39 c2                	cmp    %eax,%edx
  802232:	73 04                	jae    802238 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802234:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 50 08             	mov    0x8(%eax),%edx
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 40 0c             	mov    0xc(%eax),%eax
  802244:	01 c2                	add    %eax,%edx
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 40 08             	mov    0x8(%eax),%eax
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	52                   	push   %edx
  802250:	50                   	push   %eax
  802251:	68 fd 40 80 00       	push   $0x8040fd
  802256:	e8 a3 e5 ff ff       	call   8007fe <cprintf>
  80225b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802264:	a1 48 50 80 00       	mov    0x805048,%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802270:	74 07                	je     802279 <print_mem_block_lists+0x155>
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	eb 05                	jmp    80227e <print_mem_block_lists+0x15a>
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	a3 48 50 80 00       	mov    %eax,0x805048
  802283:	a1 48 50 80 00       	mov    0x805048,%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	75 8a                	jne    802216 <print_mem_block_lists+0xf2>
  80228c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802290:	75 84                	jne    802216 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802292:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802296:	75 10                	jne    8022a8 <print_mem_block_lists+0x184>
  802298:	83 ec 0c             	sub    $0xc,%esp
  80229b:	68 48 41 80 00       	push   $0x804148
  8022a0:	e8 59 e5 ff ff       	call   8007fe <cprintf>
  8022a5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022a8:	83 ec 0c             	sub    $0xc,%esp
  8022ab:	68 bc 40 80 00       	push   $0x8040bc
  8022b0:	e8 49 e5 ff ff       	call   8007fe <cprintf>
  8022b5:	83 c4 10             	add    $0x10,%esp

}
  8022b8:	90                   	nop
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8022c1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022c8:	00 00 00 
  8022cb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022d2:	00 00 00 
  8022d5:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022dc:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8022df:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8022e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022ee:	e9 9e 00 00 00       	jmp    802391 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8022f3:	a1 50 50 80 00       	mov    0x805050,%eax
  8022f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fb:	c1 e2 04             	shl    $0x4,%edx
  8022fe:	01 d0                	add    %edx,%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	75 14                	jne    802318 <initialize_MemBlocksList+0x5d>
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	68 70 41 80 00       	push   $0x804170
  80230c:	6a 48                	push   $0x48
  80230e:	68 93 41 80 00       	push   $0x804193
  802313:	e8 32 e2 ff ff       	call   80054a <_panic>
  802318:	a1 50 50 80 00       	mov    0x805050,%eax
  80231d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802320:	c1 e2 04             	shl    $0x4,%edx
  802323:	01 d0                	add    %edx,%eax
  802325:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80232b:	89 10                	mov    %edx,(%eax)
  80232d:	8b 00                	mov    (%eax),%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 18                	je     80234b <initialize_MemBlocksList+0x90>
  802333:	a1 48 51 80 00       	mov    0x805148,%eax
  802338:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80233e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802341:	c1 e1 04             	shl    $0x4,%ecx
  802344:	01 ca                	add    %ecx,%edx
  802346:	89 50 04             	mov    %edx,0x4(%eax)
  802349:	eb 12                	jmp    80235d <initialize_MemBlocksList+0xa2>
  80234b:	a1 50 50 80 00       	mov    0x805050,%eax
  802350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802353:	c1 e2 04             	shl    $0x4,%edx
  802356:	01 d0                	add    %edx,%eax
  802358:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80235d:	a1 50 50 80 00       	mov    0x805050,%eax
  802362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802365:	c1 e2 04             	shl    $0x4,%edx
  802368:	01 d0                	add    %edx,%eax
  80236a:	a3 48 51 80 00       	mov    %eax,0x805148
  80236f:	a1 50 50 80 00       	mov    0x805050,%eax
  802374:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802377:	c1 e2 04             	shl    $0x4,%edx
  80237a:	01 d0                	add    %edx,%eax
  80237c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802383:	a1 54 51 80 00       	mov    0x805154,%eax
  802388:	40                   	inc    %eax
  802389:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80238e:	ff 45 f4             	incl   -0xc(%ebp)
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	3b 45 08             	cmp    0x8(%ebp),%eax
  802397:	0f 82 56 ff ff ff    	jb     8022f3 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80239d:	90                   	nop
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8023ae:	eb 18                	jmp    8023c8 <find_block+0x28>
		{
			if(tmp->sva==va)
  8023b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b3:	8b 40 08             	mov    0x8(%eax),%eax
  8023b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023b9:	75 05                	jne    8023c0 <find_block+0x20>
			{
				return tmp;
  8023bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023be:	eb 11                	jmp    8023d1 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8023c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8023c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023cc:	75 e2                	jne    8023b0 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8023ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8023d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	0f 85 83 00 00 00    	jne    802469 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8023e6:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8023ed:	00 00 00 
  8023f0:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8023f7:	00 00 00 
  8023fa:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802401:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802408:	75 14                	jne    80241e <insert_sorted_allocList+0x4b>
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 70 41 80 00       	push   $0x804170
  802412:	6a 7f                	push   $0x7f
  802414:	68 93 41 80 00       	push   $0x804193
  802419:	e8 2c e1 ff ff       	call   80054a <_panic>
  80241e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	89 10                	mov    %edx,(%eax)
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8b 00                	mov    (%eax),%eax
  80242e:	85 c0                	test   %eax,%eax
  802430:	74 0d                	je     80243f <insert_sorted_allocList+0x6c>
  802432:	a1 40 50 80 00       	mov    0x805040,%eax
  802437:	8b 55 08             	mov    0x8(%ebp),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 08                	jmp    802447 <insert_sorted_allocList+0x74>
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 44 50 80 00       	mov    %eax,0x805044
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	a3 40 50 80 00       	mov    %eax,0x805040
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802459:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80245e:	40                   	inc    %eax
  80245f:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802464:	e9 16 01 00 00       	jmp    80257f <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	8b 50 08             	mov    0x8(%eax),%edx
  80246f:	a1 44 50 80 00       	mov    0x805044,%eax
  802474:	8b 40 08             	mov    0x8(%eax),%eax
  802477:	39 c2                	cmp    %eax,%edx
  802479:	76 68                	jbe    8024e3 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80247b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247f:	75 17                	jne    802498 <insert_sorted_allocList+0xc5>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 ac 41 80 00       	push   $0x8041ac
  802489:	68 85 00 00 00       	push   $0x85
  80248e:	68 93 41 80 00       	push   $0x804193
  802493:	e8 b2 e0 ff ff       	call   80054a <_panic>
  802498:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	89 50 04             	mov    %edx,0x4(%eax)
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	8b 40 04             	mov    0x4(%eax),%eax
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	74 0c                	je     8024ba <insert_sorted_allocList+0xe7>
  8024ae:	a1 44 50 80 00       	mov    0x805044,%eax
  8024b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b6:	89 10                	mov    %edx,(%eax)
  8024b8:	eb 08                	jmp    8024c2 <insert_sorted_allocList+0xef>
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d8:	40                   	inc    %eax
  8024d9:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024de:	e9 9c 00 00 00       	jmp    80257f <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8024e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8024e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8024eb:	e9 85 00 00 00       	jmp    802575 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	8b 50 08             	mov    0x8(%eax),%edx
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 40 08             	mov    0x8(%eax),%eax
  8024fc:	39 c2                	cmp    %eax,%edx
  8024fe:	73 6d                	jae    80256d <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802504:	74 06                	je     80250c <insert_sorted_allocList+0x139>
  802506:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250a:	75 17                	jne    802523 <insert_sorted_allocList+0x150>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 d0 41 80 00       	push   $0x8041d0
  802514:	68 90 00 00 00       	push   $0x90
  802519:	68 93 41 80 00       	push   $0x804193
  80251e:	e8 27 e0 ff ff       	call   80054a <_panic>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 50 04             	mov    0x4(%eax),%edx
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	89 50 04             	mov    %edx,0x4(%eax)
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	89 10                	mov    %edx,(%eax)
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 0d                	je     80254e <insert_sorted_allocList+0x17b>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	8b 55 08             	mov    0x8(%ebp),%edx
  80254a:	89 10                	mov    %edx,(%eax)
  80254c:	eb 08                	jmp    802556 <insert_sorted_allocList+0x183>
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	a3 40 50 80 00       	mov    %eax,0x805040
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 55 08             	mov    0x8(%ebp),%edx
  80255c:	89 50 04             	mov    %edx,0x4(%eax)
  80255f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802564:	40                   	inc    %eax
  802565:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80256a:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80256b:	eb 12                	jmp    80257f <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 00                	mov    (%eax),%eax
  802572:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802579:	0f 85 71 ff ff ff    	jne    8024f0 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80257f:	90                   	nop
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
  802585:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802588:	a1 38 51 80 00       	mov    0x805138,%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802590:	e9 76 01 00 00       	jmp    80270b <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 0c             	mov    0xc(%eax),%eax
  80259b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259e:	0f 85 8a 00 00 00    	jne    80262e <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8025a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a8:	75 17                	jne    8025c1 <alloc_block_FF+0x3f>
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	68 05 42 80 00       	push   $0x804205
  8025b2:	68 a8 00 00 00       	push   $0xa8
  8025b7:	68 93 41 80 00       	push   $0x804193
  8025bc:	e8 89 df ff ff       	call   80054a <_panic>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	74 10                	je     8025da <alloc_block_FF+0x58>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d2:	8b 52 04             	mov    0x4(%edx),%edx
  8025d5:	89 50 04             	mov    %edx,0x4(%eax)
  8025d8:	eb 0b                	jmp    8025e5 <alloc_block_FF+0x63>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 04             	mov    0x4(%eax),%eax
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	74 0f                	je     8025fe <alloc_block_FF+0x7c>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 04             	mov    0x4(%eax),%eax
  8025f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f8:	8b 12                	mov    (%edx),%edx
  8025fa:	89 10                	mov    %edx,(%eax)
  8025fc:	eb 0a                	jmp    802608 <alloc_block_FF+0x86>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	a3 38 51 80 00       	mov    %eax,0x805138
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261b:	a1 44 51 80 00       	mov    0x805144,%eax
  802620:	48                   	dec    %eax
  802621:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	e9 ea 00 00 00       	jmp    802718 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 0c             	mov    0xc(%eax),%eax
  802634:	3b 45 08             	cmp    0x8(%ebp),%eax
  802637:	0f 86 c6 00 00 00    	jbe    802703 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80263d:	a1 48 51 80 00       	mov    0x805148,%eax
  802642:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	8b 55 08             	mov    0x8(%ebp),%edx
  80264b:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 50 08             	mov    0x8(%eax),%edx
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	2b 45 08             	sub    0x8(%ebp),%eax
  802663:	89 c2                	mov    %eax,%edx
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 50 08             	mov    0x8(%eax),%edx
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	01 c2                	add    %eax,%edx
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80267c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802680:	75 17                	jne    802699 <alloc_block_FF+0x117>
  802682:	83 ec 04             	sub    $0x4,%esp
  802685:	68 05 42 80 00       	push   $0x804205
  80268a:	68 b6 00 00 00       	push   $0xb6
  80268f:	68 93 41 80 00       	push   $0x804193
  802694:	e8 b1 de ff ff       	call   80054a <_panic>
  802699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 10                	je     8026b2 <alloc_block_FF+0x130>
  8026a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026aa:	8b 52 04             	mov    0x4(%edx),%edx
  8026ad:	89 50 04             	mov    %edx,0x4(%eax)
  8026b0:	eb 0b                	jmp    8026bd <alloc_block_FF+0x13b>
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0f                	je     8026d6 <alloc_block_FF+0x154>
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d0:	8b 12                	mov    (%edx),%edx
  8026d2:	89 10                	mov    %edx,(%eax)
  8026d4:	eb 0a                	jmp    8026e0 <alloc_block_FF+0x15e>
  8026d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	a3 48 51 80 00       	mov    %eax,0x805148
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8026f8:	48                   	dec    %eax
  8026f9:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	eb 15                	jmp    802718 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80270b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270f:	0f 85 80 fe ff ff    	jne    802595 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802720:	a1 38 51 80 00       	mov    0x805138,%eax
  802725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802728:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80272f:	e9 c0 00 00 00       	jmp    8027f4 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273d:	0f 85 8a 00 00 00    	jne    8027cd <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	75 17                	jne    802760 <alloc_block_BF+0x46>
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	68 05 42 80 00       	push   $0x804205
  802751:	68 cf 00 00 00       	push   $0xcf
  802756:	68 93 41 80 00       	push   $0x804193
  80275b:	e8 ea dd ff ff       	call   80054a <_panic>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 10                	je     802779 <alloc_block_BF+0x5f>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	8b 52 04             	mov    0x4(%edx),%edx
  802774:	89 50 04             	mov    %edx,0x4(%eax)
  802777:	eb 0b                	jmp    802784 <alloc_block_BF+0x6a>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 0f                	je     80279d <alloc_block_BF+0x83>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802797:	8b 12                	mov    (%edx),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	eb 0a                	jmp    8027a7 <alloc_block_BF+0x8d>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8027bf:	48                   	dec    %eax
  8027c0:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	e9 2a 01 00 00       	jmp    8028f7 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027d6:	73 14                	jae    8027ec <alloc_block_BF+0xd2>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e1:	76 09                	jbe    8027ec <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8027f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f8:	0f 85 36 ff ff ff    	jne    802734 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8027fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802803:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802806:	e9 dd 00 00 00       	jmp    8028e8 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802814:	0f 85 c6 00 00 00    	jne    8028e0 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80281a:	a1 48 51 80 00       	mov    0x805148,%eax
  80281f:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 50 08             	mov    0x8(%eax),%edx
  802828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282b:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80282e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802831:	8b 55 08             	mov    0x8(%ebp),%edx
  802834:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 50 08             	mov    0x8(%eax),%edx
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	01 c2                	add    %eax,%edx
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 0c             	mov    0xc(%eax),%eax
  80284e:	2b 45 08             	sub    0x8(%ebp),%eax
  802851:	89 c2                	mov    %eax,%edx
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802859:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80285d:	75 17                	jne    802876 <alloc_block_BF+0x15c>
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 05 42 80 00       	push   $0x804205
  802867:	68 eb 00 00 00       	push   $0xeb
  80286c:	68 93 41 80 00       	push   $0x804193
  802871:	e8 d4 dc ff ff       	call   80054a <_panic>
  802876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 10                	je     80288f <alloc_block_BF+0x175>
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802887:	8b 52 04             	mov    0x4(%edx),%edx
  80288a:	89 50 04             	mov    %edx,0x4(%eax)
  80288d:	eb 0b                	jmp    80289a <alloc_block_BF+0x180>
  80288f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0f                	je     8028b3 <alloc_block_BF+0x199>
  8028a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a7:	8b 40 04             	mov    0x4(%eax),%eax
  8028aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ad:	8b 12                	mov    (%edx),%edx
  8028af:	89 10                	mov    %edx,(%eax)
  8028b1:	eb 0a                	jmp    8028bd <alloc_block_BF+0x1a3>
  8028b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8028bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d5:	48                   	dec    %eax
  8028d6:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	eb 17                	jmp    8028f7 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8028e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ec:	0f 85 19 ff ff ff    	jne    80280b <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8028f2:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8028ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	75 19                	jne    802921 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802908:	83 ec 0c             	sub    $0xc,%esp
  80290b:	ff 75 08             	pushl  0x8(%ebp)
  80290e:	e8 6f fc ff ff       	call   802582 <alloc_block_FF>
  802913:	83 c4 10             	add    $0x10,%esp
  802916:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	e9 e9 01 00 00       	jmp    802b0a <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802921:	a1 44 50 80 00       	mov    0x805044,%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80292c:	a1 44 50 80 00       	mov    0x805044,%eax
  802931:	8b 50 0c             	mov    0xc(%eax),%edx
  802934:	a1 44 50 80 00       	mov    0x805044,%eax
  802939:	8b 40 08             	mov    0x8(%eax),%eax
  80293c:	01 d0                	add    %edx,%eax
  80293e:	83 ec 08             	sub    $0x8,%esp
  802941:	50                   	push   %eax
  802942:	68 38 51 80 00       	push   $0x805138
  802947:	e8 54 fa ff ff       	call   8023a0 <find_block>
  80294c:	83 c4 10             	add    $0x10,%esp
  80294f:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 0c             	mov    0xc(%eax),%eax
  802958:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295b:	0f 85 9b 00 00 00    	jne    8029fc <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 50 0c             	mov    0xc(%eax),%edx
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 08             	mov    0x8(%eax),%eax
  80296d:	01 d0                	add    %edx,%eax
  80296f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	75 17                	jne    80298f <alloc_block_NF+0x96>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 05 42 80 00       	push   $0x804205
  802980:	68 1a 01 00 00       	push   $0x11a
  802985:	68 93 41 80 00       	push   $0x804193
  80298a:	e8 bb db ff ff       	call   80054a <_panic>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 10                	je     8029a8 <alloc_block_NF+0xaf>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a0:	8b 52 04             	mov    0x4(%edx),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	eb 0b                	jmp    8029b3 <alloc_block_NF+0xba>
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 0f                	je     8029cc <alloc_block_NF+0xd3>
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c6:	8b 12                	mov    (%edx),%edx
  8029c8:	89 10                	mov    %edx,(%eax)
  8029ca:	eb 0a                	jmp    8029d6 <alloc_block_NF+0xdd>
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ee:	48                   	dec    %eax
  8029ef:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	e9 0e 01 00 00       	jmp    802b0a <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a05:	0f 86 cf 00 00 00    	jbe    802ada <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a16:	8b 55 08             	mov    0x8(%ebp),%edx
  802a19:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 50 08             	mov    0x8(%eax),%edx
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	01 c2                	add    %eax,%edx
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a42:	89 c2                	mov    %eax,%edx
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 08             	mov    0x8(%eax),%eax
  802a50:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802a53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a57:	75 17                	jne    802a70 <alloc_block_NF+0x177>
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 05 42 80 00       	push   $0x804205
  802a61:	68 28 01 00 00       	push   $0x128
  802a66:	68 93 41 80 00       	push   $0x804193
  802a6b:	e8 da da ff ff       	call   80054a <_panic>
  802a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	74 10                	je     802a89 <alloc_block_NF+0x190>
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	8b 00                	mov    (%eax),%eax
  802a7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a81:	8b 52 04             	mov    0x4(%edx),%edx
  802a84:	89 50 04             	mov    %edx,0x4(%eax)
  802a87:	eb 0b                	jmp    802a94 <alloc_block_NF+0x19b>
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a97:	8b 40 04             	mov    0x4(%eax),%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	74 0f                	je     802aad <alloc_block_NF+0x1b4>
  802a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa7:	8b 12                	mov    (%edx),%edx
  802aa9:	89 10                	mov    %edx,(%eax)
  802aab:	eb 0a                	jmp    802ab7 <alloc_block_NF+0x1be>
  802aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aca:	a1 54 51 80 00       	mov    0x805154,%eax
  802acf:	48                   	dec    %eax
  802ad0:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	eb 30                	jmp    802b0a <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802ada:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802adf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ae2:	75 0a                	jne    802aee <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802ae4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aec:	eb 08                	jmp    802af6 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 08             	mov    0x8(%eax),%eax
  802afc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aff:	0f 85 4d fe ff ff    	jne    802952 <alloc_block_NF+0x59>

			return NULL;
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	53                   	push   %ebx
  802b10:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802b13:	a1 38 51 80 00       	mov    0x805138,%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	0f 85 86 00 00 00    	jne    802ba6 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802b20:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802b27:	00 00 00 
  802b2a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802b31:	00 00 00 
  802b34:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802b3b:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b42:	75 17                	jne    802b5b <insert_sorted_with_merge_freeList+0x4f>
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	68 70 41 80 00       	push   $0x804170
  802b4c:	68 48 01 00 00       	push   $0x148
  802b51:	68 93 41 80 00       	push   $0x804193
  802b56:	e8 ef d9 ff ff       	call   80054a <_panic>
  802b5b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	89 10                	mov    %edx,(%eax)
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 0d                	je     802b7c <insert_sorted_with_merge_freeList+0x70>
  802b6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802b74:	8b 55 08             	mov    0x8(%ebp),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	eb 08                	jmp    802b84 <insert_sorted_with_merge_freeList+0x78>
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	a3 38 51 80 00       	mov    %eax,0x805138
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 44 51 80 00       	mov    0x805144,%eax
  802b9b:	40                   	inc    %eax
  802b9c:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802ba1:	e9 73 07 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 50 08             	mov    0x8(%eax),%edx
  802bac:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bb1:	8b 40 08             	mov    0x8(%eax),%eax
  802bb4:	39 c2                	cmp    %eax,%edx
  802bb6:	0f 86 84 00 00 00    	jbe    802c40 <insert_sorted_with_merge_freeList+0x134>
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 50 08             	mov    0x8(%eax),%edx
  802bc2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bc7:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bcf:	8b 40 08             	mov    0x8(%eax),%eax
  802bd2:	01 c8                	add    %ecx,%eax
  802bd4:	39 c2                	cmp    %eax,%edx
  802bd6:	74 68                	je     802c40 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdc:	75 17                	jne    802bf5 <insert_sorted_with_merge_freeList+0xe9>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 ac 41 80 00       	push   $0x8041ac
  802be6:	68 4c 01 00 00       	push   $0x14c
  802beb:	68 93 41 80 00       	push   $0x804193
  802bf0:	e8 55 d9 ff ff       	call   80054a <_panic>
  802bf5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	89 50 04             	mov    %edx,0x4(%eax)
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 0c                	je     802c17 <insert_sorted_with_merge_freeList+0x10b>
  802c0b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c10:	8b 55 08             	mov    0x8(%ebp),%edx
  802c13:	89 10                	mov    %edx,(%eax)
  802c15:	eb 08                	jmp    802c1f <insert_sorted_with_merge_freeList+0x113>
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c30:	a1 44 51 80 00       	mov    0x805144,%eax
  802c35:	40                   	inc    %eax
  802c36:	a3 44 51 80 00       	mov    %eax,0x805144
  802c3b:	e9 d9 06 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c4b:	8b 40 08             	mov    0x8(%eax),%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	0f 86 b5 00 00 00    	jbe    802d0b <insert_sorted_with_merge_freeList+0x1ff>
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 50 08             	mov    0x8(%eax),%edx
  802c5c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c61:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c64:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c69:	8b 40 08             	mov    0x8(%eax),%eax
  802c6c:	01 c8                	add    %ecx,%eax
  802c6e:	39 c2                	cmp    %eax,%edx
  802c70:	0f 85 95 00 00 00    	jne    802d0b <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802c76:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c7b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c81:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c84:	8b 55 08             	mov    0x8(%ebp),%edx
  802c87:	8b 52 0c             	mov    0xc(%edx),%edx
  802c8a:	01 ca                	add    %ecx,%edx
  802c8c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca7:	75 17                	jne    802cc0 <insert_sorted_with_merge_freeList+0x1b4>
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	68 70 41 80 00       	push   $0x804170
  802cb1:	68 54 01 00 00       	push   $0x154
  802cb6:	68 93 41 80 00       	push   $0x804193
  802cbb:	e8 8a d8 ff ff       	call   80054a <_panic>
  802cc0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	89 10                	mov    %edx,(%eax)
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 0d                	je     802ce1 <insert_sorted_with_merge_freeList+0x1d5>
  802cd4:	a1 48 51 80 00       	mov    0x805148,%eax
  802cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	eb 08                	jmp    802ce9 <insert_sorted_with_merge_freeList+0x1dd>
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802d00:	40                   	inc    %eax
  802d01:	a3 54 51 80 00       	mov    %eax,0x805154
  802d06:	e9 0e 06 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	8b 50 08             	mov    0x8(%eax),%edx
  802d11:	a1 38 51 80 00       	mov    0x805138,%eax
  802d16:	8b 40 08             	mov    0x8(%eax),%eax
  802d19:	39 c2                	cmp    %eax,%edx
  802d1b:	0f 83 c1 00 00 00    	jae    802de2 <insert_sorted_with_merge_freeList+0x2d6>
  802d21:	a1 38 51 80 00       	mov    0x805138,%eax
  802d26:	8b 50 08             	mov    0x8(%eax),%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	8b 48 08             	mov    0x8(%eax),%ecx
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 40 0c             	mov    0xc(%eax),%eax
  802d35:	01 c8                	add    %ecx,%eax
  802d37:	39 c2                	cmp    %eax,%edx
  802d39:	0f 85 a3 00 00 00    	jne    802de2 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d44:	8b 55 08             	mov    0x8(%ebp),%edx
  802d47:	8b 52 08             	mov    0x8(%edx),%edx
  802d4a:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802d4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d52:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d58:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5e:	8b 52 0c             	mov    0xc(%edx),%edx
  802d61:	01 ca                	add    %ecx,%edx
  802d63:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7e:	75 17                	jne    802d97 <insert_sorted_with_merge_freeList+0x28b>
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	68 70 41 80 00       	push   $0x804170
  802d88:	68 5d 01 00 00       	push   $0x15d
  802d8d:	68 93 41 80 00       	push   $0x804193
  802d92:	e8 b3 d7 ff ff       	call   80054a <_panic>
  802d97:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0d                	je     802db8 <insert_sorted_with_merge_freeList+0x2ac>
  802dab:	a1 48 51 80 00       	mov    0x805148,%eax
  802db0:	8b 55 08             	mov    0x8(%ebp),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 08                	jmp    802dc0 <insert_sorted_with_merge_freeList+0x2b4>
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd2:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd7:	40                   	inc    %eax
  802dd8:	a3 54 51 80 00       	mov    %eax,0x805154
  802ddd:	e9 37 05 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 50 08             	mov    0x8(%eax),%edx
  802de8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ded:	8b 40 08             	mov    0x8(%eax),%eax
  802df0:	39 c2                	cmp    %eax,%edx
  802df2:	0f 83 82 00 00 00    	jae    802e7a <insert_sorted_with_merge_freeList+0x36e>
  802df8:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfd:	8b 50 08             	mov    0x8(%eax),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 48 08             	mov    0x8(%eax),%ecx
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0c:	01 c8                	add    %ecx,%eax
  802e0e:	39 c2                	cmp    %eax,%edx
  802e10:	74 68                	je     802e7a <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e16:	75 17                	jne    802e2f <insert_sorted_with_merge_freeList+0x323>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 70 41 80 00       	push   $0x804170
  802e20:	68 62 01 00 00       	push   $0x162
  802e25:	68 93 41 80 00       	push   $0x804193
  802e2a:	e8 1b d7 ff ff       	call   80054a <_panic>
  802e2f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	89 10                	mov    %edx,(%eax)
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0d                	je     802e50 <insert_sorted_with_merge_freeList+0x344>
  802e43:	a1 38 51 80 00       	mov    0x805138,%eax
  802e48:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4b:	89 50 04             	mov    %edx,0x4(%eax)
  802e4e:	eb 08                	jmp    802e58 <insert_sorted_with_merge_freeList+0x34c>
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e6f:	40                   	inc    %eax
  802e70:	a3 44 51 80 00       	mov    %eax,0x805144
  802e75:	e9 9f 04 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802e7a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802e84:	e9 84 04 00 00       	jmp    80330d <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 50 08             	mov    0x8(%eax),%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 86 a9 00 00 00    	jbe    802f46 <insert_sorted_with_merge_freeList+0x43a>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaf:	01 c8                	add    %ecx,%eax
  802eb1:	39 c2                	cmp    %eax,%edx
  802eb3:	0f 84 8d 00 00 00    	je     802f46 <insert_sorted_with_merge_freeList+0x43a>
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	8b 50 08             	mov    0x8(%eax),%edx
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 40 04             	mov    0x4(%eax),%eax
  802ec5:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed1:	01 c8                	add    %ecx,%eax
  802ed3:	39 c2                	cmp    %eax,%edx
  802ed5:	74 6f                	je     802f46 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edb:	74 06                	je     802ee3 <insert_sorted_with_merge_freeList+0x3d7>
  802edd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee1:	75 17                	jne    802efa <insert_sorted_with_merge_freeList+0x3ee>
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	68 d0 41 80 00       	push   $0x8041d0
  802eeb:	68 6b 01 00 00       	push   $0x16b
  802ef0:	68 93 41 80 00       	push   $0x804193
  802ef5:	e8 50 d6 ff ff       	call   80054a <_panic>
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 04             	mov    0x4(%eax),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	89 50 04             	mov    %edx,0x4(%eax)
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0d                	je     802f25 <insert_sorted_with_merge_freeList+0x419>
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 08                	jmp    802f2d <insert_sorted_with_merge_freeList+0x421>
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 55 08             	mov    0x8(%ebp),%edx
  802f33:	89 50 04             	mov    %edx,0x4(%eax)
  802f36:	a1 44 51 80 00       	mov    0x805144,%eax
  802f3b:	40                   	inc    %eax
  802f3c:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  802f41:	e9 d3 03 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 50 08             	mov    0x8(%eax),%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 40 08             	mov    0x8(%eax),%eax
  802f52:	39 c2                	cmp    %eax,%edx
  802f54:	0f 86 da 00 00 00    	jbe    803034 <insert_sorted_with_merge_freeList+0x528>
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 50 08             	mov    0x8(%eax),%edx
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 48 08             	mov    0x8(%eax),%ecx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	01 c8                	add    %ecx,%eax
  802f6e:	39 c2                	cmp    %eax,%edx
  802f70:	0f 85 be 00 00 00    	jne    803034 <insert_sorted_with_merge_freeList+0x528>
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	8b 50 08             	mov    0x8(%eax),%edx
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	8b 48 08             	mov    0x8(%eax),%ecx
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	01 c8                	add    %ecx,%eax
  802f90:	39 c2                	cmp    %eax,%edx
  802f92:	0f 84 9c 00 00 00    	je     803034 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	8b 50 08             	mov    0x8(%eax),%edx
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 50 0c             	mov    0xc(%eax),%edx
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb0:	01 c2                	add    %eax,%edx
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd0:	75 17                	jne    802fe9 <insert_sorted_with_merge_freeList+0x4dd>
  802fd2:	83 ec 04             	sub    $0x4,%esp
  802fd5:	68 70 41 80 00       	push   $0x804170
  802fda:	68 74 01 00 00       	push   $0x174
  802fdf:	68 93 41 80 00       	push   $0x804193
  802fe4:	e8 61 d5 ff ff       	call   80054a <_panic>
  802fe9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	89 10                	mov    %edx,(%eax)
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	74 0d                	je     80300a <insert_sorted_with_merge_freeList+0x4fe>
  802ffd:	a1 48 51 80 00       	mov    0x805148,%eax
  803002:	8b 55 08             	mov    0x8(%ebp),%edx
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	eb 08                	jmp    803012 <insert_sorted_with_merge_freeList+0x506>
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	a3 48 51 80 00       	mov    %eax,0x805148
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803024:	a1 54 51 80 00       	mov    0x805154,%eax
  803029:	40                   	inc    %eax
  80302a:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80302f:	e9 e5 02 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 50 08             	mov    0x8(%eax),%edx
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 40 08             	mov    0x8(%eax),%eax
  803040:	39 c2                	cmp    %eax,%edx
  803042:	0f 86 d7 00 00 00    	jbe    80311f <insert_sorted_with_merge_freeList+0x613>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 08             	mov    0x8(%eax),%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 48 08             	mov    0x8(%eax),%ecx
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	01 c8                	add    %ecx,%eax
  80305c:	39 c2                	cmp    %eax,%edx
  80305e:	0f 84 bb 00 00 00    	je     80311f <insert_sorted_with_merge_freeList+0x613>
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	8b 50 08             	mov    0x8(%eax),%edx
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	8b 48 08             	mov    0x8(%eax),%ecx
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	01 c8                	add    %ecx,%eax
  80307e:	39 c2                	cmp    %eax,%edx
  803080:	0f 85 99 00 00 00    	jne    80311f <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 40 04             	mov    0x4(%eax),%eax
  80308c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80308f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030bb:	75 17                	jne    8030d4 <insert_sorted_with_merge_freeList+0x5c8>
  8030bd:	83 ec 04             	sub    $0x4,%esp
  8030c0:	68 70 41 80 00       	push   $0x804170
  8030c5:	68 7d 01 00 00       	push   $0x17d
  8030ca:	68 93 41 80 00       	push   $0x804193
  8030cf:	e8 76 d4 ff ff       	call   80054a <_panic>
  8030d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	89 10                	mov    %edx,(%eax)
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 0d                	je     8030f5 <insert_sorted_with_merge_freeList+0x5e9>
  8030e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	eb 08                	jmp    8030fd <insert_sorted_with_merge_freeList+0x5f1>
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	a3 48 51 80 00       	mov    %eax,0x805148
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310f:	a1 54 51 80 00       	mov    0x805154,%eax
  803114:	40                   	inc    %eax
  803115:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80311a:	e9 fa 01 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	8b 50 08             	mov    0x8(%eax),%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 40 08             	mov    0x8(%eax),%eax
  80312b:	39 c2                	cmp    %eax,%edx
  80312d:	0f 86 d2 01 00 00    	jbe    803305 <insert_sorted_with_merge_freeList+0x7f9>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 50 08             	mov    0x8(%eax),%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 48 08             	mov    0x8(%eax),%ecx
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	8b 40 0c             	mov    0xc(%eax),%eax
  803145:	01 c8                	add    %ecx,%eax
  803147:	39 c2                	cmp    %eax,%edx
  803149:	0f 85 b6 01 00 00    	jne    803305 <insert_sorted_with_merge_freeList+0x7f9>
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 50 08             	mov    0x8(%eax),%edx
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	8b 48 08             	mov    0x8(%eax),%ecx
  80315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803161:	8b 40 04             	mov    0x4(%eax),%eax
  803164:	8b 40 0c             	mov    0xc(%eax),%eax
  803167:	01 c8                	add    %ecx,%eax
  803169:	39 c2                	cmp    %eax,%edx
  80316b:	0f 85 94 01 00 00    	jne    803305 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317a:	8b 52 04             	mov    0x4(%edx),%edx
  80317d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803180:	8b 55 08             	mov    0x8(%ebp),%edx
  803183:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803189:	8b 52 0c             	mov    0xc(%edx),%edx
  80318c:	01 da                	add    %ebx,%edx
  80318e:	01 ca                	add    %ecx,%edx
  803190:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8031a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ab:	75 17                	jne    8031c4 <insert_sorted_with_merge_freeList+0x6b8>
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	68 05 42 80 00       	push   $0x804205
  8031b5:	68 86 01 00 00       	push   $0x186
  8031ba:	68 93 41 80 00       	push   $0x804193
  8031bf:	e8 86 d3 ff ff       	call   80054a <_panic>
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 10                	je     8031dd <insert_sorted_with_merge_freeList+0x6d1>
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d5:	8b 52 04             	mov    0x4(%edx),%edx
  8031d8:	89 50 04             	mov    %edx,0x4(%eax)
  8031db:	eb 0b                	jmp    8031e8 <insert_sorted_with_merge_freeList+0x6dc>
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 40 04             	mov    0x4(%eax),%eax
  8031e3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	74 0f                	je     803201 <insert_sorted_with_merge_freeList+0x6f5>
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 40 04             	mov    0x4(%eax),%eax
  8031f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fb:	8b 12                	mov    (%edx),%edx
  8031fd:	89 10                	mov    %edx,(%eax)
  8031ff:	eb 0a                	jmp    80320b <insert_sorted_with_merge_freeList+0x6ff>
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	a3 38 51 80 00       	mov    %eax,0x805138
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321e:	a1 44 51 80 00       	mov    0x805144,%eax
  803223:	48                   	dec    %eax
  803224:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322d:	75 17                	jne    803246 <insert_sorted_with_merge_freeList+0x73a>
  80322f:	83 ec 04             	sub    $0x4,%esp
  803232:	68 70 41 80 00       	push   $0x804170
  803237:	68 87 01 00 00       	push   $0x187
  80323c:	68 93 41 80 00       	push   $0x804193
  803241:	e8 04 d3 ff ff       	call   80054a <_panic>
  803246:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324f:	89 10                	mov    %edx,(%eax)
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	74 0d                	je     803267 <insert_sorted_with_merge_freeList+0x75b>
  80325a:	a1 48 51 80 00       	mov    0x805148,%eax
  80325f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803262:	89 50 04             	mov    %edx,0x4(%eax)
  803265:	eb 08                	jmp    80326f <insert_sorted_with_merge_freeList+0x763>
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	a3 48 51 80 00       	mov    %eax,0x805148
  803277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803281:	a1 54 51 80 00       	mov    0x805154,%eax
  803286:	40                   	inc    %eax
  803287:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a4:	75 17                	jne    8032bd <insert_sorted_with_merge_freeList+0x7b1>
  8032a6:	83 ec 04             	sub    $0x4,%esp
  8032a9:	68 70 41 80 00       	push   $0x804170
  8032ae:	68 8a 01 00 00       	push   $0x18a
  8032b3:	68 93 41 80 00       	push   $0x804193
  8032b8:	e8 8d d2 ff ff       	call   80054a <_panic>
  8032bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	74 0d                	je     8032de <insert_sorted_with_merge_freeList+0x7d2>
  8032d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d9:	89 50 04             	mov    %edx,0x4(%eax)
  8032dc:	eb 08                	jmp    8032e6 <insert_sorted_with_merge_freeList+0x7da>
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032fd:	40                   	inc    %eax
  8032fe:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803303:	eb 14                	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80330d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803311:	0f 85 72 fb ff ff    	jne    802e89 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803317:	eb 00                	jmp    803319 <insert_sorted_with_merge_freeList+0x80d>
  803319:	90                   	nop
  80331a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    

0080331f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
  803322:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803325:	8b 55 08             	mov    0x8(%ebp),%edx
  803328:	89 d0                	mov    %edx,%eax
  80332a:	c1 e0 02             	shl    $0x2,%eax
  80332d:	01 d0                	add    %edx,%eax
  80332f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803336:	01 d0                	add    %edx,%eax
  803338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80333f:	01 d0                	add    %edx,%eax
  803341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803348:	01 d0                	add    %edx,%eax
  80334a:	c1 e0 04             	shl    $0x4,%eax
  80334d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803357:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80335a:	83 ec 0c             	sub    $0xc,%esp
  80335d:	50                   	push   %eax
  80335e:	e8 7b eb ff ff       	call   801ede <sys_get_virtual_time>
  803363:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803366:	eb 41                	jmp    8033a9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803368:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80336b:	83 ec 0c             	sub    $0xc,%esp
  80336e:	50                   	push   %eax
  80336f:	e8 6a eb ff ff       	call   801ede <sys_get_virtual_time>
  803374:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803377:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	29 c2                	sub    %eax,%edx
  80337f:	89 d0                	mov    %edx,%eax
  803381:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803384:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803387:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338a:	89 d1                	mov    %edx,%ecx
  80338c:	29 c1                	sub    %eax,%ecx
  80338e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803391:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803394:	39 c2                	cmp    %eax,%edx
  803396:	0f 97 c0             	seta   %al
  803399:	0f b6 c0             	movzbl %al,%eax
  80339c:	29 c1                	sub    %eax,%ecx
  80339e:	89 c8                	mov    %ecx,%eax
  8033a0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033af:	72 b7                	jb     803368 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033b1:	90                   	nop
  8033b2:	c9                   	leave  
  8033b3:	c3                   	ret    

008033b4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033b4:	55                   	push   %ebp
  8033b5:	89 e5                	mov    %esp,%ebp
  8033b7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033c1:	eb 03                	jmp    8033c6 <busy_wait+0x12>
  8033c3:	ff 45 fc             	incl   -0x4(%ebp)
  8033c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033cc:	72 f5                	jb     8033c3 <busy_wait+0xf>
	return i;
  8033ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033d1:	c9                   	leave  
  8033d2:	c3                   	ret    
  8033d3:	90                   	nop

008033d4 <__udivdi3>:
  8033d4:	55                   	push   %ebp
  8033d5:	57                   	push   %edi
  8033d6:	56                   	push   %esi
  8033d7:	53                   	push   %ebx
  8033d8:	83 ec 1c             	sub    $0x1c,%esp
  8033db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033eb:	89 ca                	mov    %ecx,%edx
  8033ed:	89 f8                	mov    %edi,%eax
  8033ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033f3:	85 f6                	test   %esi,%esi
  8033f5:	75 2d                	jne    803424 <__udivdi3+0x50>
  8033f7:	39 cf                	cmp    %ecx,%edi
  8033f9:	77 65                	ja     803460 <__udivdi3+0x8c>
  8033fb:	89 fd                	mov    %edi,%ebp
  8033fd:	85 ff                	test   %edi,%edi
  8033ff:	75 0b                	jne    80340c <__udivdi3+0x38>
  803401:	b8 01 00 00 00       	mov    $0x1,%eax
  803406:	31 d2                	xor    %edx,%edx
  803408:	f7 f7                	div    %edi
  80340a:	89 c5                	mov    %eax,%ebp
  80340c:	31 d2                	xor    %edx,%edx
  80340e:	89 c8                	mov    %ecx,%eax
  803410:	f7 f5                	div    %ebp
  803412:	89 c1                	mov    %eax,%ecx
  803414:	89 d8                	mov    %ebx,%eax
  803416:	f7 f5                	div    %ebp
  803418:	89 cf                	mov    %ecx,%edi
  80341a:	89 fa                	mov    %edi,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	39 ce                	cmp    %ecx,%esi
  803426:	77 28                	ja     803450 <__udivdi3+0x7c>
  803428:	0f bd fe             	bsr    %esi,%edi
  80342b:	83 f7 1f             	xor    $0x1f,%edi
  80342e:	75 40                	jne    803470 <__udivdi3+0x9c>
  803430:	39 ce                	cmp    %ecx,%esi
  803432:	72 0a                	jb     80343e <__udivdi3+0x6a>
  803434:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803438:	0f 87 9e 00 00 00    	ja     8034dc <__udivdi3+0x108>
  80343e:	b8 01 00 00 00       	mov    $0x1,%eax
  803443:	89 fa                	mov    %edi,%edx
  803445:	83 c4 1c             	add    $0x1c,%esp
  803448:	5b                   	pop    %ebx
  803449:	5e                   	pop    %esi
  80344a:	5f                   	pop    %edi
  80344b:	5d                   	pop    %ebp
  80344c:	c3                   	ret    
  80344d:	8d 76 00             	lea    0x0(%esi),%esi
  803450:	31 ff                	xor    %edi,%edi
  803452:	31 c0                	xor    %eax,%eax
  803454:	89 fa                	mov    %edi,%edx
  803456:	83 c4 1c             	add    $0x1c,%esp
  803459:	5b                   	pop    %ebx
  80345a:	5e                   	pop    %esi
  80345b:	5f                   	pop    %edi
  80345c:	5d                   	pop    %ebp
  80345d:	c3                   	ret    
  80345e:	66 90                	xchg   %ax,%ax
  803460:	89 d8                	mov    %ebx,%eax
  803462:	f7 f7                	div    %edi
  803464:	31 ff                	xor    %edi,%edi
  803466:	89 fa                	mov    %edi,%edx
  803468:	83 c4 1c             	add    $0x1c,%esp
  80346b:	5b                   	pop    %ebx
  80346c:	5e                   	pop    %esi
  80346d:	5f                   	pop    %edi
  80346e:	5d                   	pop    %ebp
  80346f:	c3                   	ret    
  803470:	bd 20 00 00 00       	mov    $0x20,%ebp
  803475:	89 eb                	mov    %ebp,%ebx
  803477:	29 fb                	sub    %edi,%ebx
  803479:	89 f9                	mov    %edi,%ecx
  80347b:	d3 e6                	shl    %cl,%esi
  80347d:	89 c5                	mov    %eax,%ebp
  80347f:	88 d9                	mov    %bl,%cl
  803481:	d3 ed                	shr    %cl,%ebp
  803483:	89 e9                	mov    %ebp,%ecx
  803485:	09 f1                	or     %esi,%ecx
  803487:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80348b:	89 f9                	mov    %edi,%ecx
  80348d:	d3 e0                	shl    %cl,%eax
  80348f:	89 c5                	mov    %eax,%ebp
  803491:	89 d6                	mov    %edx,%esi
  803493:	88 d9                	mov    %bl,%cl
  803495:	d3 ee                	shr    %cl,%esi
  803497:	89 f9                	mov    %edi,%ecx
  803499:	d3 e2                	shl    %cl,%edx
  80349b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349f:	88 d9                	mov    %bl,%cl
  8034a1:	d3 e8                	shr    %cl,%eax
  8034a3:	09 c2                	or     %eax,%edx
  8034a5:	89 d0                	mov    %edx,%eax
  8034a7:	89 f2                	mov    %esi,%edx
  8034a9:	f7 74 24 0c          	divl   0xc(%esp)
  8034ad:	89 d6                	mov    %edx,%esi
  8034af:	89 c3                	mov    %eax,%ebx
  8034b1:	f7 e5                	mul    %ebp
  8034b3:	39 d6                	cmp    %edx,%esi
  8034b5:	72 19                	jb     8034d0 <__udivdi3+0xfc>
  8034b7:	74 0b                	je     8034c4 <__udivdi3+0xf0>
  8034b9:	89 d8                	mov    %ebx,%eax
  8034bb:	31 ff                	xor    %edi,%edi
  8034bd:	e9 58 ff ff ff       	jmp    80341a <__udivdi3+0x46>
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034c8:	89 f9                	mov    %edi,%ecx
  8034ca:	d3 e2                	shl    %cl,%edx
  8034cc:	39 c2                	cmp    %eax,%edx
  8034ce:	73 e9                	jae    8034b9 <__udivdi3+0xe5>
  8034d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034d3:	31 ff                	xor    %edi,%edi
  8034d5:	e9 40 ff ff ff       	jmp    80341a <__udivdi3+0x46>
  8034da:	66 90                	xchg   %ax,%ax
  8034dc:	31 c0                	xor    %eax,%eax
  8034de:	e9 37 ff ff ff       	jmp    80341a <__udivdi3+0x46>
  8034e3:	90                   	nop

008034e4 <__umoddi3>:
  8034e4:	55                   	push   %ebp
  8034e5:	57                   	push   %edi
  8034e6:	56                   	push   %esi
  8034e7:	53                   	push   %ebx
  8034e8:	83 ec 1c             	sub    $0x1c,%esp
  8034eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803503:	89 f3                	mov    %esi,%ebx
  803505:	89 fa                	mov    %edi,%edx
  803507:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80350b:	89 34 24             	mov    %esi,(%esp)
  80350e:	85 c0                	test   %eax,%eax
  803510:	75 1a                	jne    80352c <__umoddi3+0x48>
  803512:	39 f7                	cmp    %esi,%edi
  803514:	0f 86 a2 00 00 00    	jbe    8035bc <__umoddi3+0xd8>
  80351a:	89 c8                	mov    %ecx,%eax
  80351c:	89 f2                	mov    %esi,%edx
  80351e:	f7 f7                	div    %edi
  803520:	89 d0                	mov    %edx,%eax
  803522:	31 d2                	xor    %edx,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	39 f0                	cmp    %esi,%eax
  80352e:	0f 87 ac 00 00 00    	ja     8035e0 <__umoddi3+0xfc>
  803534:	0f bd e8             	bsr    %eax,%ebp
  803537:	83 f5 1f             	xor    $0x1f,%ebp
  80353a:	0f 84 ac 00 00 00    	je     8035ec <__umoddi3+0x108>
  803540:	bf 20 00 00 00       	mov    $0x20,%edi
  803545:	29 ef                	sub    %ebp,%edi
  803547:	89 fe                	mov    %edi,%esi
  803549:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80354d:	89 e9                	mov    %ebp,%ecx
  80354f:	d3 e0                	shl    %cl,%eax
  803551:	89 d7                	mov    %edx,%edi
  803553:	89 f1                	mov    %esi,%ecx
  803555:	d3 ef                	shr    %cl,%edi
  803557:	09 c7                	or     %eax,%edi
  803559:	89 e9                	mov    %ebp,%ecx
  80355b:	d3 e2                	shl    %cl,%edx
  80355d:	89 14 24             	mov    %edx,(%esp)
  803560:	89 d8                	mov    %ebx,%eax
  803562:	d3 e0                	shl    %cl,%eax
  803564:	89 c2                	mov    %eax,%edx
  803566:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356a:	d3 e0                	shl    %cl,%eax
  80356c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803570:	8b 44 24 08          	mov    0x8(%esp),%eax
  803574:	89 f1                	mov    %esi,%ecx
  803576:	d3 e8                	shr    %cl,%eax
  803578:	09 d0                	or     %edx,%eax
  80357a:	d3 eb                	shr    %cl,%ebx
  80357c:	89 da                	mov    %ebx,%edx
  80357e:	f7 f7                	div    %edi
  803580:	89 d3                	mov    %edx,%ebx
  803582:	f7 24 24             	mull   (%esp)
  803585:	89 c6                	mov    %eax,%esi
  803587:	89 d1                	mov    %edx,%ecx
  803589:	39 d3                	cmp    %edx,%ebx
  80358b:	0f 82 87 00 00 00    	jb     803618 <__umoddi3+0x134>
  803591:	0f 84 91 00 00 00    	je     803628 <__umoddi3+0x144>
  803597:	8b 54 24 04          	mov    0x4(%esp),%edx
  80359b:	29 f2                	sub    %esi,%edx
  80359d:	19 cb                	sbb    %ecx,%ebx
  80359f:	89 d8                	mov    %ebx,%eax
  8035a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035a5:	d3 e0                	shl    %cl,%eax
  8035a7:	89 e9                	mov    %ebp,%ecx
  8035a9:	d3 ea                	shr    %cl,%edx
  8035ab:	09 d0                	or     %edx,%eax
  8035ad:	89 e9                	mov    %ebp,%ecx
  8035af:	d3 eb                	shr    %cl,%ebx
  8035b1:	89 da                	mov    %ebx,%edx
  8035b3:	83 c4 1c             	add    $0x1c,%esp
  8035b6:	5b                   	pop    %ebx
  8035b7:	5e                   	pop    %esi
  8035b8:	5f                   	pop    %edi
  8035b9:	5d                   	pop    %ebp
  8035ba:	c3                   	ret    
  8035bb:	90                   	nop
  8035bc:	89 fd                	mov    %edi,%ebp
  8035be:	85 ff                	test   %edi,%edi
  8035c0:	75 0b                	jne    8035cd <__umoddi3+0xe9>
  8035c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c7:	31 d2                	xor    %edx,%edx
  8035c9:	f7 f7                	div    %edi
  8035cb:	89 c5                	mov    %eax,%ebp
  8035cd:	89 f0                	mov    %esi,%eax
  8035cf:	31 d2                	xor    %edx,%edx
  8035d1:	f7 f5                	div    %ebp
  8035d3:	89 c8                	mov    %ecx,%eax
  8035d5:	f7 f5                	div    %ebp
  8035d7:	89 d0                	mov    %edx,%eax
  8035d9:	e9 44 ff ff ff       	jmp    803522 <__umoddi3+0x3e>
  8035de:	66 90                	xchg   %ax,%ax
  8035e0:	89 c8                	mov    %ecx,%eax
  8035e2:	89 f2                	mov    %esi,%edx
  8035e4:	83 c4 1c             	add    $0x1c,%esp
  8035e7:	5b                   	pop    %ebx
  8035e8:	5e                   	pop    %esi
  8035e9:	5f                   	pop    %edi
  8035ea:	5d                   	pop    %ebp
  8035eb:	c3                   	ret    
  8035ec:	3b 04 24             	cmp    (%esp),%eax
  8035ef:	72 06                	jb     8035f7 <__umoddi3+0x113>
  8035f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035f5:	77 0f                	ja     803606 <__umoddi3+0x122>
  8035f7:	89 f2                	mov    %esi,%edx
  8035f9:	29 f9                	sub    %edi,%ecx
  8035fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035ff:	89 14 24             	mov    %edx,(%esp)
  803602:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803606:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360a:	8b 14 24             	mov    (%esp),%edx
  80360d:	83 c4 1c             	add    $0x1c,%esp
  803610:	5b                   	pop    %ebx
  803611:	5e                   	pop    %esi
  803612:	5f                   	pop    %edi
  803613:	5d                   	pop    %ebp
  803614:	c3                   	ret    
  803615:	8d 76 00             	lea    0x0(%esi),%esi
  803618:	2b 04 24             	sub    (%esp),%eax
  80361b:	19 fa                	sbb    %edi,%edx
  80361d:	89 d1                	mov    %edx,%ecx
  80361f:	89 c6                	mov    %eax,%esi
  803621:	e9 71 ff ff ff       	jmp    803597 <__umoddi3+0xb3>
  803626:	66 90                	xchg   %ax,%ax
  803628:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80362c:	72 ea                	jb     803618 <__umoddi3+0x134>
  80362e:	89 d9                	mov    %ebx,%ecx
  803630:	e9 62 ff ff ff       	jmp    803597 <__umoddi3+0xb3>
