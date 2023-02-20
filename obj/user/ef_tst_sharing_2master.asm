
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 c0 35 80 00       	push   $0x8035c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 35 80 00       	push   $0x8035dc
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 80 1a 00 00       	call   801b23 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 fa 35 80 00       	push   $0x8035fa
  8000b2:	e8 69 17 00 00       	call   801820 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 fc 35 80 00       	push   $0x8035fc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 dc 35 80 00       	push   $0x8035dc
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 41 1a 00 00       	call   801b23 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 30 1a 00 00       	call   801b23 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 29 1a 00 00       	call   801b23 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 60 36 80 00       	push   $0x803660
  800107:	6a 1b                	push   $0x1b
  800109:	68 dc 35 80 00       	push   $0x8035dc
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 0b 1a 00 00       	call   801b23 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 f1 36 80 00       	push   $0x8036f1
  800127:	e8 f4 16 00 00       	call   801820 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 fc 35 80 00       	push   $0x8035fc
  800143:	6a 20                	push   $0x20
  800145:	68 dc 35 80 00       	push   $0x8035dc
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 cc 19 00 00       	call   801b23 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 bb 19 00 00       	call   801b23 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 b4 19 00 00       	call   801b23 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 60 36 80 00       	push   $0x803660
  80017c:	6a 21                	push   $0x21
  80017e:	68 dc 35 80 00       	push   $0x8035dc
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 96 19 00 00       	call   801b23 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 f3 36 80 00       	push   $0x8036f3
  80019c:	e8 7f 16 00 00       	call   801820 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 fc 35 80 00       	push   $0x8035fc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 dc 35 80 00       	push   $0x8035dc
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 57 19 00 00       	call   801b23 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 f8 36 80 00       	push   $0x8036f8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 dc 35 80 00       	push   $0x8035dc
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 50 80 00       	mov    0x805020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 80 37 80 00       	push   $0x803780
  800219:	e8 77 1b 00 00       	call   801d95 <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 50 80 00       	mov    0x805020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 50 80 00       	mov    0x805020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 80 37 80 00       	push   $0x803780
  800242:	e8 4e 1b 00 00       	call   801d95 <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 80 37 80 00       	push   $0x803780
  80026b:	e8 25 1b 00 00       	call   801d95 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 66 1c 00 00       	call   801ee1 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 8e 37 80 00       	push   $0x80378e
  800287:	e8 94 15 00 00       	call   801820 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 16 1b 00 00       	call   801db3 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 08 1b 00 00       	call   801db3 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 fa 1a 00 00       	call   801db3 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 c7 2f 00 00       	call   803290 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 8a 1c 00 00       	call   801f5b <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 9e 37 80 00       	push   $0x80379e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 dc 35 80 00       	push   $0x8035dc
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ac 37 80 00       	push   $0x8037ac
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 dc 35 80 00       	push   $0x8035dc
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 fc 37 80 00       	push   $0x8037fc
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 ff 1a 00 00       	call   801e1c <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 a3 1a 00 00       	call   801dcf <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 95 1a 00 00       	call   801dcf <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 87 1a 00 00       	call   801dcf <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 c5 1a 00 00       	call   801e1c <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 56 38 80 00       	push   $0x803856
  80035f:	50                   	push   %eax
  800360:	e8 7e 15 00 00       	call   8018e3 <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 79 1a 00 00       	call   801e03 <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 1b 18 00 00       	call   801c10 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 7c 38 80 00       	push   $0x80387c
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 50 80 00       	mov    0x805020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 50 80 00       	mov    0x805020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 a4 38 80 00       	push   $0x8038a4
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 50 80 00       	mov    0x805020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 50 80 00       	mov    0x805020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 cc 38 80 00       	push   $0x8038cc
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 24 39 80 00       	push   $0x803924
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 7c 38 80 00       	push   $0x80387c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 9b 17 00 00       	call   801c2a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 28 19 00 00       	call   801dcf <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 7d 19 00 00       	call   801e35 <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 38 39 80 00       	push   $0x803938
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 50 80 00       	mov    0x805000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 3d 39 80 00       	push   $0x80393d
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 59 39 80 00       	push   $0x803959
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 50 80 00       	mov    0x805020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 5c 39 80 00       	push   $0x80395c
  80054a:	6a 26                	push   $0x26
  80054c:	68 a8 39 80 00       	push   $0x8039a8
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 50 80 00       	mov    0x805020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 b4 39 80 00       	push   $0x8039b4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 a8 39 80 00       	push   $0x8039a8
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 50 80 00       	mov    0x805020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 50 80 00       	mov    0x805020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 08 3a 80 00       	push   $0x803a08
  80068c:	6a 44                	push   $0x44
  80068e:	68 a8 39 80 00       	push   $0x8039a8
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 50 80 00       	mov    0x805024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 7c 13 00 00       	call   801a62 <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 50 80 00       	mov    0x805024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 05 13 00 00       	call   801a62 <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 69 14 00 00       	call   801c10 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 63 14 00 00       	call   801c2a <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 33 2b 00 00       	call   803344 <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 f3 2b 00 00       	call   803454 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 74 3c 80 00       	add    $0x803c74,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 85 3c 80 00       	push   $0x803c85
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 8e 3c 80 00       	push   $0x803c8e
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 50 80 00       	mov    0x805004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 f0 3d 80 00       	push   $0x803df0
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801530:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801537:	00 00 00 
  80153a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801541:	00 00 00 
  801544:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80154b:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80154e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801555:	00 00 00 
  801558:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80155f:	00 00 00 
  801562:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801569:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80156c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801573:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801576:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80157d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801591:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801596:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80159d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	6a 06                	push   $0x6
  8015af:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b2:	50                   	push   %eax
  8015b3:	e8 ee 05 00 00       	call   801ba6 <sys_allocate_chunk>
  8015b8:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015bb:	a1 20 51 80 00       	mov    0x805120,%eax
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	50                   	push   %eax
  8015c4:	e8 63 0c 00 00       	call   80222c <initialize_MemBlocksList>
  8015c9:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8015cc:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8015d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8015d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8015de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f4:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8015f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015fa:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801601:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80160b:	8b 50 08             	mov    0x8(%eax),%edx
  80160e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	48                   	dec    %eax
  801614:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801617:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	f7 75 e0             	divl   -0x20(%ebp)
  801622:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801625:	29 d0                	sub    %edx,%eax
  801627:	89 c2                	mov    %eax,%edx
  801629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162c:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80162f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801633:	75 14                	jne    801649 <initialize_dyn_block_system+0x11f>
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	68 15 3e 80 00       	push   $0x803e15
  80163d:	6a 34                	push   $0x34
  80163f:	68 33 3e 80 00       	push   $0x803e33
  801644:	e8 72 ee ff ff       	call   8004bb <_panic>
  801649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 10                	je     801662 <initialize_dyn_block_system+0x138>
  801652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80165a:	8b 52 04             	mov    0x4(%edx),%edx
  80165d:	89 50 04             	mov    %edx,0x4(%eax)
  801660:	eb 0b                	jmp    80166d <initialize_dyn_block_system+0x143>
  801662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801665:	8b 40 04             	mov    0x4(%eax),%eax
  801668:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80166d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801670:	8b 40 04             	mov    0x4(%eax),%eax
  801673:	85 c0                	test   %eax,%eax
  801675:	74 0f                	je     801686 <initialize_dyn_block_system+0x15c>
  801677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80167a:	8b 40 04             	mov    0x4(%eax),%eax
  80167d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801680:	8b 12                	mov    (%edx),%edx
  801682:	89 10                	mov    %edx,(%eax)
  801684:	eb 0a                	jmp    801690 <initialize_dyn_block_system+0x166>
  801686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801689:	8b 00                	mov    (%eax),%eax
  80168b:	a3 48 51 80 00       	mov    %eax,0x805148
  801690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801693:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8016a8:	48                   	dec    %eax
  8016a9:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8016ae:	83 ec 0c             	sub    $0xc,%esp
  8016b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b4:	e8 c4 13 00 00       	call   802a7d <insert_sorted_with_merge_freeList>
  8016b9:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016bc:	90                   	nop
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <malloc>:
//=================================



