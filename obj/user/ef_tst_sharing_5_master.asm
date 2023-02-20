
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  80008d:	68 a0 36 80 00       	push   $0x8036a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 36 80 00       	push   $0x8036bc
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 dc 36 80 00       	push   $0x8036dc
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 10 37 80 00       	push   $0x803710
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 6c 37 80 00       	push   $0x80376c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 0b 1e 00 00       	call   801ede <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 a0 37 80 00       	push   $0x8037a0
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 e1 37 80 00       	push   $0x8037e1
  800104:	e8 80 1d 00 00       	call   801e89 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 e1 37 80 00       	push   $0x8037e1
  80012d:	e8 57 1d 00 00       	call   801e89 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 da 1a 00 00       	call   801c17 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 ef 37 80 00       	push   $0x8037ef
  80014f:	e8 c0 17 00 00       	call   801914 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 f4 37 80 00       	push   $0x8037f4
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 14 38 80 00       	push   $0x803814
  80017b:	6a 26                	push   $0x26
  80017d:	68 bc 36 80 00       	push   $0x8036bc
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 88 1a 00 00       	call   801c17 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 80 38 80 00       	push   $0x803880
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 bc 36 80 00       	push   $0x8036bc
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 24 1e 00 00       	call   801fd5 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 eb 1c 00 00       	call   801ea7 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 dd 1c 00 00       	call   801ea7 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 fe 38 80 00       	push   $0x8038fe
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 9a 31 00 00       	call   803384 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 5d 1e 00 00       	call   80204f <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 15 39 80 00       	push   $0x803915
  8001ff:	6a 33                	push   $0x33
  800201:	68 bc 36 80 00       	push   $0x8036bc
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 a1 18 00 00       	call   801ab7 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 24 39 80 00       	push   $0x803924
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 e9 19 00 00       	call   801c17 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 44 39 80 00       	push   $0x803944
  800248:	6a 38                	push   $0x38
  80024a:	68 bc 36 80 00       	push   $0x8036bc
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 74 39 80 00       	push   $0x803974
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 98 39 80 00       	push   $0x803998
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 c8 39 80 00       	push   $0x8039c8
  800292:	e8 f2 1b 00 00       	call   801e89 <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 d8 39 80 00       	push   $0x8039d8
  8002bb:	e8 c9 1b 00 00       	call   801e89 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 e8 39 80 00       	push   $0x8039e8
  8002d5:	e8 3a 16 00 00       	call   801914 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 ec 39 80 00       	push   $0x8039ec
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 ef 37 80 00       	push   $0x8037ef
  8002ff:	e8 10 16 00 00       	call   801914 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 f4 37 80 00       	push   $0x8037f4
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 b6 1c 00 00       	call   801fd5 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 7d 1b 00 00       	call   801ea7 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 6f 1b 00 00       	call   801ea7 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 3c 30 00 00       	call   803384 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 c7 18 00 00       	call   801c17 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 59 17 00 00       	call   801ab7 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 0c 3a 80 00       	push   $0x803a0c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 3b 17 00 00       	call   801ab7 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 22 3a 80 00       	push   $0x803a22
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 83 18 00 00       	call   801c17 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 38 3a 80 00       	push   $0x803a38
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 bc 36 80 00       	push   $0x8036bc
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 76 1c 00 00       	call   802035 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 dd 3a 80 00       	push   $0x803add
  8003cb:	e8 44 15 00 00       	call   801914 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 2c 1b 00 00       	call   801f10 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 ed 3a 80 00       	push   $0x803aed
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 b1 1a 00 00       	call   801ec3 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 a3 1a 00 00       	call   801ec3 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 95 1a 00 00       	call   801ec3 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 87 1a 00 00       	call   801ec3 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 c5 1a 00 00       	call   801f10 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 f3 3a 80 00       	push   $0x803af3
  800453:	50                   	push   %eax
  800454:	e8 7e 15 00 00       	call   8019d7 <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
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
  800479:	e8 79 1a 00 00       	call   801ef7 <sys_getenvindex>
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
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 1b 18 00 00       	call   801d04 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 1c 3b 80 00       	push   $0x803b1c
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 44 3b 80 00       	push   $0x803b44
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 6c 3b 80 00       	push   $0x803b6c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 c4 3b 80 00       	push   $0x803bc4
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 1c 3b 80 00       	push   $0x803b1c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 9b 17 00 00       	call   801d1e <sys_enable_interrupt>

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
  800596:	e8 28 19 00 00       	call   801ec3 <sys_destroy_env>
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
  8005a7:	e8 7d 19 00 00       	call   801f29 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 d8 3b 80 00       	push   $0x803bd8
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 dd 3b 80 00       	push   $0x803bdd
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 f9 3b 80 00       	push   $0x803bf9
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 fc 3b 80 00       	push   $0x803bfc
  80063e:	6a 26                	push   $0x26
  800640:	68 48 3c 80 00       	push   $0x803c48
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 54 3c 80 00       	push   $0x803c54
  800710:	6a 3a                	push   $0x3a
  800712:	68 48 3c 80 00       	push   $0x803c48
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 a8 3c 80 00       	push   $0x803ca8
  800780:	6a 44                	push   $0x44
  800782:	68 48 3c 80 00       	push   $0x803c48
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 7c 13 00 00       	call   801b56 <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 05 13 00 00       	call   801b56 <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 69 14 00 00       	call   801d04 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 63 14 00 00       	call   801d1e <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 33 2b 00 00       	call   803438 <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 f3 2b 00 00       	call   803548 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 14 3f 80 00       	add    $0x803f14,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 25 3f 80 00       	push   $0x803f25
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 2e 3f 80 00       	push   $0x803f2e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 90 40 80 00       	push   $0x804090
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801624:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80162b:	00 00 00 
  80162e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801635:	00 00 00 
  801638:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80163f:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801642:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801649:	00 00 00 
  80164c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801653:	00 00 00 
  801656:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80165d:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801660:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801667:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80166a:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801671:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801680:	2d 00 10 00 00       	sub    $0x1000,%eax
  801685:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80168a:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801694:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801699:	2d 00 10 00 00       	sub    $0x1000,%eax
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	6a 06                	push   $0x6
  8016a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a6:	50                   	push   %eax
  8016a7:	e8 ee 05 00 00       	call   801c9a <sys_allocate_chunk>
  8016ac:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016af:	a1 20 51 80 00       	mov    0x805120,%eax
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	50                   	push   %eax
  8016b8:	e8 63 0c 00 00       	call   802320 <initialize_MemBlocksList>
  8016bd:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8016c0:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8016c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8016c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016cb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8016d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e3:	89 c2                	mov    %eax,%edx
  8016e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e8:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8016eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ee:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8016f5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8016fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ff:	8b 50 08             	mov    0x8(%eax),%edx
  801702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801705:	01 d0                	add    %edx,%eax
  801707:	48                   	dec    %eax
  801708:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80170b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80170e:	ba 00 00 00 00       	mov    $0x0,%edx
  801713:	f7 75 e0             	divl   -0x20(%ebp)
  801716:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801719:	29 d0                	sub    %edx,%eax
  80171b:	89 c2                	mov    %eax,%edx
  80171d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801720:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801723:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801727:	75 14                	jne    80173d <initialize_dyn_block_system+0x11f>
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	68 b5 40 80 00       	push   $0x8040b5
  801731:	6a 34                	push   $0x34
  801733:	68 d3 40 80 00       	push   $0x8040d3
  801738:	e8 72 ee ff ff       	call   8005af <_panic>
  80173d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	85 c0                	test   %eax,%eax
  801744:	74 10                	je     801756 <initialize_dyn_block_system+0x138>
  801746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801749:	8b 00                	mov    (%eax),%eax
  80174b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80174e:	8b 52 04             	mov    0x4(%edx),%edx
  801751:	89 50 04             	mov    %edx,0x4(%eax)
  801754:	eb 0b                	jmp    801761 <initialize_dyn_block_system+0x143>
  801756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801759:	8b 40 04             	mov    0x4(%eax),%eax
  80175c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801764:	8b 40 04             	mov    0x4(%eax),%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 0f                	je     80177a <initialize_dyn_block_system+0x15c>
  80176b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80176e:	8b 40 04             	mov    0x4(%eax),%eax
  801771:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801774:	8b 12                	mov    (%edx),%edx
  801776:	89 10                	mov    %edx,(%eax)
  801778:	eb 0a                	jmp    801784 <initialize_dyn_block_system+0x166>
  80177a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177d:	8b 00                	mov    (%eax),%eax
  80177f:	a3 48 51 80 00       	mov    %eax,0x805148
  801784:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80178d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801790:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801797:	a1 54 51 80 00       	mov    0x805154,%eax
  80179c:	48                   	dec    %eax
  80179d:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8017a2:	83 ec 0c             	sub    $0xc,%esp
  8017a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8017a8:	e8 c4 13 00 00       	call   802b71 <insert_sorted_with_merge_freeList>
  8017ad:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8017b0:	90                   	nop
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b9:	e8 2f fe ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  8017be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017c2:	75 07                	jne    8017cb <malloc+0x18>
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	eb 71                	jmp    80183c <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8017cb:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8017d2:	76 07                	jbe    8017db <malloc+0x28>
	return NULL;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d9:	eb 61                	jmp    80183c <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017db:	e8 88 08 00 00       	call   802068 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	74 53                	je     801837 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8017e4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f1:	01 d0                	add    %edx,%eax
  8017f3:	48                   	dec    %eax
  8017f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	f7 75 f4             	divl   -0xc(%ebp)
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	29 d0                	sub    %edx,%eax
  801807:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80180a:	83 ec 0c             	sub    $0xc,%esp
  80180d:	ff 75 ec             	pushl  -0x14(%ebp)
  801810:	e8 d2 0d 00 00       	call   8025e7 <alloc_block_FF>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80181b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80181f:	74 16                	je     801837 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	ff 75 e8             	pushl  -0x18(%ebp)
  801827:	e8 0c 0c 00 00       	call   802438 <insert_sorted_allocList>
  80182c:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80182f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801832:	8b 40 08             	mov    0x8(%eax),%eax
  801835:	eb 05                	jmp    80183c <malloc+0x89>
    }

			}


	return NULL;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801852:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	ff 75 f0             	pushl  -0x10(%ebp)
  80185b:	68 40 50 80 00       	push   $0x805040
  801860:	e8 a0 0b 00 00       	call   802405 <find_block>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80186b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186e:	8b 50 0c             	mov    0xc(%eax),%edx
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	52                   	push   %edx
  801878:	50                   	push   %eax
  801879:	e8 e4 03 00 00       	call   801c62 <sys_free_user_mem>
  80187e:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801881:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801885:	75 17                	jne    80189e <free+0x60>
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	68 b5 40 80 00       	push   $0x8040b5
  80188f:	68 84 00 00 00       	push   $0x84
  801894:	68 d3 40 80 00       	push   $0x8040d3
  801899:	e8 11 ed ff ff       	call   8005af <_panic>
  80189e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a1:	8b 00                	mov    (%eax),%eax
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	74 10                	je     8018b7 <free+0x79>
  8018a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018aa:	8b 00                	mov    (%eax),%eax
  8018ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018af:	8b 52 04             	mov    0x4(%edx),%edx
  8018b2:	89 50 04             	mov    %edx,0x4(%eax)
  8018b5:	eb 0b                	jmp    8018c2 <free+0x84>
  8018b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ba:	8b 40 04             	mov    0x4(%eax),%eax
  8018bd:	a3 44 50 80 00       	mov    %eax,0x805044
  8018c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c5:	8b 40 04             	mov    0x4(%eax),%eax
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	74 0f                	je     8018db <free+0x9d>
  8018cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018cf:	8b 40 04             	mov    0x4(%eax),%eax
  8018d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d5:	8b 12                	mov    (%edx),%edx
  8018d7:	89 10                	mov    %edx,(%eax)
  8018d9:	eb 0a                	jmp    8018e5 <free+0xa7>
  8018db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018de:	8b 00                	mov    (%eax),%eax
  8018e0:	a3 40 50 80 00       	mov    %eax,0x805040
  8018e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018fd:	48                   	dec    %eax
  8018fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	ff 75 ec             	pushl  -0x14(%ebp)
  801909:	e8 63 12 00 00       	call   802b71 <insert_sorted_with_merge_freeList>
  80190e:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801911:	90                   	nop
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 38             	sub    $0x38,%esp
  80191a:	8b 45 10             	mov    0x10(%ebp),%eax
  80191d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801920:	e8 c8 fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801925:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801929:	75 0a                	jne    801935 <smalloc+0x21>
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	e9 a0 00 00 00       	jmp    8019d5 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801935:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80193c:	76 0a                	jbe    801948 <smalloc+0x34>
		return NULL;
  80193e:	b8 00 00 00 00       	mov    $0x0,%eax
  801943:	e9 8d 00 00 00       	jmp    8019d5 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801948:	e8 1b 07 00 00       	call   802068 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	74 7f                	je     8019d0 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801951:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195e:	01 d0                	add    %edx,%eax
  801960:	48                   	dec    %eax
  801961:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	f7 75 f4             	divl   -0xc(%ebp)
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	29 d0                	sub    %edx,%eax
  801974:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	ff 75 ec             	pushl  -0x14(%ebp)
  80197d:	e8 65 0c 00 00       	call   8025e7 <alloc_block_FF>
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80198c:	74 42                	je     8019d0 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	e8 9f 0a 00 00       	call   802438 <insert_sorted_allocList>
  801999:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80199c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80199f:	8b 40 08             	mov    0x8(%eax),%eax
  8019a2:	89 c2                	mov    %eax,%edx
  8019a4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	e8 38 04 00 00       	call   801ded <sys_createSharedObject>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8019bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019bf:	79 07                	jns    8019c8 <smalloc+0xb4>
	    		  return NULL;
  8019c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c6:	eb 0d                	jmp    8019d5 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8019c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019cb:	8b 40 08             	mov    0x8(%eax),%eax
  8019ce:	eb 05                	jmp    8019d5 <smalloc+0xc1>


				}


		return NULL;
  8019d0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019dd:	e8 0b fc ff ff       	call   8015ed <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8019e2:	e8 81 06 00 00       	call   802068 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	0f 84 9f 00 00 00    	je     801a8e <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	e8 1a 04 00 00       	call   801e17 <sys_getSizeOfSharedObject>
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a07:	79 0a                	jns    801a13 <sget+0x3c>
		return NULL;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	e9 80 00 00 00       	jmp    801a93 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801a13:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	01 d0                	add    %edx,%eax
  801a22:	48                   	dec    %eax
  801a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a29:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2e:	f7 75 f0             	divl   -0x10(%ebp)
  801a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a34:	29 d0                	sub    %edx,%eax
  801a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a3f:	e8 a3 0b 00 00       	call   8025e7 <alloc_block_FF>
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a4e:	74 3e                	je     801a8e <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a56:	e8 dd 09 00 00       	call   802438 <insert_sorted_allocList>
  801a5b:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a61:	8b 40 08             	mov    0x8(%eax),%eax
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	50                   	push   %eax
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	e8 c1 03 00 00       	call   801e34 <sys_getSharedObject>
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801a79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a7d:	79 07                	jns    801a86 <sget+0xaf>
	    		  return NULL;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	eb 0d                	jmp    801a93 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a89:	8b 40 08             	mov    0x8(%eax),%eax
  801a8c:	eb 05                	jmp    801a93 <sget+0xbc>
	      }
	}
	   return NULL;
  801a8e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a9b:	e8 4d fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	68 e0 40 80 00       	push   $0x8040e0
  801aa8:	68 12 01 00 00       	push   $0x112
  801aad:	68 d3 40 80 00       	push   $0x8040d3
  801ab2:	e8 f8 ea ff ff       	call   8005af <_panic>