void* malloc(uint32 size)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c5:	e8 2f fe ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ce:	75 07                	jne    8016d7 <malloc+0x18>
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d5:	eb 71                	jmp    801748 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016d7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016de:	76 07                	jbe    8016e7 <malloc+0x28>
	return NULL;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	eb 61                	jmp    801748 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e7:	e8 88 08 00 00       	call   801f74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	74 53                	je     801743 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016f0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	48                   	dec    %eax
  801700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801706:	ba 00 00 00 00       	mov    $0x0,%edx
  80170b:	f7 75 f4             	divl   -0xc(%ebp)
  80170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801711:	29 d0                	sub    %edx,%eax
  801713:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	ff 75 ec             	pushl  -0x14(%ebp)
  80171c:	e8 d2 0d 00 00       	call   8024f3 <alloc_block_FF>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801727:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80172b:	74 16                	je     801743 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	ff 75 e8             	pushl  -0x18(%ebp)
  801733:	e8 0c 0c 00 00       	call   802344 <insert_sorted_allocList>
  801738:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80173b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173e:	8b 40 08             	mov    0x8(%eax),%eax
  801741:	eb 05                	jmp    801748 <malloc+0x89>
    }

			}


	return NULL;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801759:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80175e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	ff 75 f0             	pushl  -0x10(%ebp)
  801767:	68 40 50 80 00       	push   $0x805040
  80176c:	e8 a0 0b 00 00       	call   802311 <find_block>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177a:	8b 50 0c             	mov    0xc(%eax),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	e8 e4 03 00 00       	call   801b6e <sys_free_user_mem>
  80178a:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80178d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801791:	75 17                	jne    8017aa <free+0x60>
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 15 3e 80 00       	push   $0x803e15
  80179b:	68 84 00 00 00       	push   $0x84
  8017a0:	68 33 3e 80 00       	push   $0x803e33
  8017a5:	e8 11 ed ff ff       	call   8004bb <_panic>
  8017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ad:	8b 00                	mov    (%eax),%eax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	74 10                	je     8017c3 <free+0x79>
  8017b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017bb:	8b 52 04             	mov    0x4(%edx),%edx
  8017be:	89 50 04             	mov    %edx,0x4(%eax)
  8017c1:	eb 0b                	jmp    8017ce <free+0x84>
  8017c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c6:	8b 40 04             	mov    0x4(%eax),%eax
  8017c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8017ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d1:	8b 40 04             	mov    0x4(%eax),%eax
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	74 0f                	je     8017e7 <free+0x9d>
  8017d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017db:	8b 40 04             	mov    0x4(%eax),%eax
  8017de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017e1:	8b 12                	mov    (%edx),%edx
  8017e3:	89 10                	mov    %edx,(%eax)
  8017e5:	eb 0a                	jmp    8017f1 <free+0xa7>
  8017e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	a3 40 50 80 00       	mov    %eax,0x805040
  8017f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801804:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801809:	48                   	dec    %eax
  80180a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	ff 75 ec             	pushl  -0x14(%ebp)
  801815:	e8 63 12 00 00       	call   802a7d <insert_sorted_with_merge_freeList>
  80181a:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80181d:	90                   	nop
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 38             	sub    $0x38,%esp
  801826:	8b 45 10             	mov    0x10(%ebp),%eax
  801829:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182c:	e8 c8 fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801831:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801835:	75 0a                	jne    801841 <smalloc+0x21>
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
  80183c:	e9 a0 00 00 00       	jmp    8018e1 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801841:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801848:	76 0a                	jbe    801854 <smalloc+0x34>
		return NULL;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	e9 8d 00 00 00       	jmp    8018e1 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801854:	e8 1b 07 00 00       	call   801f74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801859:	85 c0                	test   %eax,%eax
  80185b:	74 7f                	je     8018dc <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80185d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186a:	01 d0                	add    %edx,%eax
  80186c:	48                   	dec    %eax
  80186d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801873:	ba 00 00 00 00       	mov    $0x0,%edx
  801878:	f7 75 f4             	divl   -0xc(%ebp)
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187e:	29 d0                	sub    %edx,%eax
  801880:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801883:	83 ec 0c             	sub    $0xc,%esp
  801886:	ff 75 ec             	pushl  -0x14(%ebp)
  801889:	e8 65 0c 00 00       	call   8024f3 <alloc_block_FF>
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801894:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801898:	74 42                	je     8018dc <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80189a:	83 ec 0c             	sub    $0xc,%esp
  80189d:	ff 75 e8             	pushl  -0x18(%ebp)
  8018a0:	e8 9f 0a 00 00       	call   802344 <insert_sorted_allocList>
  8018a5:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8018a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ab:	8b 40 08             	mov    0x8(%eax),%eax
  8018ae:	89 c2                	mov    %eax,%edx
  8018b0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	e8 38 04 00 00       	call   801cf9 <sys_createSharedObject>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8018c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018cb:	79 07                	jns    8018d4 <smalloc+0xb4>
	    		  return NULL;
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d2:	eb 0d                	jmp    8018e1 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8018d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d7:	8b 40 08             	mov    0x8(%eax),%eax
  8018da:	eb 05                	jmp    8018e1 <smalloc+0xc1>


				}


		return NULL;
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e9:	e8 0b fc ff ff       	call   8014f9 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018ee:	e8 81 06 00 00       	call   801f74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	0f 84 9f 00 00 00    	je     80199a <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018fb:	83 ec 08             	sub    $0x8,%esp
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 1a 04 00 00       	call   801d23 <sys_getSizeOfSharedObject>
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80190f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801913:	79 0a                	jns    80191f <sget+0x3c>
		return NULL;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
  80191a:	e9 80 00 00 00       	jmp    80199f <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80191f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	48                   	dec    %eax
  80192f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801932:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801935:	ba 00 00 00 00       	mov    $0x0,%edx
  80193a:	f7 75 f0             	divl   -0x10(%ebp)
  80193d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801940:	29 d0                	sub    %edx,%eax
  801942:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	ff 75 e8             	pushl  -0x18(%ebp)
  80194b:	e8 a3 0b 00 00       	call   8024f3 <alloc_block_FF>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80195a:	74 3e                	je     80199a <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801962:	e8 dd 09 00 00       	call   802344 <insert_sorted_allocList>
  801967:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80196a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80196d:	8b 40 08             	mov    0x8(%eax),%eax
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	50                   	push   %eax
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	e8 c1 03 00 00       	call   801d40 <sys_getSharedObject>
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801985:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801989:	79 07                	jns    801992 <sget+0xaf>
	    		  return NULL;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	eb 0d                	jmp    80199f <sget+0xbc>
	  	return(void*) returned_block->sva;
  801992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801995:	8b 40 08             	mov    0x8(%eax),%eax
  801998:	eb 05                	jmp    80199f <sget+0xbc>
	      }
	}
	   return NULL;
  80199a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019a7:	e8 4d fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 40 3e 80 00       	push   $0x803e40
  8019b4:	68 12 01 00 00       	push   $0x112
  8019b9:	68 33 3e 80 00       	push   $0x803e33
  8019be:	e8 f8 ea ff ff       	call   8004bb <_panic>

008019c3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	68 68 3e 80 00       	push   $0x803e68
  8019d1:	68 26 01 00 00       	push   $0x126
  8019d6:	68 33 3e 80 00       	push   $0x803e33
  8019db:	e8 db ea ff ff       	call   8004bb <_panic>

008019e0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	68 8c 3e 80 00       	push   $0x803e8c
  8019ee:	68 31 01 00 00       	push   $0x131
  8019f3:	68 33 3e 80 00       	push   $0x803e33
  8019f8:	e8 be ea ff ff       	call   8004bb <_panic>

008019fd <shrink>:

}
void shrink(uint32 newSize)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	68 8c 3e 80 00       	push   $0x803e8c
  801a0b:	68 36 01 00 00       	push   $0x136
  801a10:	68 33 3e 80 00       	push   $0x803e33
  801a15:	e8 a1 ea ff ff       	call   8004bb <_panic>

00801a1a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	68 8c 3e 80 00       	push   $0x803e8c
  801a28:	68 3b 01 00 00       	push   $0x13b
  801a2d:	68 33 3e 80 00       	push   $0x803e33
  801a32:	e8 84 ea ff ff       	call   8004bb <_panic>

00801a37 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	57                   	push   %edi
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
  801a3d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a49:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a4f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a52:	cd 30                	int    $0x30
  801a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5e                   	pop    %esi
  801a5f:	5f                   	pop    %edi
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    

00801a62 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a6e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 00                	push   $0x0
  801a80:	e8 b2 ff ff ff       	call   801a37 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	90                   	nop
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_cgetc>:

int
sys_cgetc(void)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 01                	push   $0x1
  801a9a:	e8 98 ff ff ff       	call   801a37 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	6a 05                	push   $0x5
  801ab7:	e8 7b ff ff ff       	call   801a37 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ac6:	8b 75 18             	mov    0x18(%ebp),%esi
  801ac9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	56                   	push   %esi
  801ad6:	53                   	push   %ebx
  801ad7:	51                   	push   %ecx
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 06                	push   $0x6
  801adc:	e8 56 ff ff ff       	call   801a37 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 07                	push   $0x7
  801afe:	e8 34 ff ff ff       	call   801a37 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	6a 08                	push   $0x8
  801b19:	e8 19 ff ff ff       	call   801a37 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 09                	push   $0x9
  801b32:	e8 00 ff ff ff       	call   801a37 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 0a                	push   $0xa
  801b4b:	e8 e7 fe ff ff       	call   801a37 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 0b                	push   $0xb
  801b64:	e8 ce fe ff ff       	call   801a37 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	ff 75 08             	pushl  0x8(%ebp)
  801b7d:	6a 0f                	push   $0xf
  801b7f:	e8 b3 fe ff ff       	call   801a37 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
	return;
  801b87:	90                   	nop
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 10                	push   $0x10
  801b9b:	e8 97 fe ff ff       	call   801a37 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 10             	pushl  0x10(%ebp)
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 11                	push   $0x11
  801bb8:	e8 7a fe ff ff       	call   801a37 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 0c                	push   $0xc
  801bd2:	e8 60 fe ff ff       	call   801a37 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	6a 0d                	push   $0xd
  801bec:	e8 46 fe ff ff       	call   801a37 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 0e                	push   $0xe
  801c05:	e8 2d fe ff ff       	call   801a37 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	90                   	nop
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 13                	push   $0x13
  801c1f:	e8 13 fe ff ff       	call   801a37 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	90                   	nop
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 14                	push   $0x14
  801c39:	e8 f9 fd ff ff       	call   801a37 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	90                   	nop
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	50                   	push   %eax
  801c5d:	6a 15                	push   $0x15
  801c5f:	e8 d3 fd ff ff       	call   801a37 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	90                   	nop
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 16                	push   $0x16
  801c79:	e8 b9 fd ff ff       	call   801a37 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	90                   	nop
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	50                   	push   %eax
  801c94:	6a 17                	push   $0x17
  801c96:	e8 9c fd ff ff       	call   801a37 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 1a                	push   $0x1a
  801cb3:	e8 7f fd ff ff       	call   801a37 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 18                	push   $0x18
  801cd0:	e8 62 fd ff ff       	call   801a37 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	90                   	nop
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	52                   	push   %edx
  801ceb:	50                   	push   %eax
  801cec:	6a 19                	push   $0x19
  801cee:	e8 44 fd ff ff       	call   801a37 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	90                   	nop
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	8b 45 10             	mov    0x10(%ebp),%eax
  801d02:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	51                   	push   %ecx
  801d12:	52                   	push   %edx
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	50                   	push   %eax
  801d17:	6a 1b                	push   $0x1b
  801d19:	e8 19 fd ff ff       	call   801a37 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 1c                	push   $0x1c
  801d36:	e8 fc fc ff ff       	call   801a37 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	51                   	push   %ecx
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 1d                	push   $0x1d
  801d55:	e8 dd fc ff ff       	call   801a37 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	52                   	push   %edx
  801d6f:	50                   	push   %eax
  801d70:	6a 1e                	push   $0x1e
  801d72:	e8 c0 fc ff ff       	call   801a37 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 1f                	push   $0x1f
  801d8b:	e8 a7 fc ff ff       	call   801a37 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	ff 75 14             	pushl  0x14(%ebp)
  801da0:	ff 75 10             	pushl  0x10(%ebp)
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	50                   	push   %eax
  801da7:	6a 20                	push   $0x20
  801da9:	e8 89 fc ff ff       	call   801a37 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	50                   	push   %eax
  801dc2:	6a 21                	push   $0x21
  801dc4:	e8 6e fc ff ff       	call   801a37 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	90                   	nop
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	50                   	push   %eax
  801dde:	6a 22                	push   $0x22
  801de0:	e8 52 fc ff ff       	call   801a37 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 02                	push   $0x2
  801df9:	e8 39 fc ff ff       	call   801a37 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 03                	push   $0x3
  801e12:	e8 20 fc ff ff       	call   801a37 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 04                	push   $0x4
  801e2b:	e8 07 fc ff ff       	call   801a37 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_exit_env>:


void sys_exit_env(void)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 23                	push   $0x23
  801e44:	e8 ee fb ff ff       	call   801a37 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	90                   	nop
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e55:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e58:	8d 50 04             	lea    0x4(%eax),%edx
  801e5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 24                	push   $0x24
  801e68:	e8 ca fb ff ff       	call   801a37 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return result;
  801e70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e79:	89 01                	mov    %eax,(%ecx)
  801e7b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	c9                   	leave  
  801e82:	c2 04 00             	ret    $0x4

00801e85 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 10             	pushl  0x10(%ebp)
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	6a 12                	push   $0x12
  801e97:	e8 9b fb ff ff       	call   801a37 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 25                	push   $0x25
  801eb1:	e8 81 fb ff ff       	call   801a37 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ec7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	50                   	push   %eax
  801ed4:	6a 26                	push   $0x26
  801ed6:	e8 5c fb ff ff       	call   801a37 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ede:	90                   	nop
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <rsttst>:
void rsttst()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 28                	push   $0x28
  801ef0:	e8 42 fb ff ff       	call   801a37 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef8:	90                   	nop
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	8b 45 14             	mov    0x14(%ebp),%eax
  801f04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f07:	8b 55 18             	mov    0x18(%ebp),%edx
  801f0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f0e:	52                   	push   %edx
  801f0f:	50                   	push   %eax
  801f10:	ff 75 10             	pushl  0x10(%ebp)
  801f13:	ff 75 0c             	pushl  0xc(%ebp)
  801f16:	ff 75 08             	pushl  0x8(%ebp)
  801f19:	6a 27                	push   $0x27
  801f1b:	e8 17 fb ff ff       	call   801a37 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
	return ;
  801f23:	90                   	nop
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <chktst>:
void chktst(uint32 n)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 29                	push   $0x29
  801f36:	e8 fc fa ff ff       	call   801a37 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <inctst>:

void inctst()
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 2a                	push   $0x2a
  801f50:	e8 e2 fa ff ff       	call   801a37 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
	return ;
  801f58:	90                   	nop
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <gettst>:
uint32 gettst()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 2b                	push   $0x2b
  801f6a:	e8 c8 fa ff ff       	call   801a37 <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 2c                	push   $0x2c
  801f86:	e8 ac fa ff ff       	call   801a37 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
  801f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f91:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f95:	75 07                	jne    801f9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f97:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9c:	eb 05                	jmp    801fa3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 2c                	push   $0x2c
  801fb7:	e8 7b fa ff ff       	call   801a37 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
  801fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fc6:	75 07                	jne    801fcf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcd:	eb 05                	jmp    801fd4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 2c                	push   $0x2c
  801fe8:	e8 4a fa ff ff       	call   801a37 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
  801ff0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ff7:	75 07                	jne    802000 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ff9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffe:	eb 05                	jmp    802005 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 2c                	push   $0x2c
  802019:	e8 19 fa ff ff       	call   801a37 <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
  802021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802024:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802028:	75 07                	jne    802031 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80202a:	b8 01 00 00 00       	mov    $0x1,%eax
  80202f:	eb 05                	jmp    802036 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	ff 75 08             	pushl  0x8(%ebp)
  802046:	6a 2d                	push   $0x2d
  802048:	e8 ea f9 ff ff       	call   801a37 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
	return ;
  802050:	90                   	nop
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802057:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	6a 00                	push   $0x0
  802065:	53                   	push   %ebx
  802066:	51                   	push   %ecx
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	6a 2e                	push   $0x2e
  80206b:	e8 c7 f9 ff ff       	call   801a37 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80207b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	6a 2f                	push   $0x2f
  80208b:	e8 a7 f9 ff ff       	call   801a37 <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	68 9c 3e 80 00       	push   $0x803e9c
  8020a3:	e8 c7 e6 ff ff       	call   80076f <cprintf>
  8020a8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020b2:	83 ec 0c             	sub    $0xc,%esp
  8020b5:	68 c8 3e 80 00       	push   $0x803ec8
  8020ba:	e8 b0 e6 ff ff       	call   80076f <cprintf>
  8020bf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020c2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8020cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ce:	eb 56                	jmp    802126 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d4:	74 1c                	je     8020f2 <print_mem_block_lists+0x5d>
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	8b 50 08             	mov    0x8(%eax),%edx
  8020dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020df:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e8:	01 c8                	add    %ecx,%eax
  8020ea:	39 c2                	cmp    %eax,%edx
  8020ec:	73 04                	jae    8020f2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020ee:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 50 08             	mov    0x8(%eax),%edx
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fe:	01 c2                	add    %eax,%edx
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	8b 40 08             	mov    0x8(%eax),%eax
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	52                   	push   %edx
  80210a:	50                   	push   %eax
  80210b:	68 dd 3e 80 00       	push   $0x803edd
  802110:	e8 5a e6 ff ff       	call   80076f <cprintf>
  802115:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80211e:	a1 40 51 80 00       	mov    0x805140,%eax
  802123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212a:	74 07                	je     802133 <print_mem_block_lists+0x9e>
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	eb 05                	jmp    802138 <print_mem_block_lists+0xa3>
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	a3 40 51 80 00       	mov    %eax,0x805140
  80213d:	a1 40 51 80 00       	mov    0x805140,%eax
  802142:	85 c0                	test   %eax,%eax
  802144:	75 8a                	jne    8020d0 <print_mem_block_lists+0x3b>
  802146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214a:	75 84                	jne    8020d0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80214c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802150:	75 10                	jne    802162 <print_mem_block_lists+0xcd>
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	68 ec 3e 80 00       	push   $0x803eec
  80215a:	e8 10 e6 ff ff       	call   80076f <cprintf>
  80215f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802162:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	68 10 3f 80 00       	push   $0x803f10
  802171:	e8 f9 e5 ff ff       	call   80076f <cprintf>
  802176:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802179:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80217d:	a1 40 50 80 00       	mov    0x805040,%eax
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802185:	eb 56                	jmp    8021dd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802187:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218b:	74 1c                	je     8021a9 <print_mem_block_lists+0x114>
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 50 08             	mov    0x8(%eax),%edx
  802193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802196:	8b 48 08             	mov    0x8(%eax),%ecx
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 40 0c             	mov    0xc(%eax),%eax
  80219f:	01 c8                	add    %ecx,%eax
  8021a1:	39 c2                	cmp    %eax,%edx
  8021a3:	73 04                	jae    8021a9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021a5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	8b 50 08             	mov    0x8(%eax),%edx
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b5:	01 c2                	add    %eax,%edx
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 40 08             	mov    0x8(%eax),%eax
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	52                   	push   %edx
  8021c1:	50                   	push   %eax
  8021c2:	68 dd 3e 80 00       	push   $0x803edd
  8021c7:	e8 a3 e5 ff ff       	call   80076f <cprintf>
  8021cc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021d5:	a1 48 50 80 00       	mov    0x805048,%eax
  8021da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e1:	74 07                	je     8021ea <print_mem_block_lists+0x155>
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	eb 05                	jmp    8021ef <print_mem_block_lists+0x15a>
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	a3 48 50 80 00       	mov    %eax,0x805048
  8021f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 8a                	jne    802187 <print_mem_block_lists+0xf2>
  8021fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802201:	75 84                	jne    802187 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802203:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802207:	75 10                	jne    802219 <print_mem_block_lists+0x184>
  802209:	83 ec 0c             	sub    $0xc,%esp
  80220c:	68 28 3f 80 00       	push   $0x803f28
  802211:	e8 59 e5 ff ff       	call   80076f <cprintf>
  802216:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	68 9c 3e 80 00       	push   $0x803e9c
  802221:	e8 49 e5 ff ff       	call   80076f <cprintf>
  802226:	83 c4 10             	add    $0x10,%esp

}
  802229:	90                   	nop
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802232:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802239:	00 00 00 
  80223c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802243:	00 00 00 
  802246:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80224d:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802250:	a1 50 50 80 00       	mov    0x805050,%eax
  802255:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80225f:	e9 9e 00 00 00       	jmp    802302 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802264:	a1 50 50 80 00       	mov    0x805050,%eax
  802269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226c:	c1 e2 04             	shl    $0x4,%edx
  80226f:	01 d0                	add    %edx,%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	75 14                	jne    802289 <initialize_MemBlocksList+0x5d>
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 50 3f 80 00       	push   $0x803f50
  80227d:	6a 48                	push   $0x48
  80227f:	68 73 3f 80 00       	push   $0x803f73
  802284:	e8 32 e2 ff ff       	call   8004bb <_panic>
  802289:	a1 50 50 80 00       	mov    0x805050,%eax
  80228e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802291:	c1 e2 04             	shl    $0x4,%edx
  802294:	01 d0                	add    %edx,%eax
  802296:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80229c:	89 10                	mov    %edx,(%eax)
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 18                	je     8022bc <initialize_MemBlocksList+0x90>
  8022a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8022a9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022af:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022b2:	c1 e1 04             	shl    $0x4,%ecx
  8022b5:	01 ca                	add    %ecx,%edx
  8022b7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ba:	eb 12                	jmp    8022ce <initialize_MemBlocksList+0xa2>
  8022bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8022c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c4:	c1 e2 04             	shl    $0x4,%edx
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8022d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d6:	c1 e2 04             	shl    $0x4,%edx
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	a3 48 51 80 00       	mov    %eax,0x805148
  8022e0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e8:	c1 e2 04             	shl    $0x4,%edx
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8022f9:	40                   	inc    %eax
  8022fa:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8022ff:	ff 45 f4             	incl   -0xc(%ebp)
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	3b 45 08             	cmp    0x8(%ebp),%eax
  802308:	0f 82 56 ff ff ff    	jb     802264 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80231f:	eb 18                	jmp    802339 <find_block+0x28>
		{
			if(tmp->sva==va)
  802321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802324:	8b 40 08             	mov    0x8(%eax),%eax
  802327:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80232a:	75 05                	jne    802331 <find_block+0x20>
			{
				return tmp;
  80232c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232f:	eb 11                	jmp    802342 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802339:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233d:	75 e2                	jne    802321 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80233f:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80234a:	a1 40 50 80 00       	mov    0x805040,%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	0f 85 83 00 00 00    	jne    8023da <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802357:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80235e:	00 00 00 
  802361:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802368:	00 00 00 
  80236b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802372:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802379:	75 14                	jne    80238f <insert_sorted_allocList+0x4b>
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	68 50 3f 80 00       	push   $0x803f50
  802383:	6a 7f                	push   $0x7f
  802385:	68 73 3f 80 00       	push   $0x803f73
  80238a:	e8 2c e1 ff ff       	call   8004bb <_panic>
  80238f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	89 10                	mov    %edx,(%eax)
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	74 0d                	je     8023b0 <insert_sorted_allocList+0x6c>
  8023a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ab:	89 50 04             	mov    %edx,0x4(%eax)
  8023ae:	eb 08                	jmp    8023b8 <insert_sorted_allocList+0x74>
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	a3 44 50 80 00       	mov    %eax,0x805044
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	a3 40 50 80 00       	mov    %eax,0x805040
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ca:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023cf:	40                   	inc    %eax
  8023d0:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023d5:	e9 16 01 00 00       	jmp    8024f0 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 50 08             	mov    0x8(%eax),%edx
  8023e0:	a1 44 50 80 00       	mov    0x805044,%eax
  8023e5:	8b 40 08             	mov    0x8(%eax),%eax
  8023e8:	39 c2                	cmp    %eax,%edx
  8023ea:	76 68                	jbe    802454 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8023ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f0:	75 17                	jne    802409 <insert_sorted_allocList+0xc5>
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 8c 3f 80 00       	push   $0x803f8c
  8023fa:	68 85 00 00 00       	push   $0x85
  8023ff:	68 73 3f 80 00       	push   $0x803f73
  802404:	e8 b2 e0 ff ff       	call   8004bb <_panic>
  802409:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	8b 40 04             	mov    0x4(%eax),%eax
  80241b:	85 c0                	test   %eax,%eax
  80241d:	74 0c                	je     80242b <insert_sorted_allocList+0xe7>
  80241f:	a1 44 50 80 00       	mov    0x805044,%eax
  802424:	8b 55 08             	mov    0x8(%ebp),%edx
  802427:	89 10                	mov    %edx,(%eax)
  802429:	eb 08                	jmp    802433 <insert_sorted_allocList+0xef>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	a3 40 50 80 00       	mov    %eax,0x805040
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	a3 44 50 80 00       	mov    %eax,0x805044
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802449:	40                   	inc    %eax
  80244a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80244f:	e9 9c 00 00 00       	jmp    8024f0 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802454:	a1 40 50 80 00       	mov    0x805040,%eax
  802459:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80245c:	e9 85 00 00 00       	jmp    8024e6 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	8b 50 08             	mov    0x8(%eax),%edx
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 40 08             	mov    0x8(%eax),%eax
  80246d:	39 c2                	cmp    %eax,%edx
  80246f:	73 6d                	jae    8024de <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	74 06                	je     80247d <insert_sorted_allocList+0x139>
  802477:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247b:	75 17                	jne    802494 <insert_sorted_allocList+0x150>
  80247d:	83 ec 04             	sub    $0x4,%esp
  802480:	68 b0 3f 80 00       	push   $0x803fb0
  802485:	68 90 00 00 00       	push   $0x90
  80248a:	68 73 3f 80 00       	push   $0x803f73
  80248f:	e8 27 e0 ff ff       	call   8004bb <_panic>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 50 04             	mov    0x4(%eax),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	89 50 04             	mov    %edx,0x4(%eax)
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	89 10                	mov    %edx,(%eax)
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 0d                	je     8024bf <insert_sorted_allocList+0x17b>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bb:	89 10                	mov    %edx,(%eax)
  8024bd:	eb 08                	jmp    8024c7 <insert_sorted_allocList+0x183>
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cd:	89 50 04             	mov    %edx,0x4(%eax)
  8024d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d5:	40                   	inc    %eax
  8024d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024db:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024dc:	eb 12                	jmp    8024f0 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8024e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ea:	0f 85 71 ff ff ff    	jne    802461 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8024f0:	90                   	nop
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8024fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802501:	e9 76 01 00 00       	jmp    80267c <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 0c             	mov    0xc(%eax),%eax
  80250c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250f:	0f 85 8a 00 00 00    	jne    80259f <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802519:	75 17                	jne    802532 <alloc_block_FF+0x3f>
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	68 e5 3f 80 00       	push   $0x803fe5
  802523:	68 a8 00 00 00       	push   $0xa8
  802528:	68 73 3f 80 00       	push   $0x803f73
  80252d:	e8 89 df ff ff       	call   8004bb <_panic>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 10                	je     80254b <alloc_block_FF+0x58>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802543:	8b 52 04             	mov    0x4(%edx),%edx
  802546:	89 50 04             	mov    %edx,0x4(%eax)
  802549:	eb 0b                	jmp    802556 <alloc_block_FF+0x63>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	74 0f                	je     80256f <alloc_block_FF+0x7c>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802569:	8b 12                	mov    (%edx),%edx
  80256b:	89 10                	mov    %edx,(%eax)
  80256d:	eb 0a                	jmp    802579 <alloc_block_FF+0x86>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	a3 38 51 80 00       	mov    %eax,0x805138
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258c:	a1 44 51 80 00       	mov    0x805144,%eax
  802591:	48                   	dec    %eax
  802592:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	e9 ea 00 00 00       	jmp    802689 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a8:	0f 86 c6 00 00 00    	jbe    802674 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8025b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bc:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 50 08             	mov    0x8(%eax),%edx
  8025c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c8:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d4:	89 c2                	mov    %eax,%edx
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 50 08             	mov    0x8(%eax),%edx
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	01 c2                	add    %eax,%edx
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f1:	75 17                	jne    80260a <alloc_block_FF+0x117>
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 e5 3f 80 00       	push   $0x803fe5
  8025fb:	68 b6 00 00 00       	push   $0xb6
  802600:	68 73 3f 80 00       	push   $0x803f73
  802605:	e8 b1 de ff ff       	call   8004bb <_panic>
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 10                	je     802623 <alloc_block_FF+0x130>
  802613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80261b:	8b 52 04             	mov    0x4(%edx),%edx
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
  802621:	eb 0b                	jmp    80262e <alloc_block_FF+0x13b>
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 0f                	je     802647 <alloc_block_FF+0x154>
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802641:	8b 12                	mov    (%edx),%edx
  802643:	89 10                	mov    %edx,(%eax)
  802645:	eb 0a                	jmp    802651 <alloc_block_FF+0x15e>
  802647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	a3 48 51 80 00       	mov    %eax,0x805148
  802651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802664:	a1 54 51 80 00       	mov    0x805154,%eax
  802669:	48                   	dec    %eax
  80266a:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	eb 15                	jmp    802689 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	0f 85 80 fe ff ff    	jne    802506 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802691:	a1 38 51 80 00       	mov    0x805138,%eax
  802696:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802699:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8026a0:	e9 c0 00 00 00       	jmp    802765 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ae:	0f 85 8a 00 00 00    	jne    80273e <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	75 17                	jne    8026d1 <alloc_block_BF+0x46>
  8026ba:	83 ec 04             	sub    $0x4,%esp
  8026bd:	68 e5 3f 80 00       	push   $0x803fe5
  8026c2:	68 cf 00 00 00       	push   $0xcf
  8026c7:	68 73 3f 80 00       	push   $0x803f73
  8026cc:	e8 ea dd ff ff       	call   8004bb <_panic>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	74 10                	je     8026ea <alloc_block_BF+0x5f>
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 00                	mov    (%eax),%eax
  8026df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e2:	8b 52 04             	mov    0x4(%edx),%edx
  8026e5:	89 50 04             	mov    %edx,0x4(%eax)
  8026e8:	eb 0b                	jmp    8026f5 <alloc_block_BF+0x6a>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 0f                	je     80270e <alloc_block_BF+0x83>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	8b 12                	mov    (%edx),%edx
  80270a:	89 10                	mov    %edx,(%eax)
  80270c:	eb 0a                	jmp    802718 <alloc_block_BF+0x8d>
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	a3 38 51 80 00       	mov    %eax,0x805138
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272b:	a1 44 51 80 00       	mov    0x805144,%eax
  802730:	48                   	dec    %eax
  802731:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	e9 2a 01 00 00       	jmp    802868 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 40 0c             	mov    0xc(%eax),%eax
  802744:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802747:	73 14                	jae    80275d <alloc_block_BF+0xd2>
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 40 0c             	mov    0xc(%eax),%eax
  80274f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802752:	76 09                	jbe    80275d <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 40 0c             	mov    0xc(%eax),%eax
  80275a:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802765:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802769:	0f 85 36 ff ff ff    	jne    8026a5 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80276f:	a1 38 51 80 00       	mov    0x805138,%eax
  802774:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802777:	e9 dd 00 00 00       	jmp    802859 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 40 0c             	mov    0xc(%eax),%eax
  802782:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802785:	0f 85 c6 00 00 00    	jne    802851 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80278b:	a1 48 51 80 00       	mov    0x805148,%eax
  802790:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 50 08             	mov    0x8(%eax),%edx
  802799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279c:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80279f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a5:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 50 08             	mov    0x8(%eax),%edx
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	01 c2                	add    %eax,%edx
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c2:	89 c2                	mov    %eax,%edx
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ce:	75 17                	jne    8027e7 <alloc_block_BF+0x15c>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 e5 3f 80 00       	push   $0x803fe5
  8027d8:	68 eb 00 00 00       	push   $0xeb
  8027dd:	68 73 3f 80 00       	push   $0x803f73
  8027e2:	e8 d4 dc ff ff       	call   8004bb <_panic>
  8027e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 10                	je     802800 <alloc_block_BF+0x175>
  8027f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027f8:	8b 52 04             	mov    0x4(%edx),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%eax)
  8027fe:	eb 0b                	jmp    80280b <alloc_block_BF+0x180>
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	74 0f                	je     802824 <alloc_block_BF+0x199>
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80281e:	8b 12                	mov    (%edx),%edx
  802820:	89 10                	mov    %edx,(%eax)
  802822:	eb 0a                	jmp    80282e <alloc_block_BF+0x1a3>
  802824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	a3 48 51 80 00       	mov    %eax,0x805148
  80282e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802841:	a1 54 51 80 00       	mov    0x805154,%eax
  802846:	48                   	dec    %eax
  802847:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	eb 17                	jmp    802868 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285d:	0f 85 19 ff ff ff    	jne    80277c <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802870:	a1 40 50 80 00       	mov    0x805040,%eax
  802875:	85 c0                	test   %eax,%eax
  802877:	75 19                	jne    802892 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802879:	83 ec 0c             	sub    $0xc,%esp
  80287c:	ff 75 08             	pushl  0x8(%ebp)
  80287f:	e8 6f fc ff ff       	call   8024f3 <alloc_block_FF>
  802884:	83 c4 10             	add    $0x10,%esp
  802887:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	e9 e9 01 00 00       	jmp    802a7b <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802892:	a1 44 50 80 00       	mov    0x805044,%eax
  802897:	8b 40 08             	mov    0x8(%eax),%eax
  80289a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80289d:	a1 44 50 80 00       	mov    0x805044,%eax
  8028a2:	8b 50 0c             	mov    0xc(%eax),%edx
  8028a5:	a1 44 50 80 00       	mov    0x805044,%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	83 ec 08             	sub    $0x8,%esp
  8028b2:	50                   	push   %eax
  8028b3:	68 38 51 80 00       	push   $0x805138
  8028b8:	e8 54 fa ff ff       	call   802311 <find_block>
  8028bd:	83 c4 10             	add    $0x10,%esp
  8028c0:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028cc:	0f 85 9b 00 00 00    	jne    80296d <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 08             	mov    0x8(%eax),%eax
  8028de:	01 d0                	add    %edx,%eax
  8028e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8028e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e7:	75 17                	jne    802900 <alloc_block_NF+0x96>
  8028e9:	83 ec 04             	sub    $0x4,%esp
  8028ec:	68 e5 3f 80 00       	push   $0x803fe5
  8028f1:	68 1a 01 00 00       	push   $0x11a
  8028f6:	68 73 3f 80 00       	push   $0x803f73
  8028fb:	e8 bb db ff ff       	call   8004bb <_panic>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 10                	je     802919 <alloc_block_NF+0xaf>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802911:	8b 52 04             	mov    0x4(%edx),%edx
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	eb 0b                	jmp    802924 <alloc_block_NF+0xba>
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 0f                	je     80293d <alloc_block_NF+0xd3>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802937:	8b 12                	mov    (%edx),%edx
  802939:	89 10                	mov    %edx,(%eax)
  80293b:	eb 0a                	jmp    802947 <alloc_block_NF+0xdd>
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	a3 38 51 80 00       	mov    %eax,0x805138
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295a:	a1 44 51 80 00       	mov    0x805144,%eax
  80295f:	48                   	dec    %eax
  802960:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	e9 0e 01 00 00       	jmp    802a7b <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	3b 45 08             	cmp    0x8(%ebp),%eax
  802976:	0f 86 cf 00 00 00    	jbe    802a4b <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80297c:	a1 48 51 80 00       	mov    0x805148,%eax
  802981:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	8b 55 08             	mov    0x8(%ebp),%edx
  80298a:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 50 08             	mov    0x8(%eax),%edx
  802993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802996:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 50 08             	mov    0x8(%eax),%edx
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	01 c2                	add    %eax,%edx
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b0:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b3:	89 c2                	mov    %eax,%edx
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 08             	mov    0x8(%eax),%eax
  8029c1:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8029c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c8:	75 17                	jne    8029e1 <alloc_block_NF+0x177>
  8029ca:	83 ec 04             	sub    $0x4,%esp
  8029cd:	68 e5 3f 80 00       	push   $0x803fe5
  8029d2:	68 28 01 00 00       	push   $0x128
  8029d7:	68 73 3f 80 00       	push   $0x803f73
  8029dc:	e8 da da ff ff       	call   8004bb <_panic>
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 10                	je     8029fa <alloc_block_NF+0x190>
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f2:	8b 52 04             	mov    0x4(%edx),%edx
  8029f5:	89 50 04             	mov    %edx,0x4(%eax)
  8029f8:	eb 0b                	jmp    802a05 <alloc_block_NF+0x19b>
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	8b 40 04             	mov    0x4(%eax),%eax
  802a00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	8b 40 04             	mov    0x4(%eax),%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	74 0f                	je     802a1e <alloc_block_NF+0x1b4>
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	8b 40 04             	mov    0x4(%eax),%eax
  802a15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a18:	8b 12                	mov    (%edx),%edx
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	eb 0a                	jmp    802a28 <alloc_block_NF+0x1be>
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	a3 48 51 80 00       	mov    %eax,0x805148
  802a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a40:	48                   	dec    %eax
  802a41:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a49:	eb 30                	jmp    802a7b <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802a4b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a53:	75 0a                	jne    802a5f <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802a55:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	eb 08                	jmp    802a67 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 08             	mov    0x8(%eax),%eax
  802a6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a70:	0f 85 4d fe ff ff    	jne    8028c3 <alloc_block_NF+0x59>

			return NULL;
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802a7b:	c9                   	leave  
  802a7c:	c3                   	ret    

00802a7d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a7d:	55                   	push   %ebp
  802a7e:	89 e5                	mov    %esp,%ebp
  802a80:	53                   	push   %ebx
  802a81:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802a84:	a1 38 51 80 00       	mov    0x805138,%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	0f 85 86 00 00 00    	jne    802b17 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802a91:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802a98:	00 00 00 
  802a9b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802aa2:	00 00 00 
  802aa5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802aac:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802aaf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab3:	75 17                	jne    802acc <insert_sorted_with_merge_freeList+0x4f>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 50 3f 80 00       	push   $0x803f50
  802abd:	68 48 01 00 00       	push   $0x148
  802ac2:	68 73 3f 80 00       	push   $0x803f73
  802ac7:	e8 ef d9 ff ff       	call   8004bb <_panic>
  802acc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 0d                	je     802aed <insert_sorted_with_merge_freeList+0x70>
  802ae0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	eb 08                	jmp    802af5 <insert_sorted_with_merge_freeList+0x78>
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	a3 38 51 80 00       	mov    %eax,0x805138
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b07:	a1 44 51 80 00       	mov    0x805144,%eax
  802b0c:	40                   	inc    %eax
  802b0d:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802b12:	e9 73 07 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	8b 50 08             	mov    0x8(%eax),%edx
  802b1d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b22:	8b 40 08             	mov    0x8(%eax),%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	0f 86 84 00 00 00    	jbe    802bb1 <insert_sorted_with_merge_freeList+0x134>
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 50 08             	mov    0x8(%eax),%edx
  802b33:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b38:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b3b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b40:	8b 40 08             	mov    0x8(%eax),%eax
  802b43:	01 c8                	add    %ecx,%eax
  802b45:	39 c2                	cmp    %eax,%edx
  802b47:	74 68                	je     802bb1 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4d:	75 17                	jne    802b66 <insert_sorted_with_merge_freeList+0xe9>
  802b4f:	83 ec 04             	sub    $0x4,%esp
  802b52:	68 8c 3f 80 00       	push   $0x803f8c
  802b57:	68 4c 01 00 00       	push   $0x14c
  802b5c:	68 73 3f 80 00       	push   $0x803f73
  802b61:	e8 55 d9 ff ff       	call   8004bb <_panic>
  802b66:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	89 50 04             	mov    %edx,0x4(%eax)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	74 0c                	je     802b88 <insert_sorted_with_merge_freeList+0x10b>
  802b7c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b81:	8b 55 08             	mov    0x8(%ebp),%edx
  802b84:	89 10                	mov    %edx,(%eax)
  802b86:	eb 08                	jmp    802b90 <insert_sorted_with_merge_freeList+0x113>
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	a3 38 51 80 00       	mov    %eax,0x805138
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba6:	40                   	inc    %eax
  802ba7:	a3 44 51 80 00       	mov    %eax,0x805144
  802bac:	e9 d9 06 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	8b 50 08             	mov    0x8(%eax),%edx
  802bb7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bbc:	8b 40 08             	mov    0x8(%eax),%eax
  802bbf:	39 c2                	cmp    %eax,%edx
  802bc1:	0f 86 b5 00 00 00    	jbe    802c7c <insert_sorted_with_merge_freeList+0x1ff>
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 50 08             	mov    0x8(%eax),%edx
  802bcd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bd2:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bd5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
  802bdd:	01 c8                	add    %ecx,%eax
  802bdf:	39 c2                	cmp    %eax,%edx
  802be1:	0f 85 95 00 00 00    	jne    802c7c <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802be7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bec:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802bf2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf8:	8b 52 0c             	mov    0xc(%edx),%edx
  802bfb:	01 ca                	add    %ecx,%edx
  802bfd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c18:	75 17                	jne    802c31 <insert_sorted_with_merge_freeList+0x1b4>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 50 3f 80 00       	push   $0x803f50
  802c22:	68 54 01 00 00       	push   $0x154
  802c27:	68 73 3f 80 00       	push   $0x803f73
  802c2c:	e8 8a d8 ff ff       	call   8004bb <_panic>
  802c31:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0d                	je     802c52 <insert_sorted_with_merge_freeList+0x1d5>
  802c45:	a1 48 51 80 00       	mov    0x805148,%eax
  802c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	eb 08                	jmp    802c5a <insert_sorted_with_merge_freeList+0x1dd>
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c71:	40                   	inc    %eax
  802c72:	a3 54 51 80 00       	mov    %eax,0x805154
  802c77:	e9 0e 06 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 50 08             	mov    0x8(%eax),%edx
  802c82:	a1 38 51 80 00       	mov    0x805138,%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
  802c8a:	39 c2                	cmp    %eax,%edx
  802c8c:	0f 83 c1 00 00 00    	jae    802d53 <insert_sorted_with_merge_freeList+0x2d6>
  802c92:	a1 38 51 80 00       	mov    0x805138,%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	8b 48 08             	mov    0x8(%eax),%ecx
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	01 c8                	add    %ecx,%eax
  802ca8:	39 c2                	cmp    %eax,%edx
  802caa:	0f 85 a3 00 00 00    	jne    802d53 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cb0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb8:	8b 52 08             	mov    0x8(%edx),%edx
  802cbb:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802cbe:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cc9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccf:	8b 52 0c             	mov    0xc(%edx),%edx
  802cd2:	01 ca                	add    %ecx,%edx
  802cd4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 17                	jne    802d08 <insert_sorted_with_merge_freeList+0x28b>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 50 3f 80 00       	push   $0x803f50
  802cf9:	68 5d 01 00 00       	push   $0x15d
  802cfe:	68 73 3f 80 00       	push   $0x803f73
  802d03:	e8 b3 d7 ff ff       	call   8004bb <_panic>
  802d08:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <insert_sorted_with_merge_freeList+0x2ac>
  802d1c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d21:	8b 55 08             	mov    0x8(%ebp),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 08                	jmp    802d31 <insert_sorted_with_merge_freeList+0x2b4>
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 48 51 80 00       	mov    %eax,0x805148
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d43:	a1 54 51 80 00       	mov    0x805154,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 54 51 80 00       	mov    %eax,0x805154
  802d4e:	e9 37 05 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5e:	8b 40 08             	mov    0x8(%eax),%eax
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	0f 83 82 00 00 00    	jae    802deb <insert_sorted_with_merge_freeList+0x36e>
  802d69:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6e:	8b 50 08             	mov    0x8(%eax),%edx
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 48 08             	mov    0x8(%eax),%ecx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	01 c8                	add    %ecx,%eax
  802d7f:	39 c2                	cmp    %eax,%edx
  802d81:	74 68                	je     802deb <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d87:	75 17                	jne    802da0 <insert_sorted_with_merge_freeList+0x323>
  802d89:	83 ec 04             	sub    $0x4,%esp
  802d8c:	68 50 3f 80 00       	push   $0x803f50
  802d91:	68 62 01 00 00       	push   $0x162
  802d96:	68 73 3f 80 00       	push   $0x803f73
  802d9b:	e8 1b d7 ff ff       	call   8004bb <_panic>
  802da0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	89 10                	mov    %edx,(%eax)
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 0d                	je     802dc1 <insert_sorted_with_merge_freeList+0x344>
  802db4:	a1 38 51 80 00       	mov    0x805138,%eax
  802db9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbc:	89 50 04             	mov    %edx,0x4(%eax)
  802dbf:	eb 08                	jmp    802dc9 <insert_sorted_with_merge_freeList+0x34c>
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddb:	a1 44 51 80 00       	mov    0x805144,%eax
  802de0:	40                   	inc    %eax
  802de1:	a3 44 51 80 00       	mov    %eax,0x805144
  802de6:	e9 9f 04 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802deb:	a1 38 51 80 00       	mov    0x805138,%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802df5:	e9 84 04 00 00       	jmp    80327e <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 50 08             	mov    0x8(%eax),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 40 08             	mov    0x8(%eax),%eax
  802e06:	39 c2                	cmp    %eax,%edx
  802e08:	0f 86 a9 00 00 00    	jbe    802eb7 <insert_sorted_with_merge_freeList+0x43a>
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 50 08             	mov    0x8(%eax),%edx
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 48 08             	mov    0x8(%eax),%ecx
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e20:	01 c8                	add    %ecx,%eax
  802e22:	39 c2                	cmp    %eax,%edx
  802e24:	0f 84 8d 00 00 00    	je     802eb7 <insert_sorted_with_merge_freeList+0x43a>
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 50 08             	mov    0x8(%eax),%edx
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	8b 48 08             	mov    0x8(%eax),%ecx
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e42:	01 c8                	add    %ecx,%eax
  802e44:	39 c2                	cmp    %eax,%edx
  802e46:	74 6f                	je     802eb7 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	74 06                	je     802e54 <insert_sorted_with_merge_freeList+0x3d7>
  802e4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e52:	75 17                	jne    802e6b <insert_sorted_with_merge_freeList+0x3ee>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 b0 3f 80 00       	push   $0x803fb0
  802e5c:	68 6b 01 00 00       	push   $0x16b
  802e61:	68 73 3f 80 00       	push   $0x803f73
  802e66:	e8 50 d6 ff ff       	call   8004bb <_panic>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 04             	mov    0x4(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	89 50 04             	mov    %edx,0x4(%eax)
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0d                	je     802e96 <insert_sorted_with_merge_freeList+0x419>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	eb 08                	jmp    802e9e <insert_sorted_with_merge_freeList+0x421>
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	a3 38 51 80 00       	mov    %eax,0x805138
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	a1 44 51 80 00       	mov    0x805144,%eax
  802eac:	40                   	inc    %eax
  802ead:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  802eb2:	e9 d3 03 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 08             	mov    0x8(%eax),%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	0f 86 da 00 00 00    	jbe    802fa5 <insert_sorted_with_merge_freeList+0x528>
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 50 08             	mov    0x8(%eax),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 48 08             	mov    0x8(%eax),%ecx
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	01 c8                	add    %ecx,%eax
  802edf:	39 c2                	cmp    %eax,%edx
  802ee1:	0f 85 be 00 00 00    	jne    802fa5 <insert_sorted_with_merge_freeList+0x528>
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 50 08             	mov    0x8(%eax),%edx
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 40 04             	mov    0x4(%eax),%eax
  802efc:	8b 40 0c             	mov    0xc(%eax),%eax
  802eff:	01 c8                	add    %ecx,%eax
  802f01:	39 c2                	cmp    %eax,%edx
  802f03:	0f 84 9c 00 00 00    	je     802fa5 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 50 08             	mov    0x8(%eax),%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	01 c2                	add    %eax,%edx
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f41:	75 17                	jne    802f5a <insert_sorted_with_merge_freeList+0x4dd>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 50 3f 80 00       	push   $0x803f50
  802f4b:	68 74 01 00 00       	push   $0x174
  802f50:	68 73 3f 80 00       	push   $0x803f73
  802f55:	e8 61 d5 ff ff       	call   8004bb <_panic>
  802f5a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0d                	je     802f7b <insert_sorted_with_merge_freeList+0x4fe>
  802f6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f73:	8b 55 08             	mov    0x8(%ebp),%edx
  802f76:	89 50 04             	mov    %edx,0x4(%eax)
  802f79:	eb 08                	jmp    802f83 <insert_sorted_with_merge_freeList+0x506>
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	a3 48 51 80 00       	mov    %eax,0x805148
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f95:	a1 54 51 80 00       	mov    0x805154,%eax
  802f9a:	40                   	inc    %eax
  802f9b:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  802fa0:	e9 e5 02 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 50 08             	mov    0x8(%eax),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 40 08             	mov    0x8(%eax),%eax
  802fb1:	39 c2                	cmp    %eax,%edx
  802fb3:	0f 86 d7 00 00 00    	jbe    803090 <insert_sorted_with_merge_freeList+0x613>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 50 08             	mov    0x8(%eax),%edx
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	8b 48 08             	mov    0x8(%eax),%ecx
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcb:	01 c8                	add    %ecx,%eax
  802fcd:	39 c2                	cmp    %eax,%edx
  802fcf:	0f 84 bb 00 00 00    	je     803090 <insert_sorted_with_merge_freeList+0x613>
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 50 08             	mov    0x8(%eax),%edx
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	8b 48 08             	mov    0x8(%eax),%ecx
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	8b 40 0c             	mov    0xc(%eax),%eax
  802fed:	01 c8                	add    %ecx,%eax
  802fef:	39 c2                	cmp    %eax,%edx
  802ff1:	0f 85 99 00 00 00    	jne    803090 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	8b 50 0c             	mov    0xc(%eax),%edx
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	8b 40 0c             	mov    0xc(%eax),%eax
  80300c:	01 c2                	add    %eax,%edx
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803028:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302c:	75 17                	jne    803045 <insert_sorted_with_merge_freeList+0x5c8>
  80302e:	83 ec 04             	sub    $0x4,%esp
  803031:	68 50 3f 80 00       	push   $0x803f50
  803036:	68 7d 01 00 00       	push   $0x17d
  80303b:	68 73 3f 80 00       	push   $0x803f73
  803040:	e8 76 d4 ff ff       	call   8004bb <_panic>
  803045:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	89 10                	mov    %edx,(%eax)
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	74 0d                	je     803066 <insert_sorted_with_merge_freeList+0x5e9>
  803059:	a1 48 51 80 00       	mov    0x805148,%eax
  80305e:	8b 55 08             	mov    0x8(%ebp),%edx
  803061:	89 50 04             	mov    %edx,0x4(%eax)
  803064:	eb 08                	jmp    80306e <insert_sorted_with_merge_freeList+0x5f1>
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	a3 48 51 80 00       	mov    %eax,0x805148
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803080:	a1 54 51 80 00       	mov    0x805154,%eax
  803085:	40                   	inc    %eax
  803086:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80308b:	e9 fa 01 00 00       	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	8b 50 08             	mov    0x8(%eax),%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 40 08             	mov    0x8(%eax),%eax
  80309c:	39 c2                	cmp    %eax,%edx
  80309e:	0f 86 d2 01 00 00    	jbe    803276 <insert_sorted_with_merge_freeList+0x7f9>
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 50 08             	mov    0x8(%eax),%edx
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	8b 48 08             	mov    0x8(%eax),%ecx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b6:	01 c8                	add    %ecx,%eax
  8030b8:	39 c2                	cmp    %eax,%edx
  8030ba:	0f 85 b6 01 00 00    	jne    803276 <insert_sorted_with_merge_freeList+0x7f9>
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 50 08             	mov    0x8(%eax),%edx
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	8b 48 08             	mov    0x8(%eax),%ecx
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 40 04             	mov    0x4(%eax),%eax
  8030d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d8:	01 c8                	add    %ecx,%eax
  8030da:	39 c2                	cmp    %eax,%edx
  8030dc:	0f 85 94 01 00 00    	jne    803276 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 40 04             	mov    0x4(%eax),%eax
  8030e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030eb:	8b 52 04             	mov    0x4(%edx),%edx
  8030ee:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f4:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8030f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8030fd:	01 da                	add    %ebx,%edx
  8030ff:	01 ca                	add    %ecx,%edx
  803101:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311c:	75 17                	jne    803135 <insert_sorted_with_merge_freeList+0x6b8>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 e5 3f 80 00       	push   $0x803fe5
  803126:	68 86 01 00 00       	push   $0x186
  80312b:	68 73 3f 80 00       	push   $0x803f73
  803130:	e8 86 d3 ff ff       	call   8004bb <_panic>
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 10                	je     80314e <insert_sorted_with_merge_freeList+0x6d1>
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803146:	8b 52 04             	mov    0x4(%edx),%edx
  803149:	89 50 04             	mov    %edx,0x4(%eax)
  80314c:	eb 0b                	jmp    803159 <insert_sorted_with_merge_freeList+0x6dc>
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 0f                	je     803172 <insert_sorted_with_merge_freeList+0x6f5>
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80316c:	8b 12                	mov    (%edx),%edx
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	eb 0a                	jmp    80317c <insert_sorted_with_merge_freeList+0x6ff>
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	a3 38 51 80 00       	mov    %eax,0x805138
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318f:	a1 44 51 80 00       	mov    0x805144,%eax
  803194:	48                   	dec    %eax
  803195:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80319a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0x73a>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 50 3f 80 00       	push   $0x803f50
  8031a8:	68 87 01 00 00       	push   $0x187
  8031ad:	68 73 3f 80 00       	push   $0x803f73
  8031b2:	e8 04 d3 ff ff       	call   8004bb <_panic>
  8031b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 0d                	je     8031d8 <insert_sorted_with_merge_freeList+0x75b>
  8031cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d3:	89 50 04             	mov    %edx,0x4(%eax)
  8031d6:	eb 08                	jmp    8031e0 <insert_sorted_with_merge_freeList+0x763>
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f7:	40                   	inc    %eax
  8031f8:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803211:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803215:	75 17                	jne    80322e <insert_sorted_with_merge_freeList+0x7b1>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 50 3f 80 00       	push   $0x803f50
  80321f:	68 8a 01 00 00       	push   $0x18a
  803224:	68 73 3f 80 00       	push   $0x803f73
  803229:	e8 8d d2 ff ff       	call   8004bb <_panic>
  80322e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	89 10                	mov    %edx,(%eax)
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 0d                	je     80324f <insert_sorted_with_merge_freeList+0x7d2>
  803242:	a1 48 51 80 00       	mov    0x805148,%eax
  803247:	8b 55 08             	mov    0x8(%ebp),%edx
  80324a:	89 50 04             	mov    %edx,0x4(%eax)
  80324d:	eb 08                	jmp    803257 <insert_sorted_with_merge_freeList+0x7da>
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	a3 48 51 80 00       	mov    %eax,0x805148
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803269:	a1 54 51 80 00       	mov    0x805154,%eax
  80326e:	40                   	inc    %eax
  80326f:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803274:	eb 14                	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80327e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803282:	0f 85 72 fb ff ff    	jne    802dfa <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803288:	eb 00                	jmp    80328a <insert_sorted_with_merge_freeList+0x80d>
  80328a:	90                   	nop
  80328b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80328e:	c9                   	leave  
  80328f:	c3                   	ret    

00803290 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803290:	55                   	push   %ebp
  803291:	89 e5                	mov    %esp,%ebp
  803293:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	89 d0                	mov    %edx,%eax
  80329b:	c1 e0 02             	shl    $0x2,%eax
  80329e:	01 d0                	add    %edx,%eax
  8032a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032a7:	01 d0                	add    %edx,%eax
  8032a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032b0:	01 d0                	add    %edx,%eax
  8032b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032b9:	01 d0                	add    %edx,%eax
  8032bb:	c1 e0 04             	shl    $0x4,%eax
  8032be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032c8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032cb:	83 ec 0c             	sub    $0xc,%esp
  8032ce:	50                   	push   %eax
  8032cf:	e8 7b eb ff ff       	call   801e4f <sys_get_virtual_time>
  8032d4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032d7:	eb 41                	jmp    80331a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032dc:	83 ec 0c             	sub    $0xc,%esp
  8032df:	50                   	push   %eax
  8032e0:	e8 6a eb ff ff       	call   801e4f <sys_get_virtual_time>
  8032e5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ee:	29 c2                	sub    %eax,%edx
  8032f0:	89 d0                	mov    %edx,%eax
  8032f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fb:	89 d1                	mov    %edx,%ecx
  8032fd:	29 c1                	sub    %eax,%ecx
  8032ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803302:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803305:	39 c2                	cmp    %eax,%edx
  803307:	0f 97 c0             	seta   %al
  80330a:	0f b6 c0             	movzbl %al,%eax
  80330d:	29 c1                	sub    %eax,%ecx
  80330f:	89 c8                	mov    %ecx,%eax
  803311:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803317:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803320:	72 b7                	jb     8032d9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803322:	90                   	nop
  803323:	c9                   	leave  
  803324:	c3                   	ret    

00803325 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803325:	55                   	push   %ebp
  803326:	89 e5                	mov    %esp,%ebp
  803328:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80332b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803332:	eb 03                	jmp    803337 <busy_wait+0x12>
  803334:	ff 45 fc             	incl   -0x4(%ebp)
  803337:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80333a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80333d:	72 f5                	jb     803334 <busy_wait+0xf>
	return i;
  80333f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803342:	c9                   	leave  
  803343:	c3                   	ret    

00803344 <__udivdi3>:
  803344:	55                   	push   %ebp
  803345:	57                   	push   %edi
  803346:	56                   	push   %esi
  803347:	53                   	push   %ebx
  803348:	83 ec 1c             	sub    $0x1c,%esp
  80334b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80334f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803353:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803357:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80335b:	89 ca                	mov    %ecx,%edx
  80335d:	89 f8                	mov    %edi,%eax
  80335f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803363:	85 f6                	test   %esi,%esi
  803365:	75 2d                	jne    803394 <__udivdi3+0x50>
  803367:	39 cf                	cmp    %ecx,%edi
  803369:	77 65                	ja     8033d0 <__udivdi3+0x8c>
  80336b:	89 fd                	mov    %edi,%ebp
  80336d:	85 ff                	test   %edi,%edi
  80336f:	75 0b                	jne    80337c <__udivdi3+0x38>
  803371:	b8 01 00 00 00       	mov    $0x1,%eax
  803376:	31 d2                	xor    %edx,%edx
  803378:	f7 f7                	div    %edi
  80337a:	89 c5                	mov    %eax,%ebp
  80337c:	31 d2                	xor    %edx,%edx
  80337e:	89 c8                	mov    %ecx,%eax
  803380:	f7 f5                	div    %ebp
  803382:	89 c1                	mov    %eax,%ecx
  803384:	89 d8                	mov    %ebx,%eax
  803386:	f7 f5                	div    %ebp
  803388:	89 cf                	mov    %ecx,%edi
  80338a:	89 fa                	mov    %edi,%edx
  80338c:	83 c4 1c             	add    $0x1c,%esp
  80338f:	5b                   	pop    %ebx
  803390:	5e                   	pop    %esi
  803391:	5f                   	pop    %edi
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    
  803394:	39 ce                	cmp    %ecx,%esi
  803396:	77 28                	ja     8033c0 <__udivdi3+0x7c>
  803398:	0f bd fe             	bsr    %esi,%edi
  80339b:	83 f7 1f             	xor    $0x1f,%edi
  80339e:	75 40                	jne    8033e0 <__udivdi3+0x9c>
  8033a0:	39 ce                	cmp    %ecx,%esi
  8033a2:	72 0a                	jb     8033ae <__udivdi3+0x6a>
  8033a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033a8:	0f 87 9e 00 00 00    	ja     80344c <__udivdi3+0x108>
  8033ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b3:	89 fa                	mov    %edi,%edx
  8033b5:	83 c4 1c             	add    $0x1c,%esp
  8033b8:	5b                   	pop    %ebx
  8033b9:	5e                   	pop    %esi
  8033ba:	5f                   	pop    %edi
  8033bb:	5d                   	pop    %ebp
  8033bc:	c3                   	ret    
  8033bd:	8d 76 00             	lea    0x0(%esi),%esi
  8033c0:	31 ff                	xor    %edi,%edi
  8033c2:	31 c0                	xor    %eax,%eax
  8033c4:	89 fa                	mov    %edi,%edx
  8033c6:	83 c4 1c             	add    $0x1c,%esp
  8033c9:	5b                   	pop    %ebx
  8033ca:	5e                   	pop    %esi
  8033cb:	5f                   	pop    %edi
  8033cc:	5d                   	pop    %ebp
  8033cd:	c3                   	ret    
  8033ce:	66 90                	xchg   %ax,%ax
  8033d0:	89 d8                	mov    %ebx,%eax
  8033d2:	f7 f7                	div    %edi
  8033d4:	31 ff                	xor    %edi,%edi
  8033d6:	89 fa                	mov    %edi,%edx
  8033d8:	83 c4 1c             	add    $0x1c,%esp
  8033db:	5b                   	pop    %ebx
  8033dc:	5e                   	pop    %esi
  8033dd:	5f                   	pop    %edi
  8033de:	5d                   	pop    %ebp
  8033df:	c3                   	ret    
  8033e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033e5:	89 eb                	mov    %ebp,%ebx
  8033e7:	29 fb                	sub    %edi,%ebx
  8033e9:	89 f9                	mov    %edi,%ecx
  8033eb:	d3 e6                	shl    %cl,%esi
  8033ed:	89 c5                	mov    %eax,%ebp
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 ed                	shr    %cl,%ebp
  8033f3:	89 e9                	mov    %ebp,%ecx
  8033f5:	09 f1                	or     %esi,%ecx
  8033f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033fb:	89 f9                	mov    %edi,%ecx
  8033fd:	d3 e0                	shl    %cl,%eax
  8033ff:	89 c5                	mov    %eax,%ebp
  803401:	89 d6                	mov    %edx,%esi
  803403:	88 d9                	mov    %bl,%cl
  803405:	d3 ee                	shr    %cl,%esi
  803407:	89 f9                	mov    %edi,%ecx
  803409:	d3 e2                	shl    %cl,%edx
  80340b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80340f:	88 d9                	mov    %bl,%cl
  803411:	d3 e8                	shr    %cl,%eax
  803413:	09 c2                	or     %eax,%edx
  803415:	89 d0                	mov    %edx,%eax
  803417:	89 f2                	mov    %esi,%edx
  803419:	f7 74 24 0c          	divl   0xc(%esp)
  80341d:	89 d6                	mov    %edx,%esi
  80341f:	89 c3                	mov    %eax,%ebx
  803421:	f7 e5                	mul    %ebp
  803423:	39 d6                	cmp    %edx,%esi
  803425:	72 19                	jb     803440 <__udivdi3+0xfc>
  803427:	74 0b                	je     803434 <__udivdi3+0xf0>
  803429:	89 d8                	mov    %ebx,%eax
  80342b:	31 ff                	xor    %edi,%edi
  80342d:	e9 58 ff ff ff       	jmp    80338a <__udivdi3+0x46>
  803432:	66 90                	xchg   %ax,%ax
  803434:	8b 54 24 08          	mov    0x8(%esp),%edx
  803438:	89 f9                	mov    %edi,%ecx
  80343a:	d3 e2                	shl    %cl,%edx
  80343c:	39 c2                	cmp    %eax,%edx
  80343e:	73 e9                	jae    803429 <__udivdi3+0xe5>
  803440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803443:	31 ff                	xor    %edi,%edi
  803445:	e9 40 ff ff ff       	jmp    80338a <__udivdi3+0x46>
  80344a:	66 90                	xchg   %ax,%ax
  80344c:	31 c0                	xor    %eax,%eax
  80344e:	e9 37 ff ff ff       	jmp    80338a <__udivdi3+0x46>
  803453:	90                   	nop

00803454 <__umoddi3>:
  803454:	55                   	push   %ebp
  803455:	57                   	push   %edi
  803456:	56                   	push   %esi
  803457:	53                   	push   %ebx
  803458:	83 ec 1c             	sub    $0x1c,%esp
  80345b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80345f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803467:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80346b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80346f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803473:	89 f3                	mov    %esi,%ebx
  803475:	89 fa                	mov    %edi,%edx
  803477:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80347b:	89 34 24             	mov    %esi,(%esp)
  80347e:	85 c0                	test   %eax,%eax
  803480:	75 1a                	jne    80349c <__umoddi3+0x48>
  803482:	39 f7                	cmp    %esi,%edi
  803484:	0f 86 a2 00 00 00    	jbe    80352c <__umoddi3+0xd8>
  80348a:	89 c8                	mov    %ecx,%eax
  80348c:	89 f2                	mov    %esi,%edx
  80348e:	f7 f7                	div    %edi
  803490:	89 d0                	mov    %edx,%eax
  803492:	31 d2                	xor    %edx,%edx
  803494:	83 c4 1c             	add    $0x1c,%esp
  803497:	5b                   	pop    %ebx
  803498:	5e                   	pop    %esi
  803499:	5f                   	pop    %edi
  80349a:	5d                   	pop    %ebp
  80349b:	c3                   	ret    
  80349c:	39 f0                	cmp    %esi,%eax
  80349e:	0f 87 ac 00 00 00    	ja     803550 <__umoddi3+0xfc>
  8034a4:	0f bd e8             	bsr    %eax,%ebp
  8034a7:	83 f5 1f             	xor    $0x1f,%ebp
  8034aa:	0f 84 ac 00 00 00    	je     80355c <__umoddi3+0x108>
  8034b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034b5:	29 ef                	sub    %ebp,%edi
  8034b7:	89 fe                	mov    %edi,%esi
  8034b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034bd:	89 e9                	mov    %ebp,%ecx
  8034bf:	d3 e0                	shl    %cl,%eax
  8034c1:	89 d7                	mov    %edx,%edi
  8034c3:	89 f1                	mov    %esi,%ecx
  8034c5:	d3 ef                	shr    %cl,%edi
  8034c7:	09 c7                	or     %eax,%edi
  8034c9:	89 e9                	mov    %ebp,%ecx
  8034cb:	d3 e2                	shl    %cl,%edx
  8034cd:	89 14 24             	mov    %edx,(%esp)
  8034d0:	89 d8                	mov    %ebx,%eax
  8034d2:	d3 e0                	shl    %cl,%eax
  8034d4:	89 c2                	mov    %eax,%edx
  8034d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034da:	d3 e0                	shl    %cl,%eax
  8034dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e4:	89 f1                	mov    %esi,%ecx
  8034e6:	d3 e8                	shr    %cl,%eax
  8034e8:	09 d0                	or     %edx,%eax
  8034ea:	d3 eb                	shr    %cl,%ebx
  8034ec:	89 da                	mov    %ebx,%edx
  8034ee:	f7 f7                	div    %edi
  8034f0:	89 d3                	mov    %edx,%ebx
  8034f2:	f7 24 24             	mull   (%esp)
  8034f5:	89 c6                	mov    %eax,%esi
  8034f7:	89 d1                	mov    %edx,%ecx
  8034f9:	39 d3                	cmp    %edx,%ebx
  8034fb:	0f 82 87 00 00 00    	jb     803588 <__umoddi3+0x134>
  803501:	0f 84 91 00 00 00    	je     803598 <__umoddi3+0x144>
  803507:	8b 54 24 04          	mov    0x4(%esp),%edx
  80350b:	29 f2                	sub    %esi,%edx
  80350d:	19 cb                	sbb    %ecx,%ebx
  80350f:	89 d8                	mov    %ebx,%eax
  803511:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803515:	d3 e0                	shl    %cl,%eax
  803517:	89 e9                	mov    %ebp,%ecx
  803519:	d3 ea                	shr    %cl,%edx
  80351b:	09 d0                	or     %edx,%eax
  80351d:	89 e9                	mov    %ebp,%ecx
  80351f:	d3 eb                	shr    %cl,%ebx
  803521:	89 da                	mov    %ebx,%edx
  803523:	83 c4 1c             	add    $0x1c,%esp
  803526:	5b                   	pop    %ebx
  803527:	5e                   	pop    %esi
  803528:	5f                   	pop    %edi
  803529:	5d                   	pop    %ebp
  80352a:	c3                   	ret    
  80352b:	90                   	nop
  80352c:	89 fd                	mov    %edi,%ebp
  80352e:	85 ff                	test   %edi,%edi
  803530:	75 0b                	jne    80353d <__umoddi3+0xe9>
  803532:	b8 01 00 00 00       	mov    $0x1,%eax
  803537:	31 d2                	xor    %edx,%edx
  803539:	f7 f7                	div    %edi
  80353b:	89 c5                	mov    %eax,%ebp
  80353d:	89 f0                	mov    %esi,%eax
  80353f:	31 d2                	xor    %edx,%edx
  803541:	f7 f5                	div    %ebp
  803543:	89 c8                	mov    %ecx,%eax
  803545:	f7 f5                	div    %ebp
  803547:	89 d0                	mov    %edx,%eax
  803549:	e9 44 ff ff ff       	jmp    803492 <__umoddi3+0x3e>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	89 c8                	mov    %ecx,%eax
  803552:	89 f2                	mov    %esi,%edx
  803554:	83 c4 1c             	add    $0x1c,%esp
  803557:	5b                   	pop    %ebx
  803558:	5e                   	pop    %esi
  803559:	5f                   	pop    %edi
  80355a:	5d                   	pop    %ebp
  80355b:	c3                   	ret    
  80355c:	3b 04 24             	cmp    (%esp),%eax
  80355f:	72 06                	jb     803567 <__umoddi3+0x113>
  803561:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803565:	77 0f                	ja     803576 <__umoddi3+0x122>
  803567:	89 f2                	mov    %esi,%edx
  803569:	29 f9                	sub    %edi,%ecx
  80356b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80356f:	89 14 24             	mov    %edx,(%esp)
  803572:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803576:	8b 44 24 04          	mov    0x4(%esp),%eax
  80357a:	8b 14 24             	mov    (%esp),%edx
  80357d:	83 c4 1c             	add    $0x1c,%esp
  803580:	5b                   	pop    %ebx
  803581:	5e                   	pop    %esi
  803582:	5f                   	pop    %edi
  803583:	5d                   	pop    %ebp
  803584:	c3                   	ret    
  803585:	8d 76 00             	lea    0x0(%esi),%esi
  803588:	2b 04 24             	sub    (%esp),%eax
  80358b:	19 fa                	sbb    %edi,%edx
  80358d:	89 d1                	mov    %edx,%ecx
  80358f:	89 c6                	mov    %eax,%esi
  803591:	e9 71 ff ff ff       	jmp    803507 <__umoddi3+0xb3>
  803596:	66 90                	xchg   %ax,%ax
  803598:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80359c:	72 ea                	jb     803588 <__umoddi3+0x134>
  80359e:	89 d9                	mov    %ebx,%ecx
  8035a0:	e9 62 ff ff ff       	jmp    803507 <__umoddi3+0xb3>