00801ab7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801abd:	83 ec 04             	sub    $0x4,%esp
  801ac0:	68 08 41 80 00       	push   $0x804108
  801ac5:	68 26 01 00 00       	push   $0x126
  801aca:	68 d3 40 80 00       	push   $0x8040d3
  801acf:	e8 db ea ff ff       	call   8005af <_panic>

00801ad4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	68 2c 41 80 00       	push   $0x80412c
  801ae2:	68 31 01 00 00       	push   $0x131
  801ae7:	68 d3 40 80 00       	push   $0x8040d3
  801aec:	e8 be ea ff ff       	call   8005af <_panic>

00801af1 <shrink>:

}
void shrink(uint32 newSize)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	68 2c 41 80 00       	push   $0x80412c
  801aff:	68 36 01 00 00       	push   $0x136
  801b04:	68 d3 40 80 00       	push   $0x8040d3
  801b09:	e8 a1 ea ff ff       	call   8005af <_panic>

00801b0e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	68 2c 41 80 00       	push   $0x80412c
  801b1c:	68 3b 01 00 00       	push   $0x13b
  801b21:	68 d3 40 80 00       	push   $0x8040d3
  801b26:	e8 84 ea ff ff       	call   8005af <_panic>

00801b2b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	57                   	push   %edi
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
  801b31:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b40:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b43:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b46:	cd 30                	int    $0x30
  801b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	5b                   	pop    %ebx
  801b52:	5e                   	pop    %esi
  801b53:	5f                   	pop    %edi
  801b54:	5d                   	pop    %ebp
  801b55:	c3                   	ret    

00801b56 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 04             	sub    $0x4,%esp
  801b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b62:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	52                   	push   %edx
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	50                   	push   %eax
  801b72:	6a 00                	push   $0x0
  801b74:	e8 b2 ff ff ff       	call   801b2b <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	90                   	nop
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 01                	push   $0x1
  801b8e:	e8 98 ff ff ff       	call   801b2b <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 05                	push   $0x5
  801bab:	e8 7b ff ff ff       	call   801b2b <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	56                   	push   %esi
  801bb9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bba:	8b 75 18             	mov    0x18(%ebp),%esi
  801bbd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	56                   	push   %esi
  801bca:	53                   	push   %ebx
  801bcb:	51                   	push   %ecx
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 06                	push   $0x6
  801bd0:	e8 56 ff ff ff       	call   801b2b <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	6a 07                	push   $0x7
  801bf2:	e8 34 ff ff ff       	call   801b2b <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	6a 08                	push   $0x8
  801c0d:	e8 19 ff ff ff       	call   801b2b <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 09                	push   $0x9
  801c26:	e8 00 ff ff ff       	call   801b2b <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 0a                	push   $0xa
  801c3f:	e8 e7 fe ff ff       	call   801b2b <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 0b                	push   $0xb
  801c58:	e8 ce fe ff ff       	call   801b2b <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	ff 75 08             	pushl  0x8(%ebp)
  801c71:	6a 0f                	push   $0xf
  801c73:	e8 b3 fe ff ff       	call   801b2b <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 0c             	pushl  0xc(%ebp)
  801c8a:	ff 75 08             	pushl  0x8(%ebp)
  801c8d:	6a 10                	push   $0x10
  801c8f:	e8 97 fe ff ff       	call   801b2b <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
	return ;
  801c97:	90                   	nop
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	ff 75 10             	pushl  0x10(%ebp)
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 11                	push   $0x11
  801cac:	e8 7a fe ff ff       	call   801b2b <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 0c                	push   $0xc
  801cc6:	e8 60 fe ff ff       	call   801b2b <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	ff 75 08             	pushl  0x8(%ebp)
  801cde:	6a 0d                	push   $0xd
  801ce0:	e8 46 fe ff ff       	call   801b2b <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 0e                	push   $0xe
  801cf9:	e8 2d fe ff ff       	call   801b2b <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	90                   	nop
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 13                	push   $0x13
  801d13:	e8 13 fe ff ff       	call   801b2b <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	90                   	nop
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 14                	push   $0x14
  801d2d:	e8 f9 fd ff ff       	call   801b2b <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	90                   	nop
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	50                   	push   %eax
  801d51:	6a 15                	push   $0x15
  801d53:	e8 d3 fd ff ff       	call   801b2b <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	90                   	nop
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 16                	push   $0x16
  801d6d:	e8 b9 fd ff ff       	call   801b2b <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	90                   	nop
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	ff 75 0c             	pushl  0xc(%ebp)
  801d87:	50                   	push   %eax
  801d88:	6a 17                	push   $0x17
  801d8a:	e8 9c fd ff ff       	call   801b2b <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	52                   	push   %edx
  801da4:	50                   	push   %eax
  801da5:	6a 1a                	push   $0x1a
  801da7:	e8 7f fd ff ff       	call   801b2b <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	52                   	push   %edx
  801dc1:	50                   	push   %eax
  801dc2:	6a 18                	push   $0x18
  801dc4:	e8 62 fd ff ff       	call   801b2b <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	90                   	nop
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	6a 19                	push   $0x19
  801de2:	e8 44 fd ff ff       	call   801b2b <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	90                   	nop
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	8b 45 10             	mov    0x10(%ebp),%eax
  801df6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801df9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dfc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	51                   	push   %ecx
  801e06:	52                   	push   %edx
  801e07:	ff 75 0c             	pushl  0xc(%ebp)
  801e0a:	50                   	push   %eax
  801e0b:	6a 1b                	push   $0x1b
  801e0d:	e8 19 fd ff ff       	call   801b2b <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 1c                	push   $0x1c
  801e2a:	e8 fc fc ff ff       	call   801b2b <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	51                   	push   %ecx
  801e45:	52                   	push   %edx
  801e46:	50                   	push   %eax
  801e47:	6a 1d                	push   $0x1d
  801e49:	e8 dd fc ff ff       	call   801b2b <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	52                   	push   %edx
  801e63:	50                   	push   %eax
  801e64:	6a 1e                	push   $0x1e
  801e66:	e8 c0 fc ff ff       	call   801b2b <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 1f                	push   $0x1f
  801e7f:	e8 a7 fc ff ff       	call   801b2b <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	6a 00                	push   $0x0
  801e91:	ff 75 14             	pushl  0x14(%ebp)
  801e94:	ff 75 10             	pushl  0x10(%ebp)
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	50                   	push   %eax
  801e9b:	6a 20                	push   $0x20
  801e9d:	e8 89 fc ff ff       	call   801b2b <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	50                   	push   %eax
  801eb6:	6a 21                	push   $0x21
  801eb8:	e8 6e fc ff ff       	call   801b2b <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	90                   	nop
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	50                   	push   %eax
  801ed2:	6a 22                	push   $0x22
  801ed4:	e8 52 fc ff ff       	call   801b2b <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 02                	push   $0x2
  801eed:	e8 39 fc ff ff       	call   801b2b <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 03                	push   $0x3
  801f06:	e8 20 fc ff ff       	call   801b2b <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 04                	push   $0x4
  801f1f:	e8 07 fc ff ff       	call   801b2b <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_exit_env>:


void sys_exit_env(void)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 23                	push   $0x23
  801f38:	e8 ee fb ff ff       	call   801b2b <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	90                   	nop
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f4c:	8d 50 04             	lea    0x4(%eax),%edx
  801f4f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	52                   	push   %edx
  801f59:	50                   	push   %eax
  801f5a:	6a 24                	push   $0x24
  801f5c:	e8 ca fb ff ff       	call   801b2b <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
	return result;
  801f64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f6d:	89 01                	mov    %eax,(%ecx)
  801f6f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	c9                   	leave  
  801f76:	c2 04 00             	ret    $0x4

00801f79 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	ff 75 10             	pushl  0x10(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	ff 75 08             	pushl  0x8(%ebp)
  801f89:	6a 12                	push   $0x12
  801f8b:	e8 9b fb ff ff       	call   801b2b <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
	return ;
  801f93:	90                   	nop
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 25                	push   $0x25
  801fa5:	e8 81 fb ff ff       	call   801b2b <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fbb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	50                   	push   %eax
  801fc8:	6a 26                	push   $0x26
  801fca:	e8 5c fb ff ff       	call   801b2b <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd2:	90                   	nop
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <rsttst>:
void rsttst()
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 28                	push   $0x28
  801fe4:	e8 42 fb ff ff       	call   801b2b <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fec:	90                   	nop
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ffb:	8b 55 18             	mov    0x18(%ebp),%edx
  801ffe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	ff 75 10             	pushl  0x10(%ebp)
  802007:	ff 75 0c             	pushl  0xc(%ebp)
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	6a 27                	push   $0x27
  80200f:	e8 17 fb ff ff       	call   801b2b <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
	return ;
  802017:	90                   	nop
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <chktst>:
void chktst(uint32 n)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	ff 75 08             	pushl  0x8(%ebp)
  802028:	6a 29                	push   $0x29
  80202a:	e8 fc fa ff ff       	call   801b2b <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
	return ;
  802032:	90                   	nop
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <inctst>:

void inctst()
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 2a                	push   $0x2a
  802044:	e8 e2 fa ff ff       	call   801b2b <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
	return ;
  80204c:	90                   	nop
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <gettst>:
uint32 gettst()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 2b                	push   $0x2b
  80205e:	e8 c8 fa ff ff       	call   801b2b <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 2c                	push   $0x2c
  80207a:	e8 ac fa ff ff       	call   801b2b <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
  802082:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802085:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802089:	75 07                	jne    802092 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80208b:	b8 01 00 00 00       	mov    $0x1,%eax
  802090:	eb 05                	jmp    802097 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 2c                	push   $0x2c
  8020ab:	e8 7b fa ff ff       	call   801b2b <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
  8020b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020b6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020ba:	75 07                	jne    8020c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c1:	eb 05                	jmp    8020c8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 2c                	push   $0x2c
  8020dc:	e8 4a fa ff ff       	call   801b2b <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
  8020e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020e7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020eb:	75 07                	jne    8020f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f2:	eb 05                	jmp    8020f9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 2c                	push   $0x2c
  80210d:	e8 19 fa ff ff       	call   801b2b <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
  802115:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802118:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80211c:	75 07                	jne    802125 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80211e:	b8 01 00 00 00       	mov    $0x1,%eax
  802123:	eb 05                	jmp    80212a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	ff 75 08             	pushl  0x8(%ebp)
  80213a:	6a 2d                	push   $0x2d
  80213c:	e8 ea f9 ff ff       	call   801b2b <syscall>
  802141:	83 c4 18             	add    $0x18,%esp
	return ;
  802144:	90                   	nop
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80214b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80214e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802151:	8b 55 0c             	mov    0xc(%ebp),%edx
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	6a 00                	push   $0x0
  802159:	53                   	push   %ebx
  80215a:	51                   	push   %ecx
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 2e                	push   $0x2e
  80215f:	e8 c7 f9 ff ff       	call   801b2b <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80216f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	52                   	push   %edx
  80217c:	50                   	push   %eax
  80217d:	6a 2f                	push   $0x2f
  80217f:	e8 a7 f9 ff ff       	call   801b2b <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	68 3c 41 80 00       	push   $0x80413c
  802197:	e8 c7 e6 ff ff       	call   800863 <cprintf>
  80219c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80219f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	68 68 41 80 00       	push   $0x804168
  8021ae:	e8 b0 e6 ff ff       	call   800863 <cprintf>
  8021b3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021b6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8021bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c2:	eb 56                	jmp    80221a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c8:	74 1c                	je     8021e6 <print_mem_block_lists+0x5d>
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 50 08             	mov    0x8(%eax),%edx
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 48 08             	mov    0x8(%eax),%ecx
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dc:	01 c8                	add    %ecx,%eax
  8021de:	39 c2                	cmp    %eax,%edx
  8021e0:	73 04                	jae    8021e6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021e2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 50 08             	mov    0x8(%eax),%edx
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f2:	01 c2                	add    %eax,%edx
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 40 08             	mov    0x8(%eax),%eax
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	52                   	push   %edx
  8021fe:	50                   	push   %eax
  8021ff:	68 7d 41 80 00       	push   $0x80417d
  802204:	e8 5a e6 ff ff       	call   800863 <cprintf>
  802209:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802212:	a1 40 51 80 00       	mov    0x805140,%eax
  802217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221e:	74 07                	je     802227 <print_mem_block_lists+0x9e>
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	eb 05                	jmp    80222c <print_mem_block_lists+0xa3>
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	a3 40 51 80 00       	mov    %eax,0x805140
  802231:	a1 40 51 80 00       	mov    0x805140,%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	75 8a                	jne    8021c4 <print_mem_block_lists+0x3b>
  80223a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223e:	75 84                	jne    8021c4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802240:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802244:	75 10                	jne    802256 <print_mem_block_lists+0xcd>
  802246:	83 ec 0c             	sub    $0xc,%esp
  802249:	68 8c 41 80 00       	push   $0x80418c
  80224e:	e8 10 e6 ff ff       	call   800863 <cprintf>
  802253:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802256:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80225d:	83 ec 0c             	sub    $0xc,%esp
  802260:	68 b0 41 80 00       	push   $0x8041b0
  802265:	e8 f9 e5 ff ff       	call   800863 <cprintf>
  80226a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80226d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802271:	a1 40 50 80 00       	mov    0x805040,%eax
  802276:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802279:	eb 56                	jmp    8022d1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80227b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227f:	74 1c                	je     80229d <print_mem_block_lists+0x114>
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 50 08             	mov    0x8(%eax),%edx
  802287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228a:	8b 48 08             	mov    0x8(%eax),%ecx
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	8b 40 0c             	mov    0xc(%eax),%eax
  802293:	01 c8                	add    %ecx,%eax
  802295:	39 c2                	cmp    %eax,%edx
  802297:	73 04                	jae    80229d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802299:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 50 08             	mov    0x8(%eax),%edx
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a9:	01 c2                	add    %eax,%edx
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 40 08             	mov    0x8(%eax),%eax
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	52                   	push   %edx
  8022b5:	50                   	push   %eax
  8022b6:	68 7d 41 80 00       	push   $0x80417d
  8022bb:	e8 a3 e5 ff ff       	call   800863 <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022c9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d5:	74 07                	je     8022de <print_mem_block_lists+0x155>
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 00                	mov    (%eax),%eax
  8022dc:	eb 05                	jmp    8022e3 <print_mem_block_lists+0x15a>
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e3:	a3 48 50 80 00       	mov    %eax,0x805048
  8022e8:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	75 8a                	jne    80227b <print_mem_block_lists+0xf2>
  8022f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f5:	75 84                	jne    80227b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022f7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022fb:	75 10                	jne    80230d <print_mem_block_lists+0x184>
  8022fd:	83 ec 0c             	sub    $0xc,%esp
  802300:	68 c8 41 80 00       	push   $0x8041c8
  802305:	e8 59 e5 ff ff       	call   800863 <cprintf>
  80230a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80230d:	83 ec 0c             	sub    $0xc,%esp
  802310:	68 3c 41 80 00       	push   $0x80413c
  802315:	e8 49 e5 ff ff       	call   800863 <cprintf>
  80231a:	83 c4 10             	add    $0x10,%esp

}
  80231d:	90                   	nop
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802326:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80232d:	00 00 00 
  802330:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802337:	00 00 00 
  80233a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802341:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802344:	a1 50 50 80 00       	mov    0x805050,%eax
  802349:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80234c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802353:	e9 9e 00 00 00       	jmp    8023f6 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802358:	a1 50 50 80 00       	mov    0x805050,%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	c1 e2 04             	shl    $0x4,%edx
  802363:	01 d0                	add    %edx,%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	75 14                	jne    80237d <initialize_MemBlocksList+0x5d>
  802369:	83 ec 04             	sub    $0x4,%esp
  80236c:	68 f0 41 80 00       	push   $0x8041f0
  802371:	6a 48                	push   $0x48
  802373:	68 13 42 80 00       	push   $0x804213
  802378:	e8 32 e2 ff ff       	call   8005af <_panic>
  80237d:	a1 50 50 80 00       	mov    0x805050,%eax
  802382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802385:	c1 e2 04             	shl    $0x4,%edx
  802388:	01 d0                	add    %edx,%eax
  80238a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	8b 00                	mov    (%eax),%eax
  802394:	85 c0                	test   %eax,%eax
  802396:	74 18                	je     8023b0 <initialize_MemBlocksList+0x90>
  802398:	a1 48 51 80 00       	mov    0x805148,%eax
  80239d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023a6:	c1 e1 04             	shl    $0x4,%ecx
  8023a9:	01 ca                	add    %ecx,%edx
  8023ab:	89 50 04             	mov    %edx,0x4(%eax)
  8023ae:	eb 12                	jmp    8023c2 <initialize_MemBlocksList+0xa2>
  8023b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b8:	c1 e2 04             	shl    $0x4,%edx
  8023bb:	01 d0                	add    %edx,%eax
  8023bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ca:	c1 e2 04             	shl    $0x4,%edx
  8023cd:	01 d0                	add    %edx,%eax
  8023cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8023d4:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dc:	c1 e2 04             	shl    $0x4,%edx
  8023df:	01 d0                	add    %edx,%eax
  8023e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8023ed:	40                   	inc    %eax
  8023ee:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8023f3:	ff 45 f4             	incl   -0xc(%ebp)
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fc:	0f 82 56 ff ff ff    	jb     802358 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802402:	90                   	nop
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802413:	eb 18                	jmp    80242d <find_block+0x28>
		{
			if(tmp->sva==va)
  802415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802418:	8b 40 08             	mov    0x8(%eax),%eax
  80241b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80241e:	75 05                	jne    802425 <find_block+0x20>
			{
				return tmp;
  802420:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802423:	eb 11                	jmp    802436 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802425:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802428:	8b 00                	mov    (%eax),%eax
  80242a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80242d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802431:	75 e2                	jne    802415 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802433:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80243e:	a1 40 50 80 00       	mov    0x805040,%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	0f 85 83 00 00 00    	jne    8024ce <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80244b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802452:	00 00 00 
  802455:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80245c:	00 00 00 
  80245f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802466:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246d:	75 14                	jne    802483 <insert_sorted_allocList+0x4b>
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	68 f0 41 80 00       	push   $0x8041f0
  802477:	6a 7f                	push   $0x7f
  802479:	68 13 42 80 00       	push   $0x804213
  80247e:	e8 2c e1 ff ff       	call   8005af <_panic>
  802483:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	89 10                	mov    %edx,(%eax)
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	74 0d                	je     8024a4 <insert_sorted_allocList+0x6c>
  802497:	a1 40 50 80 00       	mov    0x805040,%eax
  80249c:	8b 55 08             	mov    0x8(%ebp),%edx
  80249f:	89 50 04             	mov    %edx,0x4(%eax)
  8024a2:	eb 08                	jmp    8024ac <insert_sorted_allocList+0x74>
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	a3 40 50 80 00       	mov    %eax,0x805040
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024be:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c3:	40                   	inc    %eax
  8024c4:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024c9:	e9 16 01 00 00       	jmp    8025e4 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	8b 50 08             	mov    0x8(%eax),%edx
  8024d4:	a1 44 50 80 00       	mov    0x805044,%eax
  8024d9:	8b 40 08             	mov    0x8(%eax),%eax
  8024dc:	39 c2                	cmp    %eax,%edx
  8024de:	76 68                	jbe    802548 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8024e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e4:	75 17                	jne    8024fd <insert_sorted_allocList+0xc5>
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	68 2c 42 80 00       	push   $0x80422c
  8024ee:	68 85 00 00 00       	push   $0x85
  8024f3:	68 13 42 80 00       	push   $0x804213
  8024f8:	e8 b2 e0 ff ff       	call   8005af <_panic>
  8024fd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	89 50 04             	mov    %edx,0x4(%eax)
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0c                	je     80251f <insert_sorted_allocList+0xe7>
  802513:	a1 44 50 80 00       	mov    0x805044,%eax
  802518:	8b 55 08             	mov    0x8(%ebp),%edx
  80251b:	89 10                	mov    %edx,(%eax)
  80251d:	eb 08                	jmp    802527 <insert_sorted_allocList+0xef>
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	a3 40 50 80 00       	mov    %eax,0x805040
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	a3 44 50 80 00       	mov    %eax,0x805044
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802538:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80253d:	40                   	inc    %eax
  80253e:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802543:	e9 9c 00 00 00       	jmp    8025e4 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802548:	a1 40 50 80 00       	mov    0x805040,%eax
  80254d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802550:	e9 85 00 00 00       	jmp    8025da <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	8b 50 08             	mov    0x8(%eax),%edx
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 08             	mov    0x8(%eax),%eax
  802561:	39 c2                	cmp    %eax,%edx
  802563:	73 6d                	jae    8025d2 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802565:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802569:	74 06                	je     802571 <insert_sorted_allocList+0x139>
  80256b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80256f:	75 17                	jne    802588 <insert_sorted_allocList+0x150>
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 50 42 80 00       	push   $0x804250
  802579:	68 90 00 00 00       	push   $0x90
  80257e:	68 13 42 80 00       	push   $0x804213
  802583:	e8 27 e0 ff ff       	call   8005af <_panic>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 50 04             	mov    0x4(%eax),%edx
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	89 50 04             	mov    %edx,0x4(%eax)
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259a:	89 10                	mov    %edx,(%eax)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 0d                	je     8025b3 <insert_sorted_allocList+0x17b>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8025af:	89 10                	mov    %edx,(%eax)
  8025b1:	eb 08                	jmp    8025bb <insert_sorted_allocList+0x183>
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	a3 40 50 80 00       	mov    %eax,0x805040
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c1:	89 50 04             	mov    %edx,0x4(%eax)
  8025c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c9:	40                   	inc    %eax
  8025ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025cf:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8025d0:	eb 12                	jmp    8025e4 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8025da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025de:	0f 85 71 ff ff ff    	jne    802555 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8025e4:	90                   	nop
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8025ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8025f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8025f5:	e9 76 01 00 00       	jmp    802770 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802600:	3b 45 08             	cmp    0x8(%ebp),%eax
  802603:	0f 85 8a 00 00 00    	jne    802693 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260d:	75 17                	jne    802626 <alloc_block_FF+0x3f>
  80260f:	83 ec 04             	sub    $0x4,%esp
  802612:	68 85 42 80 00       	push   $0x804285
  802617:	68 a8 00 00 00       	push   $0xa8
  80261c:	68 13 42 80 00       	push   $0x804213
  802621:	e8 89 df ff ff       	call   8005af <_panic>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 10                	je     80263f <alloc_block_FF+0x58>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802637:	8b 52 04             	mov    0x4(%edx),%edx
  80263a:	89 50 04             	mov    %edx,0x4(%eax)
  80263d:	eb 0b                	jmp    80264a <alloc_block_FF+0x63>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 04             	mov    0x4(%eax),%eax
  802645:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	74 0f                	je     802663 <alloc_block_FF+0x7c>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265d:	8b 12                	mov    (%edx),%edx
  80265f:	89 10                	mov    %edx,(%eax)
  802661:	eb 0a                	jmp    80266d <alloc_block_FF+0x86>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	a3 38 51 80 00       	mov    %eax,0x805138
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802680:	a1 44 51 80 00       	mov    0x805144,%eax
  802685:	48                   	dec    %eax
  802686:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	e9 ea 00 00 00       	jmp    80277d <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 0c             	mov    0xc(%eax),%eax
  802699:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269c:	0f 86 c6 00 00 00    	jbe    802768 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8026a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8026aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b0:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 50 08             	mov    0x8(%eax),%edx
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c8:	89 c2                	mov    %eax,%edx
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 50 08             	mov    0x8(%eax),%edx
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	01 c2                	add    %eax,%edx
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8026e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e5:	75 17                	jne    8026fe <alloc_block_FF+0x117>
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	68 85 42 80 00       	push   $0x804285
  8026ef:	68 b6 00 00 00       	push   $0xb6
  8026f4:	68 13 42 80 00       	push   $0x804213
  8026f9:	e8 b1 de ff ff       	call   8005af <_panic>
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	74 10                	je     802717 <alloc_block_FF+0x130>
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270f:	8b 52 04             	mov    0x4(%edx),%edx
  802712:	89 50 04             	mov    %edx,0x4(%eax)
  802715:	eb 0b                	jmp    802722 <alloc_block_FF+0x13b>
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	8b 40 04             	mov    0x4(%eax),%eax
  80271d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 0f                	je     80273b <alloc_block_FF+0x154>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802735:	8b 12                	mov    (%edx),%edx
  802737:	89 10                	mov    %edx,(%eax)
  802739:	eb 0a                	jmp    802745 <alloc_block_FF+0x15e>
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	a3 48 51 80 00       	mov    %eax,0x805148
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802758:	a1 54 51 80 00       	mov    0x805154,%eax
  80275d:	48                   	dec    %eax
  80275e:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	eb 15                	jmp    80277d <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802770:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802774:	0f 85 80 fe ff ff    	jne    8025fa <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
  802782:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802785:	a1 38 51 80 00       	mov    0x805138,%eax
  80278a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80278d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802794:	e9 c0 00 00 00       	jmp    802859 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a2:	0f 85 8a 00 00 00    	jne    802832 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8027a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ac:	75 17                	jne    8027c5 <alloc_block_BF+0x46>
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	68 85 42 80 00       	push   $0x804285
  8027b6:	68 cf 00 00 00       	push   $0xcf
  8027bb:	68 13 42 80 00       	push   $0x804213
  8027c0:	e8 ea dd ff ff       	call   8005af <_panic>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	74 10                	je     8027de <alloc_block_BF+0x5f>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d6:	8b 52 04             	mov    0x4(%edx),%edx
  8027d9:	89 50 04             	mov    %edx,0x4(%eax)
  8027dc:	eb 0b                	jmp    8027e9 <alloc_block_BF+0x6a>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 04             	mov    0x4(%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 0f                	je     802802 <alloc_block_BF+0x83>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fc:	8b 12                	mov    (%edx),%edx
  8027fe:	89 10                	mov    %edx,(%eax)
  802800:	eb 0a                	jmp    80280c <alloc_block_BF+0x8d>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	a3 38 51 80 00       	mov    %eax,0x805138
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281f:	a1 44 51 80 00       	mov    0x805144,%eax
  802824:	48                   	dec    %eax
  802825:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	e9 2a 01 00 00       	jmp    80295c <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80283b:	73 14                	jae    802851 <alloc_block_BF+0xd2>
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 0c             	mov    0xc(%eax),%eax
  802843:	3b 45 08             	cmp    0x8(%ebp),%eax
  802846:	76 09                	jbe    802851 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 0c             	mov    0xc(%eax),%eax
  80284e:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285d:	0f 85 36 ff ff ff    	jne    802799 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802863:	a1 38 51 80 00       	mov    0x805138,%eax
  802868:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80286b:	e9 dd 00 00 00       	jmp    80294d <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 40 0c             	mov    0xc(%eax),%eax
  802876:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802879:	0f 85 c6 00 00 00    	jne    802945 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80287f:	a1 48 51 80 00       	mov    0x805148,%eax
  802884:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 50 08             	mov    0x8(%eax),%edx
  80288d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802890:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802896:	8b 55 08             	mov    0x8(%ebp),%edx
  802899:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 50 08             	mov    0x8(%eax),%edx
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	01 c2                	add    %eax,%edx
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b6:	89 c2                	mov    %eax,%edx
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8028be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c2:	75 17                	jne    8028db <alloc_block_BF+0x15c>
  8028c4:	83 ec 04             	sub    $0x4,%esp
  8028c7:	68 85 42 80 00       	push   $0x804285
  8028cc:	68 eb 00 00 00       	push   $0xeb
  8028d1:	68 13 42 80 00       	push   $0x804213
  8028d6:	e8 d4 dc ff ff       	call   8005af <_panic>
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 10                	je     8028f4 <alloc_block_BF+0x175>
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ec:	8b 52 04             	mov    0x4(%edx),%edx
  8028ef:	89 50 04             	mov    %edx,0x4(%eax)
  8028f2:	eb 0b                	jmp    8028ff <alloc_block_BF+0x180>
  8028f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 0f                	je     802918 <alloc_block_BF+0x199>
  802909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802912:	8b 12                	mov    (%edx),%edx
  802914:	89 10                	mov    %edx,(%eax)
  802916:	eb 0a                	jmp    802922 <alloc_block_BF+0x1a3>
  802918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	a3 48 51 80 00       	mov    %eax,0x805148
  802922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802925:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802935:	a1 54 51 80 00       	mov    0x805154,%eax
  80293a:	48                   	dec    %eax
  80293b:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802943:	eb 17                	jmp    80295c <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80294d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802951:	0f 85 19 ff ff ff    	jne    802870 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    

0080295e <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80295e:	55                   	push   %ebp
  80295f:	89 e5                	mov    %esp,%ebp
  802961:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802964:	a1 40 50 80 00       	mov    0x805040,%eax
  802969:	85 c0                	test   %eax,%eax
  80296b:	75 19                	jne    802986 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80296d:	83 ec 0c             	sub    $0xc,%esp
  802970:	ff 75 08             	pushl  0x8(%ebp)
  802973:	e8 6f fc ff ff       	call   8025e7 <alloc_block_FF>
  802978:	83 c4 10             	add    $0x10,%esp
  80297b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	e9 e9 01 00 00       	jmp    802b6f <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802986:	a1 44 50 80 00       	mov    0x805044,%eax
  80298b:	8b 40 08             	mov    0x8(%eax),%eax
  80298e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802991:	a1 44 50 80 00       	mov    0x805044,%eax
  802996:	8b 50 0c             	mov    0xc(%eax),%edx
  802999:	a1 44 50 80 00       	mov    0x805044,%eax
  80299e:	8b 40 08             	mov    0x8(%eax),%eax
  8029a1:	01 d0                	add    %edx,%eax
  8029a3:	83 ec 08             	sub    $0x8,%esp
  8029a6:	50                   	push   %eax
  8029a7:	68 38 51 80 00       	push   $0x805138
  8029ac:	e8 54 fa ff ff       	call   802405 <find_block>
  8029b1:	83 c4 10             	add    $0x10,%esp
  8029b4:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c0:	0f 85 9b 00 00 00    	jne    802a61 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 50 0c             	mov    0xc(%eax),%edx
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 40 08             	mov    0x8(%eax),%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8029d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029db:	75 17                	jne    8029f4 <alloc_block_NF+0x96>
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	68 85 42 80 00       	push   $0x804285
  8029e5:	68 1a 01 00 00       	push   $0x11a
  8029ea:	68 13 42 80 00       	push   $0x804213
  8029ef:	e8 bb db ff ff       	call   8005af <_panic>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	74 10                	je     802a0d <alloc_block_NF+0xaf>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a05:	8b 52 04             	mov    0x4(%edx),%edx
  802a08:	89 50 04             	mov    %edx,0x4(%eax)
  802a0b:	eb 0b                	jmp    802a18 <alloc_block_NF+0xba>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 40 04             	mov    0x4(%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 0f                	je     802a31 <alloc_block_NF+0xd3>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2b:	8b 12                	mov    (%edx),%edx
  802a2d:	89 10                	mov    %edx,(%eax)
  802a2f:	eb 0a                	jmp    802a3b <alloc_block_NF+0xdd>
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	a3 38 51 80 00       	mov    %eax,0x805138
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802a53:	48                   	dec    %eax
  802a54:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	e9 0e 01 00 00       	jmp    802b6f <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 0c             	mov    0xc(%eax),%eax
  802a67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6a:	0f 86 cf 00 00 00    	jbe    802b3f <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a70:	a1 48 51 80 00       	mov    0x805148,%eax
  802a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7e:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 50 08             	mov    0x8(%eax),%edx
  802a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8a:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 50 08             	mov    0x8(%eax),%edx
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	01 c2                	add    %eax,%edx
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa4:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa7:	89 c2                	mov    %eax,%edx
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 08             	mov    0x8(%eax),%eax
  802ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ab8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abc:	75 17                	jne    802ad5 <alloc_block_NF+0x177>
  802abe:	83 ec 04             	sub    $0x4,%esp
  802ac1:	68 85 42 80 00       	push   $0x804285
  802ac6:	68 28 01 00 00       	push   $0x128
  802acb:	68 13 42 80 00       	push   $0x804213
  802ad0:	e8 da da ff ff       	call   8005af <_panic>
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 10                	je     802aee <alloc_block_NF+0x190>
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae6:	8b 52 04             	mov    0x4(%edx),%edx
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	eb 0b                	jmp    802af9 <alloc_block_NF+0x19b>
  802aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af1:	8b 40 04             	mov    0x4(%eax),%eax
  802af4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	74 0f                	je     802b12 <alloc_block_NF+0x1b4>
  802b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0c:	8b 12                	mov    (%edx),%edx
  802b0e:	89 10                	mov    %edx,(%eax)
  802b10:	eb 0a                	jmp    802b1c <alloc_block_NF+0x1be>
  802b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	a3 48 51 80 00       	mov    %eax,0x805148
  802b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b34:	48                   	dec    %eax
  802b35:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3d:	eb 30                	jmp    802b6f <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802b3f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b47:	75 0a                	jne    802b53 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802b49:	a1 38 51 80 00       	mov    0x805138,%eax
  802b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b51:	eb 08                	jmp    802b5b <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 08             	mov    0x8(%eax),%eax
  802b61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b64:	0f 85 4d fe ff ff    	jne    8029b7 <alloc_block_NF+0x59>

			return NULL;
  802b6a:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802b6f:	c9                   	leave  
  802b70:	c3                   	ret    

00802b71 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b71:	55                   	push   %ebp
  802b72:	89 e5                	mov    %esp,%ebp
  802b74:	53                   	push   %ebx
  802b75:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802b78:	a1 38 51 80 00       	mov    0x805138,%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	0f 85 86 00 00 00    	jne    802c0b <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802b85:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802b8c:	00 00 00 
  802b8f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802b96:	00 00 00 
  802b99:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802ba0:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba7:	75 17                	jne    802bc0 <insert_sorted_with_merge_freeList+0x4f>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 f0 41 80 00       	push   $0x8041f0
  802bb1:	68 48 01 00 00       	push   $0x148
  802bb6:	68 13 42 80 00       	push   $0x804213
  802bbb:	e8 ef d9 ff ff       	call   8005af <_panic>
  802bc0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	89 10                	mov    %edx,(%eax)
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 0d                	je     802be1 <insert_sorted_with_merge_freeList+0x70>
  802bd4:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	eb 08                	jmp    802be9 <insert_sorted_with_merge_freeList+0x78>
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfb:	a1 44 51 80 00       	mov    0x805144,%eax
  802c00:	40                   	inc    %eax
  802c01:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802c06:	e9 73 07 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c16:	8b 40 08             	mov    0x8(%eax),%eax
  802c19:	39 c2                	cmp    %eax,%edx
  802c1b:	0f 86 84 00 00 00    	jbe    802ca5 <insert_sorted_with_merge_freeList+0x134>
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c2c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c2f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c34:	8b 40 08             	mov    0x8(%eax),%eax
  802c37:	01 c8                	add    %ecx,%eax
  802c39:	39 c2                	cmp    %eax,%edx
  802c3b:	74 68                	je     802ca5 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802c3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c41:	75 17                	jne    802c5a <insert_sorted_with_merge_freeList+0xe9>
  802c43:	83 ec 04             	sub    $0x4,%esp
  802c46:	68 2c 42 80 00       	push   $0x80422c
  802c4b:	68 4c 01 00 00       	push   $0x14c
  802c50:	68 13 42 80 00       	push   $0x804213
  802c55:	e8 55 d9 ff ff       	call   8005af <_panic>
  802c5a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 0c                	je     802c7c <insert_sorted_with_merge_freeList+0x10b>
  802c70:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c75:	8b 55 08             	mov    0x8(%ebp),%edx
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	eb 08                	jmp    802c84 <insert_sorted_with_merge_freeList+0x113>
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	a3 38 51 80 00       	mov    %eax,0x805138
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c95:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9a:	40                   	inc    %eax
  802c9b:	a3 44 51 80 00       	mov    %eax,0x805144
  802ca0:	e9 d9 06 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 50 08             	mov    0x8(%eax),%edx
  802cab:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cb0:	8b 40 08             	mov    0x8(%eax),%eax
  802cb3:	39 c2                	cmp    %eax,%edx
  802cb5:	0f 86 b5 00 00 00    	jbe    802d70 <insert_sorted_with_merge_freeList+0x1ff>
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 50 08             	mov    0x8(%eax),%edx
  802cc1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cc6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802cc9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cce:	8b 40 08             	mov    0x8(%eax),%eax
  802cd1:	01 c8                	add    %ecx,%eax
  802cd3:	39 c2                	cmp    %eax,%edx
  802cd5:	0f 85 95 00 00 00    	jne    802d70 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802cdb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ce0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ce6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cec:	8b 52 0c             	mov    0xc(%edx),%edx
  802cef:	01 ca                	add    %ecx,%edx
  802cf1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0c:	75 17                	jne    802d25 <insert_sorted_with_merge_freeList+0x1b4>
  802d0e:	83 ec 04             	sub    $0x4,%esp
  802d11:	68 f0 41 80 00       	push   $0x8041f0
  802d16:	68 54 01 00 00       	push   $0x154
  802d1b:	68 13 42 80 00       	push   $0x804213
  802d20:	e8 8a d8 ff ff       	call   8005af <_panic>
  802d25:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	89 10                	mov    %edx,(%eax)
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 0d                	je     802d46 <insert_sorted_with_merge_freeList+0x1d5>
  802d39:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d41:	89 50 04             	mov    %edx,0x4(%eax)
  802d44:	eb 08                	jmp    802d4e <insert_sorted_with_merge_freeList+0x1dd>
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	a3 48 51 80 00       	mov    %eax,0x805148
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d60:	a1 54 51 80 00       	mov    0x805154,%eax
  802d65:	40                   	inc    %eax
  802d66:	a3 54 51 80 00       	mov    %eax,0x805154
  802d6b:	e9 0e 06 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 50 08             	mov    0x8(%eax),%edx
  802d76:	a1 38 51 80 00       	mov    0x805138,%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	0f 83 c1 00 00 00    	jae    802e47 <insert_sorted_with_merge_freeList+0x2d6>
  802d86:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8b:	8b 50 08             	mov    0x8(%eax),%edx
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	8b 48 08             	mov    0x8(%eax),%ecx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9a:	01 c8                	add    %ecx,%eax
  802d9c:	39 c2                	cmp    %eax,%edx
  802d9e:	0f 85 a3 00 00 00    	jne    802e47 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802da4:	a1 38 51 80 00       	mov    0x805138,%eax
  802da9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dac:	8b 52 08             	mov    0x8(%edx),%edx
  802daf:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802db2:	a1 38 51 80 00       	mov    0x805138,%eax
  802db7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dbd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc3:	8b 52 0c             	mov    0xc(%edx),%edx
  802dc6:	01 ca                	add    %ecx,%edx
  802dc8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ddf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de3:	75 17                	jne    802dfc <insert_sorted_with_merge_freeList+0x28b>
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	68 f0 41 80 00       	push   $0x8041f0
  802ded:	68 5d 01 00 00       	push   $0x15d
  802df2:	68 13 42 80 00       	push   $0x804213
  802df7:	e8 b3 d7 ff ff       	call   8005af <_panic>
  802dfc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0d                	je     802e1d <insert_sorted_with_merge_freeList+0x2ac>
  802e10:	a1 48 51 80 00       	mov    0x805148,%eax
  802e15:	8b 55 08             	mov    0x8(%ebp),%edx
  802e18:	89 50 04             	mov    %edx,0x4(%eax)
  802e1b:	eb 08                	jmp    802e25 <insert_sorted_with_merge_freeList+0x2b4>
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	a3 48 51 80 00       	mov    %eax,0x805148
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e37:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3c:	40                   	inc    %eax
  802e3d:	a3 54 51 80 00       	mov    %eax,0x805154
  802e42:	e9 37 05 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 50 08             	mov    0x8(%eax),%edx
  802e4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	39 c2                	cmp    %eax,%edx
  802e57:	0f 83 82 00 00 00    	jae    802edf <insert_sorted_with_merge_freeList+0x36e>
  802e5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e62:	8b 50 08             	mov    0x8(%eax),%edx
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	8b 48 08             	mov    0x8(%eax),%ecx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e71:	01 c8                	add    %ecx,%eax
  802e73:	39 c2                	cmp    %eax,%edx
  802e75:	74 68                	je     802edf <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7b:	75 17                	jne    802e94 <insert_sorted_with_merge_freeList+0x323>
  802e7d:	83 ec 04             	sub    $0x4,%esp
  802e80:	68 f0 41 80 00       	push   $0x8041f0
  802e85:	68 62 01 00 00       	push   $0x162
  802e8a:	68 13 42 80 00       	push   $0x804213
  802e8f:	e8 1b d7 ff ff       	call   8005af <_panic>
  802e94:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	89 10                	mov    %edx,(%eax)
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 0d                	je     802eb5 <insert_sorted_with_merge_freeList+0x344>
  802ea8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ead:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb0:	89 50 04             	mov    %edx,0x4(%eax)
  802eb3:	eb 08                	jmp    802ebd <insert_sorted_with_merge_freeList+0x34c>
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecf:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed4:	40                   	inc    %eax
  802ed5:	a3 44 51 80 00       	mov    %eax,0x805144
  802eda:	e9 9f 04 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802edf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802ee9:	e9 84 04 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 50 08             	mov    0x8(%eax),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 08             	mov    0x8(%eax),%eax
  802efa:	39 c2                	cmp    %eax,%edx
  802efc:	0f 86 a9 00 00 00    	jbe    802fab <insert_sorted_with_merge_freeList+0x43a>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 48 08             	mov    0x8(%eax),%ecx
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 40 0c             	mov    0xc(%eax),%eax
  802f14:	01 c8                	add    %ecx,%eax
  802f16:	39 c2                	cmp    %eax,%edx
  802f18:	0f 84 8d 00 00 00    	je     802fab <insert_sorted_with_merge_freeList+0x43a>
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
  802f3a:	74 6f                	je     802fab <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f40:	74 06                	je     802f48 <insert_sorted_with_merge_freeList+0x3d7>
  802f42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f46:	75 17                	jne    802f5f <insert_sorted_with_merge_freeList+0x3ee>
  802f48:	83 ec 04             	sub    $0x4,%esp
  802f4b:	68 50 42 80 00       	push   $0x804250
  802f50:	68 6b 01 00 00       	push   $0x16b
  802f55:	68 13 42 80 00       	push   $0x804213
  802f5a:	e8 50 d6 ff ff       	call   8005af <_panic>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 50 04             	mov    0x4(%eax),%edx
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	89 50 04             	mov    %edx,0x4(%eax)
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 0d                	je     802f8a <insert_sorted_with_merge_freeList+0x419>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	8b 55 08             	mov    0x8(%ebp),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 08                	jmp    802f92 <insert_sorted_with_merge_freeList+0x421>
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 55 08             	mov    0x8(%ebp),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa0:	40                   	inc    %eax
  802fa1:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  802fa6:	e9 d3 03 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 50 08             	mov    0x8(%eax),%edx
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 40 08             	mov    0x8(%eax),%eax
  802fb7:	39 c2                	cmp    %eax,%edx
  802fb9:	0f 86 da 00 00 00    	jbe    803099 <insert_sorted_with_merge_freeList+0x528>
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 50 08             	mov    0x8(%eax),%edx
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8b 48 08             	mov    0x8(%eax),%ecx
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd1:	01 c8                	add    %ecx,%eax
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	0f 85 be 00 00 00    	jne    803099 <insert_sorted_with_merge_freeList+0x528>
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 50 08             	mov    0x8(%eax),%edx
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	8b 48 08             	mov    0x8(%eax),%ecx
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff3:	01 c8                	add    %ecx,%eax
  802ff5:	39 c2                	cmp    %eax,%edx
  802ff7:	0f 84 9c 00 00 00    	je     803099 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	8b 50 08             	mov    0x8(%eax),%edx
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 50 0c             	mov    0xc(%eax),%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	8b 40 0c             	mov    0xc(%eax),%eax
  803015:	01 c2                	add    %eax,%edx
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803031:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803035:	75 17                	jne    80304e <insert_sorted_with_merge_freeList+0x4dd>
  803037:	83 ec 04             	sub    $0x4,%esp
  80303a:	68 f0 41 80 00       	push   $0x8041f0
  80303f:	68 74 01 00 00       	push   $0x174
  803044:	68 13 42 80 00       	push   $0x804213
  803049:	e8 61 d5 ff ff       	call   8005af <_panic>
  80304e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	89 10                	mov    %edx,(%eax)
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0d                	je     80306f <insert_sorted_with_merge_freeList+0x4fe>
  803062:	a1 48 51 80 00       	mov    0x805148,%eax
  803067:	8b 55 08             	mov    0x8(%ebp),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	eb 08                	jmp    803077 <insert_sorted_with_merge_freeList+0x506>
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	a3 48 51 80 00       	mov    %eax,0x805148
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803089:	a1 54 51 80 00       	mov    0x805154,%eax
  80308e:	40                   	inc    %eax
  80308f:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803094:	e9 e5 02 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 50 08             	mov    0x8(%eax),%edx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 40 08             	mov    0x8(%eax),%eax
  8030a5:	39 c2                	cmp    %eax,%edx
  8030a7:	0f 86 d7 00 00 00    	jbe    803184 <insert_sorted_with_merge_freeList+0x613>
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 50 08             	mov    0x8(%eax),%edx
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 48 08             	mov    0x8(%eax),%ecx
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bf:	01 c8                	add    %ecx,%eax
  8030c1:	39 c2                	cmp    %eax,%edx
  8030c3:	0f 84 bb 00 00 00    	je     803184 <insert_sorted_with_merge_freeList+0x613>
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	8b 50 08             	mov    0x8(%eax),%edx
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 40 04             	mov    0x4(%eax),%eax
  8030d5:	8b 48 08             	mov    0x8(%eax),%ecx
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e1:	01 c8                	add    %ecx,%eax
  8030e3:	39 c2                	cmp    %eax,%edx
  8030e5:	0f 85 99 00 00 00    	jne    803184 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803100:	01 c2                	add    %eax,%edx
  803102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803105:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80311c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803120:	75 17                	jne    803139 <insert_sorted_with_merge_freeList+0x5c8>
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	68 f0 41 80 00       	push   $0x8041f0
  80312a:	68 7d 01 00 00       	push   $0x17d
  80312f:	68 13 42 80 00       	push   $0x804213
  803134:	e8 76 d4 ff ff       	call   8005af <_panic>
  803139:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	89 10                	mov    %edx,(%eax)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 0d                	je     80315a <insert_sorted_with_merge_freeList+0x5e9>
  80314d:	a1 48 51 80 00       	mov    0x805148,%eax
  803152:	8b 55 08             	mov    0x8(%ebp),%edx
  803155:	89 50 04             	mov    %edx,0x4(%eax)
  803158:	eb 08                	jmp    803162 <insert_sorted_with_merge_freeList+0x5f1>
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	a3 48 51 80 00       	mov    %eax,0x805148
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803174:	a1 54 51 80 00       	mov    0x805154,%eax
  803179:	40                   	inc    %eax
  80317a:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80317f:	e9 fa 01 00 00       	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 50 08             	mov    0x8(%eax),%edx
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	8b 40 08             	mov    0x8(%eax),%eax
  803190:	39 c2                	cmp    %eax,%edx
  803192:	0f 86 d2 01 00 00    	jbe    80336a <insert_sorted_with_merge_freeList+0x7f9>
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	8b 50 08             	mov    0x8(%eax),%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 48 08             	mov    0x8(%eax),%ecx
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031aa:	01 c8                	add    %ecx,%eax
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	0f 85 b6 01 00 00    	jne    80336a <insert_sorted_with_merge_freeList+0x7f9>
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cc:	01 c8                	add    %ecx,%eax
  8031ce:	39 c2                	cmp    %eax,%edx
  8031d0:	0f 85 94 01 00 00    	jne    80336a <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	8b 40 04             	mov    0x4(%eax),%eax
  8031dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031df:	8b 52 04             	mov    0x4(%edx),%edx
  8031e2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e8:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8031eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ee:	8b 52 0c             	mov    0xc(%edx),%edx
  8031f1:	01 da                	add    %ebx,%edx
  8031f3:	01 ca                	add    %ecx,%edx
  8031f5:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803205:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80320c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803210:	75 17                	jne    803229 <insert_sorted_with_merge_freeList+0x6b8>
  803212:	83 ec 04             	sub    $0x4,%esp
  803215:	68 85 42 80 00       	push   $0x804285
  80321a:	68 86 01 00 00       	push   $0x186
  80321f:	68 13 42 80 00       	push   $0x804213
  803224:	e8 86 d3 ff ff       	call   8005af <_panic>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	85 c0                	test   %eax,%eax
  803230:	74 10                	je     803242 <insert_sorted_with_merge_freeList+0x6d1>
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323a:	8b 52 04             	mov    0x4(%edx),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	eb 0b                	jmp    80324d <insert_sorted_with_merge_freeList+0x6dc>
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 40 04             	mov    0x4(%eax),%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	74 0f                	je     803266 <insert_sorted_with_merge_freeList+0x6f5>
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803260:	8b 12                	mov    (%edx),%edx
  803262:	89 10                	mov    %edx,(%eax)
  803264:	eb 0a                	jmp    803270 <insert_sorted_with_merge_freeList+0x6ff>
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	a3 38 51 80 00       	mov    %eax,0x805138
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803283:	a1 44 51 80 00       	mov    0x805144,%eax
  803288:	48                   	dec    %eax
  803289:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80328e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803292:	75 17                	jne    8032ab <insert_sorted_with_merge_freeList+0x73a>
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	68 f0 41 80 00       	push   $0x8041f0
  80329c:	68 87 01 00 00       	push   $0x187
  8032a1:	68 13 42 80 00       	push   $0x804213
  8032a6:	e8 04 d3 ff ff       	call   8005af <_panic>
  8032ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	74 0d                	je     8032cc <insert_sorted_with_merge_freeList+0x75b>
  8032bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	eb 08                	jmp    8032d4 <insert_sorted_with_merge_freeList+0x763>
  8032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032eb:	40                   	inc    %eax
  8032ec:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803305:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803309:	75 17                	jne    803322 <insert_sorted_with_merge_freeList+0x7b1>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 f0 41 80 00       	push   $0x8041f0
  803313:	68 8a 01 00 00       	push   $0x18a
  803318:	68 13 42 80 00       	push   $0x804213
  80331d:	e8 8d d2 ff ff       	call   8005af <_panic>
  803322:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0d                	je     803343 <insert_sorted_with_merge_freeList+0x7d2>
  803336:	a1 48 51 80 00       	mov    0x805148,%eax
  80333b:	8b 55 08             	mov    0x8(%ebp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 08                	jmp    80334b <insert_sorted_with_merge_freeList+0x7da>
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 48 51 80 00       	mov    %eax,0x805148
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335d:	a1 54 51 80 00       	mov    0x805154,%eax
  803362:	40                   	inc    %eax
  803363:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803368:	eb 14                	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803376:	0f 85 72 fb ff ff    	jne    802eee <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80337c:	eb 00                	jmp    80337e <insert_sorted_with_merge_freeList+0x80d>
  80337e:	90                   	nop
  80337f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803382:	c9                   	leave  
  803383:	c3                   	ret    

00803384 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803384:	55                   	push   %ebp
  803385:	89 e5                	mov    %esp,%ebp
  803387:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80338a:	8b 55 08             	mov    0x8(%ebp),%edx
  80338d:	89 d0                	mov    %edx,%eax
  80338f:	c1 e0 02             	shl    $0x2,%eax
  803392:	01 d0                	add    %edx,%eax
  803394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80339b:	01 d0                	add    %edx,%eax
  80339d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033a4:	01 d0                	add    %edx,%eax
  8033a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033ad:	01 d0                	add    %edx,%eax
  8033af:	c1 e0 04             	shl    $0x4,%eax
  8033b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033bc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033bf:	83 ec 0c             	sub    $0xc,%esp
  8033c2:	50                   	push   %eax
  8033c3:	e8 7b eb ff ff       	call   801f43 <sys_get_virtual_time>
  8033c8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033cb:	eb 41                	jmp    80340e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033d0:	83 ec 0c             	sub    $0xc,%esp
  8033d3:	50                   	push   %eax
  8033d4:	e8 6a eb ff ff       	call   801f43 <sys_get_virtual_time>
  8033d9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e2:	29 c2                	sub    %eax,%edx
  8033e4:	89 d0                	mov    %edx,%eax
  8033e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ef:	89 d1                	mov    %edx,%ecx
  8033f1:	29 c1                	sub    %eax,%ecx
  8033f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f9:	39 c2                	cmp    %eax,%edx
  8033fb:	0f 97 c0             	seta   %al
  8033fe:	0f b6 c0             	movzbl %al,%eax
  803401:	29 c1                	sub    %eax,%ecx
  803403:	89 c8                	mov    %ecx,%eax
  803405:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803408:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80340b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803414:	72 b7                	jb     8033cd <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803416:	90                   	nop
  803417:	c9                   	leave  
  803418:	c3                   	ret    

00803419 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803419:	55                   	push   %ebp
  80341a:	89 e5                	mov    %esp,%ebp
  80341c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80341f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803426:	eb 03                	jmp    80342b <busy_wait+0x12>
  803428:	ff 45 fc             	incl   -0x4(%ebp)
  80342b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80342e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803431:	72 f5                	jb     803428 <busy_wait+0xf>
	return i;
  803433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803436:	c9                   	leave  
  803437:	c3                   	ret    

00803438 <__udivdi3>:
  803438:	55                   	push   %ebp
  803439:	57                   	push   %edi
  80343a:	56                   	push   %esi
  80343b:	53                   	push   %ebx
  80343c:	83 ec 1c             	sub    $0x1c,%esp
  80343f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803443:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803447:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80344b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80344f:	89 ca                	mov    %ecx,%edx
  803451:	89 f8                	mov    %edi,%eax
  803453:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803457:	85 f6                	test   %esi,%esi
  803459:	75 2d                	jne    803488 <__udivdi3+0x50>
  80345b:	39 cf                	cmp    %ecx,%edi
  80345d:	77 65                	ja     8034c4 <__udivdi3+0x8c>
  80345f:	89 fd                	mov    %edi,%ebp
  803461:	85 ff                	test   %edi,%edi
  803463:	75 0b                	jne    803470 <__udivdi3+0x38>
  803465:	b8 01 00 00 00       	mov    $0x1,%eax
  80346a:	31 d2                	xor    %edx,%edx
  80346c:	f7 f7                	div    %edi
  80346e:	89 c5                	mov    %eax,%ebp
  803470:	31 d2                	xor    %edx,%edx
  803472:	89 c8                	mov    %ecx,%eax
  803474:	f7 f5                	div    %ebp
  803476:	89 c1                	mov    %eax,%ecx
  803478:	89 d8                	mov    %ebx,%eax
  80347a:	f7 f5                	div    %ebp
  80347c:	89 cf                	mov    %ecx,%edi
  80347e:	89 fa                	mov    %edi,%edx
  803480:	83 c4 1c             	add    $0x1c,%esp
  803483:	5b                   	pop    %ebx
  803484:	5e                   	pop    %esi
  803485:	5f                   	pop    %edi
  803486:	5d                   	pop    %ebp
  803487:	c3                   	ret    
  803488:	39 ce                	cmp    %ecx,%esi
  80348a:	77 28                	ja     8034b4 <__udivdi3+0x7c>
  80348c:	0f bd fe             	bsr    %esi,%edi
  80348f:	83 f7 1f             	xor    $0x1f,%edi
  803492:	75 40                	jne    8034d4 <__udivdi3+0x9c>
  803494:	39 ce                	cmp    %ecx,%esi
  803496:	72 0a                	jb     8034a2 <__udivdi3+0x6a>
  803498:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80349c:	0f 87 9e 00 00 00    	ja     803540 <__udivdi3+0x108>
  8034a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034a7:	89 fa                	mov    %edi,%edx
  8034a9:	83 c4 1c             	add    $0x1c,%esp
  8034ac:	5b                   	pop    %ebx
  8034ad:	5e                   	pop    %esi
  8034ae:	5f                   	pop    %edi
  8034af:	5d                   	pop    %ebp
  8034b0:	c3                   	ret    
  8034b1:	8d 76 00             	lea    0x0(%esi),%esi
  8034b4:	31 ff                	xor    %edi,%edi
  8034b6:	31 c0                	xor    %eax,%eax
  8034b8:	89 fa                	mov    %edi,%edx
  8034ba:	83 c4 1c             	add    $0x1c,%esp
  8034bd:	5b                   	pop    %ebx
  8034be:	5e                   	pop    %esi
  8034bf:	5f                   	pop    %edi
  8034c0:	5d                   	pop    %ebp
  8034c1:	c3                   	ret    
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	89 d8                	mov    %ebx,%eax
  8034c6:	f7 f7                	div    %edi
  8034c8:	31 ff                	xor    %edi,%edi
  8034ca:	89 fa                	mov    %edi,%edx
  8034cc:	83 c4 1c             	add    $0x1c,%esp
  8034cf:	5b                   	pop    %ebx
  8034d0:	5e                   	pop    %esi
  8034d1:	5f                   	pop    %edi
  8034d2:	5d                   	pop    %ebp
  8034d3:	c3                   	ret    
  8034d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034d9:	89 eb                	mov    %ebp,%ebx
  8034db:	29 fb                	sub    %edi,%ebx
  8034dd:	89 f9                	mov    %edi,%ecx
  8034df:	d3 e6                	shl    %cl,%esi
  8034e1:	89 c5                	mov    %eax,%ebp
  8034e3:	88 d9                	mov    %bl,%cl
  8034e5:	d3 ed                	shr    %cl,%ebp
  8034e7:	89 e9                	mov    %ebp,%ecx
  8034e9:	09 f1                	or     %esi,%ecx
  8034eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034ef:	89 f9                	mov    %edi,%ecx
  8034f1:	d3 e0                	shl    %cl,%eax
  8034f3:	89 c5                	mov    %eax,%ebp
  8034f5:	89 d6                	mov    %edx,%esi
  8034f7:	88 d9                	mov    %bl,%cl
  8034f9:	d3 ee                	shr    %cl,%esi
  8034fb:	89 f9                	mov    %edi,%ecx
  8034fd:	d3 e2                	shl    %cl,%edx
  8034ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803503:	88 d9                	mov    %bl,%cl
  803505:	d3 e8                	shr    %cl,%eax
  803507:	09 c2                	or     %eax,%edx
  803509:	89 d0                	mov    %edx,%eax
  80350b:	89 f2                	mov    %esi,%edx
  80350d:	f7 74 24 0c          	divl   0xc(%esp)
  803511:	89 d6                	mov    %edx,%esi
  803513:	89 c3                	mov    %eax,%ebx
  803515:	f7 e5                	mul    %ebp
  803517:	39 d6                	cmp    %edx,%esi
  803519:	72 19                	jb     803534 <__udivdi3+0xfc>
  80351b:	74 0b                	je     803528 <__udivdi3+0xf0>
  80351d:	89 d8                	mov    %ebx,%eax
  80351f:	31 ff                	xor    %edi,%edi
  803521:	e9 58 ff ff ff       	jmp    80347e <__udivdi3+0x46>
  803526:	66 90                	xchg   %ax,%ax
  803528:	8b 54 24 08          	mov    0x8(%esp),%edx
  80352c:	89 f9                	mov    %edi,%ecx
  80352e:	d3 e2                	shl    %cl,%edx
  803530:	39 c2                	cmp    %eax,%edx
  803532:	73 e9                	jae    80351d <__udivdi3+0xe5>
  803534:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803537:	31 ff                	xor    %edi,%edi
  803539:	e9 40 ff ff ff       	jmp    80347e <__udivdi3+0x46>
  80353e:	66 90                	xchg   %ax,%ax
  803540:	31 c0                	xor    %eax,%eax
  803542:	e9 37 ff ff ff       	jmp    80347e <__udivdi3+0x46>
  803547:	90                   	nop

00803548 <__umoddi3>:
  803548:	55                   	push   %ebp
  803549:	57                   	push   %edi
  80354a:	56                   	push   %esi
  80354b:	53                   	push   %ebx
  80354c:	83 ec 1c             	sub    $0x1c,%esp
  80354f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803553:	8b 74 24 34          	mov    0x34(%esp),%esi
  803557:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80355b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80355f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803563:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803567:	89 f3                	mov    %esi,%ebx
  803569:	89 fa                	mov    %edi,%edx
  80356b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80356f:	89 34 24             	mov    %esi,(%esp)
  803572:	85 c0                	test   %eax,%eax
  803574:	75 1a                	jne    803590 <__umoddi3+0x48>
  803576:	39 f7                	cmp    %esi,%edi
  803578:	0f 86 a2 00 00 00    	jbe    803620 <__umoddi3+0xd8>
  80357e:	89 c8                	mov    %ecx,%eax
  803580:	89 f2                	mov    %esi,%edx
  803582:	f7 f7                	div    %edi
  803584:	89 d0                	mov    %edx,%eax
  803586:	31 d2                	xor    %edx,%edx
  803588:	83 c4 1c             	add    $0x1c,%esp
  80358b:	5b                   	pop    %ebx
  80358c:	5e                   	pop    %esi
  80358d:	5f                   	pop    %edi
  80358e:	5d                   	pop    %ebp
  80358f:	c3                   	ret    
  803590:	39 f0                	cmp    %esi,%eax
  803592:	0f 87 ac 00 00 00    	ja     803644 <__umoddi3+0xfc>
  803598:	0f bd e8             	bsr    %eax,%ebp
  80359b:	83 f5 1f             	xor    $0x1f,%ebp
  80359e:	0f 84 ac 00 00 00    	je     803650 <__umoddi3+0x108>
  8035a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035a9:	29 ef                	sub    %ebp,%edi
  8035ab:	89 fe                	mov    %edi,%esi
  8035ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035b1:	89 e9                	mov    %ebp,%ecx
  8035b3:	d3 e0                	shl    %cl,%eax
  8035b5:	89 d7                	mov    %edx,%edi
  8035b7:	89 f1                	mov    %esi,%ecx
  8035b9:	d3 ef                	shr    %cl,%edi
  8035bb:	09 c7                	or     %eax,%edi
  8035bd:	89 e9                	mov    %ebp,%ecx
  8035bf:	d3 e2                	shl    %cl,%edx
  8035c1:	89 14 24             	mov    %edx,(%esp)
  8035c4:	89 d8                	mov    %ebx,%eax
  8035c6:	d3 e0                	shl    %cl,%eax
  8035c8:	89 c2                	mov    %eax,%edx
  8035ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ce:	d3 e0                	shl    %cl,%eax
  8035d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d8:	89 f1                	mov    %esi,%ecx
  8035da:	d3 e8                	shr    %cl,%eax
  8035dc:	09 d0                	or     %edx,%eax
  8035de:	d3 eb                	shr    %cl,%ebx
  8035e0:	89 da                	mov    %ebx,%edx
  8035e2:	f7 f7                	div    %edi
  8035e4:	89 d3                	mov    %edx,%ebx
  8035e6:	f7 24 24             	mull   (%esp)
  8035e9:	89 c6                	mov    %eax,%esi
  8035eb:	89 d1                	mov    %edx,%ecx
  8035ed:	39 d3                	cmp    %edx,%ebx
  8035ef:	0f 82 87 00 00 00    	jb     80367c <__umoddi3+0x134>
  8035f5:	0f 84 91 00 00 00    	je     80368c <__umoddi3+0x144>
  8035fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035ff:	29 f2                	sub    %esi,%edx
  803601:	19 cb                	sbb    %ecx,%ebx
  803603:	89 d8                	mov    %ebx,%eax
  803605:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803609:	d3 e0                	shl    %cl,%eax
  80360b:	89 e9                	mov    %ebp,%ecx
  80360d:	d3 ea                	shr    %cl,%edx
  80360f:	09 d0                	or     %edx,%eax
  803611:	89 e9                	mov    %ebp,%ecx
  803613:	d3 eb                	shr    %cl,%ebx
  803615:	89 da                	mov    %ebx,%edx
  803617:	83 c4 1c             	add    $0x1c,%esp
  80361a:	5b                   	pop    %ebx
  80361b:	5e                   	pop    %esi
  80361c:	5f                   	pop    %edi
  80361d:	5d                   	pop    %ebp
  80361e:	c3                   	ret    
  80361f:	90                   	nop
  803620:	89 fd                	mov    %edi,%ebp
  803622:	85 ff                	test   %edi,%edi
  803624:	75 0b                	jne    803631 <__umoddi3+0xe9>
  803626:	b8 01 00 00 00       	mov    $0x1,%eax
  80362b:	31 d2                	xor    %edx,%edx
  80362d:	f7 f7                	div    %edi
  80362f:	89 c5                	mov    %eax,%ebp
  803631:	89 f0                	mov    %esi,%eax
  803633:	31 d2                	xor    %edx,%edx
  803635:	f7 f5                	div    %ebp
  803637:	89 c8                	mov    %ecx,%eax
  803639:	f7 f5                	div    %ebp
  80363b:	89 d0                	mov    %edx,%eax
  80363d:	e9 44 ff ff ff       	jmp    803586 <__umoddi3+0x3e>
  803642:	66 90                	xchg   %ax,%ax
  803644:	89 c8                	mov    %ecx,%eax
  803646:	89 f2                	mov    %esi,%edx
  803648:	83 c4 1c             	add    $0x1c,%esp
  80364b:	5b                   	pop    %ebx
  80364c:	5e                   	pop    %esi
  80364d:	5f                   	pop    %edi
  80364e:	5d                   	pop    %ebp
  80364f:	c3                   	ret    
  803650:	3b 04 24             	cmp    (%esp),%eax
  803653:	72 06                	jb     80365b <__umoddi3+0x113>
  803655:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803659:	77 0f                	ja     80366a <__umoddi3+0x122>
  80365b:	89 f2                	mov    %esi,%edx
  80365d:	29 f9                	sub    %edi,%ecx
  80365f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803663:	89 14 24             	mov    %edx,(%esp)
  803666:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80366a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80366e:	8b 14 24             	mov    (%esp),%edx
  803671:	83 c4 1c             	add    $0x1c,%esp
  803674:	5b                   	pop    %ebx
  803675:	5e                   	pop    %esi
  803676:	5f                   	pop    %edi
  803677:	5d                   	pop    %ebp
  803678:	c3                   	ret    
  803679:	8d 76 00             	lea    0x0(%esi),%esi
  80367c:	2b 04 24             	sub    (%esp),%eax
  80367f:	19 fa                	sbb    %edi,%edx
  803681:	89 d1                	mov    %edx,%ecx
  803683:	89 c6                	mov    %eax,%esi
  803685:	e9 71 ff ff ff       	jmp    8035fb <__umoddi3+0xb3>
  80368a:	66 90                	xchg   %ax,%ax
  80368c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803690:	72 ea                	jb     80367c <__umoddi3+0x134>
  803692:	89 d9                	mov    %ebx,%ecx
  803694:	e9 62 ff ff ff       	jmp    8035fb <__umoddi3+0xb3>
